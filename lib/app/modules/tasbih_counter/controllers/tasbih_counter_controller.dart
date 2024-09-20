import 'package:carousel_slider/carousel_controller.dart';
import 'package:get/get.dart';
import 'package:quran_pak/app/data/local_data/tasbih.dart';

class TasbihCounterController extends GetxController {
  CarouselSliderController carouselController = CarouselSliderController();

  int index = Get.arguments?["index"] ?? 0;

  List<Tasbih> tasbihData = TasbihData.tasbihs;

  final count = 0.obs;

  int selectedTargetIndex = 0;
  List<int> targets = [33, 99, 100, 1000];
  int get selectedTarget => targets[selectedTargetIndex];

  onPrevious() {
    carouselController.previousPage();
  }

  onNext() {
    carouselController.nextPage();
  }

  onTargetChange() {
    if (count.value > 0) resetCount();

    if (selectedTargetIndex >= 3) {
      selectedTargetIndex = 0;
    } else {
      selectedTargetIndex++;
    }
    update();
  }

  resetCount() => {count.value = 0, update()};

  void increment() {
    if (count.value < selectedTarget) count.value++;
    update();
  }

  @override
  void onInit() {
    print(index);
    super.onInit();
  }

  @override
  void onReady() {
    carouselController.jumpToPage(index);

    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
