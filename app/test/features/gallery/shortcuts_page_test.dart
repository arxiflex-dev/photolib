import 'dart:typed_data';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/features/folders/items_page.dart';
import 'package:photolib/features/gallery/actions.dart';
import 'package:photolib/features/gallery/intents.dart';
import 'package:photolib/features/gallery/shortcuts.dart';
import 'package:photolib/features/library/timeline/providers.dart';
import 'package:photolib_data/photolib_data.dart' hide Stack;

import '../../support/pump_app.dart';
import '../../support/viewer.dart' show Grey;

class _Platform implements GalleryPlatform {
  new({required this.pins});

  final bool pins;
  final pinned = <(String, String, Uri)>[];

  @override
  Future<bool> pinShortcut(String id, String label, Uri link) async {
    pinned.add((id, label, link));
    return pins;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

void main() {
  late Replica db;
  setUp(() async {
    db = Replica(NativeDatabase.memory());
    await db
        .into(db.localAsset)
        .insert(
          LocalAssetCompanion.insert(
            id: Uint8List(16)..[15] = 1,
            source: 'mediastore',
            volume: const Value('external_primary'),
            sourceId: '1',
            size: 1,
            mtime: 0,
            path: const Value('DCIM/Trip/'),
            name: const Value('1.jpg'),
            mime: const Value('image/jpeg'),
          ),
        );
  });
  tearDown(() => db.close());

  Future<void> openTrip(WidgetTester tester, _Platform platform) async {
    await pumpApp(
      tester,
      replica: (_) => db,
      overrides: [
        galleryIntentsProvider.overrideWithValue(true),
        intentSourceProvider.overrideWithValue(const NoIntents()),
        galleryPlatformProvider.overrideWithValue(platform),
        thumbnailPipelineProvider.overrideWith((ref) async => Grey()),
      ],
    );
    await tester.tapAndSettle(find.text('Collections'));
    await tester.tapAndSettle(find.text('Folders'));
    await tester.tapAndSettle(find.text('Trip'));
  }

  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(Duration.zero);
  }

  testWidgets('a folder offers a shortcut to the home screen', (tester) async {
    final platform = _Platform(pins: true);
    await openTrip(tester, platform);
    expect(find.byType(ItemsPage), findsOneWidget);
    await tester.tapAndSettle(find.byTooltip('Add to home screen'));
    final (id, label, link) = platform.pinned.single;
    expect(id, 'folder:mediastore|external_primary|DCIM/Trip/');
    expect(label, 'Trip');
    expect(shortcutOf(link), isNotNull);
    expect(find.text('Your launcher cannot add shortcuts.'), findsNothing);
    await unmount(tester);
  });

  testWidgets('the link of a shortcut opens its folder', (tester) async {
    await pumpApp(
      tester,
      replica: (_) => db,
      overrides: [
        thumbnailPipelineProvider.overrideWith((ref) async => Grey()),
      ],
    );
    final link = folderLink((
      source: 'mediastore',
      volume: 'external_primary',
      dir: 'DCIM/Trip/',
    ), 'Trip');
    GoRouter.of(tester.element(find.byType(Scaffold).first))
        .go('${link.path}?${link.query}');
    await tester.pumpAndSettle();
    expect(find.byType(ItemsPage), findsOneWidget);
    expect(find.text('Trip'), findsOneWidget);
    expect(find.text('1.jpg'), findsNothing);
    await unmount(tester);
  });

  testWidgets('a launcher that cannot pin says so', (tester) async {
    await openTrip(tester, _Platform(pins: false));
    await tester.tapAndSettle(find.byTooltip('Add to home screen'));
    expect(find.text('Your launcher cannot add shortcuts.'), findsOneWidget);
    await unmount(tester);
  });
}

ItemsSource? shortcutOf(Uri link) => ItemsSource.folder((
  source: 'mediastore',
  volume: link.queryParameters['volume']!,
  dir: link.queryParameters['dir']!,
), 'x');
