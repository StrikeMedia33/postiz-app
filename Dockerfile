# Use Node.js LTS base image
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Copy everything
COPY . .

# Install dependencies (workspace-aware)
RUN npm install

# Build the frontend app
WORKDIR /app/apps/frontend
RUN npm run build

# Expose the port
EXPOSE 3000

# Start the frontend app
CMD ["npm", "start"]
