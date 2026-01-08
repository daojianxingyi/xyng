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

FROM nginx:alpine AS runtime

# Replace default nginx conf with SPA-friendly config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy built files
COPY --from=build /app/dist /usr/share/nginx/html

# Expose the app on port 7860 for Hugging Face or custom deployments
EXPOSE 7860

# Healthcheck updated by user request should be handled externally if needed.
CMD ["nginx", "-g", "daemon off;"]


