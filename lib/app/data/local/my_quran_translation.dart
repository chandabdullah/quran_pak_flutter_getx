part of 'my_shared_pref.dart';

class MyQuranTranslation {
  static final GetStorage _storage = GetStorage();

  static const String _showQuranTranslationKey = 'show_quran_translation';
  static const String _quranLanguageKey = 'quran_language';

  static const QuranLanguage _defaultLanguage = QuranLanguage.urdu;

  static bool getShowQuranTranslation() {
    var showQuranTranslation = _storage.read(_showQuranTranslationKey);
    if (showQuranTranslation == null) return true;
    return showQuranTranslation;
  }

  static saveShowQuranTranslation(bool showQuranTranslation) {
    _storage.write(_showQuranTranslationKey, showQuranTranslation);
  }

  static QuranLanguage getTranslationLanguage() {
    var translationLanguage = _storage.read(_quranLanguageKey);
    QuranLanguage? quranLanguage = quranLanguageValues.map[translationLanguage];
    if (translationLanguage == null || quranLanguage == null) {
      return _defaultLanguage;
    }
    print("quranLanguage: ${quranLanguage.name}");
    return quranLanguage;
  }

  static saveTranslationLanguage(QuranLanguage? quranLanguage) {
    String? language = quranLanguageValues.reverse[quranLanguage];
    _storage.write(_quranLanguageKey, language);
  }
}

final quranLanguageValues = EnumValues({
  "albanian": QuranLanguage.albanian,
  "amazigh": QuranLanguage.amazigh,
  "amharic": QuranLanguage.amharic,
  "azerbaijani": QuranLanguage.azerbaijani,
  "bengali": QuranLanguage.bengali,
  "bosnian": QuranLanguage.bosnian,
  "bulgarian": QuranLanguage.bulgarian,
  "chinese": QuranLanguage.chinese,
  "czech": QuranLanguage.czech,
  "divehi": QuranLanguage.divehi,
  "dutch": QuranLanguage.dutch,
  "english": QuranLanguage.english,
  "french": QuranLanguage.french,
  "german": QuranLanguage.german,
  "hausa": QuranLanguage.hausa,
  "hindi": QuranLanguage.hindi,
  "indonesian": QuranLanguage.indonesian,
  "italian": QuranLanguage.italian,
  "japanese": QuranLanguage.japanese,
  "korean": QuranLanguage.korean,
  "kurdish": QuranLanguage.kurdish,
  "malay": QuranLanguage.malay,
  "malayalam": QuranLanguage.malayalam,
  "norwegian": QuranLanguage.norwegian,
  "pashto": QuranLanguage.pashto,
  "persian": QuranLanguage.persian,
  "polish": QuranLanguage.polish,
  "portuguese": QuranLanguage.portuguese,
  "romanian": QuranLanguage.romanian,
  "russian": QuranLanguage.russian,
  "sindhi": QuranLanguage.sindhi,
  "somali": QuranLanguage.somali,
  "spanish": QuranLanguage.spanish,
  "swahili": QuranLanguage.swahili,
  "swedish": QuranLanguage.swedish,
  "tajik": QuranLanguage.tajik,
  "tamil": QuranLanguage.tamil,
  "tatar": QuranLanguage.tatar,
  "thai": QuranLanguage.thai,
  "turkish": QuranLanguage.turkish,
  "urdu": QuranLanguage.urdu,
  "uyghur": QuranLanguage.uyghur,
  "uzbek": QuranLanguage.uzbek,
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
