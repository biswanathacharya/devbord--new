FROM node:26-slim AS build

WORKDIR /app

COPY package*.json ./
RUN npm install --legacy-peer-deps

COPY . .

ARG VITE_OTEL_ENABLED=false
ARG VITE_OTEL_ENVIRONMENT=dev
ARG VITE_APP_VERSION=dev

ENV VITE_OTEL_ENABLED=$VITE_OTEL_ENABLED \
    VITE_OTEL_ENVIRONMENT=$VITE_OTEL_ENVIRONMENT \
    VITE_APP_VERSION=$VITE_APP_VERSION

RUN npm run build

# Runtime stage
FROM node:26-slim

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY --from=build --chown=node:node /app/dist ./dist
COPY --from=build --chown=node:node /app/package*.json ./

RUN npm ci --only=production --legacy-peer-deps && \
    npm cache clean --force && \
    rm -rf /tmp/* /var/tmp/*

COPY --chown=node:node vite.preview.config.js ./vite.config.js

USER node

EXPOSE 4173

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD node -e "require('http').get('http://localhost:4173', (r) => {if (r.statusCode !== 200) throw new Error(r.statusCode)})" || exit 1

ENTRYPOINT ["node", "--no-warnings"]
CMD ["./node_modules/.bin/vite", "preview", "--host", "0.0.0.0", "--port", "4173"]
