# Architecture Decision Records

The decisions recorded in this repository. The design's own ADRs stay in the
design repository, which links back
here; the two share one numbering.

| ADR | Title | Status |
|---|---|---|
| [0013](0013-licence.md) | Licence and contribution model | Accepted |
| [0017](0017-documentation-site.md) | Documentation site: MkDocs published to GitHub Pages | Accepted (owner, 2026-10-15) |
| [0018](0018-dev-s3-store.md) | S3-compatible store for the development stack: Garage | Accepted (owner deferred, 2026-10-15) |
| [0019](0019-protobuf-toolchain.md) | Protobuf toolchain: pinned local plugins, checked-in generated code, breaking baseline | Accepted (owner confirmed, 2026-10-15) |
| [0020](0020-in-tree-synthetic-media-corpus.md) | The media test corpus starts as a generated, in-tree synthetic corpus of decodable files | Accepted (owner confirmed with decodable payloads, 2026-10-15; Pillow confirmed, the rest deferred in photolib-design#287) |
| [0021](0021-photolibd-startup-contract.md) | photolibd startup contract: YAML configuration, one health listener, instance marker | Accepted (owner confirmed, 2026-10-15) |
| [0022](0022-object-store-backends.md) | Object-store backends for managed data | **Proposed — owner to confirm** |
| [0023](0023-flutter-app-shell.md) | Flutter app shell: libraries, application ID, version pin and platform minimums | Accepted (owner answered, 2026-10-15; smoke test twice a day in photolib-design#294, never by hand in photolib-design#315) |
| [0024](0024-media-sandbox.md) | Media sandbox: a self-confining `photolibd media-child` | Accepted (owner confirmed, 2026-10-15) |
| [0025](0025-crypto-suite-v1-specification.md) | Crypto suite v1 specification: the choices behind the bytes | Accepted (owner confirmed, 2026-10-15) |
| [0026](0026-kernel-prebuilt-libraries.md) | Kernel prebuilt libraries: Dart build hooks, GitHub releases, pinned SHA-256 | Accepted (owner confirmed, 2026-10-15; publishing by hand on the tag deferred in photolib-design#304) |
| [0027](0027-connect-rpc.md) | Connect on axum with the connectrpc crate, checked by the official conformance suite | Accepted (owner confirmed, 2026-10-15) |
| [0028](0028-postgresql-migrations.md) | PostgreSQL migrations: one transaction per upgrade, released means merged, restore from the CLI | Accepted (owner confirmed, 2026-10-15) |
| [0029](0029-kernel-go-no-go.md) | Kernel go/no-go: the Rust kernel ships on all targets | Accepted (owner confirmed Rust, 2026-10-16) |
| [0030](0030-i18n-and-accessibility-scaffolding.md) | i18n and accessibility scaffolding: lints, pseudo-locales, self-hosted web fonts | Accepted (owner answered, 2026-10-16 and 2026-10-17) |
| [0031](0031-local-replica.md) | Local replica: schema conventions and the pre-migration backup | Accepted (owner deferred, 2026-10-16) |
| [0032](0032-one-network-stack.md) | One network configuration per server, on dart:io until the OkHttp and URLSession stacks | Accepted (owner confirmed, 2026-10-16) |
| [0033](0033-upgrade-path-harness.md) | Upgrade-path harness: a fixture per schema version, recorded resolutions, a weekly large run | Accepted (owner confirmed, 2026-10-16) |
| [0034](0034-job-queue.md) | Job queue: leases fenced in the handler's transaction, a reconciler that re-arms by key | Accepted (owner confirmed UTC, deferred the rest, 2026-10-16) |
| [0035](0035-accounts-and-first-run.md) | Accounts: a logged setup token, a database-enforced audit trail, viewers and delayed deletion | Accepted (owner confirmed, partly deferred, 2026-10-16) |
| [0036](0036-kernel-metadata-reader.md) | Kernel metadata reader: byte ranges in, merged fields and raw date claims out, fuzzed in and out of the gate | Accepted (owner confirmed the ranges; coverage-guided fuzzing and panic isolation added, 2026-10-17) |
| [0037](0037-design-system.md) | Design system and interaction primitives: Material 3 plus our gestures, commands and motion | Accepted (owner confirmed, 2026-10-16) |
| [0038](0038-authorization-policy.md) | Authorization: one policy crate, a rule per procedure, one SQL scope for single and list reads | Accepted (owner answered, 2026-10-17) |
| [0039](0039-android-default-gallery.md) | Android default gallery: API 30 and what is supported | Accepted (owner confirmed, 2026-10-16) |
| [0040](0040-timeline-image-pipeline.md) | Timeline image pipeline: platform decoders hand pixels over natively, Flutter's codecs on the web | Accepted (owner confirmed with conditions, 2026-10-17) |
| [0041](0041-journaled-file-operations.md) | Journaled file operations and the blob-store drivers | Accepted (owner confirmed, 2026-10-16) |
| [0042](0042-desktop-folder-sources.md) | Desktop folder sources: identity by file id, offline drives, shared ignore rules | Accepted (owner answered, 2026-10-16; reading confirmed 2026-10-17) |
| [0043](0043-video-editing-engines.md) | Video engines: OS frameworks on phones and Apple, LGPL FFmpeg on desktops, the server for the web | Accepted (owner answered, 2026-10-17) |
| [0044](0044-kernel-movies-motion-and-live-photos.md) | Kernel movies, motion photos and Live Photos: the host's file size, verified videos, a pairing call | Accepted (owner confirmed, 2026-10-16) |
| [0045](0045-mediastore-index.md) | MediaStore index: identity, re-scans and the install id | **Proposed — owner to confirm** |
| [0046](0046-observability.md) | Observability: metrics behind a token on the one port, a Prometheus and Grafana bundle, opt-in traces | Accepted (owner answered one port, deferred the rest, 2026-10-16; proxies refuse the metrics, 2026-10-17) |
| [0048](0048-performance-harness.md) | Performance harness: budgets and instruction counts in the gate, timings on reference machines | Accepted (owner kept the budgets and added instruction counts, 2026-10-17; confirmed `perf-accept:`, 2026-10-20) |
| [0049](0049-ios-backup-strategy.md) | iOS backup: the app's own path for every library, the system upload extension to speed up standard ones | Accepted (owner answered, 2026-10-17; the extension waits for a phone test of `104`) |
| [0050](0050-on-device-ml-runtime.md) | On-device ML runtime: ONNX Runtime through its C API, fp16 models, accelerators behind a golden check | Accepted (owner confirmed, 2026-10-16) |
| [0051](0051-capture-time-resolver.md) | Capture-time resolver: host-supplied claims and zones, a compiled file-name registry, explained results | Accepted (owner confirmed the registry, deferred the confidence rules; default zones added, 2026-10-16; the GPS zone shows a disagreeing measured offset's wall clock, 2026-10-17) |
| [0052](0052-password-login-and-sessions.md) | Password login: OPAQUE with a key file, setup tokens, device sessions and a progressive lockout | Accepted (owner answered, 2026-10-17; #402's choices kept, 2026-10-21) |
| [0053](0053-change-capture.md) | Change capture: tombstone keys and scopes, a purge horizon, and how the watermark lag is measured | Accepted (owner confirmed, 2026-10-16; the lag again, 2026-10-21) |
| [0054](0054-editor-rendering.md) | Editor rendering: Flutter shaders for the preview, the kernel's CPU renderer for every export | Accepted (owner answered, 2026-10-17; A′ instead of A) |
| [0055](0055-scoped-api-keys.md) | Scoped API keys: a key acts as its account within its scopes | Accepted (owner confirmed, 2026-10-17) |
| [0056](0056-web-support-tiers.md) | Web support tiers and media path: Chromium on WebAssembly, the rest on JavaScript | Accepted (owner confirmed, 2026-10-16; thumbnails 2026-10-21) |
| [0057](0057-encrypted-local-store.md) | Encrypted local store: page keys leave the kernel, keystore keys through secure storage | Accepted (owner confirmed; a lost keystore key rebuilds the store, a recovery code at L1, 2026-10-17; the passphrase fallback kept, 2026-10-23) |
| [0058](0058-supply-chain-baseline.md) | Supply-chain baseline: lock-file SBOMs, keyless cosign signatures, air-gapped test suites | Accepted (owner answered, 2026-10-17; kept, 2026-10-21) |
| [0059](0059-encrypted-media-playback.md) | Encrypted playback: a decrypting loopback proxy on native, MSE and a Service Worker on the web | Accepted (owner answered, 2026-10-17; the benchmark unless a diff provably touches no playback code) |
| [0060](0060-hdr-native-leaf-views.md) | HDR through native leaf views: Flutter keeps the gestures, the leaf cross-fades in | Accepted (owner answered go now, devices verified later, 2026-10-17; reading confirmed, 2026-10-20) |
| [0061](0061-resumable-uploads.md) | Resumable uploads: the IETF protocol on `/upload`, acknowledged after a verified write | Accepted (owner confirmed, 2026-10-16) |
| [0063](0063-admin-console.md) | Admin console: one admin service, pauses that end by themselves, the doctor inside the server | Accepted (owner answered, 2026-10-17; maintenance paused up to 7 days in one request, 2026-10-23) |
| [0064](0064-model-registry-and-licence-gate.md) | Model registry: one compiled-in list, a licence gate in the gate, bundles for air-gapped installs | Accepted (owner kept no signed manifest yet, 2026-10-23; the rest not mentioned) |
| [0065](0065-photolib-upload.md) | `photolib upload`: a journal on the client for resumable, idempotent bulk uploads | Accepted (owner confirmed, rate-limited requests back off exponentially, 2026-10-17) |
| [0066](0066-server-ingest-pipeline.md) | Server ingest: the clients' kernel calls over ranges, a job per committed upload, metadata as data | Accepted (owner answered, 2026-10-17 and 2026-10-21; other files kept on four conditions, dated by name) |
| [0070](0070-thumbnail-caches.md) | Thumbnail caches: a self-healing disk cache, ThumbHash meshes, platform thumbnailers first | Accepted (owner changed: kernel-only encoding, T2 sealed now, 2026-10-17) |
| [0071](0071-desktop-folders-in-the-app.md) | Desktop folders in the app: a desktop-only picker, the scan state in the replica, sandboxed macOS | Accepted (owner answered, 2026-10-17; read-write for the save dialog kept, 2026-10-21) |
| [0072](0072-device-metadata-extraction.md) | Device metadata extraction: in the data isolate, resumable through the replica, the platform first | Accepted (owner answered, 2026-10-17; the packages' `bundle: false` kept, 2026-10-23) |
| [0082](0082-web-folders.md) | Web folders: File System Access handles in IndexedDB, size and time for identity, scans on the page | **Proposed — owner to confirm** |
| [0084](0084-image-renditions.md) | Image renditions: libvips in the media sandbox, versioned specs, media through the API | **Proposed — owner to confirm** |
| [0085](0085-video-renditions.md) | Video renditions: FFmpeg in the sandbox on `worker:transcode`, the original as its own R1 | **Proposed — owner to confirm** |
| [0086](0086-local-search-v0.md) | Local search v0: filters and file names over the replica, compiled in Dart | **Proposed — owner to confirm** |
| [0087](0087-oidc-single-sign-on.md) | OIDC single sign-on: a PKCE code flow the client holds, checked claims, identities by issuer and subject | **Proposed — owner to confirm** |
| [0088](0088-passkeys-and-totp.md) | Passkeys and TOTP: a verifier on ring, a relay page for apps, a policy checked on every request | Accepted (owner confirmed, 2026-10-20) |
| [0089](0089-managed-library-layout.md) | Managed library layout: a template applied once, per-original moves, delayed deletes | Accepted (owner confirmed, 2026-10-23) |
| [0090](0090-local-store-cipher-and-passcode-binding.md) | Local store cipher, Argon2id floor and hardware binding per guess | **Proposed — owner to confirm** |
| [0091](0091-sync-rpc.md) | Sync RPC: generic typed rows, streams of tables, a JSON cursor and an epoch counted in the data directory | **Proposed — owner to confirm** |
| [0092](0092-per-user-deduplication.md) | Per-user deduplication: `CheckHashes` and links at upload completion, over the owner's own libraries | Accepted (owner kept it, 2026-10-23) |
| [0093](0093-external-libraries.md) | External libraries: a job per folder, read in place, hashed last, under the operator's roots | Accepted (owner kept the counted files that are not media, 2026-10-21; the whole ADR confirmed, 2026-10-23) |
| [0094](0094-device-timeline.md) | The device timeline: a view over the device index, selections as position ranges, date added from the id | **Proposed — owner to confirm** |
| [0095](0095-photokit-index.md) | PhotoKit index: JSON pages, the persistent history and an install id kept on the phone | **Proposed — owner to confirm** |
| [0096](0096-deployment-images-compose-and-proxies.md) | Deployment: an Alpine image, compose with PostgreSQL, proxy templates under test | **Proposed — owner to confirm** |
| [0098](0098-frame-budgets-against-an-idle-isolate.md) | Frame budgets against an idle isolate, raised on a busy machine | **Proposed — owner to confirm** |
| [0106](0106-photo-viewer.md) | The photo viewer: tiles within two screens, a region decoder per platform, actions by URI | **Proposed — owner to confirm** |
| [0107](0107-desktop-and-web-thumbnail-decoders.md) | Desktop and web thumbnail decoders: the platform first, libvips beside the app, the browser in a worker | **Proposed — owner to confirm** |
| [0112](0112-video-and-motion-photo-playback.md) | Video and motion-photo playback: video_player on every target, libmpv on desktops through our adapter | Accepted (owner confirmed, 2026-10-20; Windows's libmpv is M1-39) |
| [0113](0113-test-children-die-with-the-test.md) | Test children die with the test: process groups under `setpriv --pdeathsig`, stopped on drop, tools within a limit | Accepted (owner confirmed, 2026-10-20) |
| [0114](0114-tiles-at-once.md) | Tiles at once: no deferral, stand-ins from the kernel's embedded previews, a ThumbHash per item | Accepted (owner confirmed, 2026-10-20) |
| [0115](0115-debug-diagnostics.md) | Debug diagnostics: one log per isolate, redacted and sealed in release, exported as a bundle | Accepted (owner kept read-write, had the release log sealed, 2026-10-20) |
| [0116](0116-web-video-posters.md) | Web video posters: the browser's player off the DOM, kept sealed in the store | Accepted (owner confirmed, 2026-10-20) |
| [0120](0120-client-sync-engine.md) | Client sync engine: reachability garbage collection, drop-and-refetch resets, epochs on cursors | Accepted (owner confirmed, 2026-10-20) |
| [0121](0121-calibrated-throughput-budgets.md) | Throughput budgets calibrated against a reference measured beside them | Accepted (owner confirmed, 2026-10-20; #520's choice kept, 2026-10-23) |
| [0122](0122-faster-image-ingest.md) | Faster image ingest: reused renderer memory, sequential JPEG decoding | Accepted (owner confirmed, 2026-10-20) |
| [0125](0125-sign-in-from-the-app.md) | Signing in from the app: one server per install, its session in the keystore, the bearer on its endpoint | Accepted (owner answered, 2026-10-20; #522's choices kept, 2026-10-23) |
| [0128](0128-downloads.md) | Downloads: a stored zip64 streamed to a save dialog, the browser's downloads or the share sheet | Accepted (owner confirmed, 2026-10-20; #523's choice kept, 2026-10-23) |
| [0129](0129-lint-ratchet.md) | Lint rules held by a ratchet: every language in the gate, a baseline that only shrinks | Accepted (owner confirmed, 2026-10-20) |
| [0140](0140-jank-budgets-against-an-idle-isolate.md) | Jank budgets against an idle isolate, retries, and reruns of what failed | Accepted (owner changed: retries, the idle share subtracted only, 2026-10-20) |
| [0143](0143-ios-share-inbox.md) | Sharing into the iOS app: an App Group inbox the app saves into the Photos library | Accepted (owner confirmed, 2026-10-20; the App Group registered in the test phase) |
| [0144](0144-desktop-drag-and-drop.md) | Desktop drag and drop: dropped folders join the library, dropped photos open, cells drag out as files | Accepted (owner confirmed, 2026-10-20) |
| [0146](0146-panoramas-and-360-video.md) | Panoramas and 360° video: one shader, projected where the frames are, without native renderers | Accepted (owner answered, 2026-10-21 and 2026-10-23) |
| [0153](0153-ios-widget-snapshot.md) | Home screen widgets read a pre-rendered snapshot in the App Group | Accepted (owner confirmed, 2026-10-21) |
| [0154](0154-desktop-open-with-packages-keyring.md) | Desktop integration: open with Photolib, packaging smoke builds, a keyring fallback | Accepted (owner confirmed, 2026-10-21) |
| [0155](0155-partner-shares-own-libraries.md) | A partner share shows the owner's own libraries, not what the owner put in others' | Accepted (owner confirmed, 2026-10-21) |
| [0189](0189-fuzz-libfuzzer-ncsa.md) | libFuzzer's NCSA licence is allowed in the fuzz workspace only | Accepted (owner confirmed, 2026-10-21) |
| [0190](0190-sphere-viewer-follow-ups.md) | Sphere viewer: packed filter input, a tile pyramid, cylinders and a fisheye lens | Accepted (owner confirmed, 2026-10-23) |
| [0200](0200-device-and-server-copies.md) | One photo on the device and the server: one tile, the verified server copy as truth, the device a cache | Accepted (owner kept every proposal, 2026-10-21) |
| [0201](0201-sources.md) | Sources: one model for every place photos come from; drives and shares through the server | Accepted (owner kept all but proposal 6, 2026-10-21, and this status, 2026-10-23; proposal 6, OAuth, owner to confirm) |
| [0202](0202-albums-across-custody.md) | Albums across custody and over files that come and go: members are never dropped, absence is shown | Accepted (owner kept every proposal, 2026-10-21) |
| [0206](0206-desktop-single-instance.md) | One Photolib over the store on Linux and Windows | Accepted (owner confirmed, 2026-10-21) |
| [0208](0208-viewer-ergonomics-and-kept-state.md) | Viewer ergonomics behind settings, and what the user looked at kept in the vault | Accepted (owner answered: videos with sound pause other audio, 2026-10-21) |
| [0209](0209-server-session-in-the-store.md) | The server and its session are sealed in the local store | Accepted (owner confirmed, 2026-10-21) |
| [0210](0210-device-folders.md) | Android device folders: an included set by volume and relative path, applied at query time | Accepted (owner confirmed, 2026-10-21) |
| [0212](0212-perf-part-in-half-the-time.md) | The perf part in half the time: setup beside the server, a timing again only over budget | Accepted (owner confirmed, 2026-10-21) |
| [0214](0214-heic-and-hevc-without-a-system-decoder.md) | HEIC and HEVC without a system decoder: name the way out, use the system's codecs, render once | Accepted (owner answered, 2026-10-21; no codec pack, `high` by default) |
| [0215](0215-tile-kind-marks.md) | Kind marks on grid tiles: one kind glyph, a duration and a state slot, from one atlas, spoken first | Accepted (owner confirmed, 2026-10-21) |
| [0216](0216-hdr-and-raw-in-the-viewer.md) | HDR and RAW in the viewer: a facet the kernel decides, the leaf for the item shown, RAWs' largest preview | Accepted (owner confirmed, 2026-10-23) |
| [0217](0217-folders-view-and-local-albums.md) | Folders view and local albums: where their order, views and files live | Accepted (owner confirmed, 2026-10-23) |
| [0220](0220-macos-skia-until-185394.md) | macOS renders with Skia until the pinned Flutter fixes flutter/flutter#185394 | Superseded by ADR-0252 |
| [0225](0225-real-time-hints.md) | Real-time hints: a Server-Sent Events channel per foreground device, the watermark polled while it is open | **Proposed** |
| [0226](0226-backup-state-machine.md) | Backup: one state machine on the device, the account's upload destination, the device's session | **Proposed — owner to confirm** |
| [0229](0229-windows-libmpv.md) | Windows video: our own LGPL libmpv and FFmpeg, cross-built reproducibly and taken by hash | Accepted (owner confirmed, 2026-10-23) |
| [0232](0232-web-metadata-data-worker.md) | Browsers read their folders' metadata in a data worker, a second client of the drift worker | **Proposed — owner to confirm** |
| [0234](0234-integrity-scrubbing-and-backup-watchdog.md) | Integrity scrubbing at a paced rate with an egress budget, and the backup watchdog | Accepted (owner confirmed, 2026-10-21) |
| [0234](0234-several-accounts.md) | Several accounts: a replica each, the list in the store's `server` object, switching without reopening | **Proposed — owner to confirm** |
| [0238](0238-flat-panorama-strip.md) | Flat panoramas open as a strip the viewer's height, known from their metadata | Accepted (owner answered photolib-design#640, 2026-10-22) |
| [0240](0240-server-policies.md) | Server policies: capability switches in the authorisation module, presets, pins in the configuration | Accepted (owner confirmed, 2026-10-23) |
| [0242](0242-step-up.md) | Step-up: a fresh proof on the session before a way in is added, removed or replaced | Accepted (owner answered, 2026-10-23) |
| [0243](0243-setup-links-open-the-app.md) | A password setup link opens the app: photolibd's page hands it over through `photolib:` | Accepted (owner confirmed, 2026-10-21) |
| [0245](0245-deletion-trash-and-device-state.md) | One deletion path, the platforms' trashes, and Photolib's own state of device items | **Proposed — owner to confirm** |
| [0245](0245-server-ml-role.md) | The server's ML role: ONNX Runtime loaded at run time, golden self-tests per backend, a memory limit | Accepted (owner confirmed, 2026-10-23) |
| [0246](0246-adaptive-streaming.md) | Adaptive streaming: one grid of 2 s pieces, R1 sliced, the other rungs encoded on demand | Accepted (owner confirmed, 2026-10-23) |
| [0246](0246-server-renditions-tier.md) | Server renditions in the thumbnail pipeline (T5): cached by ETag, pending tiles keep their ThumbHash | **Proposed — owner to confirm** |
| [0247](0247-raw-pipeline.md) | RAW pipeline: the largest embedded JPEG, turned as the RAW is, everywhere; LibRaw once libvips has it | Accepted (owner confirmed, 2026-10-23) |
| [0249](0249-packaging-and-distribution.md) | Packaging and distribution: a package per channel, one version, photolibd with its own PostgreSQL | Accepted (owner confirmed, 2026-10-23; names and identifiers are placeholders) |
| [0252](0252-macos-keeps-impeller.md) | macOS keeps Impeller; the gate tracks the upstream fix of its foreground crash | Accepted (owner answered photolib-design#584, 2026-10-21) |
| [0252](0252-repair-from-devices-and-external-scrubs.md) | A device's upload repairs a damaged file; external libraries are scrubbed for bit-rot | Accepted (owner answered photolib-design#646, 2026-10-23) |
| [0254](0254-on-device-ml-runner.md) | On-device ML runner: kernel preprocessing, the ML isolate's golden check and a resumable gated indexer | Accepted (owner answered photolib-design#644, 2026-10-23) |
| [0255](0255-private-mode-keys-and-recovery.md) | Private-mode keys: the recovery kit, two unlock paths and the upload gate | Accepted (owner confirmed, 2026-10-23) |
| [0257](0257-external-change-detection.md) | External libraries: offline roots, moves, missing files under a guard, watches and hints | **Proposed — owner to confirm** |
| [0259](0259-external-sidecars-and-ignore-rules.md) | Ignore rules and sidecars of external libraries | Accepted (owner confirmed, 2026-10-23) |
| [0261](0261-viewer-actions-animated-facet-and-search-grid.md) | Rotate, map and set-as in the viewer, animated images by facet, search results as the library's | Accepted (owner confirmed, 2026-10-23) |
| [0263](0263-webhooks-events-and-wasm-plugins.md) | Webhooks and the events API carry signed, ids-only hints of standard libraries; WASM plugins in a capability sandbox | Accepted (owner confirmed, 2026-10-23) |
| [0265](0265-mutations-outbox-merge.md) | Mutations: an outbox of edits merged by photolibd per field, per album item and by fractional keys | **Proposed — owner to confirm** |
| [0266](0266-backups-restore-drills-manifests-postgresql-upgrades.md) | Backups with a daily restore drill, restores from the console, manifests for recovery from storage, PostgreSQL major upgrades by copy | **Proposed — owner to confirm** |
| [0267](0267-unified-timeline.md) | The unified timeline: one tile per photo from two flags that triggers keep | **Proposed — owner to confirm** |
| [0278](0278-on-device-ml-in-production.md) | On-device ML in production: models from the user's server, gated indexing, results handed off | Accepted (owner confirmed, 2026-10-23) |
| [0290](0290-one-source-tree.md) | One source tree on every client: local folders as a nested tree with an eye per node | **Proposed — owner to confirm** |
| [0311](0311-reaching-the-server.md) | Reaching the server without a network degree: discovery, pairing, guided tunnels and a relay later | Accepted (owner confirmed, 2026-10-23) |
| [0312](0312-app-icon.md) | The app icon on every platform, written from the design's export set | **Proposed — owner to confirm** |
| [0314](0314-language-setting.md) | Language setting: the device's language unless Settings chooses one | **Proposed — owner to confirm** |
| [0331](0331-basic-edits-saved-as-copies.md) | Basic edits in the alpha: copies next to the original, lossless where the JPEG allows | **Proposed — owner to confirm** |
| [0383](0383-viewer-chrome-and-panel.md) | The viewer's chrome, cues and information panel: the open choices of the owner's prototype | **Proposed — owner to confirm** |
| [0384](0384-map-view.md) | The map view: kernel clustering on the device, raster tiles on consent, area as a search filter | **Proposed — owner to confirm** |
| [0385](0385-web-client-v1.md) | The web client v1: served by photolibd, driven in the browsers it supports | **Proposed — owner to confirm** |
| [0386](0386-organisation-v1.md) | Organisation v1: trash retention, emptying through the intent log, albums made on devices, per-surface hiding | **Proposed — owner to confirm** |
| [0387](0387-heic-in-the-browser-with-webcodecs.md) | HEIC in the browser: the kernel finds the HEIF tiles, WebCodecs decodes them with the system's HEVC decoder | **Proposed — owner to confirm** |
| [0388](0388-ocr-and-text-search.md) | OCR and text search: PP-OCRv5 on the ml role, text as untrusted data, a job and a search API | **Proposed — owner to confirm** |
| [0389](0389-face-detection-and-embeddings.md) | Faces: YuNet and SFace behind one consent, boxes kept against the original and moved by the kernel | **Proposed — owner to confirm** |
| [0390](0390-hdr-handling.md) | HDR handling: tone mapping for videos and stills, gain maps in JPEG derivatives, an HDR HLS variant | **Proposed — owner to confirm** |
| [0393](0393-storage-policies-and-offline-pins.md) | Storage policies and offline pins: four presets, a sealed budgeted store, pins of albums, searches and photos | **Proposed — owner to confirm** |
| [0391](0391-edit-recipes-and-version-history.md) | Edit recipes and the version history: an `EditRecipe` per immutable version, derived data that follows | **Proposed — owner to confirm** |
| [0394](0394-macos-desktop-build.md) | The macOS desktop app builds from a fresh checkout and runs with its network, libvips and orientation: the kernel built by the hook, `network.client`, libvips bundled by the Xcode build, upright HDR | **Proposed — owner to confirm** |
| [0401](0401-android-default-gallery-integration.md) | Android default gallery: intents, edit with, wallpaper, onboarding, shortcuts and widgets | **Proposed — owner to confirm** |

To record a decision, copy [template.md](template.md) to the next number free in both repositories, set its status
to *Proposed* (the owner accepts it) and add a row above. `tools/tests/test_adr.sh` checks that every ADR is listed
with its status. Images an ADR cites live in `assets/<number>/`.
