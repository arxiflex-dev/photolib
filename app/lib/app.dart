import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/core/feature_flags.dart';
import 'package:photolib/core/keystore.dart';
import 'package:photolib/core/on_device_ml.dart';
import 'package:photolib/core/providers.dart';
import 'package:photolib/core/replica.dart';
import 'package:photolib/features/servers/hints.dart';
import 'package:photolib/features/servers/sync.dart';
import 'package:photolib/features/settings/settings.dart';
import 'package:photolib/l10n/app_localizations.dart';
import 'package:photolib/l10n/formats.dart';
import 'package:photolib/l10n/locales.dart';
import 'package:photolib/router.dart';
import 'package:photolib/ui/theme.dart';

/// Runs the app of [container] once its settings are read, so that its first
/// frame has the stored theme and language; at once if the vault fails to
/// open or its keystore asks for a passphrase, after [wait] if it is slow to.
Future<void> runPhotolib(
  ProviderContainer container, {
  Duration wait = const Duration(milliseconds: 500),
}) async {
  final unreadable = Completer<void>();
  void stop() {
    if (!unreadable.isCompleted) unreadable.complete();
  }

  final vault = container.listen(vaultProvider, (_, next) {
    if (next.hasError) stop();
  });
  final prompt = container.listen(passphrasePromptProvider, (_, next) {
    if (next != null) stop();
  });
  await Future.any([
    container.read(settingsProvider.notifier).loaded,
    unreadable.future,
  ]).timeout(wait, onTimeout: () {});
  vault.close();
  prompt.close();
  runApp(
    UncontrolledProviderScope(container: container, child: const PhotolibApp()),
  );
}

/// The app, which syncs the account in use (ADR-0234) and follows its
/// server's hints in the foreground (ADR-0225).
class PhotolibApp extends ConsumerWidget {
  /// The app.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Syncs and follows hints, and reads the accounts at start, so that kept
    // sessions are renewed (ADR-0052).
    ref
      ..watch(hintsProvider)
      ..watch(syncingProvider)
      ..watch(forgetRemovedProvider);
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: [
        ...launchLocales,
        if (ref.watch(featureFlagsProvider).isOn(Flag.pseudoLocales))
          ...pseudoLocales,
      ],
      theme: appTheme(Brightness.light),
      darkTheme: appTheme(Brightness.dark),
      highContrastTheme: appTheme(Brightness.light, highContrast: true),
      highContrastDarkTheme: appTheme(Brightness.dark, highContrast: true),
      locale: ref.watch(settingsProvider).language,
      themeMode: ref.watch(settingsProvider).themeMode,
      routerConfig: ref.watch(routerProvider),
      builder: (context, child) => DateOrderScope(
        order: ref.watch(settingsProvider.select((s) => s.dateFormat)),
        child: InteractionReporter(child: child ?? const SizedBox.shrink()),
      ),
    );
  }
}
