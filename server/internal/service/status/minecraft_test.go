package status

import (
	"bytes"
	"context"
	"errors"
	"io"
	"net"
	"testing"
	"time"
)

func TestPingReturnsMalformedHostError(t *testing.T) {
	if _, err := Ping(context.Background(), "not-a-host-port"); err == nil {
		t.Fatal("expected malformed host error")
	}
}

func TestReadPongRejectsOversizedPacketBeforeAllocation(t *testing.T) {
	data := encodeVarint(maxStatusPacket + 1)
	if _, err := readPong(bytes.NewReader(data)); err == nil {
		t.Fatal("expected oversized packet error")
	}
}

func TestPingCancellationClosesSocketRead(t *testing.T) {
	listener, err := net.Listen("tcp", "127.0.0.1:0")
	if err != nil {
		t.Fatal(err)
	}
	defer listener.Close()
	accepted := make(chan struct{})
	go func() {
		conn, err := listener.Accept()
		if err != nil {
			return
		}
		defer conn.Close()
		close(accepted)
		_, _ = io.Copy(io.Discard, conn)
	}()
	ctx, cancel := context.WithCancel(context.Background())
	done := make(chan error, 1)
	go func() { _, err := Ping(ctx, listener.Addr().String()); done <- err }()
	select {
	case <-accepted:
	case <-time.After(time.Second):
		t.Fatal("probe did not connect")
	}
	cancel()
	select {
	case err := <-done:
		if !errors.Is(err, context.Canceled) {
			t.Fatalf("Ping error = %v, want context canceled", err)
		}
	case <-time.After(time.Second):
		t.Fatal("Ping did not stop after cancellation")
	}
}
