# Multi-stage Dockerfile for building a Vite + Vue app and serving with nginx

FROM node:24-alpine AS build
WORKDIR /app

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

# Health check for Hugging Face deployment
HEALTHCHECK --interval=10s --timeout=5s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:80/index.html || exit 1

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

