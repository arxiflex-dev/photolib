#!/usr/bin/env python3
"""Builds the offline places packs of app/assets/geo/ (ADR-0405, docs/dev/places.md) from GeoNames and Natural Earth.

  python3 tools/geodata/build.py --sources DIR     fetch (hash-checked into manifest.json) and build into app/assets/geo/
  python3 tools/geodata/build.py --check           the committed packs match manifest.json (SHA-256, sizes), no network

The inputs are cities15000.zip, admin1CodesASCII.txt, countryInfo.txt, alternateNamesV2.zip (GeoNames, CC BY 4.0) and
ne_50m_admin_0_countries.zip (Natural Earth, public domain). GeoNames files change daily, so the SHA-256 of the inputs
used is recorded in the manifest and the committed packs are the canonical output; the output is deterministic.
Stdlib only.
"""
import argparse
import hashlib
import json
import struct
import sys
import urllib.request
import zipfile
from pathlib import Path

OUT = Path(__file__).resolve().parents[2] / "app" / "assets" / "geo"
GEONAMES = "https://download.geonames.org/export/dump/"
NATURAL_EARTH = "https://naciscdn.org/naturalearth/50m/cultural/ne_50m_admin_0_countries.zip"
SOURCES = {
    "cities15000.zip": GEONAMES + "cities15000.zip",
    "admin1CodesASCII.txt": GEONAMES + "admin1CodesASCII.txt",
    "countryInfo.txt": GEONAMES + "countryInfo.txt",
    "alternateNamesV2.zip": GEONAMES + "alternateNamesV2.zip",
    "ne_50m_admin_0_countries.zip": NATURAL_EARTH,
}
# The app's locales (app/lib/l10n) and the GeoNames language codes that name places in each, best first.
LOCALES = {
    "ar": ["ar"], "de": ["de"], "es": ["es"], "fr": ["fr"], "he": ["he", "iw"], "hi": ["hi"], "id": ["id", "in"],
    "it": ["it"], "ja": ["ja"], "ko": ["ko"], "nl": ["nl"], "pl": ["pl"], "pt": ["pt", "pt-BR"], "ru": ["ru"],
    "sv": ["sv"], "tr": ["tr"], "uk": ["uk"], "vi": ["vi"], "zh": ["zh-CN", "zh"],
    "zh_Hant": ["zh-TW", "zh-HK", "zh-Hant", "zh"],
}
NONE16 = 0xFFFF
SCALE_POLY = 100  # polygon vertices in hundredths of a degree
SCALE_CITY = 100000  # city positions in 1e-5 degrees


def sha256(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for block in iter(lambda: f.read(1 << 20), b""):
            h.update(block)
    return h.hexdigest()


def fetch(directory):
    directory.mkdir(parents=True, exist_ok=True)
    for name, url in SOURCES.items():
        target = directory / name
        if not target.exists():
            with urllib.request.urlopen(url, timeout=600) as r, open(target, "wb") as f:  # noqa: S310
                while block := r.read(1 << 20):
                    f.write(block)


def read_shapefile(path):
    """Yields (attributes dict, [rings]) of a polygon shapefile and its dBase table (zip holding both)."""
    with zipfile.ZipFile(path) as z:
        stem = next(n[:-4] for n in z.namelist() if n.endswith(".shp"))
        shp, dbf = z.read(stem + ".shp"), z.read(stem + ".dbf")
    count, header, record = struct.unpack("<xxxxIHH", dbf[:12])
    fields, p = [], 32
    while dbf[p] != 13:
        fields.append((dbf[p:p + 11].split(b"\0")[0].decode(), dbf[p + 16]))
        p += 32
    attrs = []
    for i in range(count):
        row, q = {}, header + i * record + 1
        for name, size in fields:
            row[name] = dbf[q:q + size].decode("utf-8", "replace").strip(" \0")
            q += size
        attrs.append(row)
    shapes, p = [], 100
    while p < len(shp):
        (length,) = struct.unpack(">4xI", shp[p:p + 8])
        body = shp[p + 8:p + 8 + length * 2]
        p += 8 + length * 2
        kind, = struct.unpack("<i", body[:4])
        rings = []
        if kind == 5:
            parts, points = struct.unpack("<ii", body[36:44])
            starts = list(struct.unpack("<%di" % parts, body[44:44 + 4 * parts])) + [points]
            base = 44 + 4 * parts
            coords = struct.unpack("<%dd" % (2 * points), body[base:base + 16 * points])
            for a, b in zip(starts, starts[1:]):
                rings.append([(coords[2 * k], coords[2 * k + 1]) for k in range(a, b)])
        shapes.append(rings)
    return list(zip(attrs, shapes))


def quantise(ring):
    out = []
    for lon, lat in ring:
        point = (round(lon * SCALE_POLY), round(lat * SCALE_POLY))
        if not out or out[-1] != point:
            out.append(point)
    if len(out) > 1 and out[0] == out[-1]:
        out.pop()
    return out


class Strings:
    """A deduplicated blob of NUL-terminated UTF-8 strings; offset 0 is the empty string."""

    def __init__(self):
        self.blob, self.seen = bytearray(b"\0"), {"": 0}

    def add(self, text):
        if text not in self.seen:
            self.seen[text] = len(self.blob)
            self.blob += text.encode() + b"\0"
        return self.seen[text]


def varint(n):
    out = bytearray()
    while True:
        out.append(n & 0x7F | (0x80 if n > 0x7F else 0))
        n >>= 7
        if not n:
            return bytes(out)


def pick(names, codes):
    """The best name among (lang, name, preferred, short, colloquial, historic) rows for the language codes."""
    for code in codes:
        rows = [r for r in names if r[0] == code and not r[4] and not r[5]]
        if rows:
            rows.sort(key=lambda r: (not r[2], r[3]))
            return rows[0][1]
    return None


def build(directory):
    with zipfile.ZipFile(directory / "cities15000.zip") as z:
        cities = [line.split("\t") for line in z.read("cities15000.txt").decode().splitlines()]
    cities.sort(key=lambda c: int(c[0]))
    countries = {}
    for line in (directory / "countryInfo.txt").read_text(encoding="utf-8").splitlines():
        if line and not line.startswith("#"):
            f = line.split("\t")
            countries[f[0]] = {"name": f[4], "id": int(f[16]) if f[16] else 0}
    for city in cities:
        countries.setdefault(city[8], {"name": city[8], "id": 0})
    codes = sorted(countries)
    country_index = {c: i for i, c in enumerate(codes)}
    regions = {}
    for line in (directory / "admin1CodesASCII.txt").read_text(encoding="utf-8").splitlines():
        code, name, _, gid = line.split("\t")
        regions[code] = {"name": name, "id": int(gid)}
    used = sorted({f"{c[8]}.{c[10]}" for c in cities if c[10] and f"{c[8]}.{c[10]}" in regions})
    region_index = {r: i for i, r in enumerate(used)}

    wanted = {c["id"] for c in countries.values() if c["id"]} | {regions[r]["id"] for r in used}
    wanted |= {int(c[0]) for c in cities}
    langs = {code for codes_ in LOCALES.values() for code in codes_} | {"en"}
    names = {}
    with zipfile.ZipFile(directory / "alternateNamesV2.zip") as z, z.open("alternateNamesV2.txt") as f:
        for raw in f:
            row = raw.decode("utf-8").rstrip("\n").split("\t")
            if len(row) < 8 or row[2] not in langs or not row[1].isdigit() or int(row[1]) not in wanted:
                continue
            flag = lambda i: len(row) > i and row[i] == "1"  # noqa: E731
            names.setdefault(int(row[1]), []).append((row[2], row[3], flag(4), flag(5), flag(6), flag(7)))

    ne = {}
    for attrs, rings in read_shapefile(directory / "ne_50m_admin_0_countries.zip"):
        iso = attrs["ISO_A2_EH"] if attrs["ISO_A2_EH"] not in ("", "-99") else attrs["ISO_A2"]
        if iso in country_index:
            ne.setdefault(iso, []).extend(r for r in map(quantise, rings) if len(r) >= 3)

    entities = [("country", c["id"], c["name"]) for c in (countries[k] for k in codes)]
    entities += [("region", regions[r]["id"], regions[r]["name"]) for r in used]
    entities += [("city", int(c[0]), c[1]) for c in cities]
    english = [pick(names.get(gid, []), ["en"]) or default for _, gid, default in entities]

    strings = Strings()
    zones = sorted({c[17] for c in cities})
    tz = {z: i for i, z in enumerate(zones)}
    out = bytearray(b"PLGC" + struct.pack("<IIIII", 1, len(codes), len(used), len(cities), len(zones)))
    for z in zones:
        out += bytes([len(z)]) + z.encode()
    ring_total = sum(len(rs) for rs in ne.values())
    out += struct.pack("<I", ring_total)
    ring_first = 0
    for i, code in enumerate(codes):
        rings = ne.get(code, [])
        xs = [p[0] for r in rings for p in r] or [0]
        ys = [p[1] for r in rings for p in r] or [0]
        out += code.encode() + struct.pack("<I4hII", strings.add(english[i]), min(xs), min(ys), max(xs), max(ys),
                                           ring_first, len(rings))
        ring_first += len(rings)
    for rings in (ne.get(code, []) for code in codes):
        for r in rings:
            out += struct.pack("<I", len(r)) + b"".join(struct.pack("<hh", *p) for p in r)
    base = len(codes)
    for i, r in enumerate(used):
        out += struct.pack("<HII", country_index[r.split(".")[0]], strings.add(english[base + i]), regions[r]["id"])
    base += len(used)
    cols = {k: bytearray() for k in ("lat", "lon", "pop", "gid", "name", "country", "region", "tz")}
    for i, c in enumerate(cities):
        cols["lat"] += struct.pack("<i", round(float(c[4]) * SCALE_CITY))
        cols["lon"] += struct.pack("<i", round(float(c[5]) * SCALE_CITY))
        cols["pop"] += struct.pack("<I", int(c[14] or 0))
        cols["gid"] += struct.pack("<I", int(c[0]))
        cols["name"] += struct.pack("<I", strings.add(english[base + i]))
        cols["country"] += struct.pack("<H", country_index[c[8]])
        cols["region"] += struct.pack("<H", region_index.get(f"{c[8]}.{c[10]}", NONE16))
        cols["tz"] += struct.pack("<H", tz[c[17]])
    for k in cols:
        out += cols[k]
    out += struct.pack("<I", len(strings.blob)) + strings.blob
    OUT.mkdir(parents=True, exist_ok=True)
    (OUT / "places.bin").write_bytes(out)

    for locale, lang_codes in LOCALES.items():
        pack = bytearray(b"PLGN" + struct.pack("<I", 1))
        for lo, hi in ((0, len(codes)), (len(codes), len(codes) + len(used)), (len(codes) + len(used), len(entities))):
            entries, last = bytearray(), 0
            count = 0
            for i in range(lo, hi):
                name = pick(names.get(entities[i][1], []), lang_codes)
                if name and name != english[i]:
                    raw = name.encode()
                    entries += varint(i - lo - last) + varint(len(raw)) + raw
                    last, count = i - lo, count + 1
            pack += struct.pack("<II", count, len(entries)) + entries
        (OUT / f"names-{locale}.bin").write_bytes(pack)
    return len(codes), len(used), len(cities), sum(1 for c in codes if ne.get(c))


def manifest_files():
    return sorted(p for p in OUT.glob("*.bin"))


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--sources", type=Path, help="directory for the downloaded inputs")
    parser.add_argument("--check", action="store_true", help="compare the committed packs with manifest.json")
    args = parser.parse_args()
    manifest = OUT / "manifest.json"
    if args.check:
        recorded = json.loads(manifest.read_text())["packs"]
        found = {p.name: {"sha256": sha256(p), "bytes": p.stat().st_size} for p in manifest_files()}
        if recorded != found:
            print("geodata: the packs differ from manifest.json: run tools/geodata/build.py --sources DIR", file=sys.stderr)
            return 1
        print(f"geodata: {len(found)} packs match manifest.json")
        return 0
    if not args.sources:
        parser.error("--sources or --check")
    fetch(args.sources)
    counts = build(args.sources)
    manifest.write_text(json.dumps({
        "format": 1,
        "counts": dict(zip(["countries", "regions", "cities", "countries_with_borders"], counts)),
        "sources": {n: {"url": u, "sha256": sha256(args.sources / n)} for n, u in SOURCES.items()},
        "licences": {
            "GeoNames": "CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, https://www.geonames.org/",
            "Natural Earth": "public domain, https://www.naturalearthdata.com/about/terms-of-use/",
        },
        "packs": {p.name: {"sha256": sha256(p), "bytes": p.stat().st_size} for p in manifest_files()},
    }, indent=2, sort_keys=True) + "\n")
    return 0


if __name__ == "__main__":
    sys.exit(main())
