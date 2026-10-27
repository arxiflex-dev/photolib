import 'dart:typed_data';

import 'package:photolib/features/folders/sorting.dart';
import 'package:photolib/features/gallery/gallery_intent.dart';
import 'package:photolib/features/gallery/intents.dart';
import 'package:photolib/features/gallery/open_plan.dart';
import 'package:photolib/features/search/search.dart' show itemOf;
import 'package:photolib_data/photolib_data.dart' hide Stack;

/// Shows [plan] in the viewer until the user leaves it; with [readOnly] only
/// to look at.
typedef OpenViewer = Future<void> Function(
  OpenPlan plan, {
  required bool readOnly,
});

/// Does what another app asked of the gallery (ADR-0401): opens items in the
/// viewer, or lets the user pick some and answers the caller; an activity
/// started for the caller closes when it is done, which shows the caller
/// again.
class IntentHandler {
  /// A handler that reads [db], opens with [open], lets [choose] pick the ids
  /// of items and answers through [source].
  const new({
    required this.db,
    required this.source,
    required this.viewOf,
    required this.open,
    required this.choose,
  });

  /// The replica that knows the library.
  final Replica db;

  /// The caller.
  final IntentSource source;

  /// A folder's view by its key.
  final ItemView Function(String key) viewOf;

  /// Shows items in the viewer.
  final OpenViewer open;

  /// Lets the user pick items for [GalleryIntent]; null when they leave.
  final Future<List<Uint8List>?> Function(GalleryIntent intent) choose;

  /// Handles [intent].
  Future<void> handle(GalleryIntent intent) async {
    switch (intent.kind) {
      case IntentKind.view || IntentKind.edit || IntentKind.send:
        final plan = await planOpen(
          db,
          intent.uris,
          viewOf: viewOf,
          siblings: intent.kind != IntentKind.send && !intent.secure,
          mime: intent.type,
        );
        if (plan.items.isNotEmpty) {
          await open(plan, readOnly: intent.secure);
        }
        await source.done();
      case IntentKind.pick:
        final ids = await choose(intent);
        final uris = ids == null
            ? const <Uri>[]
            : await pickedUris(db, ids, intent);
        if (uris.isEmpty) {
          await source.cancel();
        } else {
          await source.pick(uris);
        }
    }
  }
}

/// The URIs of the library items [ids] that the pick [intent] offers, in the
/// order chosen: the first alone unless the caller takes many; items gone,
/// and those of a type the caller did not ask for, are left out.
Future<List<Uri>> pickedUris(
  Replica db,
  List<Uint8List> ids,
  GalleryIntent intent,
) async {
  final rows = await (db.select(
    db.localAsset,
  )..where((a) => a.id.isIn(ids))).get();
  final byId = {for (final row in rows) row.id.join(','): row};
  final uris = [
    for (final id in ids)
      if (byId[id.join(',')] case final row?
          when row.state == 'present' && intent.accepts(row.mime))
        itemOf(row).uri,
  ];
  return intent.multiple ? uris : uris.take(1).toList();
}
