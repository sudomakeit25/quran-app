/// Bundled transliteration for Al-Fatihah. Keyed by "surah:ayah".
/// Additional surahs can be loaded from external JSON in a future update.
const transliterations = <String, String>{
  '1:1': 'Bismillah-ir-Rahman-ir-Raheem',
  '1:2': 'Alhamdu lillahi Rabbil-\'alameen',
  '1:3': 'Ar-Rahman-ir-Raheem',
  '1:4': 'Maliki yawm-id-deen',
  '1:5': 'Iyyaka na\'budu wa iyyaka nasta\'een',
  '1:6': 'Ihdinas-siraatal-mustaqeem',
  '1:7':
      'Siraatal-ladheena an\'amta \'alayhim, ghayril-maghdoobi \'alayhim wa lad-daalleen',
};

String? transliterationFor(int surah, int ayah) =>
    transliterations['$surah:$ayah'];
