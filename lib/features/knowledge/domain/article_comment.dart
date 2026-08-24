/// Backend `ArticleCommentDto` karşılığı — makale altındaki aile yorumları.
///
/// Not: backend'in "deneyim" alanları (`durationTried`, `effectivenessRating`)
/// yalnızca okunur; mobil düz yorum gönderir (bkz. depo `addComment`).
class ArticleComment {
  const ArticleComment({
    required this.id,
    required this.content,
    this.authorName,
    this.authorRole,
    this.isExperience = false,
    this.durationTried,
    this.effectivenessRating,
    this.createdAt,
  });

  final String id;
  final String content;
  final String? authorName;
  final String? authorRole;
  final bool isExperience;
  final String? durationTried;
  final int? effectivenessRating;
  final DateTime? createdAt;

  bool get isExpert => (authorRole ?? '').toUpperCase() == 'EXPERT';

  factory ArticleComment.fromJson(Map<String, dynamic> json) {
    final author = json['author'];
    return ArticleComment(
      id: json['id']?.toString() ?? '',
      content: json['content'] as String? ?? '',
      authorName: author is Map<String, dynamic>
          ? author['fullName'] as String?
          : null,
      authorRole:
          author is Map<String, dynamic> ? author['role'] as String? : null,
      // Lombok `boolean isExperience` alanını Jackson `experience` olarak
      // yazıyor; iki anahtar da okunur.
      isExperience: json['experience'] == true || json['isExperience'] == true,
      durationTried: json['durationTried'] as String?,
      effectivenessRating: (json['effectivenessRating'] as num?)?.toInt(),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
    );
  }
}
