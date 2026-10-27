import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/core/replica.dart';
import 'package:photolib/features/folders/folders_page.dart'
    show pageThumbnails;
import 'package:photolib/features/folders/sorting.dart';
import 'package:photolib/features/gallery/gallery_intent.dart';
import 'package:photolib/features/gallery/intents.dart';
import 'package:photolib/features/gallery/open_plan.dart';
import 'package:photolib/features/library/timeline/pages.dart';
import 'package:photolib/features/library/timeline/thumbnails.dart';
import 'package:photolib/features/viewer/viewer_page.dart';

/// The camera's review over the lock screen that the app is showing, if any
/// (REVIEW_SECURE, ADR-0039): the items the camera sent, which are all it
/// shows.
class SecureReview extends Notifier<GalleryIntent?> {
  @override
  GalleryIntent? build() {
    final source = ref.read(intentSourceProvider);
    final incoming = source.incoming.listen((intent) {
      if (intent.secure) state = intent;
    });
    ref.onDispose(incoming.cancel);
    ref.listen(initialIntentProvider, (_, intent) {
      if (intent.value case final intent? when intent.secure) state = intent;
    }, fireImmediately: true);
    return null;
  }

  /// Closes the review and the activity over the lock screen.
  Future<void> close() async {
    state = null;
    await ref.read(intentSourceProvider).done();
  }
}

/// The secure review shown.
final secureReviewProvider = NotifierProvider<SecureReview, GalleryIntent?>(
  SecureReview.new,
);

/// Shows [child], the app, unless the phone is locked and the camera asked for
/// its review: then it shows that and nothing of the library, not even for a
/// frame, since the intent is known before the app is shown (on Android the
/// first frame waits for it).
class SecureReviewGate extends ConsumerWidget {
  /// The gate over [child].
  const new({required this.child, super.key});

  /// The app.
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(galleryIntentsProvider)) return child;
    final secure = ref.watch(secureReviewProvider);
    if (secure != null) return SecureReviewPage(secure);
    // Until the launch intent is known, nothing of the library shows.
    if (ref.watch(initialIntentProvider).isLoading) {
      return const ColoredBox(color: Colors.black);
    }
    return child;
  }
}

/// The items of a secure review in a read-only viewer on black, closing the
/// activity when the viewer is closed.
class SecureReviewPage extends ConsumerStatefulWidget {
  /// The review of [intent].
  const new(this.intent, {super.key});

  /// What the camera sent.
  final GalleryIntent intent;

  @override
  ConsumerState<SecureReviewPage> createState() => _SecureReviewState();
}

class _SecureReviewState extends ConsumerState<SecureReviewPage> {
  final _navigator = GlobalKey<NavigatorState>();
  late final Thumbnails _thumbnails = pageThumbnails(ref);
  TimelinePages? _pages;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    // Only the camera's own items, resolved by the library if it knows them,
    // else shown where they are: never their folder's siblings.
    final db = await ref.read(replicaProvider.future);
    final plan = await planOpen(
      db,
      widget.intent.uris,
      viewOf: (_) => const ItemView(),
      siblings: false,
      mime: widget.intent.type,
    );
    final navigator = _navigator.currentState;
    if (!mounted || navigator == null) return;
    if (plan.items.isEmpty) {
      return unawaited(ref.read(secureReviewProvider.notifier).close());
    }
    final pages = _pages = TimelinePages(
      (first, count) async => plan.items.skip(first).take(count).toList(),
    );
    await navigator.push(
      ViewerPage.route(
        () => Offset.zero & MediaQuery.sizeOf(context),
        ViewerPage(
          pages: pages,
          count: plan.items.length,
          position: ValueNotifier(plan.at),
          thumbnails: _thumbnails,
          readOnly: true,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pages?.dispose();
    _thumbnails.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    onPopInvokedWithResult: (_, _) =>
        unawaited(ref.read(secureReviewProvider.notifier).close()),
    child: Navigator(
      key: _navigator,
      observers: [
        _Closed(
          () => unawaited(ref.read(secureReviewProvider.notifier).close()),
        ),
      ],
      onGenerateRoute: (_) => MaterialPageRoute<void>(
        builder: (_) => const ColoredBox(color: Colors.black),
      ),
    ),
  );
}

/// Says when the viewer is closed.
class _Closed extends NavigatorObserver {
  new(this.onClosed);

  final VoidCallback onClosed;

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      onClosed();
}
