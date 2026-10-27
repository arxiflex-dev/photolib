import 'dart:typed_data';

import 'package:photolib/features/gallery/actions.dart';
import 'package:photolib/features/gallery/gallery_prefs.dart';

/// How a hand-off to another app's editor ended.
enum EditWithOutcome {
  /// The edit is saved as a copy beside the original.
  saved,

  /// The editor changed nothing, or was left.
  unchanged,

  /// The phone has no app that edits.
  noEditor,

  /// The user did not choose an editor.
  cancelled,

  /// The editor made a picture but the copy could not be written.
  notSaved,
}

/// "Edit with" (MOB-13, ADR-0401): hands the picture at [uri] to the editor
/// the user chose before ([prefs]), or to the one [choose] picks from the
/// phone's editors and [remember] keeps; the editor gets a copy it may write
/// (the original is never written, ADR-0331) and what it returns goes to
/// [save], which writes the copy beside the original.
Future<EditWithOutcome> editWithApp({
  required GalleryPlatform platform,
  required Uri uri,
  required String mime,
  required GalleryPrefs prefs,
  required void Function(Editor? editor) remember,
  required Future<Editor?> Function(List<Editor> editors) choose,
  required Future<bool> Function(Uint8List jpeg) save,
}) async {
  final editors = await platform.editors(mime);
  if (editors.isEmpty) return EditWithOutcome.noEditor;
  var editor = editors
      .where((e) => e.package == prefs.editor?.package)
      .firstOrNull;
  if (editor == null) {
    editor = await choose(editors);
    if (editor == null) return EditWithOutcome.cancelled;
    remember(editor);
  }
  final edited = await platform.editWith(uri, mime, editor.package);
  if (edited == null) return EditWithOutcome.unchanged;
  return await save(edited) ? EditWithOutcome.saved : EditWithOutcome.notSaved;
}
