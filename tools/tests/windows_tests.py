"""tools/windows/deps_scan.py reads the import tables of a Windows package's executables and DLLs, on synthetic PE
files built here (a Linux machine has no Windows binaries): every import must be in the package or the system's."""
import contextlib
import io
import struct
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tools" / "windows"))
import deps_scan

SECTION_RVA, SECTION_RAW = 0x1000, 0x200


def pe(imports=(), delay=(), plus=True):
    """A minimal PE32+ (or PE32) image whose one section holds the import and delay-import tables of these DLLs."""
    descriptors = 20 * (len(imports) + 1) + 32 * (len(delay) + 1)
    names, strings = {}, b""
    for name in [*imports, *delay]:
        names[name] = SECTION_RVA + descriptors + len(strings)
        strings += name.encode() + b"\0"
    table = b"".join(struct.pack("<5I", 0, 0, 0, names[n], 0) for n in imports) + bytes(20)
    delay_table = b"".join(struct.pack("<8I", 1, names[n], 0, 0, 0, 0, 0, 0) for n in delay) + bytes(32)
    section = table + delay_table + strings
    header_size = 240 if plus else 224
    optional = bytearray(header_size)
    struct.pack_into("<H", optional, 0, 0x20B if plus else 0x10B)
    directories = 112 if plus else 96
    struct.pack_into("<I", optional, directories - 4, 16)
    struct.pack_into("<2I", optional, directories + 8, SECTION_RVA, 20 * (len(imports) + 1))
    delay_rva = SECTION_RVA + 20 * (len(imports) + 1)
    struct.pack_into("<2I", optional, directories + 13 * 8, delay_rva, 32 * (len(delay) + 1))
    coff = struct.pack("<2H3I2H", 0x8664 if plus else 0x14C, 1, 0, 0, 0, header_size, 0x2022)
    sections = struct.pack("<8s6I2HI", b".idata", len(section), SECTION_RVA, len(section), SECTION_RAW, 0, 0, 0, 0, 0)
    dos = bytearray(0x80)
    dos[:2] = b"MZ"
    struct.pack_into("<I", dos, 0x3C, 0x80)
    image = bytes(dos) + b"PE\0\0" + coff + bytes(optional) + sections
    return image + bytes(SECTION_RAW - len(image)) + section


class Tree:
    """A package directory of files, made from {path: bytes}."""

    def __init__(self, files):
        self.dir = tempfile.TemporaryDirectory()
        self.root = Path(self.dir.name)
        for name, data in files.items():
            (self.root / name).parent.mkdir(parents=True, exist_ok=True)
            (self.root / name).write_bytes(data)

    def scan(self, **options):
        return deps_scan.scan(self.root, **options)


class Case(unittest.TestCase):
    def tree(self, files):
        tree = Tree(files)
        self.addCleanup(tree.dir.cleanup)
        return tree


class Imports(Case):
    def test_reads_both_tables_of_both_formats(self):
        for plus in (True, False):
            with self.subTest(pe32plus=plus):
                data = pe(["KERNEL32.dll", "VCRUNTIME140.dll"], ["libEGL.dll"], plus=plus)
                self.assertEqual(deps_scan.imports(data), (["KERNEL32.dll", "VCRUNTIME140.dll"], ["libEGL.dll"]))

    def test_a_file_without_imports_has_none(self):
        self.assertEqual(deps_scan.imports(pe()), ([], []))

    def test_a_file_that_is_no_pe_is_refused(self):
        for data in (b"", b"MZ", b"just text", b"MZ" + bytes(0x3E) + b"\xff\xff\xff\x7f"):
            with self.subTest(data=data), self.assertRaises(deps_scan.NotPE):
                deps_scan.imports(data)


class Scan(Case):
    def test_a_package_that_needs_nothing_outside_it_is_clean(self):
        tree = self.tree({
            "photolib.exe": pe(["KERNEL32.dll", "flutter_windows.dll", "VCRUNTIME140.dll"]),
            "flutter_windows.dll": pe(["USER32.dll", "api-ms-win-crt-runtime-l1-1-0.dll", "msvcp140.dll"]),
            "VCRUNTIME140.dll": pe(["KERNEL32.dll"]),
            "MSVCP140.dll": pe(["VCRUNTIME140.dll", "KERNEL32.dll"]),
            "data/app.so": b"not a PE file and not looked at",
        })
        self.assertEqual(tree.scan(), [])

    def test_an_import_that_is_neither_shipped_nor_the_systems_is_reported(self):
        tree = self.tree({"photolib.exe": pe(["KERNEL32.dll", "VCRUNTIME140.dll", "libwinpthread-1.dll"])})
        self.assertEqual(
            tree.scan(),
            [("photolib.exe", "VCRUNTIME140.dll", "import"), ("photolib.exe", "libwinpthread-1.dll", "import")],
        )

    def test_the_names_of_dlls_match_whatever_their_case(self):
        tree = self.tree({
            "photolib.exe": pe(["AVCODEC-62.DLL", "kernel32.DLL"]),
            "avcodec-62.dll": pe(["Kernel32.dll"]),
        })
        self.assertEqual(tree.scan(), [])

    def test_a_dll_beside_the_executable_serves_plugins_in_a_folder(self):
        tree = self.tree({
            "photolib.exe": pe(["KERNEL32.dll"]),
            "shared.dll": pe(["KERNEL32.dll"]),
            "plugins/a.dll": pe(["shared.dll", "only_in_b.dll"]),
            "plugins/b/only_in_b.dll": pe(["KERNEL32.dll"]),
        })
        self.assertEqual(tree.scan(), [("plugins/a.dll", "only_in_b.dll", "import")])

    def test_delay_loaded_dlls_need_a_reason_to_be_missing(self):
        tree = self.tree({"mk.dll": pe(["KERNEL32.dll"], ["libEGL.dll", "libGLESv2.dll", "d3dx9_43.dll"])})
        self.assertEqual(tree.scan(), [("mk.dll", "d3dx9_43.dll", "delay-load")])
        self.assertEqual(
            tree.scan(delay_ok=()),
            [("mk.dll", n, "delay-load") for n in ("libEGL.dll", "libGLESv2.dll", "d3dx9_43.dll")],
        )

    def test_a_dll_that_is_no_pe_file_is_reported(self):
        tree = self.tree({"broken.dll": b"MZ but not really"})
        self.assertEqual(tree.scan(), [("broken.dll", "", "not a PE file")])


class Command(Case):
    def run_main(self, *args):
        out, err = io.StringIO(), io.StringIO()
        with contextlib.redirect_stdout(out), contextlib.redirect_stderr(err):
            code = deps_scan.main([*map(str, args)])
        return code, out.getvalue(), err.getvalue()

    def test_exit_status_and_messages(self):
        clean = self.tree({"photolib.exe": pe(["KERNEL32.dll"])})
        code, out, err = self.run_main(clean.root)
        self.assertEqual((code, err), (0, ""))
        self.assertIn("1 file", out)
        bad = self.tree({"photolib.exe": pe(["KERNEL32.dll", "MSVCP140.dll"])})
        code, out, err = self.run_main(bad.root)
        self.assertEqual(code, 1)
        self.assertIn("photolib.exe imports MSVCP140.dll, which is neither in the package nor Windows'", err)

    def test_missing_lists_the_names_one_per_line_for_the_packaging_script(self):
        bad = self.tree({"a.exe": pe(["MSVCP140.dll", "vcruntime140.dll"]), "b.dll": pe(["MSVCP140.dll"])})
        code, out, _ = self.run_main("--missing", bad.root)
        self.assertEqual((code, out.split()), (0, ["MSVCP140.dll", "vcruntime140.dll"]))

    def test_usage(self):
        self.assertEqual(self.run_main()[0], 2)
        self.assertEqual(self.run_main(Path("/nonexistent"))[0], 2)


if __name__ == "__main__":
    unittest.main()
