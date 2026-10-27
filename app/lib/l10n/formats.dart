import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'app_localizations.dart';

/// [path] laid out left to right, as paths are, inside right-to-left text.
String isolated(String path) => '\u2066$path\u2069';

/// How dates are ordered, whatever the language (ADR-0400): the language's own
/// way, or day-month-year, month-day-year or year-month-day, always with the
/// month names of the app's language.
enum DateOrder {
  /// The order of the app's language.
  languageDefault(null),

  /// Day, month, year.
  dmy(('d MMM y', 'MMM y')),

  /// Month, day, year.
  mdy(('MMM d, y', 'MMM y')),

  /// Year, month, day.
  ymd(('y MMM d', 'y MMM'));

  new(this._patterns);

  /// The day and the month patterns, or null for the language's own.
  final (String, String)? _patterns;

  /// The order stored as [name]; any other value reads as the language's own.
  static DateOrder named(Object? name) =>
      values.asNameMap()[name] ?? languageDefault;
}

/// Dates, numbers and file sizes in the user's locale (docs/17 §1). Dates and
/// the first day of the week may follow another locale than the language, such
/// as `en_GB` in an English app, for day-month-year dates; `order` sets how
/// dates are laid out, in the language's month names.
class Formats {
  new(
    this.strings, {
    String? dateLocale,
    DateOrder order = DateOrder.languageDefault,
  }) : _dates = _day(order, dateLocale ?? strings.localeName),
       _months =
           _pattern(order._patterns?.$2, dateLocale ?? strings.localeName) ??
           DateFormat.yMMM(dateLocale ?? strings.localeName),
       _years = DateFormat.y(dateLocale ?? strings.localeName),
       _times = _day(order, dateLocale ?? strings.localeName).add_jm();

  /// The formats of the app's language, with the order Settings chose.
  factory Formats.of(BuildContext context) =>
      Formats(AppLocalizations.of(context), order: DateOrderScope.of(context));

  static DateFormat _day(DateOrder order, String locale) =>
      _pattern(order._patterns?.$1, locale) ?? DateFormat.yMMMd(locale);

  static DateFormat? _pattern(String? pattern, String locale) =>
      pattern == null ? null : DateFormat(pattern, locale);

  /// The strings of the language the formats follow.
  final AppLocalizations strings;
  final DateFormat _dates;
  final DateFormat _months;
  final DateFormat _years;
  final DateFormat _times;

  String date(DateTime when) => _dates.format(when);
  String month(DateTime when) => _months.format(when);
  String year(DateTime when) => _years.format(when);

  /// A capture time as far as its [precision] goes: `year`, `month`, `day`,
  /// else to the minute.
  String taken(DateTime when, [String? precision]) => switch (precision) {
    'year' => year(when),
    'month' => month(when),
    'day' => date(when),
    _ => _times.format(when),
  };

  String number(num value) =>
      NumberFormat.decimalPattern(strings.localeName).format(value);

  String percent(int value) =>
      NumberFormat.percentPattern(strings.localeName).format(value / 100);

  /// Latitude and longitude to five decimals, about a metre.
  String place(double lat, double lon) {
    final degrees = NumberFormat('0.00000', strings.localeName);
    return '${degrees.format(lat)}, ${degrees.format(lon)}';
  }

  /// A video's length as m:ss, or h:mm:ss, to the nearest second.
  String duration(Duration length) {
    final s = (length.inMilliseconds / 1000).round();
    final two = NumberFormat('00', strings.localeName);
    final (h, m) = (s ~/ 3600, s ~/ 60 % 60);
    return [
      if (h > 0) number(h),
      if (h > 0) two.format(m) else number(m),
      two.format(s % 60),
    ].join(':');
  }

  String fileSize(int bytes) {
    const units = ['B', 'kB', 'MB', 'GB', 'TB'];
    var size = bytes.toDouble();
    var unit = 0;
    while (unit < units.length - 1 && (size * 10).round() >= 10000) {
      size /= 1000;
      unit++;
    }
    return strings.fileSize((size * 10).round() / 10, units[unit]);
  }

  /// [DateTime.monday] to [DateTime.sunday].
  int get firstDayOfWeek => _years.dateSymbols.FIRSTDAYOFWEEK + 1;
}

/// The [DateOrder] Settings chose, for [Formats.of] below it.
class DateOrderScope extends InheritedWidget {
  /// Tells what is below it to lay dates out as [order] says.
  const new({required this.order, required super.child, super.key});

  /// The order Settings chose.
  final DateOrder order;

  /// The order in effect at [context]; the language's own without a scope.
  static DateOrder of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DateOrderScope>()?.order ??
      DateOrder.languageDefault;

  @override
  bool updateShouldNotify(DateOrderScope old) => order != old.order;
}
