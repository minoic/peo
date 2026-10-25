# peo - single image, single port.
#
#   stage `web`     builds the Flutter Web (WASM) SPA
#   stage `build`   compiles the Gin server with the SPA embedded
#   stage `runtime` ships one binary that serves both /api/v1/... and the SPA
#
# Same origin for the API and the frontend means no CORS preflights and no
# cookie handling at the edge; see AGENTS.md section 8.

###############################################################################
# Stage 1 - Flutter Web bundle
###############################################################################
FROM debian:bookworm-slim AS web

# Pinned toolchain. The archive and its digest come from
# https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json
ARG FLUTTER_VERSION=3.47.4
ARG FLUTTER_SHA256=5b45f0ceda99b9bebdc873e7e69f6450aeb4c30f454b505e2e62fc9255a907d3
ARG FLUTTER_HOME=/opt/flutter

ENV DEBIAN_FRONTEND=noninteractive \
    FLUTTER_HOME=/opt/flutter \
    PUB_CACHE=/root/.pub-cache \
    PATH=/opt/flutter/bin:/root/.pub-cache/bin:$PATH

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      git \
      unzip \
      xz-utils \
 && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL --retry 5 --retry-delay 2 -o /tmp/flutter.tar.xz \
      "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" \
 && echo "${FLUTTER_SHA256}  /tmp/flutter.tar.xz" | sha256sum -c - \
 && mkdir -p "${FLUTTER_HOME}" \
 && tar -xJf /tmp/flutter.tar.xz -C "$(dirname "${FLUTTER_HOME}")" \
 && rm -f /tmp/flutter.tar.xz \
 && git config --global --add safe.directory "${FLUTTER_HOME}" \
 && flutter --version

WORKDIR /src/flutter

# Dependencies first so an application-code edit does not re-resolve the graph.
COPY flutter/pubspec.yaml flutter/pubspec.lock ./
RUN flutter pub get

COPY flutter/ ./

# freezed / json_serializable output is regenerated rather than trusted, then
# the release bundle is produced. `--wasm` emits main.dart.wasm and falls back
# to JavaScript on browsers without WebAssembly GC support.
RUN dart run build_runner build --delete-conflicting-outputs \
 && flutter build web --wasm --release \
 && test -f build/web/index.html

###############################################################################
# Stage 2 - Go server
###############################################################################
FROM golang:1.27.1-alpine AS build

ARG VERSION=dev
ARG BUILD_TIME

WORKDIR /src/server

COPY server/go.mod server/go.sum ./
RUN go mod download

COPY server/ ./

# The embed directive `//go:embed all:assets` needs assets/ to hold the bundle
# before `go build` runs, otherwise web.FS() returns nil and the binary has no
# frontend. The copy is additive: any .gitkeep from the source tree survives it.
COPY --from=web /src/flutter/build/web/ ./web/assets/

RUN BUILD_TIME="${BUILD_TIME:-$(date -u +%Y-%m-%dT%H:%M:%SZ)}" \
 && CGO_ENABLED=0 GOOS=linux \
    go build -trimpath \
      -ldflags "-s -w \
        -X github.com/minoic/peo/server/internal/buildinfo.Version=${VERSION} \
        -X github.com/minoic/peo/server/internal/buildinfo.BuildTime=${BUILD_TIME} \
        -X github.com/minoic/peo/server/internal/buildinfo.GoVersion=$(go env GOVERSION)" \
      -o /out/peo ./cmd/peo

###############################################################################
# Stage 3 - runtime
###############################################################################
FROM debian:bookworm-slim AS runtime

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC

# ca-certificates: verified TLS for the Pterodactyl API, SMTP and Alipay.
# tzdata:          Alipay timestamps and the delete-grace arithmetic are local.
# curl:            the HEALTHCHECK below.
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      tzdata \
 && rm -rf /var/lib/apt/lists/*

COPY --from=build /out/peo /peo

# MongoDB connection settings are passed through PEO_MONGO_URI and
# PEO_MONGO_DATABASE_NAME. Business settings are stored in MongoDB.
WORKDIR /

# The legacy Beego admin server on 8088 is gone; /healthz replaces it.
EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
    CMD curl -fsS http://127.0.0.1:8080/healthz || exit 1

ENTRYPOINT ["/peo"]
