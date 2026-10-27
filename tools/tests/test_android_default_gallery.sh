#!/usr/bin/env bash
# Android default-gallery integration (M1-46, ADR-0401): the manifest answers the intents of the ADR-0039 matrix, the
# platform halves exist and agree with the Dart that calls them, and the app asks for no all-files access and no
# unrestricted battery use. Nothing here compiles Kotlin (the gate does not; `flutter build apk` does), so the
# runners are checked as text against the Dart over org.photolib/intents and org.photolib/gallery.
set -uo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
cd "$REPO_ROOT" || exit 1
require_tool python3

ANDROID=app/android/app/src/main
MANIFEST=$ANDROID/AndroidManifest.xml
KOTLIN=$ANDROID/kotlin/org/photolib/photolib

# --- the manifest's intent filters, as `activity|action|category,...|scheme/host/mime;...` lines
filters=$(python3 -I - "$MANIFEST" <<'PY'
import sys
import xml.etree.ElementTree as ET

A = "{http:" + "//schemas.android.com/apk/res/android}"
root = ET.parse(sys.argv[1]).getroot()
for activity in root.iter("activity"):
    name = activity.get(A + "name")
    for f in activity.findall("intent-filter"):
        actions = [a.get(A + "name") for a in f.findall("action")]
        categories = [c.get(A + "name") for c in f.findall("category")]
        data = [
            "/".join((d.get(A + "scheme") or "-", d.get(A + "host") or "-", d.get(A + "mimeType") or "-"))
            for d in f.findall("data")
        ]
        for action in actions:
            print(f"{name}|{action}|{','.join(categories)}|{';'.join(data)}")
PY
)
[[ -n $filters ]] && ok "$MANIFEST parses and has intent filters" || fail "$MANIFEST: no intent filters"

has() { # <activity> <action> <categories regex> <data regex> <description>
  if grep -Eq "^$1\|$2\|$3\|$4" <<<"$filters"; then ok "$5"; else fail "$5 (no filter matches $1 $2 $3 $4)"; fi
}

main=.MainActivity
default='([^|]*,)?android.intent.category.DEFAULT(,[^|]*)?'
for action in android.intent.action.VIEW android.provider.action.REVIEW com.android.camera.action.REVIEW; do
  for kind in image video; do
    has $main "$action" "$default" ".*(-|[a-z]+)/-/$kind/\*" "$action opens $kind/* items"
  done
  has $main "$action" "$default" "content/media/-" "$action opens typeless MediaStore URIs (Xiaomi, Open Camera)"
done
has $main android.intent.action.EDIT "$default" ".*/-/image/\*" "EDIT edits image/*"
has $main android.intent.action.ATTACH_DATA "$default" ".*/-/image/\*" "ATTACH_DATA takes image/*"
for kind in image video; do
  has $main android.intent.action.PICK "$default" ".*/-/$kind/\*" "PICK picks $kind/*"
  has $main android.intent.action.GET_CONTENT "([^|]*,)?android.intent.category.OPENABLE(,[^|]*)?" ".*/-/$kind/\*" \
    "GET_CONTENT offers $kind/* as openable"
  has $main android.intent.action.SEND "$default" ".*/-/$kind/\*" "SEND takes $kind/*"
  has $main android.intent.action.SEND_MULTIPLE "$default" ".*/-/$kind/\*" "SEND_MULTIPLE takes $kind/*"
done
has $main android.intent.action.MAIN "([^|]*,)?android.intent.category.APP_GALLERY(,[^|]*)?" "" "answers APP_GALLERY"
has $main android.intent.action.MAIN "([^|]*,)?android.intent.category.LAUNCHER(,[^|]*)?" "" "stays the launcher"
has .SecureReviewActivity android.provider.action.REVIEW_SECURE "$default" ".*/-/image/\*" \
  "REVIEW_SECURE goes to the lock-screen activity"
has .SecureReviewActivity android.provider.action.REVIEW_SECURE "$default" "content/media/-" \
  "REVIEW_SECURE accepts typeless MediaStore URIs"
if grep -E "^\.MainActivity\|android.provider.action.REVIEW_SECURE" <<<"$filters" >/dev/null; then
  fail "MainActivity must not answer REVIEW_SECURE: it would show the library over the lock screen"
else ok "only the lock-screen activity answers REVIEW_SECURE"; fi
assert_prose $MANIFEST '<activity[^>]*SecureReviewActivity[^>]*showWhenLocked="true"' \
  "the review activity shows over the lock screen"
assert_prose $MANIFEST '<activity[^>]*SecureReviewActivity[^>]*excludeFromRecents="true"' \
  "and stays out of the recents"
assert_prose $MANIFEST 'photolib' "keeps the photolib: links"

# --- permissions: what a gallery asks, and never more (ADR-0039)
assert_matches $MANIFEST 'android.permission.SET_WALLPAPER' "can set the wallpaper"
assert_matches $MANIFEST 'android.permission.MANAGE_MEDIA' "can ask for MANAGE_MEDIA"
for forbidden in MANAGE_EXTERNAL_STORAGE REQUEST_IGNORE_BATTERY_OPTIMIZATIONS READ_EXTERNAL_STORAGE_ALL; do
  if grep -q "android.permission.$forbidden" "$MANIFEST"; then fail "$MANIFEST must not ask for $forbidden"; else ok "never asks for $forbidden"; fi
done
assert_matches $MANIFEST 'android.permission.READ_MEDIA_IMAGES' "reads images through the media permissions"
assert_matches $MANIFEST 'android.permission.READ_MEDIA_VISUAL_USER_SELECTED' "works with partial access"
assert_prose $MANIFEST '<queries>.*android.intent.action.EDIT.*image/\*' "can list the editors on the phone"
assert_prose $MANIFEST '<queries>.*android.media.action.IMAGE_CAPTURE' "can name the default camera"

# --- widgets (MOB-11): one provider per kind, each with its description and a receiver
for kind in memories people albums favourites; do
  provider=$ANDROID/res/xml/widget_$kind.xml
  assert_file "$provider"
  assert_prose $MANIFEST "<receiver[^>]*\\.${kind^}Widget\"[^>]*>.*APPWIDGET_UPDATE.*widget_$kind" \
    "the $kind widget has its receiver and provider"
  assert_matches $ANDROID/res/values/strings.xml "widget_${kind}_description" "the $kind widget is described"
  assert_matches $KOTLIN/PhotoWidget.kt "class ${kind^}Widget : PhotoWidget\\(\"$kind\"\\)" "the $kind widget reads its entry"
done

# --- Kotlin halves answer what the Dart calls
check_methods() { # <dart> <kotlin> <channel>
  local methods
  assert_matches "$1" "MethodChannel\\('$3'\\)" "$1 opens $3"
  assert_matches "$2" "\"$3\"" "$2 opens $3"
  methods=$(tr '\n' ' ' <"$1" | grep -oE "invoke(List|Map)?Method(<[^(]*>)?\( *'[a-zA-Z]+'" | cut -d"'" -f2 | sort -u)
  [[ -n $methods ]] && ok "$1 calls methods of $3" || fail "$1 calls no method of $3"
  for method in $methods; do
    assert_matches "$2" "\"$method\"" "answers $method"
  done
}
check_methods app/lib/features/gallery/intents.dart $KOTLIN/GalleryIntents.kt org.photolib/intents
check_methods app/lib/features/gallery/actions.dart $KOTLIN/GalleryActions.kt org.photolib/gallery
assert_patterns assert_matches $KOTLIN/GalleryActions.kt \
  'FLAG_GRANT_WRITE_URI_PERMISSION' "edit-with grants the editor write access" \
  'FileProvider\.getUriForFile' "to a copy in the cache, never the original" \
  'setStream\(it, null, true, flags\)' "the wallpaper is set for the chosen screens" \
  'FLAG_LOCK' "including the lock screen" \
  'requestPinShortcut' "pins folder and album shortcuts" \
  'ACTION_REQUEST_MANAGE_MEDIA' "opens the MANAGE_MEDIA request" \
  'ACTION_APPLICATION_DETAILS_SETTINGS' "and the app's details when that screen is not there" \
  'ACTION_MANAGE_DEFAULT_APPS_SETTINGS' "opens the default apps screen"
assert_patterns assert_matches $KOTLIN/GalleryIntents.kt \
  'FLAG_GRANT_READ_URI_PERMISSION' "a pick answers with read grants" \
  'EXTRA_ALLOW_MULTIPLE' "reads whether a pick takes many" \
  'MediaStore\.getMediaUri' "finds the MediaStore item of a file manager's URI"
assert_patterns assert_matches $KOTLIN/MainActivity.kt \
  'GalleryIntents\(this' "the activity opens GalleryIntents" \
  'GalleryActions\(this' "and GalleryActions" \
  'override fun onNewIntent' "takes intents while it runs" \
  'actions\?\.onActivityResult' "and the editor's answer"
assert_matches $KOTLIN/SecureReviewActivity.kt 'override val secure = true' "the lock-screen activity says it is"

finish
