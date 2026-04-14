import '../database/database.dart';

/// Bundled sample: Al-Fatihah (Surah 1) Arabic + English (Saheeh International).
/// Replace by importing full data from tanzil.net.
const sampleAyahs = <AyahSeed>[
  AyahSeed(surahNumber: 1, ayahNumber: 1, textArabic: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ'),
  AyahSeed(surahNumber: 1, ayahNumber: 2, textArabic: 'ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَٰلَمِينَ'),
  AyahSeed(surahNumber: 1, ayahNumber: 3, textArabic: 'ٱلرَّحْمَٰنِ ٱلرَّحِيمِ'),
  AyahSeed(surahNumber: 1, ayahNumber: 4, textArabic: 'مَٰلِكِ يَوْمِ ٱلدِّينِ'),
  AyahSeed(surahNumber: 1, ayahNumber: 5, textArabic: 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ'),
  AyahSeed(surahNumber: 1, ayahNumber: 6, textArabic: 'ٱهْدِنَا ٱلصِّرَٰطَ ٱلْمُسْتَقِيمَ'),
  AyahSeed(surahNumber: 1, ayahNumber: 7, textArabic: 'صِرَٰطَ ٱلَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ ٱلْمَغْضُوبِ عَلَيْهِمْ وَلَا ٱلضَّآلِّينَ'),
];

const sampleTranslations = <TranslationSeed>[
  TranslationSeed(surahNumber: 1, ayahNumber: 1, language: 'en', translator: 'Saheeh International', text: 'In the name of Allah, the Entirely Merciful, the Especially Merciful.'),
  TranslationSeed(surahNumber: 1, ayahNumber: 2, language: 'en', translator: 'Saheeh International', text: '[All] praise is [due] to Allah, Lord of the worlds —'),
  TranslationSeed(surahNumber: 1, ayahNumber: 3, language: 'en', translator: 'Saheeh International', text: 'The Entirely Merciful, the Especially Merciful,'),
  TranslationSeed(surahNumber: 1, ayahNumber: 4, language: 'en', translator: 'Saheeh International', text: 'Sovereign of the Day of Recompense.'),
  TranslationSeed(surahNumber: 1, ayahNumber: 5, language: 'en', translator: 'Saheeh International', text: 'It is You we worship and You we ask for help.'),
  TranslationSeed(surahNumber: 1, ayahNumber: 6, language: 'en', translator: 'Saheeh International', text: 'Guide us to the straight path —'),
  TranslationSeed(surahNumber: 1, ayahNumber: 7, language: 'en', translator: 'Saheeh International', text: 'The path of those upon whom You have bestowed favor, not of those who have evoked [Your] anger or of those who are astray.'),
];
