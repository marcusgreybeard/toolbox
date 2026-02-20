# Marcus's Toolbox 🔧

Custom OpenClaw image with CLI tools, built and deployed on Railway.

## What's in it

Extends `ghcr.io/openclaw/openclaw:latest` with:

### System Tools
- `jq` — JSON processor
- `sqlite3` — Embedded database
- `ripgrep` (`rg`) — Fast recursive search
- `fd` — Fast file finder
- `bat` — Cat with syntax highlighting
- `htop` — Process monitor
- `rsync` — File sync

### CLI Tools (static binaries)
- `gh` — GitHub CLI
- `railway` — Railway CLI
- `duckdb` — Analytical SQL engine (Parquet, CSV, JSON)
- `caddy` — Web server / reverse proxy
- `uplink` — Storj object storage CLI
- `sops` + `age` — Encrypted secrets management

### Scripts
- `storj-sync.sh` — Sync durable workspace files to/from Storj

## Deployment

Push to `main` → Railway auto-builds from Dockerfile → deploys as OpenClaw gateway.
