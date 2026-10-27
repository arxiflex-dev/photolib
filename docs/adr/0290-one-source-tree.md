# ADR-0290 — One source tree on every client: local folders as a nested tree with an eye per node

* **Status**: Accepted — 2026-10-23 (PHO-213, photolib-design#642). The owner kept all four decisions as made (1, 2, 3, 4:
  "Keep").
* **Requirements**: R-APP-5, LIB-11, ORG-02. **Design**:
  client app,
  feature catalogue LIB-11;
  amends [ADR-0210](0210-device-folders.md).

## Context

ADR-0210 gave Android a flat list of MediaStore buckets, a switch each and two modes; desktops and Chromium had a
list of roots with nothing below them. Taking WhatsApp, Telegram and twenty app folders out was twenty taps, with no
way to act on a parent, and three places looked three ways (owner, 2026-10-21).

## Decision

* **One model, one widget.** `SourceNode` (`photolib_data`, `sourceTree`) and `SourceTree` (`app/lib/ui/`) on Android,
  desktops and Chromium: the device, its MediaStore volumes or folder roots, and their folders. Folders above buckets
  that hold no items (`Android/media/com.whatsapp/`) are nodes too, their counts summed. Settings › Library, search's
  folder picker and the design system's gallery show the same widget; the timeline's and viewer's *Exclude this
  folder* hides that node.
* **Own visibility, inherited.** `device_folder.visibility` is `shown`, `hidden` or `inherit` (replica schema 21); a
  node shows what the nearest node at or above it with its own value says, else the device's: the M1-37 mode,
  *only the chosen* being the device hidden. An eye writes the node's own value only where its parent would not
  (else `inherit`); hiding a parent hides everything below that inherits, in one write, and a child shown under a
  hidden parent paints the parent *partly shown*. *Show only this*, *Show everything here* and *Hide everything else
  here* clear the own values below the node or its parent.
* **A query-time filter.** `excluded_folder` resolves the nearest own value in SQL, so `hidden_folder` stays the one
  helper of every device-item query and of the 50 ms bucket query at 1M items. Desktop and browser folder files are
  filed under a `device_folder` row per directory, their root as volume, so a sub-folder's eye is the same filter:
  no rescan, and `.photolibignore` stays the owner's.
* **Migration.** Schema 14's `excluded` and `chosen` become one column: the mode's list wins where a folder is on
  both, the other list is kept where it is not, and a folder on neither keeps what the mode showed of it under the
  tree's inheritance. `exportDeviceFolders` carries the own values (M1-33).
* **The row.** Chevron, icon (volume, root, folder, an app's folder), name, `items · newest · state`, the state's
  actions (allow again, remove the root, forget a folder that is gone) and the eye. Volumes and roots open, folders
  closed; a search keeps the nodes above what it finds; a hidden node dims, never leaves the tree. Arrows, space,
  Enter and type-ahead work it; a long press or a right click opens the menu. On a window 840 px wide or more the node
  in focus shows beside the tree with its menu as buttons.

**Needs thinking**, answered with the issue's leans and kept by the owner (2026-10-23):

1. *An eye on single items?* No: hiding a photo is M1-16's per-item *hide*; this is *not showing a source*. The UI
   says *hide* for items and shows an eye only on sources.
2. *A shown child under a hidden parent, or a cascade without exceptions?* Keep the exception: it costs one column,
   and include and exclude lists both exist in folder galleries.
3. *M2-18's backup choice: a second column or another copy of the widget?* A second per-node column of the same tree
   (back up, don't, inherit), one screen for what I see and what I back up.
4. *Where both M1-37 lists name a folder, which wins in the one column?* The active mode's list; a folder on neither,
   under a folder of the other value, keeps what the mode showed, so nothing the user sees changes on upgrade
   (`migration_test`).

**Out of scope.** iOS: PhotoKit albums are not a tree; M4-04 maps albums to nodes of kind album.

Amendments this needs in the design repository:

* docs/10 §5.2: `device_folder` holds every local source's folders with an own visibility; the tree and its widget.
* M1-15's folders view and M2-18's backup selection reuse `SourceTree` (M2-18 as a second per-node column); M3-19's
  folder browser of server libraries reuses it too.

## Consequences

* Every folder file costs a `device_folder` lookup per directory a scan reconciles; `removeFolder` forgets the root's
  folders.
* A visibility changes one row; showing a node again loses nothing below it.
* Flipping the device switches between M1-37's two lists only where they did not clash or nest.

## Options considered

* **Hide cascades, no exceptions**: simpler, but the include-inside-exclude case galleries are praised for is lost.
* **A materialised `effective` column**: faster to read, but every write must update a subtree; the view's correlated
  lookup over the few own values stays within budget.
* **Writing `.photolibignore` for desktop sub-folders**: the file is the owner's and the server's (M1-03), and a
  rule there needs a rescan to undo.
