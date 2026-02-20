# Marcus's Toolbox - extends OpenClaw with CLI tools via Flox
FROM ghcr.io/openclaw/openclaw:latest

USER root

# System packages (small, fast, always needed)
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo jq sqlite3 rsync htop ripgrep fd-find bat \
    && ln -sf /usr/bin/batcat /usr/local/bin/bat \
    && ln -sf /usr/bin/fdfind /usr/local/bin/fd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install CLI tools as static binaries (faster than Nix in containers)
ARG TARGETARCH

# GitHub CLI
RUN GH_VERSION=2.67.0 && \
    ARCH=$([ "$TARGETARCH" = "arm64" ] && echo "arm64" || echo "amd64") && \
    curl -fsSL "https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_${ARCH}.tar.gz" \
    | tar xz --strip-components=1 -C /usr/local && \
    gh --version

# Railway CLI (may already exist from base image)
RUN if ! command -v railway &>/dev/null; then \
    curl -fsSL https://railway.com/install.sh | sh; \
    fi

# Storj Uplink CLI
RUN ARCH=$([ "$TARGETARCH" = "arm64" ] && echo "arm64" || echo "amd64") && \
    curl -fsSL "https://github.com/storj/storj/releases/latest/download/uplink_linux_${ARCH}.zip" -o /tmp/uplink.zip && \
    cd /tmp && unzip -o uplink.zip && mv uplink /usr/local/bin/ && chmod +x /usr/local/bin/uplink && \
    rm -f /tmp/uplink.zip

# SOPS + Age (encrypted secrets)
RUN SOPS_VERSION=3.9.4 && \
    ARCH=$([ "$TARGETARCH" = "arm64" ] && echo "arm64" || echo "amd64") && \
    curl -fsSL "https://github.com/getsops/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux.${ARCH}" \
    -o /usr/local/bin/sops && chmod +x /usr/local/bin/sops && \
    AGE_VERSION=1.2.1 && \
    curl -fsSL "https://github.com/FiloSottile/age/releases/download/v${AGE_VERSION}/age-v${AGE_VERSION}-linux-${ARCH}.tar.gz" \
    | tar xz --strip-components=1 -C /usr/local/bin age/age age/age-keygen

# DuckDB
RUN DUCKDB_VERSION=1.2.1 && \
    ARCH=$([ "$TARGETARCH" = "arm64" ] && echo "aarch64" || echo "amd64") && \
    curl -fsSL "https://github.com/duckdb/duckdb/releases/download/v${DUCKDB_VERSION}/duckdb_cli-linux-${ARCH}.zip" \
    -o /tmp/duckdb.zip && cd /tmp && unzip -o duckdb.zip && mv duckdb /usr/local/bin/ && chmod +x /usr/local/bin/duckdb && \
    rm -f /tmp/duckdb.zip

# Caddy web server
RUN ARCH=$([ "$TARGETARCH" = "arm64" ] && echo "arm64" || echo "amd64") && \
    curl -fsSL "https://caddyserver.com/api/download?os=linux&arch=${ARCH}" -o /usr/local/bin/caddy && \
    chmod +x /usr/local/bin/caddy

# Add scripts
COPY scripts/ /opt/toolbox/scripts/
RUN chmod +x /opt/toolbox/scripts/*.sh

# Ensure PATH includes common locations
ENV PATH="/usr/local/bin:/home/node/.local/bin:${PATH}"

USER node
