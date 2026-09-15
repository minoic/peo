// Package buildinfo carries the values injected at link time by the Makefile
// and the CI build. The legacy project stored them on the settings controller;
// they live in their own package now so both the version endpoint and the log
// banner can read them without importing the service layer.
package buildinfo

// Version, BuildTime and GoVersion are populated with
//
//	-ldflags "-X github.com/minoic/peo/server/internal/buildinfo.Version=... \
//	          -X github.com/minoic/peo/server/internal/buildinfo.BuildTime=..."
//
// They stay empty in a plain `go run`.
var (
	// Version is the release tag of the build.
	Version string
	// BuildTime is the wall clock time the build was produced.
	BuildTime string
	// GoVersion is the toolchain that produced the binary.
	GoVersion string
)
