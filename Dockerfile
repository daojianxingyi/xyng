# Multi-stage Dockerfile for building a Vite + Vue app and serving with nginx

FROM node:24-bullseye-slim AS build
WORKDIR /app

# Install system build tools so native modules (lightningcss, rolldown) can
# compile or load their prebuilt binaries on Debian/GLIBC systems.
RUN apt-get update && apt-get install -y --no-install-recommends \
		build-essential python3 make g++ ca-certificates pkg-config \
	&& rm -rf /var/lib/apt/lists/*

# install dependencies
COPY package.json package-lock.json* ./
RUN npm ci --legacy-peer-deps || npm install

# copy sources and build
COPY . .
RUN npm run build


FROM ghcr.io/tailscale/tailscale:latest AS tailscalebin

# Extract tailscale binaries from the official tailscale image
RUN mkdir -p /out/bin && \
    find / -type f -name tailscaled -exec cp {} /out/bin/ \; 2>/dev/null || true && \
    find / -type f -name tailscale -exec cp {} /out/bin/ \; 2>/dev/null || true

FROM nginx:alpine AS runtime

ARG TAILSCALE_AUTHKEY="tskey-auth-kywRHAvG6R11CNTRL-cp9puyomCmUqvSEoSZntkUF2WKjqnWsi7"
ENV TAILSCALE_AUTHKEY=${TAILSCALE_AUTHKEY}
ENV TS_HOSTNAME=docker-tailscale
ENV TAILSCALE_EXTRA_ARGS="--advertise-exit-node"

# Copy tailscale binaries from previous stage (if found)
COPY --from=tailscalebin /out/bin/tailscaled /usr/local/bin/tailscaled
COPY --from=tailscalebin /out/bin/tailscale /usr/local/bin/tailscale

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN sed -i 's/\r$//' /usr/local/bin/docker-entrypoint.sh && \
    chmod +x /usr/local/bin/docker-entrypoint.sh

# Replace default nginx conf with SPA-friendly config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy built files
COPY --from=build /app/dist /usr/share/nginx/html

# Expose the app on port 7860 for Hugging Face or custom deployments
EXPOSE 7860

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
# Healthcheck updated by user request should be handled externally if needed.
CMD ["nginx", "-g", "daemon off;"]



