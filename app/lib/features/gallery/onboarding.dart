import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/core/deletion.dart';
import 'package:photolib/core/device_library.dart';
import 'package:photolib/features/gallery/actions.dart';
import 'package:photolib/features/gallery/gallery_prefs.dart';
import 'package:photolib/l10n/app_localizations.dart';
import 'package:photolib/ui/tokens.dart';
import 'package:photolib_data/photolib_data.dart' show MediaAccess;

/// Whether Photolib opens pictures by default, and the default camera; read
/// again each time the app resumes from a system screen.
final FutureProvider<GalleryStatus> galleryStatusProvider =
    FutureProvider.autoDispose<GalleryStatus>((ref) {
      final lifecycle = AppLifecycleListener(onResume: ref.invalidateSelf);
      ref.onDispose(lifecycle.dispose);
      return ref.watch(galleryPlatformProvider).status();
    });

/// Whether the user let Photolib manage media, which spares the dialog of each
/// trash and delete request.
final FutureProvider<bool> canManageMediaProvider =
    FutureProvider.autoDispose<bool>((ref) async {
      final lifecycle = AppLifecycleListener(onResume: ref.invalidateSelf);
      ref.onDispose(lifecycle.dispose);
      return !await ref.watch(mediaPlatformProvider)('mediastore').asksFirst();
    });

enum _Step { defaultApp, media, manage, notifications }

/// Settings › Make Photolib your gallery (MOB-02, ADR-0401): the steps that
/// make Photolib the app other apps open pictures in, each optional: setting
/// it as the default, access to all photos and videos, MANAGE_MEDIA and
/// notifications. A step says once what breaks without it; none asks for
/// unrestricted battery use or access to all files; it also names the default
/// camera, whose preview decides whether Photolib opens (ADR-0039).
class OnboardingPage extends ConsumerStatefulWidget {
  /// The page.
  const new({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  /// What had been explained before this visit.
  Set<String>? _explained;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    final prefs = ref.read(galleryPrefsProvider.notifier);
    await prefs.loaded;
    if (!mounted) return;
    setState(() => _explained = {...ref.read(galleryPrefsProvider).explained});
    // Said once: the next visit leaves the reasons out.
    for (final step in _Step.values) {
      prefs.explain(step.name);
    }
  }

  Future<void> _act(_Step step) async {
    final platform = ref.read(galleryPlatformProvider);
    switch (step) {
      case _Step.defaultApp:
        await platform.open(SystemScreen.defaultApps);
      case _Step.media:
        await ref.read(mediaAccessProvider.notifier).request();
      case _Step.manage:
        await platform.open(SystemScreen.manageMedia);
      case _Step.notifications:
        await platform.open(SystemScreen.notifications);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final tokens = AppTokens.of(context);
    final explained = _explained;
    final status = ref.watch(galleryStatusProvider).value;
    final done = {
      _Step.defaultApp: status?.isDefault ?? false,
      _Step.media: ref.watch(mediaAccessProvider).value == MediaAccess.full,
      _Step.manage: ref.watch(canManageMediaProvider).value ?? false,
      // The system does not say; the button is always there.
      _Step.notifications: false,
    };
    final titles = {
      _Step.defaultApp: strings.galleryStepDefault,
      _Step.media: strings.galleryStepMedia,
      _Step.manage: strings.galleryStepManage,
      _Step.notifications: strings.galleryStepNotifications,
    };
    final reasons = {
      _Step.defaultApp: strings.galleryStepDefaultWhy,
      _Step.media: strings.galleryStepMediaWhy,
      _Step.manage: strings.galleryStepManageWhy,
      _Step.notifications: strings.galleryStepNotificationsWhy,
    };
    return Scaffold(
      appBar: AppBar(title: Text(strings.galleryOnboardTitle)),
      body: explained == null
          ? const SizedBox.shrink()
          : ListView(
              padding: EdgeInsets.all(tokens.md),
              children: [
                Text(strings.galleryOnboardIntro),
                SizedBox(height: tokens.md),
                for (final step in _Step.values)
                  Card(
                    margin: EdgeInsets.only(bottom: tokens.sm),
                    child: Padding(
                      padding: EdgeInsets.all(tokens.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                done[step]!
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                              ),
                              SizedBox(width: tokens.sm),
                              Expanded(
                                child: Text(
                                  titles[step]!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium,
                                ),
                              ),
                            ],
                          ),
                          if (!done[step]! &&
                              !explained.contains(step.name)) ...[
                            SizedBox(height: tokens.sm),
                            Text(reasons[step]!),
                          ],
                          SizedBox(height: tokens.sm),
                          if (done[step]!)
                            Text(strings.galleryStepDone)
                          else
                            OutlinedButton(
                              onPressed: () => unawaited(_act(step)),
                              child: Text(strings.galleryStepOpen),
                            ),
                        ],
                      ),
                    ),
                  ),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(tokens.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.photo_camera_outlined),
                            SizedBox(width: tokens.sm),
                            Expanded(
                              child: Text(
                                strings.galleryStepCamera,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: tokens.sm),
                        Text(
                          strings.galleryCameraNote(
                            status?.camera ?? strings.galleryStepCamera,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(tokens.md),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.lock_outline),
                        SizedBox(width: tokens.sm),
                        Expanded(child: Text(strings.galleryUninstallWarning)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
