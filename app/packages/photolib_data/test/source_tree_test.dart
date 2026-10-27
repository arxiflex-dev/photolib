@TestOn('vm')
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:photolib_data/photolib_data.dart';
import 'package:photolib_data/src/file_system.dart';
import 'package:photolib_data/testing.dart';
import 'package:test/test.dart';

import 'drift/replica/generated/schema.dart';

Uint8List _id(int n) => Uint8List(16)..[15] = n;

void main() {
  late Replica db;
  setUp(() => db = Replica(NativeDatabase.memory()));
  tearDown(() => db.close());

  /// Every node of the tree, depth first, by its path.
  Future<Map<String, SourceNode>> tree() async => {
    for (final n in flatten(await sourceTree(db))) '${n.volume}:${n.key}': n,
  };

  test('effective visibility is the nearest own value at or above a node, '
      "else the root's: for every combination over four levels, in SQL and "
      'in the tree', () async {
    const paths = ['a/', 'a/b/', 'a/b/c/', 'a/b/c/d/'];
    for (final path in paths) {
      await db.customStatement(
        "INSERT INTO device_folder (volume, path) VALUES ('v', ?)",
        [path],
      );
    }
    const values = SourceVisibility.values;
    for (final rootShown in [true, false]) {
      await setOnlyChosen(db, on: !rootShown);
      for (var combination = 0; combination < 81; combination++) {
        final own = [
          for (var level = 0, c = combination; level < 4; level++, c ~/= 3)
            values[c % 3],
        ];
        for (final (level, path) in paths.indexed) {
          await setVisibility(db, 'v', path, own[level]);
        }
        var shown = rootShown;
        final expected = [
          for (final v in own)
            shown = switch (v) {
              SourceVisibility.inherit => shown,
              final v => v == SourceVisibility.shown,
            },
        ];
        final hidden = await excludedFolders(db);
        final nodes = await tree();
        final reason = 'root shown $rootShown, own $own';
        expect(
          [for (final p in paths) !hidden.contains(nodes['v:$p']!.id)],
          expected,
          reason: reason,
        );
        expect(
          [for (final p in paths) nodes['v:$p']!.shown],
          expected,
          reason: reason,
        );
        expect(
          [for (final p in paths) nodes['v:$p']!.visibility],
          own,
          reason: reason,
        );
        expect(
          [for (final p in paths) nodes['v:$p']!.partly],
          [
            for (final (i, s) in expected.indexed)
              !s && expected.skip(i + 1).any((below) => below),
          ],
          reason: 'a hidden node with a shown one below is partly shown',
        );
      }
    }
  });

  /// Each node a line: indented by depth, its name, kind, own items and
  /// those below, state, and shown or not, and collapsed by default.
  Future<List<String>> lines() async {
    final out = <String>[];
    void walk(SourceNode n, int depth) {
      out.add(
        [
          '${'  ' * depth}${n.name} ${n.kind.name} ${n.items}/${n.itemsBelow}',
          n.state.name,
          if (n.shown) 'shown' else if (n.partly) 'partly' else 'hidden',
          if (n.appOwned) 'app',
        ].join(' '),
      );
      for (final c in n.children) {
        walk(c, depth + 1);
      }
    }

    walk(await sourceTree(db), 0);
    return out;
  }

  test(
    "Android's buckets are a tree under the device and its volumes, with "
    'the folders above them that hold no items, their counts summed',
    () async {
      final store = FakeMediaStore();
      final primary = store.mounted['external_primary'] = FakeVolume();
      const whatsApp = 'Android/media/com.whatsapp/WhatsApp/Media/';
      for (final path in [
        'DCIM/Camera/',
        'DCIM/Camera/',
        'Pictures/',
        'Pictures/Screenshots/',
        '${whatsApp}WhatsApp Images/',
        '${whatsApp}WhatsApp Video/',
        'Android/data/com.app/cache/',
      ]) {
        primary.add('x.jpg', path: path);
      }
      store.mounted['0000-0000'] = FakeVolume()..add('y.jpg');
      await MediaStoreIndexer(db, store).sync();
      store.mounted.remove('0000-0000');
      await MediaStoreIndexer(db, store).sync();
      expect(await lines(), [
        ' device 0/7 present shown',
        '  external_primary volume 0/7 present shown',
        '    Android folder 0/3 present shown app',
        '      data folder 0/1 present shown app',
        '        com.app folder 0/1 present shown app',
        '          cache folder 1/1 present hidden app',
        '      media folder 0/2 present shown app',
        '        com.whatsapp folder 0/2 present shown app',
        '          WhatsApp folder 0/2 present shown app',
        '            Media folder 0/2 present shown app',
        '              WhatsApp Images folder 1/1 present shown app',
        '              WhatsApp Video folder 1/1 present shown app',
        '    DCIM folder 0/2 present shown',
        '      Camera folder 2/2 present shown',
        '    Pictures folder 1/2 present shown',
        '      Screenshots folder 1/1 present shown',
        '  0000-0000 volume 0/0 offline shown',
        '    DCIM folder 0/0 offline shown',
        '      Camera folder 0/0 offline shown',
      ]);
      final camera = flatten(
        await sourceTree(db),
      ).firstWhere((n) => n.name == 'Camera');
      expect(
        (
          camera.source,
          camera.volume,
          camera.key,
          camera.parent,
          camera.newest,
        ),
        (
          'mediastore:external_primary',
          'external_primary',
          'DCIM/Camera/',
          'DCIM/',
          20200913,
        ),
      );
    },
  );

  test("a folder's hidden items are left out of its count and its root's, as "
      'every other view leaves them out', () async {
    final tmp = await Directory.systemTemp.createTemp('photolib-tree-');
    addTearDown(() => tmp.delete(recursive: true));
    final root = '${tmp.path}/Photos';
    for (final path in ['a.jpg', 'b.jpg', 'sub/c.jpg']) {
      File('$root/$path')
        ..createSync(recursive: true)
        ..writeAsStringSync(path);
    }
    await addFolder(db, root);
    await FolderIndexer(db).scan(root);
    Future<(int, int, int)> counts() async {
      final nodes = await tree();
      return (
        nodes['$root:']!.itemsBelow,
        nodes['$root:']!.items,
        nodes['$root:sub/']!.items,
      );
    }

    expect(await counts(), (3, 2, 1));
    final b = await (db.select(
      db.localAsset,
    )..where((a) => a.path.equals('b.jpg'))).getSingle();
    final c = await (db.select(
      db.localAsset,
    )..where((a) => a.path.equals('sub/c.jpg'))).getSingle();
    await setHidden(db, [b.id, c.id], value: true);
    expect(await counts(), (1, 1, 0));
    await setHidden(db, [b.id], value: false);
    expect(await counts(), (2, 2, 0));
  });

  test('folders show in natural order, numbers as numbers, in any case, as '
      'the folders page sorts them', () async {
    for (final path in ['F10/', 'F2/', 'f1/', 'F2/b/', 'F2/A/']) {
      await db.customStatement(
        "INSERT INTO device_folder (volume, path) VALUES ('v', ?)",
        [path],
      );
    }
    final volume = (await sourceTree(db)).children.single;
    expect([for (final c in volume.children) c.name], ['f1', 'F2', 'F10']);
    expect([for (final c in volume.children[1].children) c.name], ['A', 'b']);
  });

  group('the eye and the menu', () {
    late FakeMediaStore store;
    late FakeVolume primary;
    late MediaStoreIndexer indexer;
    const whatsApp = 'Android/media/com.whatsapp/WhatsApp/Media/';
    setUp(() async {
      store = FakeMediaStore();
      primary = store.mounted['external_primary'] = FakeVolume();
      for (final path in [
        'DCIM/Camera/',
        'Pictures/Screenshots/',
        '${whatsApp}WhatsApp Images/',
        '${whatsApp}WhatsApp Video/',
        '${whatsApp}WhatsApp Video/Sent/',
      ]) {
        primary.add('x.jpg', path: path);
      }
      indexer = MediaStoreIndexer(db, store);
      await indexer.sync();
    });

    Future<SourceNode> node(String key) async => flatten(
      await sourceTree(db),
    ).firstWhere((n) => n.key == key && n.kind != SourceKind.device);

    /// The folders of what the timeline shows.
    Future<Set<String>> library() async => {
      for (final i in await db.timelinePage(1 << 30, false, null, 100, 0).get())
        (await (db.select(
          db.deviceFolder,
        )..where((f) => f.id.equals(i.folder))).getSingle()).path.replaceFirst(
          whatsApp,
          '…/',
        ),
    };

    test('hiding a folder above buckets hides every one below it in one '
        'write; showing one under it shows it, and the folder above is '
        'partly shown', () async {
      final above = await node('Android/media/com.whatsapp/');
      expect(above.id, isNull, reason: 'MediaStore has no bucket for it');
      await show(db, above.volume, above.key, shown: !above.shown);
      expect(await library(), {'DCIM/Camera/', 'Pictures/Screenshots/'});

      final video = await node('${whatsApp}WhatsApp Video/');
      expect(
        (video.shown, video.visibility),
        (false, SourceVisibility.inherit),
      );
      await show(db, video.volume, video.key, shown: true);
      expect(await library(), {
        'DCIM/Camera/',
        'Pictures/Screenshots/',
        '…/WhatsApp Video/',
        '…/WhatsApp Video/Sent/',
      });
      final now = await node('Android/media/com.whatsapp/');
      expect(
        (now.shown, now.partly, now.visibility),
        (false, true, SourceVisibility.hidden),
      );

      await show(db, now.volume, now.key, shown: true);
      expect((await library()).length, 5, reason: 'everything again');
      expect(
        (await node(video.key)).visibility,
        SourceVisibility.shown,
        reason: 'what was shown below keeps its own visibility',
      );
    });

    test('a hidden folder shown again under a shown one inherits again, and '
        'the device hides everything that inherits', () async {
      final camera = await node('DCIM/Camera/');
      await show(db, camera.volume, camera.key, shown: false);
      expect((await node(camera.key)).visibility, SourceVisibility.hidden);
      await show(db, camera.volume, camera.key, shown: true);
      expect((await node(camera.key)).visibility, SourceVisibility.inherit);

      await show(db, '', '', shown: false);
      expect(await onlyChosen(db), isTrue);
      expect(await library(), isEmpty);
      await show(db, camera.volume, camera.key, shown: true);
      expect(await library(), {'DCIM/Camera/'});
      expect((await sourceTree(db)).partly, isTrue);
    });

    test('Show everything here clears what is hidden below', () async {
      for (final key in ['${whatsApp}WhatsApp Video/', 'DCIM/Camera/']) {
        await show(db, 'external_primary', key, shown: false);
      }
      await showEverything(db, await node('Android/'));
      expect(await library(), hasLength(4), reason: 'the camera stays out');
      await showEverything(db, await sourceTree(db));
      expect(await library(), hasLength(5));
      expect([
        for (final n in flatten(await sourceTree(db))) n.visibility,
      ], everyElement(isNot(SourceVisibility.hidden)));
    });

    test('Hide everything else here hides the rest of the folder above, and '
        'Show only this the rest of the device', () async {
      await hideOthers(db, await node('${whatsApp}WhatsApp Images/'));
      expect(await library(), {
        'DCIM/Camera/',
        'Pictures/Screenshots/',
        '…/WhatsApp Images/',
      });
      expect((await node(whatsApp)).partly, isTrue);

      await hideOthers(db, await node('Pictures/'), everywhere: true);
      expect(await library(), {'Pictures/Screenshots/'});
      expect(await onlyChosen(db), isTrue);

      primary.add('new.jpg', path: 'Download/');
      await indexer.sync();
      expect(await library(), {
        'Pictures/Screenshots/',
      }, reason: 'a folder that comes later is hidden while only chosen show');
    });

    test("the export carries the tree's own visibilities, which a reinstall "
        'restores', () async {
      await show(db, 'external_primary', 'Android/media/', shown: false);
      await show(db, 'external_primary', whatsApp, shown: true);
      await show(db, 'external_primary', 'DCIM/', shown: false);
      final exported = await exportDeviceFolders(db);
      final before = [
        for (final n in flatten(await sourceTree(db)))
          '${n.key} ${n.visibility.name} ${n.shown}',
      ];

      await db.close();
      db = Replica(NativeDatabase.memory());
      await importDeviceFolders(db, exported);
      await MediaStoreIndexer(db, store..install = 'new').sync();
      expect(before, contains('Android/media/ hidden false'));
      expect([
        for (final n in flatten(await sourceTree(db)))
          '${n.key} ${n.visibility.name} ${n.shown}',
      ], before);
    });
  });

  group("a desktop's or a browser's folder", () {
    late Directory tmp;
    late String root;
    late _Counting files;
    setUp(() async {
      tmp = await Directory.systemTemp.createTemp('photolib-tree-');
      root = '${tmp.path}/Photos';
      files = _Counting();
      for (final path in [
        'a.jpg',
        '2024/May/b.jpg',
        '2024/May/Party/c.jpg',
        '2024/May/Party/d.jpg',
        '2024/notes.txt',
        'Scans/e.png',
      ]) {
        File('$root/$path')
          ..createSync(recursive: true)
          ..writeAsStringSync(path);
      }
      File('$root/.photolibignore').writeAsStringSync('*.tmp\n');
      await addFolder(db, root);
      await FolderIndexer(db, files).scan(root);
    });
    tearDown(() => tmp.delete(recursive: true));

    Future<List<String>> timeline() async => [
      for (final i in await db.timelinePage(1 << 30, false, null, 100, 0).get())
        i.path!.split('/').last,
    ]..sort();

    test('is a root whose sub-folders come from the index, with their '
        'counts', () async {
      expect((await lines()).skip(1), [
        '  $root root 1/5 present shown',
        '    2024 folder 0/3 present shown',
        '      May folder 1/3 present shown',
        '        Party folder 2/2 present shown',
        '    Scans folder 1/1 present shown',
      ]);
      expect(flatten(await sourceTree(db)).elementAt(1).source, 'folder:$root');
    });

    test('an eye on a sub-folder filters its items out at query time: no '
        'rescan, .photolibignore untouched, and back when shown', () async {
      final ignore = File('$root/.photolibignore').readAsStringSync();
      files.calls = 0;
      final may = flatten(
        await sourceTree(db),
      ).firstWhere((n) => n.key == '2024/May/');
      await show(db, may.volume, may.key, shown: false);
      expect(await timeline(), ['a.jpg', 'e.png']);
      await show(db, may.volume, may.key, shown: true);
      expect(await timeline(), ['a.jpg', 'b.jpg', 'c.jpg', 'd.jpg', 'e.png']);
      expect(files.calls, 0, reason: 'nothing read the folder again');
      expect(File('$root/.photolibignore').readAsStringSync(), ignore);
    });

    test('a file moved to another folder takes its visibility, and a root '
        'removed takes its folders', () async {
      await show(db, root, 'Scans/', shown: false);
      File('$root/a.jpg').renameSync('$root/Scans/a.jpg');
      await FolderIndexer(db, files).scan(root);
      expect(await timeline(), ['b.jpg', 'c.jpg', 'd.jpg']);

      await removeFolder(db, root);
      expect(await db.select(db.deviceFolder).get(), isEmpty);
      expect(await db.select(db.timelineDay).get(), isEmpty);
    });
  });

  for (final onlyChosen in [false, true]) {
    test('schema v20 turns both lists of device folders into one own '
        'visibility each, keeping what the mode shows (only chosen: '
        '$onlyChosen), and files its folder files under folders', () async {
      final verifier = SchemaVerifier(GeneratedHelper());
      final schema = await verifier.schemaAt(20);
      final raw = schema.rawDatabase;
      for (final (n, (path, excluded, chosen)) in [
        ('DCIM/Camera/', 0, 1),
        ('Pictures/', 1, 0),
        ('Pictures/Screenshots/', 0, 0),
        ('Download/', 1, 1),
        ('Telegram/', 0, 0),
      ].indexed) {
        raw
          ..execute(
            'INSERT INTO device_folder (id, volume, path, excluded, chosen) '
            "VALUES (?, 'external_primary', ?, ?, ?)",
            [n + 1, path, excluded, chosen],
          )
          ..execute(
            'INSERT INTO local_asset (id, source, volume, source_id, size, '
            "mtime, path, folder) VALUES (?, 'mediastore', "
            "'external_primary', '$n', 7, 86400000, ?, ?)",
            [_id(n), path, n + 1],
          );
      }
      raw
        ..execute(
          'INSERT INTO local_asset (id, source, volume, source_id, size, '
          "mtime, path) VALUES (?, 'folder', '/p', 'f', 7, 86400000, "
          "'2024/May/a.jpg')",
          [_id(9)],
        )
        ..execute(
          'INSERT INTO device_folder_mode (id, only_chosen) VALUES (0, ?)',
          [if (onlyChosen) 1 else 0],
        );
      final db = Replica(
        schema.newConnection(),
        openBackup: (_) => NativeDatabase.memory(),
      );
      addTearDown(db.close);
      Future<Map<String, bool>> shown() async => {
        for (final f in await db.deviceFolders().get()) f.path: !f.out,
      };
      await verifier.migrateAndValidate(db, 21);
      expect(
        [
          for (final r
              in await db
                  .customSelect('SELECT path, visibility FROM device_folder')
                  .get())
            r.data.values.toList(),
        ],
        [
          ['DCIM/Camera/', 'shown'],
          ['Pictures/', 'hidden'],
          ['Pictures/Screenshots/', if (onlyChosen) 'inherit' else 'shown'],
          ['Download/', if (onlyChosen) 'shown' else 'hidden'],
          ['Telegram/', 'inherit'],
          ['2024/May/', 'inherit'],
        ],
      );
      expect(await shown(), {
        'DCIM/Camera/': true,
        'Pictures/': false,
        'Pictures/Screenshots/': !onlyChosen,
        'Download/': onlyChosen,
        'Telegram/': !onlyChosen,
        '2024/May/': !onlyChosen,
      });
      // Read raw: schema 21's timeline_day has no veiled column yet.
      final days = await db
          .customSelect(
            'SELECT day, SUM(count) AS n FROM timeline_day '
            'WHERE folder NOT IN (SELECT id FROM hidden_folder) GROUP BY day',
          )
          .get();
      expect(
        [for (final d in days) (d.read<int>('day'), d.read<int>('n'))],
        [(19700102, onlyChosen ? 2 : 4)],
        reason: 'the folder file counts under its folder',
      );

      // The other mode's list, but where it clashes with the mode's.
      await setOnlyChosen(db, on: !onlyChosen);
      expect(await shown(), {
        'DCIM/Camera/': true,
        'Pictures/': false,
        'Pictures/Screenshots/': !onlyChosen,
        'Download/': onlyChosen,
        'Telegram/': onlyChosen,
        '2024/May/': onlyChosen,
      });
    });
  }
}

/// The file system, counting what it reads.
class _Counting implements FolderFiles {
  int calls = 0;

  @override
  Future<List<FileEntry>?> list(String root, String dir) {
    calls++;
    return folderFiles.list(root, dir);
  }

  @override
  Future<bool?> isEmpty(String root) {
    calls++;
    return folderFiles.isEmpty(root);
  }

  @override
  Future<bool> caseSensitive(String root) => folderFiles.caseSensitive(root);

  @override
  Future<FileInfo?> stat(String root, String path) {
    calls++;
    return folderFiles.stat(root, path);
  }

  @override
  Future<String> read(String root, String path) {
    calls++;
    return folderFiles.read(root, path);
  }
}
