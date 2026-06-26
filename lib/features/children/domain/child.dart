/// Backend `ChildDto` karşılığı (çocuk profili).
class Child {
  const Child({
    required this.id,
    required this.name,
    this.birthDate,
    this.gender,
    this.profileImageUrl,
    this.diagnosisInfo,
  });

  final String id;
  final String name;
  final DateTime? birthDate;
  final String? gender;
  final String? profileImageUrl;
  final String? diagnosisInfo;

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
    return Child(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      birthDate: _parseDate(json['birthDate']),
      gender: json['gender'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      diagnosisInfo: json['diagnosisInfo'] as String?,
    );
  }

  static DateTime? _parseDate(dynamic raw) {
    if (raw is String && raw.isNotEmpty) return DateTime.tryParse(raw);
    return null;
  }
}
