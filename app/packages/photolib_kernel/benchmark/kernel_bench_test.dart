// The kernel's speed through the C ABI (test/bench.dart), printed as `result:` lines for tools/perf/measure.sh, which
// checks them against the series `kernel-binding` of tools/perf/budgets.json; no time is asserted here. With
// --dart-define=vectors=<dir> it measures the kernel the build hook bundles (tools/kernel/probe.sh); otherwise
// kernel/ffi built in release mode, as apps get it, from this checkout.
import 'dart:io';

import 'package:photolib_kernel/photolib_kernel.dart';
import 'package:photolib_kernel/testing.dart';
import 'package:test/test.dart';

import '../test/bench.dart';
import '../test/cases.dart';

const vectors = String.fromEnvironment(
  'vectors',
  defaultValue: '../../../kernel/testvectors/',
);

Keys keys(Kernel kernel) {
  final keyring = kernel.keyring();
  return (
    call: keyring.call,
    open: (method, request) {
      final stream = keyring.openStream(method, request);
      return (push: stream.push, finish: stream.finish);
    },
    close: keyring.close,
  );
}

void main() {
  final kernel = const bool.hasEnvironment('vectors')
      ? Kernel()
      : Kernel.open(buildKernel());
  test('the kernel is measured through the C ABI', () {
    final files = Directory.fromUri(Directory.current.uri.resolve(vectors))
        .listSync()
        .whereType<File>()
        .where((file) => file.path.endsWith('.json'))
        .toList();
    pinToFastestCores(pid);
    report(
      'native',
      benchmark(keys(kernel), {
        for (final file in files)
          file.uri.pathSegments.last: file.readAsStringSync(),
      }, clock: threadClock()),
    );
  });
}
