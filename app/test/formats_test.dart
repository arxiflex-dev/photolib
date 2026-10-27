import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/l10n/app_localizations.dart';
import 'package:photolib/l10n/formats.dart';

void main() {
  late AppLocalizations english;

  setUpAll(() async {
    english = await AppLocalizations.delegate.load(const Locale('en'));
    await GlobalMaterialLocalizations.delegate.load(const Locale('en'));
  });

  final may3 = DateTime(2024, 5, 3);

  test('dates, numbers and the first day of the week follow the locale', () {
    final formats = Formats(english);
    expect(formats.date(may3), 'May 3, 2024');
    expect(formats.month(may3), 'May 2024');
    expect(formats.year(may3), '2024');
    expect(formats.number(1234567.5), '1,234,567.5');
    expect(formats.firstDayOfWeek, DateTime.sunday);
  });

  test('a capture time shows as far as it is known, and percentages and '
      'coordinates follow the locale', () {
    final formats = Formats(english);
    final when = DateTime(2024, 5, 3, 16, 3, 9);
    expect(formats.taken(when), 'May 3, 2024 4:03\u202fPM');
    expect(formats.taken(when, 'second'), 'May 3, 2024 4:03\u202fPM');
    expect(formats.taken(when, 'day'), 'May 3, 2024');
    expect(formats.taken(when, 'month'), 'May 2024');
    expect(formats.taken(when, 'year'), '2024');
    expect(formats.percent(95), '95%');
    expect(formats.place(48.858361, -2.2944), '48.85836, -2.29440');
  });

  test('dates can follow another locale than the language', () {
    final formats = Formats(english, dateLocale: 'en_GB');
    expect(formats.date(may3), '3 May 2024');
    expect(formats.firstDayOfWeek, DateTime.monday);
    expect(formats.number(1234567.5), '1,234,567.5');
  });

  test('a date order lays dates out its own way, in the language of the app '
      'and no other', () async {
    final german = await AppLocalizations.delegate.load(const Locale('de'));
    await GlobalMaterialLocalizations.delegate.load(const Locale('de'));
    final dec24 = DateTime(2025, 12, 24, 16, 3);
    String of(AppLocalizations s, DateOrder order) =>
        Formats(s, order: order).date(dec24);
    expect(of(english, DateOrder.languageDefault), 'Dec 24, 2025');
    expect(of(english, DateOrder.dmy), '24 Dec 2025');
    expect(of(english, DateOrder.mdy), 'Dec 24, 2025');
    expect(of(english, DateOrder.ymd), '2025 Dec 24');
    expect(of(german, DateOrder.languageDefault), '24. Dez. 2025');
    for (final order in [DateOrder.dmy, DateOrder.mdy, DateOrder.ymd]) {
      expect(of(german, order), contains('Dez'), reason: '$order');
      expect(of(german, order), isNot(contains('Dec')), reason: '$order');
    }
    final dmy = Formats(english, order: DateOrder.dmy);
    expect(dmy.month(dec24), 'Dec 2025');
    expect(Formats(english, order: DateOrder.ymd).month(dec24), '2025 Dec');
    expect(dmy.year(dec24), '2025');
    expect(dmy.taken(dec24), '24 Dec 2025 4:03\u202fPM', reason: 'time stays');
    expect(dmy.taken(dec24, 'day'), '24 Dec 2025');
    expect(dmy.firstDayOfWeek, DateTime.sunday, reason: 'week stays');
    expect(dmy.number(1234567.5), '1,234,567.5');
  });

  test('a date order is stored by name, and one this build lacks reads as the '
      'language default', () {
    for (final order in DateOrder.values) {
      expect(DateOrder.named(order.name), order);
    }
    expect(DateOrder.named('iso'), DateOrder.languageDefault);
    expect(DateOrder.named(null), DateOrder.languageDefault);
    expect(DateOrder.named(3), DateOrder.languageDefault);
  });

  test("a video's length is m:ss, or h:mm:ss, to the nearest second", () {
    final length = Formats(english).duration;
    expect(length(const Duration(milliseconds: 2008)), '0:02');
    expect(length(const Duration(minutes: 1, seconds: 5)), '1:05');
    expect(
      length(const Duration(hours: 2, seconds: 59, milliseconds: 600)),
      '2:01:00',
    );
  });

  test('file sizes use powers of 1000 and at most one decimal', () {
    final size = Formats(english).fileSize;
    expect(size(0), '0 B');
    expect(size(999), '999 B');
    expect(size(1000), '1 kB');
    expect(size(1500000), '1.5 MB');
    expect(size(999949), '999.9 kB');
    expect(size(999950), '1 MB');
    expect(size(3210000000000), '3.2 TB');
    expect(size(5000000000000000), '5,000 TB');
  });

  test('a translation formats the number and names the unit', () async {
    final pseudo = await AppLocalizations.delegate.load(
      const Locale('en', 'XA'),
    );
    expect(Formats(pseudo).fileSize(1500000), '[1.5 ṀƁ one]');
  });
}
