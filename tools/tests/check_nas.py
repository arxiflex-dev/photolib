#!/usr/bin/env python3
"""Check deploy/nas, the NAS catalogs' entries: each runs the release's photolibd beside the compose bundle's
PostgreSQL, as the bundle does (deploy/compose)."""
import json
import os
import re
import subprocess
import xml.etree.ElementTree as ET

import miniyaml
from checklib import ROOT, check, finish, read

NAS = os.path.join(ROOT, "deploy", "nas")
VERSION = re.search(r"^version: *([0-9.]+)", read("app/pubspec.yaml"), re.MULTILINE)[1]
IMAGE = f"ghcr.io/arxiflex-dev/photolib:{VERSION}"
POSTGRES = re.search(r"image: (postgres:\S+)", read("deploy/compose/compose.yaml"))[1]
ENV = {"POSTGRES_PASSWORD": "secret", "PHOTOLIB_PUBLIC_URL": "http://nas.local:8080", "PUID": "1026", "PGID": "100",
       "AppID": "photolib", "APP_DATA_DIR": "/umbrel/app-data/photolib", "APP_PASSWORD": "secret",
       "DEVICE_DOMAIN_NAME": "umbrel.local"}


def compose(path):
    run = subprocess.run(["docker", "compose", "-f", os.path.join(NAS, path), "config", "--format", "json"],
                         capture_output=True, text=True, check=False, env={**os.environ, **ENV}, cwd=NAS)
    check(run.returncode == 0, f"{path} is valid", run.stderr.strip())
    return json.loads(run.stdout or "{}").get("services", {})


def mounts(service):
    return {volume["target"]: volume["source"] for volume in service.get("volumes", [])}


def like_the_bundle(name, services, base):
    photolibd, postgres = services.get("photolibd", {}), services.get("postgres", {})
    env = photolibd.get("environment", {})
    check(photolibd.get("image") == IMAGE, f"{name}: the release's photolibd ({photolibd.get('image')})")
    check(postgres.get("image") == POSTGRES, f"{name}: the bundle's PostgreSQL, whose major pg_dump matches")
    password = postgres.get("environment", {}).get("POSTGRES_PASSWORD")
    check(password and env.get("PHOTOLIB_DATABASE__URL") == f"postgres://photolib:{password}@postgres/photolib",
          f"{name}: photolibd signs in to its PostgreSQL")
    check(env.get("PHOTOLIB_OPAQUE_KEY_FILE") == "/keys/opaque.key" and
          mounts(photolibd) == {"/data": f"{base}/data", "/keys": f"{base}/keys"} and
          mounts(postgres) == {"/var/lib/postgresql": f"{base}/postgres"},
          f"{name}: data/, keys/ (the OPAQUE key apart from the libraries, ADR-0052) and postgres/ in {base}")
    for service, spec in services.items():
        if service != "app_proxy":
            check(spec.get("read_only") is True and re.fullmatch(r"\d+:\d+", spec.get("user", "")),
                  f"{name}: {service} runs as a user on a read-only root filesystem ({spec.get('user')})")
    return env


env = like_the_bundle("compose.yaml", compose("compose.yaml"), NAS)
check(env.get("PHOTOLIB_PUBLIC_URL") == ENV["PHOTOLIB_PUBLIC_URL"], "compose.yaml: the public URL is a setting")
casaos = compose("casaos/docker-compose.yml")
like_the_bundle("CasaOS", casaos, "/DATA/AppData/photolib")
check(casaos.get("photolibd", {}).get("user") == "1026:100", "CasaOS: as the user CasaOS names")
store = miniyaml.load(read("deploy/nas/casaos/docker-compose.yml")).get("x-casaos", {})
check(store.get("main") == "photolibd" and store.get("port_map") == "8080" and store.get("category") == "Gallery",
      "CasaOS: its store opens photolibd's port")

umbrel = miniyaml.load(read("deploy/nas/umbrel/docker-compose.yml"))["services"]
for spec in umbrel.values():
    spec["environment"] = {k: re.sub(r"\$\{(\w+)\}", lambda m: ENV[m[1]], str(v))
                           for k, v in (spec.get("environment") or {}).items()}
    spec["volumes"] = [dict(zip(("source", "target"), v.replace("${APP_DATA_DIR}", ENV["APP_DATA_DIR"]).split(":")[:2]))
                       for v in spec.get("volumes", [])]
like_the_bundle("Umbrel", umbrel, ENV["APP_DATA_DIR"])
app = miniyaml.load(read("deploy/nas/umbrel/umbrel-app.yml"))
proxy = umbrel.get("app_proxy", {}).get("environment", {})
check(app.get("id") == "photolib" and app.get("version") == VERSION and
      proxy.get("APP_HOST") == "photolib_photolibd_1" and proxy.get("APP_PORT") == "8080",
      "Umbrel: the app of the release, its proxy in front of photolibd")
check(proxy.get("PROXY_AUTH_ADD") == "false", "Umbrel: photolibd signs in its own users, apps included")

unraid = ET.fromstring(read("deploy/nas/unraid/photolib.xml"))
configs = {c.get("Target"): c for c in unraid.iter("Config")}
check(unraid.findtext("Repository") == IMAGE, "Unraid: the release's photolibd")
check({"8080", "/data", "/keys", "PHOTOLIB_DATABASE__URL", "PHOTOLIB_PUBLIC_URL", "PHOTOLIB_OPAQUE_KEY_FILE"} <=
      set(configs), f"Unraid: its port, mounts and settings ({sorted(configs)})")
check(configs.get("PHOTOLIB_DATABASE__URL", ET.Element("x")).get("Mask") == "true" and
      configs.get("PHOTOLIB_OPAQUE_KEY_FILE", ET.Element("x")).get("Default") == "/keys/opaque.key",
      "Unraid: the database password is masked, the OPAQUE key apart from the libraries")
check(re.search(r"--user \d+:\d+ --read-only --tmpfs /tmp", unraid.findtext("ExtraParams") or ""),
      "Unraid: non-root on a read-only root filesystem")
finish()
