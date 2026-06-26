/// Backend uzman listesi öğesi (`GET /api/experts` → `UserDto`).
class Expert {
  const Expert({
    required this.id,
    required this.fullName,
    this.expertTitle,
    this.city,
    this.institution,
    this.profileImageUrl,
    this.specializations = const [],
    this.avgRating = 0.0,
    this.reviewCount = 0,
    this.articleCount = 0,
    this.verified = false,
    this.acceptingPatients = true,
  });

  final String id;
  final String fullName;
  final String? expertTitle;
  final String? city;
  final String? institution;
  final String? profileImageUrl;
  final List<String> specializations;
  final double avgRating;
  final int reviewCount;
  final int articleCount;
  final bool verified;
  final bool acceptingPatients;

  bool get hasRating => reviewCount > 0;

  factory Expert.fromJson(Map<String, dynamic> json) {
    return Expert(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName'] as String? ?? '',
      expertTitle: json['expertTitle'] as String?,
      city: json['city'] as String?,
      institution: json['institution'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      specializations: (json['specializations'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      avgRating: (json['avgRating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      articleCount: (json['articleCount'] as num?)?.toInt() ?? 0,
      verified: json['verified'] as bool? ?? false,
      acceptingPatients: json['acceptingPatients'] as bool? ?? true,
    );
  }
}
