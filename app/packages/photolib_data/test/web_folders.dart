// The browser folders of web_test.dart (Chromium's File System Access), in
// OPFS directories: scans as on desktops, and the metadata of their files,
// read in the replica's data worker.
import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:drift/drift.dart' hide isNull;
import 'package:photolib_data/photolib_data.dart';
import 'package:photolib_data/src/browser_folders.dart'
    show addFolderHandle, browserFile;
import 'package:photolib_data/src/open_web.dart' show openKeyed;
import 'package:photolib_log/photolib_log.dart';
import 'package:photolib_workers/testing.dart';
import 'package:test/test.dart';
import 'package:web/web.dart' as web;

/// The tests of folders in the replica under [key], whose web assets
/// (web_assets.dart) [assets] serves.
void folderTests(Uri Function() assets, Uint8List key) {
  final run = DateTime.now().microsecondsSinceEpoch;
  late web.FileSystemDirectoryHandle opfs;
  setUp(() async {
    opfs = await web.window.navigator.storage.getDirectory().toDart;
  });

  Future<Replica> open(String name) =>
      openKeyed(assets().toString(), 'folders-$run-$name', key);

  /// The directory at [path] in the origin private file system, with
  /// [files] by path, each holding its text or blob.
  Future<web.FileSystemDirectoryHandle> folder(
    String path, [
    Map<String, Object> files = const {},
  ]) async {
    Future<web.FileSystemDirectoryHandle> dir(
      web.FileSystemDirectoryHandle root,
      Iterable<String> names,
    ) async {
      var at = root;
      for (final name in names) {
        at = await at
            .getDirectoryHandle(
              name,
              web.FileSystemGetDirectoryOptions(create: true),
            )
            .toDart;
      }
      return at;
    }

    final root = await dir(opfs, path.split('/'));
    for (final MapEntry(key: file, :value) in files.entries) {
      final parts = file.split('/');
      await _put(
        await dir(root, parts.take(parts.length - 1)),
        parts.last,
        value is String ? value.toJS : value as web.Blob,
      );
    }
    return root;
  }

  late Map<Object?, Object?> corpus;
  setUpAll(() async {
    corpus =
        await spawnHybridUri('corpus_native.dart').stream.first
            as Map<Object?, Object?>;
  });

  /// The corpus file at [path], as the VM side served it.
  Future<web.Blob> fetched(String path) async {
    final served = Uri.base.resolve('../${corpus['files']}/');
    final url = served.resolveUri(Uri(path: path)).toString();
    final response = await web.window.fetch(url.toJS).toDart;
    return await response.blob().toDart;
  }

  String kernel() => assets().resolve('photolib_kernel_wasm.js').toString();

  Future<int> waiting(Replica db) async =>
      (await db
              .customSelect(
                'SELECT COUNT(*) AS n FROM local_asset '
                "WHERE extracted IS NULL AND state = 'present'",
              )
              .getSingle())
          .read<int>('n');

  /// path → [what] of every folder item of [db], by default 'state size', but
  /// for those the ignore rules exclude (`hidden` 2).
  Future<Map<String, String>> items(
    Replica db, [
    String Function(LocalAssetData)? what,
  ]) async => {
    for (final a in await (db.select(
      db.localAsset,
    )..orderBy([(a) => OrderingTerm(expression: a.path)])).get())
      if (a.hidden != 2) a.path!: what?.call(a) ?? '${a.state} ${a.size}',
  };

  Future<Map<String, String>> folders(Replica db) async => {
    for (final f in await db.folderSummary().get()) f.root: f.state,
  };

  Future<List<Object>> library(Replica db) async => [
    await folders(db),
    await items(db),
  ];

  /// Waits for [actual] to come to [expected], as the page's scans make it,
  /// for two minutes of its own waits, which a stopped browser does not run
  /// out.
  Future<void> until(Future<Object?> Function() actual, Object expected) async {
    for (var i = 0; i < 2400 && '${await actual()}' != '$expected'; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
    expect('${await actual()}', '$expected');
  }

  test('a folder the user gave is indexed as on desktops, '
      'and again on the next visit', () async {
    final dir = await folder('visits-$run/Photos', {
      'a.jpg': 'a',
      '2024/b.png': 'bb',
      'notes.txt': 'ccc',
      '.photolibignore': 'skip/',
      'skip/c.jpg': 'dddd',
    });
    var db = await open('visits');
    expect(await addFolderHandle(db, dir), isTrue);
    await until(() => library(db), [
      {'Photos': 'online'},
      {'2024/b.png': 'present 2', 'a.jpg': 'present 1'},
    ]);
    expect((await browserFile('Photos', '2024/b.png'))!.size, 2);
    expect(await browserFile('Photos', '2024/none.png'), isNull);
    await db.close();

    await folder('visits-$run/Photos', {'2024/d.jpg': 'eeeee'});
    await dir.removeEntry('a.jpg').toDart;
    db = await open('visits');
    addTearDown(db.close);
    await until(() => library(db), [
      {'Photos': 'online'},
      {
        '2024/b.png': 'present 2',
        '2024/d.jpg': 'present 5',
        'a.jpg': 'missing 1',
      },
    ]);
  });

  test('a folder in, inside or around the library is refused; '
      'another of the same name is numbered', () async {
    final db = await open('overlaps');
    addTearDown(db.close);
    final base = 'overlaps-$run';
    expect(
      await addFolderHandle(db, await folder('$base/Photos', {'a.jpg': 'a'})),
      isTrue,
    );
    for (final path in [base, '$base/Photos', '$base/Photos/2024']) {
      expect(
        await addFolderHandle(db, await folder(path)),
        isFalse,
        reason: path,
      );
    }
    expect(await addFolderHandle(db, await folder('$base/old/Photos')), isTrue);
    expect((await folders(db)).keys, ['Photos', 'Photos (2)']);
  });

  test('a renamed or moved file keeps its item', () async {
    final db = await open('moves');
    addTearDown(db.close);
    final dir = await folder('moves-$run/Moves', {
      'a.jpg': 'a',
      '2024/b.jpg': 'bb',
    });
    expect(await addFolderHandle(db, dir), isTrue);
    await until(() => folders(db), {'Moves': 'online'});
    Future<Map<String, String>> ids() => items(db, (a) => a.sourceId);
    final before = await ids();
    final a = await dir.getFileHandle('a.jpg').toDart;
    await a.callMethod<JSPromise>('move'.toJS, 'c.jpg'.toJS).toDart;
    final b = await (await dir.getDirectoryHandle('2024').toDart)
        .getFileHandle('b.jpg')
        .toDart;
    await b.callMethod<JSPromise>('move'.toJS, dir, 'b.jpg'.toJS).toDart;
    web.document.dispatchEvent(web.Event('visibilitychange'));
    await until(ids, {'b.jpg': before['2024/b.jpg'], 'c.jpg': before['a.jpg']});
  });

  test('a replica closed while its folder is scanned stops the scan '
      'between directories, and the next opening finishes it', () async {
    final dir = await folder('closing-$run/Many', {
      for (var i = 1; i < 4; i++) '$i/a.jpg': 'a' * i,
    });
    final first = await open('closing');
    final logged = <String>[];
    final logging = Log.records.listen((r) => logged.add(r.message));
    // As the scan's transaction of 1/ begins.
    final closed = Log.records
        .firstWhere((r) => r.message == 'directory' && r.fields['dir'] == '1')
        .then((_) => Future<void>.delayed(Duration.zero, first.close));
    expect(await addFolderHandle(first, dir), isTrue);
    await closed;
    await logging.cancel();
    expect(logged, contains('scan stopped'));
    final db = await open('closing');
    addTearDown(db.close);
    await until(() => library(db), [
      {'Many': 'online'},
      {'1/a.jpg': 'present 1', '2/a.jpg': 'present 2', '3/a.jpg': 'present 3'},
    ]);
  });

  test('a folder the browser cannot read turns offline, '
      'and is scanned again once the user allows it', () async {
    final db = await open('allow');
    addTearDown(db.close);
    final parent = await folder('allow-$run');
    expect(
      await addFolderHandle(
        db,
        await folder('allow-$run/Shots', {'a.jpg': 'a'}),
      ),
      isTrue,
    );
    await until(() => folders(db), {'Shots': 'online'});
    await parent
        .removeEntry('Shots', web.FileSystemRemoveOptions(recursive: true))
        .toDart;
    web.document.dispatchEvent(web.Event('visibilitychange'));
    await until(() => library(db), [
      {'Shots': 'offline'},
      {'a.jpg': 'offline 1'},
    ]);
    await folder('allow-$run/Shots', {'a.jpg': 'a'});
    await browserFolders!.allow(db, 'Shots');
    await until(() => library(db), [
      {'Shots': 'online'},
      {'a.jpg': 'present 1'},
    ]);
  });

  test('a folder is read in Web Workers as the desktops read it: every '
      'file has the capture time, projection, crop, stereo and facets the '
      'native kernel reads, its spheres are projected and the Panoramas '
      'facet finds exactly the panoramas and spheres', () async {
    final native = (corpus['native']! as Map<Object?, Object?>).map(
      (path, read) => MapEntry(path! as String, read! as Map),
    );
    final files = <String, Object>{};
    for (final path in native.keys) {
      files[path] = await fetched(path);
    }
    final dir = await folder('corpus-$run/Corpus', files);
    final db = await open('corpus');
    addTearDown(db.close);
    extractMetadata(db, kernel: kernel());
    expect(await addFolderHandle(db, dir), isTrue);
    await until(() async => [await folders(db), await waiting(db)], [
      {'Corpus': 'online'},
      0,
    ]);
    final columns = {for (final c in native.values) ...c.keys.cast<String>()};
    Map<String, Object?> read(Insertable<LocalAssetData> row) {
      final values = row.toColumns(false);
      return {for (final c in columns) c: (values[c] as Variable?)?.value};
    }

    final rows = {
      for (final a in await db.select(db.localAsset).get()) a.path!: a,
    };
    expect(
      {for (final MapEntry(:key, :value) in rows.entries) key: read(value)},
      {
        for (final MapEntry(:key, :value) in native.entries)
          key: {for (final c in columns) c: value[c]},
      },
    );
    expect(
      [
        for (final p in [
          'compound/pano/photosphere.jpg',
          'compound/pano/photosphere-cropped.jpg',
          'compound/sphere/spherical-v2.mp4',
          'compound/sphere/spherical-v2-cropped.mp4',
        ])
          [rows[p]!.projection, rows[p]!.crop, rows[p]!.stereo],
      ],
      [
        ['equirectangular', null, null],
        ['equirectangular', '0,1024,8192,2048,8192,4096', null],
        ['equirectangular', null, null],
        ['equirectangular', '960,0,1920,1920,3840,1920', null],
      ],
    );
    final panoramas = await searchPage(
      db,
      const LocalQuery(facets: {Facet.panorama}),
      limit: 100,
    );
    expect(panoramas.items.map((a) => a.path).toSet(), {
      'compound/pano/photosphere.jpg',
      'compound/pano/photosphere-cropped.jpg',
      'compound/sphere/cubemap.mp4',
      'compound/sphere/spherical-v1.mp4',
      'compound/sphere/spherical-v2.mp4',
      'compound/sphere/spherical-v2-cropped.mp4',
    });
  });

  test('a folder scanned before its files were read is read on the next '
      'visit, and a file that changes is read again', () async {
    final dir = await folder('resume-$run/Old', {
      'a.jpg': await fetched('time/zones/india.jpg'),
    });
    var db = await open('resume');
    expect(await addFolderHandle(db, dir), isTrue);
    await until(() => folders(db), {'Old': 'online'});
    expect(await items(db, (a) => '${a.extracted}'), {'a.jpg': 'null'});
    await db.close();

    db = await open('resume');
    addTearDown(db.close);
    extractMetadata(db, kernel: kernel());
    extractFirst(db, [(await db.select(db.localAsset).getSingle()).id]);
    await until(() => items(db, (a) => '${a.make}'), {'a.jpg': 'Canon'});
    await folder('resume-$run/Old', {
      'a.jpg': await fetched('stills/gps-sydney.jpg'),
    });
    web.document.dispatchEvent(web.Event('visibilitychange'));
    await until(() => items(db, (a) => '${a.make}'), {'a.jpg': 'samsung'});
  });

  test('a folder of 10,000 images is indexed, rescanned and read '
      'while the page goes on rendering', () async {
    final image = await fetched('time/zones/india.jpg');
    final dir = await folder('large-$run/Camera');
    for (var i = 0; i < 10000; i += 500) {
      await Future.wait([
        for (var j = i; j < i + 500; j++) _put(dir, 'IMG_$j.JPG', image),
      ]);
    }
    final db = await open('large');
    addTearDown(db.close);
    // The page scans: it may drop 15% more animation frames than an idle
    // page, whatever the longest gap, which a loaded machine stretches
    // past 0.5 s (ADR-0082). One try, as a folder added again is not
    // indexed again.
    final clock = Stopwatch();
    await withinFrameBudget(
      () async {
        clock.start();
        expect(await addFolderHandle(db, dir), isTrue);
        await until(() => folders(db), {'Camera': 'online'});
      },
      budget: 0.15,
      attempts: 1,
      animationOnly: true,
    );
    // The measurement is the run's report.
    // ignore: avoid_print
    print('10,000 images indexed in ${clock.elapsed}');
    expect((await db.folderSummary().getSingle()).items, 10000);
    expect(clock.elapsed, lessThan(const Duration(minutes: 1)));
    await withinFrameBudget(
      () => FolderIndexer(db).scan('Camera'),
      budget: 0.15,
      animationOnly: true,
    );
    // Read in Web Workers: the page may drop no more frames than the 1% of
    // janky frames tools/perf/budgets.json allows a scroll (folder-scroll).
    // Each try reads them all again.
    await withinFrameBudget(() async {
      clock.reset();
      await db.customUpdate(
        'UPDATE local_asset SET extracted = NULL',
        updates: {db.localAsset},
      );
      extractMetadata(db, kernel: kernel());
      await until(() => waiting(db), 0);
    });
    // The measurement is the run's report.
    // ignore: avoid_print
    print('10,000 images read in ${clock.elapsed}');
    expect(
      await items(
        db,
        (a) => '${a.takenLocal} ${a.make}',
      ).then((m) => m.values.toSet()),
      {'2023-04-14T08:30:00 Canon'},
    );
  }, timeout: const Timeout(Duration(minutes: 10)));
}

/// Writes [data], a string or blob, to the file [name] in [dir]; not inlined
/// in an async loop, where dart2wasm gives the closures made one shared copy
/// of the loop's variables.
Future<void> _put(
  web.FileSystemDirectoryHandle dir,
  String name,
  JSAny data,
) async {
  final handle = await dir
      .getFileHandle(name, web.FileSystemGetFileOptions(create: true))
      .toDart;
  final writable = await handle.createWritable().toDart;
  await writable.write(data).toDart;
  await writable.close().toDart;
}
