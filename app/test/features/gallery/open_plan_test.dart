import 'dart:typed_data';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photolib/features/folders/sorting.dart';
import 'package:photolib/features/gallery/open_plan.dart';
import 'package:photolib_data/photolib_data.dart' hide Stack;

void main() {
  late Replica db;
  var next = 0;
  setUp(() {
    db = Replica(NativeDatabase.memory());
    next = 0;
  });
  tearDown(() => db.close());

  /// A MediaStore item `<dir>/<name>`; its source id is its count.
  Future<String> add(
    String dir,
    String name, {
    int taken = 0,
    int size = 1,
    bool hidden = false,
    bool trashed = false,
    String volume = 'external_primary',
    String mime = 'image/jpeg',
  }) async {
    final id = Uint8List(16)..[15] = ++next;
    await db
        .into(db.localAsset)
        .insert(
          LocalAssetCompanion.insert(
            id: id,
            source: 'mediastore',
            volume: Value(volume),
            sourceId: '$next',
            size: size,
            mtime: 0,
            path: Value(dir),
            name: Value(name),
            mime: Value(mime),
            taken: Value(taken),
            hidden: Value(hidden ? 1 : 0),
            trashed: Value(trashed ? 1 : 0),
          ),
        );
    return 'content://media/$volume/images/media/$next';
  }

  const camera = 'DCIM/Camera/';
  String key(String dir) => 'mediastore|external_primary|$dir';

  Future<List<String>> names(OpenPlan plan) async => [
    for (final item in plan.items) item.uri.pathSegments.last,
  ];

  test('opens exactly the requested item among its folder siblings, in the '
      "folder's sort order, in one plan", () async {
    final a = await add(camera, 'a.jpg', taken: 3);
    final b = await add(camera, 'b.jpg', taken: 1);
    final c = await add(camera, 'c.jpg', taken: 2);
    await add('Pictures/Other/', 'z.jpg', taken: 9);
    final plan = await planOpen(db, [
      Uri.parse(c),
    ], viewOf: (_) => const ItemView());
    // Newest taken first, the default view.
    expect([for (final i in plan.items) '${i.uri}'], [a, c, b]);
    expect(plan.items[plan.at].uri, Uri.parse(c));
    expect(plan.inLibrary, isTrue);
  });

  test('a folder sorted by name ascending opens at that position', () async {
    final uris = [
      await add(camera, 'IMG_2.jpg', taken: 1),
      await add(camera, 'IMG_10.jpg', taken: 2),
      await add(camera, 'IMG_1.jpg', taken: 3),
    ];
    final plan = await planOpen(
      db,
      [Uri.parse(uris[1])],
      viewOf: (k) => k == key(camera)
          ? const ItemView(sort: ItemSort.name, descending: false)
          : const ItemView(),
    );
    expect(
      [for (final i in plan.items) '${i.uri}'],
      [uris[2], uris[0], uris[1]],
    );
    expect(plan.at, 2);
  });

  test('the legacy external volume finds the item of any volume', () async {
    await add(camera, 'a.jpg');
    final b = await add(camera, 'b.jpg');
    final legacy = b.replaceFirst('external_primary', 'external');
    final plan = await planOpen(db, [
      Uri.parse(legacy),
    ], viewOf: (_) => const ItemView());
    expect(plan.items, hasLength(2));
    expect(plan.items[plan.at].id, isNotNull);
  });

  test('a hidden item opens, but its hidden siblings stay out', () async {
    await add(camera, 'a.jpg');
    final hidden = await add(camera, 'h.jpg', hidden: true);
    await add(camera, 'h2.jpg', hidden: true);
    final plan = await planOpen(db, [
      Uri.parse(hidden),
    ], viewOf: (_) => const ItemView());
    expect(plan.items, hasLength(2));
    expect(plan.items[plan.at].uri, Uri.parse(hidden));
  });

  test('a trashed item and one the library does not know open alone', () async {
    await add(camera, 'a.jpg');
    final trashed = await add(camera, 't.jpg', trashed: true);
    for (final uri in [
      trashed,
      'content://media/external_primary/images/media/999',
      'content://com.example.files/doc/1',
      'file:///sdcard/Download/x.jpg',
    ]) {
      final plan = await planOpen(
        db,
        [Uri.parse(uri)],
        viewOf: (_) => const ItemView(),
        mime: 'image/png',
      );
      expect(plan.items, hasLength(1), reason: uri);
      expect(plan.items.single.uri, Uri.parse(uri));
      expect(plan.at, 0);
      expect(plan.inLibrary, isFalse);
    }
  });

  test('a video is a video', () async {
    final v = await add(camera, 'v.mp4', mime: 'video/mp4');
    final plan = await planOpen(db, [
      Uri.parse(v.replaceFirst('/images/', '/video/')),
    ], viewOf: (_) => const ItemView());
    expect(plan.items.single.video, isTrue);
    final other = await planOpen(
      db,
      [Uri.parse('content://other/1')],
      viewOf: (_) => const ItemView(),
      mime: 'video/mp4',
    );
    expect(other.items.single.video, isTrue);
  });

  test(
    'over the lock screen only the given items show, never the library',
    () async {
      final a = await add(camera, 'a.jpg');
      await add(camera, 'b.jpg');
      final c = await add(camera, 'c.jpg');
      final plan = await planOpen(
        db,
        [Uri.parse(c), Uri.parse(a)],
        viewOf: (_) => const ItemView(),
        siblings: false,
      );
      expect([for (final i in plan.items) '${i.uri}'], [c, a]);
      expect(plan.at, 0);
    },
  );

  test('several uris open as given, the first shown', () async {
    final a = await add(camera, 'a.jpg');
    final b = await add('Pictures/X/', 'b.jpg');
    final plan = await planOpen(
      db,
      [Uri.parse(b), Uri.parse(a)],
      viewOf: (_) => const ItemView(),
      siblings: false,
    );
    expect(await names(plan), ['2', '1']);
  });

  test('no uris is an empty plan', () async {
    final plan = await planOpen(db, const [], viewOf: (_) => const ItemView());
    expect(plan.items, isEmpty);
  });
}
