# The admin console and `photolibd doctor`

Administrators run the server from the app: **Settings → Server administration** (desktop and web), which appears for
an administrator's account. The choices behind this page are [ADR-0063](../adr/0063-admin-console.md).

| Tab | What it shows and does |
|---|---|
| Overview | Usage per account and per file kind (originals, thumbnails, previews), libraries and their state, database backups with the last verified restore ([backups](backups.md)), [integrity findings, scrubs and device backups](#integrity-and-backups); *Restore* a backup, *Back up now*; *Reprocess* a library or a folder of it; *Add an external library* for an account, *Scan now* |
| Jobs | Jobs by status and type; retry a failed one, cancel a queued one, pause a job type |
| Accounts | Add, edit, disable, enable and delete accounts; a *Password setup link* and its QR code for a new account or a forgotten password ([accounts](users.md#passwords-and-sign-in)) |
| Storage | Each store checked now: reachable, credentials, marker, free space |
| Audit log | Every change made through photolibd, newest first |
| Server log | The newest lines of the server's log |
| Pair a device | A link and its QR code that bring every address of the server, the certificate this app pinned and the instance to a new device's *Add a server*, so nobody types a URL ([clients](clients.md#pairing-a-device)) |
| Remote access | Tailscale or Headscale, WireGuard and Cloudflare Tunnel with their configuration filled in from this app's addresses, and *Test from outside* ([remote access](remote-access.md)) |
| Policies | A second factor for every account ([details](users.md#second-factors-and-passkeys)), face recognition for new accounts, days in the trash, free disk below which uploads pause: by default the smaller of 5 % and 20 GB ([uploads](configuration.md#uploads)), days in which the scrub checks every original (90), hours after which a device's backup is silent (48); the server's [capability switches](#capability-switches) and presets |
| Diagnostics | The doctor's checks; copy the diagnostics bundle for a bug report |

## Pausing jobs

A pause stops a job type (such as `render`) from starting for 60 minutes, or up to 24 hours, then ends by itself; a
banner shows it until then. Running jobs finish. Backups (`backup`), purges (`storage-purge`) and scrubs (`scrub`) can
be paused only from a signed-in administrator's session, never with an API key, and for up to 7 days at a time (10080
minutes). Pausing a paused type again sets its end anew.

## Reprocessing

*Reprocess* reads metadata again, regenerates thumbnails and previews, or detects faces again, for the photos of a
library, of a folder of it (`2024/05`, with its subfolders) or of a selection — and only those. Private libraries are
processed on their owners' devices and are skipped.

## Integrity and backups

The scrub checks every original of every store once in the policy's days ([ADR-0234](../adr/0234-integrity-scrubbing-and-backup-watchdog.md)):
on the data directory it reads each file, on an object store it checks each object's size and stored hash, and with
[`rehash_gib_per_month`](configuration.md#settings) downloads them within that budget; external libraries' files it
reads at their libraries' rates. *Integrity* lists what it found: a file whose bytes changed (bit-rot; in an external
library, while the file kept its size and modification time), one that is gone, has another size or was replaced, and
an object no file names (an orphan). Put a damaged file back with the bytes of its hash: from a backup, or by backing
it up again from a device that still has it, which photolibd writes in its place
([ADR-0252](../adr/0252-repair-from-devices-and-external-scrubs.md)); an external library's file only from a backup,
at the path shown. The next check resolves the finding, as deleting the file does. Check an orphan before you delete
or keep it: photolibd deletes nothing on its own.
*Backups* lists each device that reports its backup, with when it was last seen and how many items it still had to
back up; one silent for longer than the policy's hours is marked, and the `PhotolibDeviceBackupSilent`
[alert](monitoring.md#alerts) fires.

## External libraries

*Add an external library* gives an account a read-only library of a folder on the server, which must lie under the
configuration's [`external_roots`](configuration.md#external-libraries) and overlap no other library; scanning starts
at once. *Scan now* looks for new, moved and missing files. With the API you can also set how many files and bytes
per second it may read (`CreateExternalLibrary`), hide what a held scan did not find with the token its status shows
(`ConfirmScan`), announce new files (`HintPaths`) and move a library to its share's new path (`RelocateLibrary`).
A library's previews, the JPEGs that clients which cannot decode a HEIC or RAW show, are as big as the original by
default (`high`); `SetRenditionQuality` makes them 2160 px (`standard`) for a library on a small disk and renders them
again ([ADR-0405](../adr/0405-rendition-quality-and-desktop-heic-placeholders.md)).

## Capability switches

The server's policy switches what it offers ([ADR-0240](../adr/0240-server-policies.md)): managed libraries, uploads
(device backup, web and CLI), the folder browser, device folders in connected apps, sharing and public links, edits,
deletes, XMP writes, face recognition and smart search. Each is on unless the server, an account (from its menu under
*Accounts*) or a library (under *Overview*) sets it off; the narrowest level that sets one wins, and each switch says
where its value comes from. Off, photolibd refuses what needs it to every session, API key and sync stream, whatever
the roles: an upload gets `policy.disabled` naming the capability, no managed library is created, and with sharing off
no album, partner share or link gives anyone access. A preset sets every switch for the server and clears what accounts
and libraries set; the switches stay editable:

| Preset | Off |
|---|---|
| Archive viewer | Managed libraries, uploads, device folders, edits, deletes and XMP writes: the external read-only libraries are the only source of truth |
| Family backup | XMP writes |
| Personal | Sharing and public links |

A setting or switch the [configuration](configuration.md#settings) pins under `settings` shows read-only as *Set in
config*; the API refuses to change it (`setting.pinned`). Every change, and every start that applies a changed pin, is an
audit event.

## `photolibd doctor`

```sh
photolibd --config photolib.yaml doctor --bundle diagnostics.json
```

It checks the configuration, PostgreSQL (version, `fsync`, data checksums), the filesystems of the data, work and
database directories (no network or FUSE filesystem for state, write barriers on), the instance marker, every store
(credentials, marker, clock skew against the store's `Date` header), how requests arrive through the reverse proxy
(`X-Forwarded-Proto: https`, `X-Forwarded-For`) and app versions older than the server serves. It asks the running
photolibd on `listen` (`/diagnostics`, with `metrics.token`), which saw the requests; when none answers, or without the
token, it checks on its own. It exits with 1 when a check fails. The bundle adds versions, the settings that differ from
the defaults (secrets read `[redacted]`) and the log tail. `photolibd doctor schema` compares the schema with its
migrations ([upgrades](upgrades.md)).
