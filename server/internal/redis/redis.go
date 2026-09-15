// Package redis owns the shared Redis client.
//
// Redis is deliberately kept from the legacy implementation: it is used for
// short lived rate-limit keys, the password-reset codes and the JWT blacklist,
// not as a cache of authoritative data.
package redis

import (
	"context"
	"sync"
	"time"

	"github.com/minoic/peo/server/internal/config"
	"github.com/redis/go-redis/v9"
)

var (
	mu  sync.Mutex
	rdb *redis.Client
)

// client lazily creates the client, mirroring the legacy behaviour so that a
// Redis outage cannot stop the process from starting.
func client() *redis.Client {
	mu.Lock()
	defer mu.Unlock()
	if rdb == nil {
		rdb = redis.NewClient(&redis.Options{
			Addr:        config.String("RedisHost"),
			DialTimeout: 3 * time.Second,
			DB:          config.Int("RedisDB"),
			Password:    config.String("RedisPassword"),
		})
	}
	return rdb
}

// Client returns the shared Redis client.
func Client() *redis.Client { return client() }

// Reset drops the client so the next call reconnects with fresh settings.
func Reset() {
	mu.Lock()
	defer mu.Unlock()
	if rdb != nil {
		_ = rdb.Close()
	}
	rdb = nil
}

// Ping verifies connectivity; the admin settings page surfaces the result.
func Ping(ctx context.Context) error {
	ctx, cancel := context.WithTimeout(ctx, 3*time.Second)
	defer cancel()
	return client().Ping(ctx).Err()
}

// Limited reports whether the rate-limit key is still cooling down. It is the
// direct replacement for the legacy `Get(key).Err() == nil` idiom.
func Limited(ctx context.Context, key string) bool {
	n, err := client().Exists(ctx, key).Result()
	return err == nil && n > 0
}

// Limit sets the rate-limit key for the supplied window. Failures are ignored
// on purpose: a broken Redis must not take the whole endpoint down.
func Limit(ctx context.Context, key string, window time.Duration) {
	_ = client().Set(ctx, key, 1, window).Err()
}

// Release clears a rate-limit key early, used when an operation fails and the
// user should be allowed to retry immediately.
func Release(ctx context.Context, key string) {
	_ = client().Del(ctx, key).Err()
}

// Set stores a value with a TTL.
func Set(ctx context.Context, key, value string, ttl time.Duration) error {
	return client().Set(ctx, key, value, ttl).Err()
}

// Get returns the stored value and whether the key existed.
func Get(ctx context.Context, key string) (string, bool) {
	s, err := client().Get(ctx, key).Result()
	if err != nil {
		return "", false
	}
	return s, true
}

// Del removes keys.
func Del(ctx context.Context, keys ...string) {
	_ = client().Del(ctx, keys...).Err()
}
