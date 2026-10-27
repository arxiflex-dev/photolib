# ADR-0401 — Android default gallery: intents, edit with, wallpaper, onboarding, shortcuts and widgets

* **Status**: **Proposed — owner to confirm**. Builds [ADR-0039](0039-android-default-gallery.md)'s matrix (M1-46).
* **Requirements**: R-APP-4. **Design**: [ADR-0039](0039-android-default-gallery.md),
  [ADR-0331](0331-basic-edits-saved-as-copies.md), [ADR-0245](0245-deletion-trash-and-device-state.md),
  [the readiness guide](../dev/android-default-gallery.md).

## Context

ADR-0039 decided which intents a default gallery answers on every Android version and what it never asks for. None was
answered yet: another app's `VIEW` opened nothing. The design documents the item cites (docs/10 §5, docs/18 §8) and its
"Android galleries analysis" are not in the repository, and no phone was available, so the choices below take the most
conservative reading and the owner confirms them.

## Decision

1. **Kotlin extracts, Dart decides.** `GalleryIntents.kt` hands the raw fields of an intent to Dart
   (`org.photolib/intents`); `GalleryIntent.fromMap` says what each means, so that it is tested. A file manager's
   document URI or a `file:` path is replaced by its MediaStore item, so that it opens in its folder.
2. **A `VIEW` opens exactly the requested item among its folder's items, in the folder's sort order, decided before
   the viewer opens** (`planOpen`): no list loads afterwards and nothing moves. The folder's hidden items stay out;
   an item the library does not know, or has in the trash, opens alone. A `REVIEW`, legacy `REVIEW` and `ATTACH_DATA`
   are the same. An `EDIT` opens the item in the viewer, whose Edit button opens the editor. A `SEND` shows the shared
   items alone and imports nothing.
3. **Over the lock screen** (`REVIEW_SECURE`) only `SecureReviewActivity` answers, in a task of its own, showing the
   items the camera sent in a read-only viewer on black. The library is never built: the gate waits for the launch
   intent before it shows the app.
4. **`PICK` and `GET_CONTENT`** open the device folders, then a folder's items of the types asked for; the answer is
   a `ClipData` with a read grant. A caller that does not take many gets the first item chosen.
5. **Edit with…** gives the editor the user picks (once, remembered; Settings › Viewing forgets it) a *copy* of the item
   in the app's cache, readable and writable, so that the original is never written. What the editor returns, or
   writes to the copy when that changed it, is converted to JPEG if needed and saved beside the original as a copy
   (ADR-0331): the app shows files, so a version is a copy there. **Open with…** is a chooser without Photolib, for a
   video's external player. **Set as wallpaper** previews the picture in the shape of the screen and sets the home
   screen, the lock screen or both (`WallpaperManager.setStream` with the flags).
6. **Onboarding** (Settings › Make Photolib your gallery) lists optional steps: set as default (the system's default
   apps screen), access to all photos and videos, `MANAGE_MEDIA` (its request screen, and the app's details when the
   phone closes or lacks it), notifications. Each says once what breaks without it. It names the default camera and
   says which cameras hand off (ADR-0039). It never asks for unrestricted battery use or access to all files, and
   warns that uninstalling deletes the vault's key.
7. **Shortcuts and widgets.** A folder or an album offers *Add to home screen*; the shortcut is a
   `photolib:/shortcut/...` link the router opens. Four widgets (memories, people, albums, favourites) show a
   picture the app rendered into
   `files/widgets/` (`snapshot.json`), as the iOS widgets do from their App Group; they read files, never the library.
8. **Play**: the declaration for `READ_MEDIA_IMAGES` and `READ_MEDIA_VIDEO` is in the readiness guide; the manifest
   asks for `SET_WALLPAPER` (a normal permission) and nothing new that is dangerous.

## Consequences

* Another app can open, pick from and share to Photolib; the stock cameras still open their own gallery (ADR-0039).
* The viewer gains `readOnly`, and three actions (`wallpaper`, `editWith`, `openWith`) on Android only.
* The device checklist of the readiness guide is unverified until phones run it.
* `app/test/device_queries_test.dart` pins two more files that read a device item by id (`open_plan.dart`,
  `intent_handler.dart`); their folder siblings come from `folderContents`, which filters.
* A move between volumes now writes its copy under a short hidden name, and a failed rename puts the file back: both
  found by the readiness gates.

## Options considered

* **A separate lock-screen engine**: it would need the whole data stack; one engine with a gate that shows nothing of
  the library is smaller.
* **`MANAGE_EXTERNAL_STORAGE` for edit-with**: refused by ADR-0039; a cache copy with a grant does the same.
* **Letting the editor write the original**: some editors overwrite; the copy keeps ADR-0331's rule.
* **A launcher-chooser for the editor on every use**: remembering the choice is what the item asks.
