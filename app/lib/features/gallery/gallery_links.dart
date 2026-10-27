import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/core/replica.dart';
import 'package:photolib/features/folders/sorting.dart';
import 'package:photolib/features/folders/views.dart';
import 'package:photolib/features/gallery/gallery_intent.dart';
import 'package:photolib/features/gallery/intent_handler.dart';
import 'package:photolib/features/gallery/intents.dart';
import 'package:photolib/features/gallery/picker_page.dart';
import 'package:photolib/features/viewer/viewer_page.dart';

/// Answers what other apps ask of the gallery (ADR-0401) over [child]: the
/// intent that started the app and those it is sent while it runs open items
/// in the viewer, or open the picker of a PICK or GET_CONTENT. Intents over
/// the lock screen are SecureReviewGate's, never this widget's: it is inside
/// the library.
class GalleryLinks extends ConsumerStatefulWidget {
  /// Links over [child].
  const new({required this.child, super.key});

  /// The page under the links.
  final Widget child;

  @override
  ConsumerState<GalleryLinks> createState() => _GalleryLinksState();
}

class _GalleryLinksState extends ConsumerState<GalleryLinks> {
  StreamSubscription<GalleryIntent>? _incoming;
  var _launched = false;

  @override
  void initState() {
    super.initState();
    _incoming = ref.read(intentSourceProvider).incoming.listen(_handle);
    ref.listenManual(initialIntentProvider, (_, intent) {
      if (intent.value case final intent? when !_launched) {
        _launched = true;
        unawaited(_handle(intent));
      }
    }, fireImmediately: true);
  }

  @override
  void dispose() {
    unawaited(_incoming?.cancel());
    super.dispose();
  }

  Future<void> _handle(GalleryIntent intent) async {
    if (intent.secure) return;
    final db = await ref.read(replicaProvider.future);
    if (!mounted) return;
    await IntentHandler(
      db: db,
      source: ref.read(intentSourceProvider),
      viewOf: (key) =>
          ref.read(folderViewsProvider).views[key] ?? const ItemView(),
      open: (plan, {required readOnly}) =>
          openInViewer(context, ref, plan.items, at: plan.at),
      choose: (intent) => PickerPage.show(context, intent),
    ).handle(intent);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
