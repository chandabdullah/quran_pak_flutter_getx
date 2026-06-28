import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:quran_pak/app/services/api_call_status.dart';
import 'package:quran_pak/app/services/hadith_service.dart';

class HadithSearchController extends GetxController {
  final TextEditingController searchController = TextEditingController();

  String query = "";
  HadithSearchMode searchMode = HadithSearchMode.topic;
  // `holding` = idle/no query yet.
  ApiCallStatus status = ApiCallStatus.holding;
  List<HadithSearchResult> results = [];

  Timer? _debounce;
  int _searchToken = 0;

  void setMode(HadithSearchMode mode) {
    if (searchMode == mode) return;
    searchMode = mode;
    update();
    if (query.trim().isNotEmpty) onSearch(query);
  }

  /// Global search across all six collections: by hadith number, book/section
  /// name, or any word/topic in the Arabic, Urdu or English text.
  void onSearch(String value) {
    query = value;
    _debounce?.cancel();

    if (value.trim().isEmpty) {
      results = [];
      status = ApiCallStatus.holding;
      update();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final token = ++_searchToken;
      status = ApiCallStatus.loading;
      update();

      final found = await HadithService.searchAll(value, mode: searchMode);
      // Drop stale results if a newer search has started.
      if (token != _searchToken) return;

      results = found;
      status = found.isEmpty ? ApiCallStatus.empty : ApiCallStatus.success;
      update();
    });
  }

  void clearSearch() {
    searchController.clear();
    onSearch("");
  }

  @override
  void onClose() {
    _debounce?.cancel();
    searchController.dispose();
    super.onClose();
  }
}
