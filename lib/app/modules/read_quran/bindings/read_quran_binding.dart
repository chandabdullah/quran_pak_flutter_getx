import 'package:get/get.dart';

import '../controllers/read_quran_controller.dart';

class ReadQuranBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReadQuranController>(
      () => ReadQuranController(),
    );
  }
}
