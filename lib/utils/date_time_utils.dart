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
