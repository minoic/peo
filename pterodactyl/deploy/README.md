# PEO Panel image and extension deployment

The extension targets the exact official `v2.0.0-beta.2` Panel release. The companion image is built from the verified upstream image digest in `Dockerfile.panel`; it contains the extension source under `/opt/peo-panel-extension`. Compose defaults to the published `minoic/peo:panel-2.0.0-beta.2-peo.1` tag. Set `PEO_PANEL_IMAGE` only when you need to select another tag. `PEO_PANEL_APP_URL` optionally overrides Panel's public base URL; it defaults to `http://localhost:8088` for local use.

When Panel and Wings reach the same installation through different hostnames, configure `PEO_PANEL_APP_URL` to the canonical URL reachable by both, and set PEO's `PterodactylHostname` to the same URL. Panel uses `APP_URL` as the issuer in credentials presented to Wings, so these URLs must agree. Do not hard-code a machine-specific LAN address in Compose.

## Build and publish

Build from the repository root using the assigned Docker Hub repository and versioned tag:

```powershell
docker build -f pterodactyl/deploy/Dockerfile.panel -t minoic/peo:panel-2.0.0-beta.2-peo.1 .
docker push minoic/peo:panel-2.0.0-beta.2-peo.1
```

The image tag has been published by the repository owner. These commands are only needed when rebuilding or publishing a later version.

## Install or upgrade

1. Back up the Panel database and the existing `panel-extensions` and `panel-extension-assets` volumes.
2. Compose uses `minoic/peo:panel-2.0.0-beta.2-peo.1` by default. Existing deployments can set `PEO_PANEL_IMAGE` to another published tag when selecting a version.
3. Start database and cache, then run the Panel database migrations explicitly with `docker compose run --rm panel php artisan migrate --force`. The Panel image does not run migrations automatically.
4. Start Panel with `docker compose up -d panel` and verify it is healthy.
5. Run the idempotent extension install/enable step against the same volumes: `docker compose --profile extension-install run --rm extension-install`.
6. Verify with `docker compose exec panel php artisan p:extension:list` and `docker compose exec panel php artisan p:extension:doctor /app/extensions/peo-bridge`.

The one-shot service uses the same image and both extension volumes as Panel. It installs from the image-bundled source, uses `--replace --enable`, and therefore supports both existing named volumes and newly created volumes. Official beta.2 refreshes routes and restarts queue workers after an extension is enabled; the running Panel service does not need an extra manual restart. Do not delete or recreate existing extension volumes during migration. To roll back, restore the database and both volume backups together, then set `PEO_PANEL_IMAGE` to the prior image tag.

## Application API token

Create a dedicated Panel Application API token with read and write access to every Application API resource. This includes all beta.2 resources such as tags and eggs; do not restrict the token to a guessed per-feature subset. The Go startup check must call both `GET` and `POST /api/application/extensions/peo-bridge/v1/capabilities`: the read-only GET confirms read scope, while the side-effect-free POST confirms write scope through Panel's native Application API authorization middleware. Keep the token only in the Go server configuration; never expose it to Flutter or browser responses.

The bridge reuses Panel Client API request validation, permissions, and server-state checks for each server operation. Startup variable updates remain limited to visible/editable Egg variables; image updates remain limited to the current Egg's allowed Docker images. Backup restore also reads the current Wings state and requires the server to be offline.
