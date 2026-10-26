#!/usr/bin/env python3
"""Check deploy/helm/photolib, the Helm chart: lint it, render it with the pinned Helm and check what it deploys."""
import os
import re
import subprocess

import miniyaml
from checklib import ROOT, check, finish, read

CHART = os.path.join(ROOT, "deploy", "helm", "photolib")
REQUIRED = ["--set", "publicUrl=https://photos.example.com", "--set", "database.secret=photolib-db"]
SCALED = REQUIRED + ["--set", "deployments.all=null", "--set", "deployments.api.roles=api",
                     "--set", "deployments.api.replicas=2", "--set", "deployments.work.roles=scheduler\\,worker:cpu",
                     "--set", "deployments.work.replicas=1"]


def helm(*args):
    return subprocess.run(["bash", os.path.join(ROOT, "tools", "helm.sh"), *args], capture_output=True, text=True,
                          check=False)


def render(*values):
    run = helm("template", "photos", CHART, *values)
    check(run.returncode == 0, f"the chart renders with {' '.join(values[1::2]) or 'its defaults'}", run.stderr)
    docs = [miniyaml.load(doc) for doc in re.split(r"^---\s*$", run.stdout, flags=re.MULTILINE) if doc.strip()]
    return {(doc["kind"], doc["metadata"]["name"]): doc for doc in docs}


def pod(resources, kind, name):
    return resources.get((kind, name), {}).get("spec", {}).get("template", {}).get("spec", {})


def env(spec):
    return {e["name"]: e.get("value", e.get("valueFrom")) for e in spec.get("containers", [{}])[0].get("env", [])}


version = re.search(r"^version: *([0-9.]+)", read("app/pubspec.yaml"), re.MULTILINE)[1]
chart = miniyaml.load(read("deploy/helm/photolib/Chart.yaml"))
check(chart.get("version") == version and chart.get("appVersion") == version,
      f"the chart and its photolibd are the release's version, as app/pubspec.yaml says ({version})")
lint = helm("lint", "--strict", CHART, *REQUIRED)
check(lint.returncode == 0, "helm lint --strict passes", lint.stdout + lint.stderr)
bare = helm("template", "photos", CHART)
check(bare.returncode != 0 and "publicUrl" in bare.stderr and "database.secret" in bare.stderr,
      "it refuses to render without the public URL and the database's secret, and names both", bare.stderr)

one = render(*REQUIRED)
spec = pod(one, "Deployment", "photos-all")
container = spec.get("containers", [{}])[0]
check(container.get("image") == f"ghcr.io/arxiflex-dev/photolib:{version}", "photolibd's image of the release")
check(env(spec).get("PHOTOLIB_ROLES") == "all" and env(spec).get("PHOTOLIB_PUBLIC_URL") == "https://photos.example.com",
      "one Deployment runs every role at the public URL by default")
check(env(spec).get("PHOTOLIB_DATABASE__URL") == {"secretKeyRef": {"name": "photolib-db", "key": "url"}},
      "the database URL comes from the secret, never from values")
check(env(spec).get("PHOTOLIB_OPAQUE_KEY_FILE") == "/keys/opaque.key", "the OPAQUE key lives on a volume of its own")
check(one.get(("Deployment", "photos-all"), {}).get("spec", {}).get("strategy") == {"type": "Recreate"},
      "a single replica is replaced, never run beside the next, on its ReadWriteOnce volumes")
check(container.get("readinessProbe", {}).get("httpGet", {}).get("path") == "/readyz" and
      container.get("livenessProbe", {}).get("httpGet", {}).get("path") == "/healthz", "probed on /readyz and /healthz")
security = container.get("securityContext", {})
check(security.get("readOnlyRootFilesystem") is True and security.get("allowPrivilegeEscalation") is False and
      spec.get("securityContext", {}).get("runAsNonRoot") is True, "non-root on a read-only root filesystem")
check({("PersistentVolumeClaim", "photos-data"), ("PersistentVolumeClaim", "photos-keys"), ("Service", "photos")} <=
      set(one), "a claim for the data and one for the keys, and the Service")
check(one.get(("Service", "photos"), {}).get("spec", {}).get("selector", {}).get("photolib.org/api") == "true",
      "the Service reaches the processes that run the API")

job = one.get(("Job", "photos-migrate"), {})
annotations = job.get("metadata", {}).get("annotations", {})
check(annotations.get("helm.sh/hook") == "pre-upgrade", "the schema migrates in a pre-upgrade Job")
migrate = pod(one, "Job", "photos-migrate")
check(migrate.get("containers", [{}])[0].get("args") == ["migrate"] and
      env(migrate).get("PHOTOLIB_DATABASE__URL") == env(spec).get("PHOTOLIB_DATABASE__URL") and
      migrate.get("volumes") == spec.get("volumes"), "photolibd migrate, on the same database and volumes")
check(not [key for key in one if key[0] == "PodDisruptionBudget"], "no disruption budget for a single replica")

scaled = render(*SCALED)
roles = {name: env(pod(scaled, kind, name)).get("PHOTOLIB_ROLES") for kind, name in scaled if kind == "Deployment"}
check(roles == {"photos-api": "api", "photos-work": "scheduler,worker:cpu"}, f"a Deployment per process ({roles})")
labels = {name: scaled[("Deployment", name)]["spec"]["template"]["metadata"]["labels"].get("photolib.org/api")
          for name in roles}
check(labels == {"photos-api": "true", "photos-work": "false"}, f"only the API's pods take requests ({labels})")
check([name for kind, name in scaled if kind == "PodDisruptionBudget"] == ["photos-api"] and
      scaled[("PodDisruptionBudget", "photos-api")]["spec"]["minAvailable"] == 1,
      "a disruption budget keeps one of the replicated API's pods")
check(scaled[("Deployment", "photos-api")]["spec"].get("strategy") is None, "replicas roll")
finish()
