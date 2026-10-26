# Supply chain

The controls behind threats T42–T47 of the [threat model](threat-model.md); [ADR-0058](../adr/0058-supply-chain-baseline.md)
records the choices.

* **Pinned dependencies**: every ecosystem commits its lock file; `npm ci --ignore-scripts` installs; Renovate groups
  updates weekly, waits a week after each release, and raises alerts for known vulnerabilities from OSV in every
  ecosystem.
* **Audits in the gate**: `cargo deny` checks RustSec advisories, licences and sources; Dart and npm licences pass the
  same allow-list (`tools/dart_licenses.py`, `tools/node_licenses.py`). Bans, licences and sources fail the gate; an
  advisory never fails it (the owner, 2026-10-24,
  photolib-design#799): `tools/advisories.py` passes
  `cargo deny check advisories` through in full and ends with a `WARN advisories: <id> <crate> <version> in <workspace>`
  line per finding. Findings are reviewed from the gate's log, never hidden by an `ignore` entry in `deny.toml`; each
  fix is a task of its own, as RUSTSEC-2026-0387's (crypto-bigint 0.5.5, which no `opaque-ke` release lifts yet) is
  photolib-design#798.
* **Secret scanning**: `tools/tests/test_secrets.sh` runs gitleaks over the whole history of `HEAD`.
* **Air-gapped tests**: the gate runs `cargo test`, `flutter test` and `npm test` through `tools/offline.sh`, which
  preloads `tools/offline.c` (Linux): connections to anything but loopback, DNS and lookups of names other than
  `localhost` fail at once. cargo, rustc and dart, which fetch pinned dependencies, are exempt. Run one suite the same
  way with `bash tools/offline.sh flutter test`. Before any part runs, the gate prefetches the pinned tools and models
  these suites load (Garage, FFmpeg, the reverse proxies, ONNX Runtime and the face models), one download at a time;
  `tools/ml/fetch.py` also takes a lock and renames each file into place whole, so concurrent gates share one download.
  Under `offline.sh` the fetchers download nothing: a missing artefact is named with the command that fetches it.
* **SBOMs and signatures**: `bash tools/release.sh <dir> <name> <version> <lock file>...` adds to a release directory a
  CycloneDX 1.6 SBOM of the third-party packages the lock files pin (`tools/sbom.py`, reproducible with
  `SOURCE_DATE_EPOCH`), `SHA256SUMS` over every file, and `SHA256SUMS.sigstore.json`, signed by cosign. The
  `kernel-release` job signs keylessly with its GitHub identity, logged in Sigstore's public transparency log, which
  sees only the checksums and that identity. Releases are signed never with a personal identity: outside CI, cosign
  would log in interactively and write that account's e-mail into the public log for good, so `tools/release.sh`
  refuses unless `COSIGN_KEY` names a hardware-held key by its `pkcs11:` URI (a YubiKey or an HSM). cosign covers
  server images, kernel libraries, the CLI, Linux packages and SBOMs. App stores sign their own packages.

## Verifying a release

Download the release's files, then check the signature, which names the workflow and tag that built it, and the
checksums:

```sh
cosign verify-blob --bundle SHA256SUMS.sigstore.json \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com \
  --certificate-identity-regexp '^https://github\.com/arxiflex-dev/photolib/\.github/workflows/flutter-beta\.yml@refs/tags/kernel-v' \
  SHA256SUMS
sha256sum --ignore-missing -c SHA256SUMS
```

A release signed outside CI is verified offline with the public key its notes publish:
`cosign verify-blob --key cosign.pub --bundle SHA256SUMS.sigstore.json SHA256SUMS`.

Container images (M2-30) will be signed with `cosign sign` and carry their SBOM as a `cosign attest` attestation.
