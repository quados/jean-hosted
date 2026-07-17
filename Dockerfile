# Thin extension of the upstream Jean headless image that adds Node.js.
#
# Why: Jean installs/runs many MCP servers and skills via `npx` (e.g. Caveman:
# `npx -y github:JuliusBrussee/caveman`). The upstream image ships without
# Node, so those spawns fail with "npx: No such file or directory (os error 2)".
#
# Pin the base tag (e.g. :v0.1.66) for reproducible deploys; :latest tracks the
# newest release on redeploy.
FROM ghcr.io/coollabsio/jean-server:latest

USER root

# Node 22 LTS via NodeSource (bundles npm + npx). Base image is Debian bookworm.
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Drop back to the unprivileged user the server runs as.
USER jean
