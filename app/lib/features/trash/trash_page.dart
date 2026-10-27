import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/core/deletion.dart';
import 'package:photolib/core/replica.dart';
import 'package:photolib/features/library/library.dart';
import 'package:photolib/features/library/timeline/pages.dart';
import 'package:photolib/features/library/timeline/pipeline.dart';
import 'package:photolib/features/library/timeline/providers.dart';
import 'package:photolib/features/library/timeline/thumbnail_at.dart';
import 'package:photolib/features/library/timeline/thumbnails.dart';
import 'package:photolib/features/search/search.dart' show itemOf;
import 'package:photolib/features/servers/servers.dart' show sessionProvider;
import 'package:photolib/features/settings/settings.dart';
import 'package:photolib/features/trash/trash.dart';
import 'package:photolib/l10n/app_localizations.dart';
import 'package:photolib/ui/empty_state.dart';
import 'package:photolib/ui/tokens.dart';
import 'package:photolib_data/photolib_data.dart'
    show LocalAssetData, Mutations;

/// The trash (docs/10 §5.4): what was moved there, each with the time it has
/// left, restored or deleted for good from here only. Deleting for good asks
/// once, unless the platform asks itself.
class TrashPage extends ConsumerStatefulWidget {
  /// The trash.
  const new({super.key});

  /// The trash as a page pushed over the app.
  static Route<void> route() =>
      MaterialPageRoute(builder: (context) => const TrashPage());

  @override
  ConsumerState<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends ConsumerState<TrashPage> {
  late final _thumbnails = Thumbnails(
    (item, tier, tile) => ref
        .read(thumbnailPipelineProvider.future)
        .then((pipeline) => pipeline.load(item as ThumbnailItem, tier, tile)),
    video: (item) => (item as ThumbnailItem).video,
  );
  var _selected = <int>{};
  List<LocalAssetData>? _shown;
  TimelinePages? _pages;

  @override
  void dispose() {
    _pages?.dispose();
    _thumbnails.clear();
    super.dispose();
  }

  // Cells read the rows shown, a snapshot of the trash.
  TimelinePages _pagesOf(List<LocalAssetData> rows) {
    if ((identical(rows, _shown), _pages) case (true, final pages?)) {
      return pages;
    }
    _pages?.dispose();
    _shown = rows;
    _selected = {};
    return _pages = TimelinePages(
      (first, count) async => [
        for (final row in rows.skip(first).take(count)) itemOf(row),
      ],
      size: 256,
    );
  }

  Future<void> _restore(List<LocalAssetData> rows) async {
    final service = await ref.read(deletionProvider.future);
    if (!mounted) return;
    await tryChange(
      context,
      () => service.restore([for (final r in rows) r.id]),
    );
  }

  Future<void> _forget(List<LocalAssetData> rows) async {
    final service = await ref.read(deletionProvider.future);
    if (!mounted) return;
    await tryChange(
      context,
      () => service.forget([for (final r in rows) r.id]),
    );
  }

  /// Deletes [rows] for good and, with [remote] items of the server's trash,
  /// asks it to empty that too: it deletes their files and objects through
  /// its intent log, and a trash it holds back as large answers its own count
  /// to confirm (ADR-0386).
  Future<void> _purge(List<LocalAssetData> rows, {int remote = 0}) async {
    final platformOf = ref.read(mediaPlatformProvider);
    final service = await ref.read(deletionProvider.future);
    final session = ref.read(sessionProvider);
    var asked = rows.isNotEmpty && remote == 0;
    for (final source in {for (final r in rows) r.source}) {
      asked = asked && await platformOf(source).asksFirst();
    }
    if (!mounted ||
        !asked && !await _confirm(rows.length + remote) ||
        !mounted) {
      return;
    }
    final pipeline = ref.read(thumbnailPipelineProvider).value;
    await tryChange(context, () async {
      for (final gone in await service.purge([for (final r in rows) r.id])) {
        await pipeline?.forget(itemOf(gone));
      }
    });
    if (remote == 0 || session == null || !mounted) return;
    final db = await ref.read(replicaProvider.future);
    final outbox = Mutations(db);
    if (!mounted) return;
    var token = '';
    await tryChange(context, () async {
      while (true) {
        final answer = await outbox.emptyServerTrash(
          session,
          confirmToken: token,
        );
        final held = answer.held;
        if (held == null) return;
        if (!mounted || !await _confirm(held)) return;
        token = answer.token;
      }
    });
  }

  Future<bool> _confirm(int count) async {
    final strings = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(strings.trashConfirm(count)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(strings.actionDeleteForever),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  /// The app bar's buttons: what the selection can do, else empty the trash.
  List<Widget> _actions(
    AppLocalizations strings,
    List<LocalAssetData>? rows,
    int remote,
    List<LocalAssetData> chosen,
    List<LocalAssetData> gone,
  ) => [
    if (chosen.isNotEmpty && gone.length == chosen.length)
      // Nothing is left to restore or delete, only the entry.
      TextButton(
        onPressed: () => _forget(gone),
        child: Text(strings.trashRemoveGone),
      )
    else if (chosen.isNotEmpty) ...[
      TextButton(
        onPressed: () => _restore(chosen),
        child: Text(strings.actionRestore),
      ),
      TextButton(
        onPressed: () => _purge(chosen),
        child: Text(strings.actionDeleteForever),
      ),
    ] else if ((rows, remote) case (final rows?, final remote)
        when rows.isNotEmpty || remote > 0)
      TextButton(
        onPressed: () => _purge(rows, remote: remote),
        child: Text(strings.trashEmptyAll),
      ),
  ];

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final rows = ref.watch(trashProvider(ref.watch(veiledProvider))).value;
    final pages = rows == null ? null : _pagesOf(rows);
    // The server's trash, where there is a server to empty it.
    final remote = ref.watch(sessionProvider) == null
        ? 0
        : ref.watch(serverTrashProvider).value ?? 0;
    final chosen = [
      for (final (i, row) in (rows ?? const <LocalAssetData>[]).indexed)
        if (_selected.contains(i)) row,
    ];
    final now = DateTime.now().millisecondsSinceEpoch;
    // Entries whose time went by and that are still here: the platform no
    // longer holds the items.
    final gone = [
      for (final row in chosen)
        if ((row.expires ?? now + 1) <= now) row,
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.trashTitle),
        actions: _actions(strings, rows, remote, chosen, gone),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(AppTokens.of(context).md),
            child: Text(
              strings.trashRetention(ref.watch(settingsProvider).trashDays),
            ),
          ),
          Expanded(
            child: switch ((rows, pages)) {
              (final rows? && [_, ...], final pages?) => GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 160,
                ),
                itemCount: rows.length,
                itemBuilder: (context, i) => _Cell(
                  thumbnail: ThumbnailAt(i, pages, _thumbnails),
                  daysLeft: switch (rows[i].expires) {
                    final expires? =>
                      ((expires - now) / Duration.millisecondsPerDay)
                          .ceil()
                          .clamp(0, 1 << 20),
                    null => null,
                  },
                  selected: _selected.contains(i),
                  onTap: () => setState(
                    () => _selected.contains(i)
                        ? _selected.remove(i)
                        : _selected.add(i),
                  ),
                ),
              ),
              ([], _) => EmptyState(
                icon: Icons.delete_outline,
                message: strings.trashEmpty,
              ),
              _ => const SizedBox.shrink(),
            },
          ),
        ],
      ),
    );
  }
}

/// An item in the trash: its thumbnail and the days it has left, a tap
/// selecting it.
class _Cell extends StatelessWidget {
  const new({
    required this.thumbnail,
    required this.daysLeft,
    required this.selected,
    required this.onTap,
  });

  final Widget thumbnail;
  final int? daysLeft;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      selected: selected,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: EdgeInsets.all(selected ? 8 : 0),
              child: thumbnail,
            ),
            if (daysLeft case final days?)
              PositionedDirectional(
                top: 4,
                end: 4,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      AppLocalizations.of(context).trashDaysLeft(days),
                      style: Theme.of(context).textTheme.labelSmall
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            if (selected)
              PositionedDirectional(
                top: 4,
                start: 4,
                child: Icon(Icons.check_circle, color: scheme.primary),
              ),
          ],
        ),
      ),
    );
  }
}
