import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/features/library/timeline/buckets.dart';
import 'package:photolib/features/library/timeline/layout.dart';
import 'package:photolib/features/library/timeline/pages.dart';
import 'package:photolib/features/library/timeline/scrubber.dart';
import 'package:photolib/features/library/timeline/selection.dart';
import 'package:photolib/features/library/timeline/thumb_hash.dart';
import 'package:photolib/features/library/timeline/thumbnails.dart';
import 'package:photolib/features/library/timeline/timeline_row.dart';
import 'package:photolib/features/library/timeline/timeline_view.dart';
import 'package:photolib/l10n/app_localizations.dart';

void main() {
  // 3,000 days of 1 to 99 assets, one a day back from 4 March 2025.
  final days = [for (var d = 0; d < 3000; d++) DateTime(2025, 3, 4 - d)];
  final buckets = TimelineBuckets(
    days: [for (final d in days) d.year * 10000 + d.month * 100 + d.day],
    counts: [for (var d = 0; d < 3000; d++) 1 + d * 37 % 99],
  );
  final requested = <Object>[];
  final cancelled = <Object>[];
  late Thumbnails thumbnails;
  // Each position's item is its number.
  final pages = TimelinePages(
    (first, count) async => [
      for (var a = first; a < first + count && a < buckets.assets; a++) a,
    ],
  );
  final selection = ValueNotifier(Selection.none);
  final opened = <(Object, Rect)>[];
  final seen = <(int, int)>[];
  final view = GlobalKey<TimelineViewState>();
  final density = ValueNotifier(Density.days);
  final zoomed = <Density>[];
  // The reference's landscape gradient: red grows to the right, green down.
  final gradient = switch (jsonDecode(
    File('../testdata/thumbhash.json').readAsStringSync(),
  )) {
    {'cases': [{'hash': final String hash}, ...]} => ThumbHash.tryParse(
      base64.decode(hash),
    )!,
    _ => throw StateError('no ThumbHash case'),
  };

  Future<void> pump(
    WidgetTester tester, {
    bool decode = true,
    Future<ui.Image> Function(int asset, ui.Image tile, int tier)? source,
    bool Function(int asset)? cached,
    Duration? Function(Object asset)? duration,
    bool Function(Object asset)? sphere,
    (IconData, String)? Function(Object asset)? badge,
    int concurrency = 1,
    Density at = Density.days,
  }) async {
    tester.view.physicalSize = const Size(400, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    requested.clear();
    cancelled.clear();
    selection.value = Selection.none;
    opened.clear();
    seen.clear();
    density.value = at;
    zoomed.clear();
    final recorder = ui.PictureRecorder();
    ui.Canvas(recorder);
    final tile = recorder.endRecording().toImageSync(256, 256);
    thumbnails = Thumbnails(concurrency: concurrency, (asset, tier, t) {
      requested.add(asset);
      unawaited(t.cancelled.then((_) => cancelled.add(asset)));
      if (source != null) return source(asset as int, tile, tier);
      return decode ? Future.value(tile.clone()) : Completer<ui.Image>().future;
    }, cached: cached == null ? null : (asset, _) => cached(asset as int));
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          body: ValueListenableBuilder(
            valueListenable: density,
            builder: (context, at, _) => TimelineView(
              key: view,
              buckets: buckets,
              pages: pages,
              thumbnails: thumbnails,
              selection: selection,
              placeholder: (asset) => (asset as int).isEven ? gradient : null,
              duration: duration,
              sphere: sphere,
              badge: badge,
              density: at,
              onDensity: (to) => density.value = (zoomed..add(to)).last,
              onOpen: (asset, rect) => opened.add((asset, rect)),
              onVisible: (first, last) => seen.add((first, last)),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// What the repaint boundary around [row] shows, and its width.
  Future<(ByteData, int)> rowPixels(WidgetTester tester, Finder row) async {
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.ancestor(of: row, matching: find.byType(RepaintBoundary)).first,
    );
    final image = await tester.runAsync(boundary.toImage);
    final pixels = await tester.runAsync(image!.toByteData);
    return (pixels!, boundary.size.width.round());
  }

  List<int> visibleAssets() {
    final (first, last) = view.currentState!.visible;
    return [for (var a = first; a <= last; a++) a];
  }

  bool shown(int a) =>
      thumbnails.get(a, tierFor(view.currentState!.layout.cellExtent)) != null;

  testWidgets('decodes the visible cells first, at the tier of their size', (
    tester,
  ) async {
    await pump(tester);
    final visible = visibleAssets();
    expect(requested.take(visible.length), visible);
    expect(visible.every(shown), isTrue);
    expect(find.text('Mar 4, 2025'), findsOneWidget);
  });

  // A rendition not rendered yet or out of reach is asked again in 1 s.
  Future<ui.Image> notYet(int _, ui.Image _, int _) async =>
      throw const Pending('not rendered yet');
  for (final (until, source) in [('is decoded', null), ('is there', notYet)]) {
    testWidgets('a cell paints its ThumbHash until its thumbnail $until', (
      tester,
    ) async {
      await pump(tester, decode: false, source: source);
      await tester.pump(const Duration(seconds: 1));
      expect(requested.where((a) => a == 0), hasLength(source == null ? 1 : 2));
      final row = find.byType(TimelineRow);
      final (pixels, width) = await rowPixels(tester, row.at(1));
      List<int> at(int x, int y) => [
        for (var c = 0; c < 3; c++) pixels.getUint8((y * width + x) * 4 + c),
      ];
      // The second row, of three 133 px cells: assets 1 and 3 have no hash.
      final (r, g, b, _) = gradient.at(0.5, 0.5);
      expect(at(200, 66), [
        for (final v in [r, g, b]) closeTo(255 * v, 8),
      ]);
      expect(at(143, 66)[0], lessThan(at(256, 66)[0]), reason: 'redder right');
      expect(at(200, 10)[1], lessThan(at(200, 123)[1]), reason: 'greener down');
      final none = Theme.of(tester.element(row.first))
          .colorScheme
          .surfaceContainerHighest;
      expect(at(66, 66), [
        for (final v in [none.r, none.g, none.b]) closeTo(255 * v, 1),
      ]);
    });
  }

  testWidgets('a failed or hung decode marks its cell and the others still '
      'decode, with no relayout', (tester) async {
    final semantics = tester.ensureSemantics();
    await pump(
      tester,
      source: (asset, tile, _) async => switch (asset) {
        0 => throw StateError('corrupt'),
        1 => await Completer<ui.Image>().future,
        2 => throw const NoThumbnail(video: true, cause: 'macos: refused'),
        _ => tile.clone(),
      },
    );
    final tier = tierFor(view.currentState!.layout.cellExtent);
    expect(thumbnails.get(3, tier), isNull, reason: 'behind the hung decode');
    await tester.pump(const Duration(seconds: 10));
    await tester.pumpAndSettle();
    expect(thumbnails.failure(0, tier), isA<StateError>());
    expect(thumbnails.failure(1, tier), isA<TimeoutException>());
    expect(thumbnails.failure(2, tier), isA<NoThumbnail>());
    expect(visibleAssets().skip(3).every(shown), isTrue);
    // How many pixels of each cell of a row have the mark's colour.
    final row = find.byType(TimelineRow);
    final mark = Theme.of(tester.element(row.first))
        .colorScheme
        .onSurfaceVariant;
    Future<List<int>> marked(int index) async {
      final (pixels, _) = await rowPixels(tester, row.at(index));
      bool close(int x, int y) => [
        for (final (c, v) in [(0, mark.r), (1, mark.g), (2, mark.b)])
          (pixels.getUint8((y * 400 + x) * 4 + c) - 255 * v).abs() < 2,
      ].every((c) => c);
      return [
        for (var cell = 0; cell < 3; cell++)
          [
            for (var y = 0; y < 133; y++)
              for (var x = cell * 133; x < cell * 133 + 133; x++) close(x, y),
          ].where((c) => c).length,
      ];
    }

    expect(await marked(0), [greaterThan(50), 0, 0], reason: 'asset 0');
    expect(await marked(1), [greaterThan(50), greaterThan(50), 0]);
    // A marked cell says why when the pointer rests on it.
    for (final (asset, why) in [
      (0, 'Bad state: corrupt'),
      (1, 'TimeoutException after 0:00:10.000000: no thumbnail'),
      (2, 'macos: refused'),
    ]) {
      expect(
        tester.getCenter(find.byTooltip(why)),
        view.currentState!.cellOf(asset).center,
      );
    }
    expect(find.semantics.byLabel('Mar 4, 2025, 1 of 1, no preview'), findsOne);
    semantics.dispose();
  });

  testWidgets("a video cell shows its duration, a sphere's a 360° badge at "
      'its top end; one that cannot play says why; a badge sits at the '
      'bottom start, said too', (tester) async {
    final semantics = tester.ensureSemantics();
    final recorder = ui.PictureRecorder();
    ui.Canvas(recorder).drawPaint(ui.Paint()..color = const Color(0xFFFFFFFF));
    final white = recorder.endRecording().toImageSync(256, 256);
    await pump(
      tester,
      source: (asset, _, _) async => asset == 0
          ? throw const NoThumbnail(
              video: true,
              unplayable: true,
              cause: 'player: refused',
            )
          : white.clone(),
      duration: (asset) => switch (asset) {
        0 => const Duration(seconds: 65),
        1 => const Duration(hours: 1, minutes: 2, seconds: 3),
        _ => null,
      },
      sphere: (asset) => asset == 1 || asset == 2,
      badge: (asset) =>
          asset == 3 ? (Icons.cloud_outlined, 'Cloud only') : null,
    );
    expect(
      find.semantics
          .byLabel('Mar 4, 2025, 1 of 1, no preview')
          .evaluate()
          .single,
      isSemantics(value: '1:05', hint: "Can't play in this browser"),
    );
    for (final (n, value, tooltip) in [
      (1, '360°, 1:02:03', ''),
      (2, '360°', ''),
      (3, '', 'Cloud only'),
    ]) {
      final cell = find.semantics.byLabel('Mar 3, 2025, $n of 38');
      expect(
        cell.evaluate().single,
        isSemantics(value: value, hint: '', tooltip: tooltip),
      );
    }
    // The bottom end corner of each white cell of the second row: a
    // duration's scrim darkens it, and the top end a sphere's badge.
    final row = find.byType(TimelineRow);
    final (pixels, _) = await rowPixels(tester, row.at(1));
    int dark(int cell, {int top = 100, int start = 66, int width = 64}) => [
      for (var y = top; y < top + 30; y++)
        for (var x = cell * 133 + start; x < cell * 133 + start + width; x++)
          pixels.getUint8((y * 400 + x) * 4) < 128,
    ].where((d) => d).length;
    final some = greaterThan(20);
    expect([dark(0), dark(1), dark(2)], [some, 0, 0]);
    expect(
      [dark(0, top: 4), dark(1, top: 4), dark(2, top: 4)],
      [some, some, 0],
    );
    // Asset 3's badge sits at the bottom start, the state's corner (ADR-0215).
    expect(
      [dark(1, start: 2, width: 20), dark(2, start: 2, width: 20)],
      [0, some],
    );
    semantics.dispose();
  });

  testWidgets('decoded cells paint their thumbnails at full opacity next to '
      'a video badge, also when painted again', (tester) async {
    const colour = Color(0xFFC0285A);
    final recorder = ui.PictureRecorder();
    ui.Canvas(recorder).drawPaint(ui.Paint()..color = colour);
    final tile = recorder.endRecording().toImageSync(256, 256);
    await pump(
      tester,
      source: (_, _, _) async => tile.clone(),
      duration: (_) => const Duration(seconds: 5),
    );
    final row = find.byType(TimelineRow);
    // As after scrolling away and back: the row paints over its last badges.
    tester.renderObject(row.at(1)).markNeedsPaint();
    await tester.pump();
    final (pixels, _) = await rowPixels(tester, row.at(1));
    List<int> at(int x, int y) => [
      for (var c = 0; c < 4; c++) pixels.getUint8((y * 400 + x) * 4 + c),
    ];
    final source = [
      for (final v in [colour.r, colour.g, colour.b, colour.a])
        (255 * v).round(),
    ];
    expect([at(66, 40), at(200, 40), at(333, 40)], [source, source, source]);
  });

  testWidgets('memory pressure drops the images, then decodes what is seen', (
    tester,
  ) async {
    await pump(tester);
    final before = requested.length;
    tester.binding.handleMemoryPressure();
    expect(shown(visibleAssets().first), isFalse);
    await tester.pumpAndSettle();
    expect(
      requested.skip(before).take(visibleAssets().length),
      visibleAssets(),
    );
    expect(visibleAssets().every(shown), isTrue);
  });

  testWidgets('a month is one jump away', (tester) async {
    await pump(tester);
    view.currentState!.jumpToMonth(2020, 2);
    await tester.pump();
    expect(find.text('Feb 29, 2020'), findsOneWidget);
    expect(tester.getTopLeft(find.text('Feb 29, 2020')).dy, lessThan(48));
  });

  testWidgets('the scrubber jumps anywhere; while it moves fast, cached '
      'tiles show and decodes wait, and once it is held still they come, '
      'before the release', (tester) async {
    await pump(tester, cached: (asset) => asset.isEven);
    final scrubber = tester.getRect(find.byType(TimelineScrubber));
    final gesture = await tester.startGesture(
      scrubber.topCenter + const Offset(0, 10),
    );
    await gesture.moveTo(scrubber.center);
    final before = requested.length;
    await tester.pump();
    final controller = view.currentState!.controller;
    expect(
      controller.offset / controller.position.maxScrollExtent,
      closeTo(0.5, 0.05),
    );
    final visible = visibleAssets();
    expect(
      [for (final a in visible) shown(a)],
      [for (final a in visible) a.isEven],
      reason: 'cached tiles only, while the thumb outruns decodes',
    );
    final day = buckets.day(
      view.currentState!.layout.segmentAt(controller.offset),
    )!;
    expect(
      find.text(DateFormat.yMMM('en').format(day)),
      findsOneWidget,
      reason: 'the date bubble',
    );
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump();
    expect(
      requested.skip(before).where((a) => (a as int).isOdd).take(2),
      visible.where((a) => a.isOdd).take(2),
      reason: 'held still: decodes start',
    );
    expect(visible.every(shown), isTrue);
    await gesture.up();
  });

  testWidgets('a fling decodes the cells in view as it goes', (tester) async {
    await pump(tester);
    final before = requested.length;
    final position =
        view.currentState!.controller.position
              as ScrollPositionWithSingleContext
          ..goBallistic(8000);
    // 30 frames at this speed scroll several screens past what was decoded.
    for (var frame = 0; frame < 30; frame++) {
      await tester.pump(const Duration(milliseconds: 16));
      expect(position.isScrollingNotifier.value, isTrue);
      expect(
        visibleAssets().every(shown),
        isTrue,
        reason: 'frame $frame of the fling',
      );
    }
    expect(visibleAssets().first, greaterThan(before));
    await tester.pumpAndSettle();
  });

  testWidgets('a cell shows a smaller tier scaled up until its own arrives, '
      'which replaces it in one frame', (tester) async {
    final large = <int, Completer<ui.Image>>{};
    await pump(
      tester,
      source: (asset, tile, tier) => tier == 128
          ? Future.value(tile.clone())
          : (large[asset] = Completer()).future,
    );
    final state = view.currentState!..zoom(-1);
    await tester.pumpAndSettle();
    final small = tierFor(state.layout.cellExtent);
    expect(small, 128);
    state.zoom(1);
    await tester.pump();
    await tester.pump();
    final tier = tierFor(state.layout.cellExtent);
    expect(tier, 256);
    final asset = visibleAssets().first;
    expect(thumbnails.get(asset, tier), isNull);
    final row = tester.renderObject<RenderCustomPaint>(
      find
          .descendant(
            of: find.byType(TimelineRow),
            matching: find.byType(CustomPaint),
          )
          .first,
    );
    final smaller = thumbnails.get(asset, small)!;
    expect(row, paints..drawImageRect(image: smaller));
    final own = smaller.clone();
    large[asset]!.complete(own);
    await tester.pump();
    expect(row, paints..drawImageRect(image: own));
  });

  // The asset under a point of the view.
  int under(Offset point) {
    final state = view.currentState!;
    return state.layout
        .assetAt(
          state.controller.offset + point.dy,
          point.dx ~/ state.layout.cellExtent,
        )
        .$1;
  }

  Future<void> pinch(
    WidgetTester tester,
    Offset focal,
    double from,
    double to,
  ) async {
    final a = await tester.startGesture(focal - Offset(from, 0), pointer: 1);
    final b = await tester.startGesture(focal + Offset(from, 0), pointer: 2);
    for (var step = 1; step <= 4; step++) {
      final d = from + (to - from) * step / 4;
      await a.moveTo(focal - Offset(d, 0));
      await b.moveTo(focal + Offset(d, 0));
      await tester.pump();
    }
    await a.up();
    await b.up();
    await tester.pumpAndSettle();
  }

  testWidgets('a pinch snaps to a density, the item under the fingers stays', (
    tester,
  ) async {
    await pump(tester);
    view.currentState!.controller.jumpTo(5000);
    await tester.pumpAndSettle();
    const focal = Offset(200, 300);
    final asset = under(focal);
    expect(view.currentState!.layout.columns, 3);

    await pinch(tester, focal, 80, 40);
    expect(view.currentState!.density, Density.months);
    expect(view.currentState!.layout.columns, 7);
    expect(under(focal) ~/ 7, asset ~/ 7, reason: 'its row, now of 7');
    expect(view.currentState!.segments.days.take(2), [20250301, 20250201]);

    final now = under(focal);
    await pinch(tester, focal, 40, 160);
    expect(view.currentState!.density, Density.comfortable);
    expect((under(focal) - now).abs(), lessThan(7));
  });

  testWidgets('zoom steps through the densities as buttons do, telling its '
      'parent, whose own changes it follows', (tester) async {
    await pump(tester, at: Density.months);
    final state = view.currentState!;
    expect(state.layout.columns, 7);
    state.zoom(1);
    await tester.pump();
    expect(state.density, Density.days);
    state.zoom(-5);
    await tester.pump();
    expect(state.density, Density.years);
    expect(state.layout.columns, 12);
    state.zoom(9);
    await tester.pump();
    expect(state.density, Density.comfortable);
    expect(zoomed, [Density.days, Density.years, Density.comfortable]);

    // As settings read after the first frame do.
    density.value = Density.months;
    await tester.pumpAndSettle();
    expect(state.density, Density.months);
    expect(state.layout.columns, 7);
    expect(zoomed, hasLength(3), reason: "the parent's own change");
  });

  testWidgets('a long press then a drag selects across days, scrolling at '
      'the bottom edge with half the decodes', (tester) async {
    await pump(tester, decode: false, concurrency: 2);
    int running() => requested.length - cancelled.length;
    expect(running(), 2);
    // Day 0 has one asset, day 1 38 from the second row on.
    final start = under(const Offset(200, 300));
    final drag = await tester.startGesture(const Offset(200, 300));
    await tester.pump(kLongPressTimeout + const Duration(milliseconds: 50));
    expect(selection.value.ranges, [(start, start + 1)]);
    await drag.moveTo(const Offset(200, 300));
    await drag.moveTo(const Offset(200, 595));
    for (var i = 0; i < 120; i++) {
      await tester.pump(const Duration(milliseconds: 16));
    }
    final end = under(const Offset(200, 595));
    expect(view.currentState!.controller.offset, greaterThan(1000));
    expect(selection.value.ranges, [(start, end + 1)]);
    expect(end, greaterThan(1 + buckets.counts[1]), reason: 'into day 2');
    expect(running(), 1, reason: 'scrolling');
    await drag.moveTo(const Offset(200, 300));
    await tester.pump(const Duration(milliseconds: 16));
    expect(running(), 2, reason: 'held still');
    final back = under(const Offset(200, 300));
    expect(selection.value.ranges, [(start, back + 1)]);
    await drag.up();
    await tester.pumpAndSettle();
    expect(selection.value.ranges, [(start, back + 1)]);
  });

  testWidgets('a tap opens a cell, from where it is', (tester) async {
    await pump(tester);
    await tester.tapAt(const Offset(200, 100));
    expect(opened, isEmpty, reason: 'no cell there');
    await tester.tapAt(const Offset(200, 300));
    expect(opened.single.$1, 2);
    final cell = view.currentState!.layout.cellExtent;
    expect(opened.single.$2, Rect.fromLTWH(cell, 48 + cell + 48, cell, cell));
  });

  testWidgets('reveal scrolls the least that shows an item, whose cell the '
      'viewer shrinks back into', (tester) async {
    await pump(tester);
    final state = view.currentState!;
    final last = buckets.assets - 1;
    state.reveal(last);
    await tester.pump();
    final (first, end) = state.visible;
    expect(last, inInclusiveRange(first, end));
    final offset = state.controller.offset;
    final screen = Offset.zero & const Size(400, 600);
    expect(screen.contains(state.cellOf(last).center), isTrue);
    state.reveal(last - 1);
    expect(state.controller.offset, offset, reason: 'already shown');
    state.reveal(0);
    await tester.pump();
    expect(state.cellOf(0).top, TimelineViewState.headerExtent);
  });

  testWidgets('while selecting, a tap toggles and a shift tap adds the range '
      'since the last', (tester) async {
    await pump(tester);
    await tester.longPressAt(const Offset(10, 60));
    await tester.tapAt(const Offset(10, 300));
    expect(selection.value.ranges, [(0, 2)]);
    await tester.tapAt(const Offset(10, 60));
    expect(selection.value.ranges, [(1, 2)]);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await tester.tapAt(const Offset(10, 500));
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    expect(selection.value.ranges, [(0, 8)]);
    expect(opened, isEmpty);
  });

  testWidgets('a header selects its day, or clears it', (tester) async {
    await pump(tester);
    await tester.tap(find.text('Mar 4, 2025'));
    expect(selection.value.ranges, [(0, buckets.counts[0])]);
    await tester.pump();
    await tester.tap(find.text('Mar 4, 2025'));
    expect(selection.value.isEmpty, isTrue);
  });

  testWidgets('a header check lies clear of the scrubber, whose thumb rests '
      'beside the first one', (tester) async {
    await pump(tester);
    await tester.longPressAt(const Offset(10, 300));
    await tester.pump();
    final check = find.byIcon(Icons.radio_button_unchecked).first;
    final scrubber = tester.getRect(find.byType(TimelineScrubber));
    expect(tester.getRect(check).right, lessThanOrEqualTo(scrubber.left));
    await tester.tap(check);
    expect(selection.value.containsAll(0, 2), isTrue);
  });

  testWidgets('Ctrl+A selects everything and Escape clears it', (tester) async {
    await pump(tester);
    await tester.tapAt(const Offset(10, 60), kind: PointerDeviceKind.mouse);
    await tester.pump();
    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    expect(selection.value.ranges, [(0, buckets.assets)]);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    expect(selection.value.isEmpty, isTrue);
  });

  testWidgets('the header of the segment at the top sticks until the next '
      'pushes it away', (tester) async {
    await pump(tester);
    final state = view.currentState!;
    state.controller.jumpTo(state.layout.segmentOffset(2) + 500);
    await tester.pump();
    // The sticky header paints over the list, whose own is cached above.
    final top = tester.getTopLeft(find.text('Mar 2, 2025').last).dy;
    expect(top, inInclusiveRange(0, 48));
    state.controller.jumpTo(state.layout.segmentOffset(3) - 20);
    await tester.pump();
    expect(
      tester.getTopLeft(find.text('Mar 2, 2025').last).dy,
      closeTo(top - 28, 0.01),
    );
    await tester.tap(find.text('Mar 1, 2025').first);
    expect(selection.value.ranges, [state.layout.assetsOf(3)]);
  });

  testWidgets('arrow keys move a visible focus through the cells and across '
      'days, Space and Shift select, Enter opens (docs/17 §5)', (tester) async {
    await pump(tester);
    final state = view.currentState!;
    final columns = state.layout.columns;
    Future<int?> press(LogicalKeyboardKey key, {bool shift = false}) async {
      if (shift) await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      await tester.sendKeyEvent(key);
      if (shift) await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      await tester.pumpAndSettle();
      return state.cursor;
    }

    // The first arrow puts the focus on the first cell shown, ringed.
    expect(await press(LogicalKeyboardKey.arrowDown), 0);
    expect(
      tester.getRect(find.byKey(const ValueKey('cursor'))),
      state.cellOf(0),
    );
    expect(await press(LogicalKeyboardKey.arrowLeft), 0);
    // Day 0 has one asset: down crosses the next day's header.
    expect(await press(LogicalKeyboardKey.arrowDown), 1);
    expect(await press(LogicalKeyboardKey.arrowDown), 1 + columns);
    expect(await press(LogicalKeyboardKey.arrowUp), 1);
    expect(await press(LogicalKeyboardKey.arrowUp), 0);
    expect(await press(LogicalKeyboardKey.arrowRight), 1);
    expect(await press(LogicalKeyboardKey.arrowRight), 2);
    expect(
      tester.getRect(find.byKey(const ValueKey('cursor'))),
      state.cellOf(2),
    );

    await press(LogicalKeyboardKey.space);
    expect(selection.value.ranges, [(2, 3)]);
    expect(await press(LogicalKeyboardKey.arrowRight, shift: true), 3);
    expect(await press(LogicalKeyboardKey.arrowRight, shift: true), 4);
    expect(selection.value.ranges, [(2, 5)]);
    await press(LogicalKeyboardKey.space);
    expect(selection.value.ranges, [(2, 4)]);

    selection.value = Selection.none;
    await press(LogicalKeyboardKey.enter);
    expect(opened.single.$1, 4);

    // A click hides the focus.
    await tester.tapAt(const Offset(10, 300), kind: PointerDeviceKind.mouse);
    await tester.pumpAndSettle();
    expect(state.cursor, isNull);
    expect(find.byKey(const ValueKey('cursor')), findsNothing);
  });

  testWidgets('Page Down, Page Up, End and Home scroll by screens', (
    tester,
  ) async {
    await pump(tester);
    await tester.tapAt(const Offset(10, 60));
    await tester.pumpAndSettle();
    final controller = view.currentState!.controller;
    Future<double> press(LogicalKeyboardKey key) async {
      await tester.sendKeyEvent(key);
      await tester.pumpAndSettle();
      return controller.offset;
    }

    expect(await press(LogicalKeyboardKey.pageDown), closeTo(540, 0.01));
    expect(await press(LogicalKeyboardKey.pageDown), closeTo(1080, 0.01));
    expect(await press(LogicalKeyboardKey.pageUp), closeTo(540, 0.01));
    expect(
      await press(LogicalKeyboardKey.end),
      controller.position.maxScrollExtent,
    );
    expect(await press(LogicalKeyboardKey.home), 0);
  });

  testWidgets('dragging the scrubber ticks at each year it crosses', (
    tester,
  ) async {
    await pump(tester);
    final haptics = <Object?>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'HapticFeedback.vibrate') {
          haptics.add(call.arguments);
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
    final scrubber = tester.getRect(find.byType(TimelineScrubber));
    final drag = await tester.startGesture(
      scrubber.topCenter + const Offset(0, 30),
    );
    for (var y = 30.0; y < scrubber.height - 30; y += 10) {
      await drag.moveTo(scrubber.topCenter + Offset(0, y));
      await tester.pump();
    }
    await drag.up();
    // 4 March 2025 back to December 2016: eight or nine years begin.
    expect(haptics, hasLength(inInclusiveRange(7, 9)));
  });

  testWidgets('a screen reader steps the scrubber a month at a time', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pump(tester);
    final scrubber = find.semantics.byLabel('Scroll by date');
    tester.semantics.performAction(scrubber, SemanticsAction.increase);
    await tester.pump();
    expect(find.text('Feb 28, 2025'), findsOneWidget);
    tester.semantics.performAction(scrubber, SemanticsAction.increase);
    tester.semantics.performAction(scrubber, SemanticsAction.decrease);
    await tester.pump();
    expect(scrubber.evaluate().single.value, 'Feb 2025');
    semantics.dispose();
  });

  testWidgets('each cell says its day and place, and whether it is selected', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pump(tester);
    final cell = find.semantics.byLabel('Mar 3, 2025, 1 of 38');
    expect(cell, findsOne);
    await tester.longPressAt(const Offset(10, 300));
    await tester.pump();
    expect(
      cell.evaluate().single,
      matchesSemantics(
        label: 'Mar 3, 2025, 1 of 38',
        isSelected: true,
        hasSelectedState: true,
        hasTapAction: true,
        hasLongPressAction: true,
      ),
    );
    semantics.dispose();
  });

  testWidgets('tells which assets are visible once the scroll settles', (
    tester,
  ) async {
    await pump(tester);
    expect(seen.last, view.currentState!.visible);
    view.currentState!.controller.jumpTo(3000);
    await tester.pumpAndSettle();
    expect(seen.last, view.currentState!.visible);
    expect(seen.last.$1, greaterThan(0));
  });
}
