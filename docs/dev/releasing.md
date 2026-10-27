# Releasing

This is the checklist for the release commit. Items join it as the release work items land.

1. **Upgrade fixtures.** The release ships an upgrade fixture of every schema version: each migration's
   `server/migrations/fixtures/<migration>.sql` and the `<migration>.resolved` that
   `PHOTOLIB_RECORD_FIXTURES=1 cargo test -p photolib-db --test upgrade_path` records, made with the migration as
   [Database migrations](migrations.md#upgrade-path-harness) describes. The gate fails without them.
2. **Gate.** `bash tools/check.sh` passes on the release commit.
3. **Large upgrade.** The weekly workflow's `upgrade-large` job, started by hand on the release commit, passes: every
   fixture upgrades with a million synthetic assets.
4. **Signed files.** Each set of release files goes out through `tools/release.sh`, which adds an SBOM and
   `SHA256SUMS` signed by cosign; check a published set as [Supply chain](supply-chain.md#verifying-a-release) shows.
   The Windows client is a zip, not a store build: the post-merge run of the release commit builds
   `photolib-client-windows-x64-<short sha>` (the app, our LGPL libmpv and FFmpeg, the Visual C++ runtime, the licences
   and `SOURCE.txt`), and its `smoke-windows` job must be green (it unpacks the zip on a fresh runner, scans it for DLLs
   outside it and plays a corpus video, [ADR-0404](../adr/0404-standalone-windows-client.md)). Download it with
   `gh run download <run> -n photolib-client-windows-x64-<short sha> -D <release directory>` and add it to the release
   files before `tools/release.sh` signs them: it is published with the release.
5. **Version.** `app/pubspec.yaml`'s version (`x.y.z+code`) is every channel's ([ADR-0249](../adr/0249-packaging-and-distribution.md)):
   bump it with `deploy/helm/photolib/Chart.yaml`, the image tag of each `deploy/nas` entry, a `<release>` of
   `app/linux/packaging/org.photolib.photolib.metainfo.xml` and the builds of `app/android/fdroid/`; `test_helm.sh`,
   `test_nas.sh` and `test_stores.sh` fail until they agree. Package names and identifiers are placeholders until
   the name is final (ADR-0249).
6. **Release-candidate dry run.** Build every package with `bash tools/package.sh <target>` and the release's keys
   (`ANDROID_KEYSTORE`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`; `APPLE_SIGNING_IDENTITY`,
   `APPLE_NOTARY_PROFILE`; `WINDOWS_CERTIFICATE_SHA1`, `MSIX_PUBLISHER`), then install the previous release on each
   channel, upgrade it to the candidate and sign in to a library made with the previous release:

   | Channel | Build | Install, then upgrade from the previous release |
   |---|---|---|
   | Google Play | `aab` | internal testing track, then the update on a phone |
   | App Store | `ipa` | TestFlight, then the update on an iPhone and a Mac |
   | F-Droid, GitHub | `apk` | `adb install` the previous APK, then `adb install -r` the candidate's; F-Droid's recipe built with `fdroid build` |
   | macOS | `dmg`, `photolib.rb` | `spctl -a -vv` accepts the app; `brew install --cask ./photolib.rb`, then `brew upgrade` |
   | Windows | `msix`, `winget/` | `winget install --manifest`, then the candidate's manifest |
   | Linux | `deb`, `appimage` | `apt install ./photolib_*.deb`, then the candidate's; the AppImage replaced |
   | Server | the image | `deploy/compose` and each `deploy/nas` entry: `docker compose pull && docker compose up -d` |
   | Kubernetes | `deploy/helm` | `helm install`, then `helm upgrade` in a kind cluster |
   | Without Docker | `photolibd` | `apt install ./photolibd_*.deb`, then the candidate's; `systemctl status photolibd` |

   The gate already installs, upgrades and removes both debs with dpkg, renders and lints the chart, checks the NAS
   entries with `docker compose config` and starts the AppImage; the rest needs the stores, devices and accounts.
7. **Guides.** Two people who did not write them follow the [administrator guides](../admin/README.md) on a fresh
   host: install, a reverse proxy, a NAS, an object store, backups and a restore from them, and the upgrade from the
   previous release through `beta`. What they could not follow is fixed before the release.
8. **A new PostgreSQL major in the bundle**
   ([ADR-0266](../adr/0266-backups-restore-drills-manifests-postgresql-upgrades.md)). Move
   `deploy/compose/compose.yaml`'s `postgres` image to the new major, pin both majors in `tools/postgres.sh` (the
   gate's upgrade test fails until then), and keep the previous one beside it until the next major, so that photolibd
   copies the database at its first start:

   ```yaml
   photolibd:
     environment:
       PHOTOLIB_DATABASE__UPGRADE_FROM: postgres://photolib:${POSTGRES_PASSWORD}@postgres-18/photolib
     depends_on: {postgres-18: {condition: service_started}}  # until it answers, photolibd stops and is restarted
   postgres-18:  # the previous major's cluster, read once by photolibd, then idle; a new install has none
     <<: *hardened
     image: postgres:18.6@sha256:…
     entrypoint: [sh, -c, 'test -s "$$PGDATA/PG_VERSION" || exec sleep infinity; exec docker-entrypoint.sh postgres']
     volumes: [./postgres:/var/lib/postgresql]
     tmpfs: [/tmp, /var/run/postgresql]
   ```
