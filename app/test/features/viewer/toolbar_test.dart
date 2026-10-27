import 'package:drift/drift.dart' show Value;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/features/settings/settings.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

import '../../support/fake_players.dart';
import '../../support/viewer.dart';

void main() {
  setUp(() => VideoPlayerPlatform.instance = FakePlayers());

  // A photo, a video and a photo sphere.
  Future<void> pump(
    WidgetTester tester,
    double width,
    int at, {
    Settings settings = const Settings(),
  }) => pumpViewer(
    tester,
    size: Size(width, 700),
    count: 3,
    at: at,
    ids: true,
    video: (p) => p == 1,
    settings: settings,
    rowOf: (item) => item.key == '2'
        ? row(item).copyWith(
            projection: const Value('equirectangular'),
            width: const Value(4000),
            height: const Value(2000),
          )
        : row(item),
  );

  final bar = find.ancestor(
    of: find.byType(CloseButton),
    matching: find.byType(Row),
  );

  // The tooltip and place of each of the bar's buttons, in order.
  List<(String?, Rect)> buttons(WidgetTester tester) => [
    for (final b
        in find
            .descendant(of: bar.first, matching: find.byType(IconButton))
            .evaluate())
      (
        (b.widget as IconButton).tooltip,
        tester.getRect(find.byWidget(b.widget)),
      ),
  ];

  const pins = [
    'Favourite',
    'Share',
    'Info',
    'Move to trash',
    'Edit',
    'Filmstrip',
  ];

  testWidgets('the bar has no date and the same buttons in the same slots for '
      'a photo, a video and a 360° item at every width, the last pins folded '
      'into ⋮ first', (tester) async {
    for (final (width, shown) in [
      (320.0, 2),
      (390.0, 2),
      (520.0, 4),
      (760.0, 6),
      (1100.0, 6),
    ]) {
      final slots = <List<(String?, Rect)>>[];
      for (final at in [0, 1, 2]) {
        await pump(tester, width, at);
        expect(
          find.descendant(of: bar.first, matching: find.byType(Text)),
          findsNothing,
          reason: 'no date, title or counter at $width',
        );
        final found = buttons(tester);
        expect(
          [for (final (tip, _) in found) tip],
          ['Close', ...pins.take(shown), 'More'],
          reason: 'item $at at $width',
        );
        for (final (tip, rect) in found) {
          expect(rect.left, greaterThanOrEqualTo(0), reason: '$tip');
          expect(rect.right, lessThanOrEqualTo(width), reason: '$tip');
        }
        slots.add(found);
        await tester.pumpWidget(const SizedBox());
      }
      expect(slots[1], slots[0], reason: 'a video as a photo at $width');
      expect(slots[2], slots[0], reason: 'a sphere as a photo at $width');
    }
  });

  testWidgets('⋮ lists the folded pins, then the others in their fixed order, '
      'a divider and Customize toolbar, which opens its settings', (
    tester,
  ) async {
    await pump(tester, 390, 0);
    await tester.tap(find.byTooltip('More'));
    await tester.pumpAndSettle();
    final entries = [
      for (final e
          in find
              .descendant(
                of: find.byType(MenuAnchor).last,
                matching: find.byWidgetPredicate(
                  (w) => w is MenuItemButton || w is Divider,
                ),
                skipOffstage: false,
              )
              .evaluate())
        switch (e.widget) {
          MenuItemButton(:final Text child) => child.data,
          _ => '—',
        },
    ];
    expect(entries, [
      'Info',
      'Move to trash',
      'Edit',
      'Filmstrip',
      'Rotate',
      'Slideshow',
      'Hide',
      'Archive',
      'Add to album',
      '—',
      'Customize toolbar…',
    ]);
    // Escape closes the menu, not the viewer.
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('Customize toolbar…'), findsNothing);
    expect(find.byTooltip('More'), findsOneWidget);
    await tester.tap(find.byTooltip('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Customize toolbar…'));
    await tester.pumpAndSettle();
    expect(find.text('In the bar'), findsOneWidget);
  });

  testWidgets("the user's pins show in their order through the fold rule", (
    tester,
  ) async {
    await pump(
      tester,
      520,
      0,
      settings: const Settings(
        bar: [
          ViewerAction.slideshow,
          ViewerAction.info,
          ViewerAction.rotate,
          ViewerAction.favourite,
          ViewerAction.hide,
        ],
      ),
    );
    expect(
      [for (final (tip, _) in buttons(tester)) tip],
      ['Close', 'Slideshow', 'Info', 'Rotate', 'Favourite', 'More'],
    );
    await tester.tap(find.byTooltip('More'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(MenuItemButton, 'Hide'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
  });
}
