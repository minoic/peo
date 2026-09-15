# peo architecture

This document explains **how** the system described in [`AGENTS.md`](../AGENTS.md)
is built. `AGENTS.md` is the frozen specification and the single source of truth;
where the two disagree, `AGENTS.md` wins and this file is wrong.

| Document | Answers |
|---|---|
| [`ARCHITECTURE.md`](./ARCHITECTURE.md) | How is it built, why, and what are the trade-offs? |
| [`API.md`](./API.md) | What does the REST surface look like? |
| [`CONTRACT-ROUTES.md`](./CONTRACT-ROUTES.md) | The exact route table and its middleware bindings. |
| [`CONTRACT-DATA.md`](./CONTRACT-DATA.md) | Documents, fields, collections and indexes. |
| [`PLAN.md`](./PLAN.md) | Where did the rewrite get to, and what is left? |

---

## 1. What changed, and what did not

| Aspect | Legacy (`legacy/`) | Target |
|---|---|---|
| HTTP framework | Beego v2 MVC | Gin |
| Response format | server-rendered Go templates | JSON only |
| Frontend | 30 `.html` templates + static assets | Flutter Web, compiled to WASM |
| Data store | jinzhu/gorm v1.9.16 + MySQL | MongoDB via `go.mongodb.org/mongo-driver/v2` |
| Cache / rate limits / sessions | Redis | Redis, **unchanged** |
| Business rules | `legacy/internal/{orderform,pterodactyl,cryptoo,email,message,status}` | ported to `internal/service`, behaviourally identical |
| i18n | `beego/i18n`, 3 locales | removed, English only |
| Captcha | `beego/captcha` | removed, replaced by Redis rate limiting |
| Admin diagnostics | a second Beego HTTP server on port 8088 | `GET /healthz` + `GET /api/v1/admin/health` |

The rewrite is a **transport and storage rewrite**. No rule, threshold, Redis key
name, e-mail trigger or money calculation was redesigned. Where the port touches
a line that was outright broken, the fix is listed in
[`AGENTS.md` §11](../AGENTS.md) so it is a recorded decision rather than an
accident.

---

## 2. Process shape

One container, one port, one origin. The Go binary serves both the API and the
compiled SPA, which is why there is no CORS surface in production and no cookie
domain juggling for ordinary API traffic.

```
                    +-------------------------------------------+
   browser  ----->  |  peo  (Go, :8080)                         |
                    |                                           |
                    |  /api/v1/...   Gin handlers -> service     |
                    |  /healthz      liveness probe              |
                    |  everything    embedded Flutter bundle,    |
                    |  else          index.html SPA fallback     |
                    +----------------+--------------------------+
                                     |
                    +----------------+----------------+----------------+
                    |                                 |                |
                 MongoDB                            Redis          Pterodactyl
              (business data)          (cache, rate limits, JWT      Application
                                        blacklist)                     API
```

The only public unauthenticated mutation endpoint is
`POST /api/v1/alipay/notify`, which verifies the Alipay signature exactly as the
legacy code did. `/healthz` is outside the API prefix and returns a bare object
rather than the standard envelope; it is consumed by the container healthcheck,
not by the SPA. Both `/healthz` and `GET /api/v1/admin/health` call the same
`service.Admin.Health`, so the two diagnostics cannot disagree about whether a
component is up.

---

## 3. Server package layout

```
server/
├── cmd/peo/main.go          config -> store -> cron -> router -> listen -> shutdown
├── web/                     //go:embed all:assets  (the compiled SPA)
├── conf/settings.toml       generated on first run from the embedded default
└── internal/
    ├── config/              viper + TOML, Alipay client, Reload()
    ├── models/              BSON document structs, collection names
    ├── store/               repository layer, one type per collection
    ├── auth/                JWT issue/verify, password hashing, blacklist key
    ├── middleware/          auth, admin, CORS, recovery, logging
    ├── apierr/              error vocabulary + response envelope
    ├── buildinfo/           version/build metadata, filled by -ldflags
    ├── redis/               lazily connected client + Limited() rate limiter
    ├── service/             business logic, transport agnostic
    │   ├── pterodactyl/     Application API client, gcache layer, semaphore
    │   ├── status/          Minecraft TCP ping
    │   ├── email/           SMTP + templates
    │   ├── cryptoo/         product keys and recharge keys
    │   ├── message/         in-site messages
    │   └── random/          key/token generation
    ├── api/                 Gin handlers (decode -> service -> encode)
    │   ├── router.go        the whole route table
    │   ├── static.go        SPA asset server + fallback
    │   ├── response.go      re-export of apierr for handler ergonomics
    │   ├── dto/             the wire contract
    │   └── handlers/        12 handlers, 67 endpoints
    └── cron/                robfig/cron registration
```

### Layer rules

These are enforced by convention, by the import graph, and by
[`layers_test.go`](../server/internal/api/layers_test.go). Violating one usually
produces an import cycle rather than a subtle bug, but a cycle only fires when the
violation is *mutual*; a one-way reach across a boundary compiles fine, so the
four mechanically decidable rules are asserted directly:

1. **`api` never touches `store` or the Mongo driver.** A handler decodes a DTO,
   calls `service`, and encodes the result. Nothing else.
2. **`store` returns `models` structs and typed errors only** (`store.ErrNotFound`).
   No `bson.M` escapes the package.
3. **`service` never imports `http` or `gin`.** It takes plain inputs and returns
   plain outputs plus an `*apierr.Error` carrying the HTTP status to use.
4. **`middleware` is the only place that reads the `Authorization` header.**
   Handlers ask `middleware.UserID(c)` instead of parsing tokens.
5. **`config` is read through accessor helpers.** `Reload()` swaps the whole viper
   instance under a mutex, so a runtime settings save cannot race a reader.

Rule 3 permits `net/http`: `service/pterodactyl` *is* an HTTP client, and the rule
forbids the transport framework, not the standard library's client types. Rule 4
forbids *reading* the caller's header; `service/pterodactyl` setting an outbound
`Authorization` on its own request to the panel is not the same act.

#### The `models.ObjectID` alias and rule 1

`models.ObjectID` is an alias (`type ObjectID = bson.ObjectID`), not a defined
type. That distinction is what makes rule 1 mechanically checkable: `idParam`
returns `models.ObjectID`, so the handler layer can name an identifier type
without importing the driver, and because it is an alias every call site stays
source-compatible with the driver's own type. A *defined* type would have forced
a conversion at each of the twenty-odd call sites and made the boundary noisy
enough that people would route around it.

The same reasoning explains `middleware.UserID(c) bson.ObjectID`: `middleware` is
allowed to import both `store` and the driver (rule 1 constrains only `api`), and
its return type lands in handlers that are not.

### Why `apierr` exists

The error vocabulary started inside `internal/api`. That produced a cycle:
`middleware` needs the error envelope, `api/router.go` needs `middleware`, and the
services need the error codes. Moving the vocabulary into the leaf package
`internal/apierr` broke the cycle. `internal/api/response.go` is a thin re-export
so handlers keep writing `api.Fail(...)` while the dependency points one way.

### Why `dto` exists and where it stops

`internal/api/dto` holds every request and response body. Two reasons:

- The Flutter client mirrors these types field for field, so the contract is
  readable in one directory, and a rename is a compile error on both sides.
- Handlers translate a DTO into plain service arguments, which keeps DTO types
  out of `service` and `store` entirely.

The rule has one deliberate exception: some wire shapes are produced by the
service layer because both the user and the admin consoles must agree on them
(`service.WorkOrderItem`, `service.GalleryItem`, `service.ProductCard`,
`service.Status`, `service.AdminProduct`). Duplicating those in `dto` would let
the two consoles drift. `dto` therefore wraps them in envelopes rather than
redefining them.

---

## 4. Authentication

The legacy scheme was a Beego encrypted cookie carrying three session keys.
Those are gone; the trust model is otherwise unchanged.

- **Login** — `POST /api/v1/auth/login` returns
  `{accessToken, expiresAt, user}`. The token is a JWT signed with the key that
  is hardcoded in `legacy/internal/session/auth_jwt.go`, kept so tokens and the
  signing scheme do not change. `JWTSecret` in the config can override it.
- **Transport** — `Authorization: Bearer <token>`.
- **Claims** — `sub` is the Mongo ObjectID hex (replacing the legacy `ID`
  session key), `name` replaces `UN`, `admin` mirrors `isAdmin`.
- **Validity** — reproduces the legacy `session.Logged()`: the signature must
  verify **and** the referenced user document must still exist. A deleted user is
  rejected even with a perfectly valid token. This is why `middleware.Auth()`
  re-reads the user on every request instead of trusting the claims.
- **Logout** — `POST /api/v1/auth/logout` writes the token id into Redis under
  `JWTBLACKLIST:<jti>` with the token's remaining lifetime. Every authenticated
  request checks that key. `OptionalAuth()` does not check it, because it only
  needs to know whether to personalise a public response.
- **Password** — `md5(plaintext + DatabaseSalt)`, hex encoded, identical to
  legacy. Not upgraded to bcrypt: that is a behaviour change and out of scope.
- **Admin** — the user document's `isAdmin` flag, checked by `middleware.Admin`.

Token lifetimes are unchanged: 24 hours normally, 60 days when `remember` is set.

`X-Auth-*` headers are gone.

---

## 5. Data model

14 GORM models became 13 Mongo collections. `PEAdminSetting` is dropped: no
legacy code path ever read or wrote it.

| Legacy | Target |
|---|---|
| `ID uint` auto-increment | `_id ObjectID` |
| `CreatedAt` / `UpdatedAt` | `createdAt` / `updatedAt`, stamped by the repository |
| `DeletedAt *time.Time` soft delete | dropped, deletes are hard |
| foreign keys (`UserID`, `SpecID`, `WareID`, `ReceiverID`) as `uint` | `bson.ObjectID` |
| `template.HTML` / `template.URL` columns | plain `string` |
| `RechargeLog.Status` as a rendered badge | the enum `pending` / `success` / `failed` / `invalid` |

Two consequences worth internalising:

- **Every identifier in the API is a 24-character hex string.** `strconv.Atoi`
  parsing of entity ids is gone; boundaries use `models.ObjectIDFromHex`.
- **Soft-delete filtering is gone.** Every legacy query silently appended
  `deleted_at IS NULL`. Since nothing is soft-deleted any more, results are
  identical for a database that was never soft-deleted, and simpler for one that
  was — dropping the filter is what the legacy code effectively did anyway.

`time.Duration` stays an `int64` nanosecond count, so all duration arithmetic
(product validity, delete grace period, accumulated uptime) is bit-identical.
`User.UUID` stays a unique UUID string.

Field-level detail, the ten mandated indexes and the extra indexes the port adds
live in [`CONTRACT-DATA.md`](./CONTRACT-DATA.md).

---

## 6. Caching and concurrency

The legacy code cached panel responses in a `gcache` and, separately, cached the
product catalogue and the Minecraft probe results in **package-level variables
written from request handlers**. That was a data race.

The port keeps the panel cache exactly as it was and moves the other two behind
proper ownership:

- **Pterodactyl client layer** — `gcache` (ARC, 128 entries, 1–3 minute TTL) with
  the original key shapes `NEST<id>`, `NEST<id>EGG<id>`, `ALLEGGS<nestID>`,
  `SERVER<id>`, and a capacity-4 channel semaphore bounding concurrent panel
  requests. Unchanged.
- **`service.Cache`** — a struct guarded by a `sync.RWMutex` holding the probe
  results. **Handlers only read; the cron only writes.** Both accessors are
  nil-receiver safe, so a zero-value service cannot panic.
- **`ProductService`** — its own `sync.RWMutex` plus a `sync.Map` for the per-nest
  egg cache. Rebuilt by the cron, read by handlers; `Storefront` also builds once
  if it is asked for a catalogue before the first cron tick, so a cold process
  never serves an empty shop. That warm-up path takes the write lock like any
  other rebuild, which is what keeps it safe rather than privileged.
- **Redis** — every existing key family is preserved, including the rate limiters
  `RENEW<entityID>`, `REINSTALL<userName>`, `WORKORDER<userName>` and
  `RECHARGE_DELAY<userName>`, and gains only `JWTBLACKLIST:<jti>`. Captcha is
  replaced by plain Redis counters keyed per action and per user or IP.

This is [accepted behaviour fix #5](../AGENTS.md): the race is gone, and the
observable behaviour is unchanged because the caches were only ever populated by
the cron in practice.

### Redis key families

Two kinds of key are stored: **throttle keys** whose value is irrelevant (only
existence is tested) and **code keys** whose value is a mailed numeric code.

| Family | Key | Value | TTL | Source |
|---|---|---|---|---|
| Renew throttle | `RENEW<entityIdHex>` | `1` | 10 s | `user_console_controller.go:245` |
| Reinstall throttle | `REINSTALL<userName>` | `1` | 10 s | `user_console_controller.go:382` |
| Ticket throttle | `WORKORDER<userName>` | `1` | 10 s | `user_work_order_controller.go:46` |
| Recharge throttle | `RECHARGE_DELAY<userName>` | `1` | 3 s | `user_recharge_controller.go:67` |
| Password reset code | `FORGET:<email>` | 6-digit code | 30 min | `forget_password_controller.go:79` |
| E-mail change code | `CHANGE_EMAIL<newEmail>` | 6-digit code | 30 min | `user_settings_controller.go:144` |
| E-mail change owner | `CHANGE_EMAIL_PENDING:<newEmail>` | user ObjectID hex | 30 min | new — see below |
| Login throttle | `LOGIN<login>` | `1` | 1 min | new — replaces the captcha |
| Register throttle | `REGISTER<name>` / `REGISTER_IP<ip>` | `1` | 10 min / 1 h | new — replaces the captcha |
| Token blacklist | `JWTBLACKLIST:<jti>` | `1` | token lifetime | §4 |

Only the throttle keys are pure counters whose stored value is ignored; the two
code keys carry the mailed code as their value, which is the legacy shape.

Four deliberate deviations from legacy, all narrower than they look:

- **`FORGET:<email>` lives 30 minutes, not 1.** Legacy reused one 1-minute key as
  both the reset code and its resend throttle
  (`forget_password_controller.go:72` skips sending when the key exists), so the
  code expired before a user could realistically type it. The port keeps the
  "cannot resend while the code is alive" rule and only moves the deadline.
- **`CHANGE_EMAIL<newEmail>` lives 30 minutes, not 1,** for the same reason
  (`user_settings_controller.go:137` is the identical guard).
- **The mailed code is 6 digits, produced by `random.Digits`.** Legacy delegated
  to the same captcha generator it used for the on-screen challenge; removing the
  challenge removes the generator, so the port keeps the numeric-code contract the
  e-mail template renders but no longer seeds a Redis captcha pair.
- **A code key is released when the mail cannot be sent.** Legacy wrote the key
  before sending and then ignored the send failure (`mail_manager.go:48` returned
  `"", nil`), so the address stayed throttled for the key's whole lifetime against
  a code the user had never received. `ForgetPassword` and `ChangeEmail` now call
  `redis.Release` on the write they had just made, which is what that helper
  exists for. Anything that fails after a *successful* send still leaves the key
  in place, so the throttle is unchanged on the happy path.

`CHANGE_EMAIL_PENDING:<newEmail>` has no legacy counterpart and exists only
because the confirm call must name the address it is confirming: legacy
identified the pending address from the session, while the JSON API's
`POST /user/email/confirm` carries `{email, code}` and therefore needs the
address→owner binding checked server-side. It stores the requesting user's id
so a code obtained by one account cannot confirm another account's address.

Legacy stored the mailed code under the *address*, not under the account, and
the port keeps that shape: an address's code is not keyed by who asked for it.### The Minecraft probe

Status polling used to ping every server inside the request, so a five-server
console page waited on five TCP handshakes. The port probes on a 30-second cron
into `service.Cache` and answers `/servers/status` from cache. Cache entries age
out at `probeCacheTTL` (30 s), and probing is bounded to 16 workers.

---

## 7. Configuration

The same TOML file with the same key names, minus `MYSQL*`, `SqlTablePrefix` and
`Language`, plus `MongoURI` and `MongoDatabaseName`.

- `config.Init()` creates `conf/settings.toml` from the embedded default when it
  is missing. Unlike legacy it **does not exit** — it logs a warning and
  continues with the generated defaults, so a container can boot unattended.
- `config.Reload()` re-reads the file, trims a trailing `/` from `WebHostName`
  and `PterodactylHostname`, writes the file back, rebuilds the Alipay client and
  swaps the viper instance under a mutex.
- `config.Save()` = write + reload. The settings service calls it after a save and
  then calls `store.Reset()` / `store.Init()` and `redis.Reset()` so the
  datastores reconnect with the new values.

The admin settings form is **generated from a server-side schema**. `/admin/settings`
returns a list of `{key, label, description, type, value}` and the Flutter admin
page renders inputs from it. This replaces 33 hand-written template fields and
means the form and the persistence layer cannot drift apart.

The default `MongoURI` and `RedisHost` are `mongodb://mongo:27017` and
`redis:6379` — the compose service names — so an unconfigured container works.

---

## 8. Serving the SPA

`internal/api/static.go` implements a dual-source asset server:

1. The embedded bundle wins. `server/web/embed.go` does
   `//go:embed all:assets` and returns a sub-FS only if `assets/index.html`
   exists. The image build copies `flutter/build/web` into `web/assets`.
2. Otherwise it falls back to disk at `WebRoot` (default `web`), which is the
   development path: `go run ./cmd/peo` against a locally built bundle.
3. If neither source has an `index.html`, the server answers **404**, never an
   empty 200, so a misconfigured deployment fails loudly instead of showing a
   blank page.

Requests under `/api/` and `/healthz` always get the JSON 404 envelope instead of
`index.html`, so a mistyped API path is diagnosable. Everything else falls back to
`index.html` for client-side routing.

Path traversal is defended by `path.Clean("/" + trimPrefix(urlPath, "/"))` before
the leading slash is stripped, which collapses `..` segments; `fs.FS` additionally
rejects non-relative names. MIME types are set explicitly from a table rather than
left to the host, because `.wasm` and `.symbols` are not universally registered.
`index.html` is served `no-cache` and every other asset `public, max-age=3600`.

---

## 9. Frontend

Flutter Web compiled with `--wasm`. Desktop and mobile are out of scope, but
nothing here prevents adding them: the app depends only on `Dio`, `go_router`,
`flutter_bloc` and `shared_preferences`, all of which have cross-platform
implementations.

- **State** — `flutter_bloc`, one Bloc or Cubit per feature area.
- **Routing** — `go_router` with a redirect guard reading the auth Cubit, and a
  separate `/admin` branch gated on `isAdmin`.
- **HTTP** — `Dio` with a request interceptor attaching the bearer token and an
  error interceptor mapping `401` to logout plus a redirect to `/login`.
- **Models** — `freezed` + `json_serializable`, one file per DTO, mirroring
  [`API.md`](./API.md).
- **Token storage** — `shared_preferences`. Not `flutter_secure_storage`, which
  has no WASM backend.

The bootstrap request is `GET /api/v1/site/config`. It returns site identity,
feature switches and — for a signed-in visitor — `loggedIn`, `isAdmin` and the
unread message count, so the shell can build its navigation from one call. This
replaces the legacy `handleNavbar` helper that every template invoked.

---

## 10. Build and deployment

Three-stage image (`server/Dockerfile`):

| Stage | Base | Does |
|---|---|---|
| `web` | `debian:bookworm-slim` | Downloads the pinned Flutter SDK, verifies its SHA-256, `pub get`, `build_runner`, `flutter build web --wasm --release` |
| `build` | `golang:1.27.1-alpine` | `go mod download`, copies `server/`, copies the SPA from stage 1 into `web/assets/`, statically links `./cmd/peo` |
| `runtime` | `debian:bookworm-slim` | `ca-certificates` + `tzdata`, the binary, `VOLUME /conf`, `EXPOSE 8080`, healthcheck on `/healthz` |

The official Flutter SDK is downloaded from the release manifest rather than taken
from `ghcr.io/cirruslabs/flutter`, because that image does not publish the pinned
version. The tarball's SHA-256 is verified in the Dockerfile, so the build fails
closed if upstream ever serves something else.

`docker-compose.yml` brings up `mongo:7`, `redis:7-alpine` and `peo`, with
healthcheck-gated `depends_on` so the server never starts against a datastore that
is still booting. `./conf` is bind-mounted so settings survive a container
rebuild.

`make` targets wrap all of this; run `make help`.

---

## 11. Deliberate divergences from the spec

Recorded so that a reader comparing `AGENTS.md` against the tree knows which
differences are decisions.

| # | Spec says | Reality | Why |
|---|---|---|---|
| (b) | `service/order/`, `service/gallery/`, `service/settings/` sub-packages | those three are flat files in `service/` | They share `Pricing`, `ProductCard` and error helpers with the rest of the service layer; splitting them would need an extra shared package for no gain in cohesion. `pterodactyl`, `status`, `email`, `cryptoo`, `message` and `random` **are** separate packages as specified. |
| (e) | back-office product form field for field | `ProductInput` has no `startup` member | The legacy form had a startup box whose value never reached the database — the Pterodactyl create call always derives the command from the egg. Resurrecting a dead field was worse than omitting it. |
| (f) | — | `AdminService.InvalidateServer` does a second Mongo read | Kept because the delete-confirm handler is also reachable when the entity was already removed by the cron; the read is the cheapest way to distinguish "done" from "gone". |
| (j) | gallery guarded by `AlbumEnabled` | gallery routes are registered unconditionally; the client hides the UI when the switch is off | A 404 from the router cannot be distinguished from a missing route while debugging, and Gin refuses to register a wildcard child conditionally without restructuring the tree. |
| (k) | — | there is no `internal/logging` package | The spec's own package tree (§3) does not list one. `github.com/minoic/glgf` already provides file/std/both writers, per-level routing, JSON mode and HTTP middleware, so a wrapper would be a second name for the same thing. |
| (l) | the `FORGET` key lifetime | `FORGET:<email>` lives 30 minutes, not 1 | Legacy reused one 1-minute key as both the reset code and its own resend throttle, so the code expired before a user could realistically type it. The throttle rule is kept; only the deadline moved. See §6. |
| (m) | the `CHANGE_EMAIL` key lifetime | `CHANGE_EMAIL<newEmail>` lives 30 minutes, not 1 | Same reason and same guard (`user_settings_controller.go:137`). See §6. |
| (n) | — | an extra `CHANGE_EMAIL_PENDING:<newEmail>` key holds the requesting user's id | Legacy identified the pending address from the session, so the code key needed nothing else. The JSON confirm call carries `{email, code}` and has no session-address to compare against, so the address→owner binding is stored server-side; without it any account could confirm an address it does not own. See §6. |
| (o) | — | `SendCaptcha` reports send failures to its caller | Legacy `mail_manager.go:48` returned `"", nil` after `msg.Send` failed, so `forget_password_controller.go:75` and `user_settings_controller.go:140` believed a mail had gone out and wrote the code key anyway — with a code the user never received, and no way to request another for the key's whole lifetime. The port returns the error so the caller can tell the user, and both callers release the key they had just written. |
| (p) | — | `SendAnyEmail` concatenates its fragments instead of `fmt.Sprint`ing them | Legacy `mail_manager.go:59` called `fmt.Sprint(text)` on a `[]string`, which renders as `[a b c]`, so every work-order and expiry notification arrived wrapped in square brackets and separated by spaces. `message.Compose` and `email.joinText` both join with `""`, which is what the callers' fragments were written for. |
| (q) | registration confirmation mail | still not sent, but the code is now readable | Legacy `email.ConfirmRegister` (`legacy/internal/email/mail_confirm.go:29`) had no caller, so the confirmation-mail path was dead and accounts were confirmed by hand; `legacy/AGENTS.md:97` records this. The port deliberately keeps the behaviour — `IssueRegistrationKey` likewise has no caller — and `POST /api/v1/auth/confirm-email/:key` still works for a token inserted by hand. Only the misleading "wired up again" comments were corrected. |
| (r) | — | `IssueRegistrationKey` deletes its token when the mail cannot be sent | The legacy version created the row then called `sendConfirmMail`, which **panicked** on a connect failure (`mail_manager.go:17`) and left the row behind. A failed send now leaves no orphan token. Unreachable in production for the same reason as (q), but correct if the path is ever switched on. |
| (s) | panel password follows the site password | `ChangePassword` skips the panel call when `PteUserCreated` is false, instead of failing afterwards | Legacy called `pterodactyl.ChangePassword(user.Name, newPassword)` unconditionally, so a customer who had never got a panel account (a registration that raced a panel outage) had their site password committed and were then shown "未能成功更改翼龙面板密码" — an error they could never clear, because every retry hit the same missing account. The port keeps legacy's ordering and its error, but only when there is an account to rotate; otherwise the change simply succeeds. The `pterodactylPasswords` row is upserted on success, because `PterodactylSession` authenticates the console hand-off with it. |
| (t) | panel account is created at registration confirmation | `ConfirmRegistration` reports the panel outcome instead of creating the account | Legacy registered the account immediately but only created the panel mirror in `MailConfirm` (`reg_controller.go:154`), so a customer could not buy until they clicked the mailed link. The port creates the panel account in `Register` so purchase works straight away, which means `ConfirmRegistration` must not repeat the call — the panel rejects a duplicate username. It then sends the same `pterodactyl_account_success_tips` / `pterodactyl_account_failed` text legacy did (`:163`, `:171`), so the customer's inbox is unchanged. |
