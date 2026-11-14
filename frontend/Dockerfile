
# =====================================
# Stage 1: Build frontend
# =====================================
FROM dhi.io/node:26-dev AS build

WORKDIR /app

# Copy dependency manifests
COPY package.json package-lock.json ./

# Install locked dependencies
RUN npm ci --legacy-peer-deps

# Copy application source
COPY . .

# Vite build configuration
ARG VITE_OTEL_ENABLED=false
ARG VITE_OTEL_ENVIRONMENT=dev
ARG VITE_APP_VERSION=dev

ENV VITE_OTEL_ENABLED=${VITE_OTEL_ENABLED}
ENV VITE_OTEL_ENVIRONMENT=${VITE_OTEL_ENVIRONMENT}
ENV VITE_APP_VERSION=${VITE_APP_VERSION}

# Build production frontend
RUN npm run build


# =====================================
# Stage 2: Production runtime
# =====================================
FROM nginxinc/nginx-unprivileged:stable-alpine

# Copy production build
COPY --from=build /app/dist /usr/share/nginx/html

# Copy Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Run Nginx on non-privileged port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD wget -q -O /dev/null http://127.0.0.1:8080/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
