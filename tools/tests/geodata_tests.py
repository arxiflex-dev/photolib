"""The places packs (tools/geodata/build.py, ADR-0405): the committed packs match the manifest, the manifest records
sources and licences, the packs parse, and a changed byte is noticed. Stdlib only; no network."""
import contextlib
import io
import json
import shutil
import struct
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tools" / "geodata"))
import build  # noqa: E402

GEO = ROOT / "app" / "assets" / "geo"


class Packs(unittest.TestCase):
    def check(self, out):
        build.OUT = out
        sys.argv = ["build.py", "--check"]
        with contextlib.redirect_stdout(io.StringIO()), contextlib.redirect_stderr(io.StringIO()):
            return build.main()

    def test_committed_packs_match_the_manifest(self):
        self.assertEqual(self.check(GEO), 0)

    def test_a_changed_byte_is_noticed(self):
        with tempfile.TemporaryDirectory() as tmp:
            copy = Path(tmp) / "geo"
            shutil.copytree(GEO, copy)
            pack = copy / "places.bin"
            data = bytearray(pack.read_bytes())
            data[-1] ^= 1
            pack.write_bytes(data)
            self.assertEqual(self.check(copy), 1)

    def test_manifest_records_sources_and_licences(self):
        manifest = json.loads((GEO / "manifest.json").read_text())
        self.assertEqual(set(manifest["sources"]), set(build.SOURCES))
        for source in manifest["sources"].values():
            self.assertRegex(source["sha256"], "^[0-9a-f]{64}$")
        self.assertIn("CC BY 4.0", manifest["licences"]["GeoNames"])
        self.assertIn("public domain", manifest["licences"]["Natural Earth"])
        self.assertEqual(set(manifest["packs"]), {"places.bin"} | {f"names-{l}.bin" for l in build.LOCALES})

    def test_core_pack_header_counts_the_manifest(self):
        data = (GEO / "places.bin").read_bytes()
        magic, version, countries, regions, cities, zones = struct.unpack_from("<4sIIIII", data)
        counts = json.loads((GEO / "manifest.json").read_text())["counts"]
        self.assertEqual((magic, version), (b"PLGC", 1))
        self.assertEqual((countries, regions, cities), (counts["countries"], counts["regions"], counts["cities"]))
        self.assertGreater(counts["countries_with_borders"], 200)
        self.assertGreater(zones, 300)

    def test_the_packs_stay_compact(self):
        self.assertLess((GEO / "places.bin").stat().st_size, 2_500_000)
        self.assertLess(max(p.stat().st_size for p in GEO.glob("names-*.bin")), 500_000)

    def test_varint_and_quantise(self):
        self.assertEqual(build.varint(0), b"\0")
        self.assertEqual(build.varint(300), bytes([0xAC, 0x02]))
        self.assertEqual(build.quantise([(1.004, 2.0), (1.0041, 2.0), (3.0, 4.0), (1.004, 2.0)]), [(100, 200), (300, 400)])


if __name__ == "__main__":
    unittest.main()
