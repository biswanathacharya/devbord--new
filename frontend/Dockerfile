
# =====================================
# STAGE 1: BUILD
# =====================================
FROM dhi.io/node:26-dev AS build

WORKDIR /app

COPY package*.json ./

RUN npm ci --legacy-peer-deps

COPY . .

ARG VITE_OTEL_ENABLED=false
ARG VITE_OTEL_ENVIRONMENT=dev
ARG VITE_APP_VERSION=dev

ENV VITE_OTEL_ENABLED=${VITE_OTEL_ENABLED} \
    VITE_OTEL_ENVIRONMENT=${VITE_OTEL_ENVIRONMENT} \
    VITE_APP_VERSION=${VITE_APP_VERSION}

RUN npm run build


# =====================================
# STAGE 2: PRODUCTION RUNTIME
# =====================================
FROM dhi.io/node:26

WORKDIR /app

COPY --from=build /app/dist ./dist

COPY --from=build /app/node_modules ./node_modules

COPY --from=build /app/vite.preview.config.js ./vite.config.js

EXPOSE 4173

USER 1000

CMD ["./node_modules/.bin/vite", "preview", "--host", "0.0.0.0", "--port", "4173"]
