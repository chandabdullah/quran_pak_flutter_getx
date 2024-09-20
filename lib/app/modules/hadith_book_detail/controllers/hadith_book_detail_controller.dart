import 'package:get/get.dart';
import 'package:hadith/classes.dart';
import 'package:hadith/hadith.dart';

class HadithBookDetailController extends GetxController {
  Collection collection = getCollection(Collections.abudawud);

  @override
  void onInit() {
    print(Get.arguments);

    switch (Get.arguments) {
      case 'abudawud':
        break;
      default:
    }
    Collections collect = Collections.abudawud;

    // collection = getCollection();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
