/// Benzer Aile — eşleştirme motorunun bir çocuğa yakın bulduğu aile.
///
/// Backend `SimilarFamilyDto` karşılığı. Skorlar 0..1 aralığında (yüzde için
/// 100 ile çarpılır). `relationshipStatus`: NONE / PENDING / ACCEPTED / REJECTED.
class SimilarFamily {
  const SimilarFamily({
    required this.parentId,
    required this.parentName,
    required this.childAgeRange,
    this.parentCity,
    this.childName,
    this.commonTags = const [],
    this.totalCommonTags = 0,
    this.similarityScore = 0,
    this.tagScore = 0,
    this.ageScore = 0,
    this.therapyScore = 0,
    this.educationScore = 0,
    this.sensoryScore = 0,
    this.matchReasons = const [],
    this.relationshipStatus = 'NONE',
    this.mentorRelation = false,
  });

  final String parentId;
  final String parentName;
  final String childAgeRange;
  final String? parentCity;
  final String? childName;
  final List<FamilyTag> commonTags;
  final int totalCommonTags;
  final double similarityScore;
  final double tagScore;
  final double ageScore;
  final double therapyScore;
  final double educationScore;
  final double sensoryScore;
  final List<String> matchReasons;
  final String relationshipStatus;
  final bool mentorRelation;

  /// Genel uyum yüzdesi (0..100).
  int get scorePercent => (similarityScore * 100).round();

  /// Bekleyen ya da kabul edilmiş bir ilişki var mı (buddy/mentor kilitlenir).
  bool get hasRelationship =>
      relationshipStatus == 'PENDING' || relationshipStatus == 'ACCEPTED';

  SimilarFamily copyWith({String? relationshipStatus, bool? mentorRelation}) {
    return SimilarFamily(
      parentId: parentId,
      parentName: parentName,
      childAgeRange: childAgeRange,
      parentCity: parentCity,
      childName: childName,
      commonTags: commonTags,
      totalCommonTags: totalCommonTags,
      similarityScore: similarityScore,
      tagScore: tagScore,
      ageScore: ageScore,
      therapyScore: therapyScore,
      educationScore: educationScore,
      sensoryScore: sensoryScore,
      matchReasons: matchReasons,
      relationshipStatus: relationshipStatus ?? this.relationshipStatus,
      mentorRelation: mentorRelation ?? this.mentorRelation,
    );
  }

  static double _d(dynamic v) => (v as num?)?.toDouble() ?? 0;

  factory SimilarFamily.fromJson(Map<String, dynamic> json) {
    final tags = json['commonTags'];
    final reasons = json['matchReasons'];
    return SimilarFamily(
      parentId: json['parentId']?.toString() ?? '',
      parentName: json['parentName'] as String? ?? '',
      childAgeRange: json['childAgeRange'] as String? ?? '',
      parentCity: json['parentCity'] as String?,
      childName: json['childName'] as String?,
      commonTags: tags is List
          ? tags
              .whereType<Map<String, dynamic>>()
              .map(FamilyTag.fromJson)
              .toList()
          : const [],
      totalCommonTags: (json['totalCommonTags'] as num?)?.toInt() ?? 0,
      similarityScore: _d(json['similarityScore']),
      tagScore: _d(json['tagScore']),
      ageScore: _d(json['ageScore']),
      therapyScore: _d(json['therapyScore']),
      educationScore: _d(json['educationScore']),
      sensoryScore: _d(json['sensoryScore']),
      matchReasons: reasons is List
          ? reasons.map((e) => e.toString()).toList()
          : const [],
      relationshipStatus: json['relationshipStatus'] as String? ?? 'NONE',
      mentorRelation: json['mentorRelation'] == true,
    );
  }
}

/// Ortak gelişim etiketi (`TagDto`). Etiket adları veri olduğu için çevrilmez.
class FamilyTag {
  const FamilyTag({required this.id, required this.name, this.category});

  final String id;
  final String name;
  final String? category;

  factory FamilyTag.fromJson(Map<String, dynamic> json) {
    return FamilyTag(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String?,
    );
  }
}
