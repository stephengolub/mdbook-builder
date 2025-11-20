#!/bin/bash
# Script to build mdbook using Docker container

# Set default book directory to current directory
BOOK_DIR="${1:-.}"

# Resolve to absolute path
BOOK_DIR=$(cd "$BOOK_DIR" && pwd)

# Use ghcr.io image if available, otherwise use local
IMAGE_NAME="${MDBOOK_IMAGE:-mdbook-build}"

# To use the ghcr.io image by default, uncomment the next line:
# IMAGE_NAME="${MDBOOK_IMAGE:-ghcr.io/stephengolub/mdbook-builder:latest}"

echo "Building mdbook in: $BOOK_DIR"
echo "Using image: $IMAGE_NAME"

# Run the mdbook build container
docker run --rm \
    -v "$BOOK_DIR:/book" \
    "$IMAGE_NAME" \
    mdbook build

if [ $? -eq 0 ]; then
    echo "✅ Build complete! Output is in $BOOK_DIR/book"
else
    echo "❌ Build failed"
    exit 1
fi