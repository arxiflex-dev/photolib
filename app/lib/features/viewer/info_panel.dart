import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/core/kernel.dart'
    if (dart.library.js_interop) 'package:photolib/core/kernel_web.dart';
import 'package:photolib/core/replica.dart';
import 'package:photolib/features/download/download_action.dart';
import 'package:photolib/features/folders/device_folders.dart';
import 'package:photolib/features/library/timeline/pipeline.dart';
import 'package:photolib/features/settings/settings.dart';
import 'package:photolib/features/viewer/info_facts.dart';
import 'package:photolib/features/viewer/info_sections.dart';
import 'package:photolib/l10n/app_localizations.dart';
import 'package:photolib/l10n/formats.dart';
import 'package:photolib_data/photolib_data.dart';

/// The device index's row of an item, anew on every change; for a file not
/// in it, opened or dropped, what the file says of itself; else null.
final assetRowProvider = StreamProvider.autoDispose
    .family<LocalAssetData?, ThumbnailItem>((ref, item) async* {
      final id = item.id;
      if (id == null) {
        yield item.uri.isScheme('file')
            ? await readOutside(item.uri.toFilePath())
            : null;
        return;
      }
      final db = await ref.watch(replicaProvider.future);
      yield* (db.select(
        db.localAsset,
      )..where((a) => a.id.equals(id))).watchSingleOrNull();
    });

/// When [asset] was taken, as far as that is known, or null.
String? takenOf(LocalAssetData asset, Formats formats) {
  if (asset.takenLocal case final local?) {
    if (DateTime.tryParse(local) case final time?) {
      return formats.taken(time, asset.timePrecision);
    }
  }
  final ms = asset.taken ?? asset.mtime;
  return ms <= 0
      ? null
      : formats.taken(DateTime.fromMillisecondsSinceEpoch(ms));
}

/// What the viewer asks of the info panel beyond the item's row.
typedef InfoHooks = ({
  /// The screen-size picture, whose faces it crops.
  ui.Image? image,

  /// The name of the original an editor's copy copies, and what shows it.
  (String, VoidCallback)? copyOf,

  /// Outlines faces on the photo.
  ValueChanged<List<InfoFace>>? outline,

  /// Shows a version instead of the item, or the item again.
  ValueChanged<ThumbnailItem?>? compare,

  /// Whether the edit history shows instead of the rest.
  ValueNotifier<bool>? history,
});

/// What is known of an item (docs/10 §4.6, VIEW-10, VIEW-43), with no
/// heading: its description, people, the date with an inline why, a one-line
/// file row that opens its path sheet, the camera, the place behind a
/// one-time agreement to load maps, where it lives, an editor copy's
/// original, its edit history, albums and tags, and all its metadata. A
/// section with nothing to show is absent, but Albums. The [controller]
/// scrolls it inside a bottom sheet.
class InfoPanel extends ConsumerWidget {
  /// The info of [asset].
  const new(this.asset, {this.controller, this.hooks, super.key});

  /// The item's row.
  final LocalAssetData asset;

  /// What scrolls it in a sheet.
  final ScrollController? controller;

  /// What the viewer asks of it.
  final InfoHooks? hooks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // The row's own sections show at once; the others once the replica
    // opens.
    final facts = ref.watch(infoFactsProvider).value ?? const InfoFacts();
    final history = hooks?.history;
    if (history == null) return _rows(context, ref, facts);
    return ValueListenableBuilder(
      valueListenable: history,
      builder: (context, open, _) => open
          ? HistoryList(
              asset.id,
              facts,
              onBack: () => history.value = false,
              onCompare: hooks?.compare,
            )
          : _rows(context, ref, facts),
    );
  }

  Widget _rows(BuildContext context, WidgetRef ref, InfoFacts facts) {
    final strings = AppLocalizations.of(context);
    final formats = Formats.of(context);
    final a = asset;
    final camera = [?a.make, ?a.model].join(' ');
    return ListView(
      controller: controller,
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        if (facts.description(a.id) case final text?)
          DescriptionField(a.id, text, facts),
        if (facts.faces)
          People(a.id, facts, image: hooks?.image, onOutline: hooks?.outline),
        DateRow(a, facts),
        ListTile(
          leading: const Icon(Icons.insert_drive_file_outlined),
          title: Text(_name(a), maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(_size(a, formats), maxLines: 1),
          onTap: () => _pathSheet(context, ref),
        ),
        if (camera.isNotEmpty)
          StreamBuilder(
            stream: facts.optics(a.id),
            builder: (context, optics) => ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(camera),
              subtitle: switch (optics.data) {
                final o? => Text(_optics(o, formats)),
                null => null,
              },
            ),
          ),
        if ((a.lat, a.lon) case (final lat?, final lon?)) ...[
          ListTile(
            leading: const Icon(Icons.place_outlined),
            title: Text(formats.place(lat, lon)),
          ),
          const MapSlot(),
        ],
        StreamBuilder(
          stream: facts.backedUp(a.id),
          builder: (context, backed) => ListTile(
            leading: const Icon(Icons.smartphone_outlined),
            title: Text(
              [
                strings.infoOnDevice,
                if (backed.data ?? false) strings.infoBackedUp,
              ].join(' · '),
            ),
          ),
        ),
        if (hooks?.copyOf case (final name, final open))
          ListTile(
            leading: const Icon(Icons.difference_outlined),
            title: Text(strings.infoEditedCopyOf(name)),
            onTap: open,
          ),
        HistoryRow(a.id, facts, onOpen: () => hooks?.history?.value = true),
        Albums(a.id, facts),
        if (facts.tags(a.id) case final tags?) Tags(a.id, tags, facts),
        ListTile(
          leading: const Icon(Icons.data_object),
          title: Text(strings.infoAllMetadata),
          onTap: () => _metadata(context),
        ),
      ],
    );
  }

  /// The sheet of the file's path: selectable, copied, shown in its folder
  /// or its folder excluded from the library.
  void _pathSheet(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final path = _path(asset);
    final item = ThumbnailItem(
      '',
      Uri.file(asset.source == 'folder' ? path : '/$path'),
    );
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheet) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SelectableText(
                isolated(path),
                key: const ValueKey('info-path'),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.copy_outlined),
              title: Text(strings.infoCopyPath),
              onTap: () {
                unawaited(Clipboard.setData(ClipboardData(text: path)));
                Navigator.pop(context);
              },
            ),
            if (canReveal(item))
              ListTile(
                leading: const Icon(Icons.folder_open_outlined),
                title: Text(strings.reveal(defaultTargetPlatform.name)),
                onTap: () => unawaited(reveal(path)),
              ),
            if (asset.folder != 0)
              ListTile(
                leading: const Icon(Icons.folder_off_outlined),
                title: Text(strings.deviceFolderExcludeThis),
                onTap: () {
                  // The panel's context, which outlives the sheet.
                  Navigator.pop(sheet);
                  unawaited(excludeFolders(context, ref, {asset.folder}));
                },
              ),
          ],
        ),
      ),
    );
  }

  /// Every field of the item's row (VIEW-11).
  void _metadata(BuildContext context) => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(AppLocalizations.of(context).infoAllMetadata),
      content: SingleChildScrollView(
        child: SelectableText(
          [
            for (final MapEntry(:key, :value) in asset.toJson().entries)
              if (value != null && value is! Uint8List) '$key: $value',
          ].join('\n'),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(MaterialLocalizations.of(context).closeButtonLabel),
        ),
      ],
    ),
  );
}

String _path(LocalAssetData a) => a.source == 'folder'
    ? '${a.volume}/${a.path ?? ''}'
    : '${a.path ?? ''}${a.name ?? ''}';

String _name(LocalAssetData a) {
  final path = a.path ?? '';
  return a.name ?? path.substring(path.lastIndexOf('/') + 1);
}

/// The lens over `ƒ/1.8 · 1/120 s · ISO 100 · 26 mm`, as far as known.
String _optics(Optics o, Formats formats) {
  final exposure = switch (o.exposure) {
    final e? when e > 0 && e < 1 => '1/${formats.number((1 / e).round())} s',
    final e? => '${formats.number(e)} s',
    null => null,
  };
  return [
    ?o.lens,
    [
      if (o.aperture case final f?) 'ƒ/${formats.number(f)}',
      ?exposure,
      if (o.iso case final iso?) 'ISO ${formats.number(iso)}',
      if (o.focal case final mm?) '${formats.number(mm)} mm',
    ].join(' · '),
  ].where((line) => line.isNotEmpty).join('\n');
}

/// `34 MP · 8,192 × 4,096 · 14.2 MB`, as far as it is known.
String _size(LocalAssetData a, Formats formats) {
  final turned = a.orientation == 90 || a.orientation == 270;
  final (w, h) = turned ? (a.height, a.width) : (a.width, a.height);
  return [
    if ((w, h) case (final w?, final h?)) ...[
      formats.strings.infoMegapixels(formats.number((w * h / 1e6).round())),
      '${formats.number(w)} × ${formats.number(h)}',
    ],
    formats.fileSize(a.size),
  ].join(' · ');
}

/// The place's map, M1-55's, once the user agreed to load its tiles from the
/// internet (docs/14 §1); until then that agreement, and no request.
class MapSlot extends ConsumerWidget {
  /// The map, or the agreement to it.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final colours = Theme.of(context).colorScheme;
    final agreed = ref.watch(settingsProvider.select((s) => s.maps));
    return Container(
      height: agreed ? 120 : null,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colours.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: agreed
          ? Semantics(
              label: strings.infoMap,
              child: const Icon(Icons.map_outlined, size: 48),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(strings.infoMapAgree),
                TextButton(
                  onPressed: ref.read(settingsProvider.notifier).agreeToMaps,
                  child: Text(strings.infoShowMap),
                ),
              ],
            ),
    );
  }
}
