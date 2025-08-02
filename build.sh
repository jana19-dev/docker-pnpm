#!/bin/bash

# Local build script for testing
set -e

echo "Building PNPM Docker images locally..."

# Default to Node.js 24 if no version specified
NODE_VERSION=${1:-24}
VARIANT=${2:-alpine}

echo "Building for Node.js version: $NODE_VERSION ($VARIANT variant)"

# Set dockerfile and tags based on variant
if [[ "$VARIANT" == "alpine" ]]; then
    DOCKERFILE="Dockerfile"
    TAG_SUFFIX="-alpine"
    LATEST_TAG="latest-alpine"
else
    DOCKERFILE="Dockerfile.standard"
    TAG_SUFFIX=""
    LATEST_TAG="latest"
fi

# Build the image
docker build \
  --file $DOCKERFILE \
  --build-arg NODE_VERSION=$NODE_VERSION \
  -t jana19/pnpm:${NODE_VERSION}${TAG_SUFFIX} \
  -t jana19/pnpm:$LATEST_TAG \
  .

echo "Build completed successfully!"
echo ""
echo "Test the image:"
echo "  docker run --rm jana19/pnpm:${NODE_VERSION}${TAG_SUFFIX} pnpm --version"
echo "  docker run --rm jana19/pnpm:${NODE_VERSION}${TAG_SUFFIX} node --version"
echo ""
echo "Push to Docker Hub:"
echo "  docker push jana19/pnpm:${NODE_VERSION}${TAG_SUFFIX}"
