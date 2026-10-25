package service

import (
	"testing"

	"github.com/minoic/peo/server/internal/config"
)

func TestPanelTokenSettingIsWriteOnlyAndBlankPreservesValue(t *testing.T) {
	fields := settingFields(func(key string) string {
		if key == "PterodactylToken" {
			return "secret-token"
		}
		return "configured-value"
	})
	var token SettingField
	for _, field := range fields {
		if field.Key == "PterodactylToken" {
			token = field
			break
		}
	}
	if token.Value != "" || !token.Secret || !token.Configured {
		t.Fatalf("Panel token setting = %+v, want blank write-only configured field", token)
	}
	if !preserveBlankSecret("PterodactylToken", " \t") || !preserveBlankSecret("pterodactyltoken", "") {
		t.Fatal("blank Panel token submission would overwrite the configured token")
	}
	if preserveBlankSecret("PterodactylToken", "new-token") || preserveBlankSecret("OtherSecret", "") {
		t.Fatal("non-empty replacement or unrelated setting was incorrectly preserved")
	}
}

func TestSettingsUpdatesUseCanonicalKeys(t *testing.T) {
	if err := config.Init(); err != nil {
		t.Fatalf("Init() error = %v", err)
	}
	previous := config.Settings()
	t.Cleanup(func() { _ = config.LoadSettings(previous) })

	settings := map[string]any{
		"pterodactylhostname": "https://remote.example",
		"PterodactylHostname": "https://stale.example",
		"PterodactylToken":    "stale-token",
		"UnrelatedSetting":    "preserved",
	}
	setSettingValue(settings, "PterodactylHostname", "http://localhost:8088")
	setSettingValue(settings, "PterodactylToken", "local-token")
	setSettingValue(settings, "ConsoleOrigins", "http://localhost:5173")

	if len(settings) != 4 || settings["pterodactylhostname"] != "http://localhost:8088" || settings["pterodactyltoken"] != "local-token" {
		t.Fatalf("settings were not canonicalized without retaining stale variants: %#v", settings)
	}
	if _, exists := settings["PterodactylHostname"]; exists {
		t.Fatal("duplicate PascalCase Panel hostname remains in the settings map")
	}
	if settings["UnrelatedSetting"] != "preserved" {
		t.Fatal("updating known settings discarded an unrelated setting")
	}
	if err := config.LoadSettings(settings); err != nil {
		t.Fatalf("LoadSettings() error = %v", err)
	}
	if got := config.String("PterodactylHostname"); got != "http://localhost:8088" {
		t.Fatalf("Panel hostname = %q, want local test Panel", got)
	}
}
