class Reciter {
  final String id;
  final String name;
  final String language;
  final String baseUrl;
  const Reciter({
    required this.id,
    required this.name,
    required this.language,
    required this.baseUrl,
  });

  /// Build an audio URL for a specific ayah (using everyayah.com pattern).
  /// Returns e.g. "${baseUrl}001001.mp3" for Al-Fatihah ayah 1.
  String ayahUrl(int surah, int ayah) {
    final s = surah.toString().padLeft(3, '0');
    final a = ayah.toString().padLeft(3, '0');
    return '$baseUrl$s$a.mp3';
  }
}

const reciters = <Reciter>[
  Reciter(
    id: 'afasy',
    name: 'Mishary Rashid Al-Afasy',
    language: 'Arabic',
    baseUrl: 'https://everyayah.com/data/Alafasy_128kbps/',
  ),
  Reciter(
    id: 'sudais',
    name: 'Abdul Rahman Al-Sudais',
    language: 'Arabic',
    baseUrl: 'https://everyayah.com/data/Abdurrahmaan_As-Sudais_192kbps/',
  ),
  Reciter(
    id: 'basit',
    name: 'Abdul Basit (Mujawwad)',
    language: 'Arabic',
    baseUrl: 'https://everyayah.com/data/Abdul_Basit_Mujawwad_128kbps/',
  ),
  Reciter(
    id: 'ghamdi',
    name: 'Saad Al-Ghamdi',
    language: 'Arabic',
    baseUrl: 'https://everyayah.com/data/Ghamadi_40kbps/',
  ),
  Reciter(
    id: 'minshawi',
    name: 'Mohamed Siddiq Al-Minshawi',
    language: 'Arabic',
    baseUrl: 'https://everyayah.com/data/Minshawy_Murattal_128kbps/',
  ),
  Reciter(
    id: 'husary',
    name: 'Mahmoud Khalil Al-Husary',
    language: 'Arabic',
    baseUrl: 'https://everyayah.com/data/Husary_128kbps/',
  ),
  Reciter(
    id: 'shuraim',
    name: 'Saud Al-Shuraim',
    language: 'Arabic',
    baseUrl: 'https://everyayah.com/data/Saood_ash-Shuraym_128kbps/',
  ),
];
