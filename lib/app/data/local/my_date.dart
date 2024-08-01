part of 'my_shared_pref.dart';

class MyDateTime {
  static final GetStorage _storage = GetStorage();

  static const String _my_date_key = 'my_date';

  static saveDateTime(DateTime dateTime) {
    _storage.write(_my_date_key, dateTime.toIso8601String());
  }

  static DateTime? getDateTime() {
    var dateTime = _storage.read(_my_date_key);
    if (dateTime == null) return null;
    DateTime parsedDateTime = DateTime.parse(dateTime);
    return parsedDateTime;
  }
}
