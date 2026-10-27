import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/core/errors.dart';
import 'package:photolib/core/problems.dart';
import 'package:photolib/features/admin/remote_access.dart';
import 'package:photolib/features/servers/devices.dart';
import 'package:photolib/features/servers/pairing.dart';
import 'package:photolib/features/servers/security.dart';
import 'package:photolib/features/servers/servers.dart';
import 'package:photolib/l10n/app_localizations.dart';
import 'package:photolib/l10n/formats.dart';
import 'package:photolib/ui/tokens.dart';
import 'package:photolib_api/photolib_api.dart' as api;
import 'package:protobuf/protobuf.dart';
import 'package:protobuf/well_known_types/google/protobuf/field_mask.pb.dart';
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart';
import 'package:qr/qr.dart';

/// The session of an administrator of the server; null otherwise, which hides
/// the console.
final adminClientProvider = Provider<RpcClient?>(
  (ref) => ref.watch(serverProvider).value?.account?.admin ?? false
      ? ref.watch(sessionProvider)
      : null,
);

/// The admin console (OPS-02): every operation of `AdminService` and
/// `UserService`, with a banner while a job type is paused.
class AdminPage extends ConsumerStatefulWidget {
  /// The console, for the administrator `adminClientProvider` signs in.
  const new({super.key});

  @override
  ConsumerState<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends ConsumerState<AdminPage> {
  final ValueNotifier<int> _changes = ValueNotifier(0);

  @override
  void dispose() {
    _changes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final client = ref.watch(adminClientProvider);
    if (client == null) {
      return Scaffold(
        appBar: AppBar(),
        body: ErrorView(message: s.adminErrorSignIn),
      );
    }
    final (admin, users, auth) = (
      api.AdminServiceApi(client),
      api.UserServiceApi(client),
      api.AuthServiceApi(client),
    );
    final server = ref.watch(serverProvider).value;
    Widget scoped(Widget child) => _Console(
      admin: admin,
      users: users,
      auth: auth,
      changes: _changes,
      server: server,
      child: child,
    );
    final sections = [
      (s.adminOverview, Icons.dashboard_outlined, const _Overview()),
      (s.adminJobs, Icons.work_history_outlined, const _Jobs()),
      (s.adminAccounts, Icons.people_outline, const _Accounts()),
      (s.adminStores, Icons.storage_outlined, const _Stores()),
      (s.adminAudit, Icons.history, const _Audit()),
      (s.adminLog, Icons.article_outlined, const _Log()),
      (s.adminDevices, Icons.devices_outlined, DevicesView(client)),
      (s.adminPair, Icons.qr_code_2, const _Pair()),
      (s.adminRemote, Icons.public, const RemoteAccess()),
      (s.securityTitle, Icons.security_outlined, const SecurityView()),
      (s.adminPolicies, Icons.policy_outlined, const _Policies()),
      (
        s.diagnosticsTitle,
        Icons.health_and_safety_outlined,
        const _Diagnostics(),
      ),
    ];
    return scoped(
      Scaffold(
        appBar: AppBar(),
        body: ListView(
          children: [
            _Heading(s.adminTitle, page: true),
            const _Pauses(),
            for (final (title, icon, section) in sections)
              ListTile(
                leading: Icon(icon),
                title: Text(title),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        scoped(Scaffold(appBar: AppBar(), body: section)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// The services, and a counter that every change bumps so that every view
/// loads again.
class _Console extends InheritedWidget {
  const new({
    required this.admin,
    required this.users,
    required this.auth,
    required this.changes,
    required this.server,
    required super.child,
  });

  final api.AdminServiceApi admin;
  final api.UserServiceApi users;
  final api.AuthServiceApi auth;
  final ValueNotifier<int> changes;

  /// The server, whose addresses, pin and instance the links it makes carry.
  final SavedServer? server;

  static _Console of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Console>()!;

  @override
  bool updateShouldNotify(_Console old) => admin != old.admin;
}

/// Runs a change, says how it went and loads the console again.
Future<void> _change(
  BuildContext context,
  Future<Object?> Function() call, {
  String Function(Object? answer)? done,
}) async {
  final console = _Console.of(context);
  final messenger = ScaffoldMessenger.of(context);
  try {
    final answer = await call();
    if (done != null) {
      messenger.showSnackBar(SnackBar(content: Text(done(answer))));
    }
    console.changes.value++;
  } on Object catch (error) {
    if (context.mounted) showProblem(context, error);
  }
}

/// `JOB_STATUS_DEAD` as `dead`, the key the messages select on; [prefix]
/// words go, two by default (`CAPABILITY_ML_SEARCH` takes 1).
String _short(ProtobufEnum value, [int prefix = 2]) =>
    value.name.split('_').skip(prefix).join('_').toLowerCase();

/// Opens [page] on a route of its own, in this console.
void _open(BuildContext context, Widget page) {
  final console = _Console.of(context);
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => _Console(
        admin: console.admin,
        users: console.users,
        auth: console.auth,
        changes: console.changes,
        server: console.server,
        child: Scaffold(appBar: AppBar(), body: page),
      ),
    ),
  );
}

String _when(BuildContext context, Timestamp at) {
  final time = at.toDateTime().toLocal();
  final clock = MaterialLocalizations.of(context)
      .formatTimeOfDay(TimeOfDay.fromDateTime(time));
  return '${Formats.of(context).date(time)} $clock';
}

String _size(BuildContext context, Int64 bytes) =>
    Formats.of(context).fileSize(bytes.toInt());

/// A page titled [title]: [header], then the items of what [load] returns, a
/// retry when it fails; it loads again after every change. Without a title it
/// is a quiet part of a page, shown only once loaded.
class _Load<T> extends StatefulWidget {
  const new(this.load, this.items, {this.title, this.header = const []});

  final Future<T> Function(_Console console) load;
  final List<Widget> Function(BuildContext context, T value) items;
  final String? title;
  final List<Widget> header;

  @override
  State<_Load<T>> createState() => _LoadState<T>();
}

class _LoadState<T> extends State<_Load<T>> {
  late Future<T> _future;
  _Console? _console;

  void _reload() => setState(() {
    _future = _load();
  });

  /// The load, whose error [FutureBuilder] shows; it is not uncaught when the
  /// view is gone before it builds, as the console is once signed out.
  Future<T> _load() => widget.load(_console!)..ignore();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _console?.changes.removeListener(_reload);
    _console = _Console.of(context)..changes.addListener(_reload);
    _future = _load();
  }

  @override
  void didUpdateWidget(_Load<T> old) {
    super.didUpdateWidget(old);
    _future = _load();
  }

  @override
  void dispose() {
    _console?.changes.removeListener(_reload);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<T>(
    future: _future,
    builder: (context, snapshot) {
      final title = widget.title;
      final items = switch (snapshot) {
        AsyncSnapshot(connectionState: ConnectionState.done, :final T data) =>
          widget.items(context, data),
        _ when title == null => null,
        AsyncSnapshot(:final error?) => [
          ErrorView(error: error, onRetry: _reload),
        ],
        _ => [const Center(child: CircularProgressIndicator())],
      };
      if (title == null) return Column(children: items ?? const []);
      return ListView(
        children: [_Heading(title, page: true), ...widget.header, ...?items],
      );
    },
  );
}

class _Heading extends StatelessWidget {
  const new(this.text, {this.page = false});
  final String text;

  /// The title of a page rather than of a part of it.
  final bool page;

  @override
  Widget build(BuildContext context) {
    final styles = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: AppTokens.of(context).md,
        end: AppTokens.of(context).md,
        top: AppTokens.of(context).md,
      ),
      child: Semantics(
        header: true,
        child: Text(
          text,
          style: page ? styles.headlineSmall : styles.titleMedium,
        ),
      ),
    );
  }
}

/// Cancel, and [ok] (OK by default), which closes the dialog with true when
/// [accept] allows.
List<Widget> _actions(
  BuildContext context, {
  bool Function()? accept,
  String? ok,
}) {
  final m = MaterialLocalizations.of(context);
  return [
    TextButton(
      onPressed: () => Navigator.pop(context, false),
      child: Text(m.cancelButtonLabel),
    ),
    FilledButton(
      onPressed: () {
        if (accept?.call() ?? true) Navigator.pop(context, true);
      },
      child: Text(ok ?? m.okButtonLabel),
    ),
  ];
}

/// A whole number from [min] to [max]; read-only where [pinned] by the
/// server's configuration.
Widget _number(
  TextEditingController controller,
  String label,
  int min,
  int max,
  AppLocalizations s, {
  bool pinned = false,
}) => TextFormField(
  controller: controller,
  enabled: !pinned,
  keyboardType: TextInputType.number,
  decoration: InputDecoration(
    labelText: label,
    helperText: pinned ? s.adminPolicySource('config') : null,
  ),
  validator: (text) {
    final value = int.tryParse(text!.trim());
    return value == null || value < min || value > max
        ? s.adminOutOfRange
        : null;
  },
);

class _Pauses extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => _Load(
    (console) => console.admin.getStatus(null, api.GetStatusRequest()),
    (context, status) => [
      for (final pause in status.pauses)
        MaterialBanner(
          leading: const Icon(Icons.pause_circle_outline),
          content: Text(
            AppLocalizations.of(context)
                .adminPausedUntil(pause.type, _when(context, pause.untilAt)),
          ),
          actions: [
            TextButton(
              onPressed: () => _change(
                context,
                () => _Console.of(context).admin.resumeJobType(
                  null,
                  api.ResumeJobTypeRequest(type: pause.type),
                ),
              ),
              child: Text(AppLocalizations.of(context).adminResume),
            ),
          ],
        ),
    ],
  );
}

class _Overview extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => _Load(
    title: AppLocalizations.of(context).adminOverview,
    (console) => console.admin.getStatus(null, api.GetStatusRequest()),
    (context, status) {
      final s = AppLocalizations.of(context);
      String usage(Int64 count, Int64 bytes) =>
          '${s.adminItems(count.toInt())} · ${_size(context, bytes)}';
      return [
        _Heading(s.adminUsage),
        for (final account in status.accounts)
          ListTile(
            title: Text(account.handle),
            subtitle: Text(usage(account.assetCount, account.sizeBytes)),
          ),
        _Heading(s.adminFiles),
        for (final file in status.files)
          ListTile(
            title: Text(file.role),
            subtitle: Text(usage(file.fileCount, file.sizeBytes)),
          ),
        _Heading(s.adminLibraries),
        for (final library in status.libraries)
          ListTile(
            title: Text(library.name),
            subtitle: Text(
              [
                library.ownerHandle,
                s.adminLibraryState(_short(library.state)),
                s.adminItems(library.assetCount.toInt()),
              ].join(' · '),
            ),
            trailing: _libraryActions(context, library),
          ),
        ListTile(
          leading: const Icon(Icons.add),
          title: Text(s.adminAddExternalLibrary),
          onTap: () => _externalLibrary(context, status.accounts),
        ),
        _Heading(s.adminBackups),
        ..._backups(context, status),
        ..._health(context, status),
      ];
    },
  );
}

/// What the scrub found, with how to repair it, where each store's scrub is,
/// and each device's backup, a silent one marked (OPS-10, ADR-0234).
List<Widget> _health(BuildContext context, api.GetStatusResponse status) {
  final s = AppLocalizations.of(context);
  return [
    _Heading(s.adminIntegrity),
    if (status.findings.isEmpty) ListTile(title: Text(s.adminNothing)),
    for (final finding in status.findings)
      ListTile(
        leading: const Icon(Icons.report_problem_outlined),
        title: Text(
          finding.fileName.isEmpty
              ? finding.key
              : '${finding.fileName} · ${finding.ownerHandle}',
        ),
        subtitle: Text(
          [
            [
              s.adminFinding(_short(finding.kind)),
              finding.store,
              _when(context, finding.foundAt),
            ].join(' · '),
            if (finding.fileName.isNotEmpty) finding.key,
            if (finding.kind == api.FindingKind.FINDING_KIND_ORPHAN)
              s.adminRepairOrphan
            else
              s.adminRepair,
          ].join('\n'),
        ),
      ),
    for (final scrub in status.scrubs)
      ListTile(
        leading: const Icon(Icons.fact_check_outlined),
        title: Text(scrub.store),
        subtitle: Text(
          scrub.hasCycleEndedAt()
              ? s.adminScrubbed(_when(context, scrub.cycleEndedAt))
              : s.adminScrubNever,
        ),
      ),
    _Heading(s.adminDeviceBackups),
    if (status.deviceBackups.isEmpty) ListTile(title: Text(s.adminNothing)),
    for (final device in status.deviceBackups)
      ListTile(
        leading: Icon(
          device.silent ? Icons.warning_amber_outlined : Icons.backup_outlined,
        ),
        title: Text('${device.name} · ${device.ownerHandle}'),
        subtitle: Text(
          [
            if (device.silent) s.adminSilent(_when(context, device.reportedAt)),
            if (device.hasLastSeenAt())
              s.adminLastSeen(_when(context, device.lastSeenAt)),
            s.adminPending(device.pendingCount.toInt()),
          ].join(' · '),
        ),
      ),
  ];
}

/// Scan an external library again, reprocess, and its policy.
Widget _libraryActions(BuildContext context, api.LibraryStatus library) {
  final s = AppLocalizations.of(context);
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (library.kind == api.LibraryKind.LIBRARY_KIND_EXTERNAL)
        TextButton(
          onPressed: () => _change(
            context,
            () => _Console.of(context).admin.scanLibrary(
              null,
              api.ScanLibraryRequest(libraryId: library.libraryId),
            ),
          ),
          child: Text(s.adminScan),
        ),
      TextButton(
        onPressed: () => _reprocess(context, library.libraryId),
        child: Text(s.adminReprocess),
      ),
      IconButton(
        icon: const Icon(Icons.policy_outlined),
        tooltip: s.adminPolicies,
        onPressed: () => _open(
          context,
          _LevelPolicy(library.name, libraryId: library.libraryId),
        ),
      ),
    ],
  );
}

/// The restore drills, the last restore if it failed, the dumps, each of which
/// can replace the database, and a backup now (OPS-03).
List<Widget> _backups(BuildContext context, api.GetStatusResponse status) {
  final s = AppLocalizations.of(context);
  final (drill, verified, restore) = (
    status.lastDrill,
    status.lastVerifiedRestore,
    status.lastRestore,
  );
  return [
    ListTile(
      leading: Icon(
        status.hasLastDrill() && !drill.ok
            ? Icons.error_outline
            : Icons.verified_outlined,
      ),
      title: Text(
        status.hasLastVerifiedRestore()
            ? s.adminRestoreVerified(_when(context, verified.finishedAt))
            : s.adminRestoreUnverified,
      ),
      subtitle: status.hasLastDrill()
          ? Text(drill.ok ? drill.detail : s.adminDrillFailed(drill.detail))
          : null,
    ),
    if (status.hasLastRestore() && !restore.ok)
      ListTile(
        leading: const Icon(Icons.error_outline),
        title: Text(
          s.adminRestoreFailed(restore.dump.split('/').last, restore.detail),
        ),
      ),
    if (status.backups.isEmpty) ListTile(title: Text(s.adminNothing)),
    for (final backup in status.backups)
      ListTile(
        title: Text(backup.name.split('/').last),
        subtitle: Text(
          [
            _when(context, backup.createdAt),
            _size(context, backup.sizeBytes),
            backup.store,
          ].join(' · '),
        ),
        trailing: TextButton(
          onPressed: () => _restore(context, backup),
          child: Text(s.adminRestore),
        ),
      ),
    ListTile(
      leading: const Icon(Icons.backup_outlined),
      title: Text(s.adminBackUpNow),
      onTap: () => _change(
        context,
        () =>
            _Console.of(context).admin.backUpNow(null, api.BackUpNowRequest()),
        done: (_) => s.adminBackupQueued,
      ),
    ),
  ];
}

/// Asks before photolibd stops to replace the database with [backup].
Future<void> _restore(BuildContext context, api.Backup backup) async {
  final s = AppLocalizations.of(context);
  final go = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(s.adminRestore),
      content: Text(s.adminRestoreWarning(backup.name.split('/').last)),
      actions: _actions(context, ok: s.adminRestore),
    ),
  );
  if (go != true || !context.mounted) return;
  await _change(
    context,
    () => _Console.of(context).admin.restoreBackup(
      null,
      api.RestoreBackupRequest(store: backup.store, name: backup.name),
    ),
    done: (_) => s.adminRestoring,
  );
}

/// Gives an account a read-only library of a folder on the server, which the
/// server then scans.
Future<void> _externalLibrary(
  BuildContext context,
  List<api.AccountUsage> accounts,
) async {
  final s = AppLocalizations.of(context);
  final (name, root) = (TextEditingController(), TextEditingController());
  var owner = accounts.firstOrNull?.userId;
  final go = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(s.adminAddExternalLibrary),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            initialValue: owner,
            decoration: InputDecoration(labelText: s.adminLibraryOwner),
            onChanged: (chosen) => owner = chosen,
            items: [
              for (final account in accounts)
                DropdownMenuItem(
                  value: account.userId,
                  child: Text(account.handle),
                ),
            ],
          ),
          TextFormField(
            controller: name,
            decoration: InputDecoration(labelText: s.adminName),
          ),
          TextFormField(
            controller: root,
            decoration: InputDecoration(labelText: s.adminLibraryRoot),
          ),
        ],
      ),
      actions: _actions(context),
    ),
  );
  if (go != true || !context.mounted) return;
  await _change(
    context,
    () => _Console.of(context).admin.createExternalLibrary(
      null,
      api.CreateExternalLibraryRequest(
        ownerUserId: owner,
        name: name.text.trim(),
        root: root.text.trim(),
      ),
    ),
  );
}

/// Asks what to redo, in the whole library or a folder of it, and queues it.
Future<void> _reprocess(BuildContext context, String libraryId) async {
  final s = AppLocalizations.of(context);
  final folder = TextEditingController();
  final kinds = {api.ReprocessKind.REPROCESS_KIND_METADATA};
  final choices = {
    api.ReprocessKind.REPROCESS_KIND_METADATA: s.adminReprocessMetadata,
    api.ReprocessKind.REPROCESS_KIND_RENDITIONS: s.adminReprocessRenditions,
    api.ReprocessKind.REPROCESS_KIND_FACES: s.adminReprocessFaces,
  };
  final go = await showDialog<bool>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(s.adminReprocess),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: folder,
              decoration: InputDecoration(labelText: s.adminReprocessFolder),
            ),
            for (final MapEntry(key: kind, value: label) in choices.entries)
              CheckboxListTile(
                value: kinds.contains(kind),
                title: Text(label),
                onChanged: (on) =>
                    setState(() => on! ? kinds.add(kind) : kinds.remove(kind)),
              ),
          ],
        ),
        actions: _actions(context, accept: () => kinds.isNotEmpty),
      ),
    ),
  );
  if (go != true || !context.mounted) return;
  await _change(
    context,
    () => _Console.of(context).admin.reprocess(
      null,
      api.ReprocessRequest(
        libraryId: libraryId,
        folder: folder.text.trim(),
        kinds: kinds,
      ),
    ),
    done: (answer) =>
        s.adminQueued((answer! as api.ReprocessResponse).jobCount.toInt()),
  );
}

class _Jobs extends StatefulWidget {
  const new();

  @override
  State<_Jobs> createState() => _JobsState();
}

class _JobsState extends State<_Jobs> {
  api.JobStatus _status = api.JobStatus.JOB_STATUS_UNSPECIFIED;
  var _type = '';

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final tokens = AppTokens.of(context);
    return _Load(
      title: s.adminJobs,
      header: [
        Padding(
          padding: EdgeInsets.all(tokens.md),
          child: Wrap(
            spacing: tokens.sm,
            runSpacing: tokens.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              DropdownButton<api.JobStatus>(
                value: _status,
                onChanged: (status) => setState(() => _status = status!),
                items: [
                  for (final status in api.JobStatus.values)
                    DropdownMenuItem(
                      value: status,
                      child: Text(s.adminJobStatus(_short(status))),
                    ),
                ],
              ),
              TextField(
                decoration: InputDecoration(labelText: s.adminJobType),
                onSubmitted: (type) => setState(() => _type = type.trim()),
              ),
              FilledButton.tonal(
                onPressed: () => _pause(context, _type),
                child: Text(s.adminPause),
              ),
            ],
          ),
        ),
      ],
      (console) => console.admin.listJobs(
        null,
        api.ListJobsRequest(status: _status, type: _type),
      ),
      (context, page) => [
        if (page.jobs.isEmpty) ListTile(title: Text(s.adminNothing)),
        for (final job in page.jobs) _Job(job),
      ],
    );
  }
}

class _Job extends StatelessWidget {
  const new(this.job);
  final api.Job job;

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final admin = _Console.of(context).admin;
    final id = job.jobId;
    final more = [?job.key.nonEmpty, ?job.error.nonEmpty];
    return ListTile(
      title: Text(job.type),
      subtitle: Text(
        [
          s.adminAttempts(s.adminJobStatus(_short(job.status)), job.attempts),
          ...more,
        ].join('\n'),
      ),
      isThreeLine: more.isNotEmpty,
      trailing: switch (job.status) {
        api.JobStatus.JOB_STATUS_DEAD ||
        api.JobStatus.JOB_STATUS_CANCELLED => TextButton(
          onPressed: () => _change(
            context,
            () => admin.retryJob(null, api.RetryJobRequest(jobId: id)),
          ),
          child: Text(s.adminRetry),
        ),
        api.JobStatus.JOB_STATUS_QUEUED ||
        api.JobStatus.JOB_STATUS_RUNNING => TextButton(
          onPressed: () => _change(
            context,
            () => admin.cancelJob(null, api.CancelJobRequest(jobId: id)),
          ),
          child: Text(s.adminCancelJob),
        ),
        _ => null,
      },
    );
  }
}

extension on String {
  String? get nonEmpty => isEmpty ? null : this;
}

/// The most minutes one request pauses [type]: a week for maintenance, a day
/// for any other type (ADR-0063).
int _maxPause(String type) =>
    const {'backup', 'storage-purge', 'scrub'}.contains(type) ? 10080 : 1440;

/// Asks which job type to pause and for how long (an hour unless changed).
Future<void> _pause(BuildContext context, String type) async {
  final s = AppLocalizations.of(context);
  final kind = TextEditingController(text: type);
  final minutes = TextEditingController(text: '60');
  final form = GlobalKey<FormState>();
  final go = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(s.adminPause),
      content: Form(
        key: form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: kind,
              decoration: InputDecoration(labelText: s.adminJobType),
              validator: (text) =>
                  text!.trim().isEmpty ? s.adminOutOfRange : null,
            ),
            ValueListenableBuilder(
              valueListenable: kind,
              builder: (context, type, _) {
                final max = _maxPause(type.text.trim());
                return _number(minutes, s.adminPauseMinutes(max), 1, max, s);
              },
            ),
          ],
        ),
      ),
      actions: _actions(context, accept: () => form.currentState!.validate()),
    ),
  );
  if (go != true || !context.mounted) return;
  await _change(
    context,
    () => _Console.of(context).admin.pauseJobType(
      null,
      api.PauseJobTypeRequest(
        type: kind.text.trim(),
        pauseMinutes: int.parse(minutes.text.trim()),
      ),
    ),
  );
}

class _Accounts extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => _Load(
    title: AppLocalizations.of(context).adminAccounts,
    (console) => console.users.listUsers(null, api.ListUsersRequest()),
    (context, answer) {
      final s = AppLocalizations.of(context);
      final admins = answer.users.where(
        (user) =>
            user.role == api.UserRole.USER_ROLE_ADMIN &&
            user.status == api.UserStatus.USER_STATUS_ACTIVE,
      );
      return [
        ListTile(
          leading: const Icon(Icons.person_add_outlined),
          title: Text(s.adminAddAccount),
          onTap: () => _account(context, null),
        ),
        // The admin-succession kit asks for two (design 15 §6).
        if (admins.length < 2)
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(s.adminSecondAdmin),
          ),
        for (final user in answer.users)
          ListTile(
            title: Text(user.displayName),
            subtitle: Text(
              [
                user.handle,
                s.adminRole(_short(user.role)),
                s.adminAccountStatus(_short(user.status)),
              ].join(' · '),
            ),
            trailing: _AccountMenu(user),
          ),
      ];
    },
  );
}

class _AccountMenu extends StatelessWidget {
  const new(this.user);
  final api.User user;

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final console = _Console.of(context);
    final users = console.users;
    final active = user.status == api.UserStatus.USER_STATUS_ACTIVE;
    Future<void> status(api.UserStatus status) => _change(
      context,
      () => users.updateUser(
        null,
        api.UpdateUserRequest(
          user: api.User(userId: user.userId, status: status),
          updateMask: FieldMask(paths: ['status']),
        ),
      ),
    );
    return PopupMenuButton<VoidCallback>(
      onSelected: (action) => action(),
      itemBuilder: (_) => [
        PopupMenuItem(
          value: () => _account(context, user),
          child: Text(s.adminEdit),
        ),
        PopupMenuItem(
          value: () => _open(
            context,
            _LevelPolicy(user.displayName, userId: user.userId),
          ),
          child: Text(s.adminPolicies),
        ),
        if (console.server case final server? when active)
          PopupMenuItem(
            value: () => _passwordSetup(context, user, server),
            child: Text(s.adminPasswordSetup),
          ),
        PopupMenuItem(
          value: () => status(
            active
                ? api.UserStatus.USER_STATUS_DISABLED
                : api.UserStatus.USER_STATUS_ACTIVE,
          ),
          child: Text(active ? s.adminDisable : s.adminEnable),
        ),
        if (user.status != api.UserStatus.USER_STATUS_DELETED)
          PopupMenuItem(
            value: () => _change(
              context,
              () => users.deleteUser(
                null,
                api.DeleteUserRequest(userId: user.userId),
              ),
            ),
            child: Text(s.adminDelete),
          ),
      ],
    );
  }
}

/// Makes a password setup token for [user] and shows its link, which pairs
/// with [server] too, as text and a QR code to send by any channel
/// (ADR-0052).
Future<void> _passwordSetup(
  BuildContext context,
  api.User user,
  SavedServer server,
) async {
  final s = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final api.PasswordSetup setup;
  try {
    setup = (await _Console.of(context).users.createPasswordSetup(
      null,
      api.CreatePasswordSetupRequest(userId: user.userId),
    )).passwordSetup;
  } on Object catch (error) {
    if (context.mounted) showProblem(context, error);
    return;
  }
  if (!context.mounted) return;
  final link =
      '${pairingLink(server, (handle: user.handle, token: setup.token))}';
  await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(s.adminPasswordSetup),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: AppTokens.of(context).sm,
        children: [
          Text(
            s.adminPasswordSetupBody(
              user.displayName,
              _when(context, setup.expiresAt),
            ),
          ),
          Semantics(label: s.adminQrCode, image: true, child: _Qr(link)),
          SelectableText(link),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: link));
            messenger.showSnackBar(SnackBar(content: Text(s.adminCopied)));
          },
          child: Text(s.adminCopyLink),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: Text(MaterialLocalizations.of(context).closeButtonLabel),
        ),
      ],
    ),
  );
}

/// The pairing link of this server and its QR code (MOB-16, MOB-17).
class _Pair extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final server = _Console.of(context).server;
    final link = server == null ? '' : '${pairingLink(server)}';
    final tokens = AppTokens.of(context);
    return ListView(
      children: [
        _Heading(s.adminPair, page: true),
        Padding(
          padding: EdgeInsets.all(tokens.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: tokens.sm,
            children: [
              Text(s.adminPairBody),
              Semantics(label: s.adminQrCode, image: true, child: _Qr(link)),
              SelectableText(link),
              TextButton(
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  await Clipboard.setData(ClipboardData(text: link));
                  messenger.showSnackBar(
                    SnackBar(content: Text(s.adminCopied)),
                  );
                },
                child: Text(s.adminCopyLink),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// [data] as a QR code: dark on light whatever the theme, in its quiet zone.
class _Qr extends StatelessWidget {
  const new(this.data);
  final String data;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox.square(
        dimension: 200,
        child: CustomPaint(
          painter: _QrPainter(
            QrImage(QrCode(payload: QrPayload.fromString(data))),
          ),
        ),
      ),
    ),
  );
}

class _QrPainter extends CustomPainter {
  new(this.image);
  final QrImage image;

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.shortestSide / image.moduleCount;
    // One path, so that neighbouring modules show no seams between them.
    final dark = Path();
    for (var row = 0; row < image.moduleCount; row++) {
      for (var col = 0; col < image.moduleCount; col++) {
        if (image.isDark(row, col)) {
          dark.addRect(Rect.fromLTWH(col * cell, row * cell, cell, cell));
        }
      }
    }
    canvas.drawPath(dark, Paint()..color = Colors.black);
  }

  @override
  bool shouldRepaint(_QrPainter old) => old.image != image;
}

/// Creates an account, or changes [user]'s name, email, role and quota.
Future<void> _account(BuildContext context, api.User? user) async {
  final s = AppLocalizations.of(context);
  final handle = TextEditingController(text: user?.handle);
  final name = TextEditingController(text: user?.displayName);
  final email = TextEditingController(text: user?.email);
  final quota = TextEditingController(
    text: user?.hasQuotaBytes() ?? false
        ? '${user!.quotaBytes.toInt() ~/ 1000000000}'
        : '',
  );
  var role = user?.role ?? api.UserRole.USER_ROLE_USER;
  final form = GlobalKey<FormState>();
  final go = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(user == null ? s.adminAddAccount : s.adminEdit),
      content: Form(
        key: form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: handle,
              enabled: user == null,
              decoration: InputDecoration(labelText: s.adminHandle),
            ),
            TextFormField(
              controller: name,
              decoration: InputDecoration(labelText: s.adminName),
            ),
            TextFormField(
              controller: email,
              decoration: InputDecoration(labelText: s.adminEmail),
            ),
            DropdownButtonFormField<api.UserRole>(
              initialValue: role,
              onChanged: (chosen) => role = chosen!,
              items: [
                for (final role in api.UserRole.values.skip(1))
                  DropdownMenuItem(
                    value: role,
                    child: Text(s.adminRole(_short(role))),
                  ),
              ],
            ),
            TextFormField(
              controller: quota,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: s.adminQuota),
              validator: (text) =>
                  text!.trim().isEmpty || int.tryParse(text.trim()) != null
                  ? null
                  : s.adminOutOfRange,
            ),
          ],
        ),
      ),
      actions: _actions(
        context,
        accept: () => form.currentState!.validate(),
        ok: MaterialLocalizations.of(context).saveButtonLabel,
      ),
    ),
  );
  if (go != true || !context.mounted) return;
  final gigabytes = int.tryParse(quota.text.trim());
  final changed = api.User(
    userId: user?.userId,
    handle: handle.text.trim(),
    displayName: name.text.trim(),
    email: email.text.trim(),
    role: role,
    quotaBytes: gigabytes == null ? null : Int64(gigabytes) * 1000000000,
  );
  final users = _Console.of(context).users;
  await _change(
    context,
    () => user == null
        ? users.createUser(null, api.CreateUserRequest(user: changed))
        : users.updateUser(
            null,
            api.UpdateUserRequest(
              user: changed,
              updateMask: FieldMask(
                paths: ['display_name', 'email', 'role', 'quota_bytes'],
              ),
            ),
          ),
  );
}

class _CheckIcon extends StatelessWidget {
  const new(this.status);
  final api.CheckStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final (icon, color) = switch (status) {
      api.CheckStatus.CHECK_STATUS_OK => (
        Icons.check_circle_outline,
        colors.primary,
      ),
      api.CheckStatus.CHECK_STATUS_WARN => (
        Icons.warning_amber,
        colors.tertiary,
      ),
      _ => (Icons.error_outline, colors.error),
    };
    return Icon(
      icon,
      color: color,
      semanticLabel: AppLocalizations.of(context).adminCheck(_short(status)),
    );
  }
}

class _Stores extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => _Load(
    title: AppLocalizations.of(context).adminStores,
    (console) => console.admin.listStores(null, api.ListStoresRequest()),
    (context, answer) => [
      for (final store in answer.stores)
        ListTile(
          leading: _CheckIcon(store.status),
          title: Text(store.name),
          subtitle: Text(
            [
              if (store.hasFreeBytes())
                AppLocalizations.of(context)
                    .adminFree(_size(context, store.freeBytes)),
              store.detail,
            ].join('\n'),
          ),
        ),
    ],
  );
}

class _Audit extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => _Load(
    title: AppLocalizations.of(context).adminAudit,
    (console) =>
        console.admin.listAuditEvents(null, api.ListAuditEventsRequest()),
    (context, answer) => [
      for (final event in answer.events)
        ListTile(
          title: Text(event.action),
          subtitle: Text(
            [
              '${_when(context, event.recordedAt)} · ${event.actorUserId}',
              event.targetJson,
              if (event.detailsJson != 'null') event.detailsJson,
            ].join('\n'),
          ),
        ),
    ],
  );
}

class _Log extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => _Load(
    title: AppLocalizations.of(context).adminLog,
    (console) => console.admin.tailLogs(null, api.TailLogsRequest()),
    (context, answer) => [
      if (answer.lines.isEmpty)
        ListTile(title: Text(AppLocalizations.of(context).adminNothing)),
      SelectionArea(
        child: Padding(
          padding: EdgeInsets.all(AppTokens.of(context).md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final line in answer.lines.reversed)
                Text(line, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    ],
  );
}

class _Policies extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => _Load(
    title: AppLocalizations.of(context).adminPolicies,
    (console) => console.admin.getSettings(null, api.GetSettingsRequest()),
    (context, answer) => [
      _PolicyForm(answer.settings, answer.pinned.toSet()),
      const _Switches(),
    ],
  );
}

/// The policy of an account or a library, titled [title].
class _LevelPolicy extends StatelessWidget {
  const new(this.title, {this.userId = '', this.libraryId = ''});
  final String title;
  final String userId;
  final String libraryId;

  @override
  Widget build(BuildContext context) => ListView(
    children: [
      _Heading(title, page: true),
      _Switches(userId: userId, libraryId: libraryId),
    ],
  );
}

/// The capability switches of the server, or of the account [userId] or the
/// library [libraryId]: each says where its value comes from, and one the
/// configuration pins is read-only (ADR-0240).
class _Switches extends StatelessWidget {
  const new({this.userId = '', this.libraryId = ''});
  final String userId;
  final String libraryId;

  @override
  Widget build(BuildContext context) => _Load(
    (console) => console.admin.getPolicy(
      null,
      api.GetPolicyRequest(userId: userId, libraryId: libraryId),
    ),
    (context, answer) {
      final s = AppLocalizations.of(context);
      final server = userId.isEmpty && libraryId.isEmpty;
      Future<void> set(api.Capability capability, {bool? on}) => _change(
        context,
        () => _Console.of(context).admin.updatePolicy(
          null,
          api.UpdatePolicyRequest(
            userId: userId,
            libraryId: libraryId,
            capability: capability,
            enabled: on,
          ),
        ),
      );
      return [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: _Heading(s.adminCapabilities),
        ),
        if (server)
          ListTile(
            leading: const Icon(Icons.tune),
            title: Text(s.adminPreset),
            onTap: () => _preset(context),
          ),
        for (final item in answer.switches)
          SwitchListTile(
            value: item.enabled,
            title: Text(s.adminCapability(_short(item.capability, 1))),
            subtitle: Text(s.adminPolicySource(_short(item.source))),
            // At an account's or a library's level a value of its own can be
            // cleared; titles line up either way.
            secondary: server
                ? null
                : item.hasSet()
                ? IconButton(
                    icon: const Icon(Icons.undo),
                    tooltip: s.adminPolicyReset,
                    onPressed: () => set(item.capability),
                  )
                : const SizedBox(width: kMinInteractiveDimension),
            onChanged: item.source == api.PolicySource.POLICY_SOURCE_CONFIG
                ? null
                : (on) => set(item.capability, on: on),
          ),
      ];
    },
  );
}

/// Asks which preset to apply, saying what each switches off, and applies it.
Future<void> _preset(BuildContext context) async {
  final s = AppLocalizations.of(context);
  var chosen = api.Preset.PRESET_ARCHIVE_VIEWER;
  final go = await showDialog<bool>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(s.adminPreset),
        content: SingleChildScrollView(
          child: RadioGroup<api.Preset>(
            groupValue: chosen,
            onChanged: (preset) => setState(() => chosen = preset ?? chosen),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(s.adminPresetBody),
                for (final preset in api.Preset.values.skip(1))
                  RadioListTile(
                    value: preset,
                    title: Text(s.adminPresetName(_short(preset, 1))),
                    subtitle: Text(s.adminPresetSummary(_short(preset, 1))),
                  ),
              ],
            ),
          ),
        ),
        actions: _actions(context),
      ),
    ),
  );
  if (go != true || !context.mounted) return;
  await _change(
    context,
    () =>
        _Console.of(context).admin
            .applyPreset(null, api.ApplyPresetRequest(preset: chosen)),
    done: (_) => s.adminSaved,
  );
}

class _PolicyForm extends StatefulWidget {
  const new(this.settings, this.pinned);
  final api.Settings settings;

  /// The settings the server's configuration pins, by field name.
  final Set<String> pinned;

  @override
  State<_PolicyForm> createState() => _PolicyFormState();
}

class _PolicyFormState extends State<_PolicyForm> {
  final _form = GlobalKey<FormState>();
  late final api.Settings _settings = widget.settings.deepCopy();
  late final _trash = TextEditingController(
    text: '${_settings.trashRetentionDays}',
  );
  late final _free = TextEditingController(
    text: '${_settings.minFreeDiskPercent}',
  );
  late final _freeGb = TextEditingController(
    text: '${_settings.minFreeDiskGb}',
  );
  late final _scrub = TextEditingController(text: '${_settings.scrubDays}');
  late final _silent = TextEditingController(
    text: '${_settings.backupSilentHours}',
  );

  /// The number of the setting [field], from [min] to [max]; read-only where
  /// the configuration pins it.
  Widget _field(
    TextEditingController controller,
    String label,
    int max,
    String field, {
    int min = 1,
  }) => _number(
    controller,
    label,
    min,
    max,
    AppLocalizations.of(context),
    pinned: widget.pinned.contains(field),
  );

  /// The switch of the setting [field]; read-only where the configuration
  /// pins it.
  Widget _toggle(
    String field,
    String title, {
    required bool value,
    required ValueChanged<bool> set,
  }) {
    final pinned = widget.pinned.contains(field);
    return SwitchListTile(
      value: value,
      title: Text(title),
      subtitle: pinned
          ? Text(AppLocalizations.of(context).adminPolicySource('config'))
          : null,
      onChanged: pinned ? null : (on) => setState(() => set(on)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final tokens = AppTokens.of(context);
    return Form(
      key: _form,
      child: Padding(
        padding: EdgeInsets.all(tokens.md),
        child: Column(
          children: [
            _toggle(
              'require_two_factor',
              s.adminTwoFactor,
              value: _settings.requireTwoFactor,
              set: (on) => _settings.requireTwoFactor = on,
            ),
            _toggle(
              'face_recognition_default',
              s.adminFacesDefault,
              value: _settings.faceRecognitionDefault,
              set: (on) => _settings.faceRecognitionDefault = on,
            ),
            _field(_trash, s.adminTrashDays, 3650, 'trash_retention_days'),
            _field(_free, s.adminFreeDisk, 50, 'min_free_disk_percent', min: 0),
            _field(
              _freeGb,
              s.adminFreeDiskGb,
              100000,
              'min_free_disk_gb',
              min: 0,
            ),
            _field(_scrub, s.adminScrubDays, 3650, 'scrub_days'),
            _field(_silent, s.adminSilentHours, 8760, 'backup_silent_hours'),
            SizedBox(height: tokens.md),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: FilledButton(
                onPressed: () {
                  if (!_form.currentState!.validate()) return;
                  _settings
                    ..trashRetentionDays = int.parse(_trash.text.trim())
                    ..minFreeDiskPercent = int.parse(_free.text.trim())
                    ..minFreeDiskGb = int.parse(_freeGb.text.trim())
                    ..scrubDays = int.parse(_scrub.text.trim())
                    ..backupSilentHours = int.parse(_silent.text.trim());
                  unawaited(
                    _change(
                      context,
                      () => _Console.of(context).admin.updateSettings(
                        null,
                        api.UpdateSettingsRequest(settings: _settings),
                      ),
                      done: (_) => s.adminSaved,
                    ),
                  );
                },
                child: Text(MaterialLocalizations.of(context).saveButtonLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Diagnostics extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => _Load(
    title: AppLocalizations.of(context).diagnosticsTitle,
    (console) =>
        console.admin.getDiagnostics(null, api.GetDiagnosticsRequest()),
    (context, answer) {
      final s = AppLocalizations.of(context);
      return [
        ListTile(
          leading: const Icon(Icons.copy),
          title: Text(s.adminCopyBundle),
          onTap: () async {
            final messenger = ScaffoldMessenger.of(context);
            await Clipboard.setData(ClipboardData(text: answer.bundleJson));
            messenger.showSnackBar(SnackBar(content: Text(s.adminCopied)));
          },
        ),
        for (final check in answer.checks)
          ListTile(
            leading: _CheckIcon(check.status),
            title: Text(check.name),
            subtitle: Text(check.detail),
          ),
      ];
    },
  );
}
