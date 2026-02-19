# Marcus's Toolbox 🔧

Custom OpenClaw image with [Flox](https://flox.dev) for reproducible tool management.

## What's in it

Extends `ghcr.io/openclaw/openclaw:latest` with:

- **Flox** — Nix-based package manager that actually works in containers
- **storj-sync** — Durable workspace backup to Storj

## Tools (installed via Flox at runtime)

```
gh        # GitHub CLI
railway   # Railway CLI
jq        # JSON processor
caddy     # Web server
uplink    # Storj object storage CLI
sops      # Encrypted secrets
age       # Modern encryption
```

## Usage

```dockerfile
FROM ghcr.io/marcusgreybeard/toolbox:latest
```

Then use `flox install <package>` to add tools, or activate a Flox environment.
