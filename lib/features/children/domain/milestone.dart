/// Backend `MilestoneDto` karşılığı — çocuğun büyük başarıları
/// (web ChildDetailPage "Kilometre Taşları" bölümü).
class Milestone {
  const Milestone({
    required this.id,
    required this.title,
    this.description,
    this.category,
    this.achievedDate,
    this.childId,
    this.createdAt,
  });

  final String id;
  final String title;
  final String? description;

  /// Türkçe sabit kategori (web MILESTONE_CATEGORIES) — veri, çevrilmez.
  final String? category;

  /// `yyyy-MM-dd` (LocalDate).
  final DateTime? achievedDate;
  final String? childId;
  final DateTime? createdAt;

  factory Milestone.fromJson(Map<String, dynamic> json) {
    return Milestone(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      category: json['category'] as String?,
      achievedDate: DateTime.tryParse(json['achievedDate']?.toString() ?? ''),
      childId: json['childId']?.toString(),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
    );
  }
}

/// Kilometre taşı kategorileri — web `MILESTONE_CATEGORIES.value` birebir
/// (paylaşılan Türkçe veri, çevrilmez).
const List<String> kMilestoneCategoryValues = [
  'İletişim',
  'Sosyal',
  'Duyusal',
  'Davranış',
  'Motor',
  'Eğitim',
];
