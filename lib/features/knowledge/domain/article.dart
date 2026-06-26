/// Backend `KnowledgeArticleDto` karşılığı (bilgi makalesi).
class Article {
  const Article({
    required this.id,
    required this.title,
    this.category,
    this.summary,
    this.format,
    this.mediaUrl,
  });

  final String id;
  final String title;
  final String? category;
  final String? summary;
  final String? format; // ARTICLE | VIDEO | ...
  final String? mediaUrl;

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      category: json['category'] as String?,
      summary: json['summary'] as String?,
      format: json['format'] as String?,
      mediaUrl: json['mediaUrl'] as String?,
    );
  }
}
