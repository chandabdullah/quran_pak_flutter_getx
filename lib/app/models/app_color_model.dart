AppColorModel appColorModelFromJson(Map<String, dynamic> str) =>
    AppColorModel.fromJson((str));

Map<String, dynamic> appColorModelToJson(AppColorModel data) => (data.toJson());

class AppColorModel {
  List<AppColor> colors;

  AppColorModel({
    required this.colors,
  });

  factory AppColorModel.fromJson(Map<String, dynamic> json) => AppColorModel(
        colors: json["colors"] == null
            ? []
            : List<AppColor>.from(
                json["colors"]!.map((x) => AppColor.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "colors": List<dynamic>.from(colors.map((x) => x.toJson())),
      };
}

class AppColor {
  int id;
  String name;
  String hexCode;

  AppColor({
    required this.id,
    required this.name,
    required this.hexCode,
  });

  factory AppColor.fromJson(Map<String, dynamic> json) => AppColor(
        id: json["id"],
        name: json["name"],
        hexCode: json["hexCode"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "hexCode": hexCode,
      };
}
