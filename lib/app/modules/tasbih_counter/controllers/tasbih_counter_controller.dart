import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quran_pak/app/data/local_data/tasbih.dart';

class TasbihCounterController extends GetxController {
  CarouselSliderController carouselController = CarouselSliderController();
  final GetStorage _box = GetStorage();

  int index = Get.arguments?["index"] ?? 0;

  List<Tasbih> tasbihData = TasbihData.tasbihs;

  int count = 0;
  int rounds = 0; // completed cycles in this session

  int selectedTargetIndex = 0;
  List<int> targets = [33, 99, 100, 1000];
  int get selectedTarget => targets[selectedTargetIndex];

  double get progress => (count / selectedTarget).clamp(0.0, 1.0);

  /// Lifetime total for the current dhikr (persisted across sessions).
  int get lifetimeTotal => _box.read('tasbih_total_$index') ?? 0;
  void _addLifetime(int delta) =>
      _box.write('tasbih_total_$index', lifetimeTotal + delta);

  onPrevious() => carouselController.previousPage();
  onNext() => carouselController.nextPage();

  onTargetChange() {
    selectedTargetIndex = (selectedTargetIndex + 1) % targets.length;
    count = 0;
    update();
  }

  void resetCount() {
    count = 0;
    update();
  }

  void increment() {
    if (count >= selectedTarget) return;
    count++;
    _addLifetime(1);

    if (count >= selectedTarget) {
      // Completed a full cycle — celebrate.
      rounds++;
      HapticFeedback.heavyImpact();
      Get.rawSnackbar(
        message: "Masha'Allah! You completed $selectedTarget.",
        backgroundColor: Get.theme.primaryColor,
        margin: const EdgeInsets.all(16),
        borderRadius: 6,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      HapticFeedback.selectionClick();
    }
    update();
  }

  /// Start a fresh cycle after reaching the target.
  void continueAfterTarget() {
    count = 0;
    update();
  }

  @override
  void onReady() {
    carouselController.jumpToPage(index);
    super.onReady();
  }
}
