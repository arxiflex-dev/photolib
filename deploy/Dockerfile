# photolibd's image (ADR-0096), built from the repository root for linux/amd64 or linux/arm64:
#   docker buildx build -f deploy/Dockerfile .
# Base images are pinned by digest. tools/image.sh checks the result.

FROM rust:1.99.1-alpine3.24@sha256:557a94c82b485a14b569120e00867267108c734efe33f10cc31ca0cd5dd1eca9 AS build
RUN apk add --no-cache vips-dev
WORKDIR /src
COPY kernel kernel
COPY server server
COPY tools/synthlib tools/synthlib
# libvips is LGPL and linked dynamically (ADR-0013), so photolibd links musl dynamically too.
ENV RUSTFLAGS="-C target-feature=-crt-static"
RUN --mount=type=cache,target=/usr/local/cargo/registry --mount=type=cache,target=/src/server/target \
    cd server && cargo build --locked --release -p photolib-server --bin photolibd && cp target/release/photolibd /

# Alpine builds FFmpeg (GPL, never nonfree), libvips and ExifTool alike on both architectures; libvips gets its HEIF
# and JPEG XL loaders but not ImageMagick's or PDF's (ADR-0084); PostgreSQL 18's client programs make the dump before
# a schema upgrade.
FROM alpine:3.24@sha256:294b683cb724975bec92580e1e685676bd4b50bda910ddb8c51d4cabeaec77e6
RUN apk add --no-cache ca-certificates exiftool ffmpeg postgresql18-client tzdata vips vips-heif vips-jxl
COPY --from=build /photolibd /usr/bin/
COPY <<EOF /usr/share/doc/photolib/SOURCES
photolibd (AGPL-3.0-only): https://github.com/arxiflex-dev/photolib at this image's org.opencontainers.image.revision.
FFmpeg (GPL), libvips (LGPL), ExifTool and every other package: Alpine Linux 3.24 builds, whose sources and build
recipes are at https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable and
https://distfiles.alpinelinux.org/distfiles/v3.24/.
EOF
LABEL org.opencontainers.image.source=https://github.com/arxiflex-dev/photolib \
      org.opencontainers.image.licenses=AGPL-3.0-only
ENV PHOTOLIB_CONFIG_VERSION=1 \
    PHOTOLIB_LISTEN=0.0.0.0:8080 \
    PHOTOLIB_DATA_DIR=/data \
    PHOTOLIB_FFMPEG_DIR=/usr/bin \
    PHOTOLIB_EXIFTOOL=[/usr/bin/exiftool]
USER 1000:1000
EXPOSE 8080
ENTRYPOINT ["photolibd"]
