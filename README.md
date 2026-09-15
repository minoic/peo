# peo

[![](https://img.shields.io/github/stars/minoic/peo?style=social)](https://github.com/minoic/peo)
![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/minoic/peo/ci.yml?style=for-the-badge&logo=github&label=CI)

A storefront and control panel for [Pterodactyl](https://github.com/pterodactyl/panel):
sell servers automatically, provision them on the panel, and let customers manage,
renew and top up their own.

It targets **Minecraft** hosts — the status probe speaks the Minecraft server-list
ping protocol — and tracks Pterodactyl v1.11.x.

---

## Architecture

This is a v1 rewrite. The business rules are the v0.2.x rules, unchanged; the
transport and the storage engine are new.

| | v0.2.x | v1 |
|---|---|---|
| HTTP | Beego v2 MVC, server-rendered templates | **Gin**, REST/JSON only |
| Frontend | 30 Beego `.html` templates | **Flutter Web (WASM)** SPA |
| Storage | gorm v1 + MySQL | **MongoDB** (official driver) |
| Cache, sessions, rate limits | Redis | **Redis, unchanged** |
| i18n | `beego/i18n`, 3 locales | removed, English only |
| Captcha | `beego/captcha` | removed, Redis rate limiting instead |

Three directories:

| Path | What it is |
|---|---|
| [`server/`](./server) | the Go module `github.com/minoic/peo/server` |
| [`flutter/`](./flutter) | the Flutter Web app |
| [`legacy/`](./legacy) | the v0.2.x Beego module, **reference only** — not built, not shipped |
| [`docs/`](./docs) | [architecture](./docs/ARCHITECTURE.md), [API](./docs/API.md), [data](./docs/CONTRACT-DATA.md), [routes](./docs/CONTRACT-ROUTES.md), [plan](./docs/PLAN.md) |

The Go binary serves the compiled SPA, so there is **one container, one port and
one origin**: no CORS preflights, no cookie plumbing at the edge.

---

## Features

- Registration (the first account becomes the administrator), login, password
  reset, password change, e-mail change with a mailed confirmation code
- Storefront with monthly / quarterly / yearly pricing and per-product discounts
- Order and pay with balance or with an activation key
- Customer console: server list, live status, panel single-sign-on, uptime
  accounting, self-service renew and reinstall
- Support tickets
- In-site messages with an unread badge
- A shareable public gallery with moderation
- Recharge by key or by Alipay face-to-face QR payment
- Admin console: products, activation keys (batch generate and export), users,
  orders, tickets, gallery review, runtime settings and health
- Scheduled tasks: cache refresh, panel sync, expiry checks, key cleanup
- Expiry e-mails, then suspension, then a confirmation step before an
  administrator approves deletion

---

## Quick start

### Docker Compose (recommended)

```bash
git clone https://github.com/minoic/peo.git
cd peo
docker compose up -d
```

Then open <http://localhost:8080> and register — the **first account is created as
the administrator**. Open the admin console, go to Settings, and fill in the
Pterodactyl hostname and API token plus your SMTP details.

The stack is `peo` (port 8080), `mongo:7` and `redis:7`, with named volumes for
the two databases and a bind mount of `./conf` for the saved settings.

### Building the image yourself

```bash
docker compose build peo
```

The image is a three-stage build: it compiles the Flutter Web (WASM) bundle,
embeds that bundle into the Go binary, and ships one small runtime. The Flutter
toolchain is downloaded from the official release archive and verified against a
pinned SHA-256, so the build is reproducible without a prebuilt SDK image.

### Running from source

Requires Go 1.27.1 and a reachable MongoDB and Redis.

```bash
cd server
go build ./... && go run ./cmd/peo
```

On first run the server writes `conf/settings.toml` from its embedded default and
**continues** rather than exiting, so a container with no configuration boots and
logs a warning. Point `MongoURI`, `MongoDatabaseName` and `RedisHost` at your
services, then finish the configuration from the admin settings page.

The API and the SPA are both served from `:8080`, and `/healthz` reports Mongo,
Redis and Pterodactyl connectivity.

The server must be started from the repository root (or with a working directory
that contains `conf/`), because the configuration path is relative.

### Frontend development

Requires Flutter 3.47.4 with web support enabled.

```bash
cd flutter
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d chrome
```

Set `CORSOrigins` in `conf/settings.toml` while developing against a separately
running server — in production it should stay empty, because the SPA is served
from the same origin.

To produce the bundle the server embeds:

```bash
cd flutter
flutter build web --wasm --release
```

Then copy `flutter/build/web` into `server/web/assets/`, or just build the image,
which does it for you.

---

## Configuration

Settings live in `conf/settings.toml` and are all editable from the admin console
at runtime — a save reloads the file, rebuilds the Alipay client and reconnects
Mongo and Redis.

The only values worth setting by hand before the first boot are the storage
endpoints:

| Key | Default |
|---|---|
| `MongoURI` | `mongodb://mongo:27017` |
| `MongoDatabaseName` | `peo` |
| `RedisHost` | `redis:6379` |
| `RedisPassword` | empty |
| `RedisDB` | `0` |

Everything else — `WebApplicationName`, `WebHostName`, `PterodactylHostname`,
`PterodactylToken`, SMTP, Alipay keys, feature switches — is described in the
admin settings page itself.

---

## Reverse proxy

Put Nginx (or equivalent) in front for TLS and terminate on port 8080.

Panel single-sign-on needs a shared parent domain — for example `peo.example.com`
and `pte.example.com` — and a valid certificate, because the handover cookie is
scoped to the parent.

To serve the app directly on port 80, change the published port in
[`docker-compose.yml`](./docker-compose.yml):

```yaml
    ports:
      - "80:8080"
```

---

## Upgrading

The v1 rewrite does **not** read a MySQL database. It is a fresh MongoDB schema
and there is no migration path from v0.2.x: a v1 deployment starts empty.

```bash
docker compose pull
docker compose up -d
```

The `conf/` mount and the `mongo-data` volume are preserved across an image
upgrade.

---

## Documentation

| File | Contents |
|---|---|
| [`docs/ARCHITECTURE.md`](./docs/ARCHITECTURE.md) | how the rewrite is put together, and every deliberate deviation |
| [`docs/API.md`](./docs/API.md) | the REST surface: payloads, envelopes, status codes |
| [`docs/CONTRACT-ROUTES.md`](./docs/CONTRACT-ROUTES.md) | the route table and middleware bindings |
| [`docs/CONTRACT-DATA.md`](./docs/CONTRACT-DATA.md) | collections, fields, indexes, value vocabularies |
| [`docs/PLAN.md`](./docs/PLAN.md) | workstream status and open items |
| [`AGENTS.md`](./AGENTS.md) | the frozen target specification the code implements |
| [`CHANGELOG.md`](./CHANGELOG.md) | release history |

---

## License

See the repository for licence terms. Issues and pull requests are welcome.
