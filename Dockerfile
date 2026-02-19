# Marcus's Toolbox - extends OpenClaw with Nix-managed tools
FROM ghcr.io/openclaw/openclaw:latest

USER root

# Create /nix and configure for single-user container install
RUN mkdir -m 0755 /nix && chown root /nix && \
    mkdir -p /etc/nix && \
    echo 'build-users-group =' > /etc/nix/nix.conf

# Install Nix (single-user, no daemon)
RUN curl -fsSL https://nixos.org/nix/install | sh -s -- --no-daemon

# Copy Nix expression
COPY shell.nix /opt/toolbox/shell.nix

# Install tools via Nix and symlink into PATH
RUN . /root/.nix-profile/etc/profile.d/nix.sh && \
    nix-env -if /opt/toolbox/shell.nix && \
    ln -sf /root/.nix-profile/bin/* /usr/local/bin/ 2>/dev/null || true && \
    nix-collect-garbage -d

# Add sync scripts
COPY scripts/ /opt/toolbox/scripts/
RUN chmod +x /opt/toolbox/scripts/*.sh

USER node
