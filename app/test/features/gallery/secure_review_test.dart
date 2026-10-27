import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/core/replica.dart';
import 'package:photolib/features/gallery/gallery_intent.dart';
import 'package:photolib/features/gallery/intents.dart';
import 'package:photolib/features/gallery/secure_review.dart';
import 'package:photolib/features/library/timeline/providers.dart';
import 'package:photolib/features/viewer/viewer_page.dart';
import 'package:photolib/l10n/app_localizations.dart';
import 'package:photolib/ui/theme.dart';
import 'package:photolib_data/photolib_data.dart' show Replica;

import '../../support/viewer.dart' show Grey;

class _Source implements IntentSource {
  new(this.launch);

  final GalleryIntent? launch;
  final incomingNow = StreamController<GalleryIntent>.broadcast();
  int done_ = 0;

  @override
  Stream<GalleryIntent> get incoming => incomingNow.stream;

  @override
  Future<GalleryIntent?> initial() async => launch;

  @override
  Future<void> pick(List<Uri> uris) async {}

  @override
  Future<void> cancel() async {}

  @override
  Future<void> done() async => done_++;
}

GalleryIntent _review({required bool secure}) => GalleryIntent.fromMap({
  'action': secure
      ? 'android.provider.action.REVIEW_SECURE'
      : 'android.intent.action.VIEW',
  'clips': ['content://media/external_primary/images/media/1'],
  'data': secure ? null : 'content://media/external_primary/images/media/1',
  'type': 'image/jpeg',
  'secure': secure,
})!;

void main() {
  Future<_Source> pump(WidgetTester tester, GalleryIntent? launch) async {
    final source = _Source(launch);
    final db = Replica(NativeDatabase.memory());
    addTearDown(db.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          galleryIntentsProvider.overrideWithValue(true),
          intentSourceProvider.overrideWithValue(source),
          replicaProvider.overrideWith((ref) => db),
          thumbnailPipelineProvider.overrideWith((ref) async => Grey()),
        ],
        child: MaterialApp(
          theme: appTheme(Brightness.dark),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => SecureReviewGate(child: child!),
          home: const Scaffold(body: Text('the library')),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return source;
  }

  testWidgets('over the lock screen only the camera items show, read-only, '
      'and the library is never built', (tester) async {
    await pump(tester, _review(secure: true));
    expect(find.text('the library'), findsNothing);
    final viewer = tester.widget<ViewerPage>(find.byType(ViewerPage));
    expect(viewer.readOnly, isTrue);
    expect(viewer.count, 1);
    // Nothing to change or leak: no favourite, info, edit, trash or share.
    for (final icon in [
      Icons.favorite_border,
      Icons.info_outline,
      Icons.edit_outlined,
      Icons.delete_outline,
      Icons.share_outlined,
    ]) {
      expect(find.byIcon(icon), findsNothing, reason: '$icon');
    }
  });

  testWidgets('a review of the camera closes its activity when the viewer '
      'is closed', (tester) async {
    final source = await pump(tester, _review(secure: true));
    final container = ProviderScope.containerOf(
      tester.element(find.byType(SecureReviewGate)),
    );
    await container.read(secureReviewProvider.notifier).close();
    await tester.pumpAndSettle();
    expect(source.done_, 1);
    expect(find.byType(ViewerPage), findsNothing);
  });

  testWidgets('a review that arrives while the app runs takes the screen', (
    tester,
  ) async {
    final source = await pump(tester, null);
    expect(find.text('the library'), findsOneWidget);
    source.incomingNow.add(_review(secure: true));
    await tester.pumpAndSettle();
    expect(find.text('the library'), findsNothing);
    expect(find.byType(ViewerPage), findsOneWidget);
  });

  testWidgets('a plain view and the launcher show the app', (tester) async {
    await pump(tester, _review(secure: false));
    expect(find.text('the library'), findsOneWidget);
    expect(find.byType(ViewerPage), findsNothing);
  });

  testWidgets(
    'nothing of the library shows before the launch intent is known',
    (tester) async {
      final launch = Completer<GalleryIntent?>();
      final source = _Slow(launch.future);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            galleryIntentsProvider.overrideWithValue(true),
            intentSourceProvider.overrideWithValue(source),
          ],
          child: MaterialApp(
            builder: (context, child) => SecureReviewGate(child: child!),
            home: const Text('the library'),
          ),
        ),
      );
      expect(find.text('the library'), findsNothing);
      launch.complete(null);
      await tester.pumpAndSettle();
      expect(find.text('the library'), findsOneWidget);
    },
  );
}

class _Slow extends _Source {
  new(this.later) : super(null);

  final Future<GalleryIntent?> later;

  @override
  Future<GalleryIntent?> initial() => later;
}
