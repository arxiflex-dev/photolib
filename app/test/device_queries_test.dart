import 'dart:io';
import 'dart:typed_data';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photolib_data/photolib_data.dart';

/// Device items reach the user only through queries that filter on
/// `hidden_folder`, the device folders the user keeps out of the library
/// (ADR-0210): the timeline, its counts, search and its filters, memories,
/// widgets, the viewer's swipe context. These queries of replica.drift read
/// device items without it, for the reason given.
const _unfiltered = {
  'folderSummary': "the source tree counts each root's items, shown or not",
  'folderItems': "desktop folders' files, for the thumbnail warm-up",
  'extractionQueue':
      'extraction reads every item, so showing a folder needs no pass',
  'extractionQueueOf': 'extraction of the items on screen',
  'folderContext': 'an item another app opens swipes through its own folder',
  'deviceFolders': 'the source tree lists every folder, shown or not',
  'shownInFolders':
      'the source tree counts what every folder shows, shown or not',
  'freshFolder': 'a new folder is told of, shown or not',
  'backupReasons': 'backup explains every item it has not sent, shown or not',
  'backupItems': 'the items of one of those reasons',
};

/// The Dart files that name device items' tables themselves, and how often:
/// a new reference needs the filter, or a reason here.
const _references = {
  // The indexers, extraction and sync write and match device items.
  'packages/photolib_data/lib/src/media_store.dart': 16,
  'packages/photolib_data/lib/src/photo_kit.dart': 5,
  'packages/photolib_data/lib/src/folder_indexer.dart': 8,
  'packages/photolib_data/lib/src/folders.dart': 6,
  'packages/photolib_data/lib/src/ml.dart': 1,
  'packages/photolib_data/lib/src/sync.dart': 4,
  // Extraction, and the frame rate of the item the viewer shows, by its id.
  'packages/photolib_data/lib/src/metadata.dart': 6,
  // Backup selects, hashes and sends items by its own folder choice.
  'packages/photolib_data/lib/src/backup.dart': 13,
  // Migrations and their backup.
  'packages/photolib_data/lib/src/replica.dart': 69,
  'packages/photolib_data/lib/src/local_only.dart': 1,
  // An item's folder, by its id.
  'packages/photolib_data/lib/src/device_folders.dart': 2,
  // The source tree's counts.
  'packages/photolib_data/lib/src/source_tree.dart': 1,
  // The user's marks and deletions write items by id; the trash's expiry reads
  // every one.
  'packages/photolib_data/lib/src/deletion.dart': 5,
  'packages/photolib_data/lib/src/organise.dart': 1,
  // The diagnostic bundle's counts; on this day filters; the folders view,
  // which marks the excluded folders, a folder the user opens, the favourites.
  'packages/photolib_data/lib/src/search.dart': 10,
  // Adopting an album names each device item's asset (`adoptAlbums`), shown
  // or not.
  'packages/photolib_data/lib/src/outbox.dart': 2,
  // Albums' items and counts, which filter; their covers, by those ids or the
  // one chosen while it shows.
  'packages/photolib_data/lib/src/albums.dart': 7,
  // The map's located items, which filter.
  'packages/photolib_data/lib/src/geo.dart': 2,
  // The probe of every target's store.
  'packages/photolib_data/lib/testing.dart': 7,
  // The row of the item the viewer shows.
  'lib/features/viewer/info_panel.dart': 1,
  // The URI of the item the viewer shows, whose copy carried faces
  // (ADR-0389).
  'lib/features/viewer/info_facts.dart': 1,
  // The URI of a copy's original, by its id, to carry its faces onto it.
  'lib/features/editor/face_carry.dart': 1,
  // The versions of the asset a device item is linked to, by that item's id:
  // the history of one item the user opened, so no folder filter applies.
  'packages/photolib_data/lib/src/versions.dart': 3,
};

final _device = RegExp(
  r'\b(local_asset|timeline_item|timeline_day|timeline_added)\b|'
  r'\.(localAsset|timelineItem|timelineDay|timelineAdded)\b',
);

void main() {
  test('every query of device items filters on the folders the user keeps '
      'out, or says why not', () {
    final drift = File('packages/photolib_data/lib/src/replica.drift')
        .readAsStringSync();
    final bypass = [
      for (final m in RegExp(
        r'^(\w+)(?:\([^\n]*?\))?:(.*?);\s*$',
        multiLine: true,
        dotAll: true,
      ).allMatches(drift))
        if (_device.hasMatch(m[2]!) &&
            !m[2]!.contains('hidden_folder') &&
            !_unfiltered.containsKey(m[1]))
          m[1],
    ];
    expect(bypass, isEmpty, reason: 'filter them on hidden_folder');
    for (final name in _unfiltered.keys) {
      expect(drift, contains('\n$name'), reason: 'a stale exception');
    }

    final references = <String, int>{};
    for (final dir in [
      'lib',
      ...Directory('packages').listSync().map((d) => '${d.path}/lib'),
    ]) {
      if (!Directory(dir).existsSync()) continue;
      for (final file in Directory(dir).listSync(recursive: true)) {
        final path = file.path;
        if (!path.endsWith('.dart') ||
            path.endsWith('.g.dart') ||
            path.endsWith('replica.steps.dart') ||
            path.contains('/l10n/')) {
          continue;
        }
        final n = File(path)
            .readAsLinesSync()
            .where((l) => !l.trim().startsWith('//'))
            .fold(0, (n, l) => n + _device.allMatches(l).length);
        if (n > 0) references[path] = n;
      }
    }
    expect(references, _references);
  });

  test("a desktop's and a browser's folder files are device items too: "
      'filed under their folders, they leave every query the user sees when '
      'a folder above them hides (ADR-0290)', () async {
    final db = Replica(NativeDatabase.memory());
    addTearDown(db.close);
    final folders = [
      ('mediastore', 'external_primary', 'DCIM/Camera/', ''),
      ('folder', '/home/me/Pictures', '2024/May/', 'a.jpg'),
      ('folder', 'Photos', 'Trip/Day 1/', 'b.jpg'),
    ];
    for (final (n, (source, volume, dir, name)) in folders.indexed) {
      await db.customStatement(
        'INSERT INTO device_folder (id, volume, path) VALUES (?, ?, ?)',
        [n + 1, volume, dir],
      );
      await db
          .into(db.localAsset)
          .insert(
            LocalAssetCompanion.insert(
              id: Uint8List(16)..[15] = n,
              source: source,
              volume: Value(volume),
              sourceId: '$n',
              size: 1,
              // Today, years ago: what "on this day" shows.
              mtime: DateTime(
                2020,
                DateTime.now().month,
                DateTime.now().day,
                12,
              ).millisecondsSinceEpoch,
              path: Value('$dir$name'),
              make: const Value('Make'),
              model: const Value('Model'),
              folder: Value(n + 1),
            ),
          );
    }
    Future<List<int>> seen() async => [
      (await db.timelineDays(false, null).get()).fold(0, (n, d) => n + d.count),
      (await db.timelinePage(1 << 30, false, null, 9, 0).get()).length,
      (await db.timelineAddedDays(0, false, null).get()).fold(
        0,
        (n, d) => n + d.count,
      ),
      (await db.timelineAddedPage(1 << 62, false, null, 9, 0).get()).length,
      (await searchPage(db, const LocalQuery(), limit: 9)).count,
      (await searchCameras(db)).fold(0, (n, c) => n + c.items),
      (await onThisDay(db, DateTime.now())).length,
    ];
    expect(await seen(), [3, 3, 3, 3, 3, 3, 1]);
    for (final (_, volume, dir, _) in folders) {
      await show(
        db,
        volume,
        dir.substring(0, dir.indexOf('/') + 1),
        shown: false,
      );
    }
    expect(await seen(), [0, 0, 0, 0, 0, 0, 0]);
  });
}
