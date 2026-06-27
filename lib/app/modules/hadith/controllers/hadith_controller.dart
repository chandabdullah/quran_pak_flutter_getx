import 'package:get/get.dart';
import 'package:quran_pak/app/services/api_call_status.dart';
import 'package:quran_pak/app/services/hadith_service.dart';

class HadithController extends GetxController {
  List<HadithBook> books = [];
  ApiCallStatus status = ApiCallStatus.loading;

  @override
  void onInit() {
    super.onInit();
    loadBooks();
  }

  Future<void> loadBooks() async {
    status = ApiCallStatus.loading;
    update();
    try {
      books = await HadithService.getBooks();
      status = ApiCallStatus.success;
    } catch (_) {
      status = ApiCallStatus.error;
    }
    update();
  }
}
