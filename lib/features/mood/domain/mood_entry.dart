/// Günlük ruh hali kaydı (`/api/mood`). `entryDate` ISO gün formatında
/// (YYYY-AA-GG); `moodLevel` 1-5 arası. Tetikleyiciler web ile paylaşılan
/// düz metinlerdir (bkz. [kMoodTriggers]).
class MoodEntry {
  const MoodEntry({
    required this.id,
    required this.childId,
    required this.entryDate,
    required this.moodLevel,
    this.notes,
    this.triggers = const [],
  });

  final String id;
  final String childId;
  final String entryDate;
  final int moodLevel;
  final String? notes;
  final List<String> triggers;

  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      id: json['id'] as String? ?? '',
      childId: json['childId'] as String? ?? '',
      entryDate: json['entryDate'] as String? ?? '',
      moodLevel: (json['moodLevel'] as num?)?.toInt() ?? 0,
      notes: json['notes'] as String?,
      triggers: (json['triggers'] as List?)?.whereType<String>().toList() ??
          const [],
    );
  }

  DateTime? get date => DateTime.tryParse(entryDate);
}

/// 1-5 ruh hali seviyelerinin emojileri (indeks = seviye - 1).
const List<String> kMoodEmojis = ['😢', '😕', '😐', '🙂', '😄'];

/// Web platformuyla birebir aynı tetikleyici metinleri — backend'e düz metin
/// olarak kaydedilir; platformlar arası veri tutarlılığı için çevrilmez.
const List<String> kMoodTriggers = [
  'Uykusuzluk',
  'Duyusal Hassasiyet (Gürültü/Işık)',
  'Rutin Değişikliği',
  'Sosyal Kaygı',
  'Terapi Sonrası Yorgunluk',
  'İletişim Engeli (İfade Edememe)',
  'Açlık / Susuzluk',
  'Fiziksel Rahatsızlık',
  'Beklenmedik Geçişler',
];
