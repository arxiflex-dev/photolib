import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photolib/core/keystore.dart';
import 'package:photolib/core/replica.dart';
import 'package:photolib/features/gallery/actions.dart';

/// What this device remembers of the default-gallery integration: the editor
/// the user chose for "Edit with" and the permissions onboarding has
/// explained, each once.
@immutable
class GalleryPrefs {
  /// The prefs.
  const new({this.editor, this.explained = const {}});

  /// The prefs [json] holds, as [toJson] wrote it.
  factory fromJson(Map<String, Object?> json) => GalleryPrefs(
    editor: switch (json['editor']) {
      {'package': final String package, 'label': final String label} => (
        package: package,
        label: label,
      ),
      _ => null,
    },
    explained: {...?(json['explained'] as List?)?.cast<String>()},
  );

  /// The editor "Edit with" opens without asking.
  final Editor? editor;

  /// The permissions onboarding explained (`media`, `manageMedia`,
  /// `notifications`, `default`), so that it never explains one twice.
  final Set<String> explained;

  /// These prefs with [editor] chosen, or forgotten when null.
  GalleryPrefs withEditor(Editor? editor) =>
      GalleryPrefs(editor: editor, explained: explained);

  /// These prefs with [permission] explained.
  GalleryPrefs explain(String permission) =>
      GalleryPrefs(editor: editor, explained: {...explained, permission});

  /// As JSON.
  Map<String, Object?> toJson() => {
    'editor': editor == null
        ? null
        : {'package': editor!.package, 'label': editor!.label},
    'explained': [...explained],
  };
}

/// Where the prefs are kept: sealed in the vault, as the settings are.
final galleryPrefsStoreProvider = Provider<SecretStore>((ref) {
  final vault = ref.watch(vaultProvider.future);
  return VaultText(() => vault, 'gallery');
});

/// The prefs, read at start and written back on every change.
class GalleryPrefsNotifier extends StoredNotifier<GalleryPrefs> {
  @override
  Provider<SecretStore> get store => galleryPrefsStoreProvider;

  @override
  GalleryPrefs get initial => const GalleryPrefs();

  @override
  GalleryPrefs decode(Object json) =>
      GalleryPrefs.fromJson(json as Map<String, Object?>);

  @override
  Object? encode(GalleryPrefs state) => state.toJson();

  /// Keeps [editor] as the one "Edit with" opens, or forgets it.
  void setEditor(Editor? editor) => change((p) => p.withEditor(editor));

  /// Notes that [permission] has been explained.
  void explain(String permission) => change((p) => p.explain(permission));
}

/// The prefs of this device.
final galleryPrefsProvider =
    NotifierProvider<GalleryPrefsNotifier, GalleryPrefs>(
      GalleryPrefsNotifier.new,
    );
