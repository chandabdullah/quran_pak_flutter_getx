import 'package:get/get.dart';

import '../controllers/bookmarks_controller.dart';

class BookmarksBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookmarksController>(
      () => BookmarksController(),
    );
  }
}
