import 'dart:async';

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/l10n/app_localizations.dart';
import 'package:photolib/l10n/formats.dart';
import 'package:photolib/ui/adaptive.dart';
import 'package:photolib_data/photolib_data.dart';

/// What the menu of a node does (ADR-0290).
enum SourceAction {
  /// The library shows the node and nothing else of the device.
  showOnly,

  /// The node and everything below it show.
  showEverything,

  /// The node shows and the rest of the node above it hides.
  hideOthers,
}

/// The name of [node] as the user knows it.
String _label(AppLocalizations strings, SourceNode node) => switch (node.kind) {
  SourceKind.device => strings.sourceDevice,
  SourceKind.volume when node.volume == 'external_primary' =>
    strings.deviceFolderInternal,
  SourceKind.volume => strings.deviceFolderCard,
  SourceKind.root => isolated(node.volume),
  SourceKind.folder => node.name,
};

/// What [node] holds, how new, and its state: `count · newest · state`.
String _details(AppLocalizations strings, Formats formats, SourceNode node) {
  final newest = node.newest;
  return [
    switch (node.state) {
      SourceState.scanning => strings.folderScanning(node.itemsBelow),
      SourceState.offline => strings.folderOffline(node.itemsBelow),
      SourceState.lost => strings.sourceLost,
      SourceState.gone => strings.deviceFolderAbsent,
      SourceState.present => strings.folderItems(node.itemsBelow),
    },
    if (newest != null)
      formats.date(
        DateTime(newest ~/ 10000, newest ~/ 100 % 100, newest % 100),
      ),
    if (node.kind == SourceKind.device)
      if (node.shown) strings.deviceFoldersAll else strings.deviceFoldersChosen,
    if (node.partly) strings.sourcePartly,
  ].join(' · ');
}

IconData _icon(SourceNode node) => switch (node.kind) {
  SourceKind.device => Icons.devices_outlined,
  SourceKind.volume when node.volume == 'external_primary' =>
    Icons.smartphone_outlined,
  SourceKind.volume => Icons.sd_card_outlined,
  // A scanning root is read.
  _
      when node.state != SourceState.present &&
          node.state != SourceState.scanning =>
    Icons.folder_off_outlined,
  SourceKind.root => Icons.folder_special_outlined,
  _ when node.appOwned => Icons.apps_outlined,
  _ => Icons.folder_outlined,
};

/// The device's sources as one tree (ADR-0290), the same on every platform:
/// a row a node, each with its eye; a hidden node and those below it dimmed,
/// never removed. Volumes and roots open, folders closed; a search keeps the
/// nodes above what it finds. A long press or a right click offers the
/// [SourceAction]s; arrows, space and typing work it from the keyboard. A
/// list on phones; on wider windows, beside the node in focus.
class SourceTree extends StatefulWidget {
  /// The tree of [root].
  const new({
    required this.root,
    super.key,
    this.onShow,
    this.onAction,
    this.onPick,
    this.actions,
  });

  /// The device: what the tree shows.
  final SourceNode root;

  /// Shows a node or keeps it out: its eye. Without, the rows have none.
  final void Function(SourceNode node, {required bool shown})? onShow;

  /// Does the menu's action on a node. Without, there is no menu.
  final void Function(SourceNode node, SourceAction action)? onAction;

  /// Picks a node; without, a tap opens or closes it.
  final void Function(SourceNode node)? onPick;

  /// What a node's state offers: access again, forgetting it, a removal.
  final List<Widget> Function(SourceNode node)? actions;

  @override
  State<SourceTree> createState() => _SourceTreeState();
}

class _SourceTreeState extends State<SourceTree> {
  // Nodes opened or closed against their default, and while searching those
  // with what it found below.
  final _toggled = <String>{};
  final _found = <String>{};
  final _scroll = ScrollController();
  final _focus = FocusNode();
  // The row in focus.
  final GlobalKey _row = GlobalKey();
  var _search = '';
  var _at = 0;
  var _typed = '';
  Timer? _typing;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _typing?.cancel();
    _scroll.dispose();
    _focus.dispose();
    super.dispose();
  }

  static String _id(SourceNode n) => '${n.volume}\n${n.key}';

  bool get _searching => _search.trim().isNotEmpty;

  /// Whether [n] shows what is below it: opened, or found below it.
  bool _open(SourceNode n) => _searching
      ? _found.contains(_id(n))
      : (n.kind != SourceKind.folder) != _toggled.contains(_id(n));

  void _toggle(SourceNode n) => setState(() {
    if (!_searching && !_toggled.remove(_id(n))) _toggled.add(_id(n));
  });

  /// The rows on show: what is in open nodes, or while searching what it
  /// finds and the nodes above it; each with its depth.
  List<(SourceNode, int)> _rows(AppLocalizations strings) {
    final query = _search.trim().toLowerCase();
    _found.clear();
    List<(SourceNode, int)> walk(SourceNode n, int depth) {
      final below = [
        if (_searching || _open(n))
          for (final c in n.children) ...walk(c, depth + 1),
      ];
      if (below.isNotEmpty) _found.add(_id(n));
      final label = _label(strings, n).toLowerCase();
      return query.isEmpty || below.isNotEmpty || label.contains(query)
          ? [(n, depth), ...below]
          : const [];
    }

    return walk(widget.root, 0);
  }

  /// Focuses row [at] of [count] and scrolls it into view: near, where it is
  /// built; far, by the rows' mean height first.
  void _go(int at, int count) {
    setState(() => _at = at.clamp(0, count - 1));
    void show() {
      if (_row.currentContext case final row?) {
        Scrollable.ensureVisible(row, alignment: 0.5);
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_row.currentContext != null || !_scroll.hasClients) return show();
      final p = _scroll.position;
      _scroll.jumpTo(
        (_at * (p.maxScrollExtent + p.viewportDimension) / count).clamp(
          0,
          p.maxScrollExtent,
        ),
      );
      WidgetsBinding.instance.addPostFrameCallback((_) => show());
    });
  }

  void _select(int at, int count) {
    _focus.requestFocus();
    _go(at, count);
  }

  void _tap(SourceNode node, int at, int count) {
    _select(at, count);
    if (widget.onPick case final pick?) {
      pick(node);
    } else if (node.children.isNotEmpty) {
      _toggle(node);
    }
  }

  KeyEventResult _key(KeyEvent e, List<(SourceNode, int)> rows) {
    if (e is KeyUpEvent || rows.isEmpty) return KeyEventResult.ignored;
    final (node, depth) = rows[_at];
    // i18n-ok: the arrows into and out of a node follow the reading direction.
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final key = e.logicalKey;
    final into =
        key ==
        (rtl ? LogicalKeyboardKey.arrowLeft : LogicalKeyboardKey.arrowRight);
    final out =
        key ==
        (rtl ? LogicalKeyboardKey.arrowRight : LogicalKeyboardKey.arrowLeft);
    if (key == LogicalKeyboardKey.arrowDown || (into && _open(node))) {
      _go(_at + 1, rows.length);
    } else if (key == LogicalKeyboardKey.arrowUp) {
      _go(_at - 1, rows.length);
    } else if ((into || out) &&
        node.children.isNotEmpty &&
        into != _open(node)) {
      _toggle(node);
    } else if (out) {
      _go(rows.lastIndexWhere((r) => r.$2 < depth, _at), rows.length);
    } else if (key == LogicalKeyboardKey.space) {
      widget.onShow?.call(node, shown: !node.shown);
    } else if (key == LogicalKeyboardKey.enter) {
      _tap(node, _at, rows.length);
    } else if (e.character case final c? when c.trim().isNotEmpty) {
      _typeAhead(c, rows);
    } else {
      return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  /// Moves to the next row whose name starts with what was typed within the
  /// last second.
  void _typeAhead(String c, List<(SourceNode, int)> rows) {
    _typing?.cancel();
    _typing = Timer(const Duration(seconds: 1), () => _typed = '');
    _typed += c.toLowerCase();
    final strings = AppLocalizations.of(context);
    final from = _typed.length == 1 ? _at + 1 : _at;
    for (var i = 0; i < rows.length; i++) {
      final at = (from + i) % rows.length;
      if (_label(strings, rows[at].$1).toLowerCase().startsWith(_typed)) {
        return _go(at, rows.length);
      }
    }
  }

  Future<void> _menu(SourceNode node, Offset at) async {
    final onAction = widget.onAction;
    final overlay = Overlay.of(context).context.findRenderObject();
    if (onAction == null || overlay is! RenderBox) return;
    final action = await showMenu<SourceAction>(
      context: context,
      position: RelativeRect.fromRect(
        at & Size.zero,
        Offset.zero & overlay.size,
      ),
      items: [
        for (final a in _actionsOf(node))
          PopupMenuItem(value: a, child: Text(_actionLabel(context, a))),
      ],
    );
    if (action != null) onAction(node, action);
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final rows = _rows(strings);
    _at = rows.isEmpty ? 0 : _at.clamp(0, rows.length - 1);
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = WindowSize.of(constraints.maxWidth) == WindowSize.expanded;
        Widget row(int i) => _Row(
          key: i == _at ? _row : null,
          tree: this,
          node: rows[i].$1,
          depth: rows[i].$2,
          focused: i == _at && (wide || _focus.hasFocus),
          onTap: () => _tap(rows[i].$1, i, rows.length),
          onSelect: () => _select(i, rows.length),
        );
        final list = Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: strings.deviceFoldersSearch,
                  hintMaxLines: 3,
                ),
                onChanged: (text) => setState(() => _search = text),
              ),
            ),
            Expanded(
              child: Focus(
                focusNode: _focus,
                onKeyEvent: (_, e) => _key(e, rows),
                child: ListView.builder(
                  controller: _scroll,
                  itemCount: rows.length,
                  itemBuilder: (context, i) => row(i),
                ),
              ),
            ),
          ],
        );
        if (!wide || rows.isEmpty) return list;
        return Row(
          children: [
            Expanded(flex: 3, child: list),
            const VerticalDivider(width: 1),
            Expanded(flex: 2, child: _Details(this, rows[_at].$1)),
          ],
        );
      },
    );
  }
}

List<SourceAction> _actionsOf(SourceNode node) => node.kind == SourceKind.device
    ? const [SourceAction.showEverything]
    : SourceAction.values;

String _actionLabel(BuildContext context, SourceAction action) {
  final strings = AppLocalizations.of(context);
  return switch (action) {
    SourceAction.showOnly => strings.sourceShowOnly,
    SourceAction.showEverything => strings.sourceShowEverything,
    SourceAction.hideOthers => strings.sourceHideOthers,
  };
}

/// A node's eye: shown, hidden, or hidden with something shown below (an
/// outline); faint when it inherits.
class _Eye extends StatelessWidget {
  const new(this.node, this.label, this.onShow);

  final SourceNode node;
  final String label;
  final void Function(SourceNode node, {required bool shown}) onShow;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final inherits =
        node.visibility == SourceVisibility.inherit &&
        node.kind != SourceKind.device;
    return IconButton(
      icon: Icon(
        node.partly
            ? Icons.visibility_off_outlined
            : node.shown
            ? Icons.visibility
            : Icons.visibility_off,
        color: inherits ? Theme.of(context).colorScheme.outline : null,
      ),
      tooltip: node.shown
          ? strings.sourceHide(label)
          : strings.sourceShow(label),
      onPressed: () => onShow(node, shown: !node.shown),
    );
  }
}

class _Row extends StatelessWidget {
  const new({
    required this.tree,
    required this.node,
    required this.depth,
    required this.focused,
    required this.onTap,
    required this.onSelect,
    super.key,
  });

  final _SourceTreeState tree;
  final SourceNode node;
  final int depth;
  final bool focused;
  final VoidCallback onTap;

  /// Focuses the row, as a right click or a long press does before its menu.
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final material = MaterialLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    // Hidden: text as faint as legible text may be, the icon fainter.
    final dim = node.shown ? null : scheme.onSurfaceVariant;
    final label = _label(strings, node);
    final open = tree._open(node);
    final onShow = tree.widget.onShow;
    void menu(Offset at) {
      onSelect();
      unawaited(tree._menu(node, at));
    }

    final onAction = tree.widget.onAction;
    // A right click opens the menu where it is; a long press, which screen
    // readers offer too, over the row.
    return GestureDetector(
      excludeFromSemantics: true,
      onSecondaryTapUp: onAction == null ? null : (d) => menu(d.globalPosition),
      child: ListTile(
        selected: focused,
        contentPadding: EdgeInsetsDirectional.only(start: 16.0 * depth, end: 8),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // As wide whether it opens or not, at every density.
            SizedBox(
              width: 48,
              child: node.children.isEmpty
                  ? null
                  : IconButton(
                      icon: Icon(
                        open ? Icons.expand_more : Icons.chevron_right,
                      ),
                      tooltip: open
                          ? material.expandedIconTapHint
                          : material.collapsedIconTapHint,
                      onPressed: tree._searching
                          ? null
                          : () => tree._toggle(node),
                    ),
            ),
            Icon(_icon(node), color: node.shown ? null : scheme.outline),
          ],
        ),
        title: Text(label, style: TextStyle(color: dim)),
        subtitle: Text(_details(strings, Formats.of(context), node)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...?tree.widget.actions?.call(node),
            if (onShow != null) _Eye(node, label, onShow),
          ],
        ),
        onTap: onTap,
        onLongPress: onAction == null
            ? null
            : () {
                if (context.findRenderObject() case final RenderBox box) {
                  menu(box.localToGlobal(box.size.center(Offset.zero)));
                }
              },
      ),
    );
  }
}

/// The node in focus, beside the tree on a wide window: where it is, what
/// it holds, and what its menu does, as buttons.
class _Details extends StatelessWidget {
  const new(this.tree, this.node);

  final _SourceTreeState tree;
  final SourceNode node;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final onAction = tree.widget.onAction;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: Icon(_icon(node)),
          title: Text(
            _label(strings, node),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          subtitle: Text(
            [
              _details(strings, Formats.of(context), node),
              if (node.key.isNotEmpty)
                isolated(node.key.substring(0, node.key.length - 1)),
            ].join('\n'),
          ),
        ),
        Wrap(
          spacing: 8,
          children: [
            ...?tree.widget.actions?.call(node),
            if (tree.widget.onShow case final onShow?)
              _Eye(node, _label(strings, node), onShow),
            if (onAction != null)
              for (final a in _actionsOf(node))
                TextButton(
                  onPressed: () => onAction(node, a),
                  child: Text(_actionLabel(context, a)),
                ),
          ],
        ),
      ],
    );
  }
}
