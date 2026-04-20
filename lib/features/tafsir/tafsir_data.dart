class TafsirEntry {
  final int surah;
  final int ayah;
  final String source;
  final String text;
  const TafsirEntry({
    required this.surah,
    required this.ayah,
    required this.source,
    required this.text,
  });
}

/// Bundled tafsir snippets for Al-Fatihah (Surah 1).
/// Full tafsir (Ibn Kathir / Jalalayn) can be loaded from external JSON.
/// Sample entries below are condensed from well-known tafsirs for
/// educational reference only.
const bundledTafsir = <TafsirEntry>[
  TafsirEntry(
    surah: 1,
    ayah: 1,
    source: 'Ibn Kathir (summary)',
    text:
        'Bismillah al-Rahman al-Raheem opens the Quran. The Companions of the Prophet (ﷺ) '
        'began reciting with the Name of Allah, affirming that all matters begin with His Name. '
        'Ar-Rahman (The Most Gracious) and Ar-Raheem (The Most Merciful) are two names derived '
        'from the attribute of rahmah (mercy). Ar-Rahman relates to Allah\'s mercy which '
        'encompasses all of creation, while Ar-Raheem refers to His special mercy toward the '
        'believers in this life and the next.',
  ),
  TafsirEntry(
    surah: 1,
    ayah: 2,
    source: 'Ibn Kathir (summary)',
    text:
        'All praise is due to Allah, Lord of all the worlds. Al-Hamd is praise combined with '
        'love and submission. Allah praises Himself and teaches His servants to praise Him with '
        'gratitude. "The worlds" includes all created things: humans, jinn, angels, and every '
        'world beside them. He is Lord, meaning Owner, Creator, and Sustainer of all.',
  ),
  TafsirEntry(
    surah: 1,
    ayah: 3,
    source: 'Ibn Kathir (summary)',
    text:
        'Mentioning Ar-Rahman and Ar-Raheem again after Rabb al-alameen encourages hope: after '
        'learning of His lordship over all creation, the worshipper is reassured that this Lord '
        'is also Most Gracious and Most Merciful.',
  ),
  TafsirEntry(
    surah: 1,
    ayah: 4,
    source: 'Ibn Kathir (summary)',
    text:
        'Malik-i-yawm-id-deen: Sovereign of the Day of Recompense. The Day of Recompense is the '
        'Day of Judgment when Allah will repay each person according to their deeds. Specifying '
        'Allah\'s dominion of that day is a reminder that on that Day, no one will speak or act '
        'except by His permission.',
  ),
  TafsirEntry(
    surah: 1,
    ayah: 5,
    source: 'Ibn Kathir (summary)',
    text:
        'Iyyaka na\'budu wa iyyaka nasta\'een: "It is You we worship, and You we ask for help." '
        'This verse is the pivot of the Quran. The first half affirms tawhid al-uluhiyyah '
        '(oneness in worship), the second half affirms tawhid al-rububiyyah (oneness in lordship). '
        'Placing "You" before the verb in Arabic expresses exclusivity: we worship and seek help '
        'from You alone.',
  ),
  TafsirEntry(
    surah: 1,
    ayah: 6,
    source: 'Ibn Kathir (summary)',
    text:
        'Ihdinas-siraatal-mustaqeem: "Guide us to the straight path." Guidance is of two types: '
        'guidance to Islam (which Allah has granted), and guidance to steadfastness upon it. '
        'The straight path is the path of Islam — the clear, direct route to Allah\'s pleasure '
        'without deviation.',
  ),
  TafsirEntry(
    surah: 1,
    ayah: 7,
    source: 'Ibn Kathir (summary)',
    text:
        'The path of those upon whom Allah has bestowed favor: the prophets, the truthful, the '
        'martyrs, and the righteous (see 4:69). Not those who earned Allah\'s anger (those who '
        'knew the truth and abandoned it) nor those who went astray (those who acted without '
        'knowledge). The believer affirms this by saying "Ameen" at the end.',
  ),
];

List<TafsirEntry> tafsirFor(int surah, int ayah) {
  return bundledTafsir
      .where((t) => t.surah == surah && t.ayah == ayah)
      .toList();
}
