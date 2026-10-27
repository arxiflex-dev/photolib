import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:photolib/features/gallery/actions.dart';
import 'package:photolib/features/gallery/edit_with.dart';
import 'package:photolib/features/gallery/gallery_prefs.dart';

class _Platform implements GalleryPlatform {
  new(this.apps, {this.edited});

  final List<Editor> apps;
  final Uint8List? edited;
  final calls = <(Uri, String, String?)>[];

  @override
  Future<List<Editor>> editors(String mime) async => apps;

  @override
  Future<Uint8List?> editWith(Uri uri, String mime, String? package) async {
    calls.add((uri, mime, package));
    return edited;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

void main() {
  final item = Uri.parse('content://media/external_primary/images/media/5');
  const snapseed = (package: 'com.snapseed', label: 'Snapseed');
  const gimp = (package: 'org.gimp', label: 'GIMP');
  final jpeg = Uint8List.fromList([0xFF, 0xD8, 1, 2, 3]);

  test('asks which editor once, remembers it, and saves the result as a copy '
      'through the write', () async {
    final platform = _Platform([snapseed, gimp], edited: jpeg);
    var prefs = const GalleryPrefs();
    final asked = <List<Editor>>[];
    final saved = <Uint8List>[];
    Future<EditWithOutcome> run() => editWithApp(
      platform: platform,
      uri: item,
      mime: 'image/jpeg',
      prefs: prefs,
      remember: (e) => prefs = prefs.withEditor(e),
      choose: (editors) async {
        asked.add(editors);
        return gimp;
      },
      save: (bytes) async {
        saved.add(bytes);
        return true;
      },
    );

    expect(await run(), EditWithOutcome.saved);
    expect(asked, hasLength(1));
    expect(platform.calls.single, (item, 'image/jpeg', 'org.gimp'));
    expect(saved.single, jpeg);
    expect(prefs.editor, gimp);

    // The second time the chosen editor opens without a question.
    expect(await run(), EditWithOutcome.saved);
    expect(asked, hasLength(1));
    expect(platform.calls.last.$3, 'org.gimp');
  });

  test('an editor that was uninstalled is asked for again', () async {
    final platform = _Platform([snapseed], edited: jpeg);
    var prefs = const GalleryPrefs(editor: gimp);
    final outcome = await editWithApp(
      platform: platform,
      uri: item,
      mime: 'image/jpeg',
      prefs: prefs,
      remember: (e) => prefs = prefs.withEditor(e),
      choose: (editors) async => editors.single,
      save: (_) async => true,
    );
    expect(outcome, EditWithOutcome.saved);
    expect(platform.calls.single.$3, 'com.snapseed');
    expect(prefs.editor, snapseed);
  });

  test('an editor that changed nothing saves nothing', () async {
    final platform = _Platform([snapseed]);
    var saves = 0;
    final outcome = await editWithApp(
      platform: platform,
      uri: item,
      mime: 'image/jpeg',
      prefs: const GalleryPrefs(editor: snapseed),
      remember: (_) {},
      choose: (_) async => null,
      save: (_) async {
        saves++;
        return true;
      },
    );
    expect(outcome, EditWithOutcome.unchanged);
    expect(saves, 0);
  });

  test(
    'no editor on the phone, and a cancelled question, do nothing',
    () async {
      final none = _Platform(const []);
      expect(
        await editWithApp(
          platform: none,
          uri: item,
          mime: 'image/jpeg',
          prefs: const GalleryPrefs(),
          remember: (_) {},
          choose: (_) async => snapseed,
          save: (_) async => true,
        ),
        EditWithOutcome.noEditor,
      );
      expect(none.calls, isEmpty);
      final some = _Platform([snapseed, gimp], edited: jpeg);
      expect(
        await editWithApp(
          platform: some,
          uri: item,
          mime: 'image/jpeg',
          prefs: const GalleryPrefs(),
          remember: (_) {},
          choose: (_) async => null,
          save: (_) async => true,
        ),
        EditWithOutcome.cancelled,
      );
      expect(some.calls, isEmpty);
    },
  );

  test(
    'a copy that cannot be written is reported, not lost silently',
    () async {
      final outcome = await editWithApp(
        platform: _Platform([snapseed], edited: jpeg),
        uri: item,
        mime: 'image/jpeg',
        prefs: const GalleryPrefs(editor: snapseed),
        remember: (_) {},
        choose: (_) async => null,
        save: (_) async => false,
      );
      expect(outcome, EditWithOutcome.notSaved);
    },
  );

  test('the prefs survive a round trip and forget one editor', () {
    const prefs = GalleryPrefs(
      editor: gimp,
      explained: {'media', 'manageMedia'},
    );
    final back = GalleryPrefs.fromJson(prefs.toJson());
    expect(back.editor, gimp);
    expect(back.explained, {'media', 'manageMedia'});
    expect(back.withEditor(null).editor, isNull);
    expect(back.explain('notifications').explained, hasLength(3));
  });
}
