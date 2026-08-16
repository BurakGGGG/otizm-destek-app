/// Türkçe uyumlu arama normalleştirmesi — web `normalizeSearchText`
/// (TutorialVideoLibrary) ile aynı davranış: Türkçe küçük harf, aksan
/// katlama ve `ı`/`i` eşitlemesi. Böylece "gunluk" araması "Günlük"ü bulur.
library;

const Map<String, String> _turkishLower = {
  'I': 'ı',
  'İ': 'i',
  'Ş': 'ş',
  'Ğ': 'ğ',
  'Ü': 'ü',
  'Ö': 'ö',
  'Ç': 'ç',
};

const Map<String, String> _fold = {
  'ı': 'i',
  'ş': 's',
  'ğ': 'g',
  'ü': 'u',
  'ö': 'o',
  'ç': 'c',
  'â': 'a',
  'î': 'i',
  'û': 'u',
  'é': 'e',
};

String searchNormalize(String value) {
  final buffer = StringBuffer();
  for (final rune in value.trim().runes) {
    final char = String.fromCharCode(rune);
    final lower = _turkishLower[char] ?? char.toLowerCase();
    buffer.write(_fold[lower] ?? lower);
  }
  return buffer.toString();
}

/// [haystack] parçalarından herhangi biri [query] terimlerinin tamamını
/// içeriyor mu? Boş sorgu her zaman eşleşir.
bool searchMatches(String query, Iterable<String> haystack) {
  final terms = searchNormalize(query).split(RegExp(r'\s+'))
    ..removeWhere((term) => term.isEmpty);
  if (terms.isEmpty) return true;
  final text = haystack.map(searchNormalize).join(' ');
  return terms.every(text.contains);
}
