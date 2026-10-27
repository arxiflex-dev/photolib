import 'dart:async';

import 'package:drift/drift.dart';

import 'package:photolib_data/src/replica.dart';

/// The device's own tables, which neither the server nor a cheap rescan gives back; with the synced rows no server has
/// confirmed yet (`txid IS NULL`) they are the local-only data, which a failed migration must not lose. Everything
/// else is rebuilt from the server. test/migration_test.dart fails on a table that is none of these.
const deviceTables = {
  'local_asset',
  'device_folder',
  'device_folder_mode',
  'kept_state',
  'media_source',
  'volume_cursor',
  'backup_state',
  'backup_run',
  'outbox',
  'clock',
  'ext_journal_cursor',
  'local_ml',
};

/// How many rows exist only on this device and in no backup: changes not yet
/// sent and synced rows no server confirmed (docs/21 §6).
Future<int> localOnlyCount(Replica db) async {
  var count = 0;
  for (final (name, _) in await _tables(db)) {
    final columns = await _columns(db, name);
    if (name != 'outbox' && !columns.contains('txid')) continue;
    final where = name == 'outbox' ? '' : ' WHERE txid IS NULL';
    final row = await db
        .customSelect('SELECT count(*) AS n FROM "$name"$where')
        .getSingle();
    count += row.read<int>('n');
  }
  return count;
}

/// Migrates [db] from [from] to [to] in one transaction, after copying its local-only data to a timestamped backup
/// database next to it. When the migration fails, rebuilds the replica at the current schema and restores
/// that data from the backup, again in one transaction (docs/15-reliability-migrations-ops.md §3). A replica newer than
/// the app is left alone.
Future<void> upgradeKeepingLocalOnly(
  Replica db,
  Migrator m,
  int from,
  int to,
) async {
  if (from > to) {
    throw StateError(
      'the replica is at schema $from, newer than this app\'s $to',
    );
  }
  final stamp = DateTime.now().toUtc().toIso8601String().replaceAll(
    RegExp(r'[-:.]'),
    '',
  );
  final backup = _Backup(db.openBackup!('.before-v$to-$stamp'));
  // Inside the backup's transaction drift would send the replica's queries to its connection, which waits for this
  // migration to end; they run in the migration's zone instead.
  final migration = Zone.current;
  try {
    // One transaction, so that a backup that exists is complete.
    await backup.transaction(() async {
      for (final (name, sql) in await migration.run(() => _tables(db))) {
        final columns = await migration.run(() => _columns(db, name));
        final device = deviceTables.contains(name);
        if (!device && !columns.contains('txid')) continue;
        await backup.customStatement(sql);
        await _copy(
          db,
          backup,
          name,
          columns,
          where: device ? null : 'txid IS NULL',
          readIn: migration,
        );
      }
    });
    try {
      await db.transaction(() => db.migrate(m, from, to));
    } catch (_) {
      await db.transaction(() async {
        for (final view
            in await db
                .customSelect(
                  "SELECT name FROM sqlite_master WHERE type = 'view'",
                )
                .get()) {
          await db.customStatement('DROP VIEW "${view.read<String>('name')}"');
        }
        for (final (name, _) in await _tables(db)) {
          await db.customStatement('DROP TABLE "$name"');
        }
        await m.createAll();
        var foldedLists = false;
        for (final (name, _) in await _tables(backup)) {
          final current = await _columns(db, name);
          final saved = await _columns(backup, name);
          final kept = [
            for (final c in saved)
              if (current.contains(c)) c,
          ];
          // Schema 21 made the two folder lists one column: map them,
          // not leave the default.
          final lists =
              name == 'device_folder' &&
              !saved.contains('visibility') &&
              saved.contains('excluded') &&
              saved.contains('chosen');
          if (kept.isNotEmpty) {
            await _copy(
              backup,
              db,
              name,
              kept,
              computed: lists ? {'visibility': visibilityFromLists} : const {},
            );
          }
          foldedLists |= lists;
        }
        // Needs every folder and the mode restored.
        if (foldedLists) await db.customStatement(keepModeVisibility);
      });
    }
  } finally {
    await backup.close();
  }
}

Future<List<(String, String)>> _tables(GeneratedDatabase db) => db
    .customSelect(
      "SELECT name, sql FROM sqlite_master WHERE type = 'table' AND name NOT LIKE 'sqlite_%'",
    )
    .map((row) => (row.read<String>('name'), row.read<String>('sql')))
    .get();

Future<List<String>> _columns(GeneratedDatabase db, String table) => db
    .customSelect(
      'SELECT name FROM pragma_table_info(?)',
      variables: [Variable(table)],
    )
    .map((row) => row.read<String>('name'))
    .get();

Future<void> _copy(
  GeneratedDatabase from,
  GeneratedDatabase to,
  String table,
  List<String> columns, {
  String? where,
  Zone? readIn,
  Map<String, String> computed = const {},
}) async {
  final all = [...columns, ...computed.keys];
  final names = all.map((c) => '"$c"').join(', ');
  final select = [
    ...columns.map((c) => '"$c"'),
    for (final MapEntry(:key, :value) in computed.entries) '$value AS "$key"',
  ].join(', ');
  final rows = await (readIn ?? Zone.current).run(
    () => from
        .customSelect(
          'SELECT $select FROM "$table"${where == null ? '' : ' WHERE $where'}',
        )
        .get(),
  );
  final insert =
      'INSERT INTO "$table" ($names) VALUES (${List.filled(all.length, '?').join(', ')})';
  await to.batch((batch) {
    for (final row in rows) {
      batch.customStatement(insert, [for (final c in all) row.data[c]]);
    }
  });
}

/// The backup database: tables copied with the schema they had before the migration.
class _Backup extends GeneratedDatabase {
  _Backup(super.executor);

  @override
  Iterable<TableInfo<Table, Object?>> get allTables => const [];

  @override
  int get schemaVersion => 1;
}
