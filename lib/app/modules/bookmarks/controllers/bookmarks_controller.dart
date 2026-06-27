import 'package:get/get.dart';
import 'package:quran_pak/app/data/local/my_shared_pref.dart';
import 'package:quran_pak/app/routes/app_pages.dart';

class BookmarksController extends GetxController {
  List<QuranBookmark> bookmarks = [];

  @override
  void onInit() {
    super.onInit();
    refreshBookmarks();
  }

  void refreshBookmarks() {
    bookmarks = MyBookmark.getBookmarks();
    update();
  }

  /// Opens the surah at the bookmarked verse (auto-scrolls there).
  void openBookmark(QuranBookmark bookmark) {
    Get.toNamed(
      Routes.SURAH_DETAIL,
      arguments: {"surah": bookmark.surah, "verse": bookmark.verse},
    );
  }

  void remove(QuranBookmark bookmark) {
    MyBookmark.removeBookmark(bookmark.surah, bookmark.verse);
    refreshBookmarks();
  }
}
