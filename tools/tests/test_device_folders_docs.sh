#!/usr/bin/env bash
# Android device folders (ADR-0210, M1-37) as the owner kept them (photolib-design#602): the junk-folder defaults,
# the local-only lists in the replica, the 5-minute reveal and the new-folder notice.
set -uo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
cd "$REPO_ROOT" || exit 1

ADR=docs/adr/0210-device-folders.md
DATA=app/packages/photolib_data/lib/src
assert_prose "$ADR" \
  '\* \*\*Status\*\*: Accepted — 2026-10-21 \(photolib-design#502\)\. The owner kept [^*]*photolib-design#602' \
  "is Accepted, recording the owner's answer (#602)"
assert_matches docs/adr/README.md '\(0210-device-folders\.md\) \| [^|]* \| Accepted \(owner confirmed, 2026-10-21\)' \
  "the index lists ADR-0210 as Accepted"
# 1. App-private and game data, caches, hidden folders and audio folders' album art start excluded.
assert_prose "$DATA/device_folders.dart" \
  "'/Android/data/ /Android/obb/ \.\*/ cache/ caches/ /Music/ /Podcasts/ ' '/Audiobooks/ /Ringtones/ /Alarms/ /Notifications/ /Recordings/'" \
  "the default junk list"
# 2. The mode and both lists are local-only rows of the replica; since ADR-0290 the lists are one own visibility.
assert_prose "$DATA/replica.drift" "CREATE TABLE device_folder \\([^;]* visibility TEXT NOT NULL DEFAULT 'inherit'" \
  "device_folder holds both lists, as one visibility"
assert_prose "$DATA/replica.drift" 'CREATE TABLE device_folder_mode \([^;]* only_chosen INTEGER ' \
  "device_folder_mode holds the mode"
assert_prose "$DATA/local_only.dart" "const deviceTables = \{[^}]*'device_folder', 'device_folder_mode'," \
  "both are local-only, kept by a failed migration's backup"
# 3. 'Show excluded folders' lasts 5 minutes.
assert_matches app/lib/features/folders/device_folders.dart '^const revealFor = Duration\(minutes: 5\);$' \
  "excluded folders show for 5 minutes"
# 4. Folders after the first index, never junk, are announced once.
assert_matches "$DATA/media_store.dart" 'fresh: Value\(_fresh && !junk \? 1 : 0\)' "a new folder but junk is announced"

# ADR-0290 (M1-51) as the owner kept it (2026-10-23): all four decisions, Accepted, in the index too.
TREE=docs/adr/0290-one-source-tree.md
assert_prose "$TREE" '\* \*\*Status\*\*: Accepted — 2026-10-23 \(PHO-213, photolib-design#642\)\. The owner kept all four decisions' \
  "ADR-0290 is Accepted, recording the owner's answer"
assert_matches docs/adr/README.md '\(0290-one-source-tree\.md\) \| [^|]* \| Accepted \(owner confirmed, 2026-10-23\)' \
  "the index lists ADR-0290 as Accepted"
assert_prose "$TREE" '4\. \*Where both M1-37 lists name a folder' "ADR-0290 records the fourth decision, the one column"
if grep -q 'Proposed' "$TREE"; then fail "ADR-0290 still says Proposed"; else ok "ADR-0290 says nothing is Proposed"; fi

finish
