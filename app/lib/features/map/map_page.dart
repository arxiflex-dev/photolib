import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:material_ui/material_ui.dart';
import 'package:photolib/core/errors.dart';
import 'package:photolib/core/replica.dart';
import 'package:photolib/features/download/download_action.dart';
import 'package:photolib/features/folders/folders_page.dart'
    show pageThumbnails;
import 'package:photolib/features/library/timeline/pages.dart';
import 'package:photolib/features/library/timeline/pipeline.dart';
import 'package:photolib/features/library/timeline/selection.dart';
import 'package:photolib/features/library/timeline/thumbnail_at.dart';
import 'package:photolib/features/library/timeline/thumbnails.dart';
import 'package:photolib/features/map/map_logic.dart';
import 'package:photolib/features/map/map_state.dart';
import 'package:photolib/features/map/tracks.dart';
import 'package:photolib/features/search/search.dart';
import 'package:photolib/features/settings/settings.dart';
import 'package:photolib/features/trash/trash.dart';
import 'package:photolib/features/viewer/viewer_page.dart';
import 'package:photolib/l10n/app_localizations.dart';
import 'package:photolib/l10n/formats.dart';
import 'package:photolib/ui/empty_state.dart';
import 'package:photolib/ui/media_grid.dart';
import 'package:photolib/ui/selection_bar.dart';
import 'package:photolib/ui/tokens.dart';
import 'package:photolib_api/kernel.dart' show MapCluster, MapFilter;
import 'package:photolib_data/photolib_data.dart' show Area;

/// The most photos the grid under the map holds.
const int mapGridLimit = 300;

/// The most photos a trip's lines are drawn from.
const int mapTripLimit = 2000;

const _levels = [2, 3, 4, 6];

/// The map (F-11): every located photo and video, clustered by the kernel
/// for the part and zoom on screen, with a time range, a lasso, a heatmap,
/// GPX tracks, the photos of the area in a grid under it, and the area as a
/// search filter.
class MapPage extends ConsumerStatefulWidget {
  /// The map; a benchmark brings its [controller] to move the camera and
  /// hears each [onQuery]'s time in the kernel and back.
  const new({super.key, this.controller, this.onQuery});

  /// The camera's controller, else the page's own.
  final MapController? controller;

  /// Called with how long the kernel took to answer a query (with its asset
  /// list in the split view), for the benchmark of the map.
  final void Function(Duration took, int clusters)? onQuery;

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  late final MapController _controller = widget.controller ?? MapController();
  final ValueNotifier<Selection> _selection = ValueNotifier(Selection.none);
  late final Thumbnails _thumbnails = pageThumbnails(ref);
  List<MapCluster> _clusters = const [];
  ({List<ThumbnailItem> items, TimelinePages pages, int total})? _grid;
  var _heat = false;
  var _split = false;
  var _trips = false;
  List<List<LatLng>> _tripLines = const [];
  var _lassoMode = false;
  var _ready = false;
  var _columns = 3;
  RangeValues _range = const RangeValues(0, 1);
  List<double> _lasso = const [];
  List<Offset> _drawing = const [];
  List<Track> _tracks = const [];
  var _busy = false;
  var _again = false;

  @override
  void dispose() {
    _grid?.pages.dispose();
    _selection.dispose();
    _thumbnails.clear();
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  MapFilter? _filter(MapData data) {
    final span = data.span;
    final time = span == null
        ? null
        : timeFilter(span, _range.start, _range.end);
    if (_lasso.isEmpty) return time;
    return (time ?? MapFilter())..polygon.addAll(_lasso);
  }

  /// Asks the kernel for what the camera shows, one question at a time and the
  /// last one asked.
  Future<void> _refresh() async {
    final data = ref.read(mapDataProvider).value;
    if (data == null || !_ready) return;
    if (_busy) {
      _again = true;
      return;
    }
    _busy = true;
    try {
      do {
        _again = false;
        await _query(data);
      } while (_again && mounted);
    } finally {
      _busy = false;
    }
  }

  Future<void> _query(MapData data) async {
    final bounds = _controller.camera.visibleBounds;
    final v = viewport(bounds.west, bounds.south, bounds.east, bounds.north);
    final filter = _filter(data);
    final zoom = _controller.camera.zoom.floor().clamp(0, 20);
    final started = Stopwatch()..start();
    final clusters = await data.index.query(
      v.west,
      v.south,
      v.east,
      v.north,
      zoom,
      filter: filter,
    );
    widget.onQuery?.call(started.elapsed, clusters.length);
    var trips = const <List<LatLng>>[];
    if (_trips) {
      final found = await data.index.assets(
        v.west,
        v.south,
        v.east,
        v.north,
        filter: filter,
        limit: mapTripLimit,
      );
      trips = [
        for (final line in tripLines(data.points, found.assets))
          [for (final (lat, lon) in line) LatLng(lat, lon)],
      ];
    }
    List<ThumbnailItem>? items;
    var total = 0;
    if (_split) {
      final found = await data.index.assets(
        v.west,
        v.south,
        v.east,
        v.north,
        filter: filter,
        limit: mapGridLimit,
      );
      total = found.total;
      final db = await ref.read(replicaProvider.future);
      items = await mapThumbnails(db, [
        for (final i in found.assets) data.points.ids[i],
      ]);
    }
    if (!mounted) return;
    setState(() {
      _clusters = clusters;
      _tripLines = trips;
      if (items != null) {
        _grid?.pages.dispose();
        _selection.value = Selection.none;
        final shown = items;
        _grid = (
          items: shown,
          total: total,
          pages: TimelinePages(
            (first, count) async => shown.skip(first).take(count).toList(),
          ),
        );
      }
    });
  }

  void _toggleTrips() {
    setState(() => _trips = !_trips);
    unawaited(_refresh());
  }

  void _toggleSplit() {
    setState(() {
      _split = !_split;
      if (!_split) {
        _grid?.pages.dispose();
        _grid = null;
      }
    });
    unawaited(_refresh());
  }

  MapBox get _view {
    final b = _controller.camera.visibleBounds;
    return viewport(b.west, b.south, b.east, b.north);
  }

  void _searchHere() {
    final v = _view;
    var area = Area(west: v.west, south: v.south, east: v.east, north: v.north);
    if (_lasso.isNotEmpty) {
      final lats = [for (var i = 0; i < _lasso.length; i += 2) _lasso[i]];
      final lons = [for (var i = 1; i < _lasso.length; i += 2) _lasso[i]];
      area = Area(
        west: lons.reduce(math.min),
        south: lats.reduce(math.min),
        east: lons.reduce(math.max),
        north: lats.reduce(math.max),
      );
    }
    ref
        .read(searchQueryProvider.notifier)
        .set(ref.read(searchQueryProvider).copyWith(area: (value: area)));
    context.go('/search');
  }

  Future<void> _openCluster(MapCluster c) async {
    if (c.count > 1 || !c.hasAsset()) {
      final zoom = math.min(_controller.camera.zoom + 2, 18).toDouble();
      _controller.move(LatLng(c.latitude, c.longitude), zoom);
      return;
    }
    final data = ref.read(mapDataProvider).value;
    final db = await ref.read(replicaProvider.future);
    if (data == null || !mounted) return;
    final items = await mapThumbnails(db, [data.points.ids[c.asset]]);
    if (items.isEmpty || !mounted) return;
    await openInViewer(context, ref, items);
  }

  void _drawn(MapData data) {
    final camera = _controller.camera;
    final path = [
      for (final p in _drawing)
        (() {
          final at = camera.screenOffsetToLatLng(p);
          return (at.latitude, at.longitude);
        })(),
    ];
    setState(() {
      _lasso = lassoPolygon(path);
      _drawing = const [];
      _lassoMode = false;
    });
    unawaited(_refresh());
  }

  Future<void> _addTrack() async {
    final tracks = await ref.read(trackPickerProvider)();
    if (!mounted || tracks == null) return;
    if (tracks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).mapTrackBad)),
      );
      return;
    }
    setState(() => _tracks = [..._tracks, ...tracks]);
    final points = [
      for (final t in tracks)
        for (final p in t.points) LatLng(p.lat, p.lon),
    ];
    _controller.fitCamera(
      CameraFit.coordinates(
        coordinates: points,
        padding: const EdgeInsets.all(48),
        maxZoom: 16,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final data = ref.watch(mapDataProvider);
    ref.listen(mapDataProvider, (_, _) => unawaited(_refresh()));
    return ValueListenableBuilder(
      valueListenable: _selection,
      builder: (context, selected, body) => Scaffold(
        appBar: selected.isEmpty ? _bar(strings) : _selectionBar(selected),
        body: body,
      ),
      child: data.when(
        loading: () => Center(
          child: Semantics(
            label: strings.mapLoading,
            child: const CircularProgressIndicator(),
          ),
        ),
        error: (_, _) =>
            StoreErrorView(retry: () => ref.invalidate(mapDataProvider)),
        data: (data) => data.index.mapped == 0 && _tracks.isEmpty
            ? EmptyState(icon: Icons.map_outlined, message: strings.mapEmpty)
            : _body(data, strings),
      ),
    );
  }

  PreferredSizeWidget _bar(AppLocalizations strings) => AppBar(
    title: Text(strings.mapTitle),
    actions: [
      IconButton(
        icon: const Icon(Icons.route_outlined),
        tooltip: strings.mapAddTrack,
        onPressed: () => unawaited(_addTrack()),
      ),
      IconButton(
        icon: const Icon(Icons.search),
        tooltip: strings.mapSearchHere,
        onPressed: _ready ? _searchHere : null,
      ),
    ],
  );

  PreferredSizeWidget _selectionBar(Selection selected) {
    final items = _grid?.items ?? const <ThumbnailItem>[];
    final chosen = [for (final i in selected.positions) items[i]];
    return SelectionBar(
      count: selected.count,
      onClear: () => _selection.value = Selection.none,
      onSelectAll: () => _selection.value = Selection.none.add(0, items.length),
      onDownload: () => download(
        context,
        ref,
        count: chosen.length,
        items: () => Stream.fromIterable(chosen),
      ),
      actions: selectionActions(context, ref, () async {
        _selection.value = Selection.none;
        return [
          for (final c in chosen)
            if (c.id case final id?)
              (id: id, favourite: c.marks.contains(Mark.favourite)),
        ];
      }),
    );
  }

  Widget _body(MapData data, AppLocalizations strings) {
    final agreed = ref.watch(settingsProvider.select((s) => s.maps));
    final grid = _grid;
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Stack(
            children: [
              _map(data, agreed: agreed),
              ..._overlays(data, strings, agreed: agreed),
            ],
          ),
        ),
        if (_split && grid != null)
          Expanded(flex: 2, child: _gridView(strings, grid)),
      ],
    );
  }

  Widget _map(MapData data, {required bool agreed}) => FlutterMap(
    mapController: _controller,
    options: MapOptions(
      initialCenter: const LatLng(30, 10),
      initialZoom: 2,
      minZoom: 1,
      maxZoom: 18,
      interactionOptions: InteractionOptions(
        flags: _lassoMode
            ? InteractiveFlag.none
            : InteractiveFlag.all & ~InteractiveFlag.rotate,
      ),
      onMapReady: () {
        _ready = true;
        _fitAll(data);
        unawaited(_refresh());
      },
      onPositionChanged: (_, _) => unawaited(_refresh()),
    ),
    children: [
      if (agreed)
        TileLayer(
          urlTemplate: tileUrl,
          userAgentPackageName: 'org.photolib.app',
          tileProvider: ref.watch(mapTileProviderProvider),
        ),
      PolylineLayer(
        polylines: [
          for (final line in _tripLines)
            Polyline(
              points: line,
              color: Theme.of(context).colorScheme.tertiary,
              strokeWidth: 3,
            ),
          for (final t in _tracks)
            Polyline(
              points: [for (final p in t.points) LatLng(p.lat, p.lon)],
              color: t.activity.color,
              strokeWidth: 4,
            ),
        ],
      ),
      if (_lasso.isNotEmpty)
        PolygonLayer(
          polygons: [
            Polygon(
              points: [
                for (var i = 0; i < _lasso.length; i += 2)
                  LatLng(_lasso[i], _lasso[i + 1]),
              ],
              color: Theme.of(context).colorScheme.primary
                  .withValues(alpha: 0.15),
              borderColor: Theme.of(context).colorScheme.primary,
              borderStrokeWidth: 2,
            ),
          ],
        ),
      MarkerLayer(
        markers: [
          for (final c in _clusters)
            Marker(
              point: LatLng(c.latitude, c.longitude),
              width: _size(c.count),
              height: _size(c.count),
              child: _Dot(c, () => unawaited(_openCluster(c))),
            ),
        ],
      ),
    ],
  );

  List<Widget> _overlays(
    MapData data,
    AppLocalizations strings, {
    required bool agreed,
  }) {
    final tokens = AppTokens.of(context);
    return [
      if (_heat && _ready)
        IgnorePointer(
          child: CustomPaint(
            size: Size.infinite,
            painter: _HeatPainter(
              _clusters,
              _controller.camera,
              Theme.of(context).colorScheme.error,
            ),
          ),
        ),
      if (_lassoMode) _lassoLayer(data),
      PositionedDirectional(
        start: tokens.sm,
        top: tokens.sm,
        end: tokens.sm + 56,
        child: !agreed
            ? _Agreement(
                onAgree: ref.read(settingsProvider.notifier).agreeToMaps,
              )
            : const SizedBox.shrink(),
      ),
      PositionedDirectional(
        end: tokens.sm,
        top: tokens.sm,
        child: _controls(strings),
      ),
      if (agreed)
        PositionedDirectional(
          start: tokens.sm,
          bottom: tokens.sm + (data.span == null ? 0 : 56),
          child: Text(
            strings.mapAttribution,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      if (data.span case final span?)
        PositionedDirectional(
          start: 0,
          end: 0,
          bottom: 0,
          child: _slider(span, strings),
        ),
    ];
  }

  double _size(int count) =>
      count <= 1 ? 22 : 26 + 5 * math.log(count) / math.ln10;

  void _fitAll(MapData data) {
    final pts = data.points;
    if (pts.length == 0) return;
    var (minLat, maxLat, minLon, maxLon) = (90.0, -90.0, 180.0, -180.0);
    for (var i = 0; i < pts.length; i++) {
      final (lat, lon) = (pts.latitudes[i], pts.longitudes[i]);
      if (lat.abs() > 85 || lon.abs() > 180) continue;
      minLat = math.min(minLat, lat);
      maxLat = math.max(maxLat, lat);
      minLon = math.min(minLon, lon);
      maxLon = math.max(maxLon, lon);
    }
    if (minLat > maxLat) return;
    _controller.fitCamera(
      CameraFit.bounds(
        bounds: LatLngBounds(LatLng(minLat, minLon), LatLng(maxLat, maxLon)),
        padding: const EdgeInsetsDirectional.fromSTEB(
          32,
          72,
          72,
          88,
        ).resolve(Directionality.of(context)),
        maxZoom: 14,
      ),
    );
  }

  Widget _controls(AppLocalizations strings) {
    Widget button(
      IconData icon,
      String label,
      VoidCallback? onPressed, {
      bool on = false,
    }) => IconButton.filledTonal(
      icon: Icon(icon),
      tooltip: label,
      isSelected: on,
      onPressed: onPressed,
    );
    return Column(
      spacing: 4,
      children: [
        button(Icons.add, strings.zoomIn, () {
          _controller.move(
            _controller.camera.center,
            math.min(_controller.camera.zoom + 1, 18),
          );
        }),
        button(Icons.remove, strings.zoomOut, () {
          _controller.move(
            _controller.camera.center,
            math.max(_controller.camera.zoom - 1, 1),
          );
        }),
        button(
          Icons.gesture,
          strings.mapLasso,
          () => setState(() => _lassoMode = !_lassoMode),
          on: _lassoMode,
        ),
        if (_lasso.isNotEmpty)
          button(Icons.layers_clear_outlined, strings.mapClearLasso, () {
            setState(() => _lasso = const []);
            unawaited(_refresh());
          }),
        button(
          Icons.blur_on,
          strings.mapHeat,
          () => setState(() => _heat = !_heat),
          on: _heat,
        ),
        button(Icons.timeline, strings.mapTrips, _toggleTrips, on: _trips),
        button(
          Icons.view_agenda_outlined,
          strings.mapSplit,
          _toggleSplit,
          on: _split,
        ),
      ],
    );
  }

  Widget _lassoLayer(MapData data) => Positioned.fill(
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanStart: (d) => setState(() => _drawing = [d.localPosition]),
      onPanUpdate: (d) =>
          setState(() => _drawing = [..._drawing, d.localPosition]),
      onPanEnd: (_) => _drawn(data),
      child: CustomPaint(
        painter: _PathPainter(_drawing, Theme.of(context).colorScheme.primary),
      ),
    ),
  );

  Widget _slider(({int from, int to}) span, AppLocalizations strings) {
    final formats = Formats.of(context);
    DateTime at(double t) => DateTime.fromMillisecondsSinceEpoch(
      (span.from + (span.to - span.from) * t).round() * 1000,
    );
    return Material(
      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.85),
      child: Semantics(
        label: strings.mapTime,
        child: RangeSlider(
          values: _range,
          labels: RangeLabels(
            formats.date(at(_range.start)),
            formats.date(at(_range.end)),
          ),
          divisions: 200,
          onChanged: (r) => setState(() => _range = r),
          onChangeEnd: (_) => unawaited(_refresh()),
        ),
      ),
    );
  }

  Widget _gridView(
    AppLocalizations strings,
    ({List<ThumbnailItem> items, TimelinePages pages, int total}) grid,
  ) {
    return Column(
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: AppTokens.of(context).md,
              vertical: 4,
            ),
            child: Text(strings.mapPhotos(grid.total)),
          ),
        ),
        Expanded(
          child: MediaGrid(
            key: ObjectKey(grid.pages),
            count: grid.items.length,
            columns: _columns,
            levels: _levels,
            onColumns: (c) => setState(() => _columns = c),
            selection: _selection,
            itemBuilder: (context, i) =>
                ThumbnailAt(i, grid.pages, _thumbnails),
            onOpen: (i) =>
                unawaited(openInViewer(context, ref, grid.items, at: i)),
            onPress: (i) => decodeOnTouch(context, ref, grid.pages, i),
          ),
        ),
      ],
    );
  }
}

class _Agreement extends StatelessWidget {
  const new({required this.onAgree});

  final VoidCallback onAgree;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(strings.mapTilesAgree),
            TextButton(onPressed: onAgree, child: Text(strings.mapTilesShow)),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const new(this.cluster, this.onTap);

  final MapCluster cluster;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final one = cluster.count <= 1;
    return Semantics(
      button: true,
      excludeSemantics: true,
      label: AppLocalizations.of(context).mapPhotos(cluster.count),
      child: GestureDetector(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: one ? scheme.tertiary : scheme.primary,
            border: Border.all(color: scheme.onPrimary, width: 2),
          ),
          child: Center(
            child: one
                ? null
                : Text(
                    _short(cluster.count),
                    style: TextStyle(color: scheme.onPrimary, fontSize: 12),
                  ),
          ),
        ),
      ),
    );
  }

  static String _short(int n) => n < 1000
      ? '$n'
      : n < 1000000
      ? '${(n / 1000).round()}k'
      : '${(n / 1000000).round()}M';
}

class _HeatPainter extends CustomPainter {
  new(this.clusters, this.camera, this.colour);

  final List<MapCluster> clusters;
  final MapCamera camera;
  final Color colour;

  @override
  void paint(Canvas canvas, Size size) {
    const cell = 24.0;
    final cells = heatCells(
      clusters,
      (lat, lon) => camera.latLngToScreenOffset(LatLng(lat, lon)),
      size,
      cell: cell,
    );
    for (final c in cells) {
      final paint = Paint()
        ..color = colour.withValues(alpha: 0.15 + 0.55 * math.sqrt(c.weight))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
      canvas.drawCircle(
        Offset((c.col + 0.5) * cell, (c.row + 0.5) * cell),
        cell,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_HeatPainter old) =>
      !identical(old.clusters, clusters) || old.camera != camera;
}

class _PathPainter extends CustomPainter {
  new(this.path, this.colour);

  final List<Offset> path;
  final Color colour;

  @override
  void paint(Canvas canvas, Size size) {
    if (path.length < 2) return;
    final paint = Paint()
      ..color = colour
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawPath(Path()..addPolygon(path, false), paint);
  }

  @override
  bool shouldRepaint(_PathPainter old) => old.path != path;
}
