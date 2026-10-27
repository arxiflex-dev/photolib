# Kernel go/no-go report (ADR-0004)

The spike kernel (envelope decrypt, EXIF and capture time, query parsing) measured against the pass criteria of
ADR-0004 on 2026-10-15, at commit `a54d255`. The decision is [ADR-0029](../adr/0029-kernel-go-no-go.md).

## How it is measured

The gate re-measures on every run and fails below a threshold, so these numbers cannot silently go stale:

* **Size**: `python3 tools/kernel/build.py` prints each library's bytes and fails over 3 MB; CI's `kernel-prebuilt`
  job runs it over all 11 targets. `tools/kernel/wasm.sh` fails the web module over 1 MB brotli.
* **Speed**: `app/packages/photolib_kernel/test/bench.dart`, through the C ABI in `benchmark/kernel_bench_test.dart` (a
  release build in `flutter test`, the bundled prebuilt library in `tools/kernel/probe.sh` on Linux, macOS and Windows,
  where it is printed only) and through WebAssembly in `benchmark/web_bench_test.dart` (`bash tools/check.sh web`, in
  Chrome only for now: photolib-design#288). No test asserts a time: each prints `result:` lines and
  `tools/perf/measure.sh` checks them against the series `kernel-binding` of `tools/perf/budgets.json`, alone and up to
  three times, advisory on hosted runners. Each result is the fastest sample (1 ms natively, 5 ms in a browser's coarser
  clock) of a second, since a loaded machine only slows a sample (`test/bench_test.dart`; at the spike, the fastest of
  five 100 ms rounds). It is taken on the fastest cores: on Linux, `lib/testing.dart` pins the test process or the
  browser to the cores with the highest top speed and natively times the thread's CPU time, so that other work on a
  shared machine does not count. Each run prints one line per figure:
  * *call*: method 0 with an empty request, which only crosses the boundary and returns an error;
  * *decrypt*: at the spike, a whole two-chunk envelope (65,636 plaintext bytes in 64 KiB chunks) per call; MB is
    10⁶ bytes. Since crypto suite v1, [below](#crypto-suite-v1-m0-40);
  * *EXIF*: capture time from a 64 KiB JPEG head with EXIF date, sub-seconds and offset, one file per call.

Machine: Linux x64, Intel Core Ultra 7 356H, 16 threads; Flutter 3.47.7; Chrome for Testing 154 and 155, Firefox 157
and 158, headless; the test page is not cross-origin isolated (no COOP/COEP).

## Native targets

| Target | Library (bytes) | Call (µs) | Decrypt (MB/s) | EXIF (files/s) |
|---|---|---|---|---|
| android-arm64 | 598,688 | device lab | device lab | device lab |
| android-arm | 420,872 | device lab | device lab | device lab |
| android-x64 | 600,824 | device lab | device lab | device lab |
| ios-arm64 | CI | device lab | device lab | device lab |
| ios-sim-arm64 | CI | — | — | — |
| ios-sim-x64 | CI | — | — | — |
| macos-arm64 | CI | CI | CI | CI |
| macos-x64 | CI | — | — | — |
| windows-x64 | CI | CI | CI | CI |
| linux-x64 | 574,560 | 0.16 | 1,138 | 250,900 |
| linux-arm64 | CI | CI | CI | CI |

*CI*: built and checked against the thresholds by CI, which this machine cannot do (no Apple or Windows toolchain, no
arm64 Linux). *Device lab*: needs a phone; none was available. *—*: not run anywhere (simulators, and the x64 half of
the universal macOS library on CI's arm64 Mac). The linux-x64 row is the prebuilt library bundled by `flutter build
linux` (`probe.sh`). The machine is shared, so runs vary: three runs of a release build from the checkout gave
0.15–0.18 µs, 839–1,164 MB/s and 252,700–258,400 files/s, and one under the gate's own load 597 MB/s and 34,800
files/s. Two clean builds of android-arm64 and linux-x64 were byte-identical.

## Web

The module is 42,139 bytes brotli (40,233 for the `.wasm`, 1,906 for its JavaScript), loaded on first use.

| Browser | Compiler | Call (µs) | Decrypt (MB/s) | EXIF (files/s) |
|---|---|---|---|---|
| Chrome 155 | dart2js | 0.17 | 343 | 254,830 |
| Chrome 155 | dart2wasm | 0.65 | 177 | 5,560 |
| Chrome 154 | dart2js | 0.18 | 342 | 250,110 |
| Chrome 154 | dart2wasm | 0.70 | 174 | 3,796 |
| Firefox 158 | dart2js | 0.31 | 366 | 242,550 |
| Firefox 158 | dart2wasm | 0.81 | 171 | 5,630 |
| Firefox 157 | dart2js | 0.30 | 360 | 240,020 |
| Firefox 157 | dart2wasm | 1.37 | 169 | 5,440 |
| Safari | dart2js | — | — | — |

dart2wasm is slower only because `Uint8List.toJS` copies bytes that live in Dart's heap: with the same inputs already
in a JavaScript buffer, as a `Blob` or `fetch` gives them, a one-off run measured 315–334 MB/s and 198,000–257,000
files/s. `dart test` runs Safari with dart2js only; no job runs it for now (photolib-design#288).

## Against the criteria

| Criterion | Threshold | Result |
|---|---|---|
| Builds | all targets, prebuilt libraries in `flutter build` without Rust | pass: CI builds all 11 and probes each platform without Rust (M0-12); the Linux probe passed here |
| Size | ≤ 3 MB per native ABI; ≤ 1 MB brotli WASM, lazy-loaded | pass: 0.42–0.60 MB; 0.04 MB |
| Call overhead | ≤ 50 µs native, ≤ 200 µs web | pass: 0.16 µs; 0.17–1.37 µs |
| Decrypt | ≥ 200 MB/s native, ≥ 50 MB/s web | pass: 1,138 MB/s; 169–366 MB/s |
| EXIF + date | ≥ 1,000 files/s on a mid-range phone | 250,900 files/s on the desktop; the phone is unmeasured |
| Browsers | Chrome, Firefox, Safari (latest two), without COOP/COEP | pass: Chrome, Firefox; Safari is unmeasured |

At the spike, every result in the tables cleared its threshold by at least 3.4× (dart2wasm's decrypt). Native EXIF
clears it by 250× on the desktop, so a phone several times slower still passes. Open: the phones (M0-27's device lab),
Safari and the CI numbers above.

## Crypto suite v1 (M0-40)

Local data protection (ADR-0015) puts the crypto v1 kernel on every read of a cached file and on every
unlock, with budgets of its own, which `bench.dart` now fails below:

* *decrypt*: a 1 MiB PLB envelope sealed by the kernel, opened as a stream of its sixteen 64 KiB chunks, as apps and
  the viewer read originals and video (on the web from JavaScript buffers, as `fetch` and files give them). Budget:
  ≥ 1 GiB/s natively and ≥ 300 MiB/s in WASM, on a performance core (the owner confirmed, photolib-design#333): this
  machine's efficiency cores reach under 800 MiB/s natively and about 300 MiB/s in WASM. Pieces over 128 KiB are
  slower natively: glibc maps such buffers afresh, and every step pays the page faults.
* *Argon2id at the device floor*: one `KEK_pass` derivation at `m = 64 MiB, t = 3`, and the passcode's `t` that the
  calibration rule ([crypto-v1](crypto-v1.md#local-data-protection)) derives from it for at least 250 ms per unlock.
  The floor must stay within the 600 ms unlock budget of design doc 21 §8.

Measured on 2026-10-16 on the machine above, shared with other builds (load average 13 to 68). With the metadata
reader below, the web module is 192,200 bytes brotli (SIMD on) and the linux-x64 library 1,199,664 bytes.

| Target | Decrypt (MiB/s) | Argon2id at the floor (ms) | Passcode `t` |
|---|---|---|---|
| linux-x64 | 1,134–1,229 | 116–172 | 5–7 |
| Chrome 155, dart2js | 385–417 | 134–170 | 5–6 |
| Chrome 155, dart2wasm | 392–455 | 130–190 | 4–6 |
| Android, the reference phone | device lab | device lab | device lab |

The cipher alone reaches about 1.7 GiB/s on a performance core of this CPU, so the native margin is thin: copies and
allocations per step are kept to one each. Argon2id calibration on the reference phone, a mid-range Android, waits for
M0-27's device lab (M0-42 measures the whole unlock there).

## Since the report

* M1-05's metadata reader ([ADR-0036](../adr/0036-kernel-metadata-reader.md)), 2026-10-16: the linux-x64 library is
  838,720 bytes and the web module 100,061 bytes brotli. The EXIF benchmark now runs through the reader; a release
  build from the checkout measured 279,700 files/s in process.
* M1-06's movies, motion photos and Live Photos ([ADR-0044](../adr/0044-kernel-movies-motion-and-live-photos.md)),
  2026-10-16, with crypto v1: the linux-x64 library is 1,298,168 bytes and the web module 215,007 bytes brotli.
* M6-01's public-key crypto (PLH with X-Wing, PLS logs, OPAQUE), 2026-10-16: the libraries are 1,866,904 bytes
  (linux-x64) and 1,348,560–1,924,432 (Android), the web module 289,281 bytes brotli. Every crypto vector passes
  through the C ABI and in WASM, and PLB decrypt still clears its budgets: 1,190 MiB/s on linux-x64, 392 MiB/s in
  Chrome 155 (dart2js and dart2wasm) and 400–444 MiB/s in Firefox 158; Argon2id at the floor took 142–199 ms.
* M1-07's capture-time resolver ([ADR-0051](../adr/0051-capture-time-resolver.md)), 2026-10-16: with crypto v1 and
  `regex-lite` for the file-name registry, the linux-x64 library is 1,484,296 bytes and the web module 235,559 bytes
  brotli. The EXIF benchmark now runs every file-name rule too: the gate measured 82,000 files/s through the C ABI
  and, in Chrome 155, 50,200 (dart2js) and 4,900 (dart2wasm).
* M0-36's CPU reference renderer for the editor ([ADR-0054](../adr/0054-editor-rendering.md)), 2026-10-16: +66,976
  bytes, the linux-x64 library is 1,266,640; +12,465 brotli, the web module is 204,665.
