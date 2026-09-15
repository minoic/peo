// Package cron schedules the recurring maintenance jobs of the panel.
//
// The legacy deployment ran a single Beego process whose controllers held the
// caches in package level variables and whose cron jobs reached into those
// variables directly. Here every job talks to a service, so the caches are only
// ever mutated through the type that owns them.
package cron

import (
	"context"
	"sync"
	"time"

	"github.com/minoic/glgf"
	"github.com/minoic/peo/server/internal/service"
	"github.com/minoic/peo/server/internal/service/cryptoo"
	"github.com/minoic/peo/server/internal/service/pterodactyl"
	"github.com/robfig/cron/v3"
)

// Job timeouts. Every job runs on its own context so one slow dependency cannot
// hold the scheduler open, and so a shutdown can cancel in-flight work.
const (
	storefrontTimeout  = 2 * time.Minute
	serverCheckTimeout = 10 * time.Minute
	keyCleanupTimeout  = 5 * time.Minute
	probeTimeout       = 2 * time.Minute
)

// probeInterval is both the schedule of the server sweep and the amount of
// uptime credited to an online server per sweep, matching the legacy 30 second
// counter.
const probeInterval = 30 * time.Second

// Manager owns the scheduler and the shutdown gate for the jobs it started.
type Manager struct {
	cron *cron.Cron
	wg   sync.WaitGroup
	once sync.Once
}

// New builds a scheduler with the standard job set registered but not started.
func New() *Manager {
	return &Manager{
		cron: cron.New(cron.WithChain(
			cron.Recover(glgfCronLogger{}),
			cron.SkipIfStillRunning(glgfCronLogger{}),
		)),
	}
}

// glgfCronLogger routes cron's own diagnostics into the application log.
type glgfCronLogger struct{}

func (glgfCronLogger) Info(msg string, keysAndValues ...interface{}) {
	glgf.Info(append([]interface{}{"cron: ", msg, " "}, keysAndValues...)...)
}

func (glgfCronLogger) Error(err error, msg string, keysAndValues ...interface{}) {
	glgf.Error(append([]interface{}{"cron: ", msg, " ", err, " "}, keysAndValues...)...)
}

// Register installs every recurring job. The initial cache warm-up is triggered
// separately by Bootstrap so a slow panel cannot delay the first request.
func (m *Manager) Register() error {
	jobs := []struct {
		spec string
		fn   func()
	}{
		{"@every 1m", func() { m.withContext(storefrontTimeout, m.refreshStorefront) }},
		{"@every 5m", func() { m.withContext(storefrontTimeout, m.cacheEggs) }},
		{"@every 5m", func() { m.withContext(serverCheckTimeout, m.checkServers) }},
		{"@every 30m", func() { m.withContext(keyCleanupTimeout, m.deleteOutdatedKeys) }},
		{"@every 30s", func() { m.withContext(probeTimeout, m.probeServers) }},
	}
	for _, job := range jobs {
		if _, err := m.cron.AddFunc(job.spec, job.fn); err != nil {
			return err
		}
	}
	return nil
}

// Start begins scheduling. Registered jobs run on their own goroutines and are
// awaited by Stop.
func (m *Manager) Start() {
	m.cron.Start()
	glgf.Info("cron: scheduler started")
}

// Stop halts the scheduler and waits for running jobs to finish so a shutdown
// does not abandon a half-written database operation.
func (m *Manager) Stop() {
	m.once.Do(func() {
		ctx := m.cron.Stop()
		select {
		case <-ctx.Done():
		case <-time.After(30 * time.Second):
			glgf.Warn("cron: jobs did not finish within the shutdown grace period")
		}
		m.wg.Wait()
		glgf.Info("cron: scheduler stopped")
	})
}

// Bootstrap performs the startup warm-up that the legacy process did before
// serving traffic: fill the storefront cache and pre-load the server templates.
func (m *Manager) Bootstrap() {
	m.withContext(storefrontTimeout, func(ctx context.Context) {
		service.Products.Refresh(ctx)
	})
	m.withContext(storefrontTimeout, m.cacheEggs)
}

// withContext runs a job on a fresh context and tracks it for the shutdown gate.
func (m *Manager) withContext(timeout time.Duration, fn func(context.Context)) {
	m.wg.Add(1)
	go func() {
		defer m.wg.Done()
		ctx, cancel := context.WithTimeout(context.Background(), timeout)
		defer cancel()
		fn(ctx)
	}()
}

// refreshStorefront rebuilds the cached product list.
func (m *Manager) refreshStorefront(ctx context.Context) {
	service.Products.Refresh(ctx)
}

// cacheEggs pre-loads the panel templates of every nest a product uses.
func (m *Manager) cacheEggs(ctx context.Context) {
	service.Products.CacheEggs(ctx)
}

// checkServers suspends expired servers and advances the deletion workflow.
func (m *Manager) checkServers(ctx context.Context) {
	pterodactyl.CheckServers(ctx)
}

// deleteOutdatedKeys removes expired activation and recharge codes.
func (m *Manager) deleteOutdatedKeys(ctx context.Context) {
	cryptoo.DeleteOutdatedKeys(ctx)
}

// probeServers refreshes the Minecraft status of every server and credits the
// owners of the reachable ones.
func (m *Manager) probeServers(ctx context.Context) {
	service.Servers.ProbeAll(ctx, probeInterval)
}
