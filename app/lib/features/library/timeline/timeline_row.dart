import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui show Codec, Image;
import 'dart:ui' show VertexMode, Vertices;

import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/rendering.dart' show SemanticsProperties;
import 'package:material_ui/material_ui.dart';
import 'package:photolib/features/library/timeline/pages.dart';
import 'package:photolib/features/library/timeline/pipeline.dart' show Mark;
import 'package:photolib/features/library/timeline/selection.dart';
import 'package:photolib/features/library/timeline/thumbnail_at.dart';
import 'package:photolib/features/library/timeline/thumbnails.dart';
import 'package:photolib/features/library/timeline/timeline_view.dart';
import 'package:photolib/features/viewer/animated.dart' show Frames;

/// What a row tells of a cell: why its decode failed, a video's duration,
/// whether it is a sphere and the item's [Mark]s, a bit each.
typedef _Cell = (Object?, Duration?, bool, int);

/// A row of cells: one leaf that paints a placeholder or the decoded thumbnail
/// of each cell, and asks for the thumbnails as soon as it is built.
class TimelineRow extends StatefulWidget {
  /// The [count] cells from the asset at [first], of a row of [columns].
  const new({
    required this.first,
    required this.count,
    required this.columns,
    required this.tier,
    required this.view,
    required this.clock,
    required this.cannotPlay,
    required this.noHeic,
    required this.excluded,
    required this.sphere,
    required this.markLabel,
    required this.describe,
    required this.onTap,
    required this.onLongPress,
    super.key,
  });

  /// The position of the asset in its first cell.
  final int first;

  /// How many of its cells have an asset.
  final int count;

  /// How many cells a row has.
  final int columns;

  /// The thumbnail tier its cells show.
  final int tier;

  /// The timeline whose pages, selection and thumbnails it shows.
  final TimelineView view;

  /// A video's duration as shown.
  final String Function(Duration) clock;

  /// What a video the platform cannot play says.
  final String cannotPlay;

  /// What a HEIC no decoder takes says.
  final String noHeic;

  /// What an excluded folder's item says.
  final String excluded;

  /// What a screen reader says of a sphere's cell.
  final String sphere;

  /// What a screen reader says of a mark.
  final String Function(Mark) markLabel;

  /// What a screen reader says of each cell.
  final String Function(int asset, {bool failed}) describe;

  /// A screen reader's tap on a cell.
  final void Function(int asset) onTap;

  /// A screen reader's long press on a cell.
  final void Function(int asset) onLongPress;

  @override
  State<TimelineRow> createState() => _RowState();
}

class _RowState extends State<TimelineRow> {
  final ValueNotifier<int> _repaint = ValueNotifier(0);
  var _wanted = false;
  // The row's items once their page arrives, the pages they came from, and
  // their placeholders.
  List<Object>? _items;
  TimelinePages? _from;
  var _meshes = const <Int32List?>[];

  TimelineView get _view => widget.view;

  @override
  void initState() {
    super.initState();
    _view.pages.addListener(_load);
    _view.selection.addListener(_selected);
  }

  // Which cells are selected, while anything is.
  List<bool>? _marks;
  var _cells = const <_Cell>[];
  var _badges = const <(IconData, String)?>[];

  List<bool>? _marksOf(Selection selection) => selection.isEmpty
      ? null
      : [
          for (var a = widget.first; a < widget.first + widget.count; a++)
            selection.contains(a),
        ];

  // A drag-select changes a row or two a frame: only those rebuild.
  void _selected() {
    if (!listEquals(_marksOf(_view.selection.value), _marks)) {
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _load();
  }

  @override
  void didUpdateWidget(TimelineRow old) {
    super.didUpdateWidget(old);
    if (!identical(old.view.pages, _view.pages)) {
      old.view.pages.removeListener(_load);
      _view.pages.addListener(_load);
    }
    if (!identical(old.view.selection, _view.selection)) {
      old.view.selection.removeListener(_selected);
      _view.selection.addListener(_selected);
    }
    // A new snapshot of the same row keeps showing the last until it loads.
    if (old.first != widget.first || old.count != widget.count) {
      _unwant(old);
      _items = _from = null;
      _meshes = const [];
    } else if (old.tier != widget.tier ||
        !identical(old.view.thumbnails, _view.thumbnails)) {
      _unwant(old);
    }
    _load();
  }

  @override
  void dispose() {
    _view.pages.removeListener(_load);
    _view.selection.removeListener(_selected);
    _unwant(widget);
    _repaint.dispose();
    super.dispose();
  }

  void _load() {
    final row = widget;
    final pages = _view.pages;
    // Rows hear of every page that arrives: a row with its items ignores it.
    if (!identical(_from, pages)) {
      final items = <Object>[];
      for (var a = row.first; a < row.first + row.count; a++) {
        final item = pages[a];
        if (item == null) return;
        items.add(item);
      }
      _from = pages;
      Int32List? mesh(int i) =>
          _view.placeholder?.call(items[i])?.square(_RowPainter.grid);
      if (listEquals(items, _items) && !listEquals(_cellsOf(items), _cells)) {
        // The same items, marked otherwise: their tiles stay.
        setState(() => _items = items);
      } else if (!listEquals(items, _items)) {
        _unwant(row);
        // A rebuild, as the painter of a row built before its page arrived
        // has no items.
        setState(() {
          _items = items;
          _meshes = [for (var i = 0; i < items.length; i++) mesh(i)];
        });
      } else if (_meshes.contains(null)) {
        // A newer snapshot may bring ThumbHashes the warm-up kept.
        final meshes = [
          for (var i = 0; i < items.length; i++) _meshes[i] ?? mesh(i),
        ];
        if (meshes.nonNulls.length > _meshes.nonNulls.length) {
          setState(() {
            _items = items;
            _meshes = meshes;
          });
        }
      }
    }
    _want();
  }

  // Why each cell's decode failed, a video's duration, whether it is a sphere
  // and the item's marks: a screen reader hears of them.
  List<_Cell> _cellsOf([List<Object>? items]) => [
    for (final item in items ?? _items ?? const <Object>[])
      (
        _view.thumbnails.failure(item, widget.tier),
        _view.duration?.call(item),
        _view.sphere?.call(item) ?? false,
        (_view.marks?.call(item) ?? const {}).fold(
          0,
          (mask, mark) => mask | 1 << mark.index,
        ),
      ),
  ];

  void _ready() {
    _repaint.value++;
    if (!listEquals(_cellsOf(), _cells)) setState(() {});
  }

  void _want() {
    final items = _items;
    if (!mounted || _wanted || items == null) return;
    _wanted = true;
    for (var i = 0; i < items.length; i++) {
      _view.thumbnails.want(
        items[i],
        widget.tier,
        _ready,
        at: widget.first + i,
      );
    }
  }

  void _unwant(TimelineRow row) {
    if (!_wanted) return;
    _wanted = false;
    for (final item in _items ?? const <Object>[]) {
      row.view.thumbnails.unwant(item, row.tier, _ready);
    }
  }

  @override
  Widget build(BuildContext context) {
    _marks = _marksOf(_view.selection.value);
    _cells = _cellsOf();
    _badges = [
      for (final item in _items ?? const <Object>[]) _view.badge?.call(item),
    ];
    final row = CustomPaint(
      painter: _RowPainter(
        widget,
        _items,
        _meshes,
        _marks,
        _cells,
        _badges,
        Theme.of(context).colorScheme,
        Directionality.of(context),
        _repaint,
      ),
    );
    final over = [for (var i = 0; i < widget.columns; i++) _over(i)];
    if (over.every((cell) => cell == null)) return row;
    return Stack(
      fit: StackFit.expand,
      children: [
        row,
        Row(
          children: [
            for (final cell in over) Expanded(child: cell ?? const SizedBox()),
          ],
        ),
      ],
    );
  }

  /// What lies over cell [i]: a marked cell's tooltip, which says why when
  /// the pointer rests on it while a long press still selects; an animated
  /// item's frames, or its badge.
  Widget? _over(int i) {
    if (_cells.elementAtOrNull(i)?.$1 case final failure?) {
      return Opacity(
        opacity: 0,
        child: FailureMark(failure, trigger: TooltipTriggerMode.manual),
      );
    }
    final item = _items?.elementAtOrNull(i);
    if (item == null || !(_view.animated?.call(item) ?? false)) return null;
    if (_view.animation case final animation? when _marks == null) {
      return _Playing(animation(item), key: ValueKey(item));
    }
    // On a scrim, as a video's duration is: legible on any photo.
    return const Align(
      alignment: AlignmentDirectional.topEnd,
      child: Padding(
        padding: EdgeInsets.all(4),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          child: Icon(Icons.gif_box, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

/// An animated item's frames as they play, cropped to its cell.
class _Playing extends StatefulWidget {
  const new(this.codec, {super.key});

  final Future<ui.Codec?> codec;

  @override
  State<_Playing> createState() => _PlayingState();
}

class _PlayingState extends State<_Playing> with TickerProviderStateMixin {
  Frames? _frames;
  ui.Image? _frame;

  @override
  void initState() {
    super.initState();
    unawaited(
      widget.codec.then((codec) {
        if (!mounted) return codec?.dispose();
        if (codec == null) return;
        _frames = Frames(codec, this, (frame) {
          setState(() {
            _frame?.dispose();
            _frame = frame;
          });
        });
      }, onError: (Object _) {}),
    );
  }

  @override
  void dispose() {
    _frames?.dispose();
    _frame?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(1),
    child: RawImage(image: _frame, fit: BoxFit.cover),
  );
}

/// Paints each cell's thumbnail, else another tier or the file's embedded
/// preview scaled to the cell, else its ThumbHash as a mesh whose vertices
/// have the hash's colours, which needs no decode, else a flat colour; a cell
/// whose decode failed has a mark on it, a video's its duration, and each its
/// badge.
class _RowPainter extends CustomPainter {
  new(
    this.row,
    this.items,
    this.meshes,
    this.selected,
    this.cells,
    this.badges,
    this.scheme,
    this.direction,
    Listenable repaint,
  ) : super(repaint: repaint);

  final TimelineRow row;
  final List<Object>? items;
  final List<Int32List?> meshes;

  /// Whether each cell is selected, while anything is.
  final List<bool>? selected;
  final List<_Cell> cells;
  final List<(IconData, String)?> badges;
  final ColorScheme scheme;
  final TextDirection direction;
  static final _marks = <(IconData, double, Color), TextPainter>{};
  // A paint per purpose, never recoloured: an image draws with its paint's
  // alpha.
  final _image = Paint()..filterQuality = FilterQuality.low;
  final _scrim = Paint()..color = Colors.black54;
  late final _empty = Paint()..color = scheme.surfaceContainerHighest;
  late final _check = Paint()..color = scheme.primary;
  late final Paint _ring = _line(scheme.surface);
  late final Paint _tick = _line(scheme.onPrimary);
  static const grid = 6;

  static Paint _line(Color color) => Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2
    ..strokeCap = StrokeCap.round;

  // i18n-ok: cells run from the start edge
  bool get _rtl => direction == TextDirection.rtl;

  Rect _cell(int i, Size size) {
    final cell = size.width / row.columns;
    final start = _rtl ? size.width - (i + 1) * cell : i * cell;
    return Rect.fromLTWH(start, 0, cell, size.height);
  }

  // Cell [i] as drawn: inset, more so while selected.
  Rect _inset(int i, Size size) {
    final box = _cell(i, size);
    return box.deflate((selected?[i] ?? false) ? box.width / 12 : 1);
  }

  // Text of [size] in [color], at most two lines of [width].
  TextPainter _text(String text, double size, Color color, double width) =>
      TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(fontSize: size, color: color),
        ),
        textAlign: TextAlign.center,
        textDirection: direction,
        maxLines: 2,
        ellipsis: '…',
      )..layout(maxWidth: width);

  @override
  void paint(Canvas canvas, Size size) {
    final positions = <double>[];
    final colors = <int>[];
    final indices = <int>[];
    final marks = <(Rect, Object)>[];
    final clocks = <(Rect, Duration)>[];
    final marked = <(Rect, int, bool, IconData?)>[];
    final spheres = <Rect>[];
    for (var i = 0; i < row.count; i++) {
      final rect = _inset(i, size);
      final item = items?[i];
      final image = item == null
          ? null
          : row.view.thumbnails.shown(item, row.tier);
      final (failure, duration, sphere, mask) =
          cells.elementAtOrNull(i) ?? (null, null, false, 0);
      marked.add((rect, mask, _excluded(i), badges.elementAtOrNull(i)?.$1));
      if (image == null && failure != null) marks.add((rect, failure));
      if (duration != null) clocks.add((rect, duration));
      if (sphere) spheres.add(rect);
      final mesh = item == null ? null : meshes[i];
      if (image != null) {
        _drawImage(canvas, image, rect);
      } else if (mesh != null) {
        _addMesh(rect, mesh, positions, colors, indices);
      } else {
        canvas.drawRect(rect, _empty);
      }
    }
    if (indices.isNotEmpty) {
      final vertices = Vertices.raw(
        VertexMode.triangles,
        Float32List.fromList(positions),
        colors: Int32List.fromList(colors),
        indices: Uint16List.fromList(indices),
      );
      canvas.drawVertices(vertices, BlendMode.dst, _image);
      vertices.dispose();
    }
    for (final (rect, failure) in marks) {
      _drawFailure(canvas, rect, failure);
    }
    // A video's duration at the bottom end, on a scrim.
    for (final (rect, duration) in clocks) {
      _drawClock(canvas, rect, duration);
    }
    for (final (rect, mask, out, state) in marked) {
      _drawBadges(canvas, rect, mask, excluded: out, state: state);
    }
    for (final rect in spheres) {
      _drawSphere(canvas, rect);
    }
    if (selected case final selected?) {
      for (var i = 0; i < row.count; i++) {
        _mark(canvas, _cell(i, size), selected[i]);
      }
    }
  }

  // The square at the centre of [image], scaled to [rect].
  void _drawImage(Canvas canvas, ui.Image image, Rect rect) {
    final side = image.width < image.height ? image.width : image.height;
    final source = Rect.fromCenter(
      center: Offset(image.width / 2, image.height / 2),
      width: side.toDouble(),
      height: side.toDouble(),
    );
    canvas.drawImageRect(image, source, rect, _image);
  }

  // Adds a grid over [rect] whose vertices have [mesh]'s colours, two
  // triangles a square.
  static void _addMesh(
    Rect rect,
    Int32List mesh,
    List<double> positions,
    List<int> colors,
    List<int> indices,
  ) {
    final base = positions.length ~/ 2;
    for (var y = 0; y <= grid; y++) {
      for (var x = 0; x <= grid; x++) {
        positions
          ..add(rect.left + rect.width * x / grid)
          ..add(rect.top + rect.height * y / grid);
        final v = base + y * (grid + 1) + x;
        if (x < grid && y < grid) {
          indices.addAll([
            v,
            v + 1,
            v + grid + 1,
            v + 1,
            v + grid + 2,
            v + grid + 1,
          ]);
        }
      }
    }
    colors.addAll(mesh);
  }

  // The mark of a decode's [failure] at the centre of [rect], and what an
  // unplayable video says.
  void _drawFailure(Canvas canvas, Rect rect, Object failure) {
    final icon = failureMark(failure);
    final hint = failure is NoThumbnail && failure.unplayable
        ? row.cannotPlay
        : null;
    final side = (rect.shortestSide / 3).clamp(12.0, 48.0).roundToDouble();
    final color = scheme.onSurfaceVariant;
    // Below the mark, where the cell has room for it.
    final words = hint == null || rect.width < 96
        ? null
        : _text(hint, 12, color, rect.width - 16);
    final mark = _icon(icon, side, color);
    final top = rect.center.dy - (mark.height + (words?.height ?? 0)) / 2;
    mark.paint(canvas, Offset(rect.center.dx - mark.width / 2, top));
    words?.paint(
      canvas,
      Offset(rect.center.dx - words.width / 2, top + mark.height),
    );
    words?.dispose();
  }

  void _drawClock(Canvas canvas, Rect rect, Duration duration) {
    final size = (rect.shortestSide / 10).clamp(10.0, 14.0);
    final clock = _text(row.clock(duration), size, Colors.white, rect.width);
    final end = _rtl ? rect.left + 4 : rect.right - 4;
    final box = Rect.fromLTWH(
      _rtl ? end : end - clock.width - 8,
      rect.bottom - 4 - clock.height - 2,
      clock.width + 8,
      clock.height + 2,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(box, const Radius.circular(4)),
      _scrim,
    );
    clock
      ..paint(canvas, box.topLeft + const Offset(4, 1))
      ..dispose();
  }

  // At the bottom start, the state's corner (ADR-0215): an [excluded]
  // folder's item has an eye struck through on a scrim, then its backup
  // [state] on a scrim (ADR-0267), then the item's marks of [mask], white over
  // a shadow.
  void _drawBadges(
    Canvas canvas,
    Rect rect,
    int mask, {
    required bool excluded,
    IconData? state,
  }) {
    var x = _rtl ? rect.right - 4 : rect.left + 4;
    if (excluded) {
      final side = (rect.shortestSide / 6).clamp(12.0, 20.0).roundToDouble();
      final eye = _icon(Icons.visibility_off_outlined, side, Colors.white);
      final box = Rect.fromLTWH(
        _rtl ? rect.right - eye.width - 12 : rect.left + 4,
        rect.bottom - eye.height - 8,
        eye.width + 8,
        eye.height + 4,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(box, const Radius.circular(4)),
        _scrim,
      );
      eye.paint(canvas, box.topLeft + const Offset(4, 2));
      x = _rtl ? box.left - 2 : box.right + 2;
    }
    final side = (rect.shortestSide / 8).clamp(12.0, 20.0).roundToDouble();
    if (state != null) {
      final icon = _icon(state, side, Colors.white);
      final center = Offset(
        _rtl ? x - side / 2 - 2 : x + side / 2 + 2,
        rect.bottom - 6 - side / 2,
      );
      canvas.drawCircle(center, side / 2 + 2, _scrim);
      icon.paint(canvas, center - Offset(icon.width / 2, icon.height / 2));
      x += _rtl ? -side - 6 : side + 6;
    }
    for (final mark in Mark.values) {
      if (mask & 1 << mark.index == 0) continue;
      final icon = _icon(markIcon(mark), side, Colors.white);
      final at = Offset(_rtl ? x - side : x, rect.bottom - 4 - icon.height);
      _icon(markIcon(mark), side, Colors.black54).paint(canvas, at + _shadow);
      icon.paint(canvas, at);
      x += _rtl ? -side - 2 : side + 2;
    }
  }

  // A sphere's badge at the top end, on a scrim.
  void _drawSphere(Canvas canvas, Rect rect) {
    final side = (rect.shortestSide / 8).clamp(14.0, 20.0).roundToDouble();
    final badge = _icon(Icons.threesixty, side, Colors.white);
    final center = Offset(
      _rtl ? rect.left + 4 + side / 2 + 2 : rect.right - 4 - side / 2 - 2,
      rect.top + 4 + side / 2 + 2,
    );
    canvas.drawCircle(center, side / 2 + 2, _scrim);
    badge.paint(canvas, center - Offset(badge.width / 2, badge.height / 2));
  }

  bool _excluded(int i) => switch (items?.elementAtOrNull(i)) {
    final item? => row.view.excluded?.call(item) ?? false,
    null => false,
  };

  static const _shadow = Offset(0.5, 1);

  // [icon] at [side] in [color], laid out once.
  TextPainter _icon(IconData icon, double side, Color color) =>
      _marks.putIfAbsent(
        (icon, side, color),
        () => TextPainter(
          text: TextSpan(
            text: String.fromCharCode(icon.codePoint),
            style: TextStyle(
              fontFamily: icon.fontFamily,
              package: icon.fontPackage,
              fontSize: side,
              color: color,
            ),
          ),
          textDirection: direction,
        )..layout(),
      );

  // A check in a filled circle on a selected cell, an empty ring on others,
  // at the cell's top start.
  void _mark(Canvas canvas, Rect cell, bool on) {
    const r = 10.0;
    const inset = 16.0;
    final center = _rtl
        ? cell.topRight + const Offset(-inset, inset)
        : cell.topLeft + const Offset(inset, inset);
    if (!on) {
      canvas.drawCircle(center, r, _ring);
      return;
    }
    final tick = center + const Offset(-1.5, 3.5);
    canvas
      ..drawCircle(center, r, _check)
      ..drawLine(center + const Offset(-5, 0), tick, _tick)
      ..drawLine(tick, center + const Offset(5, -4), _tick);
  }

  @override
  SemanticsBuilderCallback get semanticsBuilder =>
      (size) => [
        for (var i = 0; i < row.count; i++)
          CustomPainterSemantics(
            key: ValueKey(row.first + i),
            rect: _cell(i, size),
            properties: SemanticsProperties(
              label: row.describe(
                row.first + i,
                failed: cells.elementAtOrNull(i)?.$1 != null,
              ),
              value: [
                if (cells.elementAtOrNull(i)?.$3 ?? false) row.sphere,
                if (cells.elementAtOrNull(i)?.$2 case final duration?)
                  row.clock(duration),
                for (final mark in Mark.values)
                  if ((cells.elementAtOrNull(i)?.$4 ?? 0) & 1 << mark.index !=
                      0)
                    row.markLabel(mark),
              ].join(', '),
              hint: switch (cells.elementAtOrNull(i)?.$1) {
                NoThumbnail(unplayable: true) => row.cannotPlay,
                NoThumbnail(noHevc: true) => row.noHeic,
                _ when _excluded(i) => row.excluded,
                _ => null,
              },
              tooltip: badges.elementAtOrNull(i)?.$2,
              textDirection: direction,
              selected: selected?[i],
              onTap: () => row.onTap(row.first + i),
              onLongPress: () => row.onLongPress(row.first + i),
            ),
          ),
      ];

  @override
  bool shouldRebuildSemantics(_RowPainter old) => shouldRepaint(old);

  @override
  bool shouldRepaint(_RowPainter old) =>
      !identical(old.items, items) ||
      !listEquals(old.selected, selected) ||
      !listEquals(old.cells, cells) ||
      !listEquals(old.badges, badges) ||
      old.scheme != scheme ||
      old.row.first != row.first ||
      old.row.count != row.count ||
      old.row.tier != row.tier ||
      old.direction != direction;
}
