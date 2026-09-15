# peo — Target Architecture

Status: **frozen**. This document is the single source of truth for the rewrite.
Everything in `/server` and `/flutter` implements what is written here.

Don`t modify files outside this folder directly or run risk commands.

---

## 1. Scope

| Aspect | Legacy | Target |
|---|---|---|
| HTTP layer | Beego v2 MVC, server-rendered Go templates | **Gin** — REST/JSON only, no HTML rendering |
| Frontend | 30 Beego `.html` templates + static assets | **Flutter Web (WASM)** SPA in `/flutter` |
| Storage | jinzhu/gorm v1.9.16 + MySQL | **MongoDB** via the official `go.mongodb.org/mongo-driver` |
| Cache / session state / rate limits | Redis | **Redis — unchanged** |
| Business rules | `internal/{orderform,pterodactyl,cryptoo,email,message,status}` | Ported verbatim in behaviour into `internal/service` |
| i18n | `beego/i18n`, 3 locales | **Removed — English only** |
| Captcha | `beego/captcha` | **Removed — Redis rate limiting only** |
| Old code | — | Preserved under `/legacy` (not built, not deployed) |

Business behaviour is **not** being redesigned. Every rule, threshold, key name,
Redis key, email trigger and money calculation is preserved exactly. Only the
transport, the storage engine, the rendering layer and the language handling change.

---

## 2. Repository layout

```
peo/
├── server/          Go module  github.com/minoic/peo/server      (new backend)
├── flutter/         Flutter app                                  (new frontend)
├── legacy/          Old Beego module github.com/minoic/peo       (reference only)
├── docs/            ARCHITECTURE.md · API.md · PLAN.md · CONTRACT-*.md
├── .github/         CI
├── README.md
└── docker-compose.yml   mongo + redis + peo
```

`legacy/` keeps its own `go.mod` so it never interferes with the new build. CI
ignores it. It exists so behaviour can be diffed during the port, then deleted.

---

## 3. Server package layout

```
server/
├── cmd/peo/main.go            entrypoint: config → store → services → cron → router → listen
├── internal/
│   ├── config/                viper + TOML (conf/settings.toml), Alipay client, Reload()
│   ├── models/                BSON document structs, shared by store and service
│   ├── store/                 Repository layer — one struct per collection
│   ├── auth/                  JWT issue/verify, password hashing, Redis token blacklist
│   ├── middleware/            Gin middleware: auth, admin, rate limit, error handling
│   ├── service/               business logic, transport-agnostic
│   │   ├── pterodactyl/       Application API client + gcache layer + semaphore
│   │   ├── status/            Minecraft TCP ping
│   │   ├── email/             SMTP + templates
│   │   ├── order/             order creation, payment, renew, reinstall
│   │   ├── cryptoo/           product keys & recharge keys
│   │   ├── message/           in-site messages
│   │   ├── gallery/           gallery moderation
│   │   └── settings/          config schema + save
│   ├── api/                   Gin handlers (thin: decode → service → encode)
│   │   ├── router.go
│   │   └── handlers/*.go
│   └── cron/                  robfig/cron task registration
└── conf/settings.toml         generated on first run from embedded default
```

### Layer rules

1. **`api` never touches `store` or the Mongo driver directly.** Handlers call
   `service`, services call `store`. This keeps business rules in one place and
   makes them reachable from cron as well.
2. **`store` returns `models` structs and typed errors only** (`store.ErrNotFound`).
   No `bson.M` leaks out of the package.
3. **`service` never touches `http`/`gin`.** It takes plain inputs and returns
   plain outputs plus a typed `service.Error` carrying an HTTP status + message.
4. **`middleware` is the only place that inspects the `Authorization` header.**
5. **`config` is read through accessor helpers**; `Reload()` swaps the whole
   viper instance under a mutex so a runtime settings save is safe.

---

## 4. Authentication

Replaces Beego encrypted cookies. Legacy session keys `LST` (JWT), `UN`
(username), `ID` (user id) are gone.

- **Login** → `POST /api/v1/auth/login` returns `{ accessToken, expiresAt, user }`.
  The token is a JWT signed with the key currently hardcoded in
  `legacy/internal/session/auth_jwt.go` (kept so the scheme is unchanged).
- **Transport** → `Authorization: Bearer <token>`.
- **Claims** → `sub` = Mongo ObjectID hex, `name`, `admin`. `sub` replaces the
  legacy `ID` session key; `name` replaces `UN`.
- **Validity check** is the legacy `session.Logged()` logic: the JWT must verify
  **and** the referenced user document must still exist (a deleted user is
  rejected even with a valid signature).
- **Logout** → `POST /api/v1/auth/logout` records the token id in Redis under
  `JWTBLACKLIST:<jti>` until natural expiry; every authenticated request checks it.
- **Password** → `md5(plaintext + DatabaseSalt)` hex, identical to legacy.
  Not upgraded to bcrypt: that is a behaviour change, out of scope.
- **Admin** → the user document's `isAdmin` flag, checked by `middleware.Admin`.

`X-Auth-*` headers are gone; nothing else about the trust model changes.

---

## 5. Data model

14 legacy GORM models → 13 Mongo collections (one model, `PEAdminSetting`, is
dead code and is dropped). All `gorm.Model` fields are replaced explicitly.

| Legacy | Target |
|---|---|
| `ID uint` auto-increment | `_id ObjectID` |
| `CreatedAt` / `UpdatedAt` | `createdAt` / `updatedAt` (`time.Time`, maintained by the repository, not by GORM) |
| `DeletedAt *time.Time` (soft delete) | **dropped** — deletes are hard |
| every FK (`UserID`, `SpecID`, `WareID`, `ReceiverID`) `uint` | `ObjectID` |
| `template.HTML` / `template.URL` columns | plain `string` |

Consequences:

- **IDs are 24-char hex strings in the API.** Every path parameter and DTO id
  becomes a string. All `strconv.Atoi(entityID)` parsing disappears.
- **Soft-delete filtering disappears.** Legacy queries implicitly added
  `deleted_at IS NULL`; targets simply do not delete softly, so query results are
  identical for any database that was never soft-deleted.
- `RechargeLog.Status` was an HTML label (`<span class="label label-success">success</span>`).
  It becomes an enum: `pending` / `success` / `failed` / `invalid`. The Flutter UI
  renders the badge; the stored value is data, not markup.
- `time.Duration` stays an `int64` nanosecond count, so all duration arithmetic
  (validity, delete grace period, uptime accumulation) is bit-identical.
- `User.UUID` stays a UUID string (legacy `gofrs/uuid`, unique).

### Indexes (replacing GORM's `gorm:"index"`)

| Collection | Index |
|---|---|
| `users` | `name`, `email`, `uuid` (unique) |
| `wareEntities` | `userId` |
| `wareKeys` | `specId` |
| `orders` | `userId` |
| `messages` | `receiverId` |
| `rechargeLogs` | `userId`, `outTradeNo` |
| `rechargeKeys` | `keyString` |
| `workOrders` | `userId` |
| `galleryItems` | `userId` |
| `pterodactylPasswords` | `userId` |

Index creation happens once in `store.EnsureIndexes()` at startup and is idempotent.

### Deleted-by-design

- `PEAdminSetting` — never read or written by legacy code.
- `SqlTablePrefix` — meaningless without MySQL tables.

---

## 6. Caching and concurrency

Unchanged in behaviour, retargeted to the new packages:

- **Pterodactyl API layer** keeps `gcache` (ARC, 128 entries, 1–3 min TTL) with
  the same key shapes `NEST<id>`, `NEST<id>EGG<id>`, `ALLEGGS<nestID>`, `SERVER<id>`,
  and the same capacity-4 channel semaphore limiting concurrent panel requests.
- **Controller-layer package variables** (`wares1/2/3`, `entityMap`, `EggsMap`)
  become a `service.Cache` struct guarded by a `sync.RWMutex` and rebuilt by
  `RefreshWareInfo()` / `RefreshServerInfo()` / `CacheNeededEggs()`. Handlers only
  read from it; the cron only writes it. This removes the legacy data race.
- **Redis** keeps every existing key family, including the rate limiters
  `RENEW<entityID>`, `REINSTALL<userName>`, `WORKORDER<userName>`, and gains only
  the new `JWTBLACKLIST:<jti>` family from §4. Replacements for captcha are plain
  Redis counters keyed per action + per user/IP.

---

## 7. Configuration

Same TOML file and key names, minus `MYSQL*`, `SqlTablePrefix`, `Language`.

- `config.Init()` creates `conf/settings.toml` from the embedded default when
  missing. Unlike legacy it **does not `os.Exit(1)`** — it continues with the
  generated defaults and logs a warning, so a container can boot unattended.
- `config.Reload()` re-reads the file, trims trailing `/` from `WebHostName` and
  `PterodactylHostname`, rewrites the file, and rebuilds the Alipay client.
  Called by the settings service after a save, followed by `store.Reset()` so
  Mongo and Redis reconnect with the new values.
- New settings keys are `MongoURI` and `MongoDatabaseName`.
- The admin settings **schema** (which keys exist, their labels and input types)
  is served as JSON from the settings service, so the Flutter admin page renders
  the form generically instead of duplicating 33 field definitions.

---

## 8. Deployment

The Go binary serves the Flutter build output. Same origin ⇒ no CORS, no cookies,
one container, one port.

```
docker-compose.yml
  mongo   (mongo:7)      volume mongo-data
  redis   (redis:7)      volume redis-data
  peo     (build)        port 8080, depends_on mongo+redis, mounts conf/
```

`server` embeds `flutter/build/web` (or serves it from disk in dev) and registers:

- `/api/v1/...` → REST handlers
- `/healthz` → liveness (Mongo ping, Redis ping, Pterodactyl reachability)
- everything else → `index.html` (SPA fallback) with static assets served first

The legacy Beego admin server on port 8088 is **not** carried over; `/healthz`
plus structured logs replace it.

`/api/v1/alipay/notify` is the only public, unauthenticated mutation endpoint, and
it verifies the Alipay signature exactly as legacy did.

---

## 9. Frontend

Flutter Web compiled to WASM. Desktop/mobile are out of scope but nothing in the
architecture prevents adding them later — the app depends only on `Dio` + `web`
APIs that have cross-platform equivalents.

- **State**: `flutter_bloc` — one Bloc/Cubit per feature area.
- **Routing**: `go_router`, with a redirect guard reading the auth Cubit, and a
  separate `/admin` branch gated on `isAdmin`.
- **HTTP**: `Dio` with an interceptor that attaches the Bearer token, and an
  error interceptor that maps `401` → logout + redirect to `/login`.
- **Models**: `freezed` + `json_serializable`, one file per DTO, mirroring
  `docs/API.md` exactly.
- **Token storage**: `shared_preferences` (WASM-compatible) — not `flutter_secure_storage`,
  which has no WASM backend.

Page inventory (full parity with the 30 legacy templates):

| Area | Pages |
|---|---|
| Public | shop (`/`), gallery, terms, login, register, register confirm, forgot password |
| User | console (server list), order detail + pay, renew, reinstall, recharge, messages, settings, work orders |
| Admin | dashboard, users, orders, keys, gallery review, work orders, settings, new/edit ware |

---

## 10. What is deliberately *not* changing

- Payment provider and flow (Alipay face-to-face + QR), including the exact
  `OutTradeNo` / `Code` conventions used for idempotency.
- Pterodactyl Application API endpoints, request bodies and the panel-side
  password bootstrap (`PterodactylPassword`, default = username).
- The delete state machine: expiry → suspend + email → +10 days → `DeleteConfirm`
  → admin confirms → delete.
- The trial path: a 3-day `ValidDuration` spec is priced at 1 and only reachable
  via direct order creation, never listed.
- Discount arithmetic: `0.01 * (100 - Discount) * Price`, disabled entirely when
  `TotalDiscount` is false.
- Redis key families and rate-limit semantics.
- Email triggers and templates.

## 11. Accepted behaviour fixes

These are corrected because the rewrite touches the exact lines involved. Each is
called out so it is a decision, not an accident.

1. `cryptoo.DeleteOutdatedKeys()` reused the wrong slice variable during recharge
   key cleanup; the port cleans the correct set.
2. `email.ConfirmKey()` looked up the user by the confirmation record's own
   primary key instead of `UserID`; the port uses `UserID`.
3. `pterodactyl.NewClient` discarded the result of `strings.TrimRight`, so a
   trailing slash survived into URLs; `config.Reload()` already normalises this,
   and the new client additionally trims defensively.
4. `email.sendConfirmMail` panicked on SMTP failure; the port returns an error.
5. The controller-level caches were written from request handlers without
   synchronisation; the port serialises them behind a mutex.
