import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../support/pump_app.dart';

void main() {
  testWidgets('Settings has an About page that shows the licences the app '
      'registers, the LGPL notices of the libmpv and FFmpeg Windows bundles '
      'among them (ADR-0229)', (tester) async {
    LicenseRegistry.addLicense(
      () => Stream.value(
        const LicenseEntryWithLineBreaks([
          'libmpv and FFmpeg',
        ], 'GNU Lesser General Public License, version 2.1 or later'),
      ),
    );
    await pumpApp(tester);
    await tester.tapAndSettle(find.byTooltip('Settings'));
    await tester.scrollTo(find.byType(AboutListTile));
    expect(find.text('About Photolib'), findsOneWidget);
    await tester.tapAndSettle(find.byType(AboutListTile));
    await tester.tapAndSettle(find.text('View licenses'));
    expect(find.byType(LicensePage), findsOneWidget);
    await tester.pumpUntil(
      () => find.text('libmpv and FFmpeg').evaluate().isNotEmpty,
    );
    await tester.tapAndSettle(find.text('libmpv and FFmpeg'));
    expect(find.textContaining('Lesser General Public'), findsOneWidget);
  });
}
