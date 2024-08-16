import '/app/data/local_data/midnight_methods.dart';

MidnightMethodModel midnightMethodModelFromJson(Map<String, dynamic> str) =>
    MidnightMethodModel.fromJson((str));

Map<String, dynamic> midnightMethodModelToJson(MidnightMethodModel data) =>
    (data.toJson());

class MidnightMethodModel {
  List<MidnightMethod> midnightMethods;

  MidnightMethodModel({
    required this.midnightMethods,
  });

  factory MidnightMethodModel.fromJson(Map<String, dynamic> json) =>
      MidnightMethodModel(
        midnightMethods: List<MidnightMethod>.from(
            json["midnightMethods"].map((x) => MidnightMethod.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "midnightMethods":
            List<dynamic>.from(midnightMethods.map((x) => x.toJson())),
      };
}

class MidnightMethod {
  int id;
  String name;
  MidnightMode method;

  MidnightMethod({
    required this.id,
    required this.name,
    required this.method,
  });

  factory MidnightMethod.fromJson(Map<String, dynamic> json) => MidnightMethod(
        id: json["id"],
        name: json["name"],
        method: json["method"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "method": method,
      };
}
