# Marcus's Toolbox - extends OpenClaw base image
# Tools I need that aren't in the default image
FROM ghcr.io/openclaw/openclaw:latest

USER root

# System packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    jq \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
      -o /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
      > /etc/apt/sources.list.d/github-cli.list && \
    apt-get update && apt-get install -y gh && \
    rm -rf /var/lib/apt/lists/*

# Railway CLI
RUN npm install -g @railway/cli

# Caddy (static binary)
RUN curl -fsSL "https://caddyserver.com/api/download?os=linux&arch=$(dpkg --print-architecture)" \
      -o /usr/local/bin/caddy && chmod +x /usr/local/bin/caddy

# SOPS (encrypted secrets)
RUN ARCH=$(dpkg --print-architecture) && \
    curl -fsSL "https://github.com/getsops/sops/releases/download/v3.9.4/sops-v3.9.4.linux.${ARCH}" \
      -o /usr/local/bin/sops && chmod +x /usr/local/bin/sops

# age (encryption backend for SOPS - no GPG needed)
RUN ARCH=$(dpkg --print-architecture) && \
    curl -fsSL "https://dl.filippo.io/age/latest?for=linux/${ARCH}" | tar xz -C /usr/local/bin --strip-components=1

USER node
