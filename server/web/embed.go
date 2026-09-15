// Package web carries the compiled Flutter Web bundle.
//
// The bundle is produced by `flutter build web --wasm --release` and copied
// into assets/ by the image build. In a bare checkout assets/ holds only a
// placeholder, so FS returns nil and the API falls back to serving the bundle
// from disk (the development path).
package web

import (
	"embed"
	"io/fs"
)

//go:embed all:assets
var embedded embed.FS

// FS returns the embedded Flutter Web bundle, or nil when it was not copied
// into the build.
func FS() fs.FS {
	sub, err := fs.Sub(embedded, "assets")
	if err != nil {
		return nil
	}
	if _, err := fs.Stat(sub, "index.html"); err != nil {
		return nil
	}
	return sub
}
