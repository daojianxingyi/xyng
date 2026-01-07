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

EXPOSE 3000
CMD ["nginx", "-g", "daemon off;"]

