package service

import (
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"sync/atomic"
	"testing"
	"time"

	"github.com/minoic/peo/server/internal/config"
)

func TestEggCacheIsPanelScopedAndRefreshes(t *testing.T) {
	if err := config.Init(); err != nil {
		t.Fatal(err)
	}
	var firstCalls, secondCalls atomic.Int32
	panel := func(name string, calls *atomic.Int32) *httptest.Server {
		return httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			calls.Add(1)
			w.Header().Set("Content-Type", "application/json")
			switch r.URL.Path {
			case "/api/application/tags":
				_, _ = w.Write([]byte(`{"data":[{"attributes":{"id":1,"name":"Shared","slug":"shared"}}],"meta":{"pagination":{"total_pages":1}}}`))
			case "/api/application/eggs":
				payload, _ := json.Marshal(map[string]any{"data": []any{map[string]any{"attributes": map[string]any{
					"id": 1, "name": name, "relationships": map[string]any{"tags": map[string]any{"data": []any{map[string]any{"attributes": map[string]any{"slug": "shared"}}}}},
				}}}, "meta": map[string]any{"pagination": map[string]any{"total_pages": 1}}})
				_, _ = w.Write(payload)
			default:
				http.NotFound(w, r)
			}
		}))
	}
	one := panel("Panel One Egg", &firstCalls)
	two := panel("Panel Two Egg", &secondCalls)
	defer one.Close()
	defer two.Close()

	service := &ProductService{}
	load := func(host, token string) {
		t.Helper()
		settings := config.Settings()
		settings["pterodactylhostname"] = host
		settings["pterodactyltoken"] = token
		if err := config.LoadSettings(settings); err != nil {
			t.Fatal(err)
		}
	}
	load(one.URL, "one")
	eggs, err := service.EggsForTag(context.Background(), "shared")
	if err != nil || len(eggs) != 1 || eggs[0].Name != "Panel One Egg" {
		t.Fatalf("first panel eggs=%v err=%v", eggs, err)
	}
	load(two.URL, "two")
	eggs, err = service.EggsForTag(context.Background(), "shared")
	if err != nil || len(eggs) != 1 || eggs[0].Name != "Panel Two Egg" {
		t.Fatalf("second panel reused another panel's cache: eggs=%v err=%v", eggs, err)
	}
	if firstCalls.Load() == 0 || secondCalls.Load() == 0 {
		t.Fatalf("expected both panels to be queried, calls=(%d,%d)", firstCalls.Load(), secondCalls.Load())
	}

	service.eggCache.Range(func(key, value any) bool {
		entry := value.(eggCacheEntry)
		entry.expires = time.Now().Add(-time.Second)
		service.eggCache.Store(key, entry)
		return true
	})
	before := secondCalls.Load()
	eggs, err = service.EggsForTag(context.Background(), "shared")
	if err != nil || len(eggs) != 1 || eggs[0].Name != "Panel Two Egg" || secondCalls.Load() <= before {
		t.Fatalf("expired cache was not refreshed: eggs=%v calls=%d->%d err=%v", eggs, before, secondCalls.Load(), err)
	}
}
