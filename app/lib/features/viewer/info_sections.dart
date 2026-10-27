import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/features/folders/folders_page.dart'
    show addToChosenAlbum;
import 'package:photolib/features/library/timeline/pipeline.dart';
import 'package:photolib/features/viewer/info_facts.dart';
import 'package:photolib/features/viewer/info_history_labels.dart';
import 'package:photolib/features/viewer/info_panel.dart' show takenOf;
import 'package:photolib/l10n/app_localizations.dart';
import 'package:photolib/l10n/formats.dart';
import 'package:photolib_data/photolib_data.dart' show LocalAssetData;

/// The description, saved as it is typed (M3-04).
class DescriptionField extends StatefulWidget {
  /// [id]'s description, as [text] says, kept by [facts].
  const new(this.id, this.text, this.facts, {super.key});

  /// The item's id.
  final Uint8List id;

  /// The description as kept.
  final Stream<String> text;

  /// Where its data is kept.
  final InfoFacts facts;

  @override
  State<DescriptionField> createState() => _DescriptionFieldState();
}

class _DescriptionFieldState extends State<DescriptionField> {
  final _controller = TextEditingController();
  StreamSubscription<String>? _heard;

  @override
  void initState() {
    super.initState();
    _heard = widget.text.listen((text) {
      if (text != _controller.text) _controller.text = text;
    });
  }

  @override
  void dispose() {
    unawaited(_heard?.cancel());
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: TextField(
      controller: _controller,
      maxLines: null,
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context).infoDescription,
        border: InputBorder.none,
      ),
      onChanged: (text) => unawaited(widget.facts.describe(widget.id, text)),
    ),
  );
}

/// The date and time with its time zone, an inline why (the resolver's
/// source and rule) and, where the date can change, an edit; a date read in
/// the file name says so.
class DateRow extends StatefulWidget {
  /// [asset]'s date.
  const new(this.asset, this.facts, {super.key});

  /// The item's row.
  final LocalAssetData asset;

  /// Where its data is kept.
  final InfoFacts facts;

  @override
  State<DateRow> createState() => _DateRowState();
}

class _DateRowState extends State<DateRow> {
  var _why = false;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final formats = Formats.of(context);
    final a = widget.asset;
    final source = a.timeSource;
    final named = source?.startsWith('filename:') ?? false;
    final zone = switch (a.tzOffsetMin) {
      final m? => ' UTC${m < 0 ? '−' : '+'}${_hm(m.abs())}',
      null => '',
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          leading: const Icon(Icons.event_outlined),
          title: Text('${takenOf(a, formats) ?? strings.timelineUndated}$zone'),
          subtitle: named ? Text(strings.infoFromFileName) : null,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.info_outline),
                tooltip: strings.infoWhy,
                isSelected: _why,
                onPressed: () => setState(() => _why = !_why),
              ),
              if (widget.facts.retimes)
                IconButton(
                  icon: const Icon(Icons.edit_calendar_outlined),
                  tooltip: strings.infoEditDate,
                  onPressed: _edit,
                ),
            ],
          ),
        ),
        if (_why)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(72, 0, 16, 8),
            child: Text(
              [
                strings.infoWhyBecause(switch (source) {
                  null => 'pending',
                  'unknown' => 'unknown',
                  _ when named => 'name',
                  _ when source.startsWith('path:') => 'folder',
                  _ when source.startsWith('takeout:') => 'host',
                  _ => 'metadata',
                }, source ?? ''),
                if (a.timeConfidence case final c?)
                  strings.infoConfidence(formats.percent(c)),
              ].join('\n'),
            ),
          ),
      ],
    );
  }

  String _hm(int minutes) =>
      '${minutes ~/ 60}${minutes % 60 == 0 ? '' : ':${minutes % 60}'}';

  Future<void> _edit() async {
    final was =
        DateTime.tryParse(widget.asset.takenLocal ?? '') ?? DateTime.now();
    final day = await showDatePicker(
      context: context,
      initialDate: was,
      firstDate: DateTime(1826),
      lastDate: DateTime(2100),
    );
    if (day == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(was),
    );
    if (time == null) return;
    await widget.facts.retime(
      widget.asset.id,
      DateTime(day.year, day.month, day.day, time.hour, time.minute),
    );
  }
}

/// The faces on the item (M5-10), round crops of the [image] with their
/// names, an unnamed one Add name on a dashed circle; hovering or focusing
/// one [onOutline]s it on the photo, and a toggle keeps all outlined.
class People extends StatefulWidget {
  /// The people on [id].
  const new(this.id, this.facts, {this.image, this.onOutline, super.key});

  /// The item's id.
  final Uint8List id;

  /// Where its data is kept.
  final InfoFacts facts;

  /// The picture the faces are cropped from.
  final ui.Image? image;

  /// Outlines faces on the photo.
  final ValueChanged<List<InfoFace>>? onOutline;

  @override
  State<People> createState() => _PeopleState();
}

class _PeopleState extends State<People> {
  var _all = false;
  List<InfoFace> _faces = const [];

  void _outline(List<InfoFace> faces) =>
      widget.onOutline?.call(_all ? _faces : faces);

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return StreamBuilder(
      stream: widget.facts.facesOf(widget.id),
      builder: (context, faces) {
        _faces = faces.data ?? const [];
        if (_faces.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final face in _faces) _face(context, strings, face),
              IconButton(
                icon: const Icon(Icons.center_focus_weak),
                tooltip: strings.infoShowFaces,
                isSelected: _all,
                onPressed: () {
                  setState(() => _all = !_all);
                  _outline(const []);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _face(BuildContext context, AppLocalizations strings, InfoFace face) {
    final name = face.name;
    return MouseRegion(
      onEnter: (_) => _outline([face]),
      onExit: (_) => _outline(const []),
      child: Focus(
        onFocusChange: (on) => _outline(on ? [face] : const []),
        child: InkWell(
          key: ValueKey(face),
          customBorder: const CircleBorder(),
          onTap: () => widget.facts.openPerson(context, face),
          child: SizedBox(
            width: 64,
            child: Column(
              children: [
                SizedBox.square(
                  dimension: 48,
                  child: CustomPaint(
                    painter: _FaceCrop(
                      name == null ? null : widget.image,
                      face.box,
                      Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ),
                Text(
                  name ?? strings.infoAddName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The [box] of [image] in a circle, or a dashed circle without an image.
class _FaceCrop extends CustomPainter {
  new(this.image, this.box, this.colour);

  /// The picture the faces are cropped from.
  final ui.Image? image;

  /// Where it is, as fractions of the picture.
  final Rect box;
  final Color colour;
  late final _dashes = Paint()
    ..color = colour
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5;

  @override
  void paint(Canvas canvas, Size size) {
    final circle = Offset.zero & size;
    final image = this.image;
    if (image == null) {
      for (var a = 0.0; a < 2 * pi; a += pi / 8) {
        canvas.drawArc(circle.deflate(1), a, pi / 16, false, _dashes);
      }
      return;
    }
    final (w, h) = (image.width.toDouble(), image.height.toDouble());
    canvas
      ..clipPath(Path()..addOval(circle))
      ..drawImageRect(
        image,
        Rect.fromLTRB(box.left * w, box.top * h, box.right * w, box.bottom * h),
        circle,
        Paint(),
      );
  }

  @override
  bool shouldRepaint(_FaceCrop old) => old.image != image || old.box != box;
}

/// The edit history's row (docs/11 §2.5): how many versions and the last
/// change, which [onOpen]s the list; absent without versions.
class HistoryRow extends StatelessWidget {
  /// [id]'s history.
  const new(this.id, this.facts, {required this.onOpen, super.key});

  /// The item's id.
  final Uint8List id;

  /// Where its data is kept.
  final InfoFacts facts;

  /// Opens the list.
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) => StreamBuilder(
    stream: facts.versions(id),
    builder: (context, versions) {
      final all = versions.data ?? const [];
      if (all.isEmpty) return const SizedBox.shrink();
      final strings = AppLocalizations.of(context);
      return ListTile(
        leading: const Icon(Icons.history),
        title: Text(strings.infoHistory),
        subtitle: Text(
          strings.infoVersions(
            all.length,
            Formats.of(context).taken(all.map((v) => v.time).reduce(_later)),
          ),
        ),
        onTap: onOpen,
      );
    },
  );
}

DateTime _later(DateTime a, DateTime b) => a.isAfter(b) ? a : b;

/// The edit history in the panel: a card per version, newest first, the
/// current one marked, older ones reverted, any saved as a copy, and the
/// original [onCompare]d with while on.
class HistoryList extends StatefulWidget {
  /// [id]'s versions, left by [onBack].
  const new(
    this.id,
    this.facts, {
    required this.onBack,
    this.onCompare,
    super.key,
  });

  /// The item's id.
  final Uint8List id;

  /// Where its data is kept.
  final InfoFacts facts;

  /// Goes back to the rest of the info.
  final VoidCallback onBack;

  /// Shows a version instead of the item, or with null the item.
  final ValueChanged<ThumbnailItem?>? onCompare;

  @override
  State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  var _comparing = false;

  @override
  void dispose() {
    // Shows the item again once this frame is done.
    if (_comparing) {
      final compare = widget.onCompare;
      WidgetsBinding.instance.addPostFrameCallback((_) => compare?.call(null));
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final formats = Formats.of(context);
    return StreamBuilder(
      stream: widget.facts.versions(widget.id),
      builder: (context, versions) {
        final all = [...versions.data ?? const <InfoVersion>[]]
          ..sort((a, b) => b.time.compareTo(a.time));
        final original = all.where((v) => v.original).firstOrNull;
        // The edits are numbered from the oldest.
        final edits = [
          for (final v in all.reversed)
            if (!v.original) v,
        ];
        return ListView(
          children: [
            ListTile(
              leading: BackButton(onPressed: widget.onBack),
              title: Text(strings.infoHistory),
            ),
            if (original?.item != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FilterChip(
                  label: Text(strings.infoCompare),
                  selected: _comparing,
                  onSelected: (on) {
                    setState(() => _comparing = on);
                    widget.onCompare?.call(on ? original?.item : null);
                  },
                ),
              ),
            for (final v in all)
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.photo_outlined),
                      title: Text(
                        versionTitle(strings, v, edits.indexOf(v) + 1),
                      ),
                      subtitle: Text(versionDetail(strings, formats, v)),
                    ),
                    OverflowBar(
                      alignment: MainAxisAlignment.end,
                      children: [
                        if (!v.current)
                          TextButton(
                            onPressed: () => widget.facts.revert(widget.id, v),
                            child: Text(strings.infoRevert),
                          ),
                        if (widget.facts.savesCopies)
                          TextButton(
                            onPressed: () =>
                                widget.facts.saveCopy(widget.id, v),
                            child: Text(strings.infoSaveCopy),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

/// The albums the item is in (M3-01, docs/04 §5), Not in any album when
/// none: each with its folders above its name, its count and whether it is
/// shared, opened by a tap and left by its ✕ with a 5 s undo; the smart and
/// tag albums it matches marked Auto, with no ✕. The header adds it to one.
class Albums extends ConsumerWidget {
  /// [id]'s albums.
  const new(this.id, this.facts, {super.key});

  /// The item's id.
  final Uint8List id;

  /// Where its data is kept.
  final InfoFacts facts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return StreamBuilder(
      stream: facts.albums(id),
      builder: (context, own) => StreamBuilder(
        stream: facts.tags(id) ?? Stream.value(const <String>[]),
        builder: (context, tags) => StreamBuilder(
          stream: facts.tagAlbums(),
          builder: (context, tagAlbums) {
            final all = [
              ...?own.data,
              ...matchingTagAlbums(tagAlbums.data ?? const [], [...?tags.data]),
            ];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Heading(
                  strings.infoAlbums,
                  action: IconButton(
                    icon: const Icon(Icons.add),
                    tooltip: strings.actionAddToAlbum,
                    onPressed: () =>
                        unawaited(addToChosenAlbum(context, ref, [id])),
                  ),
                ),
                if (all.isEmpty)
                  ListTile(
                    title: Text(
                      strings.infoNoAlbum,
                      style: TextStyle(color: muted),
                    ),
                  ),
                for (final album in all) _album(context, strings, album, muted),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _album(
    BuildContext context,
    AppLocalizations strings,
    InfoAlbum album,
    Color muted,
  ) => ListTile(
    leading: const Icon(Icons.photo_album_outlined),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (album.path.isNotEmpty)
          Text(
            album.path.join(' › '),
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(color: muted),
          ),
        Text(album.name),
      ],
    ),
    subtitle: Text(
      [
        strings.infoItems(album.count),
        if (album.shared) strings.infoShared,
      ].join(' · '),
    ),
    trailing: album.auto
        ? Chip(label: Text(strings.infoAuto))
        : IconButton(
            icon: const Icon(Icons.close),
            tooltip: strings.infoRemoveFrom(album.name),
            onPressed: album.removable ? () => _leave(context, album) : null,
          ),
    onTap: () => facts.openAlbum(context, album),
  );

  Future<void> _leave(BuildContext context, InfoAlbum album) async {
    final strings = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    await facts.leave(id, album);
    messenger.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: Text(strings.infoRemovedFrom(album.name)),
        action: SnackBarAction(
          label: strings.actionUndo,
          onPressed: () => unawaited(facts.join(id, album)),
        ),
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const new(this.text, {this.action});

  final String text;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.only(start: 16, end: 8, top: 8),
    child: Row(
      children: [
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.titleSmall),
        ),
        ?action,
      ],
    ),
  );
}

/// The item's tags (M3-03), compact chips of parent and tag with a dot of
/// their top-level branch's colour and the whole path as a tooltip: a tap
/// opens the tag, its ✕ takes off that tag alone, and Add tag opens a
/// [TagField].
class Tags extends StatefulWidget {
  /// [id]'s [tags].
  const new(this.id, this.tags, this.facts, {super.key});

  /// The item's id.
  final Uint8List id;

  /// The item's tags, as paths.
  final Stream<List<String>> tags;

  /// Where its data is kept.
  final InfoFacts facts;

  @override
  State<Tags> createState() => _TagsState();
}

class _TagsState extends State<Tags> {
  var _adding = false;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return StreamBuilder(
      stream: widget.tags,
      builder: (context, tags) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Heading(strings.infoTags),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final tag in tags.data ?? const <String>[])
                  _chip(context, strings, tag),
                if (!_adding)
                  ActionChip(
                    avatar: const Icon(Icons.add, size: 18),
                    label: Text(strings.infoAddTag),
                    onPressed: () => setState(() => _adding = true),
                  ),
              ],
            ),
          ),
          if (_adding)
            TagField(
              widget.facts,
              onTag: (path) async {
                setState(() => _adding = false);
                await widget.facts.tag(widget.id, path);
              },
            ),
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, AppLocalizations strings, String tag) {
    final levels = tag.split('/');
    final shown = levels.skip(max(0, levels.length - 2)).join(' › ');
    return Tooltip(
      message: tag.replaceAll('/', ' › '),
      child: InputChip(
        avatar: CircleAvatar(backgroundColor: tagColour(levels.first)),
        label: Text(shown),
        visualDensity: VisualDensity.compact,
        onPressed: () => widget.facts.openTag(context, tag),
        deleteButtonTooltipMessage: strings.infoRemoveTag(shown),
        onDeleted: () => unawaited(widget.facts.untag(widget.id, tag)),
      ),
    );
  }
}

/// The colour of a top-level tag's branch.
Color tagColour(String top) =>
    Colors.primaries[top.codeUnits.fold(0, (a, b) => a * 31 + b) %
        Colors.primaries.length];

/// A field that takes a tag's path, `Travel/Greece/Hydra`, suggesting the
/// tags kept and their parents as it is typed, picked with the arrows and
/// Enter; what none matches is offered as a new tag.
class TagField extends StatefulWidget {
  /// A field whose choice [onTag] hears.
  const new(this.facts, {required this.onTag, super.key});

  /// Where its data is kept.
  final InfoFacts facts;

  /// Hears the tag chosen.
  final ValueChanged<String> onTag;

  @override
  State<TagField> createState() => _TagFieldState();
}

class _TagFieldState extends State<TagField> {
  final _controller = TextEditingController();
  // Every tag kept, once read; the suggestion picked.
  List<String> _tags = const [];
  var _at = 0;

  @override
  void initState() {
    super.initState();
    unawaited(
      widget.facts.allTags().then((all) {
        if (mounted) setState(() => _tags = all);
      }),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// What the typed path offers: the tags that match, then it as a new tag
  /// unless it is one.
  List<(String, bool)> get _offers {
    final path = tagPath(_controller.text);
    final found = tagSuggestions(_tags, path);
    return [
      for (final tag in found) (tag, false),
      if (path.isNotEmpty && !found.contains(path)) (path, true),
    ];
  }

  KeyEventResult _key(FocusNode _, KeyEvent event) {
    final offers = _offers;
    if (event is KeyUpEvent || offers.isEmpty) return KeyEventResult.ignored;
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowDown) {
      setState(() => _at = (_at + 1) % offers.length);
    } else if (key == LogicalKeyboardKey.arrowUp) {
      setState(() => _at = (_at - 1) % offers.length);
    } else if (key == LogicalKeyboardKey.enter) {
      widget.onTag(offers[min(_at, offers.length - 1)].$1);
    } else {
      return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final offers = _offers;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Focus(
        onKeyEvent: _key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              key: const ValueKey('tag-field'),
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(hintText: strings.infoAddTag),
              onChanged: (_) => setState(() => _at = 0),
            ),
            for (final (i, (path, fresh)) in offers.indexed)
              ListTile(
                dense: true,
                selected: i == _at,
                leading: Icon(fresh ? Icons.add : Icons.sell_outlined),
                title: Text(
                  fresh
                      ? strings.infoNewTag(path)
                      : path.replaceAll('/', ' › '),
                ),
                onTap: () => widget.onTag(path),
              ),
          ],
        ),
      ),
    );
  }
}
