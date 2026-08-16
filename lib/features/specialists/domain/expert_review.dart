/// Uzman değerlendirmesi (`GET /api/experts/{id}/reviews` → `ExpertReviewDto`).
class ExpertReview {
  const ExpertReview({
    required this.id,
    required this.rating,
    this.reviewerId,
    this.reviewerName,
    this.reviewerImageUrl,
    this.comment,
    this.createdAt,
  });

  final String id;

  /// 1-5 (backend aralığı zorunlu kılıyor).
  final int rating;
  final String? reviewerId;
  final String? reviewerName;
  final String? reviewerImageUrl;
  final String? comment;
  final DateTime? createdAt;

  factory ExpertReview.fromJson(Map<String, dynamic> json) {
    return ExpertReview(
      id: json['id']?.toString() ?? '',
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      reviewerId: json['reviewerId']?.toString(),
      reviewerName: json['reviewerName'] as String?,
      reviewerImageUrl: json['reviewerImageUrl'] as String?,
      comment: json['comment'] as String?,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
    );
  }
}

/// Değerlendirme özeti: liste + ortalama + toplam (backend tek gövdede döner).
class ExpertReviewSummary {
  const ExpertReviewSummary({
    required this.reviews,
    required this.averageRating,
    required this.totalCount,
  });

  final List<ExpertReview> reviews;
  final double averageRating;
  final int totalCount;

  static const empty = ExpertReviewSummary(
    reviews: [],
    averageRating: 0,
    totalCount: 0,
  );

  /// Oturum sahibinin daha önce yazdığı değerlendirme (varsa) — backend aynı
  /// kullanıcı için yeni kayıt açmaz, mevcut olanı günceller.
  ExpertReview? mine(String? userId) {
    if (userId == null) return null;
    for (final review in reviews) {
      if (review.reviewerId == userId) return review;
    }
    return null;
  }

  factory ExpertReviewSummary.fromJson(Map<String, dynamic> json) {
    final list = json['reviews'];
    return ExpertReviewSummary(
      reviews: list is List
          ? list
              .whereType<Map<String, dynamic>>()
              .map(ExpertReview.fromJson)
              .toList()
          : const [],
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0,
      totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
    );
  }
}
