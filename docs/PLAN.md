# Plan and Status

Status: **living**. This file tracks where the rewrite got to, why it was split
the way it was, and what is still open. It is the only document in `docs/` that
is expected to change as work lands.

Companion documents:

| File | Answers |
|---|---|
| [`ARCHITECTURE.md`](./ARCHITECTURE.md) | How is it built, why, and what are the trade-offs? |
| [`API.md`](./API.md) | What does the REST surface look like? |
| [`CONTRACT-ROUTES.md`](./CONTRACT-ROUTES.md) | The exact route table and its middleware bindings. |
| [`CONTRACT-DATA.md`](./CONTRACT-DATA.md) | Documents, fields, collections and indexes. |
| [`../../AGENTS.md`](../AGENTS.md) | The frozen target specification itself. |

---

## 1. The shape of the work

The rewrite is three independent deliverables that only meet at two boundaries:

```
legacy/  ──(behaviour reference, read only)──┐
                                             ▼
                                          server/   ──>  embedded SPA  ──>  image
                                             ▲
                                          flutter/  ──>  build/web
```

The **only** interface between the two halves is the JSON contract in
[`API.md`](./API.md) plus the route table in
[`CONTRACT-ROUTES.md`](./CONTRACT-ROUTES.md). Both are frozen and pinned by
tests, which is what let the backend and the frontend be built at the same time
without integration guesswork.

`legacy/` is never compiled by CI. It exists so any behaviour question can be
answered by reading the original line rather than by guessing.

---

## 2. Workstreams

| # | Workstream | Scope | Status |
|---|---|---|---|
| ws1 | Server foundation | `models`, `store`, `auth`, `redis`, `config`, `middleware` | **done** |
| ws2 | Server service layer | `service` + `pterodactyl`, `status`, `email`, `cryptoo`, `message`, `random` | **done** |
| ws3 | Server API | `dto`, `handlers`, `router`, `static` | **done** |
| ws4 | Server cron and deploy | `cron`, `cmd/peo`, `Dockerfile`, compose, Makefile | **done** |
| ws5 | Flutter core | app shell, `Dio` client, auth cubit, `go_router`, models | in progress |
| ws6 | Flutter user pages | shop, console, orders, renew, recharge, messages, settings | in progress |
| ws7 | Flutter admin pages | dashboard, users, orders, keys, gallery, work orders, settings | in progress |
| ws8 | Documentation | this file and its siblings | **done** |
| ws9 | CI and repository files | workflow, README, CHANGELOG | **done** |

`ws5`–`ws7` are being executed as a single Flutter deliverable because they share
one routing tree and one model layer; splitting them further would have produced
three half-apps that could not be run.

---

## 3. Ordering and dependencies

The order below is what was actually followed, and why it is not rearrangeable:

1. **`legacy/` isolated first.** Moving the old module into its own directory with
   its own `go.mod` means the new module cannot accidentally import it, and CI
   cannot accidentally build it. This was step one because every later step
   depends on being able to run `go build ./...` on clean ground.
2. **Contract extracted from legacy before any porting.** The route table, the
   response envelope and the DTO shapes were read out of the legacy controllers
   and written into `docs/` *first*, so the backend and the frontend could be
   built against the same frozen target.
3. **`models` then `store` then `service` then `api`.** Strictly bottom-up: each
   layer's tests only need the layers beneath it.
4. **`cron` and deployment last.** The cron only calls services that already
   exist, and the image only embeds a SPA that already builds.

---

## 4. What the backend consists of

`server/` compiles to a single static binary that serves both the API and the
SPA. Nothing at runtime needs a second process, a template directory or a static
file directory.

| Layer | Package | Notes |
|---|---|---|
| Entry point | `cmd/peo` | `config → store → services → cron → router → listen` |
| Config | `internal/config` | viper + TOML, `Reload()` swaps the instance under a mutex |
| Documents | `internal/models` | 13 collections, embedded `Doc` base |
| Persistence | `internal/store` | 13 repositories over one generic helper set |
| Sessions | `internal/auth` | JWT issue/verify, `md5(salt)` password, Redis blacklist |
| Guards | `internal/middleware` | the only reader of `Authorization` |
| Business rules | `internal/service` | transport-agnostic; `apierr` carries status + message |
| Panel client | `internal/service/pterodactyl` | `gcache` ARC 128, capacity-4 semaphore |
| Scheduling | `internal/cron` | expiry sweep, probes, cache refresh, key cleanup |
| HTTP | `internal/api` | 67 routes, thin handlers, `dto` in and out |
| Frontend bundle | `server/web` | `//go:embed all:assets` |

---

## 5. Deliberate divergences

Fourteen decisions where the tree does not match a literal reading of
[`AGENTS.md`](../AGENTS.md) or of legacy, several of which are narrower than they
look. All are recorded in [`ARCHITECTURE.md` §11](./ARCHITECTURE.md) with the
reasoning; the list is reproduced here only so it is not missed.

| # | Summary |
|---|---|
| (b) | `service/order/`, `service/gallery/`, `service/settings/` stay flat files rather than sub-packages |
| (e) | `ProductInput` omits the legacy `startup` field, whose value never reached the database |
| (f) | `AdminService.InvalidateServer` performs a second Mongo read on purpose |
| (j) | gallery routes are registered unconditionally; the client hides the UI |
| (k) | there is no `internal/logging` package; `glgf` already does the job |
| (l) | `FORGET:<email>` lives 30 min rather than legacy's 1 min |
| (m) | `CHANGE_EMAIL<newEmail>` lives 30 min rather than legacy's 1 min |
| (n) | an extra `CHANGE_EMAIL_PENDING:<newEmail>` key binds a code to its requester |
| (o) | `SendCaptcha` reports send failures, and its callers release the key they wrote |
| (p) | `SendAnyEmail` concatenates fragments instead of rendering `[a b c]` |
| (q) | the registration confirmation mail is still not sent — the legacy path was dead code |
| (r) | `IssueRegistrationKey` deletes its token when the mail cannot be sent |
| (s) | `ChangePassword` skips the panel rotation when there is no panel account yet |
| (t) | `ConfirmRegistration` reports the panel outcome instead of creating the account a second time |

Two behaviour fixes that the spec calls out as *intentional* corrections were also
applied and are listed in [`AGENTS.md` §11](../AGENTS.md): the wrong slice variable
in the recharge-key cleanup, and the confirmation lookup by primary key instead of
`UserID`.

---

## 6. Verification

Everything below is run from `server/` unless stated otherwise.

| Gate | Command | Current |
|---|---|---|
| Compiles | `go build ./...` | **pass** |
| Static analysis | `go vet ./...` | **pass** |
| Formatting | `gofmt -l ./cmd ./internal` | **empty** |
| Tests | `go test ./...` | **pass** |
| Compose file | `docker compose config` | **pass** |
| Frontend analyze | `flutter analyze` | ws5–ws7 |
| Frontend tests | `flutter test` | ws5–ws7 |
| Frontend bundle | `flutter build web --wasm --release` | ws5–ws7 |

The Go test suite is deliberately small and high-value: `internal/api` holds the
67-route pinning test, an 8-case test for the dual-source SPA handler, and a
four-case audit (`layers_test.go`) that asserts the mechanically decidable layer
rules from `AGENTS.md` §3. There are no tests for the service layer, because its
behaviour is the legacy behaviour and a test would only assert that the port
matches a reading of the original — the reviewable artefact is the diff against
`legacy/`, not a reimplementation of it.

The cost of that choice is that the service layer's datastore interactions — the
Redis key writes in `ForgetPassword` and `ChangeEmail`, for instance — are only
covered by review. They need a live Redis to exercise, and faking one would mean
a new dependency plus a test that asserts the fake rather than the server.

Formatting is a gate rather than a nicety: the tree was normalized to LF with
`gofmt -w`, so `gofmt -l` returning non-empty is a real signal and CI treats it as
a failure.

---

## 7. Deployment

One image, one port, two sidecars.

| Component | Image | Volume | Port |
|---|---|---|---|
| `peo` | built from `server/Dockerfile` | `conf/` mount | `8080` |
| `mongo` | `mongo:7` | `mongo-data` | internal |
| `redis` | `redis:7` | `redis-data` | internal |

`server/Dockerfile` is a three-stage build: Flutter Web (WASM) → Go binary with
the bundle embedded → a slim runtime with `curl` for the healthcheck. The Flutter
toolchain is downloaded from the official release archive and verified against a
pinned `sha256`; it is **not** taken from `ghcr.io/cirruslabs/flutter`, whose tag
list has no `3.47.4`.

`/healthz` is the liveness probe and checks Mongo, Redis and Pterodactyl, not just
the HTTP listener — a container that can answer requests but cannot reach the panel
is not healthy.

The legacy Beego admin server on `8088` is not carried over.

---

## 8. Open items

### Must happen before a release

1. **Flutter parity review.** `ws5`–`ws7` must cover every page in the inventory
   of [`ARCHITECTURE.md` §9](./ARCHITECTURE.md); the list came from the 30 legacy
   templates, so it is the checklist.
2. **Remove the three `continue-on-error: true` flags** from the `flutter` job in
   [`.github/workflows/ci.yml`](../.github/workflows/ci.yml). They are there
   because generate/analyze/test had nothing to run before the SPA existed; while
   they remain, a broken analyser or a failing test still produces a green build.
3. **Delete `legacy/`** once the port has been signed off. Until then it is the
   only way to answer a behaviour question.

### Should happen, lower priority

4. **`service/` sub-packages** for `order`, `gallery` and `settings`
   (divergence (b)). Cosmetic; it changes no behaviour and no wire shape.
5. **`internal/buildinfo`** is populated only by linker flags, so a `go run`
   reports `dev`/empty. That is intended.
6. **`ProductInput.startup`** (divergence (e)) if the legacy field is ever
   confirmed to have been live.

### Explicitly not planned

- **Migrating MySQL data.** The rewrite is greenfield by decision; see
  [`CONTRACT-DATA.md` §8](./CONTRACT-DATA.md).
- **i18n.** Removed by the spec; the API is English-only.
- **Captcha in any form.** Removed by the spec; Redis counters replace it, and the
  exact families are tabulated in
  [`ARCHITECTURE.md` §6](./ARCHITECTURE.md).
- **Desktop and mobile Flutter targets.** Nothing in the architecture prevents
  them, and the app only uses APIs with cross-platform equivalents, but they are
  out of scope for this rewrite.

---

## 9. Recording a decision

Any change that a reader could mistake for a mistake belongs in
[`ARCHITECTURE.md` §11](./ARCHITECTURE.md) as a new lettered row, and any change
to the wire surface belongs in [`API.md`](./API.md) *and*
[`CONTRACT-ROUTES.md`](./CONTRACT-ROUTES.md) — the two are separate on purpose so
that a payload change and a routing change each have one obvious home.

If the new behaviour contradicts a commitment in a sibling document, fix the
sibling in the same change rather than leaving the contradiction for a reader to
find.
