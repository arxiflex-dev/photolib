import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/features/download/download.dart';
import 'package:photolib/features/download/download_action.dart';
import 'package:photolib/features/library/library_page.dart';
import 'package:photolib/features/library/timeline/pipeline.dart';
import 'package:photolib/features/library/timeline/providers.dart';
import 'package:photolib/features/library/timeline/timeline_view.dart';
import 'package:photolib/features/viewer/viewer_page.dart';
import 'package:photolib_data/photolib_data.dart';

import '../../support/pump_app.dart';

final desktop = TargetPlatformVariant.only(TargetPlatform.linux);

/// What it was given, by name, or the error that stopped it.
class _Destination implements Destination {
  final saved = <String, Object>{};

  @override
  Future<bool> save(
    String name,
    Stream<List<int>> bytes, {
    DateTime? modified,
  }) async {
    try {
      saved[name] = [await for (final chunk in bytes) ...chunk];
    } on Object catch (error) {
      saved[name] = error;
      rethrow;
    }
    return true;
  }
}

void main() {
  late Replica db;
  late _Destination to;
  setUp(() {
    db = Replica(NativeDatabase.memory());
    to = _Destination();
  });
  tearDown(() => db.close());

  // Four photos of a folder, 1.jpg to 4.jpg, newest first; on Android, of
  // MediaStore.
  Future<void> pump(
    WidgetTester tester, {
    String source = 'folder',
    Download? Function(ThumbnailItem)? of,
    Size size = const Size(400, 800),
  }) async {
    for (var n = 1; n <= 4; n++) {
      await db
          .into(db.localAsset)
          .insert(
            LocalAssetCompanion.insert(
              id: Uint8List(16)..[15] = n,
              source: source,
              volume: Value(source == 'folder' ? '/p' : 'external_primary'),
              sourceId: '$n',
              path: Value(source == 'folder' ? '$n.jpg' : 'DCIM/'),
              name: Value('$n.jpg'),
              mime: const Value('image/jpeg'),
              size: 1,
              mtime: 0,
              takenLocal: Value('2024-05-0${5 - n}T12:00:00'),
            ),
          );
    }
    await pumpApp(
      tester,
      replica: (_) => db,
      size: size,
      overrides: [
        thumbnailPipelineProvider.overrideWith(
          (ref) async => ThumbnailPipeline(),
        ),
        destinationProvider.overrideWithValue(to),
        downloadOfProvider.overrideWithValue(
          of ??
              (item) => Download(
                item.uri.pathSegments.last,
                () async => DownloadFile(
                  Stream.value(utf8.encode(item.uri.pathSegments.last)),
                  modified: DateTime(2024),
                ),
              ),
        ),
      ],
    );
  }

  // An edit somewhere in the replica.
  Future<void> edit() => db
      .into(db.assetVersion)
      .insert(
        AssetVersionCompanion.insert(
          id: Uint8List(16),
          assetId: Uint8List(16),
          kind: 'edit',
          createdAt: 0,
        ),
      );

  // An item whose bytes say which version they are.
  Download editedOf(ThumbnailItem item, {required bool edited}) {
    DownloadFile file(String text) =>
        DownloadFile(Stream.value(utf8.encode(text)), modified: DateTime(2024));
    return Download(
      item.uri.pathSegments.last,
      () async => file('original'),
      edited: edited ? () async => file('edited') : null,
    );
  }

  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(Duration.zero);
  }

  // Lets the replica, opened outside the test's fake clock, answer.
  Future<void> settle(WidgetTester tester, {bool animating = false}) async {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    animating
        ? await tester.pump(const Duration(seconds: 1))
        : await tester.pumpAndSettle();
  }

  // Long-presses the newest cell, then selects everything.
  Future<void> selectAll(WidgetTester tester) async {
    final box = tester.getRect(find.byType(TimelineView));
    await tester.longPressAt(box.topLeft + Offset(box.width / 6, 48 + 20));
    await tester.pumpAndSettle();
    await tester.tapAndSettle(find.byTooltip('Select all'));
  }

  testWidgets('a selection downloads as one zip of its items under their '
      'own names', (tester) async {
    await pump(tester);
    await selectAll(tester);
    await tester.tapAction('Download');
    await settle(tester);
    final MapEntry(key: name, value: zip) = to.saved.entries.single;
    expect(name, matches(RegExp(r'^Photolib .*\.zip$')));
    final text = utf8.decode(zip as List<int>, allowMalformed: true);
    expect(
      [for (var n = 1; n <= 4; n++) '$n.jpg'.allMatches(text).length],
      [3, 3, 3, 3],
    );
    expect(find.textContaining('Saved Photolib'), findsOneWidget);
    await unmount(tester);
  }, variant: desktop);

  testWidgets('while the replica holds no edit, a selection is read once, '
      'for its bytes, and no version is asked for', (tester) async {
    var reads = 0;
    await pump(
      tester,
      of: (item) {
        reads++;
        return Download(
          item.uri.pathSegments.last,
          () async => DownloadFile(Stream.value([1]), modified: DateTime(2024)),
        );
      },
    );
    await selectAll(tester);
    await tester.tapAction('Download');
    await settle(tester);
    expect(find.text('Which version?'), findsNothing);
    expect(reads, 4);
    expect(to.saved, hasLength(1));
    await unmount(tester);
  }, variant: desktop);

  testWidgets('an album downloads as a zip named after it, several albums '
      'as one zip with a folder each, albums of one name apart', (
    tester,
  ) async {
    ({String name, int count, Stream<ThumbnailItem> Function() items}) album(
      String name,
      List<int> photos,
    ) => (
      name: name,
      count: photos.length,
      items: () => Stream.fromIterable([
        for (final n in photos) ThumbnailItem('$n', Uri.file('/p/$n.jpg')),
      ]),
    );
    await pump(tester);
    final page = tester.element(find.byType(LibraryPage));
    Future<String> download(List<int> photos, List<String> names) async {
      unawaited(
        downloadAlbums(page, page as WidgetRef, [
          for (final (i, name) in names.indexed) album(name, [photos[i]]),
        ]),
      );
      await settle(tester);
      return utf8.decode(
        to.saved.values.last as List<int>,
        allowMalformed: true,
      );
    }

    expect('Trip/1.jpg'.allMatches(await download([1], ['Trip'])).length, 0);
    expect(to.saved.keys, ['Trip.zip']);
    final zip = await download([1, 2, 3], ['Trip', 'Home', 'trip']);
    expect(to.saved.keys.last, matches(RegExp(r'^Photolib .*\.zip$')));
    expect(
      [
        for (final name in ['Trip/1.jpg', 'Home/2.jpg', 'trip (2)/3.jpg'])
          name.allMatches(zip).length,
      ],
      [2, 2, 2],
    );
    await unmount(tester);
  }, variant: desktop);

  testWidgets("search results download as the library's do", (tester) async {
    await pump(tester);
    await tester.tapAndSettle(find.text('Search'));
    await tester.enterText(find.byType(TextField), 'jpg');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
    await tester.longPress(find.text('3.jpg'));
    await tester.pumpAndSettle();
    await tester.tapAndSettle(find.text('1.jpg'));
    await tester.tapAction('Download');
    await settle(tester);
    final zip = utf8.decode(
      to.saved.values.single as List<int>,
      allowMalformed: true,
    );
    // Each name in its header, as its bytes and in the central directory.
    expect(
      [for (var n = 1; n <= 4; n++) '$n.jpg'.allMatches(zip).length],
      [3, 0, 3, 0],
    );
    await unmount(tester);
  }, variant: desktop);

  testWidgets('a download shows its progress and stops on cancel', (
    tester,
  ) async {
    final stalled = StreamController<List<int>>();
    await pump(
      tester,
      of: (item) => Download(
        'a.jpg',
        () async => DownloadFile(stalled.stream, modified: DateTime(2024)),
      ),
    );
    await selectAll(tester);
    await tester.tapAction('Download');
    await settle(tester, animating: true);
    await settle(tester, animating: true);
    expect(find.text('Downloading 4 items'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await settle(tester);
    expect(to.saved.values.single, isA<DownloadCancelled>());
    expect(stalled.hasListener, isFalse);
    expect(find.byType(LinearProgressIndicator), findsNothing);
    expect(find.textContaining('Saved'), findsNothing);
    await unmount(tester);
  }, variant: desktop);

  // Runs the viewer's action [label] from its ⋮ menu.
  Future<void> fromMenu(WidgetTester tester, String label) async {
    await tester.tapAndSettle(
      find.descendant(
        of: find.byType(ViewerPage),
        matching: find.byTooltip('More'),
      ),
    );
    await tester.tap(find.widgetWithText(MenuItemButton, label));
  }

  testWidgets('once the replica holds an edit, the current version unless '
      'the user picks the original', (tester) async {
    await edit();
    await pump(tester, of: (item) => editedOf(item, edited: true));
    final box = tester.getRect(find.byType(TimelineView));
    await tester.tapAt(box.topLeft + Offset(box.width / 6, 48 + 20));
    await tester.pumpAndSettle();
    for (final (pick, expected) in [
      (null, 'edited'),
      ('Original', 'original'),
    ]) {
      await fromMenu(tester, 'Download');
      await tester.pumpAndSettle();
      expect(find.text('Which version?'), findsOneWidget);
      if (pick != null) await tester.tapAndSettle(find.text(pick));
      await tester.tapAndSettle(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text('Download'),
        ),
      );
      expect(utf8.decode(to.saved['1.jpg']! as List<int>), expected);
    }
    await unmount(tester);
  }, variant: desktop);

  for (final (selection, asks) in [
    ('a selection', true),
    ('one item', false),
  ]) {
    testWidgets('once the replica holds an edit, $selection where only 3.jpg '
        'has one ${asks ? 'asks' : 'downloads without asking'} for a '
        'version', (tester) async {
      await edit();
      await pump(
        tester,
        of: (item) => editedOf(item, edited: item.uri.path.endsWith('3.jpg')),
      );
      if (asks) {
        await selectAll(tester);
      } else {
        final box = tester.getRect(find.byType(TimelineView));
        await tester.tapAt(box.topLeft + Offset(box.width / 6, 48 + 20));
        await tester.pumpAndSettle();
      }
      if (asks) {
        await tester.tapAction('Download');
      } else {
        await fromMenu(tester, 'Download');
      }
      await settle(tester);
      expect(find.text('Which version?'), asks ? findsOneWidget : findsNothing);
      expect(to.saved.keys, [if (!asks) '1.jpg']);
      await unmount(tester);
    }, variant: desktop);
  }

  testWidgets('the viewer downloads its item and shows it in the folder', (
    tester,
  ) async {
    final revealed = <Object?>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('org.photolib/folders'),
      (call) async => call.method == 'lost'
          ? const <String>[]
          : revealed.add([call.method, call.arguments]),
    );
    await pump(tester, size: const Size(1000, 700));
    final semantics = tester.ensureSemantics();
    await tester.pump();
    tester.semantics.tap(
      find.semantics.byLabel('May 3, 2024, 1 of 1, no preview'),
    );
    await tester.pumpAndSettle();
    semantics.dispose();
    await fromMenu(tester, 'Download');
    await tester.pumpAndSettle();
    expect(utf8.decode(to.saved['2.jpg']! as List<int>), '2.jpg');
    await fromMenu(tester, 'Show in Finder');
    await tester.pumpAndSettle();
    expect(revealed, [
      ['reveal', '/p/2.jpg'],
    ]);
    await unmount(tester);
  }, variant: TargetPlatformVariant.only(TargetPlatform.macOS));

  testWidgets(
    'on a phone a selection goes to the share sheet: MediaStore '
    'items on Android, PhotoKit assets on iOS',
    (tester) async {
      final ios = defaultTargetPlatform == TargetPlatform.iOS;
      final calls = <MethodCall>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        MethodChannel(ios ? 'org.photolib/share' : 'org.photolib/viewer'),
        (call) async => calls.add(call),
      );
      await pump(tester, source: ios ? 'photokit' : 'mediastore');
      await selectAll(tester);
      expect(find.byTooltip('Download'), findsNothing);
      await tester.tapAction('Share');
      await settle(tester);
      expect(
        [
          for (final c in calls) [c.method, c.arguments],
        ],
        [
          [
            'share',
            if (ios)
              ['1', '2', '3', '4']
            else
              [
                [
                  for (var n = 1; n <= 4; n++)
                    'content://media/external_primary/images/media/$n',
                ],
                'image/*',
              ],
          ],
        ],
      );
      expect(to.saved, isEmpty);
      await unmount(tester);
    },
    variant: const TargetPlatformVariant({
      TargetPlatform.android,
      TargetPlatform.iOS,
    }),
  );

  testWidgets(
    'on iOS a share that fetches from iCloud shows its progress, and its '
    'cancel stops it',
    (tester) async {
      const channel = MethodChannel('org.photolib/share');
      final messenger = tester.binding.defaultBinaryMessenger;
      final calls = <String>[];
      final cancelled = Completer<void>();
      messenger.setMockMethodCallHandler(channel, (call) async {
        calls.add(call.method);
        if (call.method == 'cancel') return cancelled.complete();
        // As ShareSheet.swift does while PhotoKit downloads.
        await messenger.handlePlatformMessage(
          channel.name,
          channel.codec.encodeMethodCall(const MethodCall('progress', 0.25)),
          (_) {},
        );
        await cancelled.future;
        throw PlatformException(code: 'cancelled');
      });
      await pump(tester, source: 'photokit');
      await selectAll(tester);
      await tester.tapAction('Share');
      await settle(tester, animating: true);
      await settle(tester, animating: true);
      expect(find.text('Downloading 4 items'), findsOneWidget);
      expect(
        tester
            .widget<LinearProgressIndicator>(
              find.byType(LinearProgressIndicator),
            )
            .value,
        0.25,
      );
      await tester.tap(find.text('Cancel'));
      await settle(tester);
      expect(calls, ['share', 'cancel']);
      expect(find.byType(LinearProgressIndicator), findsNothing);
      await unmount(tester);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.iOS),
  );

  testWidgets('on iOS a share past the temporary space it may fill says so', (
    tester,
  ) async {
    // As ShareSheet.swift answers once its copies would pass the bound.
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('org.photolib/share'),
      (call) async => throw PlatformException(code: 'tooLarge'),
    );
    await pump(tester, source: 'photokit');
    await selectAll(tester);
    await tester.tapAction('Share');
    await settle(tester);
    expect(
      find.text('Too large to share at once: select fewer items'),
      findsOneWidget,
    );
    await unmount(tester);
  }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));

  testWidgets(
    'on iOS a share started while another runs does not start, and the '
    'first keeps its progress and its cancel',
    (tester) async {
      const channel = MethodChannel('org.photolib/share');
      final messenger = tester.binding.defaultBinaryMessenger;
      final calls = <String>[];
      final cancelled = Completer<void>();
      messenger.setMockMethodCallHandler(channel, (call) async {
        calls.add(call.method);
        if (call.method == 'cancel') return cancelled.complete();
        await cancelled.future;
        throw PlatformException(code: 'cancelled');
      });
      await pump(tester, source: 'photokit');
      final page = tester.element(find.byType(LibraryPage));
      final items = [
        for (var n = 1; n <= 2; n++) ThumbnailItem('$n', Uri.parse('ph:$n')),
      ];
      unawaited(share(page, items));
      unawaited(share(page, items.sublist(1)));
      await messenger.handlePlatformMessage(
        channel.name,
        channel.codec.encodeMethodCall(const MethodCall('progress', 0.25)),
        (_) {},
      );
      await settle(tester, animating: true);
      await settle(tester, animating: true);
      expect(calls, ['share']);
      expect(find.text('Downloading 2 items'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await settle(tester);
      expect(calls, ['share', 'cancel']);
      expect(find.byType(LinearProgressIndicator), findsNothing);
      await unmount(tester);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.iOS),
  );

  testWidgets(
    'on a phone a selection over 500 items, more than an intent carries, '
    'is not shared but said so',
    (tester) async {
      final ios = defaultTargetPlatform == TargetPlatform.iOS;
      final calls = <MethodCall>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        MethodChannel(ios ? 'org.photolib/share' : 'org.photolib/viewer'),
        (call) async => calls.add(call),
      );
      final source = ios ? 'photokit' : 'mediastore';
      await db.batch(
        (batch) => batch.insertAll(db.localAsset, [
          for (var n = 5; n <= 501; n++)
            LocalAssetCompanion.insert(
              id: Uint8List(16)
                ..[14] = n >> 8
                ..[15] = n,
              source: source,
              volume: const Value('external_primary'),
              sourceId: '$n',
              size: 1,
              mtime: 0,
              takenLocal: const Value('2024-04-01T12:00:00'),
            ),
        ]),
      );
      await pump(tester, source: source);
      await selectAll(tester);
      expect(find.text('501 selected'), findsOneWidget);
      await tester.tapAction('Share');
      await settle(tester);
      expect(calls, isEmpty);
      expect(
        find.text('Too many to share at once: select 500 or fewer'),
        findsOneWidget,
      );
      await unmount(tester);
    },
    variant: const TargetPlatformVariant({
      TargetPlatform.android,
      TargetPlatform.iOS,
    }),
  );
}
