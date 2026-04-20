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
    name: 'Morning',
    duas: [
      Dua(
        title: 'Morning remembrance',
        arabic:
            'أَصْبَحْنَا وَأَصْبَحَ ٱلْمُلْكُ لِلَّٰهِ، وَٱلْحَمْدُ لِلَّٰهِ، لَا إِلَٰهَ إِلَّا ٱللَّٰهُ وَحْدَهُ لَا شَرِيكَ لَهُ',
        transliteration:
            'Asbahna wa asbahal-mulku lillah, wal-hamdu lillah, la ilaha illallahu wahdahu la shareeka lah',
        translation:
            'We have entered the morning and the dominion belongs to Allah, all praise is due to Allah. There is no god but Allah, alone with no partner.',
        source: 'Muslim',
      ),
      Dua(
        title: 'Ayat-ul-Kursi (Throne Verse, 1x)',
        arabic:
            'ٱللَّهُ لَا إِلَٰهَ إِلَّا هُوَ ٱلْحَيُّ ٱلْقَيُّومُ...',
        transliteration:
            'Allahu la ilaha illa huwal-hayyul-qayyum...',
        translation:
            'Allah — there is no deity except Him, the Ever-Living, the Sustainer of existence. (Quran 2:255)',
        source: 'Quran 2:255',
      ),
      Dua(
        title: 'Sayyid-ul-Istighfar',
        arabic:
            'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَٰهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي، فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ',
        transliteration:
            'Allahumma anta Rabbi la ilaha illa ant, khalaqtani wa ana abduk, wa ana ala ahdika wa wa\'dika mastata\'t, a\'udhu bika min sharri ma sana\'t, abu\'u laka bi ni\'matika alayya, wa abu\'u bi dhanbi faghfir li, fa innahu la yaghfirudh-dhunuba illa ant',
        translation:
            'O Allah, You are my Lord, there is no god but You. You created me and I am Your slave. I keep Your covenant as much as I can. I seek refuge in You from the evil I have done. I acknowledge Your favor upon me, and I acknowledge my sin, so forgive me, for none forgives sins except You.',
        source: 'Bukhari',
      ),
      Dua(
        title: 'Seeking protection (3x)',
        arabic:
            'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ',
        transliteration:
            'Bismillahil-ladhi la yadurru ma\'as-mihi shay\'un fil-ardi wa la fis-sama\', wa huwas-Samee\'ul-Aleem',
        translation:
            'In the name of Allah, with whose name nothing can harm on earth or in heaven, and He is the All-Hearing, All-Knowing.',
        source: 'Abu Dawud, Tirmidhi',
      ),
    ],
  ),
  DuaCategory(
    name: 'Evening',
    duas: [
      Dua(
        title: 'Evening remembrance',
        arabic:
            'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ',
        transliteration:
            'Amsayna wa amsal-mulku lillah, wal-hamdu lillah, la ilaha illallahu wahdahu la shareeka lah',
        translation:
            'We have entered the evening and the dominion belongs to Allah, all praise is due to Allah. There is no god but Allah, alone with no partner.',
        source: 'Muslim',
      ),
      Dua(
        title: 'SubhanAllah wa bihamdihi (100x)',
        arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
        transliteration: 'SubhanAllahi wa bihamdihi',
        translation: 'Glory is to Allah and all praise is His.',
        source: 'Muslim',
      ),
    ],
  ),
  DuaCategory(
    name: 'After Prayer',
    duas: [
      Dua(
        title: 'Astaghfirullah (3x)',
        arabic: 'أَسْتَغْفِرُ اللَّهَ',
        transliteration: 'Astaghfirullah',
        translation: 'I seek the forgiveness of Allah.',
        source: 'Muslim',
      ),
      Dua(
        title: 'Allahumma antas-Salam',
        arabic:
            'اللَّهُمَّ أَنْتَ السَّلَامُ، وَمِنْكَ السَّلَامُ، تَبَارَكْتَ يَا ذَا الْجَلَالِ وَالْإِكْرَامِ',
        transliteration:
            'Allahumma antas-Salam, wa minkas-Salam, tabarakta ya Dhal-Jalali wal-Ikram',
        translation:
            'O Allah, You are Peace and from You comes peace. Blessed are You, O Possessor of Majesty and Honor.',
        source: 'Muslim',
      ),
      Dua(
        title: 'Help in remembrance',
        arabic:
            'اللَّهُمَّ أَعِنِّي عَلَى ذِكْرِكَ، وَشُكْرِكَ، وَحُسْنِ عِبَادَتِكَ',
        transliteration:
            'Allahumma a\'inni ala dhikrika wa shukrika wa husni ibadatik',
        translation:
            'O Allah, help me to remember You, thank You, and worship You in the best manner.',
        source: 'Abu Dawud, Nasa\'i',
      ),
      Dua(
        title: 'Tasbeeh after prayer (33, 33, 34)',
        arabic:
            'سُبْحَانَ اللَّهِ (33) الْحَمْدُ لِلَّهِ (33) اللَّهُ أَكْبَرُ (34)',
        transliteration:
            'SubhanAllah (x33), Alhamdulillah (x33), Allahu Akbar (x34)',
        translation:
            'Glory be to Allah, All praise is for Allah, Allah is the Greatest.',
        source: 'Muslim',
      ),
    ],
  ),
  DuaCategory(
    name: 'Before Sleep',
    duas: [
      Dua(
        title: 'Bismika Allahumma',
        arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
        transliteration: 'Bismika Allahumma amutu wa ahya',
        translation: 'In Your name O Allah, I die and I live.',
        source: 'Bukhari',
      ),
      Dua(
        title: 'Surah Al-Ikhlas + Al-Falaq + An-Nas (3x each)',
        arabic: 'قُلْ هُوَ اللَّهُ أَحَدٌ… / قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ… / قُلْ أَعُوذُ بِرَبِّ النَّاسِ…',
        transliteration:
            'Qul huwa Allahu Ahad... / Qul a\'udhu bi Rabbil-Falaq... / Qul a\'udhu bi Rabbin-Nas...',
        translation:
            'Recite the three Quls, blow into hands and wipe over the body three times.',
        source: 'Bukhari',
      ),
      Dua(
        title: 'When waking up',
        arabic:
            'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
        transliteration:
            'Alhamdulillahil-ladhi ahyana ba\'da ma amatana wa ilayhin-nushur',
        translation:
            'All praise is for Allah who gave us life after taking it, and to Him is the resurrection.',
        source: 'Bukhari',
      ),
    ],
  ),
  DuaCategory(
    name: 'Eating',
    duas: [
      Dua(
        title: 'Before eating',
        arabic: 'بِسْمِ اللَّهِ',
        transliteration: 'Bismillah',
        translation: 'In the name of Allah.',
        source: 'Tirmidhi',
      ),
      Dua(
        title: 'If forgot at start',
        arabic: 'بِسْمِ اللَّهِ فِي أَوَّلِهِ وَآخِرِهِ',
        transliteration: 'Bismillahi fi awwalihi wa akhirih',
        translation: 'In the name of Allah at its beginning and end.',
        source: 'Abu Dawud, Tirmidhi',
      ),
      Dua(
        title: 'After eating',
        arabic:
            'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنِي هَذَا وَرَزَقَنِيهِ، مِنْ غَيْرِ حَوْلٍ مِنِّي وَلَا قُوَّةٍ',
        transliteration:
            'Alhamdulillahil-ladhi at\'amani hadha wa razaqanihi, min ghayri hawlin minni wa la quwwah',
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
            'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُونَ',
        transliteration:
            'Subhanalladhi sakhkhara lana hadha wa ma kunna lahu muqrinin, wa inna ila Rabbina lamunqalibun',
        translation:
            'Glory be to Him who subjected this to us, and we were not capable of this. And surely to our Lord we are returning.',
        source: 'Quran 43:13-14',
      ),
      Dua(
        title: 'Travel supplication',
        arabic:
            'اللَّهُمَّ إِنَّا نَسْأَلُكَ فِي سَفَرِنَا هَذَا الْبِرَّ وَالتَّقْوَى، وَمِنَ الْعَمَلِ مَا تَرْضَى',
        transliteration:
            'Allahumma inna nas\'aluka fi safarina hadhal-birra wat-taqwa, wa minal-amali ma tarda',
        translation:
            'O Allah, we ask You on this journey for righteousness, piety, and deeds that please You.',
        source: 'Muslim',
      ),
      Dua(
        title: 'Entering a town',
        arabic:
            'اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَهَا، وَأَعُوذُ بِكَ مِنْ شَرِّهَا',
        transliteration:
            'Allahumma inni as\'aluka khayraha, wa a\'udhu bika min sharriha',
        translation:
            'O Allah, I ask You for the good of this town, and I seek refuge in You from its evil.',
        source: 'Nasa\'i',
      ),
    ],
  ),
  DuaCategory(
    name: 'Entering & Leaving',
    duas: [
      Dua(
        title: 'Entering home',
        arabic:
            'بِسْمِ اللَّهِ وَلَجْنَا، وَبِسْمِ اللَّهِ خَرَجْنَا، وَعَلَى اللَّهِ رَبِّنَا تَوَكَّلْنَا',
        transliteration:
            'Bismillahi walajna, wa bismillahi kharajna, wa ala-llahi Rabbina tawakkalna',
        translation:
            'In the name of Allah we enter, and in the name of Allah we leave, and upon our Lord we rely.',
        source: 'Abu Dawud',
      ),
      Dua(
        title: 'Leaving home',
        arabic:
            'بِسْمِ اللَّهِ، تَوَكَّلْتُ عَلَى اللَّهِ، وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
        transliteration:
            'Bismillah, tawakkaltu ala-llah, wa la hawla wa la quwwata illa billah',
        translation:
            'In the name of Allah, I place my trust in Allah, and there is no power or might except with Allah.',
        source: 'Abu Dawud, Tirmidhi',
      ),
      Dua(
        title: 'Entering restroom',
        arabic:
            'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُبُثِ وَالْخَبَائِثِ',
        transliteration: 'Allahumma inni a\'udhu bika minal-khubthi wal-khaba\'ith',
        translation:
            'O Allah, I seek refuge in You from male and female evil beings (devils).',
        source: 'Bukhari, Muslim',
      ),
      Dua(
        title: 'Leaving restroom',
        arabic: 'غُفْرَانَكَ',
        transliteration: 'Ghufranak',
        translation: 'I seek Your forgiveness.',
        source: 'Abu Dawud, Tirmidhi',
      ),
      Dua(
        title: 'Entering the mosque',
        arabic: 'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',
        transliteration: 'Allahumma-ftah li abwaba rahmatik',
        translation: 'O Allah, open the gates of Your mercy for me.',
        source: 'Muslim',
      ),
      Dua(
        title: 'Leaving the mosque',
        arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ',
        transliteration: 'Allahumma inni as\'aluka min fadlik',
        translation: 'O Allah, I ask of You Your bounty.',
        source: 'Muslim',
      ),
    ],
  ),
  DuaCategory(
    name: 'Distress & Hardship',
    duas: [
      Dua(
        title: 'Relief from anxiety',
        arabic:
            'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ، وَالْعَجْزِ وَالْكَسَلِ، وَالْبُخْلِ وَالْجُبْنِ، وَضَلَعِ الدَّيْنِ وَغَلَبَةِ الرِّجَالِ',
        transliteration:
            'Allahumma inni a\'udhu bika minal-hammi wal-hazan, wal-ajzi wal-kasal, wal-bukhli wal-jubn, wa dala\'id-dayni wa ghalabatir-rijal',
        translation:
            'O Allah, I seek refuge in You from anxiety and sorrow, weakness and laziness, miserliness and cowardice, the burden of debts and from being overpowered by men.',
        source: 'Bukhari',
      ),
      Dua(
        title: 'In times of difficulty',
        arabic:
            'لَا إِلَهَ إِلَّا اللَّهُ الْعَظِيمُ الْحَلِيمُ، لَا إِلَهَ إِلَّا اللَّهُ رَبُّ الْعَرْشِ الْعَظِيمِ، لَا إِلَهَ إِلَّا اللَّهُ رَبُّ السَّمَاوَاتِ وَرَبُّ الْأَرْضِ وَرَبُّ الْعَرْشِ الْكَرِيمِ',
        transliteration:
            'La ilaha illallahul-Adheemul-Haleem, la ilaha illallahu Rabbul-arshil-adheem, la ilaha illallahu Rabbus-samawati wa Rabbul-ard wa Rabbul-arshil-kareem',
        translation:
            'There is no god but Allah, the Most Great, the Most Forbearing. There is no god but Allah, Lord of the mighty throne. There is no god but Allah, Lord of the heavens and Lord of the earth and Lord of the noble throne.',
        source: 'Bukhari, Muslim',
      ),
      Dua(
        title: 'Hasbunallah',
        arabic: 'حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيلُ',
        transliteration: 'Hasbunallahu wa ni\'mal-wakeel',
        translation: 'Allah is sufficient for us, and He is the best disposer of affairs.',
        source: 'Quran 3:173',
      ),
    ],
  ),
  DuaCategory(
    name: 'Forgiveness',
    duas: [
      Dua(
        title: 'Seeking forgiveness',
        arabic: 'رَبِّ اغْفِرْ لِي وَتُبْ عَلَيَّ، إِنَّكَ أَنْتَ التَّوَّابُ الرَّحِيمُ',
        transliteration:
            'Rabbighfir li wa tub alayya, innaka antat-Tawwabur-Raheem',
        translation:
            'My Lord, forgive me and accept my repentance. Indeed, You are the Accepter of Repentance, the Merciful.',
        source: 'Abu Dawud, Tirmidhi',
      ),
      Dua(
        title: 'Repentance of the prophets',
        arabic:
            'رَبَّنَا ظَلَمْنَا أَنْفُسَنَا وَإِنْ لَمْ تَغْفِرْ لَنَا وَتَرْحَمْنَا لَنَكُونَنَّ مِنَ الْخَاسِرِينَ',
        transliteration:
            'Rabbana zalamna anfusana wa in lam taghfir lana wa tarhamna lanakoonanna minal-khasireen',
        translation:
            'Our Lord, we have wronged ourselves, and if You do not forgive us and have mercy upon us, we will surely be among the losers.',
        source: 'Quran 7:23',
      ),
    ],
  ),
  DuaCategory(
    name: 'Parents & Family',
    duas: [
      Dua(
        title: 'For parents',
        arabic: 'رَبِّ ارْحَمْهُمَا كَمَا رَبَّيَانِي صَغِيرًا',
        transliteration: 'Rabbi-rhamhuma kama rabbayani sagheera',
        translation: 'My Lord, have mercy upon them as they brought me up when I was small.',
        source: 'Quran 17:24',
      ),
      Dua(
        title: 'For righteous family',
        arabic: 'رَبَّنَا هَبْ لَنَا مِنْ أَزْوَاجِنَا وَذُرِّيَّاتِنَا قُرَّةَ أَعْيُنٍ وَاجْعَلْنَا لِلْمُتَّقِينَ إِمَامًا',
        transliteration:
            'Rabbana hab lana min azwajina wa dhurriyyatina qurrata a\'yun waj\'alna lil-muttaqeena imama',
        translation:
            'Our Lord, grant us from among our spouses and offspring comfort to our eyes and make us an example for the righteous.',
        source: 'Quran 25:74',
      ),
    ],
  ),
  DuaCategory(
    name: 'Ramadan',
    duas: [
      Dua(
        title: 'Intention for fasting',
        arabic:
            'نَوَيْتُ أَنْ أَصُومَ غَدًا عَنْ أَدَاءِ فَرْضِ شَهْرِ رَمَضَانَ هَذِهِ السَّنَةَ لِلَّهِ تَعَالَى',
        transliteration:
            'Nawaytu an asuma ghadan an ada\'i fardi shahri Ramadan hadhihis-sanah lillahi ta\'ala',
        translation:
            'I intend to fast tomorrow to fulfill the obligation of Ramadan this year for the sake of Allah, the Most High.',
        source: 'Traditional',
      ),
      Dua(
        title: 'Breaking the fast (Iftar)',
        arabic: 'ذَهَبَ الظَّمَأُ، وَابْتَلَّتِ الْعُرُوقُ، وَثَبَتَ الْأَجْرُ إِنْ شَاءَ اللَّهُ',
        transliteration:
            'Dhahabaz-zama\' wabtallatil-uroogu wa thabatal-ajru in sha\'Allah',
        translation:
            'The thirst has gone, the veins are moistened, and the reward is confirmed, if Allah wills.',
        source: 'Abu Dawud',
      ),
      Dua(
        title: 'Laylat-ul-Qadr',
        arabic: 'اللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي',
        transliteration:
            'Allahumma innaka \'afuwwun tuhibbul-\'afwa fa\'fu \'anni',
        translation: 'O Allah, You are Pardoning and love pardon, so pardon me.',
        source: 'Tirmidhi',
      ),
    ],
  ),
];
