import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/core/replica.dart';
import 'package:photolib/features/download/download_action.dart';
import 'package:photolib/features/folders/album_hiding.dart';
import 'package:photolib/features/folders/file_dialogs.dart';
import 'package:photolib/features/folders/file_ops.dart';
import 'package:photolib/features/folders/folders_page.dart';
import 'package:photolib/features/folders/sorting.dart';
import 'package:photolib/features/folders/views.dart';
import 'package:photolib/features/gallery/intents.dart';
import 'package:photolib/features/gallery/shortcuts.dart';
import 'package:photolib/features/library/deletion.dart';
import 'package:photolib/features/library/library.dart' show veiledProvider;
import 'package:photolib/features/library/timeline/pages.dart';
import 'package:photolib/features/library/timeline/selection.dart';
import 'package:photolib/features/library/timeline/thumbnail_at.dart';
import 'package:photolib/features/library/timeline/thumbnails.dart';
import 'package:photolib/features/offline/pin_button.dart';
import 'package:photolib/features/search/search.dart';
import 'package:photolib/features/trash/trash.dart';
import 'package:photolib/features/viewer/viewer_page.dart';
import 'package:photolib/l10n/app_localizations.dart';
import 'package:photolib/l10n/formats.dart';
import 'package:photolib/ui/empty_state.dart';
import 'package:photolib/ui/media_grid.dart';
import 'package:photolib/ui/selection_bar.dart';
import 'package:photolib_data/photolib_data.dart' hide Stack;

const _levels = [2, 3, 4, 6, 9];

/// What an [ItemsPage] shows: a device folder's own items, an album's, or
/// the favourites.
@immutable
class ItemsSource {
  /// The items of [folder], titled [title].
  const new folder(LocalFolder this.folder, String this.title) : album = null;

  /// The items of the album [album], titled [title].
  const new album(Uint8List this.album, String this.title) : folder = null;

  /// The favourites.
  const new favourites() : folder = null, album = null, title = null;

  /// The folder, if this is one.
  final LocalFolder? folder;

  /// The album's id, if this is one.
  final Uint8List? album;

  /// The page's title; the favourites have their own.
  final String? title;

  /// Where its view is kept.
  String get key => switch ((folder, album)) {
    (final f?, _) => folderKey(f),
    (_, final a?) => 'album:${hexOf(a)}',
    _ => 'favourites',
  };

  /// Whether its files can be renamed, moved and copied: a desktop folder's.
  bool get files => !kIsWeb && folder?.source == 'folder';

  Stream<List<LocalAssetData>> _items(Replica db, {required bool veiled}) =>
      switch ((folder, album)) {
        (final f?, _) => folderContents(db, f, veiled: veiled),
        (_, final a?) => albumItems(db, a, veiled: veiled),
        _ => favouriteItems(db, veiled: veiled),
      };
}

/// The items of a folder, an album or the favourites in the sort and layout
/// kept for it (VIEW-37, VIEW-38), with the selection's actions; when [pick],
/// a picker that returns the ids of the items chosen.
class ItemsPage extends ConsumerStatefulWidget {
  /// The page of [source].
  const new(this.source, {super.key, this.pick = false, this.accepts});

  /// What it shows.
  final ItemsSource source;

  /// Whether it picks items for an album.
  final bool pick;

  /// With [pick], whether an item of this MIME type may be picked; the
  /// others do not show (a caller asked for photos only, ADR-0401).
  final bool Function(String? mime)? accepts;

  @override
  ConsumerState<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends ConsumerState<ItemsPage> {
  final ValueNotifier<Selection> _selection = ValueNotifier(Selection.none);
  late final Thumbnails _thumbnails = pageThumbnails(ref);
  StreamSubscription<List<LocalAssetData>>? _rows;
  List<LocalAssetData>? _items;
  ItemView? _albumView;
  var _columns = 4;
  ({
    List<LocalAssetData> items,
    String view,
    List<LocalAssetData> sorted,
    TimelinePages pages,
  })?
  _shown;

  ItemsSource get _source => widget.source;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    final db = await ref.read(replicaProvider.future);
    if (_source.album case final album?) {
      final (mode, layout) = await albumView(db, album);
      _albumView = ItemView.album(mode, layout);
    }
    if (!mounted) return;
    // Hidden items only while they show.
    ref.listenManual(veiledProvider, (_, veiled) {
      unawaited(_rows?.cancel());
      _rows = _source
          ._items(db, veiled: veiled)
          .listen(
            (items) => setState(
              () => _items = [
                for (final a in items)
                  if (widget.accepts?.call(a.mime) ?? true) a,
              ],
            ),
          );
    }, fireImmediately: true);
  }

  @override
  void dispose() {
    unawaited(_rows?.cancel());
    _shown?.pages.dispose();
    _selection.dispose();
    _thumbnails.clear();
    super.dispose();
  }

  ItemView get _view =>
      _albumView ??
      ref.watch(folderViewsProvider.select((v) => v.views[_source.key])) ??
      const ItemView();

  Future<void> _setView(ItemView view) async {
    _selection.value = Selection.none;
    if (_source.album case final album?) {
      setState(() => _albumView = view);
      await setAlbumView(
        await ref.read(replicaProvider.future),
        album,
        sort: view.mode,
        layout: view.list ? 'list' : 'grid',
      );
    } else {
      ref.read(folderViewsProvider.notifier).setView(_source.key, view);
    }
  }

  // The items in the view's order, and their pages, made anew when either
  // changes.
  (List<LocalAssetData>, TimelinePages) _sorted(
    List<LocalAssetData> items,
    ItemView view,
  ) {
    if (_shown case final s?
        when identical(s.items, items) && s.view == view.encode()) {
      return (s.sorted, s.pages);
    }
    _shown?.pages.dispose();
    final sorted = sortItems(items, view);
    final pages = TimelinePages(
      (first, count) async => [
        for (final a in sorted.skip(first).take(count)) itemOf(a),
      ],
    );
    _shown = (items: items, view: view.encode(), sorted: sorted, pages: pages);
    return (sorted, pages);
  }

  void _open(TimelinePages pages, int count, int at) =>
      Navigator.of(context, rootNavigator: true).push(
        ViewerPage.route(
          () => Offset.zero & MediaQuery.sizeOf(context),
          ViewerPage(
            pages: pages,
            count: count,
            position: ValueNotifier(at),
            thumbnails: _thumbnails,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final view = _view;
    final items = _items;
    if (items == null) return Scaffold(appBar: AppBar());
    final (sorted, pages) = _sorted(items, view);
    return ValueListenableBuilder(
      valueListenable: _selection,
      builder: (context, selected, body) => Scaffold(
        appBar: selected.isEmpty && !widget.pick
            ? _bar(view, sorted)
            : _selectionBar(sorted, selected),
        body: body,
      ),
      child: Column(
        children: [
          if (_source.album case final album?)
            OfflineStatusLine(OfflinePin.album(album, '').id),
          Expanded(
            child: sorted.isEmpty
                ? EmptyState(
                    icon: Icons.photo_library_outlined,
                    message: _source.album == null
                        ? strings.libraryEmpty
                        : strings.albumEmpty,
                  )
                : view.list
                ? _list(sorted, pages)
                : _grid(sorted, pages),
          ),
        ],
      ),
    );
  }

  AppBar _bar(ItemView view, List<LocalAssetData> sorted) {
    final strings = AppLocalizations.of(context);
    return AppBar(
      title: Text(_source.title ?? strings.searchFavourites),
      actions: [
        if (_source.album case final album?)
          IconButton(
            icon: const Icon(Icons.add_photo_alternate_outlined),
            tooltip: strings.actionAddToAlbum,
            onPressed: () => addFromFolder(context, ref, album),
          ),
        if (_source.album case final album?)
          OfflinePinButton(
            id: OfflinePin.album(album, '').id,
            make: () => OfflinePin.album(
              album,
              _source.title ?? '',
              created: DateTime.now().millisecondsSinceEpoch,
            ),
          ),
        if (_source.album case final album?) AlbumHidingMenu(album: album),
        if (ref.watch(galleryIntentsProvider) && _source.title != null)
          IconButton(
            icon: const Icon(Icons.add_to_home_screen),
            tooltip: strings.galleryShortcutAdd,
            onPressed: () => unawaited(addShortcut(context, ref, _source)),
          ),
        _ViewMenu(view, onChanged: _setView, album: _source.album != null),
        if (_source.files)
          PopupMenuButton<void>(
            itemBuilder: (_) => [
              PopupMenuItem(
                onTap: () => deleteFolder(context, ref, _source.title ?? '', [
                  for (final a in sorted) a.id,
                ]),
                child: Text(strings.folderDelete),
              ),
            ],
          ),
      ],
    );
  }

  PreferredSizeWidget _selectionBar(
    List<LocalAssetData> sorted,
    Selection selected,
  ) {
    final strings = AppLocalizations.of(context);
    final chosen = [for (final i in selected.positions) sorted[i]];
    IconButton action(IconData icon, String label, VoidCallback onPressed) =>
        IconButton(icon: Icon(icon), tooltip: label, onPressed: onPressed);
    return SelectionBar(
      count: selected.count,
      onClear: () => widget.pick
          ? Navigator.pop(context)
          : _selection.value = Selection.none,
      onSelectAll: () =>
          _selection.value = Selection.none.add(0, sorted.length),
      onDownload: () => download(
        context,
        ref,
        count: chosen.length,
        items: () => Stream.fromIterable(chosen.map(itemOf)),
      ),
      actions: [
        if (widget.pick)
          action(
            Icons.check,
            widget.accepts == null
                ? strings.actionAddToAlbum
                : strings.galleryPickTitle,
            () => Navigator.pop(context, [for (final a in chosen) a.id]),
          )
        else ...[
          if (_source.files) ...[
            action(Icons.drive_file_rename_outline, strings.actionRename, () {
              _selection.value = Selection.none;
              unawaited(renameDialog(context, chosen));
            }),
            for (final move in [true, false])
              action(
                move
                    ? Icons.drive_file_move_outlined
                    : Icons.file_copy_outlined,
                move ? strings.actionMoveTo : strings.actionCopyTo,
                () => _transfer(chosen, move: move),
              ),
          ],
          ...selectionActions(
            context,
            ref,
            () async {
              _selection.value = Selection.none;
              return [
                for (final a in chosen) (id: a.id, favourite: a.favorite == 1),
              ];
            },
            trash: () => deleteItems(
              context,
              ref,
              [for (final a in chosen) itemOf(a)],
              chosen: () {
                _selection.value = Selection.none;
                return context;
              },
            ),
          ),
          if (_source.album case final album? when chosen.length == 1)
            action(Icons.image_outlined, strings.albumCover, () async {
              _selection.value = Selection.none;
              await setAlbumCover(
                await ref.read(replicaProvider.future),
                album,
                chosen.single.id,
              );
            })
          else if (_source.album == null)
            action(
              Icons.photo_album_outlined,
              strings.actionAddToAlbum,
              () => addToChosenAlbum(context, ref, [
                for (final a in chosen) a.id,
              ]),
            ),
        ],
      ],
    );
  }

  void _transfer(List<LocalAssetData> chosen, {required bool move}) {
    _selection.value = Selection.none;
    unawaited(
      transferDialog(
        context,
        ref,
        [for (final a in chosen) pathOf(a)],
        from: parentOf(pathOf(chosen.first)),
        move: move,
      ),
    );
  }

  Widget _grid(List<LocalAssetData> sorted, TimelinePages pages) => MediaGrid(
    key: ObjectKey(pages),
    count: sorted.length,
    columns: _columns,
    levels: _levels,
    onColumns: (columns) => setState(() => _columns = columns),
    selection: _selection,
    onOpen: widget.pick
        ? (i) => _selection.value = Selection.none.add(i, i + 1)
        : (i) => _open(pages, sorted.length, i),
    onPress: widget.pick ? null : (i) => decodeOnTouch(context, ref, pages, i),
    itemBuilder: (context, i) => _Tile(sorted[i], i, pages, _thumbnails),
  );

  Widget _list(List<LocalAssetData> sorted, TimelinePages pages) {
    final formats = Formats(AppLocalizations.of(context));
    return ValueListenableBuilder(
      valueListenable: _selection,
      builder: (context, selected, _) => ListView.builder(
        key: ObjectKey(pages),
        itemCount: sorted.length,
        itemBuilder: (context, i) {
          final a = sorted[i];
          void toggle() => _selection.value = selected.toggle(i);
          return ListTile(
            selected: selected.contains(i),
            leading: SizedBox.square(
              dimension: 56,
              child: ThumbnailAt(i, pages, _thumbnails),
            ),
            title: Text(nameOf(a)),
            subtitle: Text(
              '${formats.fileSize(a.size)} · ${formats.taken(takenAt(a))}',
            ),
            trailing: switch (a.durationMs) {
              final ms? => Text(formats.duration(Duration(milliseconds: ms))),
              null => null,
            },
            onLongPress: toggle,
            onTap: !selected.isEmpty || widget.pick
                ? toggle
                : () => _open(pages, sorted.length, i),
          );
        },
      ),
    );
  }
}

/// A grid cell: the thumbnail and, on a video, its file name and length.
class _Tile extends StatelessWidget {
  const new(this.item, this.at, this.pages, this.thumbnails);

  final LocalAssetData item;
  final int at;
  final TimelinePages pages;
  final Thumbnails thumbnails;

  @override
  Widget build(BuildContext context) {
    final thumbnail = ThumbnailAt(at, pages, thumbnails);
    if (!isVideo(item)) return thumbnail;
    final formats = Formats(AppLocalizations.of(context));
    final style = Theme.of(context).textTheme.labelSmall
        ?.copyWith(color: Colors.white);
    return Stack(
      fit: StackFit.expand,
      children: [
        thumbnail,
        Align(
          alignment: AlignmentDirectional.bottomStart,
          child: ColoredBox(
            color: Colors.black54,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      nameOf(item),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: style,
                    ),
                  ),
                  if (item.durationMs case final ms?)
                    Text(
                      formats.duration(Duration(milliseconds: ms)),
                      style: style,
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// The sort, its order and the layout of a page; an album's own order only
/// for an [album].
class _ViewMenu extends StatelessWidget {
  const new(this.view, {required this.onChanged, required this.album});

  final ItemView view;
  final ValueChanged<ItemView> onChanged;
  final bool album;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return PopupMenuButton<ItemView>(
      icon: const Icon(Icons.sort),
      tooltip: strings.libraryViewOptions,
      onSelected: onChanged,
      itemBuilder: (context) => [
        for (final sort in ItemSort.values)
          if (album || sort != ItemSort.custom)
            CheckedPopupMenuItem(
              // Random again shuffles anew.
              value: view.copyWith(
                sort: sort,
                seed: sort == ItemSort.random
                    ? Random().nextInt(1 << 31)
                    : null,
              ),
              checked: view.sort == sort,
              child: Text(strings.itemSort(sort.name)),
            ),
        const PopupMenuDivider(),
        for (final descending in [false, true])
          CheckedPopupMenuItem(
            value: view.copyWith(descending: descending),
            checked: view.descending == descending,
            child: Text(strings.sortOrder('$descending')),
          ),
        const PopupMenuDivider(),
        for (final list in [false, true])
          CheckedPopupMenuItem(
            value: view.copyWith(list: list),
            checked: view.list == list,
            child: Text(strings.itemLayout('$list')),
          ),
      ],
    );
  }
}
