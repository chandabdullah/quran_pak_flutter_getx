import 'package:get/get.dart';
import 'package:quran_pak/app/data/local/my_shared_pref.dart';
import 'package:quran_pak/app/routes/app_pages.dart';

class BookmarksController extends GetxController {
  List<QuranBookmark> savedVerses = [];
  ContinueMark? continueMark;

  @override
  void onInit() {
    super.onInit();
    refreshBookmarks();
  }

  void refreshBookmarks() {
    savedVerses = MyBookmark.getSavedVerses();
    continueMark = MyBookmark.getContinue();
    update();
  }

  /// Opens a surah at the given verse (auto-scrolls there).
  void open(int surah, int verse) {
    Get.toNamed(
      Routes.SURAH_DETAIL,
      arguments: {"surah": surah, "verse": verse},
    );
  }

  void remove(QuranBookmark bookmark) {
    MyBookmark.removeSavedVerse(bookmark.surah, bookmark.verse);
    refreshBookmarks();
  }
}
