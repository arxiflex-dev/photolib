#!/usr/bin/env python3
"""Check deploy/compose, the all-in-one compose file, through `docker compose config` (no daemon) with an .env."""
import json
import os
import re
import subprocess
import sys

from checklib import ROOT, check, finish, read

DIR = os.path.join(ROOT, "deploy", "compose")
IMAGE = "ghcr.io/arxiflex-dev/photolib"


def config(env_file):
    run = subprocess.run(["docker", "compose", "--env-file", env_file, "-f", os.path.join(DIR, "compose.yaml"), "config",
                          "--format", "json"], capture_output=True, text=True, check=False)
    check(run.returncode == 0, f"compose.yaml is valid with {os.path.basename(env_file)}", run.stderr.strip())
    return json.loads(run.stdout or "{}")


def main(env_file):
    env = dict(re.findall(r"^(\w+)=(.*)$", read(env_file), re.M))
    used = set(re.findall(r"\$\{(\w+)", read(os.path.join(DIR, "compose.yaml"))))
    check(used == set(re.findall(r"^(\w+)=", read(os.path.join(DIR, ".env.example")), re.M)),
          f"every setting is a line of .env.example, so compose.yaml is never edited ({sorted(used)})")
    services = config(env_file).get("services", {})
    check(set(services) == {"photolibd", "postgres", "caddy"}, "photolibd, PostgreSQL and Caddy run together")
    for name, service in services.items():
        check(service.get("user") == f"{env['PUID']}:{env['PGID']}", f"{name} runs as PUID:PGID")
        check(service.get("read_only") is True, f"{name} has a read-only root filesystem")
        check("no-new-privileges:true" in service.get("security_opt", []), f"{name} gains no privileges")
        volumes = service.get("volumes", [])
        check(volumes and all(volume["type"] == "bind" for volume in volumes), f"{name} uses bind mounts only")
        image = service.get("image", "")
        check(image == f"{IMAGE}:{env['PHOTOLIB_VERSION']}" if name == "photolibd" else
              re.search(r":[\w.-]+@sha256:[0-9a-f]{64}$", image), f"{name}'s image is pinned ({image})")
    check({name for name, service in services.items() if service.get("ports")} == {"caddy"} and
          {port["target"] for port in services.get("caddy", {}).get("ports", [])} == {80, 443},
          "only Caddy is reachable from outside, on ports 80 and 443")
    photolibd = services.get("photolibd", {})
    data = {volume["target"]: volume["source"] for volume in photolibd.get("volumes", [])}.get("/data", "")
    check(os.path.normpath(os.path.join(DIR, env["PHOTOLIB_DATA"])) == data, "the libraries are in PHOTOLIB_DATA")
    environment = photolibd.get("environment", {})
    mounts = {volume["target"]: volume["source"] for volume in photolibd.get("volumes", [])}
    key = environment.get("PHOTOLIB_OPAQUE_KEY_FILE", "")
    check(os.path.dirname(key) in mounts and not key.startswith("/data/") and
          mounts[os.path.dirname(key)] == os.path.join(DIR, "keys"),
          "the OPAQUE key is in keys/, a mount of its own apart from the libraries and their dumps (ADR-0052)")
    check(environment.get("PHOTOLIB_TRUSTED_PROXIES") == env["PHOTOLIB_SUBNET"],
          "photolibd trusts the forwarded headers of the containers' network only")
    check(environment.get("PHOTOLIB_BASE_PATH") == (env["PHOTOLIB_BASE_PATH"] or "/") and
          services.get("caddy", {}).get("environment", {}).get("PHOTOLIB_BASE_PATH") == env["PHOTOLIB_BASE_PATH"],
          "photolibd and Caddy serve the same base path")
    check(environment.get("PHOTOLIB_PUBLIC_URL") == f"https://{env['PHOTOLIB_DOMAIN']}",
          "passkeys bind to the domain Caddy serves (ADR-0088)")
    check(environment.get("PHOTOLIB_DATABASE__URL") == f"postgres://photolib:{env['POSTGRES_PASSWORD']}@postgres/photolib"
          and services.get("postgres", {}).get("environment", {}).get("POSTGRES_PASSWORD") == env["POSTGRES_PASSWORD"],
          "photolibd signs in to PostgreSQL with the password of .env")
    finish()


if __name__ == "__main__":
    main(sys.argv[1] if len(sys.argv) > 1 else os.path.join(DIR, ".env.example"))
