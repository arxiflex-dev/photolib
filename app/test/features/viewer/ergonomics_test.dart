import 'dart:io';
import 'dart:ui' as ui;

import 'package:drift/drift.dart' show Value;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/features/settings/settings.dart';
import 'package:photolib/features/viewer/handoff.dart';
import 'package:photolib/features/viewer/info_panel.dart';
import 'package:photolib/features/viewer/screen.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

import '../../support/fake_players.dart';
import '../../support/viewer.dart';

Future<void> tapAt(WidgetTester tester, double x) async {
  await tester.tapAt(Offset(x, 400));
  await tester.pump(kDoubleTapTimeout);
  await tester.pumpAndSettle();
}

void main() {
  const size = Size(400, 800);
  _actions();
  _backgrounds();
  _bar();
  _screen();

  testWidgets('a tap on an edge goes to the previous or next item, in the '
      'reading direction; elsewhere it toggles the controls', (tester) async {
    final position = await pumpViewer(tester, size: size, at: 1);
    await tapAt(tester, 390);
    expect(position.value, 2);
    await tapAt(tester, 10);
    await tapAt(tester, 10);
    expect(position.value, 0);
    expect(find.byType(CloseButton), findsOneWidget);
    await tapAt(tester, 200);
    expect(position.value, 0);
    expect(find.byType(CloseButton), findsNothing);
  });

  testWidgets('right to left, the left edge goes to the next item', (
    tester,
  ) async {
    final position = await pumpViewer(
      tester,
      size: size,
      at: 1,
      locale: const Locale('ar'),
    );
    await tapAt(tester, 10);
    expect(position.value, 2);
  });

  testWidgets('with edge taps off, an edge toggles the controls', (
    tester,
  ) async {
    final position = await pumpViewer(
      tester,
      size: size,
      at: 1,
      settings: const Settings(toggles: {Toggle.edgeTaps: false}),
    );
    await tapAt(tester, 390);
    expect(position.value, 1);
    expect(find.byType(CloseButton), findsNothing);
  });

  double zoom(WidgetTester tester) => tester
      .widget<InteractiveViewer>(find.byType(InteractiveViewer).hitTestable())
      .transformationController!
      .value
      .getMaxScaleOnAxis();

  // A tap, then a second press at the same place, held.
  Future<TestGesture> tapAndHold(WidgetTester tester) async {
    const centre = Offset(200, 400);
    await tester.tapAt(centre);
    await tester.pump(const Duration(milliseconds: 50));
    return await tester.startGesture(centre);
  }

  testWidgets('a double tap held and dragged zooms with one finger: down in, '
      'up out, once past the platform touch slop', (tester) async {
    tester.view.gestureSettings = const ui.GestureSettings(
      physicalTouchSlop: 40,
    );
    addTearDown(tester.view.resetGestureSettings);
    await pumpViewer(tester, size: size, at: 1);
    var drag = await tapAndHold(tester);
    await drag.moveBy(const Offset(0, 30));
    await tester.pump();
    expect(zoom(tester), 1, reason: 'within the platform slop of 40');
    // In one move, past the interactive viewer's pan slop too.
    await drag.moveBy(const Offset(0, 170));
    await tester.pump();
    final zoomed = zoom(tester);
    expect(zoomed, greaterThan(2));
    await drag.up();
    await tester.pumpAndSettle();
    expect(find.byType(CloseButton), findsOneWidget, reason: 'not a tap');

    await tester.pump(kDoubleTapTimeout);
    drag = await tapAndHold(tester);
    await drag.moveBy(const Offset(0, -50));
    await drag.moveBy(const Offset(0, -100));
    await tester.pump();
    expect(zoom(tester), inExclusiveRange(1, zoomed));
    await drag.up();
    await tester.pumpAndSettle();
  });

  testWidgets('with one-finger zoom off, a double tap and drag does not zoom', (
    tester,
  ) async {
    await pumpViewer(
      tester,
      size: size,
      at: 1,
      settings: const Settings(toggles: {Toggle.oneFingerZoom: false}),
    );
    final drag = await tapAndHold(tester);
    await drag.moveBy(const Offset(0, 20));
    await drag.moveBy(const Offset(0, 100));
    await tester.pump();
    expect(zoom(tester), 1);
    await drag.up();
    await tester.pumpAndSettle();
  });
}

/// A screen whose brightness starts at half, and what the viewer sets it to.
class _Screen implements ScreenBrightness {
  final sets = <double?>[];

  @override
  Future<double> get() async => 0.5;

  @override
  Future<void> set(double? value) async => sets.add(value);
}

void _screen() {
  late FakePlayers players;
  setUp(() => VideoPlayerPlatform.instance = players = FakePlayers());

  testWidgets("on a video, vertical drags on the left third set the screen's "
      'brightness, on the right third the volume', (tester) async {
    final screen = _Screen();
    await pumpViewer(
      tester,
      size: const Size(400, 800),
      video: (_) => true,
      overrides: [screenBrightnessProvider.overrideWithValue(screen)],
    );
    await tester.dragFrom(const Offset(20, 600), const Offset(0, -200));
    await tester.pumpAndSettle();
    expect(screen.sets.last, closeTo(0.75, 0.01));
    await tester.dragFrom(const Offset(380, 200), const Offset(0, 400));
    await tester.pumpAndSettle();
    expect(players.calls.last, 'volume 0 0.5');
    await tester.pumpWidget(const SizedBox());
    expect(screen.sets.last, isNull, reason: "the system's again");
  });

  testWidgets('with swipes off, a drag on the side of a video sets nothing', (
    tester,
  ) async {
    final screen = _Screen();
    await pumpViewer(
      tester,
      size: const Size(400, 800),
      video: (_) => true,
      settings: const Settings(toggles: {Toggle.swipes: false}),
      overrides: [screenBrightnessProvider.overrideWithValue(screen)],
    );
    await tester.dragFrom(const Offset(20, 600), const Offset(0, -200));
    await tester.pumpAndSettle();
    expect(screen.sets, isEmpty);
  });

  testWidgets('set to, the viewer shows at full brightness until it closes', (
    tester,
  ) async {
    for (final on in [false, true]) {
      final screen = _Screen();
      await pumpViewer(
        tester,
        size: const Size(400, 800),
        settings: Settings(toggles: {Toggle.maxBrightness: on}),
        overrides: [screenBrightnessProvider.overrideWithValue(screen)],
      );
      await tester.pumpWidget(const SizedBox());
      expect(screen.sets, on ? [1.0, null] : isEmpty);
    }
  });

  testWidgets("set to, a phone's viewer turns to each item's orientation, "
      'and back to any once it closes', (tester) async {
    final turns = <Object?>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'SystemChrome.setPreferredOrientations') {
          turns.add(call.arguments);
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    // Even items are 4000 × 3000, odd ones too but turned a quarter.
    final rows = assetRowProvider.overrideWith(
      (ref, item) => Stream.value(
        row(item, orientation: int.parse(item.key).isOdd ? 90 : 0),
      ),
    );
    await pumpViewer(
      tester,
      size: const Size(400, 800),
      settings: const Settings(toggles: {Toggle.autoRotate: true}),
      overrides: [rows],
    );
    await tapAt(tester, 390);
    await tester.pumpWidget(const SizedBox());
    expect(turns, [
      ['DeviceOrientation.landscapeLeft', 'DeviceOrientation.landscapeRight'],
      ['DeviceOrientation.portraitUp'],
      <String>[],
    ]);
  });
}

void _bar() {
  // The tooltips of the bar's buttons, in order.
  List<String?> buttons(WidgetTester tester) => [
    for (final b in tester.widgetList<IconButton>(
      find.descendant(
        of: find.byType(Row).first,
        matching: find.byType(IconButton),
      ),
    ))
      b.tooltip,
  ];

  testWidgets("the bar holds the user's actions in their order, the others "
      'in its menu', (tester) async {
    await pumpViewer(tester, size: const Size(800, 600));
    expect(buttons(tester), [
      'Close',
      'Favourite',
      'Share',
      'Info',
      'Move to trash',
      'Edit',
      'Filmstrip',
      'More',
    ]);

    await pumpViewer(
      tester,
      size: const Size(800, 600),
      settings: const Settings(bar: [ViewerAction.filmstrip]),
    );
    expect(buttons(tester), ['Close', 'Filmstrip', 'More']);
    await tester.tap(find.byTooltip('More'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(MenuItemButton, 'Info'), findsOneWidget);
    expect(find.widgetWithText(MenuItemButton, 'Edit'), findsOneWidget);
  });
}

void _actions() {
  const size = Size(800, 600);
  // What the viewer asks of the platform.
  late List<String> asked;
  setUp(() {
    asked = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('org.photolib/viewer'), (
          call,
        ) async {
          if (call.method case 'view' || 'setAs') {
            asked.add('${call.method} ${call.arguments}');
          }
          return null;
        });
  });
  int turns(WidgetTester tester) => tester
      .widget<RotatedBox>(find.byKey(const ValueKey('turned 1')))
      .quarterTurns;

  testWidgets('rotate turns the photo shown a quarter clockwise each time, '
      'until the viewer closes', (tester) async {
    final position = await pumpViewer(
      tester,
      size: size,
      at: 1,
      settings: const Settings(bar: [ViewerAction.rotate]),
    );
    expect(turns(tester), 0);
    await tester.tap(find.byTooltip('Rotate'));
    await tester.pump();
    expect(turns(tester), 1);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyR);
    await tester.pump();
    expect(turns(tester), 2);
    position.value = 2;
    await tester.pumpAndSettle();
    expect(find.byTooltip('Rotate'), findsOneWidget);
    position.value = 1;
    await tester.pumpAndSettle();
    expect(turns(tester), 2);
  });

  testWidgets("map shows where a photo was taken in the platform's maps, "
      'and set as hands a MediaStore photo to the apps that use one', (
    tester,
  ) async {
    await pumpViewer(
      tester,
      size: size,
      content: true,
      settings: const Settings(bar: [ViewerAction.map, ViewerAction.setAs]),
      overrides: [
        assetRowProvider.overrideWith(
          (ref, item) => Stream.value(
            row(item)
                .copyWith(lat: const Value(48.8584), lon: const Value(2.2945)),
          ),
        ),
      ],
    );
    await tester.tap(find.byTooltip('Map'));
    await tester.tap(find.byTooltip('Set as'));
    expect(asked, [
      'view [geo:48.8584,2.2945?q=48.8584,2.2945]',
      'setAs [content://media/external/images/media/0, null]',
    ]);
  });

  testWidgets('without a place the map is off, and only Android sets as', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    await pumpViewer(
      tester,
      size: const Size(1600, 600),
      content: true,
      settings: const Settings(bar: [ViewerAction.map, ViewerAction.setAs]),
    );
    expect(
      tester
          .widget<IconButton>(
            find.widgetWithIcon(IconButton, Icons.map_outlined),
          )
          .onPressed,
      isNull,
    );
    expect(find.byTooltip('Set as'), findsNothing);
    debugDefaultTargetPlatformOverride = null;
  });

  test("each platform's maps take the place as their own link", () async {
    final ran = <String>[];
    Future<ProcessResult> run(String command, List<String> arguments) async {
      ran.add('$command ${arguments.join(' ')}');
      return ProcessResult(0, 0, '', '');
    }

    for (final platform in TargetPlatform.values) {
      debugDefaultTargetPlatformOverride = platform;
      ran.add('${platform.name}: ${mapOf(1.5, -2)}');
      if (platform case TargetPlatform.linux || TargetPlatform.windows) {
        await openElsewhere(mapOf(1.5, -2), run: run);
      }
    }
    debugDefaultTargetPlatformOverride = null;
    expect(ran, [
      'android: geo:1.5,-2.0?q=1.5,-2.0',
      'fuchsia: geo:1.5,-2.0?q=1.5,-2.0',
      'iOS: maps://?ll=1.5,-2.0&q=1.5,-2.0',
      'linux: geo:1.5,-2.0?q=1.5,-2.0',
      'xdg-open geo:1.5,-2.0?q=1.5,-2.0',
      'macOS: maps://?ll=1.5,-2.0&q=1.5,-2.0',
      'windows: bingmaps:?cp=1.5~-2.0&lvl=16',
      'explorer.exe bingmaps:?cp=1.5~-2.0&lvl=16',
    ]);
  });
}

void _backgrounds() {
  testWidgets('a transparent image shows over the background chosen', (
    tester,
  ) async {
    for (final (background, expected) in [
      (ViewerBackground.black, null),
      (ViewerBackground.white, Colors.white),
      (ViewerBackground.checkerboard, null),
    ]) {
      await pumpViewer(
        tester,
        size: const Size(400, 800),
        settings: Settings(background: background),
      );
      final found = find.byKey(const ValueKey('viewer-background'));
      switch (background) {
        case ViewerBackground.black:
          expect(found, findsNothing);
        case ViewerBackground.white:
          expect(tester.widget<ColoredBox>(found).color, expected);
        case ViewerBackground.checkerboard:
          expect(tester.widget(found), isA<CustomPaint>());
      }
    }
  });
}
