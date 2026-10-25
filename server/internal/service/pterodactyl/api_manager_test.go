package pterodactyl

import (
	"context"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
)

func TestApplicationAPIRejectsRedirectsAndRedactsBodies(t *testing.T) {
	for _, status := range []int{http.StatusFound, http.StatusForbidden} {
		t.Run(http.StatusText(status), func(t *testing.T) {
			client := newPanel2TestClient(t, http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
				w.WriteHeader(status)
				_, _ = w.Write([]byte(`{"detail":"upstream-secret-marker"}`))
			}))
			_, err := client.api(context.Background(), nil, "nodes", http.MethodGet)
			if err == nil {
				t.Fatal("non-2xx Application API response was accepted")
			}
			if strings.Contains(err.Error(), "upstream-secret-marker") {
				t.Fatalf("upstream response body leaked through error: %v", err)
			}
		})
	}

	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusMovedPermanently)
	}))
	defer server.Close()
	client := newPanel2TestClient(t, http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		http.Redirect(w, r, server.URL, http.StatusFound)
	}))
	if _, err := client.api(context.Background(), nil, "nodes", http.MethodGet); err == nil {
		t.Fatal("Application API redirect was reported as success")
	}
}
