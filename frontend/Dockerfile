
# Stage 1: Build React application
FROM node:26-slim AS build

WORKDIR /app

# Copy dependency files
COPY package.json package-lock.json ./

# Install dependencies
RUN npm ci --legacy-peer-deps

# Copy application source
COPY . .

# Build-time environment variables
ARG VITE_OTEL_ENABLED=false
ARG VITE_OTEL_ENVIRONMENT=dev
ARG VITE_APP_VERSION=dev

ENV VITE_OTEL_ENABLED=${VITE_OTEL_ENABLED}
ENV VITE_OTEL_ENVIRONMENT=${VITE_OTEL_ENVIRONMENT}
ENV VITE_APP_VERSION=${VITE_APP_VERSION}

# Create production build
RUN npm run build


# Stage 2: Production runtime
FROM nginx:stable-alpine

# Copy production build
COPY --from=build /app/dist /usr/share/nginx/html

# Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Set permissions for non-root execution
RUN chown -R nginx:nginx /usr/share/nginx/html

EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget -q -O /dev/null http://127.0.0.1/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
