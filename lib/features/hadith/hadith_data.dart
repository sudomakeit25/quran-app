class Hadith {
  final int number;
  final String collection;
  final String narrator;
  final String arabic;
  final String translation;
  const Hadith({
    required this.number,
    required this.collection,
    required this.narrator,
    required this.arabic,
    required this.translation,
  });
}

class HadithCollection {
  final String name;
  final String description;
  final List<Hadith> hadiths;
  const HadithCollection({
    required this.name,
    required this.description,
    required this.hadiths,
  });
}

// The 40 Hadith of Imam Nawawi — foundational collection widely taught to beginners.
// Selection of the first 10 is bundled here; full 40 can be appended.
const nawawi40 = HadithCollection(
  name: 'Al-Nawawi\'s 40 Hadith',
  description:
      'A collection of 42 foundational ahadith on the essentials of Islam, compiled by Imam Nawawi (d. 676 AH).',
  hadiths: [
    Hadith(
      number: 1,
      collection: 'Nawawi',
      narrator: 'Umar ibn al-Khattab (ra)',
      arabic: 'إِنَّمَا الْأَعْمَالُ بِالنِّيَّاتِ وَإِنَّمَا لِكُلِّ امْرِئٍ مَا نَوَى',
      translation:
          'Actions are only by intention, and each person shall have only what they intended.',
    ),
    Hadith(
      number: 2,
      collection: 'Nawawi',
      narrator: 'Umar ibn al-Khattab (ra)',
      arabic: 'الْإِسْلَامُ أَنْ تَشْهَدَ أَنْ لَا إِلَهَ إِلَّا اللَّهُ وَأَنَّ مُحَمَّدًا رَسُولُ اللَّهِ...',
      translation:
          'Islam is to bear witness that none has the right to be worshipped but Allah and that Muhammad is His Messenger; to establish prayer; to give zakat; to fast Ramadan; and to make pilgrimage to the House if you are able. Iman is to believe in Allah, His angels, His books, His messengers, the Last Day, and the divine decree, both its good and its evil. Ihsan is to worship Allah as if you see Him, for though you do not see Him, He sees you.',
    ),
    Hadith(
      number: 3,
      collection: 'Nawawi',
      narrator: 'Abdullah ibn Umar (ra)',
      arabic: 'بُنِيَ الْإِسْلَامُ عَلَى خَمْسٍ: شَهَادَةِ أَنْ لَا إِلَهَ إِلَّا اللَّهُ وَأَنَّ مُحَمَّدًا رَسُولُ اللَّهِ، وَإِقَامِ الصَّلَاةِ، وَإِيتَاءِ الزَّكَاةِ، وَحَجِّ الْبَيْتِ، وَصَوْمِ رَمَضَانَ',
      translation:
          'Islam is built upon five: testifying that there is no god but Allah and that Muhammad is the Messenger of Allah; establishing the prayer; giving zakat; pilgrimage to the House; and fasting Ramadan.',
    ),
    Hadith(
      number: 4,
      collection: 'Nawawi',
      narrator: 'Abdullah ibn Mas\'ud (ra)',
      arabic: 'إِنَّ أَحَدَكُمْ يُجْمَعُ خَلْقُهُ فِي بَطْنِ أُمِّهِ أَرْبَعِينَ يَوْمًا نُطْفَةً...',
      translation:
          'The creation of each one of you is gathered in his mother\'s womb for forty days as a drop, then he becomes a clot for a like period, then a piece of flesh for a like period. Then the angel is sent to him and commanded with four decrees: to write down his provision, his lifespan, his actions, and whether he will be wretched or blessed.',
    ),
    Hadith(
      number: 5,
      collection: 'Nawawi',
      narrator: 'Aisha (ra)',
      arabic: 'مَنْ أَحْدَثَ فِي أَمْرِنَا هَذَا مَا لَيْسَ مِنْهُ فَهُوَ رَدٌّ',
      translation:
          'Whoever introduces into this affair of ours something that is not of it, it is rejected.',
    ),
    Hadith(
      number: 6,
      collection: 'Nawawi',
      narrator: 'Nu\'man ibn Bashir (ra)',
      arabic: 'الْحَلَالُ بَيِّنٌ وَالْحَرَامُ بَيِّنٌ وَبَيْنَهُمَا أُمُورٌ مُشْتَبِهَاتٌ',
      translation:
          'The lawful is clear and the unlawful is clear, and between them are matters which are ambiguous, about which many people do not know. So whoever guards against the ambiguous has protected his religion and his honor.',
    ),
    Hadith(
      number: 7,
      collection: 'Nawawi',
      narrator: 'Tamim Al-Dari (ra)',
      arabic: 'الدِّينُ النَّصِيحَةُ',
      translation: 'Religion is sincere good will. We said: To whom? He said: "To Allah, to His Book, to His Messenger, and to the leaders and common folk of the Muslims."',
    ),
    Hadith(
      number: 8,
      collection: 'Nawawi',
      narrator: 'Abdullah ibn Umar (ra)',
      arabic: 'أُمِرْتُ أَنْ أُقَاتِلَ النَّاسَ حَتَّى يَشْهَدُوا أَنْ لَا إِلَهَ إِلَّا اللَّهُ',
      translation:
          'I have been commanded to fight people until they testify that there is no god but Allah and that Muhammad is the Messenger of Allah, establish the prayer, and give the zakat. If they do that, they have protected from me their blood and property except by the right of Islam, and their reckoning is with Allah.',
    ),
    Hadith(
      number: 9,
      collection: 'Nawawi',
      narrator: 'Abu Hurayrah (ra)',
      arabic: 'مَا نَهَيْتُكُمْ عَنْهُ فَاجْتَنِبُوهُ، وَمَا أَمَرْتُكُمْ بِهِ فَافْعَلُوا مِنْهُ مَا اسْتَطَعْتُمْ',
      translation:
          'What I have forbidden to you, avoid; and what I have commanded you, do of it as much as you can. Those who came before you were destroyed only by their excessive questioning and their differing over their prophets.',
    ),
    Hadith(
      number: 10,
      collection: 'Nawawi',
      narrator: 'Abu Hurayrah (ra)',
      arabic: 'إِنَّ اللَّهَ طَيِّبٌ لَا يَقْبَلُ إِلَّا طَيِّبًا',
      translation:
          'Allah is pure and accepts only what is pure. Allah has commanded the believers what He has commanded the messengers.',
    ),
    Hadith(
      number: 11,
      collection: 'Nawawi',
      narrator: 'Al-Hasan ibn Ali (ra)',
      arabic: 'دَعْ مَا يَرِيبُكَ إِلَى مَا لَا يَرِيبُكَ',
      translation:
          'Leave what makes you doubt for what does not make you doubt.',
    ),
    Hadith(
      number: 12,
      collection: 'Nawawi',
      narrator: 'Abu Hurayrah (ra)',
      arabic: 'مِنْ حُسْنِ إِسْلَامِ الْمَرْءِ تَرْكُهُ مَا لَا يَعْنِيهِ',
      translation:
          'Part of the perfection of a person\'s Islam is leaving what does not concern them.',
    ),
    Hadith(
      number: 13,
      collection: 'Nawawi',
      narrator: 'Anas (ra)',
      arabic: 'لَا يُؤْمِنُ أَحَدُكُمْ حَتَّى يُحِبَّ لِأَخِيهِ مَا يُحِبُّ لِنَفْسِهِ',
      translation:
          'None of you truly believes until he loves for his brother what he loves for himself.',
    ),
    Hadith(
      number: 14,
      collection: 'Nawawi',
      narrator: 'Abdullah ibn Mas\'ud (ra)',
      arabic: 'لَا يَحِلُّ دَمُ امْرِئٍ مُسْلِمٍ إِلَّا بِإِحْدَى ثَلَاثٍ',
      translation:
          'The blood of a Muslim is not lawful except in one of three cases: the adulterer, a life for a life, and the one who forsakes his religion and separates from the community.',
    ),
    Hadith(
      number: 15,
      collection: 'Nawawi',
      narrator: 'Abu Hurayrah (ra)',
      arabic: 'مَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَالْيَوْمِ الْآخِرِ فَلْيَقُلْ خَيْرًا أَوْ لِيَصْمُتْ',
      translation:
          'Whoever believes in Allah and the Last Day, let him speak good or remain silent; and let him honor his neighbor; and let him honor his guest.',
    ),
    Hadith(
      number: 16,
      collection: 'Nawawi',
      narrator: 'Abu Hurayrah (ra)',
      arabic: 'لَا تَغْضَبْ',
      translation:
          'A man said to the Prophet (ﷺ), "Counsel me." He said, "Do not become angry." The man asked him repeatedly, and each time he said, "Do not become angry."',
    ),
    Hadith(
      number: 17,
      collection: 'Nawawi',
      narrator: 'Shaddad ibn Aws (ra)',
      arabic: 'إِنَّ اللَّهَ كَتَبَ الْإِحْسَانَ عَلَى كُلِّ شَيْءٍ',
      translation:
          'Allah has prescribed ihsan (excellence) in all things. So if you kill, kill well; if you slaughter, slaughter well. Let each of you sharpen his blade and spare suffering to the animal he slaughters.',
    ),
    Hadith(
      number: 18,
      collection: 'Nawawi',
      narrator: 'Abu Dharr and Mu\'adh (ra)',
      arabic: 'اتَّقِ اللَّهَ حَيْثُمَا كُنْتَ، وَأَتْبِعِ السَّيِّئَةَ الْحَسَنَةَ تَمْحُهَا، وَخَالِقِ النَّاسَ بِخُلُقٍ حَسَنٍ',
      translation:
          'Fear Allah wherever you are. Follow a bad deed with a good one, and it will wipe it out. And treat people with good character.',
    ),
    Hadith(
      number: 19,
      collection: 'Nawawi',
      narrator: 'Ibn Abbas (ra)',
      arabic: 'احْفَظِ اللَّهَ يَحْفَظْكَ، احْفَظِ اللَّهَ تَجِدْهُ تُجَاهَكَ',
      translation:
          'Be mindful of Allah, He will protect you. Be mindful of Allah, you will find Him in front of you. If you ask, ask of Allah; if you seek help, seek help from Allah. Know that if the nation were to gather together to benefit you, they would not benefit you except with what Allah had already prescribed for you.',
    ),
    Hadith(
      number: 20,
      collection: 'Nawawi',
      narrator: 'Abu Mas\'ud (ra)',
      arabic: 'إِنَّ مِمَّا أَدْرَكَ النَّاسُ مِنْ كَلَامِ النُّبُوَّةِ الْأُولَى: إِذَا لَمْ تَسْتَحِ فَاصْنَعْ مَا شِئْتَ',
      translation:
          'Among the words that people have received from the earliest prophecy: "If you feel no shame, then do as you wish."',
    ),
    Hadith(
      number: 21,
      collection: 'Nawawi',
      narrator: 'Sufyan ibn Abdullah (ra)',
      arabic: 'قُلْ آمَنْتُ بِاللَّهِ ثُمَّ اسْتَقِمْ',
      translation:
          'I said: "O Messenger of Allah, tell me something about Islam which I can ask of no one but you." He said: "Say, \'I believe in Allah,\' and then be steadfast."',
    ),
    Hadith(
      number: 22,
      collection: 'Nawawi',
      narrator: 'Abu Abdullah Jabir ibn Abdullah (ra)',
      arabic:
          'أَرَأَيْتَ إِذَا صَلَّيْتُ الْمَكْتُوبَاتِ وَصُمْتُ رَمَضَانَ وَأَحْلَلْتُ الْحَلَالَ وَحَرَّمْتُ الْحَرَامَ...',
      translation:
          'A man asked the Prophet (ﷺ): "Do you think that if I perform the obligatory prayers, fast in Ramadan, treat as lawful that which is lawful, and treat as forbidden that which is forbidden, and do nothing more, I shall enter Paradise?" He said: "Yes."',
    ),
    Hadith(
      number: 23,
      collection: 'Nawawi',
      narrator: 'Abu Malik al-Harith ibn Asim al-Ashari (ra)',
      arabic: 'الطُّهُورُ شَطْرُ الْإِيمَانِ',
      translation:
          'Purity is half of faith. "Alhamdulillah" fills the scale, "SubhanAllah" and "Alhamdulillah" fill what is between the heavens and earth. Prayer is a light. Charity is proof. Patience is illumination. The Quran is a proof for or against you. Every person starts the day selling himself — freeing himself or destroying himself.',
    ),
    Hadith(
      number: 24,
      collection: 'Nawawi',
      narrator: 'Abu Dharr Al-Ghafari (ra)',
      arabic: 'يَا عِبَادِي إِنِّي حَرَّمْتُ الظُّلْمَ عَلَى نَفْسِي وَجَعَلْتُهُ بَيْنَكُمْ مُحَرَّمًا فَلَا تَظَالَمُوا',
      translation:
          'Allah the Almighty said: "O My servants, I have forbidden oppression for Myself and made it forbidden among you, so do not oppress one another. O My servants, all of you are astray except those I have guided, so seek guidance from Me and I will guide you..."',
    ),
    Hadith(
      number: 25,
      collection: 'Nawawi',
      narrator: 'Abu Dharr (ra)',
      arabic: 'ذَهَبَ أَهْلُ الدُّثُورِ بِالْأُجُورِ',
      translation:
          'Some Companions said: "O Messenger of Allah, the wealthy have taken away all the rewards — they pray as we pray and fast as we fast, but they give charity from their surplus wealth." He said: "Has not Allah made things for you to give in charity? Every tasbih is charity, every takbir is charity, every tahmid is charity, every tahlil is charity; enjoining good is charity; forbidding evil is charity; and in intimacy with your spouse there is charity."',
    ),
    Hadith(
      number: 26,
      collection: 'Nawawi',
      narrator: 'Abu Hurayrah (ra)',
      arabic: 'كُلُّ سُلَامَى مِنَ النَّاسِ عَلَيْهِ صَدَقَةٌ',
      translation:
          'Every joint of a person must perform a charity each day the sun rises: to judge justly between two people is charity, to help a man with his mount is charity, a good word is charity, every step you take to prayer is charity, and removing a harmful thing from the road is charity.',
    ),
    Hadith(
      number: 27,
      collection: 'Nawawi',
      narrator: 'An-Nawwas ibn Saman (ra) and Wabisa ibn Ma\'bad (ra)',
      arabic: 'الْبِرُّ حُسْنُ الْخُلُقِ، وَالْإِثْمُ مَا حَاكَ فِي صَدْرِكَ وَكَرِهْتَ أَنْ يَطَّلِعَ عَلَيْهِ النَّاسُ',
      translation:
          'Righteousness is good character, and sin is what wavers in your soul and which you dislike people finding out about.',
    ),
    Hadith(
      number: 28,
      collection: 'Nawawi',
      narrator: 'Abu Najih Al-Irbad ibn Sariyah (ra)',
      arabic: 'أُوصِيكُمْ بِتَقْوَى اللَّهِ وَالسَّمْعِ وَالطَّاعَةِ',
      translation:
          'I counsel you to fear Allah and to listen and obey, even if an Abyssinian slave is placed over you as a leader. Whoever among you lives long will see many differences, so hold fast to my Sunnah and the Sunnah of the rightly-guided Caliphs after me. Beware of newly-invented matters, for every innovation is misguidance.',
    ),
    Hadith(
      number: 29,
      collection: 'Nawawi',
      narrator: 'Mu\'adh ibn Jabal (ra)',
      arabic: 'أَخْبِرْنِي بِعَمَلٍ يُدْخِلُنِي الْجَنَّةَ وَيُبَاعِدُنِي عَنِ النَّارِ',
      translation:
          'I said: "O Messenger of Allah, tell me of an act that will take me into Paradise and keep me away from Hellfire." He said: "You have asked about a great matter, yet it is easy for whomever Allah makes it easy: worship Allah without associating anything with Him, establish the prayer, pay the zakat, fast Ramadan, and perform Hajj to the House." Then he said: "Shall I show you the gates of goodness? Fasting is a shield, charity wipes out sin as water extinguishes fire, and a man\'s prayer in the depths of the night..."',
    ),
    Hadith(
      number: 30,
      collection: 'Nawawi',
      narrator: 'Abu Tha\'labah Al-Khushani (ra)',
      arabic: 'إِنَّ اللَّهَ فَرَضَ فَرَائِضَ فَلَا تُضَيِّعُوهَا، وَحَدَّ حُدُودًا فَلَا تَعْتَدُوهَا',
      translation:
          'Allah has set obligations, so do not neglect them. He has set limits, so do not transgress them. He has forbidden things, so do not violate them. And He remained silent about things out of mercy — not forgetfulness — so do not ask about them.',
    ),
    Hadith(
      number: 31,
      collection: 'Nawawi',
      narrator: 'Abu Al-Abbas Sahl ibn Sa\'d As-Sa\'idi (ra)',
      arabic: 'ازْهَدْ فِي الدُّنْيَا يُحِبَّكَ اللَّهُ، وَازْهَدْ فِيمَا عِنْدَ النَّاسِ يُحِبَّكَ النَّاسُ',
      translation:
          'A man came to the Prophet (ﷺ) and said: "Show me a deed which, if I do it, Allah will love me and people will love me." He said: "Have little interest in this world and Allah will love you; and have little interest in what people possess and they will love you."',
    ),
    Hadith(
      number: 32,
      collection: 'Nawawi',
      narrator: 'Abu Sa\'id Sa\'d ibn Malik ibn Sinan Al-Khudri (ra)',
      arabic: 'لَا ضَرَرَ وَلَا ضِرَارَ',
      translation:
          'There should be no harming or reciprocating harm.',
    ),
    Hadith(
      number: 33,
      collection: 'Nawawi',
      narrator: 'Ibn Abbas (ra)',
      arabic: 'لَوْ يُعْطَى النَّاسُ بِدَعْوَاهُمْ لَادَّعَى رِجَالٌ أَمْوَالَ قَوْمٍ وَدِمَاءَهُمْ، وَلَكِنَّ الْبَيِّنَةَ عَلَى الْمُدَّعِي، وَالْيَمِينَ عَلَى مَنْ أَنْكَرَ',
      translation:
          'If people were given whatever they claimed, some would claim the lives and properties of others. But the burden of proof is on the claimant, and the oath is on the one who denies.',
    ),
    Hadith(
      number: 34,
      collection: 'Nawawi',
      narrator: 'Abu Sa\'id Al-Khudri (ra)',
      arabic: 'مَنْ رَأَى مِنْكُمْ مُنْكَرًا فَلْيُغَيِّرْهُ بِيَدِهِ، فَإِنْ لَمْ يَسْتَطِعْ فَبِلِسَانِهِ، فَإِنْ لَمْ يَسْتَطِعْ فَبِقَلْبِهِ، وَذَلِكَ أَضْعَفُ الْإِيمَانِ',
      translation:
          'Whoever among you sees an evil, let him change it with his hand; if he cannot, then with his tongue; if he cannot, then with his heart — and that is the weakest of faith.',
    ),
    Hadith(
      number: 35,
      collection: 'Nawawi',
      narrator: 'Abu Hurayrah (ra)',
      arabic: 'لَا تَحَاسَدُوا، وَلَا تَنَاجَشُوا، وَلَا تَبَاغَضُوا، وَلَا تَدَابَرُوا، وَكُونُوا عِبَادَ اللَّهِ إِخْوَانًا',
      translation:
          'Do not envy one another; do not inflate prices on one another; do not hate one another; do not turn away from one another; and be, O servants of Allah, brothers. A Muslim is the brother of a Muslim: he does not oppress him, nor does he fail him, nor does he lie to him, nor does he despise him.',
    ),
    Hadith(
      number: 36,
      collection: 'Nawawi',
      narrator: 'Abu Hurayrah (ra)',
      arabic: 'مَنْ نَفَّسَ عَنْ مُؤْمِنٍ كُرْبَةً مِنْ كُرَبِ الدُّنْيَا نَفَّسَ اللَّهُ عَنْهُ كُرْبَةً مِنْ كُرَبِ يَوْمِ الْقِيَامَةِ',
      translation:
          'Whoever removes a worldly grief from a believer, Allah will remove one of his griefs on the Day of Judgment. Whoever makes it easy for one in distress, Allah will make things easy for him in this life and the next. Allah helps His servant so long as he helps his brother.',
    ),
    Hadith(
      number: 37,
      collection: 'Nawawi',
      narrator: 'Ibn Abbas (ra)',
      arabic: 'إِنَّ اللَّهَ كَتَبَ الْحَسَنَاتِ وَالسَّيِّئَاتِ ثُمَّ بَيَّنَ ذَلِكَ',
      translation:
          'Allah has recorded good and bad deeds: whoever intends a good deed and does not do it, Allah records a full good deed; if he does it, Allah records ten to seven-hundred-fold; whoever intends a bad deed and does not do it, Allah records a full good deed; if he does it, Allah records it as a single bad deed.',
    ),
    Hadith(
      number: 38,
      collection: 'Nawawi',
      narrator: 'Abu Hurayrah (ra)',
      arabic: 'مَنْ عَادَى لِي وَلِيًّا فَقَدْ آذَنْتُهُ بِالْحَرْبِ',
      translation:
          'Allah has said: "Whoever shows enmity to a friend of Mine, I declare war on him. My servant does not draw near to Me with anything more beloved to Me than what I have obligated on him. My servant continues to draw near to Me with voluntary acts until I love him; and when I love him, I am his hearing with which he hears, his sight with which he sees, his hand with which he strikes, and his foot with which he walks..."',
    ),
    Hadith(
      number: 39,
      collection: 'Nawawi',
      narrator: 'Ibn Abbas (ra)',
      arabic: 'إِنَّ اللَّهَ تَجَاوَزَ لِي عَنْ أُمَّتِي الْخَطَأَ وَالنِّسْيَانَ وَمَا اسْتُكْرِهُوا عَلَيْهِ',
      translation:
          'Allah has pardoned for my nation their mistakes, forgetfulness, and what they are forced to do.',
    ),
    Hadith(
      number: 40,
      collection: 'Nawawi',
      narrator: 'Abdullah ibn Umar (ra)',
      arabic: 'كُنْ فِي الدُّنْيَا كَأَنَّكَ غَرِيبٌ أَوْ عَابِرُ سَبِيلٍ',
      translation:
          'Be in this world as if you were a stranger or a traveler along the path. When evening comes, do not expect to reach the morning; when morning comes, do not expect to reach the evening. Take from your health for your sickness, and from your life for your death.',
    ),
    Hadith(
      number: 41,
      collection: 'Nawawi',
      narrator: 'Abu Muhammad Abdullah ibn Amr ibn Al-As (ra)',
      arabic: 'لَا يُؤْمِنُ أَحَدُكُمْ حَتَّى يَكُونَ هَوَاهُ تَبَعًا لِمَا جِئْتُ بِهِ',
      translation:
          'None of you believes until his desires conform to what I have brought.',
    ),
    Hadith(
      number: 42,
      collection: 'Nawawi',
      narrator: 'Anas (ra)',
      arabic:
          'قَالَ اللَّهُ تَعَالَى: يَا ابْنَ آدَمَ إِنَّكَ مَا دَعَوْتَنِي وَرَجَوْتَنِي غَفَرْتُ لَكَ عَلَى مَا كَانَ مِنْكَ وَلَا أُبَالِي',
      translation:
          'Allah has said: "O son of Adam, so long as you call upon Me and ask of Me, I shall forgive you for what you have done, and I shall not mind. O son of Adam, were your sins to reach the clouds of the sky and were you then to ask forgiveness of Me, I would forgive you. O son of Adam, were you to come to Me with sins nearly as great as the earth, and were you then to face Me, ascribing no partner to Me, I would bring you forgiveness nearly as great as it."',
    ),
  ],
);
