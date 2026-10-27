import 'package:flutter_test/flutter_test.dart';
import 'package:photolib/features/gallery/gallery_intent.dart';

void main() {
  Map<String, Object?> raw(
    String action, {
    String? type,
    String? data,
    List<String> clips = const [],
    bool multiple = false,
    List<String> types = const [],
    bool secure = false,
  }) => {
    'action': action,
    'type': type,
    'data': data,
    'clips': clips,
    'multiple': multiple,
    'types': types,
    'secure': secure,
  };

  const media = 'content://media/external_primary/images/media/42';

  group('the actions a default gallery answers (ADR-0039)', () {
    for (final action in [
      'android.intent.action.VIEW',
      'android.provider.action.REVIEW',
      'com.android.camera.action.REVIEW',
      'android.intent.action.ATTACH_DATA',
    ]) {
      test('$action opens the item read-write', () {
        final intent = GalleryIntent.fromMap(
          raw(action, type: 'image/jpeg', data: media),
        );
        expect(intent?.kind, IntentKind.view);
        expect(intent?.uris, [Uri.parse(media)]);
        expect(intent?.secure, isFalse);
      });
    }

    test('REVIEW_SECURE opens read-only, over the lock screen', () {
      final intent = GalleryIntent.fromMap(
        raw(
          'android.provider.action.REVIEW_SECURE',
          clips: [media, 'content://media/external_primary/images/media/43'],
        ),
      );
      expect(intent?.kind, IntentKind.view);
      expect(intent?.secure, isTrue);
      expect(intent?.uris, hasLength(2));
    });

    test(
      'a REVIEW without a MIME type, as Open Camera sends it, still opens',
      () {
        final intent = GalleryIntent.fromMap(
          raw('com.android.camera.action.REVIEW', data: media),
        );
        expect(intent?.kind, IntentKind.view);
        expect(intent?.type, isNull);
      },
    );

    test('EDIT is an edit of the one item', () {
      final intent = GalleryIntent.fromMap(
        raw('android.intent.action.EDIT', type: 'image/*', data: media),
      );
      expect(intent?.kind, IntentKind.edit);
      expect(intent?.uris, [Uri.parse(media)]);
    });

    test('PICK and GET_CONTENT pick one item, or many when asked', () {
      for (final action in [
        'android.intent.action.PICK',
        'android.intent.action.GET_CONTENT',
      ]) {
        final one = GalleryIntent.fromMap(raw(action, type: 'image/*'));
        expect(one?.kind, IntentKind.pick);
        expect(one?.multiple, isFalse);
        final many = GalleryIntent.fromMap(
          raw(action, type: 'image/*', multiple: true),
        );
        expect(many?.multiple, isTrue);
      }
    });

    test('SEND and SEND_MULTIPLE carry the shared streams', () {
      final one = GalleryIntent.fromMap(
        raw('android.intent.action.SEND', type: 'image/png', clips: [media]),
      );
      expect(one?.kind, IntentKind.send);
      expect(one?.uris, [Uri.parse(media)]);
      final many = GalleryIntent.fromMap(
        raw(
          'android.intent.action.SEND_MULTIPLE',
          type: 'image/*',
          clips: [media, 'content://other/1'],
        ),
      );
      expect(many?.uris, hasLength(2));
    });

    test('the launcher, links and the unknown are not gallery intents', () {
      expect(GalleryIntent.fromMap(raw('android.intent.action.MAIN')), isNull);
      expect(
        GalleryIntent.fromMap(
          raw('android.intent.action.VIEW', data: 'photolib://password-setup'),
        ),
        isNull,
      );
      expect(GalleryIntent.fromMap(raw('android.intent.action.VIEW')), isNull);
      expect(
        GalleryIntent.fromMap(raw('org.example.NOPE', data: media)),
        isNull,
      );
    });
  });

  group('what a picker offers', () {
    GalleryIntent pick(String? type, [List<String> types = const []]) =>
        GalleryIntent.fromMap(
          raw('android.intent.action.GET_CONTENT', type: type, types: types),
        )!;

    test('images only, videos only, both, or whatever the types list says', () {
      expect(pick('image/*').accepts('image/jpeg'), isTrue);
      expect(pick('image/*').accepts('video/mp4'), isFalse);
      expect(pick('video/*').accepts('video/mp4'), isTrue);
      expect(pick('*/*').accepts('video/mp4'), isTrue);
      expect(pick(null).accepts('image/png'), isTrue);
      expect(
        pick('*/*', ['image/png', 'video/*']).accepts('image/png'),
        isTrue,
      );
      expect(
        pick('*/*', ['image/png', 'video/*']).accepts('image/jpeg'),
        isFalse,
      );
      expect(
        pick('*/*', ['image/png', 'video/*']).accepts('video/webm'),
        isTrue,
      );
    });

    test('an item without a MIME type is offered', () {
      expect(pick('image/*').accepts(null), isTrue);
    });
  });

  group('MediaStore URIs', () {
    test('name a volume, a kind and an id', () {
      expect(mediaRefOf(Uri.parse(media)), (
        volume: 'external_primary',
        id: '42',
      ));
      expect(mediaRefOf(Uri.parse('content://media/external/video/media/7')), (
        volume: 'external',
        id: '7',
      ));
      expect(mediaRefOf(Uri.parse('content://media/external_primary/file/9')), (
        volume: 'external_primary',
        id: '9',
      ));
    });

    test('other providers, bad ids and other schemes name none', () {
      expect(
        mediaRefOf(Uri.parse('content://com.example.files/doc/42')),
        isNull,
      );
      expect(
        mediaRefOf(Uri.parse('content://media/external/images/media/x')),
        isNull,
      );
      expect(mediaRefOf(Uri.parse('file:///sdcard/a.jpg')), isNull);
      expect(mediaRefOf(Uri.parse('content://media/external/images')), isNull);
    });
  });
}
