# Use Node.js Alpine as base image
ARG NODE_VERSION=24
FROM node:${NODE_VERSION}-alpine

# Install pnpm globally
RUN npm install -g pnpm

# Set working directory
WORKDIR /app

# Add a label for better organization
LABEL maintainer="jana19"
LABEL description="Node.js Alpine with pnpm pre-installed"

# Create a non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nextjs -u 1001

# Switch to non-root user
USER nextjs

# Default command
CMD ["pnpm", "--version"]
