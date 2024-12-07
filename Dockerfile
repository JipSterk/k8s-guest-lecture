FROM node:20-alpine AS base

# Install dependencies only when needed
FROM base AS dependencies
RUN apk add --no-cache libc6-compat
WORKDIR /app

COPY package.json pnpm-lock.yaml* ./
RUN corepack enable pnpm && pnpm i --frozen-lockfile;

# Rebuild the source code only when needed
FROM base AS builder
WORKDIR /app
COPY --from=dependencies /app/node_modules ./node_modules
COPY . .

RUN corepack enable pnpm && pnpm run build;

# Install only production dependencies
FROM base AS production-dependencies
WORKDIR /app
COPY package.json pnpm-lock.yaml* ./
RUN corepack enable pnpm && pnpm i --prod --frozen-lockfile;

# Production image, copy all the files and run node
FROM base AS runner
WORKDIR /app

ENV PORT=80

COPY --from=production-dependencies /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist

EXPOSE ${PORT}

CMD ["node", "./dist/index.js"]