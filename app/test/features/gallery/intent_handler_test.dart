import 'dart:typed_data';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photolib/features/folders/sorting.dart';
import 'package:photolib/features/gallery/gallery_intent.dart';
import 'package:photolib/features/gallery/intent_handler.dart';
import 'package:photolib/features/gallery/intents.dart';
import 'package:photolib/features/gallery/open_plan.dart';
import 'package:photolib_data/photolib_data.dart' hide Stack;

class _Source implements IntentSource {
  final calls = <String>[];
  List<Uri>? picked;

  @override
  Stream<GalleryIntent> get incoming => const Stream.empty();

  @override
  Future<GalleryIntent?> initial() async => null;

  @override
  Future<void> pick(List<Uri> uris) async {
    calls.add('pick');
    picked = uris;
  }

  @override
  Future<void> cancel() async => calls.add('cancel');

  @override
  Future<void> done() async => calls.add('done');
}

GalleryIntent _intent(
  String action, {
  String? data,
  List<String> clips = const [],
  String? type,
  bool multiple = false,
  bool secure = false,
}) => GalleryIntent.fromMap({
  'action': action,
  'data': data,
  'clips': clips,
  'type': type,
  'multiple': multiple,
  'secure': secure,
})!;

void main() {
  late Replica db;
  late _Source source;
  late List<(OpenPlan, bool)> opened;
  List<Uint8List>? chosen;
  var next = 0;
  setUp(() {
    db = Replica(NativeDatabase.memory());
    source = _Source();
    opened = [];
    chosen = null;
    next = 0;
  });
  tearDown(() => db.close());

  Future<(Uint8List, String)> add(
    String name, {
    String mime = 'image/jpeg',
  }) async {
    final id = Uint8List(16)..[15] = ++next;
    await db
        .into(db.localAsset)
        .insert(
          LocalAssetCompanion.insert(
            id: id,
            source: 'mediastore',
            volume: const Value('external_primary'),
            sourceId: '$next',
            size: 1,
            mtime: 0,
            path: const Value('DCIM/Camera/'),
            name: Value(name),
            mime: Value(mime),
            taken: Value(next),
          ),
        );
    return (id, 'content://media/external_primary/images/media/$next');
  }

  IntentHandler handler() => IntentHandler(
    db: db,
    source: source,
    viewOf: (_) => const ItemView(),
    open: (plan, {required readOnly}) async => opened.add((plan, readOnly)),
    choose: (intent) async => chosen,
  );

  test(
    'a VIEW opens the item with its siblings, then returns to the caller',
    () async {
      await add('a.jpg');
      final (_, b) = await add('b.jpg');
      await handler().handle(
        _intent('android.intent.action.VIEW', data: b, type: 'image/jpeg'),
      );
      final (plan, readOnly) = opened.single;
      expect(plan.items, hasLength(2));
      expect('${plan.items[plan.at].uri}', b);
      expect(readOnly, isFalse);
      expect(source.calls, ['done']);
    },
  );

  test('a REVIEW_SECURE shows only what was sent, read-only', () async {
    final (_, a) = await add('a.jpg');
    await add('b.jpg');
    await handler().handle(
      _intent(
        'android.provider.action.REVIEW_SECURE',
        clips: [a],
        secure: true,
      ),
    );
    final (plan, readOnly) = opened.single;
    expect(plan.items, hasLength(1));
    expect(readOnly, isTrue);
    expect(source.calls, ['done']);
  });

  test('SEND opens the shared items alone', () async {
    final (_, a) = await add('a.jpg');
    await add('b.jpg');
    await handler().handle(
      _intent(
        'android.intent.action.SEND_MULTIPLE',
        clips: [a, 'content://other/1'],
        type: 'image/*',
      ),
    );
    expect(opened.single.$1.items, hasLength(2));
    expect(opened.single.$2, isFalse);
  });

  test('EDIT opens the item in the viewer, whose Edit button edits', () async {
    final (_, a) = await add('a.jpg');
    await handler().handle(
      _intent('android.intent.action.EDIT', data: a, type: 'image/*'),
    );
    expect(opened, hasLength(1));
  });

  test(
    'a PICK answers with the chosen items, readable by the caller',
    () async {
      final (idA, a) = await add('a.jpg');
      final (idB, b) = await add('b.jpg');
      chosen = [idB, idA];
      await handler().handle(
        _intent(
          'android.intent.action.GET_CONTENT',
          type: 'image/*',
          multiple: true,
        ),
      );
      expect([for (final u in source.picked!) '$u'], [b, a]);
      expect(source.calls, ['pick']);
    },
  );

  test('a single pick answers with one item, the first chosen', () async {
    final (idA, a) = await add('a.jpg');
    final (idB, _) = await add('b.jpg');
    chosen = [idA, idB];
    await handler().handle(
      _intent('android.intent.action.PICK', type: 'image/*'),
    );
    expect([for (final u in source.picked!) '$u'], [a]);
  });

  test('a pick of videos leaves the photos out', () async {
    final (idA, _) = await add('a.jpg');
    final (idV, v) = await add('v.mp4', mime: 'video/mp4');
    chosen = [idA, idV];
    await handler().handle(
      _intent(
        'android.intent.action.GET_CONTENT',
        type: 'video/*',
        multiple: true,
      ),
    );
    expect(
      [for (final u in source.picked!) '$u'],
      [v.replaceFirst('/images/', '/video/')],
    );
  });

  test('a pick that is left cancels the caller', () async {
    await add('a.jpg');
    chosen = null;
    await handler().handle(
      _intent('android.intent.action.PICK', type: 'image/*'),
    );
    expect(source.calls, ['cancel']);
    chosen = [];
    source.calls.clear();
    await handler().handle(
      _intent('android.intent.action.PICK', type: 'image/*'),
    );
    expect(source.calls, ['cancel']);
  });

  test(
    'an item that cannot be shown opens nothing and returns to the caller',
    () async {
      await handler().handle(
        _intent('android.intent.action.VIEW', data: 'content://x/1'),
      );
      // It opens alone, as any other app's item.
      expect(opened.single.$1.items, hasLength(1));
    },
  );

  test('picked ids of items gone are dropped', () async {
    final (idA, a) = await add('a.jpg');
    final gone = Uint8List(16)..[15] = 99;
    final uris = await pickedUris(
      db,
      [gone, idA],
      _intent(
        'android.intent.action.GET_CONTENT',
        type: 'image/*',
        multiple: true,
      ),
    );
    expect([for (final u in uris) '$u'], [a]);
  });
}
