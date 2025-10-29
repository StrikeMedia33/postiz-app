# ---- Base build stage ----
FROM node:22-alpine AS base
WORKDIR /app
COPY package*.json ./
COPY pnpm-lock.yaml* ./
ENV PRISMA_SCHEMA_PATH=./libraries/nestjs-libraries/src/database/prisma/schema.prisma
RUN npm install -g pnpm
RUN PRISMA_SCHEMA_PATH=$PRISMA_SCHEMA_PATH pnpm install --no-frozen-lockfile

# ---- Build frontend and backend ----
COPY . .
RUN pnpm --filter ./apps/frontend build
RUN pnpm --filter ./apps/backend build

# ---- Production runtime ----
FROM node:22-alpine
WORKDIR /app

# Copy compiled artifacts
COPY --from=base /app .

# Expose the port Render uses
ENV PORT=10000
EXPOSE 10000

# Start both backend (NestJS) and frontend (Next.js)
CMD ["sh", "-c", "pnpm --filter ./apps/backend start:prod & pnpm --filter ./apps/frontend start"]
