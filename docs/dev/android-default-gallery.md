# Android default gallery: readiness and the Play declaration

What makes Photolib the app Android opens pictures in (M1-46,
[ADR-0401](../adr/0401-android-default-gallery-integration.md)), built on the [matrix](android-gallery.md) and
[ADR-0039](../adr/0039-android-default-gallery.md). The design documents the item cites (docs/10 §5, docs/18 §8)
and the Android galleries analysis are not in this repository: the checklist
below is the one the matrix and ADR-0039 imply.

## What answers what

| Ask | Answered by | Proven by |
|---|---|---|
| `VIEW`, `REVIEW`, legacy `REVIEW`, `ATTACH_DATA` of `image/*`, `video/*`, or a typeless `content://media` URI | `MainActivity` → `planOpen`: the item among its folder's, in the folder's sort | `test/features/gallery/open_plan_test.dart`, `gallery_links_test.dart` |
| `REVIEW_SECURE` over the lock screen | `SecureReviewActivity` → `SecureReviewGate`: only the camera's items, read-only; never the library | `secure_review_test.dart` |
| `EDIT` | the viewer on the item (its Edit button opens the editor) | `intent_handler_test.dart` |
| `PICK`, `GET_CONTENT` (multiple) | `PickerPage` → `pickedUris`, a read grant for each item | `intent_handler_test.dart` |
| `SEND`, `SEND_MULTIPLE` | the viewer on the shared items alone | `intent_handler_test.dart` |
| Edit with…, Open with… | `GalleryActions.kt`: a cache copy with a write grant; the result is saved as a copy beside the original | `edit_with_test.dart` |
| Set as wallpaper | `WallpaperPage`: preview; home, lock or both | `wallpaper_page_test.dart` |
| Onboarding | Settings › Make Photolib your gallery | `onboarding_test.dart` |
| Shortcuts, widgets | `photolib:/shortcut/...` links; four `AppWidgetProvider`s | `shortcuts_test.dart`, `widgets_test.dart` |

`tools/tests/test_android_default_gallery.sh` checks the manifest's intent filters and the Kotlin halves as text; the
gate compiles no Kotlin, so after changing `app/android/` run `flutter build apk --debug --flavor play`.

## Default-gallery readiness checklist

Run on a Pixel, a Samsung and a Xiaomi phone, one at a time (`ANDROID_SERIAL` picks one), and tick each:

1. `bash tools/android/gallery_probe.sh` lists Photolib for `VIEW`, `EDIT`, `PICK`, `GET_CONTENT`, `SEND`, `REVIEW`
   and `REVIEW_SECURE`, and fills the phone's cells of the [matrix](android-gallery.md).
2. Set as default: Settings › Make Photolib your gallery › *Open photos with Photolib*; the probe then prints Photolib
   as the default for `VIEW image/jpeg`.
3. From the phone's file manager, open a photo: Photolib shows exactly that photo, its folder's other photos around
   it, in the folder's sort order, and nothing moves after it loads.
4. From the camera apps that hand off (Aperture, Open Camera, Fossify Camera), tap the preview: the same, and `Back`
   returns to the camera. From the stock camera: onboarding names the default camera and says it opens its own gallery.
5. Lock the phone, take a photo with a camera that sends `REVIEW_SECURE`: only the photos of that session show, with no
   buttons but close; closing returns to the lock screen.
6. From another app's attach button (`GET_CONTENT`, several photos) and from its share sheet (`SEND`).
7. *Edit with…* with two editors installed: the first use asks, the second does not; the result is a new photo beside
   the original, which is unchanged. *Set as wallpaper*: the preview, then home, lock and both.
8. Onboarding explains each step once, asks for no battery exemption and no all-files access, and opens *Special app
   access › Media management* on every phone (on One UI 6 it closed the app once: the Settings path works).
9. Pin a folder and an album shortcut; place the four widgets.

No phone was available while this was built (`adb devices` lists none), so these are **unverified** and the matrix's
open cells stay *open*; every step that does not need a phone is a test above.

## Readiness gates

The gates the tests prove, in `test/features/gallery/readiness_test.dart`:

* **full disk**: a copy that cannot be written (the kernel answers `ENOSPC` through `/dev/full`) reports it, keeps the
  original whole and makes no file under the target's name;
* **300-character names**: a name over 255 bytes is refused by the rename plan, by `renameFiles` (the file is put back
  under its name, not left under the temporary one it was parked by) and by new folders; a file with a 251-character
  name still moves between volumes, since its copy is written under a short hidden name (`.photolib-<hash>.part`);
* **kill mid-move**: a move cancelled while it copies, or killed after the copy and before the removal, leaves every
  file whole in its place or moved, never half under its name, and 0 files lost; moving again writes over the partial;
* **trash fidelity**: items go to the system trash in requests of at most 2,000, in order, each with when it expires;
  restore asks for exactly the same items; deleting for good is the one delete request; a refusal changes nothing;
* **thumbnail success equals playback success**: on Android both are the platform's decoders (`loadThumbnail` and the
  player), so this is a device step: for each corpus item, its tile and its playback either both work or both show the
  failure state. **Unverified** here, as a phone is needed;
* **vault encrypted with an uninstall warning**: the vault is the sealed store of `Vault` (`vault_test.dart`); the
  onboarding page warns that uninstalling deletes its key and to keep the recovery code (`onboarding_test.dart`).

## Play declaration for broad photo access

Google Play's *Photo and video permissions* policy lets an app declare broad access when photos are its core use. The
declaration to paste into the Play Console for `READ_MEDIA_IMAGES` and `READ_MEDIA_VIDEO`:

> Photolib is a photo and video gallery and backup app. Browsing, searching and organising the user's whole library of
> photos and videos on the device is its core purpose, as it is for the device's default gallery: it opens any photo
> or video another app asks to view, edit or pick, and shows the user's folders. The system photo picker cannot serve
> this: it offers a selection, never the library, its folders or its changes. The app asks for no access to all
> files (`MANAGE_EXTERNAL_STORAGE`), and its optional `MANAGE_MEDIA` only spares the dialog of each trash or delete the
> user asked for. It reads media only on the device and sends it nowhere the user has not set up (backup to the user's
> own server).

`READ_MEDIA_VISUAL_USER_SELECTED` keeps partial access working (the library then shows what the user selected). The
manifest asks for no `MANAGE_EXTERNAL_STORAGE` and no `REQUEST_IGNORE_BATTERY_OPTIMIZATIONS`
(`test_android_default_gallery.sh` fails if either appears).
