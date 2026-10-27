/// What a gallery is asked to do (ADR-0039, ADR-0401).
enum IntentKind {
  /// Open items: `VIEW`, `REVIEW`, `REVIEW_SECURE`, `ATTACH_DATA`.
  view,

  /// Edit an item: `EDIT`.
  edit,

  /// Pick items for the caller: `PICK`, `GET_CONTENT`.
  pick,

  /// Show what was shared: `SEND`, `SEND_MULTIPLE`.
  send,
}

const _views = {
  'android.intent.action.VIEW',
  'android.provider.action.REVIEW',
  'com.android.camera.action.REVIEW',
  'android.intent.action.ATTACH_DATA',
};
const _secure = 'android.provider.action.REVIEW_SECURE';
const _picks = {
  'android.intent.action.PICK',
  'android.intent.action.GET_CONTENT',
};
const _sends = {
  'android.intent.action.SEND',
  'android.intent.action.SEND_MULTIPLE',
};

/// An intent another app sent, as GalleryIntents.kt hands its fields over;
/// the decisions are here, where they are tested.
class GalleryIntent {
  const new _(
    this.kind,
    this.uris, {
    this.type,
    this.secure = false,
    this.multiple = false,
    this.types = const [],
  });

  /// The intent [raw] describes: its `action`, MIME `type`, `data` URI,
  /// `clips` (the URIs of its ClipData and `EXTRA_STREAM`), `multiple`
  /// (`EXTRA_ALLOW_MULTIPLE`), `types` (`EXTRA_MIME_TYPES`) and `secure`;
  /// null for what is not a gallery's: the launcher, Photolib's own links,
  /// a view of nothing.
  static GalleryIntent? fromMap(Map<Object?, Object?> raw) {
    final action = raw['action'] as String?;
    final data = raw['data'] as String?;
    final type = raw['type'] as String?;
    final uris = <Uri>[
      if (data != null) Uri.parse(data),
      for (final clip
          in (raw['clips'] as List?)?.cast<String>() ?? const <String>[])
        if (clip != data) Uri.parse(clip),
    ];
    if (uris.any((u) => u.scheme == 'photolib')) return null;
    GalleryIntent make(IntentKind kind, {bool secure = false}) =>
        GalleryIntent._(
          kind,
          uris,
          type: type,
          secure: secure || raw['secure'] == true,
          multiple: raw['multiple'] == true,
          types: (raw['types'] as List?)?.cast<String>() ?? const [],
        );
    if (action == _secure && uris.isNotEmpty) {
      return make(IntentKind.view, secure: true);
    }
    if (_views.contains(action) && uris.isNotEmpty) {
      return make(IntentKind.view);
    }
    if (action == 'android.intent.action.EDIT' && uris.isNotEmpty) {
      return make(IntentKind.edit);
    }
    if (_sends.contains(action) && uris.isNotEmpty) {
      return make(IntentKind.send);
    }
    if (_picks.contains(action)) return make(IntentKind.pick);
    return null;
  }

  /// What the caller wants done.
  final IntentKind kind;

  /// The items, in the order the caller gave them.
  final List<Uri> uris;

  /// The MIME type the caller named; none when it sent none.
  final String? type;

  /// Whether the phone is locked: items are only looked at (`REVIEW_SECURE`).
  final bool secure;

  /// Whether a pick may return many items.
  final bool multiple;

  /// The types a pick is limited to, besides [type].
  final List<String> types;

  /// Whether a picker offers an item of MIME type [mime]; one of no known
  /// type is always offered.
  bool accepts(String? mime) {
    if (mime == null) return true;
    final wanted = types.isNotEmpty ? types : [type ?? '*/*'];
    return wanted.any((pattern) {
      if (pattern == '*/*' || pattern == '*') return true;
      if (pattern.endsWith('/*')) {
        return mime.startsWith(pattern.substring(0, pattern.length - 1));
      }
      return pattern == mime;
    });
  }
}

/// An item of MediaStore: its volume (`external_primary`, an SD card's name or
/// the legacy `external`) and its id.
typedef MediaRef = ({String volume, String id});

/// The MediaStore item a `content://media/VOLUME/KIND/...` URI names, KIND
/// being images, video, audio or file; null for another provider's, which
/// only the app that owns it can say more of.
MediaRef? mediaRefOf(Uri uri) {
  if (!uri.isScheme('content') || uri.authority != 'media') return null;
  final parts = uri.pathSegments;
  final volume = parts.firstOrNull;
  final id = switch (parts) {
    [_, 'images' || 'video' || 'audio', 'media', final id] => id,
    [_, 'file', final id] => id,
    _ => null,
  };
  if (volume == null || id == null || int.tryParse(id) == null) return null;
  return (volume: volume, id: id);
}
