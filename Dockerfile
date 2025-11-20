# Multi-stage build for smaller final image
FROM rust:1.91-bookworm as builder

# Set cargo install root
ENV CARGO_INSTALL_ROOT=/usr/local/cargo

# Install build dependencies
RUN apt-get update && apt-get install -y \
    pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Install mdbook and plugins with specific versions for reproducibility
RUN --mount=type=cache,target=/usr/local/cargo/registry \
    --mount=type=cache,target=/usr/local/cargo/git \
    cargo install --locked \
    mdbook --version 0.5.1 && \
    cargo install --locked \
    mdbook-toc --version 0.15.1 && \
    cargo install --locked \
    mdbook-mermaid --version 0.16.2 && \
    cargo install --locked \
    mdbook-pagetoc --version 0.2.2 && \
    cargo install --locked \
    mdbook-footnote --version 0.1.1 && \
    cargo install --locked \
    mdbook-frontmatter --version 0.0.4 && \
    cargo install --locked \
    mdbook-obsidian --version 0.1.0

# Final stage - smaller runtime image
FROM debian:bookworm-slim

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy built binaries from builder stage
COPY --from=builder /usr/local/cargo/bin/mdbook* /usr/local/bin/

# Add metadata labels
LABEL org.opencontainers.image.source="https://github.com/stephengolub/mdbook-builder"
LABEL org.opencontainers.image.description="Multi-platform mdbook with plugins"
LABEL org.opencontainers.image.licenses="MIT"

# Create non-root user
RUN useradd -m -u 1000 mdbook && \
    mkdir -p /book && \
    chown -R mdbook:mdbook /book

# Switch to non-root user
USER mdbook

# Set the working directory
WORKDIR /book

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD mdbook --version || exit 1

# Default command
CMD ["mdbook", "serve", "--hostname", "0.0.0.0"]
