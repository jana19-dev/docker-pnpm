# PNPM Docker Images

[![Docker Pulls](https://img.shields.io/docker/pulls/jana19/pnpm)](https://hub.docker.com/r/jana19/pnpm)
[![Docker Image Size](https://img.shields.io/docker/image-size/jana19/pnpm/24-alpine)](https://hub.docker.com/r/jana19/pnpm)
[![Build Status](https://github.com/jana19-dev/docker-pnpm/workflows/Build%20and%20Push%20PNPM%20Docker%20Image/badge.svg)](https://github.com/jana19-dev/docker-pnpm/actions)

Pre-built Docker images with Node.js and pnpm pre-installed, available in both Alpine (production) and standard (development) variants.

## Available Tags

| Tag | Base Image | Node.js Version | Use Case | Size |
|-----|------------|----------------|----------|------|
| `24-alpine` | node:24-alpine | Latest Node.js 24.x.x | Production | ~192MB |
| `24` | node:24 | Latest Node.js 24.x.x | Development | ~400MB |

> **Note**: We only maintain Node.js 24+ versions. When Node.js 25 is released, `25-alpine` and `25` tags will be automatically added.

## Quick Start

```bash
# Production use (Alpine - smaller size)
docker run --rm jana19/pnpm:24-alpine pnpm --version

# Development use (Standard - includes more tools)
docker run --rm jana19/pnpm:24 pnpm --version

# Use in a Dockerfile (Production)
FROM jana19/pnpm:24-alpine
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile
COPY . .
RUN pnpm build

# Use in a Dockerfile (Development)
FROM jana19/pnpm:24
COPY package.json pnpm-lock.yaml ./
RUN pnpm install
COPY . .
```

## Features

- ✅ **Alpine variant**: Minimal size (~192MB) for production
- ✅ **Standard variant**: Full toolset (~400MB) for development
- ✅ Latest pnpm pre-installed
- ✅ Multi-architecture support (amd64, arm64)
- ✅ Automatic updates weekly for Node.js 24+
- ✅ Non-root user for security
- ✅ Future-proof for Node.js 25, 26, etc.

## Usage Examples

### Development Environment

```bash
# Interactive shell with pnpm (Alpine)
docker run -it --rm -v $(pwd):/app jana19/pnpm:24-alpine sh

# Interactive shell with pnpm (Standard - better for debugging)
docker run -it --rm -v $(pwd):/app jana19/pnpm:24 bash

# Run pnpm commands
docker run --rm -v $(pwd):/app -w /app jana19/pnpm:24-alpine pnpm install
docker run --rm -v $(pwd):/app -w /app jana19/pnpm:24-alpine pnpm run build
```

### Production Dockerfile

```dockerfile
FROM jana19/pnpm:24-alpine AS dependencies
WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile --prod

FROM jana19/pnpm:24-alpine AS build
WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile
COPY . .
RUN pnpm run build

FROM node:24-alpine AS runtime
WORKDIR /app
COPY --from=dependencies /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist
COPY package.json ./
EXPOSE 3000
CMD ["node", "dist/index.js"]
```

### Docker Compose

```yaml
version: '3.8'
services:
  # Production service (Alpine)
  app-prod:
    image: jana19/pnpm:24-alpine
    working_dir: /app
    volumes:
      - .:/app
    command: pnpm start
    ports:
      - "3000:3000"

  # Development service (Standard)
  app-dev:
    image: jana19/pnpm:24
    working_dir: /app
    volumes:
      - .:/app
    command: pnpm dev
    ports:
      - "3001:3000"
```

## Update Schedule

Images are automatically updated:
- **Weekly**: Every Sunday at 2 AM UTC to check for new Node.js patch versions
- **Manual**: Can be triggered manually via GitHub Actions
- **On Changes**: When Dockerfile or workflow changes are pushed

## Supported Node.js Versions

This repository maintains images for Node.js 24+ only:
- **Node.js 24**: Current (both `-alpine` and standard variants)
- **Node.js 25+**: Future versions will be automatically added when released

We focus on modern Node.js versions to ensure optimal performance and security. Legacy versions (18, 20, 22) are no longer maintained.

## Security

- Images run as non-root user (`nextjs:nodejs`)
- Based on official Node.js Alpine images
- Regular security updates through automated builds
- Multi-architecture support for better compatibility

## Local Development

```bash
# Build Alpine variant (default)
./build.sh 24 alpine
npm run build:24-alpine

# Build Standard variant
./build.sh 24 standard
npm run build:24-standard

# Test Alpine variant
./test.sh 24 alpine
npm run test:alpine

# Test Standard variant
./test.sh 24 standard
npm run test:standard
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test locally with both variants:
   ```bash
   ./build.sh 24 alpine && ./test.sh 24 alpine
   ./build.sh 24 standard && ./test.sh 24 standard
   ```
5. Submit a pull request

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Support

- 🐛 [Report bugs](https://github.com/jana19-dev/docker-pnpm/issues)
- 💬 [Discussions](https://github.com/jana19-dev/docker-pnpm/discussions)
- 📧 [Contact maintainer](mailto:your-email@example.com)
