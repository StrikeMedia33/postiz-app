FROM node:20-alpine

# Install system dependencies for node-gyp and canvas
RUN apk add --no-cache python3 make g++ cairo-dev pango-dev jpeg-dev giflib-dev

WORKDIR /app
COPY . .

# Install dependencies (workspace-aware, skip peer-dep checks)
RUN npm install --legacy-peer-deps

# Build the frontend app
WORKDIR /app/apps/frontend
RUN npm run build

EXPOSE 3000
CMD ["npm", "start"]
