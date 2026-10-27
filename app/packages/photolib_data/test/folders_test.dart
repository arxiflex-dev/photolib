// Watches run 10x slower under load; a timed-out test runs into the next one.
@Timeout(Duration(minutes: 3))
@TestOn('vm')
library;

import 'dart:io';

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:photolib_data/photolib_data.dart';
import 'package:photolib_data/src/file_system.dart';
import 'package:photolib_data/testing.dart';
import 'package:photolib_log/photolib_log.dart';
import 'package:test/test.dart';

import 'kernel.dart';

void main() {
  final kernel = testKernel();
  late Directory tmp;
  late String root;
  late Replica db;
  late FolderIndexer indexer;
  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('photolib-folders-');
    root = '${tmp.path}/Photos';
    db = Replica(NativeDatabase.memory());
    indexer = FolderIndexer(db);
  });
  tearDown(() async {
    await db.close();
    await tmp.delete(recursive: true);
  });

  void write(String path, [String bytes = 'x']) => (File(
    '$root/$path',
  )..createSync(recursive: true)).writeAsStringSync(bytes);

  /// Every folder item of [of], by default the test's replica, by path.
  Future<List<LocalAssetData>> byPath([Replica? of]) {
    final from = of ?? db;
    return (from.select(
      from.localAsset,
    )..orderBy([(a) => OrderingTerm(expression: a.path)])).get();
  }

  /// path → state of every folder item of [of], by default the test's
  /// replica, but for those the ignore rules exclude (`hidden` 2).
  Future<Map<String, String>> items([Replica? of]) async => {
    for (final a in await byPath(of))
      if (a.hidden != 2) a.path!: a.state,
  };

  /// Waits until the items are [expected], which a watcher's scan makes them
  /// within seconds: 200 looks 50 ms apart, counted, not timed, as a loaded
  /// machine that stalls this process for seconds would use up a deadline.
  Future<void> expectItems(Map<String, String> expected, [Replica? of]) async {
    for (var look = 0; look < 200; look++) {
      if ((await items(of)).toString() == expected.toString()) return;
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
    expect(await items(of), expected);
  }

  /// The query plan of the last select [query] runs.
  Future<List<Object?>> plan(Future<void> Function(Replica) query) async {
    final selects = _Selects();
    final traced = Replica(NativeDatabase.memory().interceptWith(selects));
    addTearDown(traced.close);
    await query(traced);
    final (sql, args) = selects.last;
    return [
      for (final row in await traced.executor.runSelect(
        'EXPLAIN QUERY PLAN $sql',
        args,
      ))
        row['detail'],
    ];
  }

  Future<Map<String, String>> ids() async => {
    for (final a in await db.select(db.localAsset).get()) a.path!: a.sourceId,
  };

  /// Links the item at [path] to an asset in an album and among the
  /// favourites, as the metadata pipeline (M1-08) and the user do.
  Future<void> organise(String path) async {
    final asset = Uint8List(16)..[15] = 9;
    await (db.update(db.localAsset)..where((a) => a.path.equals(path))).write(
      LocalAssetCompanion(assetId: Value(asset)),
    );
    await db
        .into(db.albumItem)
        .insert(
          AlbumItemCompanion.insert(
            id: Uint8List(16),
            albumId: Uint8List(16)..[0] = 1,
            kind: 'asset',
            assetId: Value(asset),
            sortKey: 'a',
          ),
        );
    await db
        .into(db.assetUserState)
        .insert(
          AssetUserStateCompanion.insert(
            assetId: asset,
            favorite: const Value(1),
          ),
        );
  }

  /// The present items that are in an album and among the favourites.
  Future<List<String>> organised() async => [
    for (final row in await db.customSelect('''
      SELECT path FROM local_asset
      JOIN album_item USING (asset_id) JOIN asset_user_state USING (asset_id)
      WHERE state = 'present' AND asset_user_state.favorite = 1''').get())
      row.read<String>('path'),
  ];

  test('a folder added is scanned recursively for media files', () async {
    write('a.jpg');
    write('2024/May/b.HEIC');
    write('2024/notes.txt');
    expect(await addFolder(db, root), isTrue);
    final before = DateTime.now().millisecondsSinceEpoch;
    await indexer.scan(root);
    expect(await items(), {'2024/May/b.HEIC': 'present', 'a.jpg': 'present'});
    for (final a in await db.select(db.localAsset).get()) {
      expect(a.added, uuidTime(a.id), reason: 'added when first seen');
      expect(a.added, inInclusiveRange(before, before + 60000));
    }
  });

  test(
    'a folder is scanning, counting what it found, until a full scan ends',
    () async {
      write('a/x.jpg');
      write('b/y.jpg');
      write('b/z.jpg');
      Future<String> summary() async => [
        for (final f in await db.folderSummary().get())
          '${f.root.split('/').last} ${f.state} ${f.items}',
      ].join(', ');
      await addFolder(db, root);
      await addFolder(db, '${tmp.path}/Other');
      expect(await summary(), 'Other scanning 0, Photos scanning 0');

      late Future<String> halfway;
      await indexer.scan(
        root,
        entering: (d) => d == 'b' ? halfway = summary() : null,
      );
      expect(await halfway, 'Other scanning 0, Photos scanning 1');
      expect(await summary(), 'Other scanning 0, Photos online 3');

      File('$root/b/z.jpg').deleteSync();
      await indexer.scan(root, dir: 'b', recursive: false);
      expect(await summary(), 'Other scanning 0, Photos online 2');

      Directory(root).renameSync('${tmp.path}/away');
      await indexer.scan(root);
      await indexer.scan('${tmp.path}/Other');
      expect(await summary(), 'Other offline 0, Photos offline 2');
    },
  );

  test("the summary counts a folder's items off an index, never reading a "
      'row: 1.7 s at a million of them', () async {
    expect(
      await plan((db) => db.folderSummary().get()),
      contains('SEARCH a USING COVERING INDEX local_asset_root (volume=?)'),
    );
  });

  test(
    'renaming a folder keeps item identity, albums and favourites',
    () async {
      write('2024/May/a.jpg', 'a');
      write('2024/May/b.jpg', 'bb');
      await addFolder(db, root);
      await indexer.scan(root);
      await organise('2024/May/a.jpg');
      final before = await ids();

      Directory('$root/2024/May').renameSync('$root/2024/Holiday');
      await indexer.scan(root);

      expect(await items(), {
        '2024/Holiday/a.jpg': 'present',
        '2024/Holiday/b.jpg': 'present',
      });
      expect(await ids(), {
        '2024/Holiday/a.jpg': before['2024/May/a.jpg'],
        '2024/Holiday/b.jpg': before['2024/May/b.jpg'],
      });
      expect(await organised(), ['2024/Holiday/a.jpg']);
    },
  );

  test(
    'unplugging a drive marks its items offline, never removes them',
    () async {
      write('a.jpg');
      write('2024/b.jpg');
      await addFolder(db, root);
      await indexer.scan(root);
      await organise('a.jpg');
      final before = await ids();
      Future<String> folder() async =>
          (await db.select(db.mediaSource).getSingle()).state;

      Directory(root).renameSync('${tmp.path}/away');
      await indexer.scan(root);
      expect(await items(), {'2024/b.jpg': 'offline', 'a.jpg': 'offline'});
      expect(await folder(), 'offline');

      // The mount point a drive leaves behind is an empty directory.
      Directory(root).createSync();
      await indexer.scan(root);
      expect(await items(), {'2024/b.jpg': 'offline', 'a.jpg': 'offline'});

      Directory(root).deleteSync();
      Directory('${tmp.path}/away').renameSync(root);
      await indexer.scan(root);
      expect(await items(), {'2024/b.jpg': 'present', 'a.jpg': 'present'});
      expect(await ids(), before);
      expect(await organised(), ['a.jpg']);
      expect(await folder(), 'online');
    },
  );

  test('a file moved to another directory keeps its identity', () async {
    write('a/x.jpg');
    write('z/y.jpg', 'yy');
    await addFolder(db, root);
    await indexer.scan(root);
    final before = await ids();

    File('$root/a/x.jpg').renameSync('$root/z/x.jpg');
    File('$root/z/y.jpg').renameSync('$root/a/y.jpg');
    await indexer.scan(root);

    expect(await items(), {'a/y.jpg': 'present', 'z/x.jpg': 'present'});
    expect(await ids(), {
      'a/y.jpg': before['z/y.jpg'],
      'z/x.jpg': before['a/x.jpg'],
    });
  });

  test('a file deleted is marked missing, never removed', () async {
    write('a.jpg');
    write('d/b.jpg');
    await addFolder(db, root);
    await indexer.scan(root);

    File('$root/a.jpg').deleteSync();
    Directory('$root/d').deleteSync(recursive: true);
    write('c.jpg');
    await indexer.scan(root);

    expect(await items(), {
      'a.jpg': 'missing',
      'c.jpg': 'present',
      'd/b.jpg': 'missing',
    });
  });

  test('a file saved over keeps its identity and loses its hash', () async {
    write('a.jpg', 'a');
    write('b.jpg', 'b');
    await addFolder(db, root);
    await indexer.scan(root);
    await db
        .update(db.localAsset)
        .write(LocalAssetCompanion(contentHash: Value(Uint8List(32))));
    final before = await ids();

    write('a.jpg', 'edited in place');
    // An editor that writes a new file and renames it over the old one.
    File('$root/b.tmp').writeAsStringSync('saved anew');
    File('$root/b.tmp').renameSync('$root/b.jpg');
    await indexer.scan(root);

    expect(await ids(), before);
    final rows = await byPath();
    expect(
      [for (final r in rows) (r.size, r.contentHash)],
      [(15, null), (10, null)],
    );
  });

  test(
    'a file saved over is extracted and hashed again, an unchanged one not',
    () async {
      write('a.jpg', 'a');
      write('b.jpg', 'b');
      await addFolder(db, root);
      await indexer.scan(root);
      await db
          .update(db.localAsset)
          .write(
            LocalAssetCompanion(
              extracted: const Value(1),
              width: const Value(640),
              orientation: const Value(90),
              thumbhash: Value(Uint8List(5)),
              fingerprint: Value(Uint8List(32)),
            ),
          );

      write('a.jpg', 'edited in place');
      await indexer.scan(root);

      final rows = await byPath();
      expect(
        [
          for (final r in rows)
            (r.extracted, r.width, r.orientation, r.thumbhash?.length),
        ],
        [(null, null, null, null), (1, 640, 90, 5)],
      );
      expect([for (final r in rows) r.fingerprint?.length], [null, 32]);
    },
  );

  test('a hard link is a second item; a symlink is not followed', () async {
    write('a.jpg');
    Directory('${tmp.path}/elsewhere').createSync();
    File('${tmp.path}/elsewhere/c.jpg').writeAsStringSync('c');
    Link('$root/elsewhere').createSync('${tmp.path}/elsewhere');
    Link('$root/c.jpg').createSync('${tmp.path}/elsewhere/c.jpg');
    Process.runSync('ln', ['$root/a.jpg', '$root/b.jpg']);
    await addFolder(db, root);
    await indexer.scan(root);

    expect(await items(), {'a.jpg': 'present', 'b.jpg': 'present'});
  }, testOn: 'posix');

  test('a folder is added once, never inside or around another', () async {
    expect(await addFolder(db, '/media/photos/'), isTrue);
    expect(await addFolder(db, '/media/photos'), isFalse);
    expect(await addFolder(db, '/media/photos/2024'), isFalse);
    expect(await addFolder(db, '/media'), isFalse);
    expect(await addFolder(db, '/media/photos2'), isTrue);
    expect(await addFolder(db, r'D:\'), isTrue);
    expect(await addFolder(db, r'D:\Pictures'), isFalse);
    expect(await addFolder(db, r'C:\Users\me\Pictures\\'), isTrue);
    expect(
      [for (final s in await watchFolders(db).first) s.root],
      ['/media/photos', '/media/photos2', r'C:\Users\me\Pictures', r'D:\'],
    );
  });

  test("a folder's timeline: its present items, newest first, a page at a "
      'time', () async {
    await addFolder(db, '/p');
    var n = 0;
    for (final (volume, taken, state) in [
      ('/p', '2024-05-01T10:00:00', 'present'),
      ('/p', '2024-05-03T10:00:00', 'present'),
      ('/q', '2024-05-04T10:00:00', 'present'),
      ('/p', '2024-05-02T10:00:00', 'missing'),
      ('/p', '2024-05-02T09:00:00', 'present'),
    ]) {
      n++;
      await db
          .into(db.localAsset)
          .insert(
            LocalAssetCompanion.insert(
              id: Uint8List(16)..[15] = n,
              source: 'folder',
              volume: Value(volume),
              sourceId: '$n',
              path: Value('$n.jpg'),
              size: 1,
              mtime: 0,
              takenLocal: Value(taken),
              state: Value(state),
            ),
          );
    }
    expect(
      [for (final i in await folderTimeline(db, '/p')) i.path],
      ['2.jpg', '5.jpg', '1.jpg'],
    );
    final first = await folderTimeline(db, '/p', limit: 1);
    expect(
      [
        for (final i in await folderTimeline(db, '/p', after: first.last))
          i.path,
      ],
      ['5.jpg', '1.jpg'],
    );
  });

  test("a page of a folder's timeline walks the timeline index from the "
      'last, never sorting the folder', () async {
    expect(await plan((db) => folderTimeline(db, '/p', limit: 500)), [
      startsWith('SEARCH local_asset USING INDEX local_asset_timeline ('),
    ]);
  });

  test('the present folder items without a ThumbHash, newest first, a page '
      'after another, however many get theirs in between', () async {
    await addFolder(db, '/p');
    for (final (n, taken, source, hash, state) in [
      (1, '2024-05-01T10:00:00', 'folder', false, 'present'),
      (2, '2024-05-03T10:00:00', 'folder', false, 'present'),
      (3, '2024-05-03T10:00:00', 'folder', false, 'present'),
      (4, '2024-05-04T10:00:00', 'folder', true, 'present'),
      (5, '2024-05-05T10:00:00', 'mediastore', false, 'present'),
      (6, '2024-05-06T10:00:00', 'folder', false, 'missing'),
      (7, '2024-04-30T10:00:00', 'folder', false, 'present'),
    ]) {
      await db
          .into(db.localAsset)
          .insert(
            LocalAssetCompanion.insert(
              id: Uint8List(16)..[15] = n,
              source: source,
              volume: const Value('/p'),
              sourceId: '$n',
              path: Value('$n.jpg'),
              size: 1,
              mtime: 0,
              takenLocal: Value(taken),
              state: Value(state),
              thumbhash: Value(hash ? Uint8List(5) : null),
            ),
          );
    }
    final first = await withoutThumbHash(db, limit: 2);
    expect([for (final i in first) i.path], ['3.jpg', '2.jpg']);
    await saveThumbHashes(db, {for (final i in first) i.id: Uint8List(5)});
    expect(
      [for (final i in await withoutThumbHash(db, after: first.last)) i.path],
      ['1.jpg', '7.jpg'],
    );
  });

  test('a page of items without a ThumbHash walks the timeline index from '
      'the last, never sorting the folder', () async {
    expect(await plan(withoutThumbHash), [
      startsWith('SEARCH local_asset USING INDEX local_asset_timeline ('),
    ]);
  });

  test('removing a folder forgets its items and keeps its files', () async {
    write('a.jpg');
    write('2024/c.mp4', 'cc');
    final other = '${tmp.path}/Other';
    File('$other/b.jpg').createSync(recursive: true);
    await addFolder(db, root);
    await addFolder(db, other);
    await indexer.scan(root);
    await indexer.scan(other);
    final a = await db.select(db.localAsset).get();
    await db
        .into(db.backupState)
        .insert(
          BackupStateCompanion.insert(
            localAssetId: a.first.id,
            state: 'uploading',
            updatedAt: 1,
          ),
        );

    Map<String, String> files() => {
      for (final f in tmp.listSync(recursive: true).whereType<File>())
        f.path: '${f.readAsStringSync()} ${f.lastModifiedSync()}',
    };
    final before = files();

    await removeFolder(db, root);

    expect(await items(), {'b.jpg': 'present'});
    expect(await db.select(db.backupState).get(), isEmpty);
    expect(files(), before);
    expect(before, hasLength(3));
    expect([for (final s in await watchFolders(db).first) s.root], [other]);
  });

  test('a scan skips what the ignore rules name', () async {
    write('a.jpg');
    write('@eaDir/a.jpg/SYNOPHOTO_THUMB_XL.jpg');
    write('drafts/b.jpg');
    write('.photolibignore', 'drafts/\n');
    write('2024/c.jpg');
    write('2024/keep.jpg');
    write('2024/.photolibignore', '*.jpg\n!keep.jpg\n');
    await addFolder(db, root);
    await indexer.scan(root);
    expect(await items(), {'2024/keep.jpg': 'present', 'a.jpg': 'present'});

    // A scan of one directory reads the rules above it too.
    write('2024/.photolibignore', '');
    write('.photolibignore', 'drafts/\nkeep.jpg\n');
    await indexer.scan(root, dir: '2024');
    expect(await items(), {'2024/c.jpg': 'present', 'a.jpg': 'present'});
  });

  /// Indexes `a.jpg` and `2024/drafts/b.jpg` under a rule `DRAFTS/`.
  Future<void> scanDrafts() async {
    write('2024/drafts/b.jpg');
    write('2024/.photolibignore', 'DRAFTS/\n');
    write('a.jpg');
    await addFolder(db, root);
    await indexer.scan(root);
  }

  test('a scan logs what it saw, indexed and skipped, and why', () async {
    write('a.jpg');
    write('b.jpg');
    write('notes.txt');
    write('drafts/c.jpg');
    write('.photolibignore', 'drafts/\n');
    await addFolder(db, root);
    final heard = <LogRecord>[];
    addTearDown(Log.records.listen(heard.add).cancel);
    await indexer.scan(root);
    File('$root/b.jpg').deleteSync();
    await indexer.scan(root);
    final [first, second] = [
      for (final r in heard)
        if (r.message == 'scanned') r,
    ];
    expect(first.logger, 'photolib.index');
    expect(first.fields, containsPair('root', root));
    expect(first.fields, containsPair('directories', 2));
    expect(first.fields, containsPair('seen', 6));
    expect(first.fields, containsPair('indexed', 3));
    expect(first.fields['skipped'], {'excluded': 1, 'not media': 2});
    expect(second.fields, containsPair('indexed', 0));
    expect(second.fields, containsPair('missing', 1));
  });

  test('ignore rules match names in any case where the volume does', () async {
    await scanDrafts();
    expect(await items(), {'2024/drafts/b.jpg': 'present', 'a.jpg': 'present'});

    // A name of the root in another case that is the same file, as this hard
    // link is, shows a case-insensitive volume.
    Process.runSync('ln', ['$root/a.jpg', '$root/A.JPG']);
    await indexer.scan(root);
    expect(await items(), {'A.JPG': 'present', 'a.jpg': 'present'});
  }, testOn: 'linux');
  test(
    'on a case-insensitive volume, ignore rules match names in any case',
    () async {
      final volume = Directory(
        Platform.environment['TEST_CASEFOLD_DIR']!,
      ).createTempSync('photolib-');
      addTearDown(() => volume.deleteSync(recursive: true));
      root = '${volume.path}/Photos';
      await scanDrafts();
      expect(await items(), {'a.jpg': 'present'});
    },
    skip: Platform.environment['TEST_CASEFOLD_DIR'] == null
        ? 'needs TEST_CASEFOLD_DIR, a directory on a case-insensitive volume'
        : false,
  );
  test(
    'a full scan that stops resumes after the last directory it finished',
    () async {
      for (final d in ['a', 'b', 'b/x', 'c']) {
        write('$d/1.jpg');
      }
      await addFolder(db, root);
      Future<String?> checkpoint() async =>
          (await db.select(db.mediaSource).getSingle()).checkpoint;
      // The app quits while the scan is in c.
      await db.customStatement(
        "CREATE TRIGGER quit BEFORE INSERT ON local_asset WHEN NEW.path LIKE 'c/%' "
        "BEGIN SELECT RAISE(ABORT, 'quit'); END",
      );
      await expectLater(indexer.scan(root), throwsA(anything));
      expect(await checkpoint(), 'b/x');
      await db.customStatement('DROP TRIGGER quit');

      for (final d in ['', 'a', 'b', 'b/x', 'b/y', 'c']) {
        write('$d/2.jpg');
      }
      await indexer.scan(root);
      expect((await items()).keys, [
        'a/1.jpg',
        'b/1.jpg',
        'b/x/1.jpg',
        'b/y/2.jpg',
        'c/1.jpg',
        'c/2.jpg',
      ]);
      expect(await checkpoint(), isNull);
    },
  );
  test(
    'a drive that goes during a full scan is scanned whole when back',
    () async {
      write('a/1.jpg');
      write('b/1.jpg');
      await addFolder(db, root);
      final away = '${tmp.path}/away';
      expect(
        await indexer.scan(
          root,
          entering: (d) => d == 'b' ? Directory(root).renameSync(away) : null,
        ),
        isFalse,
      );
      expect(await items(), {'a/1.jpg': 'offline'});

      Directory(away).renameSync(root);
      await indexer.scan(root);
      expect(await items(), {'a/1.jpg': 'present', 'b/1.jpg': 'present'});
    },
  );
  test('a file id survives a rename, not a copy', () {
    write('a.jpg', 'abc');
    final info = statFile('$root/a.jpg')!;
    final stat = File('$root/a.jpg').statSync();
    expect(info.size, 3);
    expect(info.mtime, stat.modified.millisecondsSinceEpoch);
    File('$root/a.jpg').renameSync('$root/b.jpg');
    expect(statFile('$root/b.jpg'), info);
    File('$root/b.jpg').copySync('$root/c.jpg');
    expect(statFile('$root/c.jpg')!.id, isNot(info.id));
    expect(statFile('$root/a.jpg'), isNull);
  });

  group('watched', () {
    Future<FolderWatcher> watch({
      Duration poll = const Duration(hours: 1),
      int? watchLimit,
    }) async {
      await addFolder(db, root);
      final watcher = FolderWatcher(
        indexer,
        root,
        poll: poll,
        watchLimit: watchLimit,
      );
      addTearDown(watcher.stop);
      return watcher;
    }

    test('a watched folder follows its events at any depth', () async {
      write('a/b/x.jpg');
      await watch();
      await expectItems({'a/b/x.jpg': 'present'});
      final id = (await db.select(db.localAsset).getSingle()).id;

      write('a/b/y.jpg');
      Directory('$root/n/m').createSync(recursive: true);
      write('n/m/z.jpg');
      await expectItems({
        'a/b/x.jpg': 'present',
        'a/b/y.jpg': 'present',
        'n/m/z.jpg': 'present',
      });

      Directory('$root/a').renameSync('$root/c');
      write('c/b/w.jpg');
      File('$root/n/m/z.jpg').deleteSync();
      await expectItems({
        'c/b/w.jpg': 'present',
        'c/b/x.jpg': 'present',
        'c/b/y.jpg': 'present',
        'n/m/z.jpg': 'missing',
      });
      final x = db.select(db.localAsset)
        ..where((a) => a.path.equals('c/b/x.jpg'));
      expect((await x.getSingle()).id, id);
    });

    test(
      'a folder with more directories than it may watch is polled',
      () async {
        write('a/x.jpg');
        await watch(poll: const Duration(milliseconds: 100), watchLimit: 0);
        await expectItems({'a/x.jpg': 'present'});
        write('a/y.jpg');
        await expectItems({'a/x.jpg': 'present', 'a/y.jpg': 'present'});
      },
    );

    test('a drive that goes and comes back is followed', () async {
      write('x.jpg');
      await watch(poll: const Duration(milliseconds: 100));
      await expectItems({'x.jpg': 'present'});

      Directory(root).renameSync('${tmp.path}/away');
      await expectItems({'x.jpg': 'offline'});

      Directory('${tmp.path}/away').renameSync(root);
      await expectItems({'x.jpg': 'present'});
      write('y.jpg');
      await expectItems({'x.jpg': 'present', 'y.jpg': 'present'});
    });

    test('the data isolate watches each folder any client adds, and logs '
        'to the isolate that opened it', () async {
      final heard = <LogRecord>[];
      addTearDown(Log.records.listen(heard.add).cancel);
      final vault = Vault(
        location: '${tmp.path}/store',
        keystore: MemoryKeystore(),
        files: storeFiles('${tmp.path}/store'),
        keyring: kernel.keyring,
      );
      await vault.unlock();
      addTearDown(vault.lock);
      final app = await vault.openReplica();
      write('x.jpg');
      await addFolder(app, root);
      await expectItems({'x.jpg': 'present'}, app);
      write('y.jpg');
      await expectItems({'x.jpg': 'present', 'y.jpg': 'present'}, app);

      await removeFolder(app, root);
      write('z.jpg');
      await Future<void>.delayed(const Duration(seconds: 1));
      expect(await items(app), isEmpty);
      await expectLater(
        Stream.periodic(
          const Duration(milliseconds: 50),
          (_) => [
            for (final r in heard)
              if (r.message == 'scanned') r.fields['root'],
          ],
        ).timeout(const Duration(minutes: 1)),
        emitsThrough(contains(root)),
      );
    });

    test('a polled file dated 2100 is followed, never deleted', () async {
      write('x.jpg');
      write('y.jpg');
      File('$root/x.jpg').setLastModifiedSync(DateTime.utc(2100));
      await watch(poll: const Duration(milliseconds: 100), watchLimit: 0);
      await expectItems({'x.jpg': 'present', 'y.jpg': 'present'});
      final x = db.select(db.localAsset)..where((a) => a.path.equals('x.jpg'));
      expect(
        (await x.getSingle()).mtime,
        DateTime.utc(2100).millisecondsSinceEpoch,
      );
      File('$root/x.jpg').deleteSync();
      await expectItems({'x.jpg': 'missing', 'y.jpg': 'present'});
    });

    test('a scan that fails is retried at the next poll', () async {
      await db.customStatement(
        'CREATE TRIGGER full BEFORE INSERT ON local_asset '
        "BEGIN SELECT RAISE(ABORT, 'disk full'); END",
      );
      write('x.jpg');
      await watch(poll: const Duration(milliseconds: 100));
      await Future<void>.delayed(const Duration(milliseconds: 500));
      expect(await items(), isEmpty);
      await db.customStatement('DROP TRIGGER full');
      await expectItems({'x.jpg': 'present'});
    });

    test('a network share is found by its mount', () {
      final mounts = [
        '/dev/sda1 / ext4 rw 0 0',
        '//nas/photos /mnt/nas cifs rw 0 0',
        '/dev/sdb1 /mnt/nas/usb ext4 rw 0 0',
        r'nas:/export /media/my\040nfs nfs4 rw 0 0',
      ].join('\n');
      expect(networkMount(mounts, '/home/me/Pictures'), isFalse);
      expect(networkMount(mounts, '/mnt/nas'), isTrue);
      expect(networkMount(mounts, '/mnt/nas/2024'), isTrue);
      expect(networkMount(mounts, '/mnt/nas/usb/a'), isFalse);
      expect(networkMount(mounts, '/mnt/nasty'), isFalse);
      expect(networkMount(mounts, '/media/my nfs/a'), isTrue);
      expect(isNetworkShare(tmp.path), isFalse);
    });
  }, testOn: 'linux');
}

class _Selects extends QueryInterceptor {
  late (String, List<Object?>) last;

  @override
  Future<List<Map<String, Object?>>> runSelect(
    QueryExecutor executor,
    String statement,
    List<Object?> args,
  ) {
    last = (statement, args);
    return executor.runSelect(statement, args);
  }
}
