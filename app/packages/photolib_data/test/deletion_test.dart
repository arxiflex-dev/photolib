@TestOn('vm')
library;

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:photolib_data/photolib_data.dart';
import 'package:test/test.dart';

/// A platform that records what it was asked, refusing when [refuse].
class FakePlatform implements MediaPlatform {
  FakePlatform({this.expires = false, this.restores = true});

  @override
  final bool expires;
  @override
  final bool restores;
  final List<String> calls = [];
  bool refuse = false;

  void _ask(String what, List<LocalAssetData> items) {
    if (refuse) throw StateError('refused');
    calls.add('$what ${[for (final i in items) i.sourceId].join(',')}');
  }

  @override
  Future<bool> asksFirst() async => false;

  @override
  Future<List<Binned>> trash(List<LocalAssetData> items) async {
    _ask('trash', items);
    return [
      for (final i in items)
        (
          bin: expires ? null : 'bin/${i.sourceId}',
          expires: expires ? 7 : null,
        ),
    ];
  }

  @override
  Future<void> restore(List<LocalAssetData> items) async =>
      _ask('restore', items);

  @override
  Future<void> purge(List<LocalAssetData> items) async => _ask('purge', items);

  @override
  Future<void> favorite(
    List<LocalAssetData> items, {
    required bool value,
  }) async => _ask('favorite $value', items);
}

Uint8List id(int n) => Uint8List(16)..[15] = n;

void main() {
  late Replica db;
  late FakePlatform folders;
  late FakePlatform store;
  late DeletionService service;
  final now = DateTime.utc(2024, 5, 2);
  setUp(() {
    db = Replica(NativeDatabase.memory());
    folders = FakePlatform();
    store = FakePlatform(expires: true);
    service = DeletionService(
      db,
      (source) => source == 'folder' ? folders : store,
      now: () => now,
    );
  });
  tearDown(() => db.close());

  Future<void> add(int n, {String source = 'folder', int trashed = 0}) => db
      .into(db.localAsset)
      .insert(
        LocalAssetCompanion.insert(
          id: id(n),
          source: source,
          sourceId: '$n',
          size: n,
          mtime: 0,
          path: Value('$n.jpg'),
          trashed: Value(trashed),
          state: Value(trashed == 1 ? 'missing' : 'present'),
        ),
      );

  Future<List<(String, int, int?, String?)>> rows() async => [
    for (final a in await (db.select(
      db.localAsset,
    )..orderBy([(a) => OrderingTerm(expression: a.id)])).get())
      (a.sourceId, a.trashed, a.expires, a.bin),
  ];

  test('moves items to the trash one request per source, keeping where each '
      'went and when it goes', () async {
    for (final n in [1, 2]) {
      await add(n);
    }
    await add(3, source: 'mediastore');
    await add(4, trashed: 1);
    await service.trash([id(1), id(2), id(3), id(4)]);
    expect(folders.calls, ['trash 1,2']);
    expect(store.calls, ['trash 3']);
    final until = now
        .add(DeletionService.defaultRetention)
        .millisecondsSinceEpoch;
    expect(await rows(), [
      ('1', 1, until, 'bin/1'),
      ('2', 1, until, 'bin/2'),
      ('3', 1, 7, null),
      ('4', 1, null, null),
    ]);
    expect(await db.trashItems(false).get(), hasLength(4));
    expect(await db.timelineDays(true, null).get(), isEmpty);
  });

  test('Photolib keeps what it trashes for the retention given, fixed for '
      'each item when it is trashed', () async {
    await add(1);
    await add(2);
    DeletionService keeping(int days) => DeletionService(
      db,
      (_) => folders,
      now: () => now,
      retention: Duration(days: days),
    );
    await keeping(30).trash([id(1)]);
    await keeping(90).trash([id(2)]);
    int? at(int days) => now.add(Duration(days: days)).millisecondsSinceEpoch;
    expect(await rows(), [
      ('1', 1, at(30), 'bin/1'),
      ('2', 1, at(90), 'bin/2'),
    ]);
    expect(DeletionService.defaultRetention, const Duration(days: 60));
    expect(service.retention, DeletionService.defaultRetention);
  });

  test('what goes to a trash Photolib cannot restore from leaves the index, '
      'and no undo is offered for it', () async {
    final photos = FakePlatform(expires: true, restores: false);
    service = DeletionService(
      db,
      (source) => source == 'photokit' ? photos : folders,
      now: () => now,
    );
    await add(1);
    await add(2, source: 'photokit');
    expect(await service.trash([id(1)]), isTrue);
    expect(await service.trash([id(1), id(2)]), isFalse);
    expect(photos.calls, ['trash 2']);
    expect([for (final r in await rows()) r.$1], ['1']);
  });

  test('a platform that refuses leaves the items as they were', () async {
    await add(1);
    folders.refuse = true;
    await expectLater(service.trash([id(1)]), throwsStateError);
    expect(await rows(), [('1', 0, null, null)]);
  });

  test('restores items from the trash where they were', () async {
    await add(1);
    await add(2);
    await service.trash([id(1), id(2)]);
    await service.restore([id(1)]);
    expect(folders.calls, ['trash 1,2', 'restore 1']);
    expect((await rows()).first, ('1', 0, null, null));
    final restored = await (db.select(
      db.localAsset,
    )..where((a) => a.id.equals(id(1)))).getSingle();
    expect(restored.state, 'present');
  });

  test('deletes for good only what is in the trash, with what is kept of '
      'it', () async {
    await add(1);
    await add(2, trashed: 1);
    await db
        .into(db.keptState)
        .insert(
          KeptStateCompanion.insert(
            fingerprint: Uint8List.fromList([2]),
            favorite: const Value(1),
          ),
        );
    await (db.update(db.localAsset)..where((a) => a.id.equals(id(2)))).write(
      LocalAssetCompanion(fingerprint: Value(Uint8List.fromList([2]))),
    );
    await expectLater(service.purge([id(1), id(2)]), throwsStateError);
    expect(folders.calls, isEmpty, reason: 'nothing outside the trash');
    final purged = await service.purge([id(2)]);
    expect([for (final p in purged) p.sourceId], ['2']);
    expect(folders.calls, ['purge 2']);
    expect(await rows(), [('1', 0, null, null)]);
    expect(await db.select(db.keptState).get(), isEmpty);
  });

  test('forgets the entry of an item the platform no longer holds without '
      'asking the platform, and only from the trash', () async {
    await add(1);
    await add(2, source: 'mediastore');
    await service.trash([id(2)]);
    store.refuse = true;
    await expectLater(service.forget([id(1), id(2)]), throwsStateError);
    expect(await rows(), [('1', 0, null, null), ('2', 1, 7, null)]);
    await service.forget([id(2)]);
    expect(await rows(), [('1', 0, null, null)]);
    expect(store.calls, ['trash 2'], reason: 'no purge: it refuses them');
  });

  test('purges what Photolib keeps past its retention, and leaves what the '
      'platform expires itself', () async {
    await add(1);
    await add(2);
    await add(3, source: 'mediastore');
    await service.trash([id(1), id(3)]);
    final later = DeletionService(
      db,
      (source) => source == 'folder' ? folders : store,
      now: () => now.add(DeletionService.defaultRetention),
    );
    expect([for (final p in await later.purgeExpired()) p.sourceId], ['1']);
    expect(folders.calls.last, 'purge 1');
    expect(store.calls, ['trash 3']);
  });

  test("a selection past SQLite's 32,766 variables is trashed, restored, "
      'favoured and purged whole', () async {
    const n = 40000;
    final ids = [
      for (var i = 0; i < n; i++)
        Uint8List(16)..buffer.asByteData().setUint32(0, i),
    ];
    await db.batch(
      (b) => b.insertAll(db.localAsset, [
        for (final (i, id) in ids.indexed)
          LocalAssetCompanion.insert(
            id: id,
            source: 'folder',
            sourceId: '$i',
            size: 1,
            mtime: 0,
          ),
      ]),
    );
    await service.trash(ids);
    expect(await db.trashItems(false).get(), hasLength(n));
    await service.restore(ids);
    await setFavorite(db, (_) => folders, ids, value: true);
    expect(await db.timelineDays(false, null).get(), [
      isA<TimelineDaysResult>().having((d) => d.count, 'count', n),
    ]);
    expect(
      folders.calls.last,
      'favorite true ${[for (var i = 0; i < n; i++) i].join(',')}',
    );
    await service.trash(ids);
    expect(await service.purge(ids), hasLength(n));
    expect(await db.select(db.localAsset).get(), isEmpty);
  });
}
