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
	rdb *managedClient
)

type managedClient struct {
	client  *redis.Client
	refs    int
	retired bool
	close   func() error
}

// client lazily creates the client, mirroring the legacy behaviour so that a
// Redis outage cannot stop the process from starting.
func newClient() *redis.Client {
	settings := config.Snapshot()
	return redis.NewClient(&redis.Options{
		Addr:         settings.RedisAddress(),
		DialTimeout:  3 * time.Second,
		ReadTimeout:  3 * time.Second,
		WriteTimeout: 3 * time.Second,
		PoolTimeout:  3 * time.Second,
		DB:           settings.Int("RedisDB"),
		Password:     settings.String("RedisPassword"),
	})
}

func acquire() (*redis.Client, func()) {
	mu.Lock()
	if rdb == nil {
		c := newClient()
		rdb = &managedClient{client: c, close: c.Close}
	}
	state := rdb
	state.refs++
	mu.Unlock()
	return state.client, func() { release(state) }
}

func release(state *managedClient) {
	mu.Lock()
	state.refs--
	closeClient := state.retired && state.refs == 0
	mu.Unlock()
	if closeClient && state.close != nil {
		_ = state.close()
	}
}

// Reset drops the client so the next call reconnects with fresh settings.
func Reset() {
	mu.Lock()
	old := rdb
	rdb = nil
	closeClient := false
	if old != nil {
		old.retired = true
		closeClient = old.refs == 0
	}
	mu.Unlock()
	if closeClient {
		_ = old.close()
	}
}

// Ping verifies connectivity; the admin settings page surfaces the result.
func Ping(ctx context.Context) error {
	ctx, cancel := context.WithTimeout(ctx, 3*time.Second)
	defer cancel()
	c, release := acquire()
	defer release()
	return c.Ping(ctx).Err()
}

// Limited reports whether the rate-limit key is still cooling down. It is the
// direct replacement for the legacy `Get(key).Err() == nil` idiom.
func Limited(ctx context.Context, key string) bool {
	c, release := acquire()
	defer release()
	n, err := c.Exists(ctx, key).Result()
	return err == nil && n > 0
}

// Revoked reports whether a token blacklist entry exists. Unlike Limited,
// lookup failures are returned because authentication must fail closed.
func Revoked(ctx context.Context, key string) (bool, error) {
	c, release := acquire()
	defer release()
	n, err := c.Exists(ctx, key).Result()
	if err != nil {
		return false, err
	}
	return n > 0, nil
}

// Limit sets the rate-limit key for the supplied window. Failures are ignored
// on purpose: a broken Redis must not take the whole endpoint down.
func Limit(ctx context.Context, key string, window time.Duration) {
	c, release := acquire()
	defer release()
	_ = c.Set(ctx, key, 1, window).Err()
}

// Release clears a rate-limit key early, used when an operation fails and the
// user should be allowed to retry immediately.
func Release(ctx context.Context, key string) {
	c, release := acquire()
	defer release()
	_ = c.Del(ctx, key).Err()
}

// Set stores a value with a TTL.
func Set(ctx context.Context, key, value string, ttl time.Duration) error {
	c, release := acquire()
	defer release()
	return c.Set(ctx, key, value, ttl).Err()
}

// Get returns the stored value and whether the key existed.
func Get(ctx context.Context, key string) (string, bool) {
	c, release := acquire()
	defer release()
	s, err := c.Get(ctx, key).Result()
	if err != nil {
		return "", false
	}
	return s, true
}

// Del removes keys.
func Del(ctx context.Context, keys ...string) {
	c, release := acquire()
	defer release()
	_ = c.Del(ctx, keys...).Err()
}
