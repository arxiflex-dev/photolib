import 'dart:math';

import 'package:drift/drift.dart';
import 'package:photolib_data/src/replica.dart';
import 'package:photolib_data/src/trash_native.dart'
    if (dart.library.js_interop) 'package:photolib_data/src/trash_web.dart'
    as trash;

/// Where the platform's trash took an item: `bin`, where Photolib must look
/// to restore it, or null when the platform keeps track itself; `expires`,
/// when it goes for good, or null when Photolib's retention decides.
typedef Binned = ({String? bin, int? expires});

/// What a platform does with the media of one source (docs/10-client-app.md
/// §5.4): MediaStore, PhotoKit, or a desktop's or browser's folders. Each call
/// is one request, so that a batch costs at most one system dialog, and throws
/// when the user or the platform refuses, having changed nothing.
abstract interface class MediaPlatform {
  /// Whether the platform deletes what is in its trash when it expires; else
  /// Photolib does, after [retention].
  bool get expires;

  /// Whether Photolib can [restore] from the platform's trash; Photos'
  /// Recently Deleted lets only Photos.
  bool get restores;

  /// Whether the platform asks the user itself before it [purge]s, so that
  /// Photolib does not ask too.
  Future<bool> asksFirst();

  /// Moves [items] to the platform's trash; returns where each went, in order.
  Future<List<Binned>> trash(List<LocalAssetData> items);

  /// Brings [items] back from the trash to where they were.
  Future<void> restore(List<LocalAssetData> items);

  /// Deletes [items], which are in the trash, for good; those already gone
  /// are no error.
  Future<void> purge(List<LocalAssetData> items);

  /// Marks [items] favourite, or not, where the platform keeps favourites.
  Future<void> favorite(List<LocalAssetData> items, {required bool value});
}

/// Photolib's own bin, for files whose platform has no trash it can restore
/// from: an item in it stays where it is, out of every view but the trash's,
/// until it is purged.
class AppBin implements MediaPlatform {
  /// The bin, which keeps nothing but the index's marks and deletes a file
  /// for good with [_delete].
  const AppBin(this._delete);

  final Future<void> Function(LocalAssetData item) _delete;

  @override
  bool get expires => false;

  @override
  bool get restores => true;

  @override
  Future<bool> asksFirst() async => false;

  @override
  Future<List<Binned>> trash(List<LocalAssetData> items) async => [
    for (final _ in items) (bin: null, expires: null),
  ];

  @override
  Future<void> restore(List<LocalAssetData> items) async {}

  @override
  Future<void> purge(List<LocalAssetData> items) async {
    for (final item in items) {
      await _delete(item);
    }
  }

  @override
  Future<void> favorite(
    List<LocalAssetData> items, {
    required bool value,
  }) async {}
}

/// The one way device items are deleted (docs/10-client-app.md §5.4,
/// ADR-0245): into the platform's trash, out of it again, and for good only
/// from there. `tool/deletion_lint.dart` rejects platform delete calls
/// anywhere else.
class DeletionService {
  /// The service over [db], asking each source's platform of [platformOf].
  DeletionService(
    this.db,
    this.platformOf, {
    DateTime Function()? now,
    this.retention = defaultRetention,
  }) : _now = now ?? DateTime.now;

  /// The replica whose items it deletes.
  final Replica db;

  /// The platform of each source.
  final MediaPlatform Function(String source) platformOf;
  final DateTime Function() _now;

  /// How long Photolib keeps what is in a trash that keeps no time of its
  /// own, until the user chooses (ORG-18).
  static const defaultRetention = Duration(days: 60);

  /// How long it keeps an item from the moment it is trashed: each item's
  /// expiry is fixed then, so that a later choice never moves it.
  final Duration retention;

  /// Moves the items of [ids] that are not in the trash there, one request
  /// per source; returns whether Photolib can restore them all. What it
  /// cannot leaves the index, as from Photolib it is gone.
  Future<bool> trash(List<Uint8List> ids) async {
    var restores = true;
    for (final rows in bySource(await _rows(ids, trashed: false))) {
      final platform = platformOf(rows.first.source);
      final binned = await platform.trash(rows);
      if (!platform.restores) {
        restores = false;
        await _forget(rows);
        continue;
      }
      final until = _now().add(retention).millisecondsSinceEpoch;
      await db.batch((b) {
        for (final (i, row) in rows.indexed) {
          b.update(
            db.localAsset,
            LocalAssetCompanion(
              trashed: const Value(1),
              expires: Value(binned[i].expires ?? until),
              bin: Value(binned[i].bin),
            ),
            where: (a) => a.id.equals(row.id),
          );
        }
      });
    }
    return restores;
  }

  /// Brings the items of [ids] that are in the trash back where they were.
  Future<void> restore(List<Uint8List> ids) async {
    for (final rows in bySource(await _rows(ids, trashed: true))) {
      await platformOf(rows.first.source).restore(rows);
      for (final ids in chunked([for (final r in rows) r.id])) {
        await (db.update(db.localAsset)..where((a) => a.id.isIn(ids))).write(
          const LocalAssetCompanion(
            trashed: Value(0),
            expires: Value(null),
            bin: Value(null),
            state: Value('present'),
          ),
        );
      }
    }
  }

  /// Deletes the items of [ids] for good, which only items in the trash may
  /// be; returns them, so that what was made of them goes too.
  Future<List<LocalAssetData>> purge(List<Uint8List> ids) async {
    final rows = await _rows(ids);
    if (rows.any((r) => r.trashed == 0)) {
      throw StateError('only items in the trash are deleted for good');
    }
    for (final group in bySource(rows)) {
      await platformOf(group.first.source).purge(group);
      await _forget(group);
    }
    return rows;
  }

  /// Drops the entries of [ids] from the trash without asking their platform,
  /// which no longer holds the items (their bin was emptied, their time went
  /// by): nothing is left to delete there. Only items in the trash.
  Future<void> forget(List<Uint8List> ids) async {
    final rows = await _rows(ids);
    if (rows.any((r) => r.trashed == 0)) {
      throw StateError('only items in the trash are forgotten');
    }
    await _forget(rows);
  }

  /// Purges what Photolib keeps in a trash past its time; returns it.
  Future<List<LocalAssetData>> purgeExpired() async {
    final now = _now().millisecondsSinceEpoch;
    final expired =
        await (db.select(db.localAsset)..where(
              (a) => a.trashed.equals(1) & a.expires.isSmallerOrEqualValue(now),
            ))
            .get();
    return await purge([
      for (final r in expired)
        if (!platformOf(r.source).expires) r.id,
    ]);
  }

  Future<List<LocalAssetData>> _rows(List<Uint8List> ids, {bool? trashed}) =>
      rowsOf(
        db,
        ids,
        (a) => trashed == null
            ? const Constant(true)
            : a.trashed.equals(trashed ? 1 : 0),
      );

  /// The rows of [items], their backup state and the state kept by their
  /// content.
  Future<void> _forget(List<LocalAssetData> items) => db.transaction(() async {
    for (var i = 0; i < items.length; i += _chunk) {
      final rows = items.sublist(i, min(i + _chunk, items.length));
      final ids = [for (final r in rows) r.id];
      await (db.delete(
        db.backupState,
      )..where((s) => s.localAssetId.isIn(ids))).go();
      await (db.delete(db.keptState)..where(
            (k) => k.fingerprint.isIn([for (final r in rows) ?r.fingerprint]),
          ))
          .go();
      await (db.delete(db.localAsset)..where((a) => a.id.isIn(ids))).go();
    }
  });
}

/// How many ids a statement binds at most, well within SQLite's 32,766
/// variables.
const _chunk = 500;

/// [ids] in chunks of [_chunk].
Iterable<List<Uint8List>> chunked(List<Uint8List> ids) sync* {
  for (var i = 0; i < ids.length; i += _chunk) {
    yield ids.sublist(i, min(i + _chunk, ids.length));
  }
}

/// The rows of [ids] that [where] admits.
Future<List<LocalAssetData>> rowsOf(
  Replica db,
  List<Uint8List> ids,
  Expression<bool> Function(LocalAsset a) where,
) async => [
  for (final chunk in chunked(ids))
    ...await (db.select(
      db.localAsset,
    )..where((a) => a.id.isIn(chunk) & where(a))).get(),
];

/// The trash of a desktop's or browser's folders where the app calls none of
/// its own: Linux's freedesktop.org trash, Windows' Recycle Bin, else
/// Photolib's own bin. macOS's is its runner's (app/lib/core/deletion.dart).
MediaPlatform desktopTrash() => trash.folderTrash();

/// [rows] by source, in the order the sources first come.
Iterable<List<LocalAssetData>> bySource(List<LocalAssetData> rows) {
  final groups = <String, List<LocalAssetData>>{};
  for (final r in rows) {
    (groups[r.source] ??= []).add(r);
  }
  return groups.values;
}
