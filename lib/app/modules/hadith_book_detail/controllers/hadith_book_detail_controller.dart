import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:quran_pak/app/services/api_call_status.dart';
import 'package:quran_pak/app/services/hadith_service.dart';

class HadithBookDetailController extends GetxController {
  final String bookId = (Get.arguments?["book"] ?? "bukhari").toString();

  ApiCallStatus status = ApiCallStatus.loading;
  HadithCollection? collection;

  /// Full filtered list (search applied). The view only renders [visibleCount]
  /// of these and grows the window as the user scrolls (chunked loading).
  List<HadithItem> _filtered = [];
  static const int _pageSize = 60;
  int visibleCount = _pageSize;

  String query = "";
  HadithSearchMode searchMode = HadithSearchMode.topic;

  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  Timer? _debounce;

  List<HadithItem> get visible =>
      _filtered.take(visibleCount).toList(growable: false);
  bool get hasMore => visibleCount < _filtered.length;
  int get totalFiltered => _filtered.length;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    load();
  }

  Future<void> load() async {
    status = ApiCallStatus.loading;
    update();
    try {
      collection = await HadithService.loadCollection(bookId);
      _filtered = collection!.hadiths;
      visibleCount = _pageSize;
      status = _filtered.isEmpty ? ApiCallStatus.empty : ApiCallStatus.success;
    } catch (_) {
      status = ApiCallStatus.error;
    }
    update();
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    final pos = scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 600 && hasMore) {
      visibleCount = (visibleCount + _pageSize).clamp(0, _filtered.length);
      update();
    }
  }

  void setMode(HadithSearchMode mode) {
    if (searchMode == mode) return;
    searchMode = mode;
    _runSearch(query);
    update();
  }

  void onSearch(String value) {
    query = value;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () => _runSearch(value));
  }

  void _runSearch(String value) {
    if (collection == null) return;
    _filtered =
        HadithService.searchInCollection(collection!, value, mode: searchMode);
    visibleCount = _pageSize;
    status = _filtered.isEmpty ? ApiCallStatus.empty : ApiCallStatus.success;
    if (scrollController.hasClients) scrollController.jumpTo(0);
    update();
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
    scrollController.dispose();
    searchController.dispose();
    super.onClose();
  }
}
