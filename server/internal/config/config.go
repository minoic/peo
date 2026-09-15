package config

import (
	_ "embed"
	"errors"
	"os"
	"path"
	"strings"
	"sync"

	"github.com/minoic/glgf"
	"github.com/smartwalle/alipay/v3"
	"github.com/spf13/viper"
)

//go:embed default_settings.toml
var defaultSettingsToml []byte

var (
	mu        sync.RWMutex
	v         *viper.Viper
	aliClient *alipay.Client
)

// SettingsFile is the path of the business configuration file.
const SettingsFile = "conf/settings.toml"

// Init loads (or generates) the configuration file, wires up the Alipay client
// and returns an error if the process must be restarted because a default file
// has just been written.
func Init() error {
	if _, err := os.Stat("conf"); errors.Is(err, os.ErrNotExist) {
		if err := os.MkdirAll("conf", os.ModePerm); err != nil {
			return err
		}
	}
	if _, err := os.Stat(SettingsFile); errors.Is(err, os.ErrNotExist) {
		glgf.Warn("Config file not found, generating " + SettingsFile)
		if err := os.WriteFile(SettingsFile, defaultSettingsToml, 0o644); err != nil {
			return err
		}
	}
	return Reload()
}

// Reload re-reads the configuration file from disk and rebuilds derived
// clients. It is safe to call at runtime after settings have been saved.
func Reload() error {
	fresh := viper.New()
	fresh.SetConfigType("toml")
	fresh.SetConfigFile(SettingsFile)
	if err := fresh.ReadInConfig(); err != nil {
		return err
	}
	// Trailing slashes break URL concatenation in the Pterodactyl client and
	// the Frontend redirect helper.
	fresh.Set("WebHostName", strings.TrimRight(fresh.GetString("WebHostName"), "/"))
	fresh.Set("PterodactylHostname", strings.TrimRight(fresh.GetString("PterodactylHostname"), "/"))
	if err := fresh.WriteConfig(); err != nil {
		return err
	}

	var client *alipay.Client
	if fresh.GetBool("AliPayEnabled") {
		var err error
		client, err = alipay.New(fresh.GetString("AliPayAppID"), fresh.GetString("AliPayPrivateKey"), true)
		if err != nil {
			return err
		}
		if err := client.LoadAliPayPublicKey(fresh.GetString("AliPayPublicKey")); err != nil {
			return err
		}
	}

	mu.Lock()
	v = fresh
	aliClient = client
	mu.Unlock()
	return nil
}

// Viper returns the currently loaded configuration.
func Viper() *viper.Viper {
	mu.RLock()
	defer mu.RUnlock()
	return v
}

// String returns a string setting.
func String(key string) string { return Viper().GetString(key) }

// Bool returns a boolean setting.
func Bool(key string) bool { return Viper().GetBool(key) }

// Int returns an int setting.
func Int(key string) int { return Viper().GetInt(key) }

// AliClient returns the configured Alipay client, or nil when recharge via
// Alipay is disabled.
func AliClient() *alipay.Client {
	mu.RLock()
	defer mu.RUnlock()
	return aliClient
}

// Set stores a setting in memory. Call Save to persist.
func Set(key string, value interface{}) {
	mu.RLock()
	cfg := v
	mu.RUnlock()
	cfg.Set(key, value)
}

// Save writes the in-memory configuration back to disk.
func Save() error {
	mu.RLock()
	cfg := v
	mu.RUnlock()
	if err := cfg.WriteConfig(); err != nil {
		return err
	}
	return Reload()
}

// SiteSubdomain returns the cookie scope used to hand the Pterodactyl session
// over to the panel (everything after the first dot of WebHostName).
func SiteSubdomain() string {
	_, after, _ := strings.Cut(String("WebHostName"), ".")
	return "." + after
}

// Path joins path elements relative to the process working directory.
func Path(elem ...string) string { return path.Join(elem...) }
