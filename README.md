# Marcus's Toolbox 🔧

Custom OpenClaw image with CLI tools for agent workflows.

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

## Usage

```dockerfile
FROM ghcr.io/marcusgreybeard/toolbox:latest
```

## Deploying on Railway

Set `OPENCLAW_IMAGE=ghcr.io/marcusgreybeard/toolbox:latest` in your OpenClaw Railway service, or use this image directly as the deployment source.

## CI

Pushes to `main` trigger a GitHub Actions workflow that builds multi-arch (amd64 + arm64) Docker images and pushes to `ghcr.io/marcusgreybeard/toolbox:latest`.
