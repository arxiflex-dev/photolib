import 'package:drift/drift.dart';
import 'package:photolib_data/photolib_data.dart';

/// A node's own visibility: the nearest node at or above one that has its
/// own decides whether the library shows it (ADR-0290).
enum SourceVisibility {
  /// As the node above.
  inherit,

  /// Shown, and what below inherits.
  shown,

  /// Hidden, and what below inherits.
  hidden,
}

/// What a node of the source tree is.
enum SourceKind {
  /// The device, whose own visibility is the mode of ADR-0210.
  device,

  /// A MediaStore volume.
  volume,

  /// A folder a desktop or a browser added.
  root,

  /// A folder in a volume or root.
  folder,
}

/// Whether the files of a node can be read.
enum SourceState {
  /// Its files are there.
  present,

  /// A root's first scan is under way.
  scanning,

  /// A card out, a drive away.
  offline,

  /// A root the app may read no more: a macOS bookmark, a browser's
  /// permission.
  lost,

  /// Its row is kept, with no items.
  gone,
}

/// A local source or one of its folders, as the source tree shows it.
class SourceNode {
  /// A node; [children] in the order they show.
  const SourceNode({
    required this.source,
    required this.volume,
    required this.key,
    required this.name,
    required this.kind,
    this.id,
    this.items = 0,
    this.itemsBelow = 0,
    this.newest,
    this.state = SourceState.present,
    this.visibility = SourceVisibility.inherit,
    this.shown = true,
    this.partly = false,
    this.appOwned = false,
    this.children = const [],
  });

  /// `mediastore:<volume>`, `folder:<root>` or `fsa:<name>`; '' for the
  /// device.
  final String source;

  /// The volume of its device folder rows: MediaStore's, or a root; ''
  /// for the device.
  final String volume;

  /// Its path under [volume], ending in `/`; '' for the volume itself.
  final String key;

  /// Its folder's name; a volume's or root's [volume].
  final String name;

  /// What it is.
  final SourceKind kind;

  /// Its device folder row; null for a folder above buckets with none yet.
  final int? id;

  /// Its own items.
  final int items;

  /// Its items with those of every folder below, the hidden and archived in
  /// none; an offline root's all.
  final int itemsBelow;

  /// The newest day, `yyyymmdd`, of its items and those below.
  final int? newest;

  /// Whether its files can be read.
  final SourceState state;

  /// Its own visibility.
  final SourceVisibility visibility;

  /// Whether the library shows its own items.
  final bool shown;

  /// Hidden, with a node below it shown.
  final bool partly;

  /// Whether an app keeps it, as messengers do: shown collapsed.
  final bool appOwned;

  /// The nodes below it, in the order they show.
  final List<SourceNode> children;

  /// The key of the node above it in its volume; null for a volume or root,
  /// whose parent is the device, and for the device.
  String? get parent => key.isEmpty
      ? null
      : key.substring(0, key.lastIndexOf('/', key.length - 2) + 1);
}

/// [node] and every node below it, parents first.
Iterable<SourceNode> flatten(SourceNode node) sync* {
  yield node;
  for (final child in node.children) {
    yield* flatten(child);
  }
}

/// The device's sources as one tree: the device, whose own visibility is
/// the mode, its volumes and folder roots, and their folders, with the
/// folders above buckets that hold none. [lost] are the roots the app can
/// no longer read.
Future<SourceNode> sourceTree(Replica db, {Set<String> lost = const {}}) async {
  final roots = {for (final s in await db.folderSummary().get()) s.root: s};
  final volumes = <String, Map<String, DeviceFoldersResult>>{
    for (final root in roots.keys) root: {},
  };
  for (final f in await db.deviceFolders().get()) {
    (volumes[f.volume] ??= {})[f.path] = f;
  }
  // Hidden and archived items leave the library's views, and so its counts.
  final shownIn = {
    for (final c in await db.shownInFolders().get()) c.folder: c,
  };
  final shown = !await onlyChosen(db);
  final order = volumes.keys.toList()
    ..sort(
      (a, b) => a == 'external_primary'
          ? -1
          : b == 'external_primary'
          ? 1
          : a.compareTo(b),
    );
  final children = [
    for (final v in order)
      _Fold(
        v,
        volumes[v]!,
        roots[v],
        shownIn,
        lost: lost.contains(v),
      ).node('', above: shown),
  ];
  return SourceNode(
    source: '',
    volume: '',
    key: '',
    name: '',
    kind: SourceKind.device,
    visibility: shown ? SourceVisibility.shown : SourceVisibility.hidden,
    shown: shown,
    partly: !shown && children.any(_showsAny),
    itemsBelow: children.fold(0, (n, c) => n + c.itemsBelow),
    newest: _latest([for (final c in children) c.newest]),
    children: children,
  );
}

/// [sourceTree], as it changes.
Stream<SourceNode> watchSourceTree(Replica db, {Set<String> lost = const {}}) =>
    db
        .customSelect(
          'SELECT 1',
          readsFrom: {
            db.deviceFolder,
            db.deviceFolderMode,
            db.timelineDay,
            db.mediaSource,
          },
        )
        .watch()
        .asyncMap((_) => sourceTree(db, lost: lost));

bool _showsAny(SourceNode n) => n.shown || n.children.any(_showsAny);

int? _latest(Iterable<int?> days) =>
    days.fold<int?>(null, (n, d) => d == null || (n != null && n >= d) ? n : d);

/// Messengers' folders: what an app keeps, shown collapsed.
final _appOwned = RegExp('^(Android|WhatsApp|Telegram|Signal|Viber)/');

/// The nodes of one volume or root, from its [rows] by path.
class _Fold {
  _Fold(this.volume, this.rows, this.root, this.shownIn, {required this.lost})
    : source = root == null
          ? 'mediastore:$volume'
          : '${_web ? 'fsa' : 'folder'}:$volume' {
    for (final path in [...rows.keys]) {
      for (var p = path; p.isNotEmpty; p = _parent(p)) {
        (_below[_parent(p)] ??= {}).add(p);
      }
    }
  }

  static const _web = bool.fromEnvironment('dart.library.js_interop');
  final String volume;
  final String source;
  final Map<String, DeviceFoldersResult> rows;

  /// The root's state and items, offline ones too; null for MediaStore.
  final FolderSummaryResult? root;

  /// What each folder shows, by its row.
  final Map<int, ShownInFoldersResult> shownIn;
  final bool lost;
  final _below = <String, Set<String>>{};

  static String _parent(String path) =>
      path.substring(0, path.lastIndexOf('/', path.length - 2) + 1);

  String _name(String key) => switch (rows[key]?.name) {
    final name? when name.isNotEmpty => name,
    _ when key.isEmpty => volume,
    _ => key.substring(_parent(key).length, key.length - 1),
  };

  SourceNode node(String key, {required bool above}) {
    final row = rows[key];
    final own = SourceVisibility.values.byName(row?.visibility ?? 'inherit');
    final shown = own == SourceVisibility.inherit
        ? above
        : own == SourceVisibility.shown;
    final children = [
      for (final k in _below[key] ?? const <String>{}) node(k, above: shown),
    ]..sort((a, b) => naturalCompare(a.name, b.name));
    final shownHere = shownIn[row?.id];
    final items = shownHere?.items ?? 0;
    final below = children.fold(items, (n, c) => n + c.itemsBelow);
    final top = key.isEmpty;
    return SourceNode(
      source: source,
      volume: volume,
      key: key,
      name: _name(key),
      kind: !top
          ? SourceKind.folder
          : root == null
          ? SourceKind.volume
          : SourceKind.root,
      id: row?.id,
      items: items,
      // A root away counts what the scan found; else what the library shows.
      itemsBelow: top && root?.state == 'offline' ? root!.items : below,
      newest: _latest([shownHere?.newest, for (final c in children) c.newest]),
      state: _state(top, below),
      visibility: own,
      shown: shown,
      partly: !shown && children.any(_showsAny),
      appOwned: root == null && _appOwned.hasMatch(key),
      children: children,
    );
  }

  SourceState _state(bool top, int items) {
    final away = lost
        ? SourceState.lost
        : switch (root?.state) {
            null when items == 0 => SourceState.offline,
            'offline' => SourceState.offline,
            _ => null,
          };
    if (top) {
      return away ??
          (root?.state == 'scanning'
              ? SourceState.scanning
              : SourceState.present);
    }
    return items > 0 ? SourceState.present : away ?? SourceState.gone;
  }
}

bool _digit(int c) => c >= 0x30 && c <= 0x39;

/// [a] before [b] by their runs of digits as numbers and the rest in any
/// case, so that `8` comes before `66`; never 0 for different names. It
/// scans both once, allocating nothing but their lower case: the source
/// tree sorts thousands of folders with it on every change.
int naturalCompare(String a, String b) {
  final (x, y) = (a.toLowerCase(), b.toLowerCase());
  var (i, j) = (0, 0);
  while (i < x.length && j < y.length) {
    if (!_digit(x.codeUnitAt(i)) || !_digit(y.codeUnitAt(j))) {
      final c = x.codeUnitAt(i++) - y.codeUnitAt(j++);
      if (c != 0) return c;
      continue;
    }
    // Two numbers: the longer without leading zeros is larger, else the
    // first digit that differs decides, else the one with fewer zeros.
    var (p, q) = (i, j);
    while (p < x.length && x.codeUnitAt(p) == 0x30) {
      p++;
    }
    while (q < y.length && y.codeUnitAt(q) == 0x30) {
      q++;
    }
    var (e, f) = (p, q);
    while (e < x.length && _digit(x.codeUnitAt(e))) {
      e++;
    }
    while (f < y.length && _digit(y.codeUnitAt(f))) {
      f++;
    }
    var c = (e - p) - (f - q);
    for (var k = 0; c == 0 && k < e - p; k++) {
      c = x.codeUnitAt(p + k) - y.codeUnitAt(q + k);
    }
    if (c == 0) c = (e - i) - (f - j);
    if (c != 0) return c;
    (i, j) = (e, f);
  }
  final c = (x.length - i) - (y.length - j);
  return c != 0 ? c : a.compareTo(b);
}

/// Sets the own visibility of the folder [path] of [volume], adding its row
/// when it has none; of the device ([volume] ''), its mode.
Future<void> setVisibility(
  Replica db,
  String volume,
  String path,
  SourceVisibility visibility,
) async {
  if (volume.isEmpty) {
    return await setOnlyChosen(db, on: visibility == SourceVisibility.hidden);
  }
  final values = DeviceFolderCompanion(
    visibility: Value(visibility.name),
    fresh: const Value(0),
  );
  await db
      .into(db.deviceFolder)
      .insert(
        values.copyWith(volume: Value(volume), path: Value(path)),
        onConflict: DoUpdate(
          (_) => values,
          target: [db.deviceFolder.volume, db.deviceFolder.path],
        ),
      );
}
