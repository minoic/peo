package main

import (
	"context"
	"errors"
	"net/http"
	"os"
	"os/signal"
	"strings"
	"syscall"
	"time"

	"github.com/minoic/glgf"
	"github.com/minoic/peo/server/internal/api"
	"github.com/minoic/peo/server/internal/config"
	"github.com/minoic/peo/server/internal/cron"
	"github.com/minoic/peo/server/internal/redis"
	"github.com/minoic/peo/server/internal/store"
	"go.mongodb.org/mongo-driver/v2/mongo"
)

func main() {
	if err := config.Init(); err != nil {
		glgf.Error("config init failed: ", err)
		os.Exit(1)
	}
	if err := store.Init(); err != nil {
		glgf.Error("mongo init failed: ", err)
		os.Exit(1)
	}
	settingsCtx, cancelSettings := context.WithTimeout(context.Background(), 10*time.Second)
	settings, err := store.LoadAppSettings(settingsCtx)
	seedSettings := false
	if errors.Is(err, store.ErrSettingsNotFound) {
		seedSettings = true
		settings, err = config.DefaultSettings()
		if err == nil {
			var legacyFound bool
			var legacySettings map[string]any
			legacySettings, legacyFound, err = config.LegacySettings()
			if err == nil && legacyFound {
				for key, value := range legacySettings {
					settings[key] = value
				}
				glgf.Warn("importing legacy business settings from conf/settings.toml")
			}
		}
	}
	if err == nil && seedSettings {
		if config.NeedsJWTSecretRotation(settings) {
			var secret string
			secret, err = config.NewJWTSecret()
			if err == nil {
				settings["jwtsecret"] = secret
			}
		}
		if err == nil {
			cancelSettings()
			settingsCtx, cancelSettings = context.WithTimeout(context.Background(), 10*time.Second)
			err = store.CreateAppSettings(settingsCtx, settings)
			cancelSettings()
			if err == nil || mongo.IsDuplicateKeyError(err) {
				err = nil
			}
		}
		if err == nil {
			settingsCtx, cancelSettings = context.WithTimeout(context.Background(), 10*time.Second)
			settings, err = store.LoadAppSettings(settingsCtx)
			cancelSettings()
		}
	}
	cancelSettings()
	if err != nil {
		glgf.Error("settings load failed: ", err)
		store.Reset()
		os.Exit(1)
	}
	if err := config.LoadSettings(settings); err != nil {
		glgf.Error("settings load failed: ", err)
		store.Reset()
		os.Exit(1)
	}
	if config.NeedsJWTSecretRotation(settings) {
		glgf.Warn("rotating unsafe JWT signing key; existing bearer tokens will no longer validate")
		if err := rotateJWTSecret(settings); err != nil {
			glgf.Error("JWT secret initialization failed: ", err)
			store.Reset()
			os.Exit(1)
		}
		settingsCtx, cancelSettings = context.WithTimeout(context.Background(), 10*time.Second)
		settings, err = store.LoadAppSettings(settingsCtx)
		cancelSettings()
		if err != nil {
			glgf.Error("settings reload failed: ", err)
			store.Reset()
			os.Exit(1)
		}
		if err := config.LoadSettings(settings); err != nil {
			glgf.Error("settings load failed: ", err)
			store.Reset()
			os.Exit(1)
		}
	}
	bootstrapCtx, cancelBootstrap := context.WithTimeout(context.Background(), 10*time.Second)
	if err := store.EnsureBootstrapAdmin(bootstrapCtx); err != nil {
		cancelBootstrap()
		glgf.Error("admin bootstrap recovery failed: ", err)
		store.Reset()
		os.Exit(1)
	}
	cancelBootstrap()

	scheduler := cron.New()
	if err := scheduler.Register(); err != nil {
		glgf.Error("cron register failed: ", err)
		os.Exit(1)
	}
	scheduler.Bootstrap()
	scheduler.Start()

	router := api.Router()
	server := &http.Server{
		Addr:           ":8080",
		Handler:        router,
		ReadTimeout:    10 * time.Second,
		WriteTimeout:   20 * time.Second,
		IdleTimeout:    30 * time.Second,
		MaxHeaderBytes: 1 << 20,
	}

	go func() {
		if err := server.ListenAndServe(); err != nil && !errors.Is(err, http.ErrServerClosed) {
			glgf.Error("http server failed: ", err)
			os.Exit(1)
		}
	}()

	quit := make(chan os.Signal, 1)
	signal.Notify(quit, os.Interrupt, syscall.SIGTERM)
	<-quit

	glgf.Info("shutdown requested: stopping http server and scheduler")
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	if err := server.Shutdown(ctx); err != nil {
		glgf.Error("http shutdown error: ", err)
	}
	if scheduler.Stop() {
		store.Reset()
		redis.Reset()
	} else {
		glgf.Warn("shutdown: maintenance work did not stop; leaving dependency connections open until process exit")
	}
}

func rotateJWTSecret(settings map[string]any) error {
	field := "jwtsecret"
	var current any
	exists := false
	for key, value := range settings {
		if strings.EqualFold(key, "JWTSecret") {
			field, current, exists = key, value, true
			break
		}
	}
	next, err := config.NewJWTSecret()
	if err != nil {
		return err
	}
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	_, err = store.ReplaceAppSettingIfCurrent(ctx, field, current, exists, next)
	return err
}
