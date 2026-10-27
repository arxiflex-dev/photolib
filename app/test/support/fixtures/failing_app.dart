// Run by pump_app_test.dart with flutter test: a test that fails with the app
// up over a database it closes in its tearDown must end at once.
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photolib/features/library/timeline/pipeline.dart';
import 'package:photolib/features/library/timeline/providers.dart';
import 'package:photolib/features/library/timeline/timeline_view.dart';
import 'package:photolib_data/photolib_data.dart';

import '../pump_app.dart';

void main() {
  late Replica db;
  setUp(() => db = Replica(NativeDatabase.memory()));
  tearDown(() => db.close());

  testWidgets('fails with the viewer up', (tester) async {
    await db
        .into(db.localAsset)
        .insert(
          LocalAssetCompanion.insert(
            id: Uint8List(16)..[15] = 1,
            source: 'folder',
            volume: const Value('/p'),
            sourceId: '1',
            path: const Value('1.jpg'),
            size: 1,
            mtime: 0,
            takenLocal: const Value('2024-05-01T12:00:00'),
          ),
        );
    await pumpApp(
      tester,
      size: const Size(1000, 700),
      replica: (_) => db,
      overrides: [
        thumbnailPipelineProvider.overrideWith(
          (ref) async => ThumbnailPipeline(),
        ),
      ],
    );
    final box = tester.getRect(find.byType(TimelineView));
    await tester.tapAt(box.topLeft + Offset(box.width / 6, 48 + box.width / 6));
    await tester.pumpAndSettle();
    await tester.pressKey(LogicalKeyboardKey.keyL, character: 'l');
    expect(1, 2);
  });
}
