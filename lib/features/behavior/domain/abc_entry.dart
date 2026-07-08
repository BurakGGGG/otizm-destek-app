/// ABC davranış günlüğü sabitleri — DB'de düz Türkçe metin saklanır,
/// web (eski BehaviorJournalPage) ile birebir aynı listeler (ÇEVRİLMEZ).
const kAbcCategories = [
  'Agresyon',
  'Öz-Zarar',
  'Kaçma / Kaçınma',
  'Tantrum / Ağlama',
  'Stereotipik Davranış',
  'Uyumsuzluk',
  'Sosyal Geri Çekilme',
  'Yeme Reddi',
  'Uyku Sorunu',
  'Diğer',
];

const kAbcLocations = [
  'Ev',
  'Okul',
  'Terapi Merkezi',
  'Dışarı',
  'Araç',
  'Market',
  'Diğer',
];

const kAbcAntecedents = [
  'İstek reddedildi',
  'Rutin değişti',
  'Yeni ortam',
  'Kalabalık/Gürültü',
  'Geçiş (aktivite değişimi)',
  'Bekleme süresi',
  'Sosyal talep',
  'Fiziksel rahatsızlık',
  'Açlık/Yorgunluk',
  'Ekran süresi bitti',
  'Oyun bitti',
  'Ev ödevi',
];

const kAbcConsequences = [
  'Talep iptal edildi',
  'Dikkat verildi',
  'Ayrıldım',
  'Sakinleştirme uygulandı',
  'Yönlendirme yapıldı',
  'Tercih verildi',
  'Görmezden gelindi',
  'Ceza uygulandı',
  'Ödül verildi',
  'Uzlaşı sağlandı',
];

/// Backend `ABCEntryDto` karşılığı (Öncesi-Davranış-Sonuç kaydı).
class AbcEntry {
  const AbcEntry({
    required this.id,
    required this.childId,
    required this.entryDate,
    this.entryTime,
    required this.antecedent,
    required this.behavior,
    required this.consequence,
    required this.intensity,
    this.category,
    this.location,
    this.notes,
  });

  final String id;
  final String childId;
  final String entryDate; // "YYYY-MM-DD"
  final String? entryTime; // "HH:mm"
  final String antecedent;
  final String behavior;
  final String consequence;
  final int intensity; // 1-5
  final String? category;
  final String? location;
  final String? notes;

  DateTime? get date => DateTime.tryParse(entryDate);

  factory AbcEntry.fromJson(Map<String, dynamic> json) {
    // LocalTime "HH:mm:ss" gelir; web gibi ilk 5 karaktere kırpılır.
    final rawTime = json['entryTime']?.toString() ?? '';
    return AbcEntry(
      id: json['id']?.toString() ?? '',
      childId: json['childId']?.toString() ?? '',
      entryDate: json['entryDate']?.toString() ?? '',
      entryTime: rawTime.length >= 5 ? rawTime.substring(0, 5) : null,
      antecedent: json['antecedent'] as String? ?? '',
      behavior: json['behavior'] as String? ?? '',
      consequence: json['consequence'] as String? ?? '',
      intensity: (json['intensity'] as num?)?.toInt() ?? 3,
      category: json['category'] as String?,
      location: json['location'] as String?,
      notes: json['notes'] as String?,
    );
  }
}
