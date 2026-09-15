# peo REST API

Base path: `/api/v1`. All bodies are JSON, `Content-Type: application/json`,
UTF-8, except the two endpoints marked otherwise.

The route table in [`CONTRACT-ROUTES.md`](./CONTRACT-ROUTES.md) is the frozen
list and is asserted by `server/internal/api/router_test.go`; this document
explains the payloads.

---

## 1. Conventions

### Envelope

Success:

```json
{ "ok": true, "data": { } }
```

Failure:

```json
{ "ok": false, "error": { "code": "not_found", "message": "invalid server" } }
```

`data` is omitted when there is nothing to report. `error.code` is stable and
safe to branch on; `error.message` is a human-readable English string and may
change.

### Error codes

| `code` | HTTP | Meaning |
|---|---|---|
| `validation_failed` | 400 | Body or parameter is malformed, missing or out of range |
| `unauthorized` | 401 | No token, an expired token, a blacklisted token, or a deleted user |
| `forbidden` | 403 | Authenticated but not an administrator |
| `not_found` | 404 | The addressed document does not exist, or the id is not a valid ObjectID |
| `conflict` | 409 | The action contradicts current state |
| `rate_limited` | 429 | The per-action Redis cooldown is still counting down |
| `insufficient_balance` | 400 | The balance is lower than the order price |
| `invalid_key` | 400 | The activation code is unknown, expired or already redeemed |
| `already_paid` | 400 | The order or trade has already been settled |
| `pterodactyl_error` | 502 | The panel rejected the request or is unreachable |
| `internal_error` | 500 | Anything unexpected; the cause is logged, not returned |

### Identifiers

Every id is a **24-character lowercase hex MongoDB ObjectID**. A path parameter
that does not parse returns `404 not_found` (`invalid <what>`), not 400, because
the resource addressed by that string cannot exist.

This is the single biggest wire-level difference from the legacy product, which
used auto-increment integers in every URL and form.

### Authentication

`Authorization: Bearer <accessToken>`. The legacy `X-Auth-*` headers and the
`LST` / `UN` / `ID` cookies are gone.

`middleware` is the only code that reads that header. Handlers use
`middleware.UserID(c)`.

### Routes bound with `OptionalAuth()`

These are public, but personalise their output when a valid token is present:
`/site/config` reports `loggedIn`, `isAdmin` and `unread`.

### Routes bound with `Auth()` + `Admin()`

Everything under `/admin`. A non-admin gets `403 forbidden` before the handler
runs, so no handler repeats the check.

---

## 2. Time and number formats

Deliberately unchanged from the legacy templates so the numbers stay comparable:

| Field | Format |
|---|---|
| `expiresAt`, `validDate`, `createdAt` on documents | RFC 3339, from `time.Time` |
| `createdAt` on joined admin/ticket/gallery rows | `"2006-01-02 15:04"` |
| `expire` on delete-confirm rows | `"2006-01-02 15:04"` |
| `time` on recharge logs | `"2006-01-02 15:04:05"` |
| Durations (`validDuration`, `deleteDuration`, `totalUpTime`) | integer nanoseconds, as `time.Duration` always marshalled |
| Money and balances | unsigned integers, in the site's single currency |

Money arithmetic is `0.01 * (100 - Discount) * Price` and is disabled entirely
when `TotalDiscount` is off. A product whose validity is 3 days is the trial and
always costs 1.

---

## 3. Public endpoints

### `GET /site/config`

The shell bootstrap. Call this once, before rendering anything.

```json
{
  "applicationName": "peo",
  "description": "…",
  "hostName": "https://panel.example.com",
  "adminAddress": "admin@example.com",
  "albumEnabled": false,
  "rechargeMode": false,
  "alipayEnabled": false,
  "totalDiscount": false,
  "socialLink": "https://t.me/…",
  "socialLinkTitle": "Community",
  "emailNotice": true,
  "loggedIn": true,
  "isAdmin": false,
  "unread": 3
}
```

`rechargeMode`, `totalDiscount`, `alipayEnabled`, `albumEnabled` and `emailNotice`
are feature switches: hide the corresponding UI when they are false.
`loggedIn`, `isAdmin` and `unread` are always present and are `false` / `false` /
`0` for an anonymous visitor.

This is the one call that replaces the legacy `handleNavbar` helper that every
server-rendered template invoked.

### `GET /site/storefront`

The shop landing page, grouped by billing cycle.

```json
{
  "monthly":    [ ProductCard ],
  "quarterly":  [ ProductCard ],
  "yearly":     [ ProductCard ],
  "emailNotice": true
}
```

`ProductCard`:

| Field | Type | Notes |
|---|---|---|
| `specId` | string | ObjectID hex; the id used to create an order |
| `wareName` | string | |
| `discount` | int | 0–100, already reflected in `price` |
| `intros` | array | see below |
| `price` | uint | total for this cycle's duration |
| `monthPrice` | uint | monthly list price before discount |
| `validDays` / `deleteDays` | int | derived from the two durations, in days |
| `memory` `cpu` `disk` `backups` | int | resource limits |
| `nest` `egg` | int | Pterodactyl ids |

`Intro` is a bullet whose wording belongs to the client:

```json
{ "key": "memory", "value": "1024", "label": null, "hint": false }
```

`key` is a translation key, `value` is appended verbatim, `label` is free-form
text with no translation (a nest description, a product note), `hint` marks a
bullet that needs an extra explanation.

A product whose validity is none of 30 / 90 / 365 days is **not grouped into any
bucket**. That is how the 3-day trial stays reachable only from a direct product
link and never appears in the shop.

### `GET /products/:specId`

```json
{
  "product": ProductCard,
  "pricing": { "originPrice": 2000, "finalPrice": 1800 },
  "nestName": "…",
  "eggName": "…",
  "eggs": [ { "id": 12, "name": "Paper" } ]
}
```

`nestName` and `eggName` are omitted when the panel lookup fails; the product is
still purchasable. `eggs` is the list the reinstall picker uses.

Returns `404` when `specId` is not a valid ObjectID or the product is gone.

### `GET /nests/:nestId/eggs`

```json
{ "eggs": [ { "id": 12, "name": "Paper" } ] }
```

`nestId` is a **panel integer**, not an ObjectID. A non-numeric value returns
`400 validation_failed`.

### `POST /auth/login`

```json
{ "login": "name or email", "password": "…", "remember": false }
```

`Login` is whatever the user typed: the server tries the name first, then the
e-mail, exactly as the legacy controller did. `remember` selects the 60-day token
instead of the 24-hour one.

`200`:

```json
{
  "accessToken": "eyJ…",
  "expiresAt": "2026-01-01T00:00:00Z",
  "user": { "id": "…", "name": "…", "email": "…", "balance": 0,
            "isAdmin": false, "emailConfirmed": true, "pteUserCreated": true,
            "totalUpTime": 0, "uuid": "…", "createdAt": "…" }
}
```

`user.password` never appears: the field is tagged `json:"-"`.

Failures are `401 unauthorized`. The response does not distinguish "no such user"
from "wrong password".

`POST /auth/register` takes `{name, email, password}` and returns the same
payload with `201`. If the site mails confirmations, the account starts with
`emailConfirmed: false` and the user must follow the mailed link.

### `GET /auth/confirm-email/:key`

Consumes the registration confirmation token. `key` is an opaque string, not an
ObjectID. Returns `{ "message": "e-mail confirmed" }`.

### `POST /auth/forget-password`

```json
{ "email": "…" }
```

Always returns `200` with
`{ "message": "if the address is registered a reset code has been sent" }`,
whether or not the address exists. That is intentional: it does not leak account
existence.

### `POST /auth/reset-password`

```json
{ "email": "…", "code": "…", "newPassword": "…" }
```

The address is repeated because this endpoint is anonymous — there is no session
to take the identity from. This is the port's fix for
[accepted behaviour fix #2](../AGENTS.md): the legacy code looked the user up by
the confirmation record's own primary key.

### `POST /alipay/notify` — **not JSON**

The Alipay server-to-server callback. The body is
`application/x-www-form-urlencoded` and is signed by Alipay. The handler verifies
the signature, records the trade, and answers with the literal body `success` or
`fail` — **not** the JSON envelope, because that is what Alipay parses.

This is the only public unauthenticated mutation endpoint in the system.

---

## 4. Authenticated endpoints

All of these require `Authorization: Bearer <token>` and answer `401` without it.

### Session

| Method | Path | Body | Response |
|---|---|---|---|
| `POST` | `/auth/logout` | — | `{message}`; blacklists the token |
| `GET` | `/auth/me` | — | `{user}` |
| `POST` | `/user/pterodactyl-session` | — | `{cookie, loginUrl, subdomain}` |

`POST /auth/logout` writes the token's id into Redis under `JWTBLACKLIST:<jti>`
for the token's remaining lifetime. The client must drop its stored token
regardless of the response.

`POST /user/pterodactyl-session` is the passwordless hand-off to the panel. The
server sets the `pterodactyl_session` cookie itself (12 hours, `SameSite=None`,
`Secure`) and also returns it in the body so a non-browser client can use it. The
legacy version answered `302`; a REST client cannot follow that usefully, so the
target URL is data now. **`subdomain` must be a subdomain of the site host or the
cookie will not be sent** — the configuration is validated for this.

### Account

| Method | Path | Body | Response |
|---|---|---|---|
| `PUT` | `/user/password` | `{oldPassword, newPassword}` | `{message}` |
| `PUT` | `/user/email` | `{email}` | `{message}`; mails a code |
| `POST` | `/user/email/confirm` | `{email, code}` | `{message}` |
| `POST` | `/user/pterodactyl-user` | — | `{message}`; creates the panel account |

`PUT /user/password` verifies `oldPassword` against
`md5(old + DatabaseSalt)` before rotating.

### Orders

| Method | Path | Body | Response |
|---|---|---|---|
| `POST` | `/orders` | `{specId}` | `201 {order}` |
| `GET` | `/orders` | — | `{orders}` |
| `GET` | `/orders/:id` | — | `{order}` |
| `GET` | `/orders/:id/allocations` | — | `{allocations}` |
| `POST` | `/orders/:id/pay` | `{allocationId, hostName, key}` | `{message}` |
| `POST` | `/orders/:id/pay-by-balance` | `{allocationId, hostName}` | `{message}` |

`POST /orders` only records the intent. The allocation and host name are chosen
on the payment screen, so creation does not need them, and the price is frozen
into `originPrice` / `finalPrice` at that moment.

`GET /orders/:id/allocations` lists the free ports on the node the ordered
product is pinned to:

```json
{ "allocations": [ { "id": 12, "address": "node.example.com:25565" } ] }
```

The legacy form posted a single string `"<id> <alias:port>"`; the DTO splits it
into a numeric `allocationId` and a display-only `hostName`.

`POST /orders/:id/pay` with a non-empty `key` redeems that product key. With an
empty `key` it is equivalent to `/pay-by-balance`. Both create the server on the
panel and answer `{message}` — the newly created server is not in the response,
because provisioning is asynchronous; poll `GET /servers`.

Failures: `404` unknown order, `409 already_paid`, `400 insufficient_balance`,
`400 invalid_key`, `429 rate_limited`, `502 pterodactyl_error`.

### Servers

| Method | Path | Body | Response |
|---|---|---|---|
| `GET` | `/servers` | — | `{servers}` |
| `GET` | `/servers/status` | — | `{servers}` of live status |
| `GET` | `/servers/:id` | — | `{server}` |
| `POST` | `/servers/:id/renew` | `{key}` | `{message}` |
| `POST` | `/servers/:id/renew-by-balance` | — | `{message}` |
| `POST` | `/servers/:id/reinstall` | `{eggId}` | `{message}` |
| `POST` | `/servers/:id/delete` | — | `{message}` |

`GET /servers` returns `models.WareEntity` documents. `GET /servers/status`
returns the lightweight polled shape, which is what the console table renders:

```json
{ "servers": [ {
  "entityId": "…", "externalId": "1", "hostName": "…",
  "validDate": "2026-01-01T00:00:00Z", "deleteStatus": 0, "suspended": false,
  "identifier": "abc123", "panelName": "…",
  "online": true, "version": "1.20.4", "motd": "A Minecraft Server",
  "playerCount": 3, "playerMax": 20, "probing": false
} ] }
```

Statuses are answered from a cron-maintained cache and are at most 30 seconds
stale. This is why the console no longer blocks on one TCP handshake per server.

`deleteStatus` is the delete state machine: `0` normal, `1` the expiry notice was
sent, `2` the owner confirmed and the server awaits an administrator. The
transitions themselves are unchanged from legacy.

`renew` and `reinstall` are rate limited per entity / per user through Redis.

### Gallery

| Method | Path | Body | Response |
|---|---|---|---|
| `GET` | `/gallery` | — | `{items}` of approved items |
| `GET` | `/gallery/mine` | — | `{items}` including pending |
| `POST` | `/gallery` | `{itemName, itemDescription, imgSource}` | `201 {item}` |
| `POST` | `/gallery/:id/like` | — | `{likes}` |
| `DELETE` | `/gallery/:id` | — | `{message}` |

```json
{ "id": "…", "itemName": "…", "itemDescription": "…", "imgSource": "https://…",
  "likes": 4, "reviewPassed": false, "userName": "…", "createdAt": "2006-01-02 15:04" }
```

`imgSource` is a URL chosen by the user; the server does not host uploads and does
not fetch it.

The gallery routes are **always registered**, even when `AlbumEnabled` is false.
The client hides the UI. This is divergence (j) in
[`ARCHITECTURE.md`](./ARCHITECTURE.md) — a 404 from a working route and a 404 from
a missing route are indistinguishable while debugging.

### Messages

| Method | Path | Body | Response |
|---|---|---|---|
| `GET` | `/messages` | — | `{messages}` |
| `GET` | `/messages/unread` | — | `{unread}` |
| `POST` | `/messages/:id/read` | — | `{message}` |
| `POST` | `/messages/read-all` | — | `{message}` |
| `DELETE` | `/messages/:id` | — | `{message}` |

`MessageItem` is deliberately not the raw document: it carries `id` as a string
and `createdAt` as a formatted string, so the client renders it directly.

```json
{ "id": "…", "senderName": "…", "text": "…", "timeText": "…",
  "haveRead": false, "createdAt": "2006-01-02 15:04" }
```

`/messages/unread` is cheap and is the endpoint behind the navbar badge; the
count is also inlined into `/site/config` so the badge needs no second call on a
cold start.

### Work orders

| Method | Path | Body | Response |
|---|---|---|---|
| `GET` | `/work-orders` | — | `{orders}` |
| `POST` | `/work-orders` | `{title, text}` | `201 {order}` |

```json
{ "id": "…", "userId": "…", "userName": "…", "orderTitle": "…",
  "orderText": "…", "createdAt": "2006-01-02 15:04", "closed": false }
```

Opening a ticket is rate limited with the legacy `WORKORDER<userName>` Redis key.

### Recharge

| Method | Path | Body | Response |
|---|---|---|---|
| `GET` | `/recharge/logs` | — | `{logs}` |
| `POST` | `/recharge/key` | `{key}` | `{message}` |
| `POST` | `/recharge/alipay` | `{amount}` | `201 {qrCodeBase64, outTradeNo}` |
| `GET` | `/recharge/alipay/:outTradeNo` | — | `{status}` |

`POST /recharge/key` redeems a balance code. `429` while the 3-second cooldown is
running; amounts above 100000 are rejected.

`POST /recharge/alipay` starts a face-to-face payment:

```json
{ "qrCodeBase64": "data:image/png;base64,…", "outTradeNo": "…" }
```

The client renders `qrCodeBase64` and polls
`GET /recharge/alipay/:outTradeNo` until `status` leaves `pending`.

`status` is one of `pending`, `success`, `failed`, `invalid` — the enum that
replaces the legacy HTML badge. `RechargeLog.status` is the same enum.

`outTradeNo` is a path parameter, not an ObjectID: it is the Alipay trade number.
The legacy `OutTradeNo` / `Code` conventions, which are what make the callback
idempotent, are unchanged.

---

## 5. Admin endpoints

Every route here is bound with `Auth()` **and** `Admin()`. A valid non-admin token
gets `403 forbidden`.

| Method | Path | Body | Response |
|---|---|---|---|
| `GET` | `/admin/dashboard` | — | `{dashboard}` |
| `GET` | `/admin/users` | — | `{users}` |
| `GET` | `/admin/orders` | — | `{orders}` |
| `GET` | `/admin/products` | — | `{products}` |
| `GET` | `/admin/products/raw` | — | `{products}` of raw `WareSpec` |
| `GET` | `/admin/products/form` | — | `{fields}` |
| `POST` | `/admin/products` | `{product}` | `201 {specIds}` |
| `PUT` | `/admin/products/:specId` | `{product}` | `{message}` |
| `DELETE` | `/admin/products/:specId` | — | `{message}` |
| `GET` | `/admin/key-targets` | — | `{targets}` |
| `POST` | `/admin/keys` | `{target, amount, validityDays}` | `{message}` |
| `GET` | `/admin/keys/export` | — | **zip file** |
| `GET` | `/admin/delete-confirms` | — | `{confirms}` |
| `POST` | `/admin/delete-confirms/:entityId` | `{approve}` | `{message}` |
| `GET` | `/admin/work-orders` | — | `{orders}` |
| `POST` | `/admin/work-orders/:id/close` | `{closeInfo}` | `{message}` |
| `POST` | `/admin/gallery/:id/:action` | — | `{message}` |
| `GET` | `/admin/settings` | — | `{fields}` |
| `PUT` | `/admin/settings` | `{values}` | `{message}` |
| `GET` | `/admin/health` | — | `{health}` |

### Dashboard

```json
{
  "specAmount": 4, "entityAmount": 12, "userAmount": 8, "keyAmount": 30,
  "orderAmount": 11, "workOrderCount": 2, "galleryCount": 5,
  "galleryItems": [ … ], "workOrders": [ … ], "deleteConfirms": [ … ]
}
```

Reading the dashboard also prunes pending deletions whose server has already
disappeared or whose owner withdrew the request, so the moderation list stays
trustworthy without a dedicated cron job.

`galleryItems` are pending submissions, `workOrders` are open tickets, and
`deleteConfirms` are:

```json
{ "entityId": "…", "confirmId": "…", "serverName": "…", "consoleUrl": "…",
  "identifier": "abc123", "owner": "…", "expire": "…", "hostName": "…" }
```

`consoleUrl` points at the panel page of the server so the operator can inspect it
before deciding.

### Products

One `POST /admin/products` produces **one document per enabled billing cycle**,
so the response is a list:

```json
{ "specIds": ["…", "…", "…"] }
```

A cycle whose discount is 100 is disabled and produces no document. This is why
the request body carries `discount0` / `discount1` / `discount2` while the
single-cycle `PUT` path reads `discount`.

`ProductInput`:

| Field | Type | Notes |
|---|---|---|
| `wareName`, `wareDescription` | string | |
| `cpu` `disk` `memory` `swap` `io` `backups` | int | resource limits |
| `nodeId` `nestId` `eggId` | int | Pterodactyl ids |
| `image` | string | optional Docker image override |
| `deleteTime` | int | grace period, in days |
| `price` | uint | undiscounted monthly price |
| `discount0` `discount1` `discount2` | int | per-cycle, 0–100, 100 disables |
| `discount` | int | used by `PUT` only |

There is deliberately **no `startup` member** — see divergence (e) in
[`ARCHITECTURE.md`](./ARCHITECTURE.md).

`GET /admin/products/form` returns the editor schema so the client renders the
form generically:

```json
{ "fields": [ { "name": "price", "label": "Price (per 30 days, CNY)",
               "description": "…", "type": "number", "required": true,
               "default": null } ] }
```

Note the field names here are **snake_case** (`ware_name`, `node_id`,
`delete_time`) because they mirror the legacy HTML form, whereas `ProductInput`
is **camelCase**. The client maps one to the other; `service.FormField` is the
only place the two vocabularies meet.

### Keys

`GET /admin/key-targets`:

```json
{ "targets": [ { "target": "spec:5f…", "name": "…", "description": "…",
                "validity": 30 } ] }
```

`validity` is the product lifetime in days; `0` means the target is a balance code
and carries no lifetime, `-1` means the target stands for every product at once.

`POST /admin/keys` accepts:

| `target` | Meaning |
|---|---|
| `all` | every product, validity defaults to the product's own |
| `spec:<hex>` | one product |
| `balance:all` | balance code, `amount` applied |
| `balance:<amount>` | balance code with the amount inline |

`amount` and `validityDays` are integers; `validityDays` of `0` means "use the
product's lifetime".

The codes are **not** in the response — the client reloads the export. The legacy
flow read them from a separate page, and keeping them out of a browser's response
body is the safer default.

`GET /admin/keys/export` returns `application/zip` with
`Content-Disposition: attachment; filename="peo-keys.zip"`. It is not a JSON
envelope. The archive is built in memory, which removes the temporary directory
and the goroutine race the legacy implementation had.

### Delete confirmations

`POST /admin/delete-confirms/:entityId` with `{"approve": true}` destroys the
server; `false` cancels the request and returns the server to normal. The legacy
endpoint could only approve; cancelling is the same decision with the opposite
answer, so one route carries both.

### Gallery review

`POST /admin/gallery/:id/pass` publishes a submission;
`POST /admin/gallery/:id/delete` rejects and removes it. The legacy code used two
static paths; they collapse into one parameterised route.

### Settings

`GET /admin/settings` returns the schema with current values:

```json
{ "fields": [ { "key": "WebApplicationName", "label": "Site name",
               "description": "…", "type": "text", "value": "peo" } ] }
```

`type` is one of `text`, `number`, `bool`. The client renders the matching input.

`PUT /admin/settings` takes a sparse map:

```json
{ "values": { "TotalDiscount": "true", "SMTPPort": "587" } }
```

Everything is a **string**, including booleans and numbers, because that is what
an HTML form produces and it keeps one code path. The server parses against the
schema and returns `400 validation_failed` naming the offending key. Unknown keys
are ignored, so an old client cannot introduce arbitrary TOML entries.

A successful save writes `conf/settings.toml`, reloads the configuration, and
**reconnects Mongo and Redis** so the change is live immediately. A save that
changes `MongoURI` or `RedisHost` therefore briefly drops the datastore
connections; that is intended and is why the response is only sent after the
reconnect attempt.

### Health

`GET /admin/health`:

```json
{
  "mongo":       { "ok": true,  "message": "success" },
  "redis":       { "ok": true,  "message": "success" },
  "pterodactyl": { "ok": false, "message": "…" },
  "version": "v1.0.0", "buildTime": "…", "goVersion": "go1.27.1"
}
```

This endpoint **never fails**. A component that is down is reported as
`"ok": false` with the error message; the operator asked for the state of the
system, so the state is what they get.

---

## 6. Outside `/api/v1`

### `GET /healthz`

The container liveness probe. It returns a **bare** object, not the envelope,
because the Docker healthcheck and any orchestrator parse it directly:

```json
{ "ok": true, "mongo": true, "redis": true, "pterodactyl": true }
```

`503` with `"ok": false` when any component is unreachable, plus a
`<component>_error` string. No authentication, no envelope.

### Everything else

Serves the compiled Flutter bundle. Unknown non-API paths fall back to
`index.html` for client-side routing; unknown `/api/` paths get the JSON `404`
envelope so a mistyped endpoint is diagnosable rather than silently returning
HTML. See [`ARCHITECTURE.md` §8](./ARCHITECTURE.md).
