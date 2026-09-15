package api

import (
	"io"
	"io/fs"
	"net/http"
	"os"
	"path"
	"path/filepath"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/minoic/peo/server/internal/apierr"
	"github.com/minoic/peo/server/web"
)

// bundle resolves the compiled Flutter Web output the single-page shell is
// served from.
//
// Two sources are supported, in order:
//
//  1. the bundle embedded in the binary (web.FS), which is what a release image
//     ships, so the container needs no writable directory and no volume; or
//  2. the directory named by the WebRoot setting, which is the development path
//     (`flutter build web --wasm --release`, then WebRoot = flutter/build/web).
//
// Both sources answer the same requests: a path that resolves to a real file is
// served as-is, anything else falls back to index.html so go_router owns the
// address bar.
type bundle struct {
	fsys fs.FS
	root string
}

// newBundle picks the SPA source for the current process, preferring the
// embedded bundle.
func newBundle(webRoot string) bundle {
	if fsys := web.FS(); fsys != nil {
		return bundle{fsys: fsys}
	}
	if strings.TrimSpace(webRoot) == "" {
		webRoot = "web"
	}
	return bundle{root: webRoot}
}

// ready reports whether a bundle is actually present. When it is not, the
// fallback degrades to a plain 404 envelope instead of masking every unknown
// path with an index.html that does not exist.
func (b bundle) ready() bool {
	if b.fsys != nil {
		return true
	}
	info, err := os.Stat(filepath.Join(b.root, "index.html"))
	return err == nil && !info.IsDir()
}

// asset is one servable file plus the metadata http.ServeContent needs.
type asset struct {
	io.ReadSeeker
	name    string
	size    int64
	modTime time.Time
}

// Close releases the underlying handle. Files from a directory source hold an
// OS handle and must be closed; files from an fs.FS that is a map or an embed
// do not, so Close is a no-op there.
func (a *asset) Close() error {
	if closer, ok := a.ReadSeeker.(io.Closer); ok {
		return closer.Close()
	}
	return nil
}

// open resolves a request path against the bundle, falling back to index.html
// for anything the bundle does not contain.
//
// The path is normalised as absolute before use, so a request such as
// "/../../etc/passwd" collapses to "/etc/passwd" and can never escape the
// bundle. fs.FS additionally rejects any name that is not a valid relative
// path.
func (b bundle) open(urlPath string) (*asset, bool) {
	rel := strings.TrimPrefix(path.Clean("/"+strings.TrimPrefix(urlPath, "/")), "/")
	if rel == "" || rel == "." {
		rel = "index.html"
	}

	if b.fsys != nil {
		if a := openFromFS(b.fsys, rel); a != nil {
			return a, true
		}
		if rel == "index.html" {
			return nil, false
		}
		a := openFromFS(b.fsys, "index.html")
		return a, a != nil
	}

	if a := openFromDisk(filepath.Join(b.root, filepath.FromSlash(rel))); a != nil {
		return a, true
	}
	if rel == "index.html" {
		return nil, false
	}
	a := openFromDisk(filepath.Join(b.root, "index.html"))
	return a, a != nil
}

// openFromFS returns the named file from an fs.FS, or nil when it is missing,
// a directory, or unreadable through io.ReadSeeker.
func openFromFS(fsys fs.FS, name string) *asset {
	f, err := fsys.Open(name)
	if err != nil {
		return nil
	}
	info, err := f.Stat()
	if err != nil || info.IsDir() {
		_ = f.Close()
		return nil
	}
	rs, ok := f.(io.ReadSeeker)
	if !ok {
		_ = f.Close()
		return nil
	}
	return &asset{ReadSeeker: rs, name: name, size: info.Size(), modTime: info.ModTime()}
}

// openFromDisk returns the regular file at full, or nil.
func openFromDisk(full string) *asset {
	info, err := os.Stat(full)
	if err != nil || !info.Mode().IsRegular() {
		return nil
	}
	f, err := os.Open(full)
	if err != nil {
		return nil
	}
	return &asset{ReadSeeker: f, name: info.Name(), size: info.Size(), modTime: info.ModTime()}
}

// spaFallback is the gin NoRoute handler.
//
// Anything under /api/ or /healthz is a genuine 404: answering those with an
// HTML shell would turn a mistyped API call into a client-side parse error.
func spaFallback(b bundle) gin.HandlerFunc {
	return func(c *gin.Context) {
		p := c.Request.URL.Path
		if strings.HasPrefix(p, "/api/") || strings.HasPrefix(p, "/healthz") {
			apierr.Abort(c, apierr.Fail(apierr.CodeNotFound, "resource not found"))
			return
		}
		if !b.ready() {
			apierr.Abort(c, apierr.Fail(apierr.CodeNotFound, "resource not found"))
			return
		}
		a, found := b.open(p)
		if !found {
			apierr.Abort(c, apierr.Fail(apierr.CodeNotFound, "resource not found"))
			return
		}
		defer func() { _ = a.Close() }()

		// The shell must never be cached under its own name: a stale copy keeps
		// pointing at content-hashed assets that no longer exist. Everything
		// else in the bundle is content-hashed (or stable, like favicon.png),
		// so it is safe to cache.
		if a.name == "index.html" {
			c.Header("Cache-Control", "no-cache")
		} else {
			c.Header("Cache-Control", "public, max-age=3600")
		}
		// Set explicitly rather than letting ServeContent sniff: the type of
		// .wasm and .symbols must not depend on the host MIME database.
		c.Header("Content-Type", contentTypeFor(a.name))
		http.ServeContent(c.Writer, c.Request, a.name, a.modTime, a.ReadSeeker)
	}
}

// contentTypeFor maps a bundle file extension to its content type.
func contentTypeFor(name string) string {
	switch strings.ToLower(path.Ext(name)) {
	case ".html":
		return "text/html; charset=utf-8"
	case ".js", ".mjs":
		return "text/javascript; charset=utf-8"
	case ".wasm":
		return "application/wasm"
	case ".json", ".map":
		return "application/json; charset=utf-8"
	case ".css":
		return "text/css; charset=utf-8"
	case ".png":
		return "image/png"
	case ".svg":
		return "image/svg+xml"
	case ".ico":
		return "image/x-icon"
	case ".ttf":
		return "font/ttf"
	case ".otf":
		return "font/otf"
	case ".woff":
		return "font/woff"
	case ".woff2":
		return "font/woff2"
	case ".txt", ".symbols":
		return "text/plain; charset=utf-8"
	}
	return "application/octet-stream"
}
