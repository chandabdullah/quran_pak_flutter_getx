import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:quran_pak/app/services/api_call_status.dart';
import 'package:quran_pak/app/services/hadith_service.dart';

class HadithBookDetailController extends GetxController {
  final String bookId = (Get.arguments?["book"] ?? "bukhari").toString();

  ApiCallStatus status = ApiCallStatus.loading;
  HadithCollection? collection;
  List<HadithItem> filtered = [];
  String query = "";

  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    status = ApiCallStatus.loading;
    update();
    try {
      collection = await HadithService.loadCollection(bookId);
      filtered = collection!.hadiths;
      status = filtered.isEmpty ? ApiCallStatus.empty : ApiCallStatus.success;
    } catch (_) {
      status = ApiCallStatus.error;
    }
    update();
  }

  /// In-book search: by hadith number, section/book name, or any word/topic.
  void onSearch(String value) {
    query = value;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      if (collection == null) return;
      filtered = HadithService.searchInCollection(collection!, value);
      status = filtered.isEmpty ? ApiCallStatus.empty : ApiCallStatus.success;
      update();
    });
  }

  void clearSearch() {
    searchController.clear();
    onSearch("");
  }

  String sectionNameFor(HadithItem h) =>
      collection?.sectionName(h.sectionNumber) ?? "";

  @override
  void onClose() {
    _debounce?.cancel();
    searchController.dispose();
    super.onClose();
  }
}
