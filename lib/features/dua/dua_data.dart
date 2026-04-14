class Dua {
  final String title;
  final String arabic;
  final String transliteration;
  final String translation;
  final String? source;
  const Dua({
    required this.title,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    this.source,
  });
}

class DuaCategory {
  final String name;
  final List<Dua> duas;
  const DuaCategory({required this.name, required this.duas});
}

const duaCategories = <DuaCategory>[
  DuaCategory(
    name: 'Morning & Evening',
    duas: [
      Dua(
        title: 'Morning remembrance',
        arabic:
            'أَصْبَحْنَا وَأَصْبَحَ ٱلْمُلْكُ لِلَّٰهِ، وَٱلْحَمْدُ لِلَّٰهِ',
        transliteration:
            'Asbahna wa asbahal-mulku lillah, wal-hamdu lillah',
        translation:
            'We have entered the morning and the dominion belongs to Allah, all praise is due to Allah.',
        source: 'Muslim',
      ),
      Dua(
        title: 'Evening remembrance',
        arabic: 'أَمْسَيْنَا وَأَمْسَى ٱلْمُلْكُ لِلَّٰهِ، وَٱلْحَمْدُ لِلَّٰهِ',
        transliteration:
            'Amsayna wa amsal-mulku lillah, wal-hamdu lillah',
        translation:
            'We have entered the evening and the dominion belongs to Allah, all praise is due to Allah.',
        source: 'Muslim',
      ),
    ],
  ),
  DuaCategory(
    name: 'After Prayer',
    duas: [
      Dua(
        title: 'Astaghfirullah (3x)',
        arabic: 'أَسْتَغْفِرُ ٱللَّٰه',
        transliteration: 'Astaghfirullah',
        translation: 'I seek the forgiveness of Allah.',
        source: 'Muslim',
      ),
      Dua(
        title: 'Allahumma antas-Salam',
        arabic:
            'ٱللَّٰهُمَّ أَنْتَ ٱلسَّلَامُ، وَمِنْكَ ٱلسَّلَامُ، تَبَارَكْتَ يَا ذَا ٱلْجَلَالِ وَٱلْإِكْرَام',
        transliteration:
            'Allahumma antas-Salam, wa minkas-Salam, tabarakta ya Dhal-Jalali wal-Ikram',
        translation:
            'O Allah, You are Peace and from You comes peace. Blessed are You, O Possessor of Majesty and Honour.',
        source: 'Muslim',
      ),
    ],
  ),
  DuaCategory(
    name: 'Before Sleep',
    duas: [
      Dua(
        title: 'Bismika Allahumma',
        arabic: 'بِٱسْمِكَ ٱللَّٰهُمَّ أَمُوتُ وَأَحْيَا',
        transliteration: 'Bismika Allahumma amutu wa ahya',
        translation: 'In Your name O Allah, I die and I live.',
        source: 'Bukhari',
      ),
    ],
  ),
  DuaCategory(
    name: 'Eating',
    duas: [
      Dua(
        title: 'Before eating',
        arabic: 'بِسْمِ ٱللَّٰه',
        transliteration: 'Bismillah',
        translation: 'In the name of Allah.',
        source: 'Tirmidhi',
      ),
      Dua(
        title: 'After eating',
        arabic:
            'ٱلْحَمْدُ لِلَّٰهِ ٱلَّذِي أَطْعَمَنِي هَٰذَا، وَرَزَقَنِيهِ، مِنْ غَيْرِ حَوْلٍ مِنِّي وَلَا قُوَّة',
        transliteration:
            'Alhamdulillahil-ladhi at`amani hadha, wa razaqanihi, min ghayri hawlin minni wa la quwwah',
        translation:
            'All praise is for Allah who fed me this and provided it for me, without any might or power from myself.',
        source: 'Abu Dawud',
      ),
    ],
  ),
  DuaCategory(
    name: 'Travel',
    duas: [
      Dua(
        title: 'When boarding a vehicle',
        arabic:
            'سُبْحَانَ ٱلَّذِي سَخَّرَ لَنَا هَٰذَا وَمَا كُنَّا لَهُ مُقْرِنِين',
        transliteration:
            'Subhanalladhi sakhkhara lana hadha wa ma kunna lahu muqrinin',
        translation:
            'Glory to Him who has subjected this for us, and we were not capable of doing so.',
        source: 'Quran 43:13',
      ),
    ],
  ),
];
