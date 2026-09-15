package service

import (
	"sync"
	"time"
)

// Cache is the process-wide in-memory cache. The split of responsibility is the
// point: request handlers only ever read from it, the cron is the only writer,
// and both go through the mutex.
//
// The legacy controllers kept the same kind of data in bare package variables
// that request handlers also wrote to, so two concurrent requests could rebuild
// the same map at the same time. Making the cache an object guarded by a mutex
// removes that race without changing what is cached or how long it lives.
type Cache struct {
	mu sync.RWMutex
	// probes holds the latest Minecraft answer per host name.
	probes map[string]probeResult
}

// NewCache returns an empty cache ready to use.
func NewCache() *Cache {
	return &Cache{probes: map[string]probeResult{}}
}

// probeFor returns the cached answer for host. The second result is false when
// there is no answer or it has aged out, which is what lets the console tell
// "not asked yet" apart from "offline".
func (c *Cache) probeFor(host string) (probeResult, bool) {
	if c == nil {
		return probeResult{}, false
	}
	c.mu.RLock()
	defer c.mu.RUnlock()
	pr, ok := c.probes[host]
	if !ok || time.Since(pr.At) > probeCacheTTL {
		return probeResult{}, false
	}
	return pr, true
}

// putProbe records the latest answer for host.
func (c *Cache) putProbe(host string, pr probeResult) {
	if c == nil {
		return
	}
	c.mu.Lock()
	defer c.mu.Unlock()
	if c.probes == nil {
		c.probes = make(map[string]probeResult)
	}
	c.probes[host] = pr
}
