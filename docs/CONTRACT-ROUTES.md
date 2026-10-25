# Route Contract

Status: **frozen**. This file and [`API.md`](./API.md) describe the same surface.
`API.md` documents payloads; this file documents the *routing table itself* — which
paths exist, which middleware guards them, and which of them are pinned by a test.

The authoritative source is
[`server/internal/api/router.go`](../server/internal/api/router.go). The contract is
enforced by [`server/internal/api/router_test.go`](../server/internal/api/router_test.go),
which asserts that every path below is registered with the expected method, and that
the removed captcha routes are **not** registered.

---

## 1. Why a separate route contract

The Flutter client generates its `Dio` calls from a hand-written API layer, so a path
typo is a runtime 404 rather than a compile error. Pinning the table in a test means a
renamed route breaks `go test ./internal/api/...` instead of shipping a dead client.

The test is deliberately a *list equality* check over the paths that exist, not a
snapshot of Gin's internal radix tree. Gin's tree shape is an implementation detail;
the set of `(method, path, handler-name)` triples is the contract.

---

## 2. Global middleware

Applied to the whole engine, in this order, before any route:

| Order | Middleware | Purpose |
|---|---|---|
| 1 | `middleware.Recovery()` | Turns a panic into a `500` `internal_error` envelope and logs the stack. |
| 2 | `middleware.Logger()` | One structured line per request. |
| 3 | `middleware.CORS(config.CORSOrigins)` | Emits CORS headers only when `CORSOrigins` is configured. |

`CORSOrigins` is empty by default, and it *should* stay empty in production: the Go
binary serves the Flutter bundle from the same origin (spec §8), so no cross-origin
request is ever made. The middleware exists for `flutter run -d chrome` during
development, where the dev server and the API differ in port.

Note that no middleware inspects the `Authorization` header here. That is layer rule 4
of spec §3 — the header is read in exactly one place, `middleware.Auth()`.

---

## 3. Middleware bindings

Every route belongs to exactly one of three groups. Each group is created with
`api.Group("/")` rather than `api.Group("")`, so the paths below are **absolute from
`/api/v1`**, not relative to a longer prefix.

### 3.1 `OptionalAuth()`

Populates the request context with the caller when a valid token is present, and
continues anonymously when it is absent, invalid, revoked, or the Redis revocation
check fails. Used by public pages whose *content*
changes for a logged-in visitor — the shop header, for instance, shows the unread
message count.

A route in this group must never assume a user exists.

### 3.2 `Auth()`

Rejects invalid sessions with a `401` `unauthorized` envelope unless all of the following
hold:

1. the header is `Authorization: Bearer <token>`;
2. the JWT signature verifies against the installation's configured `JWTSecret`
   (empty and formerly public fallback secrets are rejected);
3. the `jti` is **not** present in Redis under `JWTBLACKLIST:<jti>`;
4. the user document referenced by `sub` still exists.

Condition 4 is the legacy `session.Logged()` rule: a valid token for a deleted user is
still rejected. Condition 3 is new, and is what makes `POST /auth/logout` meaningful
for a stateless token.

A Redis revocation-query failure returns `500 internal_error` rather than
accepting a token whose revocation status cannot be established. On first startup
with an empty or formerly public secret, a random key is persisted atomically;
tokens signed using the old key must be replaced by logging in again.

### 3.3 `Auth()` + `Admin()`

As above, plus the `isAdmin` flag on the user document must be true. Otherwise `403`
`forbidden`.

`Admin()` is applied *after* `Auth()` in the same chain, never instead of it, so an
anonymous request to an admin path answers `401` and a non-admin answers `403`. That
distinction is visible to the client and the Flutter router relies on it.

---

## 4. Public routes — `OptionalAuth()`

```
GET    /api/v1/site/config
GET    /api/v1/site/storefront
GET    /api/v1/products/:specId
GET    /api/v1/nests/:nestId/eggs
POST   /api/v1/auth/login
POST   /api/v1/auth/register
GET    /api/v1/auth/confirm-email/:key
POST   /api/v1/auth/forget-password
POST   /api/v1/auth/reset-password
POST   /api/v1/alipay/notify
GET    /api/v1/gallery
```

Ten of the eleven answer the standard JSON envelope. **`POST /api/v1/alipay/notify` does
not** — see §7.

`GET /api/v1/site/config` is the bootstrap call: it reports `loggedIn`, `isAdmin` and
`unread` so the SPA can render its shell before it has a token. It is the reason this
group needs `OptionalAuth` rather than no middleware at all.

`GET /api/v1/product…` paths use **`specId`, the product specification id**, not a
ware id. A ware is a product line and a spec is one priced configuration of it; the
shop lists specs. The client never sees ware ids.

`GET /api/v1/gallery` is also public: anonymous visitors receive approved items.
The route remains registered regardless of `AlbumEnabled`; Flutter hides the
feature UI when that switch is off, but the public API read is unchanged.

---

## 5. Authenticated routes — `Auth()`

### Session and account

```
POST   /api/v1/auth/logout
GET    /api/v1/auth/me
PUT    /api/v1/user/password
PUT    /api/v1/user/email
POST   /api/v1/user/email/confirm
POST   /api/v1/user/pterodactyl-user
```

`PUT` is used for the two account mutations because both are idempotent replacements
of a field. There is no `PATCH`.

### Orders

```
POST   /api/v1/orders
GET    /api/v1/orders
GET    /api/v1/orders/:id
GET    /api/v1/orders/:id/allocations
POST   /api/v1/orders/:id/pay
POST   /api/v1/orders/:id/pay-by-balance
```

Expired orders remain accessible through the order routes for history. Their
payment endpoints reject attempts after the 15-minute payment window.

`GET /orders/:id/allocations` is served by the **product** handler, not the order
handler, because it proxies the Pterodactyl allocation list for the order's egg. It
lives under the order path because it is scoped to one order.

### Servers

```
GET    /api/v1/servers
GET    /api/v1/servers/status
GET    /api/v1/servers/:id
POST   /api/v1/servers/:id/renew
POST   /api/v1/servers/:id/renew-by-balance
POST   /api/v1/servers/:id/reinstall
POST   /api/v1/servers/:id/delete
GET    /api/v1/servers/:id/console
GET    /api/v1/servers/:id/resources
POST   /api/v1/servers/:id/power
POST   /api/v1/servers/:id/command
POST   /api/v1/servers/:id/terminal-ticket
GET    /api/v1/servers/:id/terminal (Origin + one-time ticket; no Bearer middleware)
GET    /api/v1/servers/:id/files
POST   /api/v1/servers/:id/files/read
PUT    /api/v1/servers/:id/files/write
POST   /api/v1/servers/:id/files/:action
GET    /api/v1/servers/:id/files/download
PUT    /api/v1/servers/:id/files/upload
GET    /api/v1/servers/:id/backups
POST   /api/v1/servers/:id/backups
GET    /api/v1/servers/:id/backups/:backupId/download
POST   /api/v1/servers/:id/backups/:backupId/:action
DELETE /api/v1/servers/:id/backups/:backupId
GET    /api/v1/servers/:id/startup
PUT    /api/v1/servers/:id/startup/variable
PUT    /api/v1/servers/:id/startup/image
```

`GET /servers/status` is a sibling of the `:id` wildcard. Gin allows this: a static
segment takes precedence over a parametrised one at the same depth, so `/servers/status`
resolves to the status handler and `/servers/<hex>` resolves to `:id`. Declaration order
does **not** matter — Gin's `addChild` keeps the wildcard child **last** when inserting.
That was verified against `gin@v1.12.0/tree.go` rather than assumed, because the usual
advice for other routers (register static before dynamic) does not apply.

`/servers/status` is a batch probe of every server the caller owns, and it is cached
for 30 seconds per entity. `/servers/:id` is a single server read with no probe.

`POST /servers/:id/delete` *requests* deletion; it does not delete. It advances the
delete state machine from "keep" to "notice sent". The actual removal happens after an
admin resolves the delete confirmation. This is deliberately not a `DELETE` verb,
because the request is not retractable by the user and is not idempotent in the sense
`DELETE` implies.

Console REST routes use the current entity ownership and administrator state. The
browser WebSocket endpoint is the only unauthenticated-by-Bearer route: it checks a
configured exact Origin and consumes a 30-second, single-use ticket bound to the
current login token and entity before upgrading. Panel/Wings credentials remain
server-side; file and backup signed URLs are validated and streamed through Go.

### Gallery

```
GET    /api/v1/gallery/mine
POST   /api/v1/gallery
POST   /api/v1/gallery/:id/like
DELETE /api/v1/gallery/:id
```

These authenticated routes are registered unconditionally, even when `AlbumEnabled`
is `false`. `/gallery/mine` includes pending items; submission, like, and delete
remain behind `Auth()`. The public approved-items feed is listed in §4 and is also
registered unconditionally. `SiteConfigResponse.albumEnabled` tells Flutter to hide
the feature UI; it does not change the API route table or filter the public feed.

### Messages

```
GET    /api/v1/messages
GET    /api/v1/messages/unread
POST   /api/v1/messages/:id/read
POST   /api/v1/messages/read-all
DELETE /api/v1/messages/:id
```

`/messages/read-all` is again a static sibling of `:id`. Marking one message read is a
`POST` to a sub-resource rather than a `PATCH` on the message, because the message body
is not what changes — a separate fact about it does.

In the Flutter client, the navigation `Message` entry opens the inbox in a dialog and
keeps the current page in place. The legacy `/messages` SPA path remains authenticated
and opens the same dialog before returning to the user console.

### Work orders

```
GET    /api/v1/work-orders
POST   /api/v1/work-orders
```

A user can open a work order and read their own; only an admin can close one. Closing
is under `/admin`, in §6.

### Recharge

```
GET    /api/v1/recharge/logs
POST   /api/v1/recharge/key
POST   /api/v1/recharge/alipay
GET    /api/v1/recharge/alipay/:outTradeNo
```

`POST /recharge/alipay` creates a face-to-face trade and returns a QR code as a base64
PNG. `GET /recharge/alipay/:outTradeNo` is the polling endpoint the client uses while
the QR code is on screen — it reports `pending` or `success`. The callback that
actually credits the balance arrives out of band at `/alipay/notify`.

---

## 6. Admin routes — `Auth()` + `Admin()`

```
GET    /api/v1/admin/dashboard
GET    /api/v1/admin/users
GET    /api/v1/admin/orders
GET    /api/v1/admin/products
GET    /api/v1/admin/products/raw
GET    /api/v1/admin/products/form
POST   /api/v1/admin/products
PUT    /api/v1/admin/products/:specId
DELETE /api/v1/admin/products/:specId
GET    /api/v1/admin/key-targets
POST   /api/v1/admin/keys
GET    /api/v1/admin/keys/export
GET    /api/v1/admin/delete-confirms
POST   /api/v1/admin/delete-confirms/:entityId
GET    /api/v1/admin/work-orders
POST   /api/v1/admin/work-orders/:id/close
POST   /api/v1/admin/gallery/:id/:action
GET    /api/v1/admin/settings
PUT    /api/v1/admin/settings
GET    /api/v1/admin/health
```

Notes on the ones that are not obvious:

- **`GET /admin/products` vs `GET /admin/products/raw`.** `/products` returns
  *formatted* cards for display. `/products/raw` returns the raw `AdminProduct` rows
  the edit form binds to, including the numeric `specId`-adjacent fields that the
  display shape hides. They are different shapes on purpose; the edit page needs
  values the shop page must not compute.
- **`GET /admin/products/form`** returns the **field schema**, not a product. It is
  what lets the Flutter admin page render a generic form instead of hard-coding 17
  field definitions (spec §7). The field `name`s are `snake_case` (`ware_name`,
  `node_id`, `delete_time`, `discount0`) because they mirror the legacy HTML form.
  The `PUT` body is the same vocabulary.
- **`GET /admin/keys/export`** answers a **zip**, not JSON. See §7.
- **`POST /admin/delete-confirms/:entityId`** is the human half of the delete state
  machine. `GET` lists the servers awaiting confirmation; the `POST` approves or
  rejects one. Approval deletes the Pterodactyl server and the local entity.
- **`POST /admin/gallery/:id/:action`** collapses approve and reject into one route
  with an action segment (`pass` / `delete`) rather than two routes, because the body
  and the response are identical and only the transition differs. Any other
  action returns a validation error without modifying the submission.
- **`GET /admin/settings`** returns an ordered array of `{key,label,description,type,value}`.
  **`PUT /admin/settings`** takes a flat `map[string]string` of setting values.
  A save updates the singleton `app_settings` document in MongoDB, swaps the
  in-memory configuration and rebuilds the Alipay client. Redis is reset when
  settings change. MongoDB connection settings are deployment-only environment
  variables (`PEO_MONGO_URI` and `PEO_MONGO_DATABASE_NAME`) and are excluded
  from this API. Unknown submitted keys are ignored.
  `PterodactylToken` is write-only (`secret:true`, `configured`, empty `value`);
  an empty update preserves the existing token. `ConsoleOrigins` stores exact
  additional browser origins for terminal WebSockets.

- **`GET /admin/health`** probes MongoDB, Redis, Panel API, and Panel extension, wrapped in
  the envelope and gated on admin, so the dashboard can show it without treating a
  failing dependency as an authentication problem.

---

## 7. The two non-JSON routes

Both are spoken to by something other than the Flutter app, and both would be broken by
force-fitting the envelope.

| Route | Body | Why |
|---|---|---|
| `POST /api/v1/alipay/notify` | the literal string `success` or `fail`, `text/plain` | Alipay's protocol expects exactly these two words. The SDK verifies the provider signature; PEO Bearer authentication is not required. Other public writes include login, registration and password-reset flows with their own validation. Replying with JSON breaks the callback acknowledgement protocol. |
| `GET /api/v1/admin/keys/export` | a zip archive, with `Content-Disposition: attachment; filename="peo-keys.zip"` | A download. Wrapping a binary in base64 inside an envelope would inflate it by a third for no benefit, and `Dio` on the Flutter side already handles a byte response. |

Note that `/alipay/notify` is **outside the `Auth()` group** but *inside* `OptionalAuth()`.
That is intentional: `OptionalAuth` does not reject an unauthenticated request, and it
gives the handler a user in the context if Alipay happened to include a token, which
legacy did not do. The handler does not rely on it.

---

## 8. Outside the API prefix

```
GET  /healthz
```

Registered directly on the engine, not under `/api/v1`, and **not** wrapped in the
envelope. It returns a bare object:

```json
{ "ok": true, "mongo": true, "redis": true, "pterodactyl": true }
```

When any component fails, the failing key becomes `false`, an `<name>_error` key is
added with the underlying message, and the status becomes **`503 Service Unavailable`**.
A container orchestrator can therefore use both the status code and the body.

This replaces the legacy Beego admin server that listened on port **8088**. That server
is deliberately not carried over (spec §8); `/healthz` plus structured logs cover what
it was used for.

---

## 9. The catch-all

```
r.NoRoute(spaFallback(newBundle(webRoot)))
```

Everything that is not matched by the tables above falls through to the SPA handler,
which serves a file from the embedded Flutter bundle when the path names one, and
`index.html` otherwise. The SPA handler itself answers `404` — with a JSON envelope —
for `/api/` and `/healthz` prefixes, so a mistyped API path still returns JSON rather
than an HTML page. See [`ARCHITECTURE.md`](./ARCHITECTURE.md) §8.

Flutter uses path-based browser URLs, so client routes appear as `/console` and
`/admin/settings` without a `#` fragment. The SPA fallback above must keep serving
`index.html` for these deep links so they also work when opened directly or refreshed.

The Flutter user console links to `/servers/:id` (the console view) and
`/servers/:id/:tab`, where `tab` is `console`, `files`, `backups`, `startup`, or
`manage`. Editable server files open `/servers/:id/editor?path=...` in a dedicated
editor page; that route remains under the existing signed-in guard and uses the
existing authenticated file read/write endpoints. A dirty draft asks before a
client-side route change. An unknown tab is redirected to that server's console
view. These are client-side pages and do not add API routes or change the REST
contract.

The consequence for this contract: a route that is *absent* from the tables is not a
`404` from Gin, it is a `404` from the SPA handler. `router_test.go` calls
`NoRoute`-produced responses by issuing a real request, which is why an unregistered
path test is meaningful rather than tautological.

---

## 10. Removed routes

The following legacy surfaces have **no** equivalent and are asserted absent by
`router_test.go`:

| Legacy | Disposition |
|---|---|
| `/captcha`, `/captcha/…` | Removed. `beego/captcha` is gone (spec §1); Redis rate limiting replaces it. |
| Every server-rendered HTML route (`/`, `/order`, `/console`, `/admin/…` as pages) | Removed. The Flutter SPA owns all rendering; `/` is the catch-all, so these paths exist only as client-side router states. |
| `/alipay` (legacy callback path) | Moved to `/api/v1/alipay/notify`. The `NotifyURL` sent to Alipay was updated to match. |
| Port 8088 admin server | Removed. |

Because the API lives under `/api/v1` and the SPA owns everything else, a stale
bookmark to a legacy page renders the SPA rather than a Beego template. There is no
`301` table.
