package config

import "testing"

func TestPrepareSettingsDoesNotPublishUntilRequested(t *testing.T) {
	if err := Init(); err != nil {
		t.Fatal(err)
	}
	if err := LoadSettings(map[string]any{"JWTSecret": "test-private-signing-key-with-entropy"}); err != nil {
		t.Fatal(err)
	}
	before := Snapshot()
	candidate, err := PrepareSettings(map[string]any{
		"JWTSecret":           "another-private-signing-key-with-entropy",
		"PterodactylHostname": "https://panel.example/",
		"PterodactylToken":    "panel-token",
	})
	if err != nil {
		t.Fatal(err)
	}
	if Snapshot() != before || Snapshot().String("PterodactylToken") == "panel-token" {
		t.Fatal("preparing candidate changed the active configuration")
	}
	PublishSettings(candidate)
	after := Snapshot()
	if after == before || after.String("PterodactylHostname") != "https://panel.example" || after.String("PterodactylToken") != "panel-token" {
		t.Fatalf("published settings are not a normalized coherent snapshot: host=%q", after.String("PterodactylHostname"))
	}
}
