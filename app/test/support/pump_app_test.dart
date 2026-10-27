// pumpApp's tests, run on fixtures that fail on purpose (untimed, in main).
import 'package:flutter_test/flutter_test.dart';
import 'package:photolib_harness/testing.dart';

Future<void> main() async {
  final run = await outcomes([
    'flutter',
    'test',
    '--no-pub',
    '--timeout=60s',
    'test/support/fixtures/failing_app.dart',
  ]);

  test('a test that fails with the app up fails at once, not when its '
      'timeout ends, as the app is gone before its database closes', () {
    expect(run, {
      'fails with the viewer up': everyElement(
        allOf(contains('Test failed'), isNot(contains('timed out'))),
      ),
    });
  });
}
