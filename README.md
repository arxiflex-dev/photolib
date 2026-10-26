# Photolib

A private, local-first photo and video library: a gallery app first, and a self-hosted server second. One Flutter app
replaces your phone's gallery and browses local folders on the desktop. When you want backup, sync, sharing, search
and web access, you connect it to a fast Rust server that you run yourself, with an optional zero-knowledge private
mode.

> **Status: pre-alpha.** This repository was just created and is not yet usable. The folders below are the agreed
> layout; the code arrives milestone by milestone. The design, research and roadmap live in the
> design repository.

## Repository layout

| Folder | What lives there |
|---|---|
| [`proto/`](proto/) | The protobuf IDL: every wire message and service, generated for Rust, Dart and TypeScript |
| [`kernel/`](kernel/) | `photolib-kernel`, the pure Rust crate with the rules every client and the server must agree on |
| [`server/`](server/) | The Rust workspace behind `photolibd` (one binary with roles) and the `photolib` CLI |
| [`app/`](app/) | The Flutter app for Android, iOS, macOS, Windows, Linux and the web |
| [`viewer/`](viewer/) | The lightweight TypeScript viewer for public links and static exports |
| [`deploy/`](deploy/) | Compose files, the Helm chart, NAS catalog entries and reverse-proxy templates |
| [`docs/`](docs/) | User, administrator and developer documentation, and the architecture decision records |
| [`tools/`](tools/) | The quality gate, repository tests, commit message checker and developer tooling |
| [`testdata/`](testdata/) | Small, licence-clean fixtures shared by tests |

Each folder has a short README describing its architecture and linking the design documents it implements.

## Development environment

You need [Docker](https://docs.docker.com/get-docker/) with the Compose plugin, [just](https://just.systems/),
[pre-commit](https://pre-commit.com/) and Python 3. Running the server and the app also needs Rust (via
[rustup](https://rustup.rs/)), libvips 8.15 or later with libheif's HEVC plugin (Debian and Ubuntu: `libvips-dev
libheif-plugin-libde265`), [Flutter](https://docs.flutter.dev/get-started/install) and, for the app on Linux, libmpv
(`libmpv-dev`). The `.devcontainer.json` at the root provides all of it except Flutter and libmpv: open the folder in
a dev container (VS Code or Codespaces) and it runs the bootstrap for you.

```sh
git clone https://github.com/arxiflex-dev/photolib.git && cd photolib
just bootstrap    # secrets, dev stack, seed data, git hooks (the first run pulls three container images)
just run-server   # in one terminal
just run-app      # in another
just test         # the quality gate, the same as bash tools/check.sh
```

`just bootstrap` is safe to repeat. It generates random secrets into `tools/dev/.env` (owner-readable, git-ignored,
never committed), starts the stack in `tools/dev/compose.yaml`, loads the seed data and installs the git hooks. The
stack listens on loopback only:

| Service | Address |
|---|---|
| PostgreSQL 18 | `localhost:5432`; `DATABASE_URL` is in `tools/dev/.env` |
| S3-compatible store ([Garage](docs/adr/0018-dev-s3-store.md)) | `http://localhost:3900`, bucket `photolib-dev`; keys in `tools/dev/.env` |
| Caddy with local TLS | `https://photolib.localhost:8443`, proxying to the server on host port 8080 |

Caddy signs with its own certificate authority. Bootstrap copies the root certificate to `tools/dev/caddy-root.crt`; add
it to your system or browser trust store, or pass it to `curl --cacert`. On Linux the server must listen on
`0.0.0.0:8080` so Caddy, which runs in a container, can reach it.

The seed set in [`testdata/seed/`](testdata/seed/) has three users, two libraries and six small synthetic photos; the
loader uploads the photos to the bucket. `just seed` loads it again, `just down` stops the stack and keeps its data, and
`just reset` deletes the data as well.

> The app shell needs no server to start: `just run-app -d linux` (or `-d chrome`) shows it. Its Flutter version is
> the one pinned in `app/.fvmrc` (see [the Flutter page](docs/dev/flutter.md)).

## Checking your work

One command runs every check that applies to the parts of the repository that exist, and CI runs the same one:

```sh
bash tools/check.sh
```

Commit message and merge conventions are in [AGENTS.md](AGENTS.md#commits).

## Licence

Photolib is licensed under AGPL-3.0-only; the text is in [`LICENSE`](LICENSE). Contributions are made under the same
licence and signed off with the [Developer Certificate of Origin](DCO); there is no CLA. The choice is recorded in
[ADR-0013](docs/adr/0013-licence.md).
