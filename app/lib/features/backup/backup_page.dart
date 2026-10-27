import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/core/replica.dart';
import 'package:photolib/features/backup/backup.dart';
import 'package:photolib/features/servers/server_pages.dart';
import 'package:photolib/features/servers/servers.dart';
import 'package:photolib/l10n/app_localizations.dart';
import 'package:photolib/l10n/formats.dart';
import 'package:photolib/ui/adaptive.dart';
import 'package:photolib/ui/tokens.dart';
import 'package:photolib_data/photolib_data.dart';

/// The folders holding the device's items, again after each backup run.
final backupFoldersProvider = FutureProvider<List<BackupFolder>>((ref) async {
  ref.watch(backupProvider);
  return await backupFolders(await ref.watch(replicaProvider.future));
});

/// What waits, by state and reason, again whenever it changes.
final backupReasonsProvider = StreamProvider<List<BackupReasonsResult>>((
  ref,
) async* {
  yield* (await ref.watch(replicaProvider.future)).backupReasons().watch();
});

/// A folder's name as a person knows it: its path below the folder added,
/// else the last name of the folder added.
String folderName(BackupFolder f) => f.dir.isNotEmpty
    ? f.dir.substring(0, f.dir.length - 1)
    : f.volume.split(RegExp(r'[/\\]')).lastWhere((n) => n.isNotEmpty);

/// The key `backupWhy` explains the items of [state] waiting for [reason] by.
String _why(String state, String? reason) => switch ((state, reason)) {
  ('selected', null) => 'selected',
  ('failed', 'quota.exceeded') => 'quota',
  (
    'hashing' || 'dedup_check' || 'preparing' || 'uploading' || 'verifying',
    _,
  ) =>
    'working',
  ('waiting_for_icloud', _) => 'waiting_for_icloud',
  (_, final reason?) => reason,
  _ => 'selected',
};

/// Why the last run stopped, in words, or null when it did not.
String? stoppedText(AppLocalizations s, String? stopped) => switch (stopped) {
  null || 'signed_out' => null,
  'quota.exceeded' => s.backupStopped('quota', ''),
  'second_factor.required' => s.backupStopped('second_factor', ''),
  final reason => s.backupStopped(reason, reason),
};

/// Settings › Backup: whether and what the device backs up, on which
/// networks, and why each item not backed up waits (ING-14).
class BackupPage extends ConsumerWidget {
  /// The page.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppLocalizations.of(context);
    final settings = ref.watch(backupSettingsProvider);
    final tokens = AppTokens.of(context);
    final heading = Theme.of(context).textTheme.titleMedium;
    final folders =
        ref.watch(backupFoldersProvider).value ?? const <BackupFolder>[];
    final signedIn = ref.watch(serverProvider).value?.account != null;
    return Scaffold(
      appBar: AppBar(title: Text(s.backupTitle)),
      body: ContentWidth(
        child: ListView(
          padding: EdgeInsets.all(tokens.md),
          children: [
            SwitchListTile(
              title: Text(s.backupEnabled),
              value: settings.enabled,
              onChanged: (on) => ref
                  .read(backupSettingsProvider.notifier)
                  .edit(
                    (b) => b.copyWith(
                      enabled: on,
                      // The folders the person has now are those they chose.
                      folders: {
                        for (final f in folders) f.key: true,
                        ...b.folders,
                      },
                    ),
                  ),
            ),
            if (!signedIn) ListTile(title: Text(s.backupSignIn)),
            const BackupSummary(),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: FilledButton.icon(
                onPressed: settings.enabled && signedIn
                    ? ref.read(backupProvider.notifier).run
                    : null,
                icon: const Icon(Icons.backup_outlined),
                label: Text(s.backupNow),
              ),
            ),
            SizedBox(height: tokens.lg),
            Text(s.backupWhat, style: heading),
            _What(folders),
            SizedBox(height: tokens.lg),
            Text(s.backupMetered, style: heading),
            const _When(),
            SizedBox(height: tokens.lg),
            Text(s.backupWaiting, style: heading),
            const _Waiting(),
          ],
        ),
      ),
    );
  }
}

/// The folders, media types and capture dates backed up (ING-06, ING-07).
class _What extends ConsumerWidget {
  const new(this.folders);

  final List<BackupFolder> folders;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppLocalizations.of(context);
    final settings = ref.watch(backupSettingsProvider);
    final edit = ref.read(backupSettingsProvider.notifier).edit;
    final since = settings.since;
    return Column(
      children: [
        for (final f in folders)
          CheckboxListTile(
            title: Text(folderName(f)),
            subtitle: Text(s.folderItems(f.items)),
            value: settings.folders[f.key] ?? false,
            onChanged: (on) => edit(
              (b) => b.copyWith(folders: {...b.folders, f.key: on ?? false}),
            ),
          ),
        SwitchListTile(
          title: Text(s.searchPhotos),
          value: settings.photos,
          onChanged: (on) => edit((b) => b.copyWith(photos: on)),
        ),
        SwitchListTile(
          title: Text(s.searchVideos),
          value: settings.videos,
          onChanged: (on) => edit((b) => b.copyWith(videos: on)),
        ),
        ListTile(
          title: Text(s.backupSince),
          subtitle: Text(
            since == null
                ? s.backupAnyDate
                : Formats.of(context)
                      .date(DateTime.fromMillisecondsSinceEpoch(since)),
          ),
          trailing: since == null
              ? null
              : IconButton(
                  icon: const Icon(Icons.clear),
                  tooltip: s.backupAnyDate,
                  onPressed: () =>
                      edit((b) => b.copyWith(clear: const {'since'})),
                ),
          onTap: () async {
            final day = await showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (day == null) return;
            edit((b) => b.copyWith(since: day.millisecondsSinceEpoch));
          },
        ),
      ],
    );
  }
}

/// What a metered network carries, roaming, charging and the watchdog's
/// hours (ING-05, ING-26).
class _When extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppLocalizations.of(context);
    final settings = ref.watch(backupSettingsProvider);
    final edit = ref.read(backupSettingsProvider.notifier).edit;
    final formats = Formats.of(context);
    return Column(
      children: [
        SwitchListTile(
          title: Text(s.searchPhotos),
          value: settings.photosMetered,
          onChanged: (on) => edit((b) => b.copyWith(photosMetered: on)),
        ),
        SwitchListTile(
          title: Text(s.searchVideos),
          value: settings.videosMetered,
          onChanged: (on) => edit((b) => b.copyWith(videosMetered: on)),
        ),
        ListTile(
          title: Text(s.backupCap),
          trailing: DropdownButton<int>(
            value: settings.meteredCap ?? 0,
            items: [
              for (final cap in const [10000000, 50000000, 200000000, 0])
                DropdownMenuItem(
                  value: cap,
                  child: Text(
                    cap == 0 ? s.backupNoLimit : formats.fileSize(cap),
                  ),
                ),
            ],
            onChanged: (cap) => edit(
              (b) => cap == 0 || cap == null
                  ? b.copyWith(clear: const {'meteredCap'})
                  : b.copyWith(meteredCap: cap),
            ),
          ),
        ),
        SwitchListTile(
          title: Text(s.backupRoaming),
          value: settings.roaming,
          onChanged: (on) => edit((b) => b.copyWith(roaming: on)),
        ),
        SwitchListTile(
          title: Text(s.backupCharging),
          value: settings.charging,
          onChanged: (on) => edit((b) => b.copyWith(charging: on)),
        ),
        ListTile(
          title: Text(s.backupWarnAfter),
          trailing: DropdownButton<int>(
            value: settings.warnAfter,
            items: [
              for (final hours in const [12, 24, 48, 72])
                DropdownMenuItem(
                  value: hours,
                  child: Text(s.backupHours(hours)),
                ),
            ],
            onChanged: (hours) => edit((b) => b.copyWith(warnAfter: hours)),
          ),
        ),
      ],
    );
  }
}

/// When backup last completed, what waits, and why the last run stopped.
class BackupSummary extends ConsumerWidget {
  /// The summary.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppLocalizations.of(context);
    final status = ref.watch(backupStatusProvider).value;
    if (status == null) return const SizedBox.shrink();
    final settings = ref.watch(backupSettingsProvider);
    final overdue = backupOverdue(
      status,
      settings.warnAfter,
      DateTime.now().millisecondsSinceEpoch,
    );
    final stopped = stoppedText(s, status.stopped);
    final formats = Formats.of(context);
    return ListTile(
      leading: Icon(
        overdue ? Icons.cloud_off_outlined : Icons.cloud_done_outlined,
        color: overdue ? Theme.of(context).colorScheme.error : null,
      ),
      title: Text(switch (status.completed) {
        null => s.backupNever,
        final at => s.backupCompleted(
          formats.taken(DateTime.fromMillisecondsSinceEpoch(at)),
        ),
      }),
      subtitle: Text(
        [
          if (status.pending == 0)
            s.backupNothing
          else
            s.backupPending(s.folderItems(status.pending)),
          ?stopped,
          if ((status.stopped, status.contact) case ('offline', final at?))
            s.backupContact(
              formats.taken(DateTime.fromMillisecondsSinceEpoch(at)),
            ),
        ].join('\n'),
      ),
    );
  }
}

/// Every reason items wait for, with how many, their next retry and some of
/// them by name.
class _Waiting extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppLocalizations.of(context);
    final formats = Formats.of(context);
    // The states and reasons one explanation covers, with how many wait and
    // the first retry.
    final groups = <String, (List<BackupReasonsResult>, int, int?)>{};
    for (final r
        in ref.watch(backupReasonsProvider).value ??
            const <BackupReasonsResult>[]) {
      final text = s.backupWhy(_why(r.state, r.reason), r.reason ?? '');
      final (rows, count, retry) =
          groups[text] ?? (const <BackupReasonsResult>[], 0, null);
      groups[text] = (
        [...rows, r],
        count + r.count,
        [
          ?retry,
          ?r.retryAt,
        ].fold<int?>(null, (a, b) => a == null || b < a ? b : a),
      );
    }
    return Column(
      children: [
        for (final MapEntry(key: text, value: (rows, count, retry))
            in groups.entries)
          ExpansionTile(
            title: Text(text),
            subtitle: Text(
              [
                s.folderItems(count),
                if (retry != null)
                  s.backupRetry(
                    formats.taken(DateTime.fromMillisecondsSinceEpoch(retry)),
                  ),
              ].join(' · '),
            ),
            children: [_Items(rows)],
          ),
      ],
    );
  }
}

/// Some of the items waiting for [reasons], by name.
class _Items extends ConsumerWidget {
  const new(this.reasons);

  final List<BackupReasonsResult> reasons;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(replicaProvider).value;
    return FutureBuilder(
      future: db == null
          ? null
          : Future.wait([
              for (final r in reasons)
                db.backupItems(r.state, r.reason, 50).get(),
            ]),
      builder: (context, items) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final a in [...?items.data?.expand((i) => i)].take(50))
            ListTile(
              dense: true,
              // A folder file's path, a gallery item's folder and name.
              title: Text(switch ([?a.path, ?a.name].join()) {
                '' => a.sourceId,
                final name => name,
              }),
            ),
        ],
      ),
    );
  }
}

/// The backup on the home screen (ING-25, ING-26): a notice that stays while
/// the server has signed the device out, naming the fix; a question for each
/// new folder, asked once; and when backup last completed, with what waits.
class BackupBanner extends ConsumerWidget {
  /// The banner.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppLocalizations.of(context);
    final settings = ref.watch(backupSettingsProvider);
    if (!settings.enabled || !ref.watch(backupSupportedProvider)) {
      return const SizedBox.shrink();
    }
    ref.watch(backupProvider);
    final server = ref.watch(serverProvider).value;
    final edit = ref.read(backupSettingsProvider.notifier).edit;
    final folders =
        ref.watch(backupFoldersProvider).value ?? const <BackupFolder>[];
    final asked = folders.where((f) => !settings.folders.containsKey(f.key));
    void open(Widget page) =>
        Navigator.of(context)
            .push(MaterialPageRoute<void>(builder: (_) => page));
    return Column(
      children: [
        if (server?.account == null && (server?.ended ?? false))
          MaterialBanner(
            leading: const Icon(Icons.cloud_off_outlined),
            content: Text(s.backupSignedOut),
            actions: [
              TextButton(
                onPressed: () => open(const ServerPage()),
                child: Text(s.serverSignIn),
              ),
            ],
          )
        else if (asked.firstOrNull case final f?)
          MaterialBanner(
            leading: const Icon(Icons.create_new_folder_outlined),
            content: Text(s.backupNewFolder(folderName(f))),
            actions: [
              for (final on in [false, true])
                TextButton(
                  onPressed: () => edit(
                    (b) => b.copyWith(folders: {...b.folders, f.key: on}),
                  ),
                  child: Text(on ? s.backupFolderYes : s.backupFolderNo),
                ),
            ],
          ),
        InkWell(
          onTap: () => open(const BackupPage()),
          child: const BackupSummary(),
        ),
      ],
    );
  }
}

/// Settings' way to the backup page.
class BackupTile extends ConsumerWidget {
  /// The tile.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(backupSupportedProvider)) return const SizedBox.shrink();
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.backup_outlined),
      title: Text(AppLocalizations.of(context).backupTitle),
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (_) => const BackupPage())),
    );
  }
}
