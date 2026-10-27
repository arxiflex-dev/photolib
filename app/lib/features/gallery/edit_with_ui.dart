import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/features/editor/save_copy.dart';
import 'package:photolib/features/gallery/actions.dart';
import 'package:photolib/features/gallery/edit_with.dart';
import 'package:photolib/features/gallery/gallery_prefs.dart';
import 'package:photolib/features/library/timeline/pipeline.dart';
import 'package:photolib/l10n/app_localizations.dart';

/// Whether [item] can go to another app's editor: a MediaStore photo on a
/// phone.
bool canEditWith(ThumbnailItem item) =>
    _android && item.uri.isScheme('content') && !item.video;

/// Whether [item] can open in another app: any MediaStore item on a phone,
/// such as a video in an external player.
bool canOpenWith(ThumbnailItem item) =>
    _android && item.uri.isScheme('content');

bool get _android => !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

/// "Edit with…" (MOB-13): [item] in the editor the user picks, once, whose
/// result is saved beside it as a copy (ADR-0331); returns that copy, null if
/// nothing was saved, saying why when it matters.
Future<ThumbnailItem?> editWithOther(
  BuildContext context,
  WidgetRef ref,
  ThumbnailItem item,
  String? mime,
) async {
  final strings = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.maybeOf(context);
  ThumbnailItem? copy;
  final outcome = await editWithApp(
    platform: ref.read(galleryPlatformProvider),
    uri: item.uri,
    mime: mime ?? 'image/jpeg',
    prefs: ref.read(galleryPrefsProvider),
    remember: ref.read(galleryPrefsProvider.notifier).setEditor,
    choose: (editors) => showDialog<Editor>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(strings.galleryEditWith),
        children: [
          for (final editor in editors)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, editor),
              child: Text(editor.label),
            ),
        ],
      ),
    ),
    save: (jpeg) async => (copy = await writeCopy(item, jpeg)) != null,
  );
  final notice = switch (outcome) {
    EditWithOutcome.noEditor => strings.galleryEditNone,
    EditWithOutcome.notSaved => strings.galleryEditNotSaved,
    _ => null,
  };
  if (notice != null) {
    messenger?.showSnackBar(SnackBar(content: Text(notice)));
  }
  return copy;
}
