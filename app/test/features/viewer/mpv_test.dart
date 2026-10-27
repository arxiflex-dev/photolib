import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photolib/features/viewer/mpv.dart';

void main() {
  test('players render in software on Windows, whose app ships no ANGLE', () {
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    for (final (platform, hardware) in [
      (TargetPlatform.windows, false),
      (TargetPlatform.linux, true),
    ]) {
      debugDefaultTargetPlatformOverride = platform;
      expect(
        mpvVideoConfiguration().enableHardwareAcceleration,
        hardware,
        reason: '$platform',
      );
    }
  });

  test('the notices bundled with libmpv are licence entries, one per '
      'library', () async {
    final dir = await Directory.systemTemp.createTemp('notices-');
    addTearDown(() => dir.delete(recursive: true));
    const ffmpeg =
        'FFmpeg: LGPL-2.1-or-later, built from '
        'https://ffmpeg.org/releases/ffmpeg-8.1.3.tar.xz';
    final file = File('${dir.path}/libmpv-notices.txt')
      ..writeAsStringSync(
        'FFmpeg\n\n$ffmpeg\n\n'
        '  GNU LESSER GENERAL PUBLIC LICENSE\n'
        '${'-' * 80}\n'
        'zlib\n\nzlib: Zlib, built from zlib-1.3.2.tar.xz\n\n'
        '  (C) 1995-2026 Jean-loup Gailly and Mark Adler\n',
      );
    final entries = await bundledNotices(file).toList();
    expect(
      [for (final e in entries) e.packages],
      [
        ['FFmpeg'],
        ['zlib'],
      ],
    );
    expect(
      [for (final p in entries.first.paragraphs) p.text],
      [ffmpeg, 'GNU LESSER GENERAL PUBLIC LICENSE'],
    );
    expect(
      await bundledNotices(File('${dir.path}/missing.txt')).toList(),
      isEmpty,
      reason: 'only Windows bundles them',
    );
  });

  test('--self-test-play <video> <result> asks the app to play a video '
      'and report; any other arguments are files to open', () {
    final test = selfTestOf(['--self-test-play', 'a.mp4', 'r.txt']);
    expect((test?.video, test?.result), ('a.mp4', 'r.txt'));
    expect(selfTestOf(const []), isNull);
    expect(selfTestOf(['a.mp4', 'b.jpg']), isNull);
    expect(
      () => selfTestOf(['--self-test-play', 'a.mp4']),
      throwsArgumentError,
      reason: 'a half-given test must not start the app',
    );
  });

  test('a self-test of a video that is not there fails and says so in its '
      'result file, before libmpv is loaded', () async {
    final dir = await Directory.systemTemp.createTemp('self-test-');
    addTearDown(() => dir.delete(recursive: true));
    final test = (video: '${dir.path}/none.mp4', result: '${dir.path}/r.txt');
    expect(await runSelfTest(test), 1);
    expect(
      File(test.result).readAsStringSync(),
      startsWith('failed: ${dir.path}/none.mp4 does not exist'),
    );
  });
}
