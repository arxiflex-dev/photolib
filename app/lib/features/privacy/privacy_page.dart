import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/core/errors.dart';
import 'package:photolib/core/problems.dart';
import 'package:photolib/features/privacy/privacy.dart';
import 'package:photolib/features/servers/servers.dart';
import 'package:photolib/l10n/app_localizations.dart';
import 'package:photolib/l10n/formats.dart';
import 'package:photolib/ui/adaptive.dart';
import 'package:photolib/ui/tokens.dart';
import 'package:photolib_api/photolib_api.dart';

/// Private libraries (design 06 §6, ADR-0255): what losing the keys means, the
/// setup that makes a recovery kit and has the person prove they saved it,
/// the account's ways to unlock, and the drills that check the kit still
/// works.
class PrivacyPage extends ConsumerStatefulWidget {
  /// The page at /settings/privacy.
  const new({super.key});

  @override
  ConsumerState<PrivacyPage> createState() => _PrivacyPageState();
}

enum _Step { overview, kit, verify, drill }

/// How many words of the kit the setup asks for again.
const int _asked = 3;

class _PrivacyPageState extends ConsumerState<PrivacyPage> {
  _Step _step = _Step.overview;
  Enrolment? _enrolment;
  var _positions = <int>[];
  final _password = TextEditingController();
  final _phrase = TextEditingController();
  final List<TextEditingController> _words = [
    for (var i = 0; i < _asked; i++) TextEditingController(),
  ];
  var _busy = false;
  String? _error;

  @override
  void dispose() {
    for (final c in [_password, _phrase, ..._words]) {
      c.dispose();
    }
    super.dispose();
  }

  KeyServiceApi get _keys => KeyServiceApi(
    ref.read(sessionProvider) ?? (throw StateError('signed out')),
  );

  void _go(_Step step) => setState(() {
    _step = step;
    _error = null;
  });

  /// Runs [work], busy meanwhile, showing what fails as [_error].
  Future<void> _run(Future<String?> Function(AppLocalizations s) work) async {
    final s = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    String? error;
    try {
      error = await work(s);
    } on KeyRefused catch (refused) {
      error = switch (refused) {
        KeyRefused(reason: 'unknown_word', :final int word) =>
          s.privacyUnknownWord(word),
        KeyRefused(reason: 'commitment_mismatch') => s.privacyKitOther,
        _ => s.privacyPhraseInvalid,
      };
    } on CallError catch (failure) {
      final problem = problemOf(s, failure);
      error = '${problem.cause} ${problem.next}';
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = error;
        });
      }
    }
  }

  Future<void> _setUp(GetKeysResponse got) => _run((s) async {
    final password = _password.text;
    if (!await ref.read(accountsProvider.notifier).checkPassword(password)) {
      return s.privacyWrongPassword;
    }
    final enrolment = await ref
        .read(custodyProvider)
        .enrol(got.userId, password);
    await _keys.createKeys(null, enrolment.keys);
    _password.clear();
    _enrolment = enrolment;
    _go(_Step.kit);
    return null;
  });

  void _ask() {
    final random = Random.secure();
    final positions = <int>{};
    while (positions.length < _asked) {
      positions.add(random.nextInt(24));
    }
    for (final word in _words) {
      word.clear();
    }
    _positions = positions.toList()..sort();
    _go(_Step.verify);
  }

  Future<void> _verifyWords() => _run((s) async {
    final enrolment = _enrolment;
    if (enrolment == null) return null;
    final words = enrolment.phrase.split(' ');
    for (final (i, position) in _positions.indexed) {
      if (_words[i].text.trim().toLowerCase() != words[position]) {
        return s.privacyWordsDiffer;
      }
    }
    await _verified(enrolment.kit);
    return null;
  });

  Future<void> _drill(GetKeysResponse got) => _run((s) async {
    final recovery = got.keys.paths.firstWhere(
      (path) => path.kind == UnlockKind.UNLOCK_KIND_RECOVERY,
    );
    final kit = await ref
        .read(custodyProvider)
        .openKit(got.userId, _phrase.text, recovery.wrap);
    await _verified(kit);
    _phrase.clear();
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(s.privacyKitDone)));
    }
    return null;
  });

  /// Records that the person holds [kit] and forgets its phrase.
  Future<void> _verified(List<int> kit) async {
    await _keys.verifyRecoveryKit(null, VerifyRecoveryKitRequest(kitId: kit));
    _enrolment = null;
    ref.invalidate(keysProvider);
    _go(_Step.overview);
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final tokens = AppTokens.of(context);
    final keys = ref.watch(keysProvider);
    final got = keys.value;
    return Scaffold(
      appBar: AppBar(title: Text(s.privacyTitle)),
      body: ContentWidth(
        child: got == null
            ? (keys.hasError
                  ? ErrorView(message: s.errorTitle)
                  : const LinearProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.all(tokens.md),
                      children: [
                        ...switch (_step) {
                          _Step.overview when !got.hasKeys() => _intro(s),
                          _Step.overview => _health(s, got.keys),
                          _Step.kit => _kit(s),
                          _Step.verify => _verify(s),
                          _Step.drill => _drillForm(s),
                        },
                        if (_error case final error?)
                          Padding(
                            padding: EdgeInsets.only(top: tokens.md),
                            child: Text(
                              error,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // The step's button stays in view below what scrolls.
                  if (_action(s, got) case (final label, final onPressed))
                    Padding(
                      padding: EdgeInsets.all(tokens.md),
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: FilledButton(
                          onPressed: _busy ? null : onPressed,
                          child: Text(label),
                        ),
                      ),
                    ),
                  if (_busy) const LinearProgressIndicator(),
                ],
              ),
      ),
    );
  }

  /// The step's button.
  (String, VoidCallback)? _action(AppLocalizations s, GetKeysResponse got) =>
      switch (_step) {
        _Step.overview when !got.hasKeys() => (
          s.privacySetUp,
          () => _setUp(got),
        ),
        _Step.overview => (s.privacyCheckKit, () => _go(_Step.drill)),
        _Step.kit => (s.privacyKitWritten, _ask),
        _Step.verify => (s.privacyVerify, _verifyWords),
        _Step.drill => (s.privacyVerify, () => _drill(got)),
      };

  List<Widget> _intro(AppLocalizations s) => [
    Text(s.privacyHonest),
    const SizedBox(height: 16),
    Text(s.privacyPasswordHelp),
    TextField(
      controller: _password,
      obscureText: true,
      decoration: InputDecoration(labelText: s.serverPassword),
    ),
  ];

  List<Widget> _health(AppLocalizations s, AccountKeys keys) {
    final formats = Formats.of(context);
    final now = DateTime.now();
    final verified = keys.hasRecoveryVerifiedAt();
    final due = verified && keys.drillDueAt.toDateTime().isBefore(now);
    return [
      Text(s.privacyHonest),
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(
          keys.ready ? Icons.lock_outline : Icons.warning_amber_outlined,
        ),
        title: Text(keys.ready ? s.privacyReady : s.privacyNotReady),
      ),
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(
          verified && !due
              ? Icons.verified_user_outlined
              : Icons.warning_amber_outlined,
        ),
        title: Text(
          verified
              ? s.privacyKitVerified(
                  formats.date(keys.recoveryVerifiedAt.toDateTime().toLocal()),
                )
              : s.privacyKitUnverified,
        ),
        subtitle: due ? Text(s.privacyDrillDue) : null,
      ),
      const SizedBox(height: 16),
      Text(s.privacyWays, style: Theme.of(context).textTheme.titleMedium),
      for (final path in keys.paths)
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(
            path.kind == UnlockKind.UNLOCK_KIND_PASSWORD
                ? Icons.password_outlined
                : Icons.key_outlined,
          ),
          title: Text(
            path.kind == UnlockKind.UNLOCK_KIND_PASSWORD
                ? s.serverPassword
                : s.privacyRecoveryKit,
          ),
        ),
    ];
  }

  List<Widget> _kit(AppLocalizations s) {
    final words = _enrolment?.phrase.split(' ') ?? const [];
    return [
      Text(s.privacyKitTitle, style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: 8),
      Text(s.privacyKitBody),
      const SizedBox(height: 16),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final (i, word) in words.indexed)
            SizedBox(
              width: 112,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.privacyWord(i + 1),
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      Text(word),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    ];
  }

  List<Widget> _verify(AppLocalizations s) => [
    Text(s.privacyVerifyBody),
    for (final (i, position) in _positions.indexed)
      TextField(
        controller: _words[i],
        autocorrect: false,
        enableSuggestions: false,
        decoration: InputDecoration(labelText: s.privacyWord(position + 1)),
      ),
    Align(
      alignment: AlignmentDirectional.centerStart,
      child: TextButton(
        onPressed: () => _go(_Step.kit),
        child: Text(s.privacyShowWords),
      ),
    ),
  ];

  List<Widget> _drillForm(AppLocalizations s) => [
    TextField(
      controller: _phrase,
      autocorrect: false,
      enableSuggestions: false,
      minLines: 3,
      maxLines: null,
      decoration: InputDecoration(
        labelText: s.privacyPhrase,
        helperText: s.privacyPhraseHelp,
      ),
    ),
  ];
}
