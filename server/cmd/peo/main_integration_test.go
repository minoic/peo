package main

import (
	"context"
	"fmt"
	"os"
	"strings"
	"sync"
	"testing"
	"time"

	"github.com/minoic/peo/server/internal/config"
	"github.com/minoic/peo/server/internal/store"
)

func TestConcurrentJWTSecretRotationConvergesOnPersistedWinner(t *testing.T) {
	uri := strings.TrimSpace(os.Getenv("PEO_TEST_MONGO_URI"))
	if uri == "" {
		t.Skip("set PEO_TEST_MONGO_URI to run MongoDB startup-settings concurrency test")
	}
	dbName := fmt.Sprintf("peo_jwt_startup_%d", time.Now().UnixNano())
	t.Setenv(config.MongoURIEnv, uri)
	t.Setenv(config.MongoDBEnv, dbName)
	if err := config.Init(); err != nil {
		t.Fatal(err)
	}
	if err := store.Init(); err != nil {
		t.Fatal(err)
	}
	db := store.DB()
	t.Cleanup(func() {
		ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
		defer cancel()
		_ = db.Drop(ctx)
		store.Reset()
	})

	ctx := context.Background()
	if err := store.SaveAppSettings(ctx, map[string]any{"jwtsecret": ""}); err != nil {
		t.Fatal(err)
	}
	settings, err := store.LoadAppSettings(ctx)
	if err != nil {
		t.Fatal(err)
	}

	const starters = 12
	var wg sync.WaitGroup
	errCh := make(chan error, starters)
	for i := 0; i < starters; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			if err := rotateJWTSecret(settings); err != nil {
				errCh <- err
			}
		}()
	}
	wg.Wait()
	close(errCh)
	for err := range errCh {
		t.Fatal(err)
	}

	winner, err := store.LoadAppSettings(ctx)
	if err != nil {
		t.Fatal(err)
	}
	if config.NeedsJWTSecretRotation(winner) {
		t.Fatalf("persisted startup settings have no usable JWT key: %v", winner["jwtsecret"])
	}
	if err := config.LoadSettings(winner); err != nil {
		t.Fatal(err)
	}
	if got := config.String("JWTSecret"); got != winner["jwtsecret"] {
		t.Fatalf("active key %q differs from persisted winner %v", got, winner["jwtsecret"])
	}
}
