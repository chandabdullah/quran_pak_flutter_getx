part of 'my_shared_pref.dart';

class MyCoordinates {
  static final GetStorage _storage = GetStorage();

  static const String _key_lat = 'my_lat';
  static const String _key_lng = 'my_lng';

  static saveCoordinates(adhan.Coordinates coordinates) {
    _storage.write(_key_lat, coordinates.latitude);
    _storage.write(_key_lng, coordinates.longitude);
  }

  static adhan.Coordinates? getCoordinates() {
    var latitude = _storage.read(_key_lat);
    var longitude = _storage.read(_key_lng);

    if (latitude == null || longitude == null) return null;

    adhan.Coordinates coordinates = adhan.Coordinates(latitude, longitude);
    return coordinates;
  }
}
