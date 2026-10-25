package redis

import (
	"testing"

	"github.com/redis/go-redis/v9"
)

func TestResetDefersClosingAnInFlightClient(t *testing.T) {
	Reset()
	c := redis.NewClient(&redis.Options{Addr: "127.0.0.1:6379"})
	closed := false
	state := &managedClient{client: c, close: func() error {
		closed = true
		return c.Close()
	}}
	mu.Lock()
	rdb = state
	mu.Unlock()

	_, release := acquire()
	Reset()
	if !state.retired || closed {
		t.Fatal("Reset closed a client while an operation still held it")
	}
	release()
	if !closed {
		t.Fatal("retired client was not closed after its final operation released it")
	}
}
