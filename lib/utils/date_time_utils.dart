import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

String timeLeft(DateTime currentDate, DateTime nextDate) {
  Duration difference = nextDate.difference(currentDate);

  int hours = difference.inHours;
  int minutes = difference.inMinutes.remainder(60);

  String hoursPart = hours > 0 ? '$hours hour${hours > 1 ? 's' : ''} ' : '';
  String minutesPart = minutes > 0 ? '$minutes min' : '';

  return '$hoursPart$minutesPart left';
}

extension DateFormatExtension on DateTime? {
  String toLocalDateFormat() {
    if (this == null) return '';

    bool is24Format = false;
    String format = is24Format ? 'HH:mm' : 'hh:mm a';
    return DateFormat(format).format(this!.toLocal());
  }
}

extension AdjustHijriDate on DateTime {
  HijriCalendar adjustHijriDateFunction() {
    HijriCalendar adjustedHijriDate = HijriCalendar.fromDate(
      add(
        const Duration(
          days: -1,
          // days: MyHijriAdjustment.getHijriAdjustment(),
        ),
      ),
    );
    return adjustedHijriDate;
  }
}

extension AdjustGregorianDate on DateTime {
  DateTime adjustGregorianDateFunction() {
    DateTime adjustedGregorianDate = add(
      const Duration(
        days: -1,
        // days: MyHijriAdjustment.getHijriAdjustment(),
      ),
    );

    return adjustedGregorianDate;
  }
}

extension DateTimeExtensions on DateTime {
  bool isToday() {
    DateTime now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
}
