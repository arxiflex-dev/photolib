import 'dart:async';
import 'dart:typed_data';

import 'package:material_ui/material_ui.dart';
import 'package:photolib/features/folders/folders_page.dart';
import 'package:photolib/features/folders/items_page.dart';
import 'package:photolib/features/gallery/gallery_intent.dart';
import 'package:photolib/features/search/search.dart' show folderLabel;
import 'package:photolib/l10n/app_localizations.dart';

/// What the user picks for another app's PICK or GET_CONTENT (ADR-0401): the
/// device's folders, then the items of one, of the types the caller asked for.
/// Pops with the ids chosen, or nothing when the user leaves.
class PickerPage extends StatelessWidget {
  /// The picker for [intent].
  const new(this.intent, {super.key});

  /// What the caller asked for.
  final GalleryIntent intent;

  /// Opens the picker over everything.
  static Future<List<Uint8List>?> show(
    BuildContext context,
    GalleryIntent intent,
  ) => Navigator.of(context, rootNavigator: true).push(
    MaterialPageRoute<List<Uint8List>>(builder: (_) => PickerPage(intent)),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(AppLocalizations.of(context).galleryPickTitle)),
    body: DeviceFolderList(
      onTap: (entry) async {
        final navigator = Navigator.of(context);
        final ids = await navigator.push<List<Uint8List>>(
          MaterialPageRoute(
            builder: (_) => ItemsPage(
              ItemsSource.folder(entry.folder, folderLabel(entry.folder)),
              pick: true,
              accepts: intent.accepts,
            ),
          ),
        );
        if (ids != null && ids.isNotEmpty) navigator.pop(ids);
      },
    ),
  );
}
