import 'package:flutter/material.dart';

import 'package:quran_pak/app/components/hadith_card.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:quran_pak/app/services/hadith_service.dart';

/// Full-screen view of a single hadith (opened from a list row).
class HadithDetailPage extends StatelessWidget {
  const HadithDetailPage({
    super.key,
    required this.hadith,
    required this.collectionName,
    this.sectionName,
  });

  final HadithItem hadith;
  final String collectionName;
  final String? sectionName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$collectionName · #${hadith.number}"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(kPadding),
        children: [
          HadithCard(
            hadith: hadith,
            collectionName: collectionName,
            sectionName: sectionName,
          ),
        ],
      ),
    );
  }
}
