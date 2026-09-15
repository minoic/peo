# peo - developer entry points.
#
# `make image`, `make up` and `make down` need a running Docker daemon.
# `make build`, `make test` and `make vet` need Go.
# `make flutter` needs the Flutter SDK and network access to pub.dev for the
# first `pub get`.

SHELL := /bin/sh

MODULE      := github.com/minoic/peo/server
SERVER_DIR  := server
FLUTTER_DIR := flutter
WEB_BUNDLE  := $(FLUTTER_DIR)/build/web
WEB_ASSETS  := $(SERVER_DIR)/web/assets
BIN         := $(SERVER_DIR)/bin/peo

VERSION   ?= dev
BUILD_TIME ?= $(shell date -u +%Y-%m-%dT%H:%M:%SZ)
GO_VERSION ?= $(shell go version | awk '{print $$3}')
LDFLAGS := -s -w \
  -X $(MODULE)/internal/buildinfo.Version=$(VERSION) \
  -X $(MODULE)/internal/buildinfo.BuildTime=$(BUILD_TIME) \
  -X $(MODULE)/internal/buildinfo.GoVersion=$(GO_VERSION)

.PHONY: all build test vet fmt tidy flutter embed image up down logs clean help

all: build

## build: compile the server into server/bin/peo
build:
	cd $(SERVER_DIR) && go build -trimpath -ldflags "$(LDFLAGS)" -o bin/peo ./cmd/peo

## test: run the Go test suite
test:
	cd $(SERVER_DIR) && go test ./...

## vet: run go vet over the whole module
vet:
	cd $(SERVER_DIR) && go vet ./...

## fmt: gofmt every tracked Go file
fmt:
	cd $(SERVER_DIR) && gofmt -l -w .

## tidy: sync go.mod/go.sum (CI re-checks this and fails on a diff)
tidy:
	cd $(SERVER_DIR) && go mod tidy

## flutter: build the web (WASM) SPA
flutter:
	cd $(FLUTTER_DIR) && flutter pub get
	cd $(FLUTTER_DIR) && dart run build_runner build --delete-conflicting-outputs
	cd $(FLUTTER_DIR) && flutter build web --wasm --release

## embed: copy a locally built SPA bundle into the server's embed directory.
##        The image build does this for you; local builds need it so that
##        `go run ./cmd/peo` serves the frontend instead of 404 on `/`.
##        .gitkeep is restored afterwards so `//go:embed all:assets` still
##        matches a file in a source checkout that has no bundle.
embed: flutter
	rm -rf $(WEB_ASSETS)
	mkdir -p $(WEB_ASSETS)
	cp -r $(WEB_BUNDLE)/. $(WEB_ASSETS)/
	touch $(WEB_ASSETS)/.gitkeep

## image: build the container image through compose
image:
	docker compose build peo

## up: start mongo, redis and peo in the background
up:
	docker compose up -d

## down: stop the stack
down:
	docker compose down

## logs: follow the peo container logs
logs:
	docker compose logs -f peo

## clean: remove build output
clean:
	rm -rf $(SERVER_DIR)/bin
	rm -rf $(FLUTTER_DIR)/build
	rm -rf $(WEB_ASSETS)
	mkdir -p $(WEB_ASSETS)
	touch $(WEB_ASSETS)/.gitkeep

## help: list the available targets
help:
	@grep -E '^## ' $(MAKEFILE_LIST) | sed 's/^## //'
