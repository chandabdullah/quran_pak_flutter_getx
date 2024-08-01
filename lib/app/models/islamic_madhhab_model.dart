import 'package:adhan/adhan.dart';

IslamicMadhabModel islamicMadhabModelFromJson(Map<String, dynamic> str) =>
    IslamicMadhabModel.fromJson((str));

Map<String, dynamic> islamicMadhabModelToJson(IslamicMadhabModel data) =>
    (data.toJson());

class IslamicMadhabModel {
  List<IslamicMadhab> islamicMadhab;

  IslamicMadhabModel({
    required this.islamicMadhab,
  });

  factory IslamicMadhabModel.fromJson(Map<String, dynamic> json) =>
      IslamicMadhabModel(
        islamicMadhab: json["islamicMadhab"] == null
            ? []
            : List<IslamicMadhab>.from(
                json["islamicMadhab"]!.map((x) => IslamicMadhab.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "islamicMadhab": islamicMadhab == null
            ? []
            : List<dynamic>.from(islamicMadhab.map((x) => x.toJson())),
      };
}

class IslamicMadhab {
  int id;
  String name;
  Madhab value;

  IslamicMadhab({
    required this.id,
    required this.name,
    required this.value,
  });

  factory IslamicMadhab.fromJson(Map<String, dynamic> json) => IslamicMadhab(
        id: json["id"],
        name: json["name"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "value": value,
      };
}
