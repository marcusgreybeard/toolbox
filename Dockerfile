# Marcus's Toolbox - extends OpenClaw with Flox-managed tools
FROM ghcr.io/openclaw/openclaw:latest

USER root

# Install Flox (handles Nix setup properly)
ARG TARGETARCH
ARG FLOX_VERSION=1.9.0
RUN apt-get update && \
    ARCH=$([ "$TARGETARCH" = "arm64" ] && echo "aarch64" || echo "x86_64") && \
    curl -fsSL "https://downloads.flox.dev/by-env/stable/deb/flox-${FLOX_VERSION}.${ARCH}-linux.deb" -o /tmp/flox.deb && \
    dpkg -i /tmp/flox.deb || apt-get install -f -y && \
    dpkg -i /tmp/flox.deb && \
    rm -f /tmp/flox.deb && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Add sync scripts
COPY scripts/ /opt/toolbox/scripts/
RUN chmod +x /opt/toolbox/scripts/*.sh

USER node
