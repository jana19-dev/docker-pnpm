#!/bin/bash

# Test script to verify the Docker image works correctly
set -e

NODE_VERSION=${1:-24}
VARIANT=${2:-alpine}

# Set image tag based on variant
if [[ "$VARIANT" == "alpine" ]]; then
    IMAGE_TAG="jana19/pnpm:${NODE_VERSION}-alpine"
    BUILD_CMD="./build.sh $NODE_VERSION alpine"
else
    IMAGE_TAG="jana19/pnpm:${NODE_VERSION}"
    BUILD_CMD="./build.sh $NODE_VERSION standard"
fi

echo "Testing Docker image: $IMAGE_TAG ($VARIANT variant)"
echo "========================================"

# Test 1: Check if image exists
echo "1. Checking if image exists..."
if docker images --format "table {{.Repository}}:{{.Tag}}" | grep -q "$IMAGE_TAG"; then
    echo "✅ Image $IMAGE_TAG found"
else
    echo "❌ Image $IMAGE_TAG not found. Please build it first with: $BUILD_CMD"
    exit 1
fi

# Test 2: Check Node.js version
echo ""
echo "2. Testing Node.js version..."
NODE_OUTPUT=$(docker run --rm $IMAGE_TAG node --version)
echo "✅ Node.js version: $NODE_OUTPUT"

# Test 3: Check pnpm version
echo ""
echo "3. Testing pnpm version..."
PNPM_OUTPUT=$(docker run --rm $IMAGE_TAG pnpm --version)
echo "✅ pnpm version: $PNPM_OUTPUT"

# Test 4: Check user
echo ""
echo "4. Testing user (should not be root)..."
USER_OUTPUT=$(docker run --rm $IMAGE_TAG whoami)
if [ "$USER_OUTPUT" != "root" ]; then
    echo "✅ Running as non-root user: $USER_OUTPUT"
else
    echo "⚠️  Warning: Running as root user"
fi

# Test 5: Test pnpm functionality
echo ""
echo "5. Testing pnpm functionality..."
PNPM_HELP=$(docker run --rm $IMAGE_TAG pnpm --help | head -1)
echo "✅ pnpm help: $PNPM_HELP"

# Test 6: Check image size
echo ""
echo "6. Image size information..."
SIZE=$(docker images --format "table {{.Size}}" --filter "reference=$IMAGE_TAG" | tail -1)
echo "✅ Image size: $SIZE"

echo ""
echo "========================================"
echo "🎉 All tests passed for $IMAGE_TAG!"
