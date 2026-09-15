package main

import (
	"context"
	"errors"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/minoic/glgf"
	"github.com/minoic/peo/server/internal/api"
	"github.com/minoic/peo/server/internal/config"
	"github.com/minoic/peo/server/internal/cron"
	"github.com/minoic/peo/server/internal/redis"
	"github.com/minoic/peo/server/internal/store"
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
	scheduler.Stop()
	store.Reset()
	redis.Reset()
}
