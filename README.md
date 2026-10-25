# peo

[![GitHub stars](https://img.shields.io/github/stars/minoic/peo?style=social)](https://github.com/minoic/peo)
[![CI](https://img.shields.io/github/actions/workflow/status/minoic/peo/ci.yml?style=for-the-badge&logo=github&label=CI)](https://github.com/minoic/peo/actions/workflows/ci.yml)

peo is a storefront and management console for Minecraft hosting on
[Pterodactyl Panel 2](https://github.com/pterodactyl/panel). Customers can order,
renew and manage servers; administrators manage products, payments, users and
runtime settings. Server management integrates through the Panel 2 `peo-bridge`
extension.

The application is a Go/Gin REST service and a Flutter Web single-page app. The
Go service serves both the API and compiled frontend from one origin. MongoDB
stores business data and settings; Redis handles short-lived state and caching.

## Repository

- `server/`: Go service (`github.com/minoic/peo/server`)
- `flutter/`: Flutter Web application, built for WebAssembly with a JavaScript fallback
- `pterodactyl/`: Panel extension and deployment files
- `docs/`: architecture, API, route and data contracts

## Run locally

Start the dependencies with Docker Compose:

```sh
docker compose up -d mongo redis
```

Run the backend with Go 1.27.1 or newer:

```sh
cd server
go run ./cmd/peo
```

The server listens on `:8080`. Open <http://localhost:8080> after building the
frontend bundle (see below). Set `PEO_MONGO_URI` and
`PEO_MONGO_DATABASE_NAME` when MongoDB is not available at the defaults
`mongodb://localhost:27017` and `peo`.

Embedded defaults seed application settings in MongoDB on first start. The
default Redis host is `redis:6379`, which resolves inside the Compose network.
When running the Go process on the host, set `PEO_REDIS_ADDR=127.0.0.1:6379`;
the VS Code Go debug target already sets it. This runtime override keeps the
MongoDB business setting unchanged. Without the override, a fresh database
uses `redis:6379`; legacy `server/conf/settings.toml` is imported once into a
new settings document.
Configure the Pterodactyl Panel, SMTP and Alipay settings from the admin settings
page. The first registered account becomes the administrator.

The root Compose file runs MongoDB, Redis and the application. Its
`PEO_REDIS_ADDR=redis:6379` setting points the application at Redis on the
Compose network even when the same database was previously used by a host-side
debug server. For other deployments, `PEO_REDIS_ADDR` optionally overrides the
Redis endpoint stored in MongoDB; Redis password and database settings remain
in MongoDB. To build the application image:

```sh
docker build -f Dockerfile -t peo:local .
```

The image build compiles Flutter Web, regenerates Freezed/JSON code, embeds the
bundle in the Go binary, and packages a single runtime image. MongoDB connection
settings are passed as `PEO_MONGO_URI` and `PEO_MONGO_DATABASE_NAME`; business
settings are persisted in MongoDB, with the optional `PEO_REDIS_ADDR`
deployment override described above.

## Frontend development

Use the Flutter version pinned in `Dockerfile` (3.47.4) with web support:

```sh
cd flutter
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d chrome --web-port 5173 --dart-define=API_BASE_URL=http://localhost:8080/api/v1
```

For a production bundle served by the backend:

```sh
flutter build web --wasm --release
```

Copy `flutter/build/web/` into `server/web/assets/`, or use the Docker build,
which builds and embeds the frontend automatically. During separate frontend
and backend development, configure the backend's `CORSOrigins` setting for the
frontend origin. Keep it empty when serving the SPA and API from the same origin.

## Checks

The CI workflow runs Go formatting, module tidiness, build, vet, unit and race
tests; Flutter dependency resolution, code generation, analysis, tests and a
WASM release build; and a Docker image build.

Run the Go checks from `server/`:

```sh
go mod tidy
gofmt -l ./cmd ./internal
go build ./...
go vet ./...
go test ./...
```

Run Flutter checks from `flutter/`:

```sh
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter build web --wasm --release
```

MongoDB and Redis integration tests run when `PEO_TEST_MONGO_URI` and
`PEO_TEST_REDIS_ADDR` point to disposable test services; otherwise those tests
are skipped.

## Deployment and documentation

Terminate TLS at a reverse proxy and forward traffic to port 8080. The
`/healthz` endpoint reports service health. Keep the Pterodactyl Application API
token in server-side settings; it is not exposed to the browser. Install and
configure the Panel extension using the
[deployment guide](./pterodactyl/deploy/README.md).

- [Architecture](./docs/ARCHITECTURE.md)
- [REST API](./docs/API.md)
- [Routes and access control](./docs/CONTRACT-ROUTES.md)
- [MongoDB data contract](./docs/CONTRACT-DATA.md)
- [Development boundaries](./AGENTS.md)

## License

Licensed under the [MIT License](./LICENSE). Issues and pull requests are welcome.
