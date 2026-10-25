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
| ws1 | Server foundation | `models`, `store`, `auth`, `redis`, `config`, `middleware` | **implemented; tested** |
| ws2 | Server service layer | `service` + `pterodactyl`, `status`, `email`, `cryptoo`, `message`, `random` | **implemented; B8 parity audit complete and tests pass** |
| ws3 | Server API | `dto`, `handlers`, `router`, `static` | **implemented; tests pass** |
| ws4 | Server cron and deploy | `cron`, `cmd/peo`, `Dockerfile`, compose, Makefile | **implemented; C9 image/runtime smoke passed** |
| ws5 | Flutter core | app shell, `Dio` client, auth cubit, `go_router`, models | **implemented; focused tests pass** |
| ws6 | Flutter user pages | shop, console, orders, renew, recharge, messages, settings | **implemented; parity follow-ups complete and tested** |
| ws7 | Flutter admin pages | dashboard, users, orders, keys, gallery, work orders, settings | **implemented; targeted checks pass** |
| ws8 | Documentation | this file and its siblings | **in progress** |
| ws9 | CI and repository files | workflow, README, CHANGELOG | **Flutter CI gates blocking and locally verified; other repository-file review remains outside active plan** |

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

Status checked on 2026-09-26. Commands run in the indicated module directory.

| Gate | Command | Current |
|---|---|---|
| Server build | `cd server; go build ./...` | **pass** |
| Server tests | `cd server; go test ./...` | **pass (2026-09-26)** after Phase B8 parity corrections; most packages currently have no tests |
| Server static analysis | `cd server; go vet ./...` | **not rerun in this audit**; prior plan recorded pass |
| Go formatting | `gofmt -l ./cmd ./internal` | **not rerun in this audit**; prior plan recorded empty |
| Compose configuration | `docker compose config --quiet` | **pass** |
| Flutter analysis | `cd flutter; flutter analyze` | **pass (2026-09-26)** — no issues found |
| Flutter tests | `cd flutter; flutter test` | **pass (2026-09-26)** — 12 focused tests cover bootstrap, routes/pages, API errors, and session behavior |
| Flutter code generation | `cd flutter; dart run build_runner build --delete-conflicting-outputs` | **pass (2026-09-26)** (tool reports the option was removed and ignored; no outputs written) |
| Flutter WASM bundle | `cd flutter; flutter build web --wasm --release` | **pass (2026-09-26)** — rerun after parity implementations; built `flutter/build/web` |
| Docker image / runtime smoke test | image build plus Mongo/Redis-backed `/healthz` | **pass (2026-09-26)** — latest full image build and isolated checks: health 200 with Mongo/Redis/Pterodactyl healthy, site API/root/static asset/SPA fallback 200, unknown API route 404; cleanup verified. Used cached MongoDB 8.2, Redis 7-alpine, and an isolated HTTP Pterodactyl probe mock. |

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

## 8. Open items and execution plan

The implementation and automated validation gates are complete. Final release
sign-off remains blocked on explicit acceptance of the greenfield data decision and
explicit legacy disposition approval. Preserve `legacy/` until those approvals are
recorded.

### Active task breakdown

Independent work is assigned to child sessions with file/scope ownership. The
coordinating session tracks dependencies and updates this table and the phase
checklist as each result is verified; it does not duplicate implementation work.

| Task | Scope / deliverable | Owner | Status |
|---|---|---|---|
| A4 | Complete routed admin pages: dashboard, users, orders, products/editor, keys, gallery moderation, work orders, settings | Child session | **complete (2026-09-26)** — improved admin coverage in `admin_pages.dart`; existing DTO/API/cubits used and admin routes remain gated by `isAdmin`; `flutter analyze lib/pages/admin` and focused dashboard route test passed |
| A5 | Review page/route parity against architecture inventory, route/API contracts, and legacy flows; record actionable gaps | Review and follow-up sessions complete | **complete (2026-09-26)** — implemented password reset, substantive terms, gallery interactions/images, recharge QR/status/gates, user navigation/panel provisioning, console status/summary, and discount/email-notice flags. Public approved-gallery GET now uses `OptionalAuth`; mine and mutations remain authenticated. Updated `API.md` and `CONTRACT-ROUTES.md`. Flutter tests (12), analyze, server tests, WASM build, and diff check pass. |
| B6 | Add focused Flutter bootstrap, redirect, representative page, and API/session tests | Child session | **complete (2026-09-26)** — 12 Flutter tests pass across bootstrap/shop, auth/admin redirects, representative console/admin access, Bearer token handling, API errors, and expired-token session reset; analyze clean |
| B7 | Make Flutter generation, analysis, and tests blocking in CI; validate frontend gates/WASM build | Child session | **complete (2026-09-26)** — removed all three `continue-on-error` directives; generation, `flutter analyze`, `flutter test`, and `flutter build web --wasm --release` passed locally |
| B8 | Audit server business parity, fix only confirmed mismatches, and validate targeted behavior | Child session | **complete (2026-09-26)** — corrected legacy expiry grace/notifications, renewal distinctions, password/key formats, Redis key shape, cooldown/email behavior, undocumented Alipay cap, and balance-payment rollback; verified accepted fixes. `go test ./...` and `git diff --check -- server` pass. |
| C9 | Build image and smoke-test API, assets, SPA fallback, and dependency-backed `/healthz` | Coordinator; final verification | **complete (2026-09-26)** — rebuilt latest worktree as `peo-c9-final-20260926:smoke`; isolated runtime passed `/healthz` 200 (Mongo/Redis/Pterodactyl all true), site config 200, root 200, static asset 200 (1,548 bytes), SPA fallback 200, unknown API 404; app cleanup verified. Used cached MongoDB 8.2, Redis 7-alpine, and an isolated Pterodactyl HTTP probe mock. |
| C10 | Review integrated release sign-off prerequisites; preserve `legacy/` pending explicit sign-off | Child session (read-only) | **review complete; approval blocked** — automated validation and C9 runtime proof passed, A5/B8 parity complete. Greenfield data acceptance and explicit legacy-disposition approval require owner sign-off. Do not delete `legacy/`. |

### Phase A — Make the SPA a real application

1. **Wire the app entrypoint.** ✅ Complete (2026-09-26). Replaced the generated
   counter scaffold in `flutter/lib/main.dart` with initialization for
   `TokenStore`, `ApiClient`, `PeoApi`, session/site cubits, `buildRouter`, and
   required `BlocProvider`s. Router and session subscriptions are disposed by
   the app state. Replaced the default counter widget test with a focused
   bootstrap test.
2. **Implement public pages.** ✅ Complete (2026-09-26). Added the routed
   login, registration, forgot-password, confirmation, shop/product detail,
   gallery, terms, and not-found pages using the existing API/state layer.
3. **Implement user pages.** ✅ Complete (2026-09-26). Added the routed
   console/server details, order list/detail/payment, renew/reinstall, recharge,
   messages, account/settings, and work-order pages using the existing cubits
   and API contracts.
4. **Implement admin pages.** ✅ Complete (2026-09-26). Dashboard, users, orders,
   products/editor, keys, gallery moderation, work orders, and settings are routed
   and use the existing DTOs/cubits; admin routing is gated by `isAdmin`.
5. **Complete parity review.** ✅ Complete (2026-09-26). Reviewed the page inventory
   against [`ARCHITECTURE.md` §9](./ARCHITECTURE.md), API/route contracts, and legacy
   flows. Implemented password reset, substantive terms, gallery workflows/images,
   recharge QR and feature gates, user navigation and panel provisioning, console
   status/summary, and discount/email-notice flags. Public approved-gallery reads
   use `OptionalAuth`; private/mutating gallery routes remain authenticated. API and
   route contracts were updated. Final Flutter test/analyze and WASM checks passed.

### Phase B — Restore trustworthy validation

6. **Add focused frontend tests.** ✅ Complete (2026-09-26). Tests cover
   entrypoint/bootstrap and shop, signed-out/user/admin route behavior, a
   representative console flow, Bearer-token attachment, API error handling,
   and expired-token session reset. `flutter test` passes (12 tests) and
   `flutter analyze` reports no issues.
7. **Make Flutter CI blocking.** ✅ Complete (2026-09-26). Removed all three
   `continue-on-error: true` directives for generation, analysis, and tests in
   [`.github/workflows/ci.yml`](../.github/workflows/ci.yml). Code generation,
   `flutter analyze`, `flutter test`, and the WASM release build all passed locally.
8. **Audit server business parity.** ✅ Complete (2026-09-26). Compared service
   behavior with `legacy/` and [`AGENTS.md`](../AGENTS.md), and corrected confirmed
   mismatches in expiry grace/notifications, renewal paths, password/key formats,
   Redis key shape, cooldown/email behavior, Alipay amount cap, and balance-payment
   rollback. Verified accepted fixes. `go test ./...` and `git diff --check -- server`
   passed. Pricing arithmetic, key limits, core cooldown names/TTLs, and the
   documented email-code TTL divergences were also checked.

### Phase C — Prove the deployable artifact

9. **Build and smoke-test the image.** ✅ Complete (2026-09-26). Rebuilt the latest
   worktree and passed isolated runtime checks: `/healthz` returned 200 with MongoDB,
   Redis, and Pterodactyl probe healthy; site config, root, static asset (1,548 bytes),
   and SPA fallback returned 200; unknown API path returned 404. Temporary containers,
   network, and config directory were cleaned and verified absent. Used cached MongoDB
   8.2, Redis 7-alpine, and an isolated Pterodactyl HTTP probe mock.
10. **Release sign-off and legacy disposition.** Review the full page/API/data
    parity checklist. Delete `legacy/` only after explicit sign-off; until then,
    preserve it as the read-only behavior reference.

### Lower-priority structural cleanup

- Split `service/order`, `service/gallery`, and `service/settings` into
  sub-packages if it is still useful after functional parity (divergence (b));
  cosmetic and not a release blocker.
- `internal/buildinfo` is populated only by linker flags; `go run` reporting
  `dev`/empty is intentional.
- Revisit `ProductInput.startup` (divergence (e)) only if legacy evidence shows
  the field had a live behavior impact.

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
