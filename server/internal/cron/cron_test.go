package cron

import (
	"context"
	"sync/atomic"
	"testing"
	"time"
)

func TestRunSkipsOverlappingJobAndRecoversPanic(t *testing.T) {
	m := New()
	started := make(chan struct{})
	finish := make(chan struct{})
	var runs atomic.Int32
	fn := func(ctx context.Context) { runs.Add(1); close(started); <-finish }
	go m.run("same", time.Second, fn)
	<-started
	m.run("same", time.Second, fn)
	close(finish)
	deadline := time.Now().Add(time.Second)
	for m.jobsRunning() && time.Now().Before(deadline) {
		time.Sleep(time.Millisecond)
	}
	if got := runs.Load(); got != 1 {
		t.Fatalf("overlap runs = %d, want 1", got)
	}
	m.run("panic", time.Second, func(context.Context) { panic("test") })
	if m.jobsRunning() {
		t.Fatal("panicking job left its running marker set")
	}
}

func (m *Manager) jobsRunning() bool {
	m.jobsMu.Lock()
	defer m.jobsMu.Unlock()
	return len(m.jobs) != 0
}

func TestRunContextInheritsShutdownCancellation(t *testing.T) {
	m := New()
	done := make(chan struct{})
	go func() { defer close(done); m.run("cancel", time.Minute, func(ctx context.Context) { <-ctx.Done() }) }()
	m.cancel()
	select {
	case <-done:
	case <-time.After(time.Second):
		t.Fatal("job context did not observe shutdown")
	}
}
