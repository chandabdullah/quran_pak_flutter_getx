import '/config/theme/dark_theme_colors.dart';
import '/config/theme/light_theme_colors.dart';
import '/utils/color_utils.dart';

const int defaultAppColorId = 1;

Map<String, List> lightColors = {
  "colors": [
    {
      "id": 1,
      "name": "Default",
      "hexCode": LightThemeColors.primaryColor().colorToHex()
    },
    {"id": 2, "name": "Aquamarine", "hexCode": "7FFFD4"},
    {"id": 3, "name": "Bright Pink", "hexCode": "FF69B4"},
    {"id": 4, "name": "Bright Green", "hexCode": "32CD32"},
    {"id": 5, "name": "Dodger Blue", "hexCode": "1E90FF"},
    {"id": 6, "name": "Tomato", "hexCode": "FF6347"},
    {"id": 7, "name": "Goldenrod", "hexCode": "DAA520"}
  ],
};

Map<String, List> darkColors = {
  "colors": [
    {
      "id": 1,
      "name": "Default",
      "hexCode": DarkThemeColors.primaryColor().colorToHex()
    },
    {"id": 2, "name": "Aquamarine", "hexCode": "3B6F69"},
    {"id": 3, "name": "Bright Pink", "hexCode": "8B3A62"},
    {"id": 4, "name": "Bright Green", "hexCode": "006400"},
    {"id": 5, "name": "Dodger Blue", "hexCode": "104E8B"},
    {"id": 6, "name": "Tomato", "hexCode": "8B3626"},
    {"id": 7, "name": "Goldenrod", "hexCode": "8B6914"}
  ],
};
