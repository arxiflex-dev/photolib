import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/features/folders/folders_page.dart' show hexOf;
import 'package:photolib/features/folders/items_page.dart';
import 'package:photolib/features/gallery/actions.dart';
import 'package:photolib/l10n/app_localizations.dart';
import 'package:photolib_data/photolib_data.dart' show LocalFolder;

/// The link a home-screen shortcut to the device folder [folder], named
/// [name], opens (MOB-02, ADR-0401); the router routes it.
Uri folderLink(LocalFolder folder, String name) => Uri(
  scheme: 'photolib',
  path: '/shortcut/folder',
  queryParameters: {
    'source': folder.source,
    'volume': folder.volume,
    'dir': folder.dir,
    'name': name,
  },
);

/// The link a home-screen shortcut to the album [id], named [name], opens.
Uri albumLink(Uint8List id, String name) => Uri(
  scheme: 'photolib',
  path: '/shortcut/album',
  queryParameters: {'id': hexOf(id), 'name': name},
);

/// What the shortcut [link] shows; null for a link that names nothing.
ItemsSource? shortcutSource(Uri link) {
  final query = link.queryParameters;
  final name = query['name'] ?? '';
  switch (link.path) {
    case '/shortcut/folder':
      if (query case {
        'source': final source,
        'volume': final volume,
        'dir': final dir,
      }) {
        return ItemsSource.folder((
          source: source,
          volume: volume,
          dir: dir,
        ), name);
      }
    case '/shortcut/album':
      final id = query['id'] ?? '';
      if (id.length == 32 && RegExp(r'^[0-9a-f]+$').hasMatch(id)) {
        return ItemsSource.album(
          Uint8List.fromList([
            for (var i = 0; i < id.length; i += 2)
              int.parse(id.substring(i, i + 2), radix: 16),
          ]),
          name,
        );
      }
  }
  return null;
}

/// The id of the launcher's shortcut to [source], the same for the same
/// folder or album; null for what has no shortcut (the favourites).
String? shortcutId(ItemsSource source) =>
    switch ((source.folder, source.album)) {
      (final f?, _) => 'folder:${f.source}|${f.volume}|${f.dir}',
      (_, final a?) => 'album:${hexOf(a)}',
      _ => null,
    };

/// Offers to pin a shortcut to [source] on the home screen, saying so when
/// the launcher cannot.
Future<void> addShortcut(
  BuildContext context,
  WidgetRef ref,
  ItemsSource source,
) async {
  final strings = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final id = shortcutId(source);
  if (id == null) return;
  final link = switch ((source.folder, source.album)) {
    (final f?, _) => folderLink(f, source.title ?? ''),
    (_, final a?) => albumLink(a, source.title ?? ''),
    _ => null,
  };
  if (link == null) return;
  final pinned = await ref
      .read(galleryPlatformProvider)
      .pinShortcut(id, source.title ?? '', link);
  if (!pinned) {
    messenger.showSnackBar(
      SnackBar(content: Text(strings.galleryShortcutFailed)),
    );
  }
}
