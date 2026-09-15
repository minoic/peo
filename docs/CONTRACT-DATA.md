# Data Contract

Status: **frozen**. This file describes what the new backend persists, how a
legacy MySQL row maps onto a MongoDB document, and which vocabularies the values
use.

The authoritative source is
[`server/internal/models/models.go`](../server/internal/models/models.go) for the
document shapes and
[`server/internal/store/indexes.go`](../server/internal/store/indexes.go) for the
indexes. Both are enforced by construction: the store package's generic helpers
type-assert on the embedded `Doc` method set, so a model that stops embedding it
fails to compile rather than failing at runtime.

---

## 1. The four mechanical differences

Everything below follows from these four rules, applied to all 13 documents.

### 1.1 `gorm.Model` becomes `Doc`

```go
type Doc struct {
	ID        bson.ObjectID `bson:"_id,omitempty" json:"id"`
	CreatedAt time.Time     `bson:"createdAt" json:"createdAt"`
	UpdatedAt time.Time     `bson:"updatedAt,omitempty" json:"updatedAt,omitempty"`
}
```

Every document embeds it. `Insert` calls `EnsureID()`, so a caller may mint an
id first (needed when one document references another before the insert), and
`prepare` calls `StampNow(true)` so the repository — not the driver, not a hook
— owns the timestamps.

`EnsureID`, `Touch`, `StampNow` and `IDString` are the embedded method set the
store's generic helpers assert on. Reflection is never used.

### 1.2 Integers become ObjectIDs

`ID uint` auto-increment does not exist in MongoDB. Every primary key and every
foreign key is a `bson.ObjectID`.

Consequences that reach the API surface:

- **Identifiers are 24-character lowercase hex strings on the wire.**
  `bson.ObjectID.MarshalJSON` emits a bare JSON string, not an object, so
  `"userId": "665f…"` parses without a custom decoder. See
  [`API.md` §1](./API.md).
- **Every path parameter and DTO id is a `string`.** The legacy
  `strconv.Atoi(this.Ctx.Input.Param(":entityID"))` pattern is gone; the single
  parse boundary is `models.ObjectIDFromHex`, and a value that fails to parse is
  a `404 not_found`, not a `400` — an unparseable id addresses nothing.
- **The store returns `models` structs only.** `bson.M` never leaves the store
  package; `api` never imports the driver. That is layer rules 1 and 2 of spec
  §3.

### 1.3 `template.HTML` / `template.URL` become `string`

The legacy schema stored pre-escaped markup in a few columns, most visibly
`RechargeLog.Status`, which held a rendered Bootstrap badge:

```html
<span class="label label-success">success</span>
```

The client renders now, so the column is data. `RechargeLog.Status` is an enum
(§5.3), and the Flutter page turns it into a badge. `html/template` is not
imported anywhere in `server/`.

### 1.4 Soft delete is dropped

GORM's `DeletedAt *time.Time` added `deleted_at IS NULL` to every query and
`UPDATE … SET deleted_at = …` to every delete. Neither behaviour was ever
observed by a user: no legacy handler restored a soft-deleted row, and no
handler displayed one. Rather than reproduce an invisible filter, the port
deletes hard and filters with real fields — `DeleteStatus` on `WareEntity`,
`Closed` on `WorkOrder`, `ReviewPassed` on `GalleryItem`.

For any database that had not been soft-deleted, the visible result set is
identical.

### 1.5 The one model that is gone

`PEAdminSetting` is dropped. Grep the legacy tree and it is written by the GORM
migration and read nowhere. It is the 14th model; the port has 13 collections.

`SqlTablePrefix` is also gone — meaningless without SQL tables.

---

## 2. Legacy to target field mapping

| Legacy (GORM) | Target (MongoDB) |
|---|---|
| `ID uint` auto-increment | `ID bson.ObjectID` (`_id`, omitempty) |
| `CreatedAt time.Time` | `CreatedAt time.Time` (`createdAt`) |
| `UpdatedAt time.Time` | `UpdatedAt time.Time` (`updatedAt`, omitempty) |
| `DeletedAt *time.Time` | — dropped, hard delete |
| `UserID uint` | `UserID bson.ObjectID` |
| `SpecID uint` | `SpecID bson.ObjectID` |
| `WareID uint` | `WareID bson.ObjectID` |
| `ReceiverID uint` | `ReceiverID bson.ObjectID` |
| `template.HTML`, `template.URL` | `string` |
| `uuid.UUID` | `string` — the value is still a UUID, only the Go type changed |
| `time.Duration` | `time.Duration` — `int64` nanoseconds, bit-identical |
| `gorm:"index"` | an explicit index in `store.EnsureIndexes` (§4) |
| `gorm:"unique"` | an explicit **unique** index in `store.EnsureIndexes` |

`time.Duration` is called out because it matters: validity arithmetic, the
delete grace period and `User.TotalUpTime` accumulation all add and compare
nanosecond counts, and every one of those operations is unchanged.

`User.UUID` keeps the `uuid` index and the `unique` flag. Only the Go type is
different, so the JSON value is the same string.

---

## 3. The 13 documents

Field order below matches the struct, which is the JSON order the client sees.

### `users` — `User`

| Field | Type | Notes |
|---|---|---|
| `_id` | ObjectID | also the JWT `sub` claim |
| `createdAt`, `updatedAt` | time | |
| `name` | string | **unique**; also the Pterodactyl panel username |
| `email` | string | **unique** |
| `password` | string | `md5(plaintext + DatabaseSalt)` hex; `json:"-"` |
| `balance` | uint | |
| `isAdmin` | bool | first registrant becomes admin |
| `emailConfirmed` | bool | |
| `pteUserCreated` | bool | whether the panel account exists |
| `totalUpTime` | duration | nanoseconds |
| `uuid` | string | **unique** |

### `ware_specs` — `WareSpec`

| Field | Type | Notes |
|---|---|---|
| `pricePerMonth` | uint | |
| `wareName`, `wareDescription` | string | |
| `node` | int | `0` means "let the panel pick" |
| `memory`, `cpu`, `swap`, `disk`, `io` | int | Pterodactyl limits |
| `backups` | int | |
| `nest`, `egg` | int | Pterodactyl ids |
| `discount` | int | percent |
| `startOnCompletion` | bool | |
| `oomDisabled` | bool | always `true` at creation; see §6 |
| `dockerImage` | string | |
| `validDuration` | duration | 3 days marks the trial product |
| `deleteDuration` | duration | grace period before destruction |

### `ware_entities` — `WareEntity`

A purchased, provisioned server.

| Field | Type | Notes |
|---|---|---|
| `userId` | ObjectID | **indexed** |
| `specId` | ObjectID | |
| `serverExternalId` | string | **unique**; panel server id, which is also its panel name |
| `userExternalId` | string | the customer's **username**; see §6 |
| `hostName` | string | |
| `deleteStatus` | int | **indexed**; see §5.1 |
| `validDate` | time | **indexed**; the cron sweeper orders by it |

### `ware_keys` — `WareKey`

| Field | Type | Notes |
|---|---|---|
| `specId` | ObjectID | **indexed** |
| `keyString` | string | **unique** |
| `exp` | time | **indexed** |

### `orders` — `Order`

| Field | Type | Notes |
|---|---|---|
| `specId` | ObjectID | |
| `userId` | ObjectID | **indexed** |
| `allocationId` | int | chosen at payment time, `0` until then |
| `originPrice`, `finalPrice` | uint | |
| `paid` | bool | |
| `confirmed` | bool | **indexed**; confirmed implies paid |

### `messages` — `Message`

| Field | Type | Notes |
|---|---|---|
| `senderName` | string | |
| `receiverId` | ObjectID | **indexed**, and indexed with `haveRead` |
| `text` | string | |
| `timeText` | string | pre-formatted display string |
| `haveRead` | bool | |

### `gallery_items` — `GalleryItem`

| Field | Type | Notes |
|---|---|---|
| `userId` | ObjectID | **indexed** |
| `itemName`, `itemDescription` | string | |
| `likes` | uint | incremented with `$inc` |
| `reviewPassed` | bool | **indexed**; replaces the legacy soft-delete filter |
| `imgSource` | string | |

### `work_orders` — `WorkOrder`

| Field | Type | Notes |
|---|---|---|
| `userId` | ObjectID | **indexed** |
| `userName` | string | denormalised so the admin list needs no join |
| `orderTitle`, `orderText` | string | |
| `closed` | bool | **indexed** |

### `recharge_keys` — `RechargeKey`

| Field | Type | Notes |
|---|---|---|
| `keyString` | string | **unique** |
| `balance` | uint | |
| `exp` | time | **indexed** |

### `recharge_logs` — `RechargeLog`

| Field | Type | Notes |
|---|---|---|
| `userId` | ObjectID | **indexed** |
| `code` | string | carries the idempotency convention; see §5.4 |
| `method` | string | |
| `balance` | uint | |
| `time` | string | display string |
| `outTradeNo` | string | **unique, sparse** |
| `status` | string | see §5.3 |

`outTradeNo` is indexed `unique` **and** `sparse`. Sparse matters: an Alipay
top-up creates exactly one row per trade number, but balance-key redemptions
never have one, and a non-sparse unique index would treat the second empty
string as a duplicate.

### `reg_confirm_keys` — `RegConfirmKey`

| Field | Type | Notes |
|---|---|---|
| `keyString` | string | **unique** |
| `userName` | string | |
| `userId` | ObjectID | the lookup key; see below |
| `userEmail` | string | |
| `validTime` | time | |

The confirmation lookup uses `userId`, which is
[accepted behaviour fix #2](../AGENTS.md): legacy looked the user up by the
confirmation record's own primary key, which happened to work only because the
two counters started together.

### `delete_confirms` — `DeleteConfirm`

| Field | Type | Notes |
|---|---|---|
| `wareId` | ObjectID | **indexed** |

The presence of a row *is* the state; there is no boolean.

### `pterodactyl_passwords` — `PterodactylPassword`

| Field | Type | Notes |
|---|---|---|
| `userId` | ObjectID | **unique** |
| `password` | string | `json:"-"` |

The panel password is seeded to the username
(`delay_controller.go:74`) and cached here so the single-sign-on handover needs
no panel call.

---

## 4. Indexes

26 indexes over 13 collections, created by `store.EnsureIndexes` on every start.
Creation is idempotent: `CreateMany` ignores an index that already exists with
the same name and keys.

Names are stable on purpose — `uniq_*` for a unique index, `idx_*` for a plain
one — so an operator can drop a single index by name without guessing what the
server called it.

| Collection | Index | Keys | Unique |
|---|---|---|---|
| `users` | `uniq_name` | `name` | yes |
| `users` | `uniq_email` | `email` | yes |
| `users` | `uniq_uuid` | `uuid` | yes |
| `ware_specs` | `idx_ware_name` | `wareName` | |
| `ware_entities` | `idx_user` | `userId` | |
| `ware_entities` | `idx_delete_status` | `deleteStatus` | |
| `ware_entities` | `idx_valid_date` | `validDate` | |
| `ware_entities` | `uniq_server_ext_id` | `serverExternalId` | yes |
| `ware_keys` | `uniq_key_string` | `keyString` | yes |
| `ware_keys` | `idx_spec` | `specId` | |
| `ware_keys` | `idx_exp` | `exp` | |
| `orders` | `idx_user` | `userId` | |
| `orders` | `idx_confirmed` | `confirmed` | |
| `messages` | `idx_receiver` | `receiverId` | |
| `messages` | `idx_receiver_read` | `receiverId`, `haveRead` | |
| `gallery_items` | `idx_review_passed` | `reviewPassed` | |
| `gallery_items` | `idx_user` | `userId` | |
| `work_orders` | `idx_closed` | `closed` | |
| `work_orders` | `idx_user` | `userId` | |
| `recharge_keys` | `uniq_key_string` | `keyString` | yes |
| `recharge_keys` | `idx_exp` | `exp` | |
| `recharge_logs` | `idx_user` | `userId` | |
| `recharge_logs` | `uniq_out_trade_no` | `outTradeNo` | yes, sparse |
| `reg_confirm_keys` | `uniq_key_string` | `keyString` | yes |
| `delete_confirms` | `idx_ware` | `wareId` | |
| `pterodactyl_passwords` | `uniq_user` | `userId` | yes |

All eleven legacy `gorm:"index"` annotations map onto an `idx_*` entry. The
remaining fifteen are a mix of the `unique` constraints GORM enforced (and the
code assumed silently — `uniq_server_ext_id`, the three `uniq_key_string`, and
so on) and additions each justified by a real query in the service layer. The
most obvious additions are `idx_valid_date`, which the expiry sweeper sorts on,
and `idx_receiver_read`, which the unread badge counts with.

Spec §5 requires ten indexes and all ten are present.

---

## 5. Value vocabularies

### 5.1 `WareEntity.DeleteStatus`

| Value | Meaning |
|---|---|
| `0` | active; the server is kept |
| `1` | the deletion notice has been mailed |
| `2` | the owner confirmed; an administrator must approve |

The state machine is unchanged and is driven by the cron:

```
validDate passed  → suspend + e-mail, DeleteStatus = 1
          +10 days → e-mail asking for confirmation
owner confirms    → DeleteStatus = 2, a delete_confirms row appears
admin approves    → panel server deleted, entity deleted
```

### 5.2 `Order` status

`Order` answers three states from two booleans, exposed as strings by the API:

| Value | Condition |
|---|---|
| `pending` | `!paid` |
| `paid` | `paid && !confirmed` |
| `confirmed` | `confirmed` |

`confirmed` implies `paid`; no writer sets `confirmed` without `paid`.

### 5.3 `RechargeLog.Status`

The enum that replaces the rendered Bootstrap badge:

| Value | Meaning |
|---|---|
| `pending` | an Alipay top-up was started and is awaiting the callback |
| `success` | the balance was credited |
| `failed` | a write failed; any partial credit is compensated first |
| `invalid` | the key is unknown or expired |

`invalid` is the value the legacy port initially never emitted; it is now
produced for both the unknown-key and the expired-key path.

### 5.4 `RechargeLog.Code`

`Code` is not free text — it is the idempotency convention inherited unchanged
from legacy, and the callback compares it:

| Pattern | Written when |
|---|---|
| `ByKEY_<key>_<before>_<after>` | a balance key was redeemed |
| `ByZFB_<outTradeNo>_Waiting` | an Alipay top-up was started |

`/api/v1/alipay/notify` short-circuits when the located log is already
`success`, which is what makes a replayed callback harmless.

### 5.5 `GalleryItem.ReviewPassed`

`false` while awaiting moderation, `true` once approved. The public list filters
on `true`; `/gallery/mine` does not.

### 5.6 `message.TimeText` and `rechargeLog.Time`

Both are display strings, not timestamps. They exist because the legacy
templates formatted them once at write time and the value is user-visible; the
`createdAt` field alongside them is the real ordering key.

---

## 6. Panel identity

This section records the single most error-prone part of the port, because the
legacy code keys *everything* panel-side on `user.Name` rather than on the
database id, and getting it wrong produces a server that is provisioned but
attached to the wrong account.

**The rule: the panel knows users by name, not by id.**

| Panel-side value | Legacy | Port |
|---|---|---|
| Panel account lookup | `cli.GetUser(user.Name, true)` | `cli.GetUser(ctx, u.Name)` |
| `ExternalId` on account creation | `newUser.Name` | `u.Name` |
| `Username` | `newUser.Name` | `u.Name` |
| `Password` | `newUser.Name` | `u.Name` |
| `FirstName` | `newUser.Name` | `u.Name` |
| `LastName` | `"_"` | `"_"` |
| `RootAdmin` | `newUser.IsAdmin` | `u.IsAdmin` |
| Server `ExternalId` and panel name | `user.Name + strconv.Itoa(order.ID)` | `u.Name + o.ID.Hex()` |
| `WareEntity.ServerExternalID` | same value | same value |
| `WareEntity.UserExternalID` | `user.Name` | `u.Name` |
| Server `OOMDisabled` | `true`, hardcoded | `true` |
| Panel password bootstrap | username | username |

Two of these are easy to get subtly wrong, so they are spelled out:

- **`WareEntity.UserExternalID` holds a username, not an id.** The name is a
  legacy artefact and was kept because the value is rendered as `ServerOwner` in
  the admin console and is compared by the panel. Because it is a username,
  `admin_service.go` feeds it straight into the delete-confirm row's `owner`
  field — no lookup is needed.
- **`serverExternalId` is `username + orderIdHex`.** It is *also* the panel
  server's name. It is not the ObjectID of the order alone, and it is not the
  ObjectID of the entity. It is unique-indexed, so a collision is a loud write
  failure rather than two servers sharing an identity.

`RootAdmin` mirrors `IsAdmin` on both account-creation paths: registration
(`reg_controller.go:106`) and the retry path in the settings page
(`user_settings_controller.go:160`). The first-ever registrant is made an
administrator, so the bootstrap administrator is also a panel root admin.

**Nothing panel-side consumes a password change.** `pterodactyl.Client.ChangePassword`
exists in the port because the legacy API client had it, but no service calls
it. The account password (`PUT /user/password`) and the panel password are
different values and the latter never changes after creation.

---

## 7. What a document deliberately does not contain

- **No `deletedAt`.** See §1.4.
- **No `language`.** i18n is removed; there is no per-user locale, and the
  panel account is created with a fixed panel language.
- **No captcha state.** The challenge is gone from the schema and from Redis;
  see [`ARCHITECTURE.md` §6](./ARCHITECTURE.md).
- **No session rows.** Sessions are stateless JWTs plus a Redis blacklist.
- **No stored markup.** Every `string` field holds data.

---

## 8. Migration

There is none. This is a greenfield schema: the target deployment starts against
an empty MongoDB, and the rewrite explicitly does not carry the MySQL data over.
`legacy/` is kept only so behaviour can be diffed while the port is reviewed; it
is not a data source.
