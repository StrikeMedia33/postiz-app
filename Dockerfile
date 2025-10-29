# ---- Base build stage ----
FROM node:22-alpine AS base
WORKDIR /app
COPY package*.json ./
COPY pnpm-lock.yaml* ./
RUN npm install -g pnpm
RUN pnpm install --no-frozen-lockfile

# ---- Copy full source and generate Prisma client ----
COPY . .
RUN pnpm dlx prisma generate --schema ./libraries/nestjs-libraries/src/database/prisma/schema.prisma

# ---- Build frontend and backend ----
RUN pnpm --filter ./apps/frontend build
RUN pnpm --filter ./apps/backend build

# ---- Production runtime ----
FROM node:22-alpine
WORKDIR /app
COPY --from=base /app .
ENV PORT=10000
EXPOSE 10000

# ---- Run both backend and frontend ----
CMD ["sh", "-c", "pnpm --filter ./apps/backend start:prod & pnpm --filter ./apps/frontend start"]
