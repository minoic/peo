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

func TestPrepareSettingsRedisAddrEnvironmentOverride(t *testing.T) {
	t.Setenv(RedisAddrEnv, " redis:6379 ")
	if err := Init(); err != nil {
		t.Fatal(err)
	}
	if got := Snapshot().RedisAddress(); got != "redis:6379" {
		t.Fatalf("initial RedisAddress() = %q, want environment override", got)
	}
	candidate, err := PrepareSettings(map[string]any{
		"RedisHost":     "127.0.0.1:6379",
		"RedisPassword": "redis-password",
		"RedisDB":       4,
	})
	if err != nil {
		t.Fatal(err)
	}
	if got := candidate.RedisAddress(); got != "redis:6379" {
		t.Fatalf("RedisAddress() = %q, want environment override", got)
	}
	if got := candidate.Values()["redishost"]; got != "127.0.0.1:6379" {
		t.Fatalf("persisted RedisHost = %v, want original business setting", got)
	}
	if got := candidate.String("RedisPassword"); got != "redis-password" {
		t.Fatalf("RedisPassword = %q, want business setting", got)
	}
	if got := candidate.Int("RedisDB"); got != 4 {
		t.Fatalf("RedisDB = %d, want business setting", got)
	}

	// Admin settings saves candidate.Values(); preparing from those values must
	// continue using the deployment override without persisting it.
	savedCandidate, err := PrepareSettings(candidate.Values())
	if err != nil {
		t.Fatal(err)
	}
	if got := savedCandidate.RedisAddress(); got != "redis:6379" {
		t.Fatalf("RedisAddress() after settings save = %q, want environment override", got)
	}
	if got := savedCandidate.Values()["redishost"]; got != "127.0.0.1:6379" {
		t.Fatalf("persisted RedisHost after settings save = %v, want original business setting", got)
	}
}

func TestPrepareSettingsRedisAddrEmptyUsesStoredHost(t *testing.T) {
	t.Setenv(RedisAddrEnv, "  ")
	if err := Init(); err != nil {
		t.Fatal(err)
	}
	candidate, err := PrepareSettings(map[string]any{"RedisHost": "cache.internal:6379"})
	if err != nil {
		t.Fatal(err)
	}
	if got := candidate.RedisAddress(); got != "cache.internal:6379" {
		t.Fatalf("RedisAddress() = %q, want stored RedisHost", got)
	}
}
