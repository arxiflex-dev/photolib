# ADR-0013 — Licence and contribution model

* **Status**: Accepted — 2026-10-15, confirmed by the owner in
  photolib-design#265.
  Asked in photolib-design#263
  which licences dependencies may use, the owner answered "do not specify any license for now. let's assume it is
  closed for now". Asked which of the two holds, the owner answered in
  photolib-design#275
  "YES LET'S KEEP LICENSE", so AGPL-3.0-only stands. The dependency allow-list stays: besides our own licence it holds
  only permissive licences.
* **Requirements**: R-SEC-1. **Roadmap**: M0-02 (`photolib-design#3`).
* **Design**: 18 §20, 08 §2.3 and 09 §12.1.

## Context

Photolib is a self-hosted photo library with a server, Flutter apps, a web viewer and a shared Rust kernel. It links or
runs third-party media libraries (libvips, libheif, LibRaw, FFmpeg) and machine-learning models, some of them under
copyleft or non-commercial terms. We need one licence for our own code, one rule for what may enter the build, and a
way to accept contributions that does not need a lawyer for each one.

## Decision

* **Licence**: AGPL-3.0-only for all first-party code: server, apps, viewer, kernel, schemas, tooling and
  documentation. The text is the unmodified FSF licence in [`LICENSE`][license]. One licence for the whole
  repository and no per-file headers; manifests declare `license = "AGPL-3.0-only"`. The design's optional MPL-2.0 for
  the kernel and the viewer is not adopted: a second licence doubles the review burden, and relicensing later needs
  every contributor's consent.
* **Contributions**: the [Developer Certificate of Origin][dco] 1.1. Every commit carries a `Signed-off-by`
  trailer (`git commit -s`), checked by `tools/dco.sh` in the PR build (dependency-update bots are exempt). There is no
  CLA: contributors keep their copyright and contribute under the project licence (inbound = outbound).
* **Dependencies**: only the licences in [`deny.toml`][deny] are allowed, enforced in the gate (see
  [Dependency licences](#dependency-licences)).
* **FFmpeg**: LGPL builds only in the apps; GPL builds only on the server, as a separate executable (see
  [FFmpeg builds](#ffmpeg-builds)).
* **Model weights**: nothing non-commercial or otherwise restricted is bundled, downloaded or synced by default (see
  [Model weights](#model-weights)).

## App stores

AGPL-3.0 and Apple's App Store terms conflict: the store's usage rules are "further restrictions" that AGPL §10 does
not allow, and GPL apps have been pulled from it on exactly this ground (VLC, 2011). Google Play, F-Droid, the Microsoft
Store, direct downloads and Linux packages are not affected in the same way.

The design assumed that store distribution "works because the project ships its own builds". That holds only if the
project holds the rights to every line in them, and under DCO-only terms it does not: contributors keep their
copyright. Three ways to resolve it:

1. An **additional permission** under AGPL §7, recorded with the licence notice, that allows store builds to be
   distributed under the store's terms. It binds a contribution only if it is part of the terms the contribution is
   made under, so it is cheapest to add before the first external contribution is merged; the owner can add it at any
   time while all the code is owner-authored.
2. A **CLA** or copyright assignment, which lets the project relicense its own builds. It deters contributors and
   needs a legal entity to hold the rights.
3. **No App Store** distribution: sideloading and the other channels only.

Chosen: option 1, with the wording drafted and reviewed by counsel; there is no store build, submission or
release until it is in place. `LICENSE` stays the unmodified FSF text and the permission is added beside it, never
edited into it. Until then the apps are distributed as source and as direct downloads.

The AGPL network clause (§13) means that anyone who runs a modified server for other people must offer them the
modified source. That is the intent: it stops a closed hosted fork and costs self-hosters who do not modify the server
nothing.

## FFmpeg builds

| Where | FFmpeg | Rule |
|---|---|---|
| Mobile apps (iOS, Android) | none | OS codecs only; no FFmpeg is shipped |
| Desktop apps (Windows, Linux) | LGPL build | bundled player (libmpv/media_kit) with an LGPL FFmpeg, dynamically linked |
| Desktop app (macOS) | none | OS codecs only |
| Server | GPL build allowed, as a separate executable | run as a child process, never linked into our binaries; the image carries the build's source offer |
| Web viewer | none | the browser decodes |

* Never `--enable-nonfree`, anywhere: such a build cannot be redistributed.
* The apps never carry `--enable-gpl`; libmpv is built with `-Dgpl=false`. We build FFmpeg and libmpv reproducibly in
  our own CI and never vendor prebuilt binaries.
* LGPL libraries (libvips, libheif, LibRaw) are used as dynamically linked system libraries, never linked statically.

## Dependency licences

[`deny.toml`][deny] is the single allow-list: MIT, Apache-2.0 (with or without the LLVM exception),
BSD-2-Clause, BSD-3-Clause, ISC, Zlib, Unicode-3.0, MPL-2.0, CC0-1.0, and our own AGPL-3.0-only. Anything
else is denied, including a dependency with no licence. One crate-scoped exception: `libfuzzer-sys` may carry NCSA in
the fuzz workspace, which never ships ([ADR-0189](0189-fuzz-libfuzzer-ncsa.md)).

* `bash tools/check.sh` runs `cargo deny check licenses` for every Rust part and `tools/dart_licenses.py` for every Dart
  part, both against that file, and fails when either tool is missing. The PR build runs the same gate.
* Adding a licence is a reviewed change to `deny.toml`; a copyleft, source-available or non-commercial one also needs
  an amendment to this ADR.
* GPL-2.0-only is incompatible with the AGPL, and GPL-3.0 is left out so that store distribution stays possible; GPL
  and LGPL code is used only as a separate program or a dynamically linked system library.
* A package whose licence the tools cannot establish is not waved through: it is denied until the licence is known.

## Model weights

Weights are inputs with their own licences, and they are downloaded rather than compiled in, so they get a
registry-level policy (the registry itself arrives with M5-01):

| Class | Licences | Default | Handling |
|---|---|---|---|
| Permissive | Apache-2.0, MIT, BSD, CC0 | yes | normal |
| Attribution | CC-BY-4.0 | yes | credited on the attribution screen |
| Copyleft | GPL, AGPL, CC-BY-SA | no | bring-your-own, server-side only, never synced to devices |
| Restricted | non-commercial, research-only, revenue caps, custom use policies | no | bring-your-own, only after an administrator acknowledges the licence (an audit event) |

* Non-commercial or research-only weights are never bundled, downloaded or synced by default, and never fetched on
  first use.
* Weights with an unknown or missing licence are treated as restricted.
* Every registry entry records the SPDX identifier, the class, the attribution text, the source URL and any caveat about
  the training data, and its licence is re-checked at every model version bump.
* CI rejects a default registry entry outside the first two classes. Apps do not bundle large models in store binaries.

## Consequences

* Contributors keep their copyright and need only a sign-off; nobody signs a legal document.
* The project cannot relicense contributed code without asking its authors. Choosing the licence now, while the
  contributor set is small, is the cheap moment.
* Distribution through Apple's App Store needs the additional permission first (a follow-up for counsel).
* The tooling already enforces what this ADR says about contributions and dependencies: `tools/dco.sh`, `deny.toml` and
  `tools/dart_licenses.py`, all run by the gate. The FFmpeg and weights rules are enforced when the packaging and the
  model registry exist.

## Options considered

* **AGPL-3.0-only (chosen)**: protects against closed hosted forks, matches comparable projects (Immich, Ente,
  PhotoPrism) and keeps self-hosting free.
* **AGPL-3.0-or-later**: lets a future FSF version apply; "only" keeps the decision with the owner.
* **Permissive (MIT/Apache-2.0)**: eases adoption and store distribution, but allows closed forks of the server.
* **MPL-2.0 for the kernel and the viewer, AGPL elsewhere**: encourages reuse, at the cost of two licences to police.
* **DCO plus a CLA**: gives the project the rights for store builds and dual licensing, but is a barrier to contributors.

## Changing the decision

Changing the licence takes an ADR that supersedes this one, and the same change to `LICENSE`, the `AGPL-3.0-only`
entry in `deny.toml`, the `license` field of every manifest, and the statements in `README.md` and
`AGENTS.md`; `tools/tests/test_licence_policy.sh` fails until they agree.

[license]: https://github.com/arxiflex-dev/photolib/blob/main/LICENSE
[dco]: https://github.com/arxiflex-dev/photolib/blob/main/DCO
[deny]: https://github.com/arxiflex-dev/photolib/blob/main/deny.toml
