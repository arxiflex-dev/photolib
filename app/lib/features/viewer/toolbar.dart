import 'dart:math';

import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:material_ui/material_ui.dart';
import 'package:photolib/features/settings/settings.dart';
import 'package:photolib/l10n/app_localizations.dart';
import 'package:photolib/ui/adaptive.dart' show sharesDownloads;
import 'package:photolib/ui/commands.dart';

/// The width from which the viewer is laid out for a large window: its info
/// beside the photo, the filmstrip on by default and up to 12 pinned buttons
/// (docs/10 §4.6).
const wideViewer = 760.0;

/// How many of [pins] pinned buttons show in a bar [width] wide in a window
/// [window] wide: as many as fit beside the close button (48 dp) and `⋮` (44
/// dp) in 44 dp steps, at most 12 from [wideViewer] on, 4 from 520 dp and 2
/// below; the last fold into `⋮` first.
int pinsShown(double window, double width, int pins) {
  final cap = window >= wideViewer ? 12 : (window >= 520 ? 4 : 2);
  final room = ((width - 12 - 48 - 44) / 44).floor();
  return max(0, min(min(cap, room), pins));
}

/// Whether this platform has [action] for some item: phones share what
/// desktops and browsers download, Android copies and sets as, desktops show
/// files in their folder, browsers have no maps app, and only folder and
/// MediaStore files are edited (ADR-0331).
bool onThisPlatform(ViewerAction action) {
  final android = !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  return switch (action) {
    ViewerAction.edit => !kIsWeb && defaultTargetPlatform != TargetPlatform.iOS,
    ViewerAction.share => sharesDownloads,
    ViewerAction.download => !sharesDownloads,
    ViewerAction.copy || ViewerAction.setAs => android,
    ViewerAction.wallpaper ||
    ViewerAction.editWith ||
    ViewerAction.openWith => android,
    ViewerAction.reveal => !kIsWeb && !sharesDownloads,
    ViewerAction.addToAlbum || ViewerAction.map => !kIsWeb,
    ViewerAction.copyText ||
    ViewerAction.info ||
    ViewerAction.filmstrip ||
    ViewerAction.slideshow ||
    ViewerAction.rotate ||
    ViewerAction.keepOffline ||
    ViewerAction.favourite ||
    ViewerAction.trash ||
    ViewerAction.hide ||
    ViewerAction.archive => true,
  };
}

/// What [action] is called in the bar, its menu and Settings.
String actionLabel(ViewerAction action, AppLocalizations strings) =>
    switch (action) {
      ViewerAction.favourite => strings.actionFavourite,
      ViewerAction.info => strings.viewerInfo,
      ViewerAction.edit => strings.editorEdit,
      ViewerAction.trash => strings.actionTrash,
      ViewerAction.filmstrip => strings.viewerFilmstrip,
      ViewerAction.share => strings.viewerShare,
      ViewerAction.download => strings.download,
      ViewerAction.copy => strings.viewerCopy,
      ViewerAction.copyText => strings.viewerCopyText,
      ViewerAction.reveal => strings.reveal(defaultTargetPlatform.name),
      ViewerAction.rotate => strings.viewerRotate,
      ViewerAction.map => strings.viewerMap,
      ViewerAction.setAs => strings.viewerSetAs,
      ViewerAction.slideshow => strings.slideshow,
      ViewerAction.hide => strings.actionHide,
      ViewerAction.archive => strings.actionArchive,
      ViewerAction.addToAlbum => strings.actionAddToAlbum,
      ViewerAction.keepOffline => strings.offlineKeep,
      ViewerAction.wallpaper => strings.galleryWallpaper,
      ViewerAction.editWith => strings.galleryEditWith,
      ViewerAction.openWith => strings.galleryOpenWith,
    };

/// [action]'s icon.
IconData actionIcon(ViewerAction action) => switch (action) {
  ViewerAction.favourite => Icons.favorite_border,
  ViewerAction.info => Icons.info_outline,
  ViewerAction.edit => Icons.edit_outlined,
  ViewerAction.trash => Icons.delete_outline,
  ViewerAction.filmstrip => Icons.view_carousel_outlined,
  ViewerAction.share => Icons.share_outlined,
  ViewerAction.download => Icons.download_outlined,
  ViewerAction.copy => Icons.copy_outlined,
  ViewerAction.copyText => Icons.text_snippet_outlined,
  ViewerAction.reveal => Icons.folder_open_outlined,
  ViewerAction.rotate => Icons.rotate_90_degrees_cw_outlined,
  ViewerAction.map => Icons.map_outlined,
  ViewerAction.setAs => Icons.wallpaper_outlined,
  ViewerAction.slideshow => Icons.slideshow_outlined,
  ViewerAction.hide => Icons.hide_image_outlined,
  ViewerAction.archive => Icons.archive_outlined,
  ViewerAction.addToAlbum => Icons.photo_album_outlined,
  ViewerAction.keepOffline => Icons.push_pin_outlined,
  ViewerAction.wallpaper => Icons.wallpaper,
  ViewerAction.editWith => Icons.edit_note,
  ViewerAction.openWith => Icons.open_in_new,
};

const _shadows = [Shadow(blurRadius: 6, color: Color(0x99000000))];

/// The viewer's top bar (docs/10 §4.6, VIEW-40): the close button, then the
/// [pins] that fit, the same slots for every item, a pin this item cannot
/// run, missing from [actions], disabled in its place; then `⋮`, which holds
/// the pins folded, every other action in their fixed order, [history] and
/// Customize toolbar, [onCustomize]. A gradient keeps it legible.
class ViewerBar extends StatelessWidget {
  /// The bar over the photo.
  const new({
    required this.pins,
    required this.actions,
    required this.onCustomize,
    this.history,
    this.menu,
    this.onMenu,
    this.readOnly = false,
    super.key,
  });

  /// The actions pinned, in order.
  final List<ViewerAction> pins;

  /// What the item shown can do.
  final Map<ViewerAction, Command> actions;

  /// Shows the item's edit history, when it has versions.
  final Command? history;

  /// Opens the toolbar's settings.
  final VoidCallback onCustomize;

  /// Opens and closes `⋮`.
  final MenuController? menu;

  /// Hears the menu open and close.
  final ValueChanged<bool>? onMenu;

  /// Whether only the close button shows: items looked at over the lock
  /// screen have no actions (ADR-0401).
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final window = MediaQuery.sizeOf(context).width;
    final scrim = Theme.of(context).colorScheme.scrim;
    (String, IconData) look(ViewerAction a) => _look(a, strings);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [scrim.withValues(alpha: 0.55), scrim.withValues(alpha: 0)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsetsDirectional.only(start: 4, end: 8),
          child: LayoutBuilder(
            builder: (context, box) {
              final shown = pinsShown(window, box.maxWidth, pins.length);
              final menu = [
                for (final a in pins.skip(shown)) (a, actions[a]),
                for (final a in ViewerAction.values)
                  if (!pins.contains(a) && actions[a] != null) (a, actions[a]),
              ];
              return Row(
                children: [
                  const SizedBox(
                    width: 48,
                    child: CloseButton(
                      key: ValueKey('viewer-close'),
                      style: ButtonStyle(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (!readOnly)
                    for (final a in pins.take(shown))
                      SizedBox(
                        key: ValueKey('pin ${a.name}'),
                        width: 44,
                        height: 48,
                        child: IconButton(
                          icon: Icon(look(a).$2, shadows: _shadows),
                          tooltip: look(a).$1,
                          isSelected: actions[a]?.on,
                          style: const ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: actions[a]?.run,
                        ),
                      ),
                  if (!readOnly)
                    SizedBox(width: 44, child: _more(strings, menu, look)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  (String, IconData) _look(ViewerAction a, AppLocalizations strings) =>
      switch (actions[a]) {
        Command(:final label, :final icon?) => (label, icon),
        _ => (actionLabel(a, strings), actionIcon(a)),
      };

  /// `⋮` and its menu of [entries], each an action and what it runs here.
  Widget _more(
    AppLocalizations strings,
    List<(ViewerAction, Command?)> entries,
    (String, IconData) Function(ViewerAction) look,
  ) {
    Widget item(Command? c, String label, IconData icon) => MenuItemButton(
      leadingIcon: Icon(icon),
      onPressed: c?.run,
      child: Text(label),
    );
    return MenuAnchor(
      controller: menu,
      onOpen: () => onMenu?.call(true),
      onClose: () => onMenu?.call(false),
      menuChildren: [
        for (final (a, c) in entries) item(c, look(a).$1, look(a).$2),
        if (history case final h?) item(h, h.label, h.icon ?? Icons.history),
        const Divider(),
        item(
          Command(strings.viewerCustomize, onCustomize),
          strings.viewerCustomize,
          Icons.tune,
        ),
      ],
      builder: (context, menu, _) => IconButton(
        icon: const Icon(Icons.more_vert, shadows: _shadows),
        tooltip: MaterialLocalizations.of(context).moreButtonTooltip,
        style: const ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () => menu.isOpen ? menu.close() : menu.open(),
      ),
    );
  }
}
