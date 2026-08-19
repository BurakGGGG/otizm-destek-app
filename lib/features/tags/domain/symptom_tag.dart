/// `/api/tags` semptom etiketi — forum, çocuk profili, ilk kurulum sihirbazı
/// ve bilgi bankası filtresi aynı etiket kümesini kullanır.
///
/// `name` paylaşılan veridir (web'in yazdığı/okuduğu metin) — çevrilmez;
/// yalnızca kategori kodları (`ILETISIM`, `SOSYAL` ...) arayüzde çevrilir.
/// Etiket kategori kodları — web CATEGORY_LABELS anahtarları birebir.
const List<String> kSymptomTagCategories = [
  'ILETISIM',
  'SOSYAL',
  'DUYUSAL',
  'DAVRANIS',
  'MOTOR',
  'EGITIM',
];

class SymptomTag {
  const SymptomTag({required this.id, required this.name, this.category});

  final String id;
  final String name;
  final String? category;

  factory SymptomTag.fromJson(Map<String, dynamic> json) {
    return SymptomTag(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String?,
    );
  }
}
