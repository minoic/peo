package service

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

func TestConcurrentSettingsSavesMergeAndFailedSaveDoesNotPublish(t *testing.T) {
	uri := strings.TrimSpace(os.Getenv("PEO_TEST_MONGO_URI"))
	if uri == "" {
		t.Skip("set PEO_TEST_MONGO_URI to run settings persistence integration test")
	}
	dbName := fmt.Sprintf("peo_settings_save_%d", time.Now().UnixNano())
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

	initial, err := config.DefaultSettings()
	if err != nil {
		t.Fatal(err)
	}
	initial["jwtsecret"] = "settings-test-secret-with-enough-entropy"
	if err := config.LoadSettings(initial); err != nil {
		t.Fatal(err)
	}
	if err := store.SaveAppSettings(context.Background(), config.Settings()); err != nil {
		t.Fatal(err)
	}

	var wg sync.WaitGroup
	for _, update := range []map[string]string{
		{"WebDescription": "description from concurrent save"},
		{"WebApplicationName": "application from concurrent save"},
	} {
		wg.Add(1)
		go func(update map[string]string) {
			defer wg.Done()
			if err := Admin.SaveSettings(context.Background(), update); err != nil {
				t.Errorf("SaveSettings: %v", err)
			}
		}(update)
	}
	wg.Wait()
	if got := config.String("WebDescription"); got != "description from concurrent save" {
		t.Fatalf("WebDescription=%q", got)
	}
	if got := config.String("WebApplicationName"); got != "application from concurrent save" {
		t.Fatalf("WebApplicationName=%q", got)
	}
	persisted, err := store.LoadAppSettings(context.Background())
	if err != nil {
		t.Fatal(err)
	}
	if persisted["webdescription"] != "description from concurrent save" || persisted["webapplicationname"] != "application from concurrent save" {
		t.Fatalf("persisted settings lost a concurrent update: %v", persisted)
	}

	before := config.Settings()
	canceled, cancel := context.WithCancel(context.Background())
	cancel()
	if err := Admin.SaveSettings(canceled, map[string]string{"WebDescription": "must not publish"}); err == nil {
		t.Fatal("SaveSettings succeeded with a canceled persistence context")
	}
	if got := config.String("WebDescription"); got != before["webdescription"] {
		t.Fatalf("failed persistence published %q, want %q", got, before["webdescription"])
	}
}
