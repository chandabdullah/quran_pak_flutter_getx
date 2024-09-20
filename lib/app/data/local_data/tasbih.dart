class TasbihData {
  static List<Tasbih> tasbihs = [
    Tasbih(
      arabic: "سبحان الله",
      english: "Subhanallah",
    ),
    Tasbih(
      arabic: "الحمد لله",
      english: "Alhamdulillah",
    ),
    Tasbih(
      arabic: "الله أكبر",
      english: "Allahu Akbar",
    ),
    Tasbih(
      arabic: "أستغفر الله",
      english: "Astagfirullah",
    ),
    Tasbih(
      arabic: "لا إله إلا الله",
      english: "La ilaha illallah",
    ),
    Tasbih(
      arabic: "لا حول ولاقوة إلا بالله",
      english: "La hawla wa la quwata illa billah",
    ),
    Tasbih(
      arabic: "اللهم صل على محمد",
      english: "Allahumma salli 'ala Muhammad",
    ),
    Tasbih(
      arabic: "سبحان الله وبحمده سبحان الله العظيم",
      english: "Subhanallah wa bihamdihi Subhanallah Al-Azeem",
    ),
    Tasbih(
      arabic: "يا حي يا قيوم برحمتك أستغيث",
      english: "Ya Hayyu Ya Qayyum bi rahmatika astagheeth",
    ),
  ];
}

class Tasbih {
  final String arabic;
  final String english;

  Tasbih({
    required this.arabic,
    required this.english,
  });
}
