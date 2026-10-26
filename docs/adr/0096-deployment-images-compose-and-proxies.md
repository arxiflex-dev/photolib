# ADR-0096 — Deployment: an Alpine image, compose with PostgreSQL, proxy templates under test

* **Status**: **Proposed — owner to confirm** (roadmap M2-30; open decisions 7 and 20).
* **Requirements**: R-SEC-4, R-REL-3, OPS-13, OPS-14, OPS-17, OPS-18. **Design**:
  reliability, migrations and operations §8, §9,
  open decisions.

## Context

photolibd must ship as multi-arch, non-root images with identical codecs on amd64 and arm64, a static binary, an
all-in-one compose file that upgrades without edits, and reverse-proxy templates tested against large uploads,
streams, server-sent events and HTTP/2. Open decision 7 leans towards a server image with codecs and a codecs-free
variant; decision 20 towards an all-in-one image plus compose, an embedded PostgreSQL to be evaluated in M2.

## Decision

1. **Image.** `deploy/Dockerfile` builds photolibd on musl (`rust:*-alpine`) and installs it on Alpine with Alpine's
   FFmpeg (GPL, never nonfree), libvips (without its ImageMagick and PDF loaders, ADR-0084), ExifTool and PostgreSQL
   18's client programs. Alpine builds those packages from one recipe for both architectures, so the codecs match;
   the weekly `image-parity` job proves it on the corpus. Every base image is pinned by digest. The image runs as
   `1000:1000`, declares no volume, needs only `/data` and `/tmp` writable, takes its settings from `PHOTOLIB_*`
   variables and carries a source offer for the GPL and LGPL programs. It is published as
   `ghcr.io/arxiflex-dev/photolib`, tagged by channel (`stable`, `beta`, `nightly`) and version.
2. **No static binary yet.** photolibd links libvips (ADR-0084), which ADR-0013 allows only as a dynamically linked
   system library, so a static photolibd needs a build without libvips: the owner's call. Until then the image is
   the one package, and the codecs-free variant of decision 7 is not built.
3. **Compose.** `deploy/compose` runs photolibd, the official PostgreSQL image and Caddy, each as `PUID:PGID` on a
   read-only root filesystem with no new privileges and bind mounts only. Every setting is a line of `.env`; an upgrade
   replaces `compose.yaml` and never edits it. photolibd trusts the forwarded headers of the bundle's own subnet.
   `setup.sh` is the one-command quickstart. No supervised PostgreSQL inside photolibd's image (decision 20).
4. **Proxies.** Caddy is recommended; Traefik, nginx, Apache, Nginx Proxy Manager and Cloudflare Tunnel templates live
   in `deploy/proxy`. The gate runs each, at `/` and under `/photos`, through `tests/proxies.rs`; cloudflared, whose
   edge is Cloudflare's, only validates its recipe offline.

## Consequences

* The gate checks everything but the image itself without a Docker daemon; `tools/image.sh` builds and runs the image
  weekly on amd64 and arm64 runners. Publishing and signing the images belongs to the release work (M2-34).
* PostgreSQL major upgrades stay with M2-31: the image's `pg_dump` must match the compose file's PostgreSQL major.
* Hardware transcoding (M7-02) may add packages or a variant; their codecs must still match across architectures.

## Options considered

* **A static photolibd with libvips linked in**: what the issue asks for, but ADR-0013 forbids linking LGPL
  libraries statically; a build without libvips would make no thumbnails.
* **Debian base**: its PostgreSQL client is 17, older than the server; Alpine has 18 on both architectures.
* **Static FFmpeg downloads**: identical codecs too, but prebuilt binaries we neither build nor can rebuild.
* **One image with PostgreSQL supervised inside**: one container, but two processes, root for the supervisor, and the
  database upgraded with the image.
* **Named volumes**: Docker's default, but they hide the data from the host's backups and file browser.
