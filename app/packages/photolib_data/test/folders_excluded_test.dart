@TestOn('vm')
library;

import 'dart:io';

import 'package:drift/drift.dart' show OrderingTerm;
import 'package:drift/native.dart';
import 'package:photolib_data/photolib_data.dart';
import 'package:test/test.dart';

void main() {
  late Directory tmp;
  late String root;
  late Replica db;
  late FolderIndexer indexer;
  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('photolib-excluded-');
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

  Future<List<LocalAssetData>> byPath() => (db.select(
    db.localAsset,
  )..orderBy([(a) => OrderingTerm(expression: a.path)])).get();

  test(
    'what the rules ignore is indexed apart: out of every view until the '
    'excluded show, and in again when the rules let go; junk is not',
    () async {
      write('a.jpg');
      write('drafts/b.jpg');
      write('c.tmp.jpg');
      write('@eaDir/t.jpg');
      write('.photolibignore', 'drafts/\n*.tmp.jpg\n');
      await addFolder(db, root);
      await indexer.scan(root);
      Future<Map<String, int>> hidden() async => {
        for (final a in await byPath()) a.path!: a.hidden,
      };
      Future<List<String?>> shown({required bool veiled}) async => [
        for (final i
            in await db.timelinePage(1 << 30, veiled, null, 9, 0).get())
          i.path,
      ]..sort();
      expect(await hidden(), {'a.jpg': 0, 'c.tmp.jpg': 2, 'drafts/b.jpg': 2});
      expect(await shown(veiled: false), ['a.jpg']);
      expect(await shown(veiled: true), ['a.jpg', 'c.tmp.jpg', 'drafts/b.jpg']);

      // A hidden item the rules also ignore stays the user's.
      await setHidden(db, [
        (await byPath()).firstWhere((a) => a.path == 'a.jpg').id,
      ], value: true);
      write('.photolibignore', '*.jpg\n');
      await indexer.scan(root);
      expect(await hidden(), {'a.jpg': 1, 'c.tmp.jpg': 2, 'drafts/b.jpg': 2});

      write('.photolibignore', '');
      await indexer.scan(root);
      expect(await hidden(), {'a.jpg': 1, 'c.tmp.jpg': 0, 'drafts/b.jpg': 0});
      expect(await shown(veiled: false), ['c.tmp.jpg', 'drafts/b.jpg']);
    },
  );
}
