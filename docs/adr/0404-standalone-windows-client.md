# ADR-0404 — The Windows client is one standalone zip, proven on a fresh runner

* **Status**: **Proposed** — awaiting the product owner's decision.
* **Requirements**: R-APP-5. **Design**: docs/10 §4.2, [ADR-0229](0229-windows-libmpv.md),
  [ADR-0013](0013-licence.md), [ADR-0249](0249-packaging-and-distribution.md).

## Context

ADR-0229 gave the Windows app an LGPL libmpv and FFmpeg built from pinned sources, but nothing built the app for Windows
after a merge, so no one could download it, and nothing showed that a machine with nothing installed could run it.
A `flutter build windows` output needs more than the app and libmpv: Flutter's runner and the kernel library import
Microsoft's Visual C++ runtime (`vcruntime140.dll`, `msvcp140.dll`), which a clean Windows machine does not have, and
the LGPL asks that the notices and the way to the source travel with the libraries. The archive of ADR-0229 is also
not published as a release yet, so a job that took it by URL would fail.

## Decision

We will:

* **Build the archive in the pipeline.** `post-merge-builds.yml`'s `libmpv-windows` job runs
  `bash tools/video/libmpv.sh --check` on Ubuntu 22.04, the system the pins were made on, so the archive is the bytes
  `app/windows/libmpv.json` pins or the job fails; its sources and archive are cached by the pins and the script.
  `client-windows` takes the archive from that job, and `app/windows/libmpv.cmake` still refuses any archive without
  the pinned SHA-256.
* **Pack one self-contained zip.** `client-windows` builds `flutter build windows --release` and
  `tools/windows/standalone.sh` packs `photolib-client-windows-x64-<short sha>.zip`: the app, `libmpv-2.dll`, the FFmpeg
  DLLs and `libmpv-notices.txt` the build installs beside `photolib.exe`, the Visual C++ runtime DLLs that something in
  the package imports (taken from the runner's Visual Studio redistributable, never any other toolchain's DLL),
  `LICENSE`, `SOURCE.txt` (the commit, the libraries' pins and the script that rebuilds them; the DLLs are dynamically
  linked, so they can be replaced) and `README.txt`. The zip's bytes depend only on the build.
* **Scan its dependencies.** `tools/windows/deps_scan.py` reads the import tables of every `.exe` and `.dll` in the
  package and fails on any import that is neither in the package (beside the importer, or beside the exe) nor Windows' own
  (the API sets and a list of system DLLs). The only delay-loaded imports allowed to be missing are the ANGLE libraries
  of ADR-0229, never called. The packer runs it on its result.
* **Prove it on a fresh runner.** `smoke-windows` is a second Windows job that built nothing (no Flutter, no Rust, no
  build directory): `tools/windows/smoke.sh` unpacks the zip into a new directory, scans it again, and starts
  `photolib.exe --self-test-play <corpus video> <result>` with only Windows' directories on the `PATH`. The app plays
  the corpus' decodable `mjpeg.mov` headless with its bundled libmpv, writes `played ...` or `failed: ...` with libmpv's
  log and the libmpv and FFmpeg versions it ran with, and exits. The job fails unless the video played and the app exited.
* **Publish with the release.** The zip is a release file like the others: the release checklist
  (`docs/dev/releasing.md`) downloads it from the post-merge run of the release commit and passes it through
  `tools/release.sh`, which adds it to `SHA256SUMS` and its cosign signature. The workflow keeps its read-only
  permissions and publishes nothing itself.
* **List the licences in the app.** Settings has an About entry whose licence page shows every licence the app
  registers: Roboto and, on Windows, the libmpv and FFmpeg notices.

## docs/10 §4.2, for photolib-design

photolib-design is read-only to this repository; its §4.2 Windows/Linux row should read: "Windows bundles our LGPL libmpv
and FFmpeg, cross-built reproducibly from pinned sources and taken by SHA-256 (ADR-0229), rendered in software, in a
standalone zip with the Visual C++ runtime and the licence notices that a clean machine runs (ADR-0404); Linux links the
system's libmpv; the licence is checked by tools/video/lgpl_check.py."

## Consequences

* A Windows user downloads one zip, unpacks it anywhere and runs `photolib.exe`; no installer, no registry, no admin rights.
* Every merge to `dev` builds the LGPL libraries (cached while the pins stand) and two Windows jobs: the most expensive
  runner type, which the post-merge workflow already accepts for macOS.
* `--self-test-play` is an argument of the shipped app: it only plays a file and writes a result file, and any other
  arguments are files to open as before.
* Not done, as ADR-0229 leaves them: ANGLE (software rendering), Windows on Arm, and signing the zip's executables
  (the MSIX of `tools/package.sh msix` is signed with the release's certificate).
* A clean machine here is a fresh runner with a stripped `PATH` plus a static scan: GitHub's runner still has Visual C++
  installed, which is why the scan, not the run, proves the runtime is bundled.

## Options considered

* **A published libmpv release as the only source**: the job would fail until the owner publishes the archive.
* **An installer (MSIX, MSI)**: needs the signing certificate, which the read-only pipeline does not hold; the MSIX
  stays a release-candidate build. A zip needs no installation, so a clean machine runs it as it is.
* **The Visual C++ redistributable installer as a prerequisite**: not self-contained.
* **Static linking of the Visual C++ runtime (`/MT`)**: Flutter's runner and its plugins are built with `/MD`.
* **Running the smoke test on the build runner**: it would find the Flutter, Visual Studio and build directories the app
  must not depend on.
