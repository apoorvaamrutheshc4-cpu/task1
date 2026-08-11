# Stage 1: Build
FROM node:22 AS builder

WORKDIR /app

# Copy dependency files first for Docker layer caching
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy application source
COPY . .

# Stage 2: Runtime
FROM node:22-alpine

WORKDIR /app

# Copy application from builder
COPY --from=builder /app .

# Create a non-root group and user
RUN addgroup -S appgroup && \
    adduser -S appuser -G appgroup

# Run application as non-root user
USER appuser

# Application port
EXPOSE 3000

# Start application
CMD ["npm", "start"]
