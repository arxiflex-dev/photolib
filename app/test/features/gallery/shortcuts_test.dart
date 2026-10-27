import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:photolib/features/folders/items_page.dart';
import 'package:photolib/features/gallery/shortcuts.dart';

void main() {
  const folder = (
    source: 'mediastore',
    volume: 'external_primary',
    dir: 'DCIM/My Trip & Co/',
  );
  final album = Uint8List.fromList([for (var i = 0; i < 16; i++) i]);

  test('a folder shortcut is a link the router opens, and back', () {
    final link = folderLink(folder, 'My Trip & Co');
    expect(link.scheme, 'photolib');
    expect(link.path, '/shortcut/folder');
    final source = shortcutSource(link)!;
    expect(source.folder, folder);
    expect(source.title, 'My Trip & Co');
    expect(source.album, isNull);
  });

  test('an album shortcut is a link too', () {
    final link = albumLink(album, 'Summer');
    expect(link.path, '/shortcut/album');
    final source = shortcutSource(link)!;
    expect(source.album, album);
    expect(source.title, 'Summer');
    expect(source.folder, isNull);
  });

  test('the route form, without a scheme, opens the same', () {
    final link = folderLink(folder, 'x');
    final route = Uri(path: link.path, query: link.query);
    expect(shortcutSource(route)?.folder, folder);
  });

  test('a link of nothing, or of a bad album, opens nothing', () {
    expect(shortcutSource(Uri.parse('photolib:/shortcut/folder')), isNull);
    expect(
      shortcutSource(Uri.parse('photolib:/shortcut/album?id=zz&name=a')),
      isNull,
    );
    expect(shortcutSource(Uri.parse('photolib:/library')), isNull);
  });

  test('shortcuts of the same folder or album share an id, so that the '
      'launcher does not pin it twice', () {
    expect(
      shortcutId(const ItemsSource.folder(folder, 'a')),
      shortcutId(const ItemsSource.folder(folder, 'b')),
    );
    expect(
      shortcutId(const ItemsSource.folder(folder, 'a')),
      isNot(shortcutId(ItemsSource.album(album, 'a'))),
    );
  });

  test('the favourites have no shortcut of their own here', () {
    expect(shortcutId(const ItemsSource.favourites()), isNull);
  });
}
