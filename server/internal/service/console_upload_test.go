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
		blockBody  bool
		wantErr    bool
		wantTooBig bool
	}{
		{name: "unknown length ordinary upload", body: "hello", limit: 5, readBody: true},
		{name: "unknown length overflow", body: "123456", limit: 5, readBody: true, wantErr: true, wantTooBig: true},
		{name: "early success response", body: strings.Repeat("x", 32<<10), limit: 2 << 20, blockBody: true, wantErr: true},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			var source io.ReadCloser = io.NopCloser(strings.NewReader(tt.body))
			var blockedSource *earlyResponseSource
			if tt.blockBody {
				blockedSource = &earlyResponseSource{body: strings.NewReader(tt.body), closed: make(chan struct{}), started: make(chan struct{})}
				source = blockedSource
			}
			server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
				if r.Method != http.MethodPost || !strings.Contains(r.Header.Get("Content-Type"), "multipart/form-data") {
					t.Errorf("request = %s %s content-type=%q", r.Method, r.URL, r.Header.Get("Content-Type"))
				}
				if tt.readBody {
					_, _ = io.Copy(io.Discard, r.Body)
				}
				if tt.blockBody {
					if err := http.NewResponseController(w).EnableFullDuplex(); err != nil {
						t.Errorf("enable full duplex: %v", err)
						return
					}
					select {
					case <-blockedSource.started:
					case <-time.After(time.Second):
						t.Error("upload source did not start")
						return
					}
					w.Header().Set("Content-Length", "0")
					w.WriteHeader(http.StatusOK)
					if err := http.NewResponseController(w).Flush(); err != nil {
						t.Errorf("flush early response: %v", err)
					}
					select {
					case <-blockedSource.closed:
					case <-time.After(time.Second):
						t.Error("client did not stop the incomplete upload")
					}
					return
				}
				w.WriteHeader(http.StatusOK)
			}))
			server.Config.SetKeepAlivesEnabled(false)
			defer server.Close()
			link := pterodactyl.BridgeURL{URL: server.URL + "/upload?token=signed", Host: "127.0.0.1"}
			open := func(ctx context.Context, contentType string, body io.Reader) (*http.Response, error) {
				req, err := http.NewRequestWithContext(ctx, http.MethodPost, link.URL, body)
				if err != nil {
					return nil, err
				}
				req.Header.Set("Content-Type", contentType)
				return (&http.Client{Timeout: 3 * time.Second, Transport: &http.Transport{DisableKeepAlives: true}}).Do(req)
			}
			started := time.Now()
			err := uploadFileStreamWithOpen(context.Background(), link, "world.zip", source, tt.limit, open)
			if (err != nil) != tt.wantErr {
				t.Fatalf("upload error = %v, wantErr=%v", err, tt.wantErr)
			}
			if tt.blockBody {
				if err == nil || !strings.Contains(err.Error(), "file upload was interrupted") || strings.Contains(err.Error(), "context deadline exceeded") {
					t.Fatalf("early response error = %v, want prompt interrupted upload", err)
				}
				select {
				case <-blockedSource.closed:
				default:
					t.Fatal("early response did not close the incomplete upload source")
				}
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

// Keep the source open after its first chunk so the server's successful response
// races with an incomplete request body, independent of the OS TCP send buffer.
type earlyResponseSource struct {
	body    io.Reader
	closed  chan struct{}
	started chan struct{}
	once    sync.Once
	reads   int
}

func (s *earlyResponseSource) Read(p []byte) (int, error) {
	if s.reads > 0 {
		<-s.closed
		return 0, io.ErrClosedPipe
	}
	s.reads++
	n, err := s.body.Read(p)
	close(s.started)
	return n, err
}

func (s *earlyResponseSource) Close() error {
	s.once.Do(func() { close(s.closed) })
	return nil
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
