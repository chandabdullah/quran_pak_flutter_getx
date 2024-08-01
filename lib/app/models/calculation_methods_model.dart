import 'package:adhan/adhan.dart' as adhan;

CalculationMethodsModel calculationMethodsModelFromJson(
        Map<String, dynamic> str) =>
    CalculationMethodsModel.fromJson((str));

Map<String, dynamic> calculationMethodsModelToJson(
        CalculationMethodsModel data) =>
    (data.toJson());

class CalculationMethodsModel {
  CalculationMethodsModel({
    required this.calculationMethods,
  });

  List<CalculationMethod> calculationMethods;

  factory CalculationMethodsModel.fromJson(Map<String, dynamic> json) =>
      CalculationMethodsModel(
        calculationMethods: json["calculationMethods"] == null
            ? []
            : List<CalculationMethod>.from(json["calculationMethods"]!
                .map((x) => CalculationMethod.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "calculationMethods": calculationMethods == null
            ? []
            : List<dynamic>.from(calculationMethods.map((x) => x.toJson())),
      };
}

class CalculationMethod {
  CalculationMethod({
    required this.id,
    required this.name,
    this.params,
    this.location,
    required this.method,
  });

  int id;
  String name;
  Params? params;
  Location? location;
  adhan.CalculationMethod method;

  factory CalculationMethod.fromJson(Map<String, dynamic> json) =>
      CalculationMethod(
        id: json["id"],
        name: json["name"],
        params: json["params"] == null ? null : Params.fromJson(json["params"]),
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
        method: json["method"] == null ? null : json['method'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "params": params?.toJson(),
        "location": location?.toJson(),
        "method": method,
      };
}

class Location {
  Location({
    this.latitude,
    this.longitude,
  });

  double? latitude;
  double? longitude;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
      };
}

class Params {
  Params({
    this.fajr,
    this.isha,
    this.maghrib,
    this.midnight,
    this.shafaq,
  });

  double? fajr;
  double? isha;
  double? maghrib;
  String? midnight;
  String? shafaq;

  factory Params.fromJson(Map<String, dynamic> json) => Params(
        fajr: json["Fajr"]?.toDouble(),
        isha: json["Isha"]?.toDouble(),
        maghrib: json["Maghrib"]?.toDouble(),
        midnight: json["Midnight"],
        shafaq: json["shafaq"],
      );

  Map<String, dynamic> toJson() => {
        "Fajr": fajr,
        "Isha": isha,
        "Maghrib": maghrib,
        "Midnight": midnight,
        "shafaq": shafaq,
      };
}
