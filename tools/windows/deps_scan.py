"""Fails unless a Windows package runs on a machine with nothing installed (ADR-0404): every DLL that one of its
executables or DLLs imports must be in the package or be Windows' own. It reads the PE import tables itself, so it
runs on the Linux machines that test it as well as on the Windows runner that packs the app.

  python3 tools/windows/deps_scan.py [--missing] <package directory>

A DLL is found where the loader looks for an implicit import of an app: beside the importing file, or in the
package's top directory, where the executable is. `--missing` prints, one per line, the names of the DLLs that are
missing (the packaging script then adds the Visual C++ runtime's from the Visual Studio installation) and exits 0.
Exit status: 0 clean, 1 something is missing, 2 usage.
"""
import struct
import sys
from pathlib import Path

# What every Windows 10 and 11 has, which a clean machine can be relied on for (the API sets are virtual DLLs).
SYSTEM_PREFIXES = ("api-ms-win-", "ext-ms-win-", "ext-ms-onecore-")
SYSTEM = frozenset([
    "advapi32", "audioses", "avrt", "bcrypt", "bcryptprimitives", "cabinet", "cfgmgr32", "combase", "comctl32",
    "comdlg32", "crypt32", "d2d1", "d3d11", "d3d12", "d3d9", "d3dcompiler_47", "dbgcore", "dbghelp", "dcomp",
    "dhcpcsvc", "dnsapi", "dwmapi", "dwrite", "dxgi", "dxva2", "gdi32", "gdi32full", "glu32", "hid", "imm32",
    "iphlpapi", "kernel32", "kernelbase", "ksuser", "mf", "mfplat", "mfreadwrite", "mmdevapi", "mpr", "msimg32",
    "mswsock", "msvcrt", "ncrypt", "netapi32", "normaliz", "ntdll", "ntmarta", "oleacc", "oleaut32", "ole32",
    "opengl32", "powrprof", "profapi", "propsys", "psapi", "rpcrt4", "rstrtmgr", "schannel", "secur32",
    "setupapi", "shcore", "shell32", "shlwapi", "sspicli", "ucrtbase", "uiautomationcore", "urlmon", "user32",
    "userenv", "usp10", "uxtheme", "version", "wevtapi", "win32u", "windowscodecs", "winhttp", "wininet", "winmm",
    "winspool.drv", "wintrust", "wldap32", "ws2_32", "wsock32", "wtsapi32",
])
# The ANGLE libraries media_kit_video delay-loads for a hardware path the app turns off and never calls (ADR-0229).
DELAY_OK = ("libEGL.dll", "libGLESv2.dll")


class NotPE(ValueError):
    pass


def imports(data):
    """The DLL names a PE image imports at load time and delay-loads, from its import tables."""
    try:
        if data[:2] != b"MZ":
            raise NotPE("no MZ header")
        (pe_at,) = struct.unpack_from("<I", data, 0x3C)
        if data[pe_at : pe_at + 4] != b"PE\0\0":
            raise NotPE("no PE signature")
        _, sections, _, _, _, optional_size, _ = struct.unpack_from("<2H3I2H", data, pe_at + 4)
        optional = pe_at + 24
        (magic,) = struct.unpack_from("<H", data, optional)
        if magic not in (0x10B, 0x20B):
            raise NotPE("neither PE32 nor PE32+")
        directories = optional + (112 if magic == 0x20B else 96)
        (count,) = struct.unpack_from("<I", data, directories - 4)
        table = optional + optional_size
        ranges = [struct.unpack_from("<4I", data, table + 40 * i + 8) for i in range(sections)]

        def offset(rva):  # (VirtualSize, VirtualAddress, SizeOfRawData, PointerToRawData)
            for size, address, raw_size, raw in ranges:
                if address <= rva < address + max(size, raw_size):
                    return raw + rva - address
            raise NotPE(f"RVA {rva:#x} is in no section")

        def string(rva):
            start = offset(rva)
            return data[start : data.index(b"\0", start)].decode("ascii")

        def names(directory, size, name_at):
            if directory >= count:
                return []
            rva, _ = struct.unpack_from("<2I", data, directories + 8 * directory)
            found, at = [], rva and offset(rva)
            while at:
                entry = struct.unpack_from(f"<{size // 4}I", data, at)
                if not any(entry):
                    break
                found.append(string(entry[name_at]))
                at += size
            return found

        return names(1, 20, 3), names(13, 32, 1)
    except (struct.error, ValueError, IndexError) as e:
        raise (e if isinstance(e, NotPE) else NotPE(str(e))) from None


def is_system(name):
    lower = name.lower()
    return lower.startswith(SYSTEM_PREFIXES) or lower.removesuffix(".dll") in SYSTEM or lower in SYSTEM


def scan(root, delay_ok=DELAY_OK):
    """[(file, dll, kind)] for each import of a file under [root] found nowhere it may be, in order."""
    root = Path(root)
    files = sorted(p for p in root.rglob("*") if p.suffix.lower() in (".exe", ".dll") and p.is_file())
    shipped = {}
    for path in files:
        shipped.setdefault(path.parent, set()).add(path.name.lower())
    optional = {name.lower() for name in delay_ok}
    found = []
    for path in files:
        relative = path.relative_to(root).as_posix()
        try:
            loaded, delayed = imports(path.read_bytes())
        except NotPE:
            found.append((relative, "", "not a PE file"))
            continue
        here = shipped[path.parent] | shipped.get(root, set())
        for kind, names in (("import", loaded), ("delay-load", delayed)):
            for name in names:
                lower = name.lower()
                if lower in here or is_system(name) or (kind == "delay-load" and lower in optional):
                    continue
                found.append((relative, name, kind))
    return found


def main(argv):
    missing = argv[:1] == ["--missing"]
    argv = argv[1:] if missing else argv
    if len(argv) != 1 or not Path(argv[0]).is_dir():
        print(__doc__.strip().split("\n\n")[1], file=sys.stderr)
        return 2
    found = scan(argv[0])
    if missing:
        names = {}
        for _, name, _ in found:
            names.setdefault(name.lower(), name)
        print("\n".join(names.values()))
        return 0
    for file, name, kind in found:
        if kind == "not a PE file":
            print(f"deps_scan: {file} is not a PE file", file=sys.stderr)
        else:
            print(f"deps_scan: {file} imports {name}, which is neither in the package nor Windows' ({kind})",
                  file=sys.stderr)
    if found:
        return 1
    count = sum(1 for p in Path(argv[0]).rglob("*") if p.suffix.lower() in (".exe", ".dll"))
    print(f"deps_scan: {count} file{'s' * (count != 1)} of {argv[0]} need nothing outside the package and Windows")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
