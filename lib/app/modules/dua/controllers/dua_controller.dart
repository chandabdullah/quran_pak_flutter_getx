import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quran_pak/app/services/api_call_status.dart';
import 'package:quran_pak/app/services/dua_service.dart';

class DuaController extends GetxController {
  final GetStorage _box = GetStorage();
  static const String _savedKey = 'saved_duas';

  ApiCallStatus status = ApiCallStatus.loading;

  List<DuaCategory> categories = [];
  List<Dua> _all = [];
  List<Dua> filtered = [];

  String query = "";
  String selectedCategory = "all";
  bool showSavedOnly = false;

  final TextEditingController searchController = TextEditingController();

  // --- Saved duas (favourites) ----------------------------------------------

  List<int> get _savedIds =>
      (_box.read(_savedKey) as List?)?.map((e) => e as int).toList() ?? [];

  bool isSaved(int id) => _savedIds.contains(id);

  int get savedCount => _savedIds.length;

  void toggleSaved(int id) {
    final ids = _savedIds;
    if (ids.contains(id)) {
      ids.remove(id);
    } else {
      ids.add(id);
    }
    _box.write(_savedKey, ids);
    _applyFilter();
    update();
  }

  void toggleSavedView() {
    showSavedOnly = !showSavedOnly;
    _applyFilter();
    update();
  }

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    status = ApiCallStatus.loading;
    update();
    try {
      categories = await DuaService.getCategories();
      _all = await DuaService.getDuas();
      _applyFilter();
      status = ApiCallStatus.success;
    } catch (_) {
      status = ApiCallStatus.error;
    }
    update();
  }

  void onSearch(String value) {
    query = value;
    _applyFilter();
    update();
  }

  void selectCategory(String id) {
    selectedCategory = id;
    _applyFilter();
    update();
  }

  void _applyFilter() {
    final q = query.trim().toLowerCase();
    final saved = _savedIds.toSet();
    filtered = _all.where((d) {
      if (showSavedOnly && !saved.contains(d.id)) return false;
      final inCategory =
          selectedCategory == "all" || d.category == selectedCategory;
      // Match by number (id) or by any text.
      final matches = q.isEmpty ||
          d.id.toString() == q ||
          d.searchText.contains(q);
      return inCategory && matches;
    }).toList();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
