import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/features/servers/servers.dart';
import 'package:photolib/l10n/app_localizations.dart';
import 'package:photolib/l10n/formats.dart';
import 'package:photolib/ui/adaptive.dart';
import 'package:photolib/ui/tokens.dart';
import 'package:photolib_api/photolib_api.dart';

/// The app's version, which the server's oldest one served is checked against;
/// empty in tests.
const appVersion = String.fromEnvironment('FLUTTER_BUILD_NAME');

/// Runs the connection check of [diagnose] on one address; tests fake it.
typedef Check = Stream<Finding> Function(
  NetworkConfig config,
  Uri endpoint,
  String? instance,
);

/// Whether this device is on a metered network, such as mobile data.
final meteredProvider = Provider<Future<bool> Function()>(
  (ref) =>
      () async => metered(await Connectivity().checkConnectivity()),
);

/// Whether [networks] reach the internet only through mobile data, which the
/// platforms count by the byte.
bool metered(List<ConnectivityResult> networks) =>
    networks.contains(ConnectivityResult.mobile) &&
    !networks.contains(ConnectivityResult.wifi) &&
    !networks.contains(ConnectivityResult.ethernet);

/// The connection check this app runs.
final checkProvider = Provider<Check>(
  (ref) =>
      (config, endpoint, instance) => diagnose(
        config,
        endpoint,
        instance: instance?.isEmpty ?? true ? null : instance,
        version: appVersion,
        metered: ref.read(meteredProvider),
      ),
);

enum _Fix { retry, trust, signIn, copy }

/// The connection check (OPS-29): every step against each address of
/// [server], in order, the failing one named with its cause, its next step and
/// a fix one tap away. [saved] when [server] is the one this app keeps, whose
/// certificate and session the fixes then change.
class ConnectionCheckPage extends ConsumerStatefulWidget {
  /// The check of [server]'s addresses.
  const new(this.server, {super.key, this.saved = true});

  /// The server, saved or about to be added.
  final SavedServer server;

  /// Whether [server] is the one this app keeps.
  final bool saved;

  @override
  ConsumerState<ConnectionCheckPage> createState() => _CheckState();
}

class _CheckState extends ConsumerState<ConnectionCheckPage> {
  late SavedServer _server = widget.server;
  final _found = <Uri, List<Finding>>{};

  @override
  void initState() {
    super.initState();
    _run();
  }

  void _run() {
    final check = ref.read(checkProvider);
    setState(_found.clear);
    for (final endpoint in _server.endpoints) {
      final found = _found[endpoint] = [];
      check(_server.config, endpoint, _server.instance).listen(
        (finding) => mounted ? setState(() => found.add(finding)) : null,
      );
    }
  }

  Future<void> _fix(_Fix fix, Uri endpoint, Finding finding) async {
    final s = AppLocalizations.of(context);
    final navigator = Navigator.of(context);
    final notifier = ref.read(accountsProvider.notifier);
    switch (fix) {
      case _Fix.retry:
        _run();
      case _Fix.copy:
        final (cause, next) = _words(s, finding);
        await Clipboard.setData(
          ClipboardData(text: [endpoint, cause, next, finding].join('\n')),
        );
      case _Fix.trust:
        final pin = finding.fingerprint ?? '';
        if (!await trustCertificate(context, endpoint, pin)) return;
        _server = _server.pinned(pin);
        await notifier.put(_server);
        _run();
      case _Fix.signIn:
        await notifier.ended(_server.account?.token ?? '');
        navigator.pop();
    }
  }

  (String, String) _words(AppLocalizations s, Finding finding) =>
      switch (finding.fault) {
        Fault.dnsFailed => (s.checkDnsFailed, s.checkDnsFailedNext),
        Fault.refused => (s.checkRefused, s.checkRefusedNext),
        Fault.timedOut => (s.checkTimedOut, s.checkTimedOutNext),
        Fault.certificateExpired => (
          s.checkExpired(
            Formats.of(context)
                .date((finding.date ?? DateTime.now()).toLocal()),
          ),
          s.nextAskAdmin,
        ),
        Fault.selfSigned => (s.checkSelfSigned, s.checkTrustNext),
        Fault.certificateChanged => (s.checkChanged, s.checkChangedNext),
        Fault.untrustedCertificate => (s.checkUntrusted, s.checkTrustNext),
        Fault.tlsFailed => (s.checkTlsFailed, s.nextAskAdmin),
        Fault.notPhotolib => (s.checkNotPhotolib, s.checkNotPhotolibNext),
        Fault.otherServer => (s.checkOtherServer, s.nextAskAdmin),
        Fault.appTooOld => (s.checkAppTooOld, s.checkAppTooOldNext),
        Fault.signedOut => (s.problemSignedOut, s.nextSignIn),
        Fault.uploadCap => (s.checkUploadCap, s.checkUploadCapNext),
        Fault.metered => (s.checkMetered, s.checkMeteredNext),
        Fault.clockSkew => (s.checkClock, s.checkClockNext),
        null => ('', ''),
      };

  _Fix _fixOf(Fault fault) => switch (fault) {
    Fault.selfSigned ||
    Fault.certificateChanged ||
    Fault.untrustedCertificate when widget.saved => _Fix.trust,
    Fault.signedOut when widget.saved => _Fix.signIn,
    Fault.certificateExpired ||
    Fault.tlsFailed ||
    Fault.notPhotolib ||
    Fault.otherServer ||
    Fault.appTooOld ||
    Fault.uploadCap => _Fix.copy,
    _ => _Fix.retry,
  };

  Widget _row(BuildContext context, Uri endpoint, CheckStep kind) {
    final s = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final finding = _found[endpoint]?.where((f) => f.step == kind).firstOrNull;
    final (icon, color, state) = switch (finding) {
      null => (Icons.more_horiz, colors.outline, s.checkRunning),
      Finding(ran: false) => (Icons.remove, colors.outline, s.checkSkipped),
      Finding(fault: null) => (
        Icons.check_circle_outline,
        colors.primary,
        s.checkPassed,
      ),
      _ => (Icons.error_outline, colors.error, s.checkFailed),
    };
    final fault = finding?.fault;
    if (finding == null || fault == null) {
      return ListTile(
        leading: Icon(icon, color: color, semanticLabel: state),
        title: Text(_title(s, kind)),
      );
    }
    final (cause, next) = _words(s, finding);
    final fix = _fixOf(fault);
    return ListTile(
      leading: Icon(icon, color: color, semanticLabel: state),
      title: Text(_title(s, kind)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppTokens.of(context).xs,
        children: [
          Text(cause, style: TextStyle(color: colors.error)),
          Text(next),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: FilledButton.tonal(
              onPressed: () => _fix(fix, endpoint, finding),
              child: Text(_label(s, fix)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final tokens = AppTokens.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(s.checkTitle),
        actions: [
          IconButton(
            tooltip: s.errorRetry,
            icon: const Icon(Icons.refresh),
            onPressed: _run,
          ),
        ],
      ),
      body: ContentWidth(
        child: ListView(
          padding: EdgeInsets.all(tokens.md),
          children: [
            for (final endpoint in _found.keys) ...[
              Semantics(
                header: true,
                child: Text(
                  '$endpoint',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              for (final kind in CheckStep.values)
                _row(context, endpoint, kind),
              SizedBox(height: tokens.md),
            ],
          ],
        ),
      ),
    );
  }
}

/// Whether the user trusts the certificate [url] presents, whose SHA-256 is
/// [fingerprint], once they compared it with their server's.
Future<bool> trustCertificate(
  BuildContext context,
  Uri url,
  String fingerprint,
) async {
  final s = AppLocalizations.of(context);
  final pairs = [
    for (var i = 0; i < fingerprint.length; i += 2)
      fingerprint.substring(i, i + 2),
  ].join(':').toUpperCase();
  return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(s.serverCertificateTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppTokens.of(context).sm,
            children: [
              Text(s.serverCertificateBody(url.host)),
              Text(pairs, style: const TextStyle(fontFamily: 'monospace')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(s.serverTrust),
            ),
          ],
        ),
      ) ??
      false;
}

String _title(AppLocalizations s, CheckStep step) => switch (step) {
  CheckStep.dns => s.checkStepDns,
  CheckStep.tcp => s.checkStepTcp,
  CheckStep.tls => s.checkStepTls,
  CheckStep.server => s.checkStepServer,
  CheckStep.auth => s.checkStepAuth,
  CheckStep.upload => s.checkStepUpload,
  CheckStep.network => s.checkStepNetwork,
  CheckStep.clock => s.checkStepClock,
};

String _label(AppLocalizations s, _Fix fix) => switch (fix) {
  _Fix.retry => s.errorRetry,
  _Fix.trust => s.serverTrust,
  _Fix.signIn => s.serverSignIn,
  _Fix.copy => s.problemCopy,
};
