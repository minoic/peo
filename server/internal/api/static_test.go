package api

import (
	"net/http"
	"net/http/httptest"
	"os"
	"path/filepath"
	"testing"
	"testing/fstest"

	"github.com/gin-gonic/gin"
)

// shellBundle is a miniature stand-in for the Flutter build output: a shell
// plus one content-hashed asset and a nested static file.
func shellBundle() fstest.MapFS {
	return fstest.MapFS{
		"index.html":                       {Data: []byte("<!doctype html><title>peo</title>")},
		"main.dart.js":                     {Data: []byte("console.log(1)")},
		"main.dart.wasm":                   {Data: []byte("\x00asm")},
		"assets/AssetManifest.json":        {Data: []byte("{}")},
		"assets/fonts/MaterialIcons.woff2": {Data: []byte("wOF2")},
	}
}

func TestBundleEmbeddedSource(t *testing.T) {
	b := bundle{fsys: shellBundle()}

	if !b.ready() {
		t.Fatal("ready() = false for an embedded bundle")
	}

	cases := []struct {
		path     string
		wantName string
	}{
		{"/", "index.html"},
		{"/index.html", "index.html"},
		{"/main.dart.js", "main.dart.js"},
		{"/main.dart.wasm", "main.dart.wasm"},
		{"/assets/AssetManifest.json", "assets/AssetManifest.json"},
		{"/assets/fonts/MaterialIcons.woff2", "assets/fonts/MaterialIcons.woff2"},
		// unknown deep links are the SPA's job: fall back to the shell
		{"/console/servers", "index.html"},
		{"/admin/settings", "index.html"},
		{"/orders/64b7f0c1e4b0a1d2c3e4f5a6", "index.html"},
		// traversal attempts must never escape the bundle
		{"/../conf/settings.toml", "index.html"},
		{"/../../etc/passwd", "index.html"},
		{"/assets/../../index.html", "index.html"},
	}

	for _, tc := range cases {
		a, found := b.open(tc.path)
		if !found {
			t.Errorf("open(%q) = not found, want %q", tc.path, tc.wantName)
			continue
		}
		if a.name != tc.wantName {
			t.Errorf("open(%q) name = %q, want %q", tc.path, a.name, tc.wantName)
		}
		if err := a.Close(); err != nil {
			t.Errorf("close(%q): %v", tc.path, err)
		}
	}
}

func TestBundleDiskSource(t *testing.T) {
	dir := t.TempDir()
	files := map[string]string{
		"index.html":                       "<!doctype html><title>peo</title>",
		"main.dart.js":                     "console.log(1)",
		"assets/AssetManifest.json":        "{}",
		"assets/fonts/MaterialIcons.woff2": "wOF2",
	}
	for name, body := range files {
		full := filepath.Join(dir, filepath.FromSlash(name))
		if err := os.MkdirAll(filepath.Dir(full), 0o755); err != nil {
			t.Fatalf("mkdir %s: %v", name, err)
		}
		if err := os.WriteFile(full, []byte(body), 0o644); err != nil {
			t.Fatalf("write %s: %v", name, err)
		}
	}

	b := bundle{root: dir}
	if !b.ready() {
		t.Fatal("ready() = false for a populated directory")
	}

	for _, tc := range []struct{ path, wantName string }{
		{"/", "index.html"},
		{"/main.dart.js", "main.dart.js"},
		{"/assets/AssetManifest.json", "AssetManifest.json"},
		{"/assets/fonts/MaterialIcons.woff2", "MaterialIcons.woff2"},
		{"/console/orders", "index.html"},
		{"/../../../etc/passwd", "index.html"},
	} {
		a, found := b.open(tc.path)
		if !found {
			t.Errorf("open(%q) = not found, want %q", tc.path, tc.wantName)
			continue
		}
		if a.name != tc.wantName {
			t.Errorf("open(%q) name = %q, want %q", tc.path, a.name, tc.wantName)
		}
		if a.size == 0 {
			t.Errorf("open(%q) size = 0", tc.path)
		}
		if err := a.Close(); err != nil {
			t.Errorf("close(%q): %v", tc.path, err)
		}
	}
}

// TestBundleMissing asserts the deliberate failure mode: without a bundle the
// fallback reports 404 rather than answering every path with a shell that
// cannot exist.
func TestBundleMissing(t *testing.T) {
	b := bundle{root: filepath.Join(t.TempDir(), "does-not-exist")}
	if b.ready() {
		t.Fatal("ready() = true for a missing directory")
	}
	if _, found := b.open("/"); found {
		t.Fatal("open(/) found a file in a missing directory")
	}

	// A directory that exists but holds no shell is equally unusable.
	empty := t.TempDir()
	if (bundle{root: empty}).ready() {
		t.Fatal("ready() = true for a directory without index.html")
	}
}

// TestBundleDefaultsToDiskSource documents the resolution order: the embedded
// bundle wins when the binary carries one, otherwise WebRoot is used and a
// blank setting means "web".
func TestBundleDefaultsToDiskSource(t *testing.T) {
	got := newBundle("")
	if got.fsys != nil {
		// A build that copied the Flutter output into server/web/assets embeds
		// it, and the embedded source legitimately wins. Nothing to assert here.
		return
	}
	if got.root != "web" {
		t.Errorf("blank WebRoot resolved to %q, want %q", got.root, "web")
	}
	if custom := newBundle("flutter/build/web"); custom.fsys == nil && custom.root != "flutter/build/web" {
		t.Errorf("WebRoot resolved to %q, want %q", custom.root, "flutter/build/web")
	}
}

func TestSpaFallbackRouting(t *testing.T) {
	gin.SetMode(gin.TestMode)

	r := gin.New()
	r.NoRoute(spaFallback(bundle{fsys: shellBundle()}))

	cases := []struct {
		method      string
		path        string
		wantStatus  int
		wantType    string
		wantNoCache bool
		wantBody    string
	}{
		{http.MethodGet, "/", http.StatusOK, "text/html; charset=utf-8", true, "<!doctype html>"},
		{http.MethodGet, "/index.html", http.StatusOK, "text/html; charset=utf-8", true, "<!doctype html>"},
		{http.MethodGet, "/console/servers", http.StatusOK, "text/html; charset=utf-8", true, "<!doctype html>"},
		{http.MethodGet, "/main.dart.js", http.StatusOK, "text/javascript; charset=utf-8", false, "console.log(1)"},
		{http.MethodGet, "/main.dart.wasm", http.StatusOK, "application/wasm", false, "\x00asm"},
		{http.MethodGet, "/assets/fonts/MaterialIcons.woff2", http.StatusOK, "font/woff2", false, "wOF2"},
		// API paths must never be answered with the shell
		{http.MethodGet, "/api/v1/definitely-not-a-route", http.StatusNotFound, "application/json; charset=utf-8", false, `"not_found"`},
		{http.MethodPost, "/api/v1/nope", http.StatusNotFound, "application/json; charset=utf-8", false, `"not_found"`},
		{http.MethodGet, "/healthz/deeper", http.StatusNotFound, "application/json; charset=utf-8", false, `"not_found"`},
	}

	for _, tc := range cases {
		rec := httptest.NewRecorder()
		r.ServeHTTP(rec, httptest.NewRequest(tc.method, tc.path, nil))

		if rec.Code != tc.wantStatus {
			t.Errorf("%s %s: status = %d, want %d", tc.method, tc.path, rec.Code, tc.wantStatus)
		}
		if got := rec.Header().Get("Content-Type"); got != tc.wantType {
			t.Errorf("%s %s: content-type = %q, want %q", tc.method, tc.path, got, tc.wantType)
		}
		cache := rec.Header().Get("Cache-Control")
		if tc.wantNoCache && cache != "no-cache" {
			t.Errorf("%s %s: cache-control = %q, want no-cache", tc.method, tc.path, cache)
		}
		if !tc.wantNoCache && cache == "no-cache" {
			t.Errorf("%s %s: cache-control = %q, want a cacheable value", tc.method, tc.path, cache)
		}
		if body := rec.Body.String(); !contains(body, tc.wantBody) {
			t.Errorf("%s %s: body = %q, want it to contain %q", tc.method, tc.path, body, tc.wantBody)
		}
	}
}

// TestSpaFallbackWithoutBundle asserts that a deployment with no bundle at all
// fails closed instead of returning an empty 200.
func TestSpaFallbackWithoutBundle(t *testing.T) {
	gin.SetMode(gin.TestMode)
	r := gin.New()
	r.NoRoute(spaFallback(bundle{root: filepath.Join(t.TempDir(), "missing")}))

	for _, p := range []string{"/", "/console", "/main.dart.js"} {
		rec := httptest.NewRecorder()
		r.ServeHTTP(rec, httptest.NewRequest(http.MethodGet, p, nil))
		if rec.Code != http.StatusNotFound {
			t.Errorf("GET %s without a bundle: status = %d, want 404", p, rec.Code)
		}
	}
}

func TestContentTypeFor(t *testing.T) {
	for name, want := range map[string]string{
		"index.html":         "text/html; charset=utf-8",
		"main.dart.js":       "text/javascript; charset=utf-8",
		"main.dart.wasm":     "application/wasm",
		"AssetManifest.json": "application/json; charset=utf-8",
		"main.dart.js.map":   "application/json; charset=utf-8",
		"favicon.png":        "image/png",
		"logo.svg":           "image/svg+xml",
		"favicon.ico":        "image/x-icon",
		"Font.ttf":           "font/ttf",
		"Font.woff2":         "font/woff2",
		"styles.css":         "text/css; charset=utf-8",
		"main.dart.symbols":  "text/plain; charset=utf-8",
		"mystery.bin":        "application/octet-stream",
	} {
		if got := contentTypeFor(name); got != want {
			t.Errorf("contentTypeFor(%q) = %q, want %q", name, got, want)
		}
	}
}

func contains(haystack, needle string) bool {
	if needle == "" {
		return true
	}
	for i := 0; i+len(needle) <= len(haystack); i++ {
		if haystack[i:i+len(needle)] == needle {
			return true
		}
	}
	return false
}
