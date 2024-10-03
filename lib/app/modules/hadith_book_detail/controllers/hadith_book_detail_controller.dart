import 'package:get/get.dart';
import 'package:hadith/classes.dart';
import 'package:hadith/hadith.dart';

class HadithBookDetailController extends GetxController {
  // Collection collection = getCollection(Collections.bukhari);

  String name = Get.arguments["name"];
  String engName = Get.arguments["engName"];
  String arName = Get.arguments["arName"];

  @override
  void onInit() {
    print(Get.arguments);

    switch (name) {
      case 'abudawud':
        break;
      default:
    }

    List<Book> books = getBooks(Collections.bukhari);
    Book book = books.first;
    print(book.hadithEndNumber);
    print(book.book.first.name);
    // Book book = getBook(Collections.bukhari, 1);

    Hadith hadith = getHadith(Collections.bukhari, 1, 1);
    print(hadith.hadith.first.chapterTitle);
    // collection = getCollection();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
