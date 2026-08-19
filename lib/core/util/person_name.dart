/// Unvanlar — selamlama, koç notu ve avatar baş harflerinde atlanır
/// ("Uzm. Psk. Selin Aksoy" → "Selin", "SA").
///
/// Web `HONORIFICS` listesi temel alındı; listede olmayan klinik unvanlar
/// (Psk., Uz., Ped., Dt., Vet.) eklendi — web'de "Uzm. Psk. Selin" için ad
/// "Psk." çıkıyor. Bu liste yalnızca arayüzde kullanılır, sunucuya bir şey
/// yazılmaz; genişletmek paylaşılan veriyi etkilemez.
const Set<String> kHonorifics = {
  'Dr.',
  'Prof.',
  'Av.',
  'Doç.',
  'Op.',
  'Uzm.',
  'Uz.',
  'Yrd.',
  'Fzt.',
  'Psk.',
  'Ped.',
  'Dt.',
  'Vet.',
};

List<String> _nameParts(String? fullName) {
  if (fullName == null) return const [];
  return fullName.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
}

/// Adın unvansız ilk parçası (web `getFirstName`).
String personFirstName(String? fullName) {
  final parts = _nameParts(fullName);
  if (parts.isEmpty) return '';
  final name = parts.firstWhere(
    (p) => !kHonorifics.contains(p),
    orElse: () => parts.first,
  );
  return name[0].toUpperCase() + name.substring(1);
}

/// Avatar baş harfleri: unvanlar atlanır, en fazla iki harf.
/// "Uzm. Psk. Selin Aksoy" → "SA", "Ada" → "A".
String personInitials(String? fullName) {
  final parts = [
    for (final part in _nameParts(fullName))
      if (!kHonorifics.contains(part)) part,
  ];
  if (parts.isEmpty) return '';
  String first(String s) => s.substring(0, 1).toUpperCase();
  if (parts.length == 1) return first(parts.first);
  return first(parts.first) + first(parts.last);
}
