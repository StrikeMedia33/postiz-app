FROM node:20-alpine

# Install system dependencies for node-gyp and canvas, plus pnpm
RUN apk add --no-cache python3 make g++ cairo-dev pango-dev jpeg-dev giflib-dev \
  && npm install -g pnpm

WORKDIR /app
COPY . .

# Install dependencies (workspace-aware, skip peer-dep checks)
RUN npm install --legacy-peer-deps

# Build the frontend app
WORKDIR /app/apps/frontend
RUN npm run build

# Expose the Render port
EXPOSE 10000

# Start the app on Render's assigned port
CMD ["sh", "-c", "npm start -- -p ${PORT:-10000}"]
