import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quran_pak/app/data/local/my_shared_pref.dart';
import 'package:quran_pak/app/routes/app_pages.dart';
import 'package:quran_pak/app/services/dua_service.dart';

class BookmarksController extends GetxController {
  final GetStorage _box = GetStorage();

  List<QuranBookmark> savedVerses = [];
  List<Dua> savedDuas = [];

  /// 0 = favourite verses, 1 = favourite duas.
  int segment = 0;

  @override
  void onInit() {
    super.onInit();
    refreshBookmarks();
  }

  void setSegment(int value) {
    segment = value;
    update();
  }

  Future<void> refreshBookmarks() async {
    savedVerses = MyBookmark.getSavedVerses();

    final savedIds =
        (_box.read('saved_duas') as List?)?.map((e) => e as int).toSet() ?? {};
    if (savedIds.isNotEmpty) {
      final all = await DuaService.getDuas();
      savedDuas = all.where((d) => savedIds.contains(d.id)).toList();
    } else {
      savedDuas = [];
    }
    update();
  }

  /// Opens a surah at the given verse (auto-scrolls there).
  void open(int surah, int verse) {
    Get.toNamed(
      Routes.SURAH_DETAIL,
      arguments: {"surah": surah, "verse": verse},
    );
  }

  void removeVerse(QuranBookmark bookmark) {
    MyBookmark.removeSavedVerse(bookmark.surah, bookmark.verse);
    refreshBookmarks();
  }

  void removeDua(int id) {
    final ids =
        (_box.read('saved_duas') as List?)?.map((e) => e as int).toList() ?? [];
    ids.remove(id);
    _box.write('saved_duas', ids);
    refreshBookmarks();
  }
}
