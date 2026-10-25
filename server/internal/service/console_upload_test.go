package service

import (
	"bytes"
	"context"
	"errors"
	"fmt"
	"io"
	"net/http"
	"net/http/httptest"
	"strings"
	"sync"
	"testing"
	"time"

	"github.com/minoic/peo/server/internal/service/pterodactyl"
)

func TestCopyUploadLimitAcceptsBoundaryAndRejectsUnknownLengthOversize(t *testing.T) {
	var dst bytes.Buffer
	n, err := copyUploadLimit(&dst, bytes.NewBufferString("12345"), 5)
	if err != nil || n != 5 || dst.String() != "12345" {
		t.Fatalf("boundary copy = (%d, %q, %v)", n, dst.String(), err)
	}

	dst.Reset()
	n, err = copyUploadLimit(&dst, bytes.NewBufferString("123456789"), 5)
	if !errors.Is(err, errUploadTooLarge) || n != 6 || dst.String() != "123456" {
		t.Fatalf("oversize copy = (%d, %q, %v), want limit+1 detection", n, dst.String(), err)
	}
}

func TestUploadFileStreamRealTransport(t *testing.T) {
	tests := []struct {
		name       string
		body       string
		limit      int64
		readBody   bool
		wantErr    bool
		wantTooBig bool
	}{
		{name: "unknown length ordinary upload", body: "hello", limit: 5, readBody: true},
		{name: "unknown length overflow", body: "123456", limit: 5, readBody: true, wantErr: true, wantTooBig: true},
		{name: "early success response", body: strings.Repeat("x", 1<<20), limit: 2 << 20, wantErr: true},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
				if r.Method != http.MethodPost || !strings.Contains(r.Header.Get("Content-Type"), "multipart/form-data") {
					t.Errorf("request = %s %s content-type=%q", r.Method, r.URL, r.Header.Get("Content-Type"))
				}
				if tt.readBody {
					_, _ = io.Copy(io.Discard, r.Body)
				}
				w.WriteHeader(http.StatusOK)
			}))
			defer server.Close()
			link := pterodactyl.BridgeURL{URL: server.URL + "/upload?token=signed", Host: "127.0.0.1"}
			open := func(ctx context.Context, contentType string, body io.Reader) (*http.Response, error) {
				req, err := http.NewRequestWithContext(ctx, http.MethodPost, link.URL, body)
				if err != nil {
					return nil, err
				}
				req.Header.Set("Content-Type", contentType)
				return (&http.Client{Timeout: 3 * time.Second}).Do(req)
			}
			started := time.Now()
			err := uploadFileStreamWithOpen(context.Background(), link, "world.zip", io.NopCloser(strings.NewReader(tt.body)), tt.limit, open)
			if (err != nil) != tt.wantErr {
				t.Fatalf("upload error = %v, wantErr=%v", err, tt.wantErr)
			}
			if tt.wantTooBig && !strings.Contains(fmt.Sprint(err), "upload exceeds") {
				t.Fatalf("overflow error = %v", err)
			}
			if time.Since(started) > 3*time.Second {
				t.Fatalf("upload took too long: %s", time.Since(started))
			}
		})
	}
}

func TestUploadFileStreamCancellationClosesSource(t *testing.T) {
	source := &blockingSource{closed: make(chan struct{})}
	// A canceled request must close the original body so its copy goroutine exits.
	var _ io.ReadCloser = source
	ctx, cancel := context.WithCancel(context.Background())
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		_, _ = io.Copy(io.Discard, r.Body)
	}))
	defer server.Close()
	link := pterodactyl.BridgeURL{URL: server.URL + "/upload?token=signed", Host: "127.0.0.1"}
	done := make(chan error, 1)
	go func() {
		done <- uploadFileStreamWithOpen(ctx, link, "world.zip", source, 1<<20, func(ctx context.Context, contentType string, body io.Reader) (*http.Response, error) {
			req, err := http.NewRequestWithContext(ctx, http.MethodPost, link.URL, body)
			if err != nil {
				return nil, err
			}
			req.Header.Set("Content-Type", contentType)
			return (&http.Client{Timeout: 3 * time.Second}).Do(req)
		})
	}()
	time.Sleep(40 * time.Millisecond)
	cancel()
	select {
	case <-done:
	case <-time.After(2 * time.Second):
		t.Fatal("canceled upload blocked")
	}
	select {
	case <-source.closed:
	case <-time.After(time.Second):
		t.Fatal("source body was not closed")
	}
}

func (s *blockingSource) Read([]byte) (int, error) { <-s.closed; return 0, io.ErrClosedPipe }
func (s *blockingSource) Close() error             { s.once.Do(func() { close(s.closed) }); return nil }

type blockingSource struct {
	closed chan struct{}
	once   sync.Once
}
