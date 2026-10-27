import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:photolib/features/folders/folders_page.dart' show hexOf;
import 'package:photolib/features/folders/sorting.dart';
import 'package:photolib/features/gallery/gallery_intent.dart';
import 'package:photolib/features/library/timeline/pipeline.dart';
import 'package:photolib/features/search/search.dart' show itemOf;
import 'package:photolib_data/photolib_data.dart' hide Stack;

/// What the viewer opens for an intent: `items`, shown at `at`, decided before
/// the viewer opens so that nothing moves once it has.
typedef OpenPlan = ({List<ThumbnailItem> items, int at, bool inLibrary});

/// The viewer's items for `uris`, which another app asked Photolib to open
/// (ADR-0401): a MediaStore item of the library opens among the other items
/// of its folder, in the order that folder is sorted in (`viewOf`, by
/// the folder's key), as swiping in the folder would; anything else opens
/// alone. With `siblings` false (over the lock screen, or items sent to
/// Photolib) the viewer shows the `uris` and nothing else of the library.
Future<OpenPlan> planOpen(
  Replica db,
  List<Uri> uris, {
  required ItemView Function(String key) viewOf,
  bool siblings = true,
  String? mime,
}) async {
  if (uris.isEmpty) return (items: <ThumbnailItem>[], at: 0, inLibrary: false);
  final rows = [for (final uri in uris) await _row(db, uri)];
  if (siblings && uris.length == 1 && rows.single != null) {
    final row = rows.single!;
    final folder = (
      source: row.source,
      volume: row.volume,
      dir: row.path ?? '',
    );
    final all = {
      for (final a in await folderContents(db, folder).first) hexOf(a.id): a,
      hexOf(row.id): row,
    }.values.toList();
    final sorted = sortItems(
      all,
      viewOf('${folder.source}|${folder.volume}|${folder.dir}'),
    );
    return (
      items: [for (final a in sorted) itemOf(a)],
      at: sorted.indexWhere((a) => hexOf(a.id) == hexOf(row.id)),
      inLibrary: true,
    );
  }
  return (
    items: [
      for (final (i, uri) in uris.indexed)
        if (rows[i] case final row?) itemOf(row) else _adHoc(uri, mime),
    ],
    at: 0,
    inLibrary: rows.every((r) => r != null),
  );
}

/// The library's row for [uri], if it is a MediaStore item that is present.
Future<LocalAssetData?> _row(Replica db, Uri uri) async {
  final ref = mediaRefOf(uri);
  if (ref == null) return null;
  final row =
      await (db.select(db.localAsset)..where(
            (a) => a.source.equals('mediastore') & a.sourceId.equals(ref.id),
          ))
          .get();
  for (final a in row) {
    // `external` is the volume of old URIs, whichever the item is on.
    if (a.state == 'present' &&
        a.trashed == 0 &&
        (ref.volume == 'external' || a.volume == ref.volume)) {
      return a;
    }
  }
  return null;
}

/// An item of another app's, or of no known place: opened where it is.
ThumbnailItem _adHoc(Uri uri, String? mime) {
  final extension = uri.path.split('.').last.toLowerCase();
  return ThumbnailItem(
    '${sha1.convert(utf8.encode('$uri'))}',
    uri,
    video:
        (mime ?? '').startsWith('video/') ||
        (uri.path.contains('.') && videoExtensions.contains(extension)),
  );
}
