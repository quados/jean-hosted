# jean-hosted

Coolify deployment for [Jean](https://github.com/coollabsio/jean) headless server.

Runs the prebuilt upstream image `ghcr.io/coollabsio/jean-server` — no build, no
fork. Jean is a Tauri desktop app but ships a browser-accessible headless server
(`jean-server`) that this compose deploys behind the Coolify proxy.

## Deploy on Coolify

1. New Resource → **Docker Compose** → point at this repo's `docker-compose.yml`.
2. Attach a **domain** to the `jean` service (port `3456`) in the Coolify UI. TLS
   is handled by the proxy.
3. Coolify auto-generates the two magic values used here:
   - `SERVICE_FQDN_JEAN_3456` — the public URL (also the allowed browser origin).
   - `SERVICE_PASSWORD_JEANTOKEN` — the auth token (`JEAN_TOKEN`).
4. Deploy.

## Access

Token auth is required. Open the app with the token in the query string:

```
https://<your-domain>/?token=<JEAN_TOKEN>
```

Grab the generated token from the Coolify UI (Environment Variables →
`SERVICE_PASSWORD_JEANTOKEN`). API calls accept a bearer token too:

```bash
curl -H "Authorization: Bearer $JEAN_TOKEN" https://<your-domain>/api/auth
```

Health checks: `GET /healthz` (alive), `GET /readyz` (ready).

## Updating

- **Latest:** with `image: ...:latest`, redeploy in Coolify (enable *Force pull*)
  to fetch the newest release. Or wire a Coolify webhook / auto-deploy.
- **Pinned:** bump the tag in `docker-compose.yml` (e.g. `:v0.1.66` → `:v0.1.67`),
  commit, redeploy. Available tags:
  https://github.com/coollabsio/jean/pkgs/container/jean-server

Data lives in the named `jean-data` volume and survives updates.

## Notes

- Never map a fixed host port or disable the token on a public bind — both bypass
  the security model. Keep the anonymous `ports: - "3456"` as-is.
- To customize Jean's code, fork upstream and either build `Dockerfile.server` in
  Coolify or run the fork's `server-release` workflow and point `image:` at your
  own `ghcr.io/<you>/jean-server`.
