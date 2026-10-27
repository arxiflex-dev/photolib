import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/features/library/timeline/buckets.dart';
import 'package:photolib/features/library/timeline/pages.dart';
import 'package:photolib/features/library/timeline/selection.dart';
import 'package:photolib/features/library/timeline/thumbnail_at.dart';
import 'package:photolib/features/library/timeline/thumbnails.dart';
import 'package:photolib/features/library/timeline/timeline_view.dart';
import 'package:photolib/l10n/app_localizations.dart';

void main() {
  testWidgets('rows ask a new Thumbnails and leave the old', (tester) async {
    final buckets = TimelineBuckets(days: [20250304], counts: [6]);
    final pages = TimelinePages(
      (first, count) async => [for (var a = first; a < 6; a++) a],
    );
    final selection = ValueNotifier(Selection.none);
    final asked = <String, List<Object>>{'old': [], 'new': []};
    final cancelled = <Object>[];
    Thumbnails of(String name) => Thumbnails((asset, tier, t) {
      asked[name]!.add(asset);
      unawaited(t.cancelled.then((_) => cancelled.add(asset)));
      return Completer<ui.Image>().future;
    }, concurrency: 6);
    Future<void> show(Thumbnails thumbnails) => tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          body: TimelineView(
            buckets: buckets,
            pages: pages,
            thumbnails: thumbnails,
            selection: selection,
          ),
        ),
      ),
    );

    await show(of('old'));
    await tester.pumpAndSettle();
    expect(asked['old'], unorderedEquals([0, 1, 2, 3, 4, 5]));

    await show(of('new'));
    await tester.pumpAndSettle();
    expect(asked['new'], unorderedEquals([0, 1, 2, 3, 4, 5]));
    expect(cancelled, unorderedEquals([0, 1, 2, 3, 4, 5]));
  });

  // M1-49 (ADR-0214, ADR-0405): a HEIC no decoder takes says to connect a
  // server or open it on a Mac, never a codec, to screen readers and in the
  // mark's tooltip; any other failure keeps its cause.
  for (final (platform, device) in [
    (TargetPlatform.linux, 'computer'),
    (TargetPlatform.windows, 'PC'),
  ]) {
    testWidgets('a HEIC no decoder takes says on ${platform.name} the way '
        'out', (tester) async {
      debugDefaultTargetPlatformOverride = platform;
      final semantics = tester.ensureSemantics();
      final thumbnails = Thumbnails(
        (asset, tier, t) async =>
            throw const NoThumbnail(cause: 'vips: refused', noHevc: true),
      );
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(
            body: TimelineView(
              buckets: TimelineBuckets(days: [20250304], counts: [1]),
              pages: TimelinePages((first, count) async => [0]),
              thumbnails: thumbnails,
              selection: ValueNotifier(Selection.none),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final text =
          "Photolib can't show HEIC photos on this $device. Connect a "
          'Photolib server to see its copy, or open them on a Mac.';
      expect(
        find.semantics
            .byLabel('Mar 4, 2025, 1 of 1, no preview')
            .evaluate()
            .single,
        isSemantics(hint: text),
      );
      expect(text, isNot(contains('HEVC')));
      semantics.dispose();
      debugDefaultTargetPlatformOverride = null;
    });
  }

  testWidgets('the mark of a HEIC no decoder takes says the way out, not the '
      'cause, which stays for every other failure', (tester) async {
    final semantics = tester.ensureSemantics();
    for (final (error, said) in [
      (
        const NoThumbnail(cause: 'vips: refused', noHevc: true),
        "Photolib can't show HEIC photos on this computer. Connect a "
            'Photolib server to see its copy, or open them on a Mac.',
      ),
      (const NoThumbnail(cause: 'vips: refused'), 'vips: refused'),
    ]) {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: FailureMark(error),
        ),
      );
      expect(find.byTooltip(said), findsOne);
      expect(
        find.semantics.byPredicate(
          (node) => node.getSemanticsData().tooltip == said,
        ),
        findsOne,
      );
    }
    semantics.dispose();
  });
}
