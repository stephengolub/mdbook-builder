#!/bin/bash
# Script to serve mdbook locally using Docker container

# Set default book directory to current directory
BOOK_DIR="${1:-.}"
PORT="${2:-3000}"

# Resolve to absolute path
BOOK_DIR=$(cd "$BOOK_DIR" && pwd)

# Use ghcr.io image if available, otherwise use local
IMAGE_NAME="${MDBOOK_IMAGE:-mdbook-build}"

# To use the ghcr.io image by default, uncomment the next line:
# IMAGE_NAME="${MDBOOK_IMAGE:-ghcr.io/stephengolub/mdbook-builder:latest}"

echo "Serving mdbook from: $BOOK_DIR"
echo "Using image: $IMAGE_NAME"
echo "Access at: http://localhost:$PORT"
echo "Press Ctrl+C to stop"

# Run the mdbook serve container
docker run --rm \
    -v "$BOOK_DIR:/book" \
    -p "$PORT:3000" \
    "$IMAGE_NAME" \
    mdbook serve --hostname 0.0.0.0