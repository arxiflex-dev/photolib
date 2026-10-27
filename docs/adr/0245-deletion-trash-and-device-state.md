# ADR-0245 — One deletion path, the platforms' trashes, and Photolib's own state of device items

* **Status**: **Proposed — owner to confirm** (photolib-design#64, roadmap M1-16).
* **Requirements**: F-14, R-APP-4, R-REL-1. **Design**:
  client app §3.6, §5.4, §6.1,
  feature catalogue ORG-11, ORG-16, ORG-18,
  [ADR-0039](0039-android-default-gallery.md).

## Context

Design 10 §5.4 asks for one `DeletionService` that performs every deletion, a lint against platform delete calls
elsewhere, two tiers of trash behind one screen, restore that keeps dates and paths, favourites stored transactionally
and mirrored to the platform, and hiding that never depends on `.nomedia` or an OS policy (Simple Gallery lost hidden
media to both). It leaves open what identifies an item's content before M2 hashes files, how long Photolib keeps what
the platform's trash does not expire, and what iOS, Windows and browsers use as their trash.

## Decision

We will delete device items only through `DeletionService` (`photolib_data`), which calls one `MediaPlatform` per
source; `app/tool/deletion_lint.dart` fails `flutter test` on platform delete calls anywhere else, and a file the app
made itself says why with `// deletion-ok: <reason>`.

* Android: MediaStore's trash, delete and favourite requests, one per 2,000 URIs, so at most one dialog per batch and
  none with `MANAGE_MEDIA`; the system's expiry (`DATE_EXPIRES`) shows per item.
* iOS: one `PHAssetChangeRequest` into Recently Deleted, which Photos confirms; only Photos restores from it, so the
  items leave Photolib's index at once and no undo is offered.
* Linux: the freedesktop.org trash, which file managers list and restore from; macOS: the Trash through
  `FileManager.trashItem`; Windows: the Recycle Bin through the shell (`SHFileOperationW`), found again by the `$I`
  record beside the file. Browsers, and Windows drives without a bin: Photolib's own bin, which leaves a file in place,
  out of every view, until it is purged.
* What Photolib keeps in a trash that keeps no time of its own goes for good after 60 days (ORG-18's proposal), each
  item's expiry fixed when it is trashed, so that a later change of retention never moves it.
* Deleting for good exists only in the trash screen and asks once, unless the platform asks itself; moving to the trash
  asks nothing of Photolib's and offers undo.
* Favourites, hidden and archived are columns of `local_asset`, Photolib's own; triggers also keep them in `kept_state`
  by the item's fingerprint, the SHA-256 of its size and its first and last 4 KiB, which extraction reads with one
  more small read, so that an item a move, rename or copy leaves under another row gets them back. MediaStore's
  favourites join the index's, and Photolib's are written to MediaStore and PhotoKit first.
* Hidden items leave every view; archived ones only the timeline. Both show for 5 minutes on request, and never past
  the app going to the background.
* Every grid's selection (the library's, a folder's, an album's, the favourites') and the viewer favourite, trash, hide
  and archive alike, the viewer's as `ViewerAction`s the user arranges (ADR-0261); a folder's *Delete folder* trashes
  its items through the same service.

## Consequences

* M2-22 and M2-36 delete through the same service; M2-26 maps these columns to the server's per-user state.
* A fingerprint is no content hash: two files equal in size, head and tail but not between share their state. M2's
  BLAKE3 `content_hash` can replace it with one more migration.
* A browser's folders have no trash; Photolib's own bin stands in.
* Media a folder's `.photolibignore` rules exclude are indexed with `hidden` 2: out of every view, shown with the
  hidden by *Temporarily show hidden and excluded*, and let go when the rules do. The default junk (`@eaDir`,
  `.thumbnails`...) is still never indexed.
* Photolib's own trash keeps items 30, 60 (default) or 90 days as Settings says, fixed per item when trashed.
* Nothing here runs the platforms' halves: Android's and iOS's requests, macOS's Trash (whose sandbox may refuse
  moving a file back) and Windows' shell call are verified on devices and in the smoke runs.

## Options considered

* **Full BLAKE3 hash as content identity**: what M2 computes for backup; reading whole files for every item only to keep
  favourites costs far more than 8 KiB an item.
* **The first and last 64 KiB**: fewer collisions, but SHA-256 in Dart took 5 ms an item on the loaded build machine,
  against 0.14 ms for 4 KiB each, for every item extraction reads.
* **Photolib's own bin everywhere**: one behaviour, but invisible to file managers and other galleries (Aves #1315).
* **A Photolib bin in front of Recently Deleted on iOS**: restorable from Photolib, but a deleted photo stays in Photos
  until the bin empties.
* **Asking "bin or delete forever" on every delete**: the accidental permanent deletes of the Play reviews (InShot).
