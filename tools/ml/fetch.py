#!/usr/bin/env python3
"""Downloads what the on-device ML runtime spike runs, pinned in artefacts.json next to this script, into a private
per-user cache once, refusing anything whose SHA-256 differs from its pin, and prints a JSON object mapping each name
to its local files. Concurrent fetches of one artefact wait for a single download; under tools/offline.sh nothing is
downloaded, and a missing artefact is named with the command that fetches it.

    tools/ml/fetch.py [--sizes | --archives <dir>] <name>...

A model is one file; a runtime is an archive (.tgz, .zip or .aar) of which only its listed files are kept. --sizes
prints "<name> <file> <bytes> <gzip -9 bytes>" lines instead; --archives keeps each archive whole and copies it into
<dir> under its URL's name, as app/packages/photolib_ml's build hook takes it. The cache is $PHOTOLIB_TOOLS_CACHE/ml,
by default under $TMPDIR or /tmp (%TEMP% on Windows); the SigLIP 2 models need about 3 GB there.
"""
import contextlib
import errno
import gzip
import hashlib
import io
import json
import os
import shutil
import sys
import tarfile
import tempfile
import urllib.request
import zipfile
from pathlib import Path

try:
    import fcntl
except ImportError:  # Windows
    fcntl = None
    import msvcrt

PINS = json.loads((Path(__file__).parent / "artefacts.json").read_text())


def cache_root():
    # Windows has no user ids, and its temporary directory is the user's own.
    uid = os.getuid() if hasattr(os, "getuid") else None
    default = Path(tempfile.gettempdir(), "photolib-tools" if uid is None else f"photolib-tools-{uid}")
    root = Path(os.environ.get("PHOTOLIB_TOOLS_CACHE") or default)
    root.mkdir(mode=0o700, parents=True, exist_ok=True)
    if root.is_symlink() or uid is not None and root.stat().st_uid != uid:
        sys.exit(f"fetch.py: {root} is not a private directory of this user; set PHOTOLIB_TOOLS_CACHE to one")
    return root / "ml"


@contextlib.contextmanager
def locked(path):
    """Holds an exclusive lock on the file at path; another process waits for it."""
    with open(path, "a") as file:
        if fcntl:
            fcntl.flock(file, fcntl.LOCK_EX)
            yield
            return
        while True:
            try:
                msvcrt.locking(file.fileno(), msvcrt.LK_LOCK, 1)
                break
            except OSError as error:  # after 10 s
                if error.errno != errno.EDEADLOCK:
                    raise
        try:
            yield
        finally:
            msvcrt.locking(file.fileno(), msvcrt.LK_UNLCK, 1)


def fetch(name, archive=False):
    pin = PINS[name]
    url, files = pin["url"], [] if archive else pin.get("files") or []
    out = cache_root() / f"{name}-{pin['sha256'][:16]}"
    paths = [out / f for f in files] or [out / url.rsplit("/", 1)[1]]
    if all(p.is_file() for p in paths):
        return paths
    if os.environ.get("EGRESS_BLOCKED"):
        sys.exit(f"fetch.py: {name} is not in {out}, and egress is blocked (tools/offline.sh); "
                 f"fetch it first: python3 tools/ml/fetch.py {'--archives <dir> ' if archive else ''}{name}")
    out.mkdir(parents=True, exist_ok=True)
    # One download at a time, into a temporary directory: a concurrent fetch waits for the lock, then finds every file
    # renamed into place whole.
    with locked(out / ".lock"), tempfile.TemporaryDirectory(dir=out, prefix=".download-") as tmp:
        if all(p.is_file() for p in paths):
            return paths
        download, digest = Path(tmp, "download"), hashlib.sha256()
        # Wikimedia refuses the default user agent; every host gets a name and where to ask.
        request = urllib.request.Request(url, headers={"User-Agent": "photolib-tools/1 (https://github.com/arxiflex-dev/photolib)"})
        with urllib.request.urlopen(request) as response, open(download, "wb") as sink:
            while chunk := response.read(1 << 20):
                digest.update(chunk)
                sink.write(chunk)
        if digest.hexdigest() != pin["sha256"]:
            shutil.rmtree(out, ignore_errors=True)  # but the lock, open, on Windows
            sys.exit(f"fetch.py: {url} does not have the pinned SHA-256 {pin['sha256']}")
        if not files:
            os.replace(download, paths[0])
        for i, (file, path) in enumerate(zip(files, paths)):
            if zipfile.is_zipfile(download):
                data = zipfile.ZipFile(download).read(file)
            else:
                with tarfile.open(download) as tar:
                    data = tar.extractfile(next(m for m in tar if m.name.removeprefix("./") == file)).read()
            Path(tmp, str(i)).write_bytes(data)
            path.parent.mkdir(parents=True, exist_ok=True)
            os.replace(Path(tmp, str(i)), path)
    return paths


def main(args):
    sizes, archives = args[:1] == ["--sizes"], args[1] if args[:1] == ["--archives"] and args[1:] else None
    names = args[1:] if sizes else args[2:] if archives else args
    unknown = [n for n in names if n not in PINS]
    if not names or unknown:
        sys.exit(f"fetch.py: unknown {' '.join(unknown) or 'nothing'}; pinned: {' '.join(PINS)}")
    result = {name: fetch(name, bool(archives)) for name in names}
    if archives:
        Path(archives).mkdir(parents=True, exist_ok=True)
        result = {name: [Path(shutil.copyfile(path, Path(archives, path.name))) for path in paths]
                  for name, paths in result.items()}
    if not sizes:
        print(json.dumps({name: [str(p) for p in paths] for name, paths in result.items()}, indent=1))
        return
    for name, paths in result.items():
        for file, path in zip(PINS[name].get("files") or [path.name for path in paths], paths):
            data = path.read_bytes()
            packed = io.BytesIO()
            with gzip.GzipFile(fileobj=packed, mode="wb", compresslevel=9, mtime=0) as z:
                z.write(data)
            print(name, file, len(data), len(packed.getvalue()))


if __name__ == "__main__":
    main(sys.argv[1:])
