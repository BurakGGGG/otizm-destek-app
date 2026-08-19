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
    this.bio,
    this.licenseVerified = false,
    this.ageGroups = const [],
    this.supportTopics = const [],
    this.spokenLanguages = const [],
    this.sessionDurationMinutes,
    this.cancellationPolicy,
    this.reschedulePolicy,
    this.sessionFeeMin,
    this.sessionFeeMax,
    this.offersOnline = true,
    this.offersFaceToFace = true,
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

  /// Uzmanın kendi yazdığı tanıtım metni (veri).
  final String? bio;
  final bool licenseVerified;

  /// Profil bilgileri — hepsi uzmanın girdiği serbest metinlerdir (veri,
  /// çevrilmez); yalnızca etiketleri i18n'den gelir.
  final List<String> ageGroups;
  final List<String> supportTopics;
  final List<String> spokenLanguages;
  final int? sessionDurationMinutes;
  final String? cancellationPolicy;
  final String? reschedulePolicy;

  /// Seans ücreti aralığı (TL) ve hizmet biçimi. Web kartlarında da görünür;
  /// bayraklar `false` gelmedikçe açık kabul edilir (web `!== false`).
  final num? sessionFeeMin;
  final num? sessionFeeMax;
  final bool offersOnline;
  final bool offersFaceToFace;

  bool get hasFee => sessionFeeMin != null || sessionFeeMax != null;

  bool get hasRating => reviewCount > 0;

  factory Expert.fromJson(Map<String, dynamic> json) {
    return Expert(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName'] as String? ?? '',
      expertTitle: json['expertTitle'] as String?,
      city: json['city'] as String?,
      institution: json['institution'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      specializations:
          (json['specializations'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      avgRating: (json['avgRating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      articleCount: (json['articleCount'] as num?)?.toInt() ?? 0,
      verified: json['verified'] as bool? ?? false,
      acceptingPatients: json['acceptingPatients'] as bool? ?? true,
      bio: json['bio'] as String?,
      licenseVerified: json['licenseVerified'] as bool? ?? false,
      ageGroups: _stringList(json['ageGroups']),
      supportTopics: _stringList(json['supportTopics']),
      spokenLanguages: _stringList(json['spokenLanguages']),
      sessionDurationMinutes:
          (json['sessionDurationMinutes'] as num?)?.toInt(),
      cancellationPolicy: json['cancellationPolicy'] as String?,
      reschedulePolicy: json['reschedulePolicy'] as String?,
      sessionFeeMin: json['sessionFeeMin'] as num?,
      sessionFeeMax: json['sessionFeeMax'] as num?,
      offersOnline: json['offersOnline'] != false,
      offersFaceToFace: json['offersFaceToFace'] != false,
    );
  }
}

List<String> _stringList(Object? value) {
  if (value is! List) return const [];
  return [
    for (final item in value)
      if (item != null && item.toString().trim().isNotEmpty) item.toString(),
  ];
}
