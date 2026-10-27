import 'package:drift/drift.dart';
import 'package:photolib_data/photolib_data.dart' show isJunk;

import 'package:photolib_data/src/local_only.dart';
import 'package:photolib_data/src/replica.steps.dart';

part 'replica.g.dart';

/// Schema 21's own visibility of a folder from schema 20's two lists, the mode's list first (ADR-0290).
const visibilityFromLists =
    'CASE WHEN chosen AND (NOT excluded OR '
    "(SELECT only_chosen FROM device_folder_mode)) THEN 'shown' "
    "WHEN excluded THEN 'hidden' ELSE 'inherit' END";

/// Gives a folder on neither list, whose inherited value is not what the mode showed of it, that value as its own.
const keepModeVisibility =
    "UPDATE device_folder SET visibility = IIF(EXISTS (SELECT 1 FROM device_folder_mode WHERE only_chosen), 'hidden', 'shown') "
    "WHERE visibility = 'inherit' AND (id IN (SELECT id FROM excluded_folder)) <> "
    'EXISTS (SELECT 1 FROM device_folder_mode WHERE only_chosen)';

/// The local replica (docs/10-client-app.md §2), defined in replica.drift.
@DriftDatabase(include: {'replica.drift'})
class Replica extends _$Replica {
  /// A replica on [executor].
  Replica(super.executor, {this.openBackup}) {
    // Each opening is a connection of its own to its replica's one writer, and
    // every account has a replica of its own (ADR-0234): several instances
    // race on nothing.
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  }

  /// Opens a database next to it, named by appending a suffix to its name;
  /// only the side that opens the file, and so migrates it, needs one.
  final QueryExecutor Function(String suffix)? openBackup;

  @override
  int get schemaVersion => 29;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    // One transaction with its version: a first open cut short leaves
    // nothing half-made that the next would trip on, and syncs the disk once,
    // not once a statement.
    onCreate: (m) => transaction(() async {
      await m.createAll();
      await customStatement('PRAGMA user_version = $schemaVersion');
    }),
    onUpgrade: (m, from, to) => upgradeKeepingLocalOnly(this, m, from, to),
  );

  /// The schema migration from [from] to [to], one step per released schema
  /// version (`replica.steps.dart`, from `dart run drift_dev make-migrations`).
  Future<void> migrate(Migrator m, int from, int to) => m.runMigrationSteps(
    from: from,
    to: to,
    steps: migrationSteps(
      from1To2: (m, schema) async {
        final local = schema.localAsset;
        for (final column in [local.path, local.fileId, local.state]) {
          await m.addColumn(local, column);
        }
        await m.createIndex(schema.localAssetPath);
        await m.createIndex(schema.localAssetFile);
        await m.createTable(schema.mediaSource);
      },
      from2To3: (m, schema) async {
        // The columns schema 3 appended to the twelve of schema 2.
        final asset = schema.localAsset;
        for (final column in asset.$columns.skip(12)) {
          await m.addColumn(asset, column);
        }
        await m.createTable(schema.volumeCursor);
      },
      from3To4: (m, schema) async {
        // The columns schema 4 appended to the 24 of schema 3.
        final asset = schema.localAsset;
        for (final column in asset.$columns.skip(24)) {
          await m.addColumn(asset, column);
        }
        await m.createIndex(schema.localAssetPending);
        await m.addColumn(schema.volumeCursor, schema.volumeCursor.root);
      },
      from4To5: (m, schema) async {
        // The columns schema 5 appended to the 36 of schema 4.
        final asset = schema.localAsset;
        for (final column in asset.$columns.skip(36)) {
          await m.addColumn(asset, column);
        }
      },
      from5To6: (m, schema) async {
        final asset = schema.localAsset;
        await m.addColumn(asset, asset.added);
        // The time in each id: a UUIDv7's first 48 bits, in hex.
        String nibble(int i) =>
            "(instr('123456789ABCDEF', substr(hex(id), ${i + 1}, 1))"
            ' << ${44 - 4 * i})';
        final time = [for (var i = 0; i < 12; i++) nibble(i)].join(' + ');
        await customStatement('UPDATE local_asset SET added = $time');
        await m.createView(schema.timelineItem);
        await m.createIndex(schema.localAssetTimeline);
        await m.createIndex(schema.localAssetAdded);
      },
      from6To7: (m, schema) async {
        await m.createTable(schema.albumMember);
        await m.createTable(schema.partnerShare);
        await m.addColumn(schema.syncCursor, schema.syncCursor.epoch);
        await m.createIndex(schema.assetLibrary);
        await m.createIndex(schema.assetVersionAsset);
        await m.createIndex(schema.faceAsset);
        await m.createTrigger(schema.assetDeleted);
      },
      from7To8: _from7To8,
      from8To9: _from8To9,
      from9To10: (m, schema) => m.createTable(schema.partnerLibrary),
      from10To11: _from10To11,
      from11To12: _from11To12,
      from12To13: _from12To13,
      from13To14: _from13To14,
      from14To15: (m, schema) => m.createTable(schema.localMl),
      from15To16: _from15To16,
      from16To17: (m, schema) => m.createIndex(schema.localAssetRoot),
      from17To18: _from17To18,
      from18To19: _from18To19,
      from19To20: _from19To20,
      from20To21: _from20To21,
      from21To22: _from21To22,
      from22To23: _from22To23,
      from23To24: _from23To24,
      from24To25: _from24To25,
      from25To26: _from25To26,
      from26To27: _from26To27,
      from27To28: _from27To28,
      from28To29: _from28To29,
    ),
  );

  /// Schema 29 (ORG-17): what an account hides by album or library, which the
  /// tiles of the timeline leave out; the account stream sends it again.
  Future<void> _from28To29(Migrator m, Schema29 schema) async {
    await m.addColumn(
      schema.assetUserState,
      schema.assetUserState.albumHidesTimeline,
    );
    await m.addColumn(
      schema.assetUserState,
      schema.assetUserState.albumHidesMemories,
    );
    await m.createTable(schema.albumUserState);
    await m.createTable(schema.libraryUserState);
    for (final old in [schema.linkedTile, schema.cloudItem]) {
      await m.drop(old);
    }
    await m.createView(schema.linkedTile);
    await m.createView(schema.cloudItem);
    for (final trigger in [
      schema.assetStateHiddenInsert,
      schema.assetStateHiddenUpdate,
      schema.libraryStateHiddenInsert,
      schema.libraryStateHiddenUpdate,
      schema.libraryStateHiddenDelete,
    ]) {
      await m.createTrigger(trigger);
    }
    await customStatement("DELETE FROM sync_cursor WHERE stream = 'account'");
  }

  /// Schema 8 keeps each item's ThumbHash, which the timeline shows.
  Future<void> _from7To8(Migrator m, Schema8 schema) async {
    await m.addColumn(schema.localAsset, schema.localAsset.thumbhash);
    await m.drop(schema.timelineItem);
    await m.createView(schema.timelineItem);
  }

  /// Schema 9 sends motion photos back to extraction, to find their videos.
  Future<void> _from8To9(Migrator m, Schema9 schema) async {
    final asset = schema.localAsset;
    await m.addColumn(asset, asset.motionOffset);
    await m.addColumn(asset, asset.motionLength);
    await customStatement(
      'UPDATE local_asset SET extracted = NULL '
      "WHERE ',' || facets || ',' LIKE '%,motion_photo,%'",
    );
  }

  /// Schema 11 keeps every library of a partner's that its stream sent; the
  /// partners' streams send those not shown whole again, from scratch.
  Future<void> _from10To11(Migrator m, Schema11 schema) async {
    final library = schema.partnerLibrary;
    await m.addColumn(library, library.whole);
    await customStatement('UPDATE partner_library SET whole = 1');
    await customStatement(
      "DELETE FROM sync_cursor WHERE stream LIKE 'partner/%'",
    );
  }

  /// Schema 12 keeps a video's frame rate; its videos go back to extraction to
  /// read it.
  Future<void> _from11To12(Migrator m, Schema12 schema) async {
    await m.addColumn(schema.localAsset, schema.localAsset.frameRate);
    await customStatement(
      "UPDATE local_asset SET extracted = NULL WHERE mime LIKE 'video/%'",
    );
  }

  /// Schema 13 reads panoramas and videos again, for their projections and
  /// stereo modes.
  Future<void> _from12To13(Migrator m, Schema13 schema) async {
    final asset = schema.localAsset;
    for (final column in [asset.projection, asset.crop, asset.stereo]) {
      await m.addColumn(asset, column);
    }
    await customStatement(
      'UPDATE local_asset SET extracted = NULL WHERE '
      "',' || facets || ',' LIKE '%,panorama,%' OR mime LIKE 'video/%'",
    );
  }

  /// Schema 14 files each MediaStore item under its device folder, keeps the
  /// default junk list out of the library (ADR-0210) and counts the
  /// timeline's items by day and folder.
  Future<void> _from13To14(Migrator m, Schema14 schema) async {
    await m.addColumn(schema.localAsset, schema.localAsset.folder);
    await m.createTable(schema.deviceFolder);
    await m.createTable(schema.deviceFolderMode);
    await customStatement(
      'INSERT INTO device_folder (volume, path, name) '
      "SELECT volume, path, MAX(IFNULL(bucket_name, '')) FROM local_asset "
      "WHERE source = 'mediastore' AND path IS NOT NULL GROUP BY volume, path",
    );
    for (final f in await customSelect(
      'SELECT id, path FROM device_folder',
    ).get()) {
      if (isJunk(f.read<String>('path'))) {
        await customStatement(
          'UPDATE device_folder SET excluded = 1 WHERE id = ?',
          [f.read<int>('id')],
        );
      }
    }
    await m.drop(schema.localAssetTimeline);
    await m.drop(schema.localAssetAdded);
    await m.drop(schema.timelineItem);
    await customStatement(
      'UPDATE local_asset SET folder = (SELECT id FROM device_folder f '
      'WHERE f.volume = local_asset.volume AND f.path = local_asset.path) '
      "WHERE source = 'mediastore' AND path IS NOT NULL",
    );
    for (final entity in [
      schema.localAssetTimeline,
      schema.localAssetAdded,
      schema.excludedFolder,
      schema.hiddenFolder,
      schema.timelineItem,
      schema.timelineDay,
    ]) {
      await m.create(entity);
    }
    await customStatement(
      'INSERT INTO timeline_day '
      'SELECT day, folder, COUNT(*) FROM timeline_item GROUP BY 1, 2',
    );
    for (final trigger in [
      schema.timelineDayInsert,
      schema.timelineDayDelete,
      schema.timelineDayUpdate,
      schema.timelineDayEmpty,
    ]) {
      await m.createTrigger(trigger);
    }
  }

  /// Schema 16 keeps a server video's frame rate and a sphere's heading, and
  /// the timeline says which items are spheres; panoramas and 360° videos go
  /// back to extraction for their headings and crops.
  Future<void> _from15To16(Migrator m, Schema16 schema) async {
    await m.addColumn(schema.asset, schema.asset.fps);
    await m.addColumn(schema.localAsset, schema.localAsset.heading);
    await m.drop(schema.timelineItem);
    await m.createView(schema.timelineItem);
    await customStatement(
      'UPDATE local_asset SET extracted = NULL WHERE projection IS NOT NULL',
    );
  }

  /// Schema 18 counts the timeline's items by quarter hour added and folder.
  Future<void> _from17To18(Migrator m, Schema18 schema) async {
    await m.createTable(schema.timelineAdded);
    await customStatement(
      'INSERT INTO timeline_added SELECT added / 900000, folder, COUNT(*) '
      'FROM timeline_item GROUP BY 1, 2',
    );
    for (final trigger in [
      schema.timelineAddedInsert,
      schema.timelineAddedDelete,
      schema.timelineAddedUpdate,
      schema.timelineAddedEmpty,
    ]) {
      await m.createTrigger(trigger);
    }
  }

  /// Schema 19 shows the timeline's facets, and reads the files that may be
  /// animated again, PhotoKit's whole library too, to find their animations.
  Future<void> _from18To19(Migrator m, Schema19 schema) async {
    await m.drop(schema.timelineItem);
    await m.createView(schema.timelineItem);
    const types = ['gif', 'webp', 'png', 'apng', 'avif'];
    const named = "lower(IFNULL(name, path)) LIKE '%.";
    await customStatement(
      'UPDATE local_asset SET extracted = NULL, facets = NULL '
      "WHERE source != 'photokit' AND (mime IN "
      "(${[for (final t in types) "'image/$t'"].join(', ')}) OR "
      "${[for (final t in types) "$named$t'"].join(' OR ')})",
    );
    await customStatement(
      "DELETE FROM volume_cursor WHERE source = 'photokit'",
    );
  }

  /// Schema 20 marks HDR items, so every file it read is read again.
  Future<void> _from19To20(Migrator m, Schema20 schema) =>
      customStatement('UPDATE local_asset SET extracted = NULL');

  /// Schema 21 makes the device folders a tree (ADR-0290): one own visibility
  /// each, the mode's list first, then the other's; a folder with neither
  /// keeps what the mode showed of it, whatever is above it. Each folder file
  /// is filed under its directory's device folder.
  Future<void> _from20To21(Migrator m, Schema21 schema) async {
    await m.drop(schema.hiddenFolder);
    await m.drop(schema.excludedFolder);
    final folder = schema.deviceFolder;
    await m.alterTable(
      TableMigration(
        folder,
        columnTransformer: {
          folder.visibility: const CustomExpression<String>(
            visibilityFromLists,
          ),
        },
        newColumns: [folder.visibility],
      ),
    );
    for (final entity in [
      schema.deviceFolderOwn,
      schema.excludedFolder,
      schema.hiddenFolder,
    ]) {
      await m.create(entity);
    }
    await customStatement(keepModeVisibility);
    String dir(String path) => "rtrim($path, replace($path, '/', ''))";
    await customStatement(
      'INSERT INTO device_folder (volume, path) '
      "SELECT DISTINCT volume, ${dir('path')} "
      "FROM local_asset WHERE source = 'folder' AND path IS NOT NULL",
    );
    await customStatement(
      'UPDATE local_asset SET folder = (SELECT id FROM device_folder f '
      'WHERE f.volume = local_asset.volume '
      "AND f.path = ${dir('local_asset.path')}) "
      "WHERE source = 'folder' AND path IS NOT NULL",
    );
  }

  /// Schema 22 keeps the ThumbHashes of the server's assets; the streams that
  /// bring assets sync again, from scratch, for them.
  Future<void> _from21To22(Migrator m, Schema22 schema) async {
    await m.addColumn(schema.asset, schema.asset.thumbhash);
    await customStatement(
      "DELETE FROM sync_cursor WHERE stream LIKE 'assets/%' "
      "OR stream LIKE 'album_items/%' OR stream LIKE 'partner/%'",
    );
  }

  /// Schema 23 finds the mutations waiting for a row, and keeps the device's
  /// clock (ADR-0265).
  Future<void> _from22To23(Migrator m, Schema23 schema) async {
    await m.createIndex(schema.outboxEntity);
    await m.createTable(schema.clock);
  }

  /// Schema 24 keeps Photolib's own state of device items, by row and by
  /// content (ADR-0245), and counts the hidden and archived apart.
  Future<void> _from23To24(Migrator m, Schema24 schema) async {
    final counts = [
      schema.timelineDayInsert,
      schema.timelineDayDelete,
      schema.timelineDayUpdate,
      schema.timelineAddedInsert,
      schema.timelineAddedDelete,
      schema.timelineAddedUpdate,
    ];
    for (final entity in [
      ...counts,
      schema.timelineDay,
      schema.timelineAdded,
      schema.timelineItem,
    ]) {
      await m.drop(entity);
    }
    final asset = schema.localAsset;
    for (final column in [
      asset.hidden,
      asset.archived,
      asset.bin,
      asset.fingerprint,
    ]) {
      await m.addColumn(asset, column);
    }
    await m.create(schema.timelineItem);
    await m.create(schema.timelineDay);
    await m.create(schema.timelineAdded);
    await customStatement(
      'INSERT INTO timeline_day SELECT day, folder, hidden + archived > 0, '
      'COUNT(*) FROM timeline_item GROUP BY 1, 2, 3',
    );
    await customStatement(
      'INSERT INTO timeline_added SELECT added / 900000, folder, '
      'hidden + archived > 0, COUNT(*) FROM timeline_item GROUP BY 1, 2, 3',
    );
    await m.createTable(schema.keptState);
    for (final trigger in [
      ...counts,
      schema.timelineDayEmpty,
      schema.timelineAddedEmpty,
      schema.localAssetKept,
      schema.localAssetFingerprint,
    ]) {
      await m.createTrigger(trigger);
    }
  }

  /// Schema 25 keeps where each upload is on the server and the failures in a
  /// row of each item, finds an item's copies by hash and logs backup runs
  /// (ADR-0226).
  Future<void> _from24To25(Migrator m, Schema25 schema) async {
    final state = schema.backupState;
    await m.addColumn(state, state.upload);
    await m.addColumn(state, state.attempts);
    await m.createIndex(schema.backupStateState);
    await m.createIndex(schema.localAssetHash);
    await m.createTable(schema.backupRun);
  }

  /// Schema 26 counts what on-device ML has read by folder and model, which
  /// Settings' indexing progress sums.
  Future<void> _from25To26(Migrator m, Schema26 schema) async {
    for (final entity in <DatabaseSchemaEntity>[
      schema.mlPhoto,
      schema.mlCounted,
      schema.mlCount,
      schema.mlCountInsert,
      schema.mlCountDelete,
      schema.mlCountUnset,
      schema.mlCountSet,
      schema.mlCountMlReplace,
      schema.mlCountMlInsert,
      schema.mlCountMlDelete,
      schema.mlCountMlUpdate,
    ]) {
      await m.create(entity);
    }
    await customStatement(
      'INSERT INTO ml_count SELECT folder, model, COUNT(*), SUM(failed) '
      'FROM ml_counted GROUP BY folder, model',
    );
  }

  /// Schema 28 keeps the text that on-device OCR read, and its folded form
  /// for the search (ADR-0388).
  Future<void> _from27To28(Migrator m, Schema28 schema) async {
    await m.addColumn(schema.localMl, schema.localMl.ocrText);
    await m.addColumn(schema.localMl, schema.localMl.ocrFolded);
  }

  /// Schema 27 shows the account's photos and videos beside the device's, one
  /// tile per photo (ADR-0267): device items' tiles and assets' flags are
  /// computed once, then kept by triggers, and the days and on-device ML's
  /// progress count tiles only.
  Future<void> _from26To27(Migrator m, Schema27 schema) async {
    await m.addColumn(schema.asset, schema.asset.onDevice);
    await m.addColumn(schema.localAsset, schema.localAsset.tile);
    final ml = <DatabaseSchemaEntity>[
      schema.mlPhoto,
      schema.mlCounted,
      schema.mlCountInsert,
      schema.mlCountDelete,
      schema.mlCountUnset,
      schema.mlCountSet,
      schema.mlCountMlReplace,
      schema.mlCountMlInsert,
      schema.mlCountMlDelete,
      schema.mlCountMlUpdate,
    ];
    for (final old in [
      schema.timelineItem,
      schema.localAssetTimeline,
      schema.localAssetAdded,
      schema.assetDeleted,
      schema.timelineDayInsert,
      schema.timelineDayDelete,
      schema.timelineDayUpdate,
      schema.timelineAddedInsert,
      schema.timelineAddedDelete,
      schema.timelineAddedUpdate,
      ...ml,
    ]) {
      await m.drop(old);
    }
    await m.createView(schema.linkedTile);
    await customStatement(
      'UPDATE local_asset SET tile = t.tile FROM linked_tile t '
      'WHERE t.id = local_asset.id',
    );
    await customStatement(
      'UPDATE asset SET on_device = 1 WHERE id IN (SELECT asset_id '
      "FROM local_asset WHERE state = 'present' AND trashed = 0)",
    );
    for (final created in [
      schema.timelineItem,
      schema.cloudItem,
      schema.localAssetTimeline,
      schema.localAssetAdded,
      schema.localAssetAsset,
      schema.assetTimeline,
      schema.assetAdded,
      schema.assetDeleted,
      schema.localAssetLinked,
      schema.localAssetRelinked,
      schema.localAssetUnlinked,
      schema.assetLinked,
      schema.assetChanged,
      schema.timelineDayInsert,
      schema.timelineDayDelete,
      schema.timelineDayUpdate,
      schema.timelineAddedInsert,
      schema.timelineAddedDelete,
      schema.timelineAddedUpdate,
      ...ml,
    ]) {
      await m.create(created);
    }
    await customStatement('DELETE FROM timeline_day');
    await customStatement(
      'INSERT INTO timeline_day SELECT day, folder, hidden + archived > 0, '
      'COUNT(*) FROM timeline_item GROUP BY 1, 2, 3',
    );
    await customStatement('DELETE FROM timeline_added');
    await customStatement(
      'INSERT INTO timeline_added SELECT added / 900000, folder, '
      'hidden + archived > 0, COUNT(*) FROM timeline_item GROUP BY 1, 2, 3',
    );
    await customStatement('DELETE FROM ml_count');
    await customStatement(
      'INSERT INTO ml_count SELECT folder, model, COUNT(*), SUM(failed) '
      'FROM ml_counted WHERE id IN (SELECT id FROM ml_photo WHERE tile < 2) '
      'GROUP BY folder, model',
    );
  }
}
