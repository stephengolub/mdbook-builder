# mdbook Docker Container

A multi-platform Docker container for [mdbook](https://github.com/rust-lang/mdBook) with commonly used plugins, available for both x64 and ARM64 architectures.

## Features

- **Multi-platform support**: Works on both x64 and ARM64 (Apple Silicon, Raspberry Pi, etc.)
- **Pre-installed plugins**:
  - `mdbook-toc` (0.15.1) - Table of contents generation
  - `mdbook-mermaid` (0.17.0) - Mermaid diagram support
  - `mdbook-pagetoc` (0.2.2) - Page table of contents
  - `mdbook-footnote` (0.1.1) - Footnote support
  - `mdbook-frontmatter` (0.0.4) - Frontmatter processing
  - `mdbook-obsidian` (0.1.0) - Obsidian-style wikilinks
- **Small image size**: Multi-stage build with minimal runtime dependencies
- **Security**: Runs as non-root user

## Quick Start

### Using GitHub Container Registry

Once the image is published to ghcr.io, you can pull and use it directly:

```bash
# Pull the image
docker pull ghcr.io/stephengolub/mdbook-builder:latest

# Build a book
docker run --rm -v "$(pwd):/book" ghcr.io/stephengolub/mdbook-builder:latest mdbook build

# Serve a book for development
docker run --rm -v "$(pwd):/book" -p 3000:3000 ghcr.io/stephengolub/mdbook-builder:latest

# Initialize a new book
docker run --rm -v "$(pwd):/book" ghcr.io/stephengolub/mdbook-builder:latest mdbook init
```

### Building Locally

```bash
# Build the image
docker build -t mdbook-build .

# Use the convenience scripts
./build-mdbook.sh /path/to/book    # Build a book
./serve-mdbook.sh /path/to/book    # Serve for development
```

## Usage Examples

### Build a Book

```bash
docker run --rm \
  -v "$(pwd):/book" \
  ghcr.io/stephengolub/mdbook-builder:latest \
  mdbook build
```

### Serve with Live Reload

```bash
docker run --rm \
  -v "$(pwd):/book" \
  -p 3000:3000 \
  ghcr.io/stephengolub/mdbook-builder:latest
```

### Custom Configuration

```bash
# With custom config file
docker run --rm \
  -v "$(pwd):/book" \
  -v "$(pwd)/custom-book.toml:/book/book.toml" \
  ghcr.io/stephengolub/mdbook-builder:latest \
  mdbook build
```

### Using with Docker Compose

Create a `docker-compose.yml`:

```yaml
version: '3.8'

services:
  mdbook:
    image: ghcr.io/stephengolub/mdbook-builder:latest
    volumes:
      - .:/book
    ports:
      - "3000:3000"
    command: mdbook serve --hostname 0.0.0.0
```

Then run:

```bash
docker-compose up
```

## GitHub Actions Integration

The repository includes a GitHub Actions workflow that:

1. Builds multi-platform images (x64 and ARM64)
2. Pushes to GitHub Container Registry (ghcr.io)
3. Tags images appropriately (latest, version tags, commit SHA)
4. Uses build caching for faster builds

The workflow triggers on:
- Push to main/master branch
- Version tags (v*)
- Pull requests (build only, no push)
- Manual dispatch

## Convenience Scripts

### build-mdbook.sh

Build a book using the Docker container:

```bash
./build-mdbook.sh [path/to/book]
```

### serve-mdbook.sh

Serve a book locally with live reload:

```bash
./serve-mdbook.sh [path/to/book] [port]
```

## Supported Platforms

- `linux/amd64` (x64)
- `linux/arm64` (ARM64/Apple Silicon)

## License

This Docker setup is provided as-is. Please refer to the individual licenses of mdbook and its plugins.

## Contributing

Feel free to submit issues and pull requests for improvements to the Docker setup.

## Notes

- The container runs as a non-root user (UID 1000) for security
- The working directory is `/book`
- Default serve port is 3000
- All plugins are installed with specific versions for reproducibility