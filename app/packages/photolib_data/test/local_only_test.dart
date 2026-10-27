@TestOn('vm')
library;

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:photolib_data/photolib_data.dart';
import 'package:photolib_data/testing.dart';
import 'package:sqlite3/sqlite3.dart' show sqlite3;
import 'package:test/test.dart';

/// The schema of a future release, whose migration fails after damaging the
/// replica.
class _Broken extends Replica {
  _Broken(super.executor, {super.openBackup});

  @override
  int get schemaVersion => _current + 1;

  @override
  Future<void> migrate(Migrator m, int from, int to) async {
    await customStatement('DELETE FROM outbox');
    await customStatement('DROP TABLE local_asset');
    throw StateError('a bug in the migration to v$to');
  }
}

class _Fixed extends Replica {
  _Fixed(super.executor, {super.openBackup});

  @override
  int get schemaVersion => _current + 1;

  @override
  Future<void> migrate(Migrator m, int from, int to) =>
      customStatement('UPDATE outbox SET attempts = 9');
}

Uint8List _id(int n) => Uint8List(16)..[15] = n;

final int _current = Replica(NativeDatabase.memory()).schemaVersion;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late Directory dir;
  setUp(
    () async => dir = await Directory.systemTemp.createTemp('photolib-data-'),
  );
  tearDown(() => dir.delete(recursive: true));

  QueryExecutor file(String name) => NativeDatabase(File('${dir.path}/$name'));
  QueryExecutor openBackup(String suffix) => file('replica$suffix');

  Future<List<String>> rows(GeneratedDatabase db, String table) async => [
    for (final row
        in await db.customSelect('SELECT * FROM $table ORDER BY rowid').get())
      '${row.data.values.toList()}',
  ];

  group('a migration', () {
    late Map<String, List<String>> before;

    setUp(() async {
      final old = Replica(file('replica'));
      await old.batch((b) {
        b
          ..insert(
            old.localAsset,
            LocalAssetCompanion.insert(
              id: _id(1),
              source: 'mediastore',
              sourceId: '42',
              size: 7,
              mtime: 8,
            ),
          )
          ..insert(
            old.backupState,
            BackupStateCompanion.insert(
              localAssetId: _id(1),
              state: 'uploading',
              updatedAt: 9,
            ),
          )
          ..insert(
            old.outbox,
            OutboxCompanion.insert(
              mutationId: _id(2),
              entity: 'album',
              entityId: _id(3),
              mutation: Uint8List.fromList([1, 2]),
              createdAt: 10,
            ),
          )
          ..insert(
            old.extJournalCursor,
            ExtJournalCursorCompanion.insert(journal: 'share', merged: 3),
          )
          ..insert(
            old.syncCursor,
            SyncCursorCompanion.insert(
              stream: 'albums',
              cursor: Uint8List(2),
              updatedAt: 11,
            ),
          );
        for (final (n, txid) in [(4, null), (5, 77)]) {
          b.insert(
            old.album,
            AlbumCompanion.insert(
              id: _id(n),
              ownerId: _id(0),
              title: 'album $n',
              createdAt: n,
              txid: Value(txid),
            ),
          );
        }
      });
      before = {
        for (final table in [...deviceTables, 'album'])
          table: await rows(old, table),
      };
      await old.close();
    });

    test(
      'that fails rebuilds the replica and restores the local-only data from '
      'the backup',
      () async {
        final db = _Broken(file('replica'), openBackup: openBackup);
        addTearDown(db.close);
        for (final table in deviceTables) {
          expect(await rows(db, table), before[table], reason: table);
        }
        expect(await rows(db, 'album'), [
          before['album']!.first,
        ], reason: 'rows a server confirmed are synced again');
        expect(
          await rows(db, 'sync_cursor'),
          isEmpty,
          reason: 'so the replica syncs from scratch',
        );
        expect(
          (await db.customSelect('PRAGMA user_version').getSingle())
              .data
              .values
              .single,
          _current + 1,
        );
      },
    );

    test(
      'that fails restores the folder lists of an older schema as visibility',
      () async {
        // Schema 20 kept two lists (excluded, chosen) where schema 21 has one
        // own visibility; the restore at the current schema must map them.
        const alter = 'ALTER TABLE device_folder';
        const column = 'INTEGER NOT NULL DEFAULT 0';
        final old = sqlite3.open('${dir.path}/replica')
          ..execute('DROP VIEW hidden_folder')
          ..execute('DROP VIEW excluded_folder')
          ..execute('DROP INDEX device_folder_own')
          ..execute('$alter DROP COLUMN visibility')
          ..execute('$alter ADD COLUMN excluded $column')
          ..execute('$alter ADD COLUMN chosen $column')
          ..execute(
            'INSERT OR REPLACE INTO device_folder_mode (id) VALUES (0)',
          );
        for (final (path, excluded, chosen) in [
          ('DCIM/Camera/', 0, 1),
          ('Android/media/com.whatsapp/', 1, 0),
          ('Pictures/', 0, 0),
          ('Android/media/com.whatsapp/Media/', 0, 0),
          ('Both/', 1, 1),
        ]) {
          old.execute(
            'INSERT INTO device_folder (volume, path, excluded, chosen) '
            "VALUES ('v', ?, ?, ?)",
            [path, excluded, chosen],
          );
        }
        old.close();

        final db = _Broken(file('replica'), openBackup: openBackup);
        addTearDown(db.close);
        expect(await rows(db, 'device_folder'), [
          for (final (id, path, visibility) in [
            (1, 'DCIM/Camera/', 'shown'),
            (2, 'Android/media/com.whatsapp/', 'hidden'),
            (3, 'Pictures/', 'inherit'),
            // Neither list, below a hidden folder, shown before: still shown.
            (4, 'Android/media/com.whatsapp/Media/', 'shown'),
            (5, 'Both/', 'hidden'),
          ])
            '[$id, v, $path, , $visibility, 0]',
        ]);
      },
    );

    test(
      'whose restore fails too leaves the replica untouched at its old version',
      () async {
        final old = Replica(file('replica'));
        // A released schema whose outbox allowed what the current one forbids.
        await old.customStatement('DROP TABLE outbox');
        await old.customStatement(
          'CREATE TABLE outbox (seq INTEGER PRIMARY KEY, mutation_id BLOB)',
        );
        await old.customStatement('INSERT INTO outbox VALUES (1, NULL)');
        await old.close();

        final db = _Broken(file('replica'), openBackup: openBackup);
        await expectLater(
          db.customSelect('SELECT 1').get(),
          throwsA(isA<SqliteException>()),
        );
        await db.close();

        final after = Replica(file('replica'));
        addTearDown(after.close);
        expect(await rows(after, 'outbox'), ['[1, null]']);
        expect(await rows(after, 'album'), before['album']);
        expect(
          (await after.customSelect('PRAGMA user_version').getSingle())
              .data
              .values
              .single,
          _current,
        );
      },
    );

    test(
      'whose backup cannot be completed keeps none of it and changes nothing',
      () async {
        // A table the backup cannot create stands in for a full disk midway.
        sqlite3.open('${dir.path}/taken')
          ..execute('CREATE TABLE outbox (seq INTEGER)')
          ..close();
        final db = _Fixed(file('replica'), openBackup: (_) => file('taken'));
        await expectLater(
          db.customSelect('SELECT 1').get(),
          throwsA(isA<SqliteException>()),
        );
        await db.close();

        final taken = sqlite3.open('${dir.path}/taken');
        addTearDown(taken.close);
        expect(
          taken.select('SELECT name FROM sqlite_master').map((r) => r['name']),
          ['outbox'],
        );
        final after = Replica(file('replica'));
        addTearDown(after.close);
        expect(await rows(after, 'outbox'), before['outbox']);
        expect(await rows(after, 'album'), before['album']);
      },
    );

    test(
      'that fails skips local-only rows of a table the new schema dropped',
      () async {
        final old = Replica(file('replica'));
        await old.customStatement('CREATE TABLE dropped (txid INTEGER)');
        await old.customStatement('INSERT INTO dropped VALUES (NULL)');
        await old.close();

        final db = _Broken(file('replica'), openBackup: openBackup);
        addTearDown(db.close);
        expect(await rows(db, 'outbox'), before['outbox']);
      },
    );

    test('to an older schema is refused and changes nothing', () async {
      final newer = _Fixed(file('replica'), openBackup: openBackup);
      await newer.customSelect('SELECT 1').get();
      await newer.close();
      final backups = dir.listSync().length;

      final older = Replica(file('replica'), openBackup: openBackup);
      await expectLater(
        older.customSelect('SELECT 1').get(),
        throwsA(predicate((e) => '$e'.contains('newer than this app'))),
      );
      await older.close();
      final after = _Fixed(file('replica'));
      addTearDown(after.close);
      expect(await rows(after, 'album'), before['album']);
      expect(dir.listSync(), hasLength(backups), reason: 'no backup either');
    });

    test('copies the local-only data to a timestamped backup first', () async {
      final db = _Fixed(file('replica'), openBackup: openBackup);
      addTearDown(db.close);
      expect(await rows(db, 'album'), before['album']);
      expect((await rows(db, 'outbox')).single, contains(', 9, '));

      final backups = dir
          .listSync()
          .map((f) => f.uri.pathSegments.last)
          .where((n) => n.contains('.before-'));
      expect(
        backups.single,
        matches(
          RegExp('^replica\\.before-v${_current + 1}-\\d{8}T\\d{6}\\d*Z\$'),
        ),
      );
      final backup = Unmigrated(file(backups.single));
      addTearDown(backup.close);
      for (final table in deviceTables) {
        expect(await rows(backup, table), before[table], reason: table);
      }
      expect(await rows(backup, 'album'), [before['album']!.first]);
      expect(
        await backup
            .customSelect(
              "SELECT name FROM sqlite_master WHERE name = 'sync_cursor'",
            )
            .get(),
        isEmpty,
        reason: 'cursors are worthless without the synced rows',
      );
    });
  });
}
