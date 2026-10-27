import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/l10n/app_localizations.dart';
import 'package:photolib/ui/selection_bar.dart';

void main() {
  late List<String> calls;

  Future<void> pumpBar(
    WidgetTester tester, {
    required int count,
    bool selectAll = true,
    bool slideshow = true,
  }) async {
    calls = [];
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          appBar: SelectionBar(
            count: count,
            onClear: () => calls.add('clear'),
            onSelectAll: selectAll ? () => calls.add('all') : null,
            onSlideshow: slideshow ? () => calls.add('slideshow') : null,
            onDownload: () => calls.add('download'),
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite_border),
                tooltip: 'Favourite',
                onPressed: () => calls.add('favourite'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  testWidgets('counts the selection', (tester) async {
    await pumpBar(tester, count: 1);
    expect(find.text('1 selected'), findsOneWidget);
    await pumpBar(tester, count: 1200);
    expect(find.text('1,200 selected'), findsOneWidget);
  });

  testWidgets('clears, selects all, plays a slideshow, downloads and runs '
      'its actions', (tester) async {
    await pumpBar(tester, count: 3);
    for (final tooltip in [
      'Clear selection',
      'Select all',
      'Slideshow',
      'Download',
      'Favourite',
    ]) {
      await tester.tap(find.byTooltip(tooltip));
    }
    expect(calls, ['clear', 'all', 'slideshow', 'download', 'favourite']);
  }, variant: TargetPlatformVariant.desktop());

  testWidgets(
    'shares on phones, where it would download',
    (tester) async {
      await pumpBar(tester, count: 3);
      expect(find.byTooltip('Download'), findsNothing);
      await tester.tap(find.byTooltip('Share'));
      expect(calls, ['download']);
    },
    variant: const TargetPlatformVariant({
      TargetPlatform.android,
      TargetPlatform.iOS,
    }),
  );

  // A folder's bar: select all, a slideshow, share and seven actions.
  Future<void> pumpFolderBar(
    WidgetTester tester, {
    required double width,
    double textScale = 1,
  }) async {
    calls = [];
    tester.view
      ..devicePixelRatio = 1
      ..physicalSize = Size(width, 800);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        ),
        home: Scaffold(
          appBar: SelectionBar(
            count: 1200,
            onClear: () {},
            onSelectAll: () => calls.add('all'),
            onSlideshow: () => calls.add('slideshow'),
            onDownload: () => calls.add('download'),
            actions: [
              for (final (icon, label) in [
                (Icons.drive_file_rename_outline, 'Rename'),
                (Icons.drive_file_move_outlined, 'Move to'),
                (Icons.file_copy_outlined, 'Copy to'),
                (Icons.favorite_border, 'Favourite'),
                (Icons.delete_outline, 'Move to trash'),
              ])
                IconButton(
                  icon: Icon(icon),
                  tooltip: label,
                  onPressed: () => calls.add(label),
                ),
              PopupMenuButton<VoidCallback>(
                itemBuilder: (_) => const [],
                tooltip: 'Hide or archive',
              ),
              IconButton(
                icon: const Icon(Icons.check),
                tooltip: 'Add to album',
                onPressed: () => calls.add('Add to album'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  const labels = [
    'Select all',
    'Slideshow',
    'Share',
    'Rename',
    'Move to',
    'Copy to',
    'Favourite',
    'Move to trash',
    'Add to album',
  ];

  testWidgets('what does not fit folds into a menu, in any width and text '
      'size, and the count keeps its size', (tester) async {
    await pumpFolderBar(tester, width: 1000);
    expect(find.byTooltip('More'), findsNothing, reason: 'all fit');
    final size = tester.getSize(find.text('1,200 selected'));
    for (final (width, scale) in [
      (412.0, 1.0),
      (320.0, 1.0),
      (400.0, 2.0),
      (600.0, 1.0),
    ]) {
      await pumpFolderBar(tester, width: width, textScale: scale);
      expect(tester.takeException(), isNull, reason: '$width x $scale');
      if (scale == 1) {
        expect(
          tester.getSize(find.text('1,200 selected')).height,
          greaterThanOrEqualTo(size.height - 1),
          reason: 'the count is not shrunk at $width',
        );
      }
      // Every action is on the bar or in its menu, and never both.
      final onBar = [
        for (final label in labels)
          if (find.byTooltip(label).evaluate().isNotEmpty) label,
      ];
      expect(find.byTooltip('Hide or archive'), findsOneWidget);
      if (find.byTooltip('More').evaluate().isNotEmpty) {
        await tester.tap(find.byTooltip('More'));
        await tester.pumpAndSettle();
      }
      final inMenu = [
        for (final label in labels)
          if (find.text(label).evaluate().isNotEmpty) label,
      ];
      expect(
        [...onBar, ...inMenu]..sort(),
        [...labels]..sort(),
        reason: '$width',
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
    }
    await pumpFolderBar(tester, width: 412);
    await tester.tap(find.byTooltip('More'));
    await tester.pumpAndSettle();
    expect(find.text('Rename'), findsOneWidget);
    await tester.tap(find.text('Rename'));
    await tester.pumpAndSettle();
    expect(calls, ['Rename']);
  });

  testWidgets('offers select all and a slideshow only when it can', (
    tester,
  ) async {
    await pumpBar(tester, count: 3, selectAll: false, slideshow: false);
    expect(find.byTooltip('Select all'), findsNothing);
    expect(find.byTooltip('Slideshow'), findsNothing);
  });
}
