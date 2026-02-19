# Marcus's Toolbox

Custom OpenClaw image with additional CLI tools.

## Included Tools
- **gh** — GitHub CLI
- **railway** — Railway CLI  
- **caddy** — Web server
- **jq** — JSON processor
- **sops** — Encrypted secrets management
- **age** — Modern encryption (SOPS backend)

## Usage
Set as the OpenClaw container image, or build locally:
```bash
docker build -t marcusgreybeard/toolbox .
```
