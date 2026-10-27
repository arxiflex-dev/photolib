import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/core/errors.dart';
import 'package:photolib/core/kept.dart';
import 'package:photolib/core/replica.dart';
import 'package:photolib/features/download/download_action.dart';
import 'package:photolib/features/folders/device_folders.dart';
import 'package:photolib/features/library/timeline/pages.dart';
import 'package:photolib/features/library/timeline/pipeline.dart';
import 'package:photolib/features/library/timeline/providers.dart';
import 'package:photolib/features/library/timeline/selection.dart';
import 'package:photolib/features/library/timeline/thumbnail_at.dart';
import 'package:photolib/features/library/timeline/thumbnails.dart';
import 'package:photolib/features/offline/pin_button.dart';
import 'package:photolib/features/search/search.dart';
import 'package:photolib/features/servers/servers.dart';
import 'package:photolib/features/settings/settings.dart';
import 'package:photolib/features/viewer/slideshow.dart';
import 'package:photolib/features/viewer/viewer_page.dart';
import 'package:photolib/l10n/app_localizations.dart';
import 'package:photolib/l10n/formats.dart';
import 'package:photolib/ui/empty_state.dart';
import 'package:photolib/ui/media_grid.dart';
import 'package:photolib/ui/selection_bar.dart';
import 'package:photolib/ui/tokens.dart';
import 'package:photolib_data/photolib_data.dart' hide Stack;

const _levels = [2, 3, 4, 6, 9];
const _kinds = <Facet>{Facet.photo, Facet.video};

/// Search v0 (M1-17): words in file names and folders, and filter chips, with
/// the results in a grid that selects as the library does.
class SearchPage extends ConsumerStatefulWidget {
  /// The page, which keeps its query in [searchQueryProvider].
  const new({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  late final _text = TextEditingController(
    text: ref.read(searchQueryProvider).text,
  );
  late final _thumbnails = Thumbnails(
    (item, tier, tile) => ref
        .read(thumbnailPipelineProvider.future)
        .then((pipeline) => pipeline.load(item as ThumbnailItem, tier, tile)),
    video: (item) => (item as ThumbnailItem).video,
  );
  // The results of the query shown as the viewer reads them, and the file
  // names of those read so far.
  (LocalQuery, TimelinePages, Map<int, String>)? _pages;
  final ValueNotifier<Selection> _selection = ValueNotifier(Selection.none);
  Timer? _typing;
  // Whether the selection a restart kept has been restored, which nothing
  // overwrites before.
  bool? _restored;
  // Built anew for each account (AccountScope), which keeps its own.
  late final String _selectionKey = keptKey(
    ref.read(replicaNameProvider).value,
    'searchSelection',
  );
  late final String _topKey = keptKey(
    ref.read(replicaNameProvider).value,
    'searchTop',
  );

  @override
  void initState() {
    super.initState();
    _selection.addListener(() {
      if (_restored != true) return;
      ref.read(keptProvider.notifier).put(_selectionKey, {
        'count': ref.read(searchPageProvider(0)).value?.count,
        'ranges': _selection.value.toJson(),
      });
    });
  }

  /// Restores the selection a restart kept, when the search finds as many.
  void _restore(int count) {
    _restored = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (ref.read(keptProvider)[_selectionKey]
          case {'count': final int kept, 'ranges': final ranges}
          when kept == count) {
        _selection.value = Selection.fromJson(ranges);
      }
      _restored = true;
    });
  }

  @override
  void dispose() {
    _typing?.cancel();
    _text.dispose();
    _selection.dispose();
    _pages?.$2.dispose();
    _thumbnails.clear();
    super.dispose();
  }

  LocalQuery get _query => ref.read(searchQueryProvider);

  void _set(LocalQuery query) {
    _selection.value = Selection.none;
    ref.read(keptProvider.notifier).put(_topKey, null);
    ref.read(searchQueryProvider.notifier).set(query);
  }

  /// The results of [query], a page of the search at a time, and their names.
  (TimelinePages, Map<int, String>) _pagesOf(LocalQuery query) {
    if (_pages case (final shown, final pages, final names)
        when identical(shown, query)) {
      return (pages, names);
    }
    _pages?.$2.dispose();
    final names = <int, String>{};
    final pages = TimelinePages((first, count) async {
      final page = searchPageProvider(first ~/ searchPageSize);
      final listening = ref.listenManual(page, (_, _) {});
      final ({int count, List<LocalAssetData> items}) found;
      try {
        found = await ref.read(page.future);
      } finally {
        listening.close();
      }
      for (final (i, a) in found.items.indexed) {
        names[first + i] = a.name ?? a.path?.split('/').last ?? '';
      }
      return found.items.map(itemOf).toList();
    }, size: searchPageSize);
    _pages = (query, pages, names);
    return (pages, names);
  }

  /// Opens the viewer on result [at] of [count].
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

  /// The result a restart kept at the top, when the search finds as many.
  int _top(int count) => switch (ref.read(keptProvider)[_topKey]) {
    {'count': final int kept, 'top': final int top} when kept == count => top,
    _ => 0,
  };

  void _search(String text) {
    _typing?.cancel();
    _set(_query.copyWith(text: text));
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final query = ref.watch(searchQueryProvider);
    final first = query.isEmpty ? null : ref.watch(searchPageProvider(0));
    final count = first?.value?.count ?? 0;
    if (_restored == null && first?.hasValue == true) _restore(count);
    return ValueListenableBuilder(
      valueListenable: _selection,
      builder: (context, selected, results) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (selected.isEmpty)
            _filters(query)
          else
            SelectionBar(
              count: selected.count,
              onClear: () => _selection.value = Selection.none,
              onSelectAll: () =>
                  _selection.value = Selection.none.add(0, count),
              onSlideshow: () => _slideshow(selected.count, selected),
              onDownload: _download,
            ),
          Expanded(child: results ?? const SizedBox.shrink()),
        ],
      ),
      child: switch (first) {
        null => EmptyState(icon: Icons.search, message: strings.searchEmpty),
        AsyncValue(value: (count: 0, items: _)) => EmptyState(
          icon: Icons.search_off,
          message: strings.searchNothing,
        ),
        AsyncValue(hasValue: true) => _results(count),
        AsyncError() => StoreErrorView(
          retry: () => ref.invalidate(searchPageProvider),
        ),
        _ => const SizedBox.shrink(),
      },
    );
  }

  Widget _filters(LocalQuery query) {
    final tokens = AppTokens.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: tokens.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: tokens.sm,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: tokens.md),
            child: _field(),
          ),
          // One row, so that the results keep the screen.
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: tokens.md),
            child: _chips(query),
          ),
        ],
      ),
    );
  }

  Widget _field() => TextField(
    controller: _text,
    textInputAction: TextInputAction.search,
    decoration: InputDecoration(
      prefixIcon: const Icon(Icons.search),
      hintText: AppLocalizations.of(context).searchHint,
      hintMaxLines: 3,
      suffixIcon: ValueListenableBuilder(
        valueListenable: _text,
        builder: (context, value, _) => value.text.isEmpty
            ? const SizedBox.shrink()
            : IconButton(
                icon: const Icon(Icons.clear),
                tooltip: MaterialLocalizations.of(context).clearButtonTooltip,
                onPressed: () {
                  _text.clear();
                  _search('');
                },
              ),
      ),
    ),
    // The search runs once typing pauses (docs/09 §4.2).
    onChanged: (text) {
      _typing?.cancel();
      _typing = Timer(const Duration(milliseconds: 300), () => _search(text));
    },
    onSubmitted: _search,
  );

  Widget _chips(LocalQuery query) {
    final strings = AppLocalizations.of(context);
    final formats = Formats.of(context);
    final (folder, camera) = (query.folder, query.camera);
    Widget facet(Facet f, String label) => FilterChip(
      label: Text(label),
      selected: query.facets.contains(f),
      onSelected: (on) => _set(
        query.copyWith(
          facets: {
            ...query.facets.difference(on && _kinds.contains(f) ? _kinds : {f}),
            if (on) f,
          },
        ),
      ),
    );
    Widget optional(
      String label,
      String? chosen,
      VoidCallback pick,
      VoidCallback clear,
    ) => InputChip(
      label: Text(chosen ?? label),
      selected: chosen != null,
      showCheckmark: false,
      onPressed: pick,
      onDeleted: chosen == null ? null : clear,
    );
    return Row(
      spacing: AppTokens.of(context).sm,
      children: [
        optional(
          strings.searchDates,
          switch (query.days) {
            (:final first, :final last) => strings.searchDays(
              formats.date(first),
              formats.date(last),
            ),
            null => null,
          },
          _pickDays,
          () => _set(_query.copyWith(days: (value: null))),
        ),
        facet(Facet.photo, strings.searchPhotos),
        facet(Facet.video, strings.searchVideos),
        facet(Facet.favorite, strings.searchFavourites),
        facet(Facet.panorama, strings.searchPanoramas),
        facet(Facet.motionPhoto, strings.searchMotionPhotos),
        facet(Facet.screenshot, strings.searchScreenshots),
        optional(
          strings.searchFolder,
          folder == null ? null : folderLabel(folder),
          _pickFolder,
          () => _set(_query.copyWith(folder: (value: null))),
        ),
        optional(
          strings.searchCamera,
          camera == null ? null : cameraLabel(camera),
          _pickCamera,
          () => _set(_query.copyWith(camera: (value: null))),
        ),
        optional(
          strings.mapArea,
          query.area == null ? null : strings.mapArea,
          () => context.go('/collections/map'),
          () => _set(_query.copyWith(area: (value: null))),
        ),
      ],
    );
  }

  // The pin of a search, named by its query so that it is kept once.
  OfflinePin _pinOf(LocalQuery query, AppLocalizations strings) {
    final json = queryToJson(query);
    return OfflinePin.search(
      json,
      query.text.isEmpty ? strings.storagePinKind('search') : query.text,
      id: jsonEncode(json).hashCode.toRadixString(36),
      created: DateTime.now().millisecondsSinceEpoch,
    );
  }

  Widget _results(int count) {
    final strings = AppLocalizations.of(context);
    final (pages, names) = _pagesOf(ref.read(searchQueryProvider));
    final stored = ref.watch(settingsProvider.select((s) => s.searchColumns));
    final columns = _levels.contains(stored)
        ? stored
        : const Settings().searchColumns;
    final zoom = ref.read(settingsProvider.notifier).setSearchColumns;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(start: AppTokens.of(context).md),
          child: Row(
            children: [
              Expanded(child: Text(strings.searchCount(count))),
              // While selecting, the selection bar's plays what is selected.
              ValueListenableBuilder(
                valueListenable: _selection,
                builder: (context, selected, _) => !selected.isEmpty
                    ? const SizedBox.shrink()
                    : IconButton(
                        icon: const Icon(Icons.slideshow_outlined),
                        tooltip: strings.slideshow,
                        onPressed: () => _slideshow(count),
                      ),
              ),
              OfflinePinButton(
                id: _pinOf(ref.read(searchQueryProvider), strings).id,
                make: () => _pinOf(ref.read(searchQueryProvider), strings),
              ),
              IconButton(
                icon: const Icon(Icons.zoom_out),
                tooltip: strings.zoomOut,
                onPressed: () => zoom(MediaGrid.step(_levels, columns, 1)),
              ),
              IconButton(
                icon: const Icon(Icons.zoom_in),
                tooltip: strings.zoomIn,
                onPressed: () => zoom(MediaGrid.step(_levels, columns, -1)),
              ),
            ],
          ),
        ),
        Expanded(
          child: MediaGrid(
            key: ObjectKey(pages),
            count: count,
            columns: columns,
            levels: _levels,
            onColumns: zoom,
            selection: _selection,
            itemBuilder: (context, i) => _Result(i, pages, _thumbnails, names),
            onOpen: (i) => _open(pages, count, i),
            onPress: (i) => decodeOnTouch(context, ref, pages, i),
            top: _top(count),
            onTop: (top) {
              if (_restored != true) return;
              ref.read(keptProvider.notifier).put(_topKey, {
                'count': count,
                'top': top,
              });
            },
          ),
        ),
      ],
    );
  }

  /// A slideshow of the [count] results, or of those at [only].
  Future<void> _slideshow(int count, [Selection? only]) async {
    final query = _query;
    final db = await ref.read(replicaProvider.future);
    if (!mounted) return;
    final pages = TimelinePages(
      (first, n) async => [
        for (final a in (await searchPage(
          db,
          query,
          limit: n,
          offset: first,
        )).items)
          itemOf(a),
      ],
      size: searchPageSize,
    );
    await SlideshowPage.show(
      context,
      SlideshowPage(
        pages: pages,
        count: count,
        at: only == null ? null : (slide) => only[slide],
      ),
    );
    pages.dispose();
  }

  // The selected results, in order, a page of the search at a time.
  Future<void> _download() async {
    final selected = _selection.value;
    final query = _query;
    final db = await ref.read(replicaProvider.future);
    if (!mounted) return;
    await download(
      context,
      ref,
      count: selected.count,
      items: () async* {
        int? at;
        var page = const <LocalAssetData>[];
        for (final i in selected.positions) {
          if (i ~/ searchPageSize != at) {
            at = i ~/ searchPageSize;
            page = (await searchPage(
              db,
              query,
              limit: searchPageSize,
              offset: at * searchPageSize,
            )).items;
          }
          if (page.elementAtOrNull(i % searchPageSize) case final item?) {
            yield itemOf(item);
          }
        }
      },
    );
  }

  Future<void> _pickDays() async {
    final days = _query.days;
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(1800),
      lastDate: DateTime(2100),
      initialDateRange: days == null
          ? null
          : DateTimeRange(start: days.first, end: days.last),
    );
    if (range != null) {
      _set(
        _query.copyWith(days: (value: (first: range.start, last: range.end))),
      );
    }
  }

  /// A folder of the source tree (ADR-0290), whose eyes and menus work as in
  /// Settings; the device clears the filter.
  Future<void> _pickFolder() async {
    final node = await showModalBottomSheet<SourceNode>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.8,
        child: Sources(onPick: (node) => Navigator.pop(context, node)),
      ),
    );
    if (node == null) return;
    _set(
      _query.copyWith(
        folder: (
          value: node.kind == SourceKind.device
              ? null
              : (
                  source: node.source.startsWith('mediastore:')
                      ? 'mediastore'
                      : 'folder',
                  volume: node.volume,
                  dir: node.key,
                ),
        ),
      ),
    );
  }

  Future<void> _pickCamera() async {
    final cameras = await searchCameras(await ref.read(replicaProvider.future));
    if (!mounted) return;
    final camera = await _choose(AppLocalizations.of(context).searchCamera, [
      for (final (:camera, :items) in cameras)
        (camera, cameraLabel(camera), items),
    ]);
    if (camera != null) _set(_query.copyWith(camera: (value: camera)));
  }

  /// One of [entries], each a value with its label and item count.
  Future<T?> _choose<T>(String title, List<(T, String, int)> entries) =>
      showModalBottomSheet<T>(
        context: context,
        showDragHandle: true,
        builder: (context) {
          final md = AppTokens.of(context).md;
          final formats = Formats.of(context);
          return ListView.builder(
            itemCount: entries.length + 1,
            itemBuilder: (context, i) {
              if (i == 0) {
                return ListTile(
                  title: Semantics(
                    header: true,
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                );
              }
              final (value, label, items) = entries[i - 1];
              return ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: md),
                title: Text(label),
                trailing: Text(formats.number(items)),
                onTap: () => Navigator.pop(context, value),
              );
            },
          );
        },
      );
}

/// A result: its thumbnail, with its file name and whether it is a video.
class _Result extends StatelessWidget {
  const new(this.index, this.pages, this.thumbnails, this.names);

  final int index;
  final TimelinePages pages;
  final Thumbnails thumbnails;
  final Map<int, String> names;

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      ThumbnailAt(index, pages, thumbnails),
      ListenableBuilder(
        listenable: pages,
        builder: (context, _) {
          final (item, name) = (pages[index] as ThumbnailItem?, names[index]);
          if (item == null || name == null) return const SizedBox.shrink();
          final xs = AppTokens.of(context).xs;
          // On scrims, as the timeline's badges are: legible on any photo.
          return Stack(
            children: [
              if (item.video)
                PositionedDirectional(
                  top: xs,
                  end: xs,
                  child: ColoredBox(
                    color: Colors.black54,
                    child: Icon(
                      Icons.videocam_outlined,
                      color: Colors.white,
                      size: 16,
                      semanticLabel: AppLocalizations.of(context).searchVideo,
                    ),
                  ),
                ),
              PositionedDirectional(
                start: 0,
                end: 0,
                bottom: 0,
                child: ColoredBox(
                  color: Colors.black54,
                  child: Padding(
                    padding: EdgeInsets.all(xs),
                    child: Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ],
  );
}
