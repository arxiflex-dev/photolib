import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/core/feature_flags.dart';
import 'package:photolib/core/providers.dart';
import 'package:photolib/features/admin/admin_page.dart';
import 'package:photolib/features/folders/folders.dart';
import 'package:photolib/features/servers/servers.dart';
import 'package:photolib/features/settings/settings.dart';
import 'package:photolib/features/settings/settings_page.dart';

import '../support/fake_server.dart';
import '../support/pump_app.dart';
import '../support/tiles.dart';

void main() {
  Future<Settings Function()> open(WidgetTester tester) async {
    await pumpApp(tester, size: const Size(800, 1800));
    await tester.tapAndSettle(find.byTooltip('Settings'));
    await tester.tapAndSettle(find.text('Viewing'));
    final container = ProviderScope.containerOf(
      tester.element(find.text('Viewing')),
    );
    return () => container.read(settingsProvider);
  }

  testWidgets('every tile of Settings starts where the headings do, the '
      "server's while it is read and once it is", (tester) async {
    final answered = Completer<void>();
    final kept = SavedServer(
      endpoints: [Uri.parse('https://photos.example.org')],
      instance: 'instance-a',
      account: const Account(name: 'ann', token: 't', deviceId: 'd'),
    );
    await pumpApp(
      tester,
      size: const Size(800, 1800),
      serverStore: MemoryStore(jsonEncode(kept.toJson()), answered.future),
      overrides: [
        adminClientProvider.overrideWithValue(FakeServer()),
        connectProvider.overrideWithValue((_, _) => FakeServer()),
        featureFlagsProvider.overrideWithValue(
          FeatureFlags.parse('diagnostics'),
        ),
        folderPickerProvider.overrideWithValue(
          ({initialDirectory}) async => null,
        ),
      ],
    );
    await tester.tapAndSettle(find.byTooltip('Settings'));
    void expectAligned(int tiles) {
      final start = tester.getTopLeft(find.text('Theme')).dx;
      final starts = tester.tileStarts(find.byType(SettingsPage));
      expect(starts, hasLength(tiles));
      expect(starts, {for (final title in starts.keys) title: start});
    }

    expectAligned(14);
    answered.complete();
    await tester.pumpAndSettle();
    expect(find.text('photos.example.org'), findsOneWidget);
    // The server, one that adds another (ADR-0234) and private libraries.
    expectAligned(16);
  });

  testWidgets('each viewing choice has a switch, on or off as it is by '
      'default, that turns it', (tester) async {
    final settings = await open(tester);
    final switches = find.byType(SwitchListTile);
    // Then the filmstrip and HDR.
    expect(switches, findsNWidgets(Toggle.values.length + 2));
    for (final (i, toggle) in Toggle.values.indexed) {
      final tile = switches.at(i);
      expect(tester.widget<SwitchListTile>(tile).value, toggle.byDefault);
      await tester.tapAndSettle(tile);
      expect(settings().isOn(toggle), !toggle.byDefault, reason: '$toggle');
    }
  });

  testWidgets("the filmstrip's switch is on from 760 dp until turned off", (
    tester,
  ) async {
    final settings = await open(tester);
    final strip = find.widgetWithText(SwitchListTile, 'Filmstrip');
    expect(tester.widget<SwitchListTile>(strip).value, isTrue);
    await tester.tapAndSettle(strip);
    expect(settings().filmstrip, isFalse);
  });

  testWidgets("Photolib's trash keeps its items 60 days until 30 or 90 is "
      'chosen in Settings', (tester) async {
    await pumpApp(tester, size: const Size(800, 1800));
    await tester.tapAndSettle(find.byTooltip('Settings'));
    final container = ProviderScope.containerOf(
      tester.element(find.text('Settings')),
    );
    Settings settings() => container.read(settingsProvider);
    expect(settings().trashDays, 60);
    expect(find.text('How long Photolib keeps items in its trash'), findsOne);
    await tester.tapAndSettle(find.text('30 days'));
    expect(settings().trashDays, 30);
    await tester.tapAndSettle(find.text('90 days'));
    expect(settings().trashDays, 90);
  });

  testWidgets('the background behind transparent images is chosen', (
    tester,
  ) async {
    final settings = await open(tester);
    await tester.tapAndSettle(find.text('Checkerboard'));
    expect(settings().background, ViewerBackground.checkerboard);
  });

  // The labels of the toolbar's lists: in the bar, then in the ⋮ menu.
  (List<String>, List<String>) lists(WidgetTester tester) {
    final menu = tester.getTopLeft(find.text('In the ⋮ menu')).dy;
    final (bar, rest) = (<String>[], <String>[]);
    for (final tile in find.byType(ListTile).evaluate()) {
      final title = ((tile.widget as ListTile).title! as Text).data!;
      final y = tester.getTopLeft(find.byWidget(tile.widget)).dy;
      if (y > tester.getTopLeft(find.text('In the bar')).dy) {
        (y < menu ? bar : rest).add(title);
      }
    }
    return (bar, rest);
  }

  testWidgets('Settings › Viewer › Toolbar lists In the bar and In the ⋮ '
      'menu, moves pins up and down, removes, adds and resets them, and '
      'keeps them', (tester) async {
    final settings = await open(tester);
    await tester.tapAndSettle(find.text("Buttons in the viewer's bar"));
    const menu = ['Copy', 'Copy text', 'Rotate', 'Map', 'Set as', 'Slideshow'];
    expect(lists(tester).$1, [
      'Favourite',
      'Share',
      'Info',
      'Move to trash',
      'Edit',
      'Filmstrip',
    ]);
    expect(lists(tester).$2, [
      ...menu,
      'Hide',
      'Archive',
      'Add to album',
      'Keep offline',
    ]);
    await tester.tapAndSettle(find.byTooltip('Move Info up'));
    await tester.tapAndSettle(find.byTooltip('Move Edit down'));
    await tester.tapAndSettle(find.byTooltip('Remove Filmstrip from the bar'));
    await tester.tapAndSettle(find.byTooltip('Add Slideshow to the bar'));
    expect(lists(tester).$1, [
      'Favourite',
      'Info',
      'Share',
      'Move to trash',
      'Edit',
      'Slideshow',
    ]);
    expect(lists(tester).$2.take(3), ['Filmstrip', 'Copy', 'Copy text']);
    expect(settings().bar, [
      ViewerAction.favourite,
      ViewerAction.info,
      ViewerAction.share,
      ViewerAction.trash,
      ViewerAction.edit,
      ViewerAction.slideshow,
    ]);
    expect(
      tester
          .widget<IconButton>(
            find.widgetWithIcon(IconButton, Icons.arrow_upward).first,
          )
          .onPressed,
      isNull,
      reason: 'the first cannot move up',
    );
    await tester.tapAndSettle(find.text('Reset to default'));
    expect(settings().bar, defaultPins);
    expect(defaultPins, [
      ViewerAction.favourite,
      ViewerAction.share,
      ViewerAction.info,
      ViewerAction.trash,
      ViewerAction.edit,
      ViewerAction.filmstrip,
    ]);
  });

  test('a bar saved before the new default keeps its order', () {
    final decode = SettingsNotifier().decode;
    final saved = decode({
      'bar': ['info', 'favourite', 'trash'],
    });
    expect(saved.bar, [
      ViewerAction.info,
      ViewerAction.favourite,
      ViewerAction.trash,
    ]);
    expect(decode(<String, Object?>{}).bar, defaultPins);
    expect(decode(saved.toJson()).bar, saved.bar);
    expect(const Settings().toJson().containsKey('bar'), isFalse);
  });

  testWidgets('the toolbar is arranged with the keyboard alone', (
    tester,
  ) async {
    final settings = await open(tester);
    await tester.tapAndSettle(find.text("Buttons in the viewer's bar"));
    // Tabs to the button [tooltip] and presses it with Enter.
    Future<void> press(String tooltip) async {
      for (var i = 0; i < 80; i++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        final focused = FocusManager.instance.primaryFocus?.context;
        if (focused?.findAncestorWidgetOfExactType<Tooltip>()?.message ==
            tooltip) {
          await tester.sendKeyEvent(LogicalKeyboardKey.enter);
          await tester.pumpAndSettle();
          return;
        }
      }
      fail('no focus reaches $tooltip');
    }

    await press('Move Favourite down');
    await press('Remove Edit from the bar');
    await press('Add Rotate to the bar');
    expect(settings().bar, [
      ViewerAction.share,
      ViewerAction.favourite,
      ViewerAction.info,
      ViewerAction.trash,
      ViewerAction.filmstrip,
      ViewerAction.rotate,
    ]);
  });

  testWidgets('on a desktop a drag reorders the pins', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    final settings = await open(tester);
    await tester.tapAndSettle(find.text("Buttons in the viewer's bar"));
    final drag = await tester.startGesture(
      tester.getCenter(find.byIcon(Icons.drag_handle).at(1)),
    );
    for (var i = 0; i < 10; i++) {
      await drag.moveBy(const Offset(0, -10));
      await tester.pump(const Duration(milliseconds: 16));
    }
    await drag.up();
    await tester.pumpAndSettle();
    expect(settings().bar.take(2), [ViewerAction.info, ViewerAction.favourite]);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('the toolbar lists the actions this platform has', (
    tester,
  ) async {
    await open(tester);
    const pins = ['Favourite', 'Info', 'Move to trash', 'Edit', 'Filmstrip'];
    const veils = ['Slideshow', 'Hide', 'Archive'];
    for (final (platform, actions) in [
      (
        TargetPlatform.android,
        [
          'Favourite',
          'Share',
          ...pins.skip(1),
          'Copy',
          'Copy text',
          'Rotate',
          'Map',
          'Set as',
          ...veils,
          'Add to album',
          'Keep offline',
        ],
      ),
      (
        TargetPlatform.iOS,
        [
          'Favourite',
          'Share',
          ...pins.skip(1).where((p) => p != 'Edit'),
          'Copy text',
          'Rotate',
          'Map',
          ...veils,
          'Add to album',
          'Keep offline',
        ],
      ),
      (
        TargetPlatform.linux,
        [
          ...pins,
          'Download',
          'Copy text',
          'Show in folder',
          'Rotate',
          'Map',
          ...veils,
          'Add to album',
          'Keep offline',
        ],
      ),
    ]) {
      debugDefaultTargetPlatformOverride = platform;
      await tester.tapAndSettle(find.text("Buttons in the viewer's bar"));
      final (bar, menu) = lists(tester);
      expect([...bar, ...menu], actions, reason: '$platform');
      await tester.tapAndSettle(find.byType(BackButton));
      debugDefaultTargetPlatformOverride = null;
    }
  });
}
