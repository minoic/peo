package config

import (
	"crypto/rand"
	_ "embed"
	"encoding/hex"
	"errors"
	"os"
	"path"
	"strings"
	"sync"

	"github.com/smartwalle/alipay/v3"
	"github.com/spf13/viper"
)

//go:embed default_settings.toml
var defaultSettingsToml []byte

const (
	// SettingsFile is read only to import settings from installations that used
	// the old TOML-based configuration. New settings are persisted in MongoDB.
	SettingsFile = "conf/settings.toml"
	MongoURIEnv  = "PEO_MONGO_URI"
	MongoDBEnv   = "PEO_MONGO_DATABASE_NAME"
	RedisAddrEnv = "PEO_REDIS_ADDR"
)

const legacyJWTSecret = "xiCI^gi0!HE1kKZO6*W6k&SPS3$6jufiu*0T7$t!jUktm@#o"

// NeedsJWTSecretRotation reports whether settings still contain a known public
// signing key or no key at all.
func NeedsJWTSecretRotation(settings map[string]any) bool {
	for key, value := range settings {
		if strings.EqualFold(key, "JWTSecret") {
			secret, _ := value.(string)
			secret = strings.TrimSpace(secret)
			return len(secret) < 32 || secret == legacyJWTSecret
		}
	}
	return true
}

var (
	mu                sync.RWMutex
	v                 *viper.Viper
	aliClient         *alipay.Client
	active            *SettingsSnapshot
	mongoURI          string
	mongoDatabaseName string
)

// Init loads embedded business defaults and the MongoDB connection settings
// from the environment. Business settings are replaced after store.Init reads
// them from MongoDB.
func Init() error {
	defaults, err := defaultViper()
	if err != nil {
		return err
	}
	uri := strings.TrimSpace(os.Getenv(MongoURIEnv))
	if uri == "" {
		uri = "mongodb://localhost:27017"
	}
	databaseName := strings.TrimSpace(os.Getenv(MongoDBEnv))
	if databaseName == "" {
		databaseName = "peo"
	}
	redisAddr := strings.TrimSpace(os.Getenv(RedisAddrEnv))
	mu.Lock()
	v = defaults
	aliClient = nil
	active = &SettingsSnapshot{values: defaults, redisAddr: redisAddr}
	mongoURI = uri
	mongoDatabaseName = databaseName
	mu.Unlock()
	return nil
}

// MongoURI returns the connection string supplied by PEO_MONGO_URI.
func MongoURI() string {
	mu.RLock()
	defer mu.RUnlock()
	return mongoURI
}

// MongoDatabaseName returns the database supplied by
// PEO_MONGO_DATABASE_NAME.
func MongoDatabaseName() string {
	mu.RLock()
	defer mu.RUnlock()
	return mongoDatabaseName
}

// DefaultSettings returns the embedded business settings used to initialize a
// fresh database.
func DefaultSettings() (map[string]any, error) {
	defaults, err := defaultViper()
	if err != nil {
		return nil, err
	}
	return defaults.AllSettings(), nil
}

// LegacySettings reads the old settings file for a one-time migration. MongoDB
// connection settings are deliberately ignored: the environment is their only
// source of truth. A missing file is not an error.
func LegacySettings() (settings map[string]any, found bool, err error) {
	if _, err := os.Stat(SettingsFile); errors.Is(err, os.ErrNotExist) {
		return nil, false, nil
	} else if err != nil {
		return nil, false, err
	}

	legacy := viper.New()
	legacy.SetConfigType("toml")
	legacy.SetConfigFile(SettingsFile)
	if err := legacy.ReadInConfig(); err != nil {
		return nil, false, err
	}
	settings = legacy.AllSettings()
	delete(settings, "mongouri")
	delete(settings, "mongodatabasename")
	return settings, true, nil
}

// LoadSettings replaces business settings with values loaded from MongoDB.
// Missing keys inherit the embedded defaults, and MongoDB connection keys are
// never accepted from the document.
func LoadSettings(settings map[string]any) error {
	snapshot, err := PrepareSettings(settings)
	if err != nil {
		return err
	}
	PublishSettings(snapshot)
	return nil
}

// SettingsSnapshot is a validated, immutable configuration candidate. Build it
// before persisting settings so a failed validation cannot partially publish.
type SettingsSnapshot struct {
	values    *viper.Viper
	ali       *alipay.Client
	redisAddr string
}

// PrepareSettings validates settings and constructs dependent clients without
// changing the active configuration.
func PrepareSettings(settings map[string]any) (*SettingsSnapshot, error) {
	fresh, err := defaultViper()
	if err != nil {
		return nil, err
	}
	for key, value := range settings {
		key = strings.ToLower(key)
		if key == "mongouri" || key == "mongodatabasename" {
			continue
		}
		fresh.Set(key, value)
	}
	// Redis can have different network addresses from the host and a container.
	// Keep this deployment-only value separate from persisted business settings.
	redisAddr := strings.TrimSpace(os.Getenv(RedisAddrEnv))

	// Trailing slashes break URL concatenation in the Pterodactyl client and
	// the frontend redirect helper.
	fresh.Set("WebHostName", strings.TrimRight(fresh.GetString("WebHostName"), "/"))
	fresh.Set("PterodactylHostname", strings.TrimRight(fresh.GetString("PterodactylHostname"), "/"))

	var client *alipay.Client
	if fresh.GetBool("AliPayEnabled") {
		client, err = alipay.New(fresh.GetString("AliPayAppID"), fresh.GetString("AliPayPrivateKey"), true)
		if err != nil {
			return nil, err
		}
		if err := client.LoadAliPayPublicKey(fresh.GetString("AliPayPublicKey")); err != nil {
			return nil, err
		}
	}

	return &SettingsSnapshot{values: fresh, ali: client, redisAddr: redisAddr}, nil
}

// PublishSettings atomically replaces the active settings and dependent client.
func PublishSettings(snapshot *SettingsSnapshot) {
	if snapshot == nil || snapshot.values == nil {
		return
	}
	mu.Lock()
	v = snapshot.values
	aliClient = snapshot.ali
	active = snapshot
	mu.Unlock()
}

// Snapshot returns the currently active immutable settings set.
func Snapshot() *SettingsSnapshot {
	mu.RLock()
	defer mu.RUnlock()
	return active
}

func (s *SettingsSnapshot) String(key string) string  { return s.values.GetString(key) }
func (s *SettingsSnapshot) Int(key string) int        { return s.values.GetInt(key) }
func (s *SettingsSnapshot) AliClient() *alipay.Client { return s.ali }
func (s *SettingsSnapshot) Values() map[string]any    { return s.values.AllSettings() }

// RedisAddress returns the deployment override when set, otherwise the stored
// RedisHost business setting.
func (s *SettingsSnapshot) RedisAddress() string {
	if s.redisAddr != "" {
		return s.redisAddr
	}
	return s.values.GetString("RedisHost")
}

// NewJWTSecret returns a fresh 256-bit key encoded as hex.
func NewJWTSecret() (string, error) {
	key := make([]byte, 32)
	if _, err := rand.Read(key); err != nil {
		return "", err
	}
	return hex.EncodeToString(key), nil
}

func defaultViper() (*viper.Viper, error) {
	fresh := viper.New()
	fresh.SetConfigType("toml")
	if err := fresh.ReadConfig(strings.NewReader(string(defaultSettingsToml))); err != nil {
		return nil, err
	}
	return fresh, nil
}

// Viper returns the currently loaded configuration.
func Viper() *viper.Viper {
	mu.RLock()
	defer mu.RUnlock()
	copy := viper.New()
	for key, value := range v.AllSettings() {
		copy.Set(key, value)
	}
	return copy
}

// String returns a string setting.
func String(key string) string { return Snapshot().String(key) }

// Bool returns a boolean setting.
func Bool(key string) bool {
	mu.RLock()
	current := v
	mu.RUnlock()
	return current.GetBool(key)
}

// Int returns an int setting.
func Int(key string) int { return Snapshot().Int(key) }

// Settings returns a copy of the currently loaded business settings.
func Settings() map[string]any { return Snapshot().Values() }

// AliClient returns the configured Alipay client, or nil when recharge via
// Alipay is disabled.
func AliClient() *alipay.Client { return Snapshot().AliClient() }

// SiteSubdomain returns the cookie scope used to hand the Pterodactyl session
// over to the panel (everything after the first dot of WebHostName).
func SiteSubdomain() string {
	_, after, _ := strings.Cut(String("WebHostName"), ".")
	return "." + after
}

// Path joins path elements relative to the process working directory.
func Path(elem ...string) string { return path.Join(elem...) }
