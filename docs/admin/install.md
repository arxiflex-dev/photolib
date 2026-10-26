# Installing photolibd

The all-in-one bundle in `deploy/compose` runs photolibd, PostgreSQL 18 and Caddy, which gets and renews the TLS
certificate. A fresh install takes about ten minutes, most of it waiting for DNS and image downloads.

## Before you start

* An amd64 or arm64 host that runs Linux containers: Linux with Docker Engine 23 or newer and its compose plugin, or
  Docker Desktop on Windows or macOS, WSL2 or a NAS's container manager. There is no native Windows or macOS
  photolibd, as its media sandbox ([ADR-0024](../adr/0024-media-sandbox.md)) needs Linux; the desktop app's
  trusted-node mode (M6-11) will run natively on Windows and macOS.
* A DNS record for the server's name, such as `photos.example.com`, pointing at the host, and ports 80 and 443 reaching
  it from the internet: Let's Encrypt checks both before it issues the certificate.

## Install

As the user who should own Photolib's files (or with `sudo`, which then uses yours):

```sh
mkdir photolib
curl -fsSL https://github.com/arxiflex-dev/photolib/archive/refs/heads/main.tar.gz |
  tar -xz --strip-components=3 -C photolib photolib-main/deploy/compose
sh photolib/setup.sh photos.example.com
```

`setup.sh` writes `photolib/.env` from `.env.example` with the domain, your user and group (`PUID`, `PGID`) and a new
database password, makes `data/`, `keys/`, `postgres/` and `caddy/`, and starts the bundle. Add a second argument such as
`/photos` to serve Photolib at `https://photos.example.com/photos/` beside other sites. Passkeys bind to the domain
(`public_url`). Then create the first administrator in the app or web app with the setup token that `cd photolib &&
docker compose logs photolibd` shows ([accounts](users.md)), make a second person an administrator too, so that
someone can run and restore the server when you cannot, and make the
[admin-succession kit](backups.md#the-admin-succession-kit).

Every container runs as `PUID:PGID` on a read-only root filesystem, and everything it keeps is in the bind-mounted
directories next to `compose.yaml`: [back those up](backups.md#backing-up-the-originals). `keys/` holds the OPAQUE
key: back it up apart from the database dumps in `data/backups` ([accounts](users.md#the-opaque-key-file)).
`PHOTOLIB_DATA` in `.env` moves the libraries elsewhere.

## Upgrade

Every setting is in `.env`, so an upgrade replaces the bundle's files and never edits them; photolibd settings
beyond it, such as [object stores](storage.md#set-up-a-bucket), go in a `compose.override.yaml` beside
`compose.yaml`, which upgrades leave alone. `PHOTOLIB_VERSION` picks the [release channel](upgrades.md#release-channels).
photolibd dumps the database before it migrates the schema ([upgrades](upgrades.md)):

```sh
curl -fsSL https://github.com/arxiflex-dev/photolib/archive/refs/heads/main.tar.gz |
  tar -xz --strip-components=3 -C photolib photolib-main/deploy/compose
cd photolib && docker compose pull && docker compose up -d
```

## On a NAS

`deploy/nas` holds photolibd with PostgreSQL for NAS app stores, each pinned to a release: photolibd answers on port
8080 for the LAN or the NAS's own reverse proxy (set `PHOTOLIB_TRUSTED_PROXIES` to its address). The libraries are in
`data/`, the [OPAQUE key](users.md#the-opaque-key-file) in `keys/` and the database in `postgres/`: back up `keys/`
apart from `data/`. An upgrade is the store's update, or the next release's file.

* **Synology Container Manager** and **Portainer**: a project from `deploy/nas/compose.yaml` with an `.env` beside it
  that sets `POSTGRES_PASSWORD`, `PHOTOLIB_PUBLIC_URL` (such as `http://nas.local:8080`) and your `PUID` and `PGID`;
  create `data/`, `keys/` and `postgres/` owned by them first.
* **TrueNAS** (24.10 or newer): *Apps › Discover apps › Install via YAML* with `deploy/nas/compose.yaml`, its
  `${...}` replaced by your values and `./` by a dataset's path.
* **CasaOS** (`deploy/nas/casaos`), **Umbrel** (`deploy/nas/umbrel`) and **Unraid** (`deploy/nas/unraid`, photolibd
  alone beside a PostgreSQL container of yours): their app stores' entries.

## On Kubernetes

The Helm chart `deploy/helm/photolib` runs photolibd against a PostgreSQL 16 or newer that you provide, whose URL is
the key `url` of a Secret:

```sh
kubectl create secret generic photolib-db --from-literal=url='postgres://photolib:…@db/photolib'
helm install photos deploy/helm/photolib --set publicUrl=https://photos.example.com --set database.secret=photolib-db
```

It claims a volume for the libraries and one for the OPAQUE key (both kept by `helm uninstall`) and runs every role in
one Deployment, replaced on upgrade. `helm upgrade` first runs `photolibd migrate` in a Job, which dumps and migrates
the schema ([upgrades](upgrades.md)). For a scaled install, on storage every node reaches, give each process its own
entry of `deployments` with its roles and replicas; a Deployment of more than one replica gets a disruption budget.
Route an Ingress of your own to the Service on port 8080, with the limits of [reverse proxies](reverse-proxy.md).

## Other ways to run photolibd

* Behind a proxy of your own: `deploy/proxy` has templates for Traefik, nginx, Apache, Nginx Proxy Manager and
  Cloudflare Tunnel ([reverse proxies](reverse-proxy.md)).
* The image alone: `ghcr.io/arxiflex-dev/photolib`, configured with `PHOTOLIB_*` variables
  ([configuration](configuration.md)); give it `--read-only --tmpfs /tmp`, a writable `/data`, and
  `PHOTOLIB_OPAQUE_KEY_FILE` on a volume of its own or as a Docker secret.
* From source, on Linux: build photolibd from `server/` ([server](https://github.com/arxiflex-dev/photolib/blob/main/server/README.md));
  it needs libvips, FFmpeg, ExifTool and PostgreSQL's client programs. No static binary is published: photolibd links
  libvips, which may only be linked dynamically ([ADR-0096](../adr/0096-deployment-images-compose-and-proxies.md)).

## Without Docker

On Debian 13, Ubuntu 24.04 or newer, the `photolibd` package runs the server as a service with a PostgreSQL cluster of
its own, on a desktop or a small box ([ADR-0249](../adr/0249-packaging-and-distribution.md)):

```sh
sudo apt install ./photolibd_<version>_amd64.deb
sudo systemctl enable --now photolibd
journalctl -u photolibd | grep setup    # the first administrator's setup token
```

photolibd answers on port 8080 of every address; its settings are `/etc/photolib/photolibd.yaml`, which upgrades keep.
It keeps the libraries in `/var/lib/photolib/data`, the OPAQUE key in `/var/lib/photolib/keys` and its cluster
(`database.cluster`, [configuration](configuration.md)) in `/var/lib/photolib/postgres`, made from the distribution's
PostgreSQL programs and stopped with it. An upgrade is `apt install` of the next release's package, which migrates
the schema at the next start. When the distribution moves to a new PostgreSQL major, keep the old one's programs
installed until you have upgraded the cluster with `pg_upgrade`: photolibd refuses a cluster of another major.
