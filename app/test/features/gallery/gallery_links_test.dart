import 'dart:async';
import 'dart:typed_data';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/features/gallery/gallery_intent.dart';
import 'package:photolib/features/gallery/intents.dart';
import 'package:photolib/features/library/timeline/providers.dart';
import 'package:photolib/features/viewer/viewer_page.dart';
import 'package:photolib_data/photolib_data.dart' hide Stack;

import '../../support/pump_app.dart';
import '../../support/viewer.dart' show Grey;

class _Source implements IntentSource {
  new(this.launch);

  final GalleryIntent? launch;
  final sent = StreamController<GalleryIntent>.broadcast();
  final calls = <String>[];

  @override
  Stream<GalleryIntent> get incoming => sent.stream;

  @override
  Future<GalleryIntent?> initial() async => launch;

  @override
  Future<void> pick(List<Uri> uris) async => calls.add('pick');

  @override
  Future<void> cancel() async => calls.add('cancel');

  @override
  Future<void> done() async => calls.add('done');
}

GalleryIntent _view(String uri) => GalleryIntent.fromMap({
  'action': 'android.intent.action.VIEW',
  'data': uri,
  'type': 'image/jpeg',
  'clips': <String>[],
})!;

// The drift streams of the app's pages close on a timer once unmounted.
Future<void> unmount(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(Duration.zero);
}

void main() {
  late Replica db;
  setUp(() async {
    db = Replica(NativeDatabase.memory());
    for (final n in [1, 2, 3]) {
      await db
          .into(db.localAsset)
          .insert(
            LocalAssetCompanion.insert(
              id: Uint8List(16)..[15] = n,
              source: 'mediastore',
              volume: const Value('external_primary'),
              sourceId: '$n',
              size: 1,
              mtime: 0,
              path: const Value('DCIM/Camera/'),
              name: Value('$n.jpg'),
              mime: const Value('image/jpeg'),
              taken: Value(n),
            ),
          );
    }
  });
  tearDown(() => db.close());

  Future<_Source> pump(WidgetTester tester, GalleryIntent? launch) async {
    final source = _Source(launch);
    await pumpApp(
      tester,
      replica: (_) => db,
      overrides: [
        galleryIntentsProvider.overrideWithValue(true),
        intentSourceProvider.overrideWithValue(source),
        thumbnailPipelineProvider.overrideWith((ref) async => Grey()),
      ],
    );
    return source;
  }

  testWidgets('the intent that started the app opens its item in the viewer, '
      'and closing the viewer returns to the caller', (tester) async {
    final source = await pump(
      tester,
      _view('content://media/external_primary/images/media/2'),
    );
    await tester.pumpUntil(
      () => tester.any(find.byType(ViewerPage)),
      step: const Duration(milliseconds: 50),
      within: const Duration(seconds: 10),
    );
    final viewer = tester.widget<ViewerPage>(find.byType(ViewerPage));
    // The item asked for, among its three folder siblings.
    expect(viewer.count, 3);
    expect(viewer.position.value, 1);
    expect(viewer.readOnly, isFalse);
    await tester.tap(find.byKey(const ValueKey('viewer-close')));
    await tester.pumpAndSettle();
    expect(find.byType(ViewerPage), findsNothing);
    expect(source.calls, ['done']);
    await unmount(tester);
  });

  testWidgets('an intent sent while the app runs opens too', (tester) async {
    final source = await pump(tester, null);
    expect(find.byType(ViewerPage), findsNothing);
    source.sent.add(_view('content://media/external_primary/images/media/3'));
    await tester.pumpUntil(
      () => tester.any(find.byType(ViewerPage)),
      step: const Duration(milliseconds: 50),
      within: const Duration(seconds: 10),
    );
    expect(
      tester.widget<ViewerPage>(find.byType(ViewerPage)).position.value,
      0,
    );
    await unmount(tester);
  });
}
