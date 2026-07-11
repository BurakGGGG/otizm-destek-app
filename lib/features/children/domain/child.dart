/// Çocuğa atanmış semptom etiketi (backend `TagDto`). Adı paylaşılan veridir,
/// çevrilmez; `category` ILETISIM/SOSYAL/... enum kodudur.
class ChildTag {
  const ChildTag({required this.id, required this.name, this.category});

  final String id;
  final String name;
  final String? category;

  factory ChildTag.fromJson(Map<String, dynamic> json) {
    return ChildTag(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String?,
    );
  }
}

/// Backend `ChildDto` karşılığı (çocuk profili).
class Child {
  const Child({
    required this.id,
    required this.name,
    this.birthDate,
    this.gender,
    this.profileImageUrl,
    this.diagnosisInfo,
    this.educationProgram,
    this.therapies,
    this.tags = const [],
  });

  final String id;
  final String name;
  final DateTime? birthDate;

  /// Backend serbest metin: `ERKEK` / `KIZ` (ya da null).
  final String? gender;
  final String? profileImageUrl;
  final String? diagnosisInfo;
  final String? educationProgram;
  final String? therapies;
  final List<ChildTag> tags;

  /// Doğum tarihinden tam yaş (yoksa null).
  int? get ageYears {
    final b = birthDate;
    if (b == null) return null;
    final now = DateTime.now();
    var age = now.year - b.year;
    if (now.month < b.month || (now.month == b.month && now.day < b.day)) {
      age--;
    }
    return age < 0 ? null : age;
  }

  factory Child.fromJson(Map<String, dynamic> json) {
    final tags = json['tags'];
    return Child(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      birthDate: _parseDate(json['birthDate']),
      gender: json['gender'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      diagnosisInfo: json['diagnosisInfo'] as String?,
      educationProgram: json['educationProgram'] as String?,
      therapies: json['therapies'] as String?,
      tags: tags is List
          ? tags
              .whereType<Map<String, dynamic>>()
              .map(ChildTag.fromJson)
              .toList()
          : const [],
    );
  }

  /// Oluştur/güncelle gövdesi (yalnız yazılabilir alanlar). Boş metinler
  /// gönderilmez; `birthDate` ISO `yyyy-MM-dd` formatında serileştirilir.
  Map<String, dynamic> toWriteJson() {
    return {
      'name': name,
      if (birthDate != null) 'birthDate': _formatDate(birthDate!),
      if (_notEmpty(gender)) 'gender': gender,
      if (_notEmpty(diagnosisInfo)) 'diagnosisInfo': diagnosisInfo,
      if (_notEmpty(educationProgram)) 'educationProgram': educationProgram,
      if (_notEmpty(therapies)) 'therapies': therapies,
    };
  }

  static bool _notEmpty(String? s) => s != null && s.trim().isNotEmpty;

  static String _formatDate(DateTime d) {
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}-$m-$day';
  }

  static DateTime? _parseDate(dynamic raw) {
    if (raw is String && raw.isNotEmpty) return DateTime.tryParse(raw);
    return null;
  }
}
