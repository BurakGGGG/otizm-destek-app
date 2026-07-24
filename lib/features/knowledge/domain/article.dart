import '../../../core/util/html_text.dart';

/// İçeriğe gömülü medya türü (`[MEDIA:video|podcast:url]` ön ekinden).
enum ArticleMedia { none, video, podcast }

/// Bir makalenin ayrıştırılmış gövdesi: gömülü medya + düz metin.
class ParsedContent {
  const ParsedContent({
    required this.media,
    required this.mediaUrl,
    required this.text,
  });
  final ArticleMedia media;
  final String? mediaUrl;
  final String text;
}

/// Backend `KnowledgeArticleDto` karşılığı (bilgi makalesi).
class Article {
  const Article({
    required this.id,
    required this.title,
    this.category,
    this.summary,
    this.format,
    this.mediaUrl,
    this.content,
    this.authorName,
    this.viewCount,
    this.createdAt,
  });

  final String id;
  final String title;
  final String? category;
  final String? summary;
  final String? format; // TEXT | VIDEO | PODCAST | STORY
  final String? mediaUrl;
  final String? content; // tam gövde (HTML olabilir, medya ön eki taşıyabilir)
  final String? authorName;
  final int? viewCount;
  final DateTime? createdAt;

  static final _mediaPrefix = RegExp(
    r'^\[MEDIA:(video|podcast):([^\]]+)\]\s*([\s\S]*)$',
    caseSensitive: false,
  );

  /// İçeriği ayrıştır: `[MEDIA:...]` ön ekini ayıkla, kalan HTML'i düz metne çevir.
  ParsedContent get parsedContent {
    final raw = content ?? '';
    final m = _mediaPrefix.firstMatch(raw);
    if (m != null) {
      final kind = m.group(1)!.toLowerCase();
      return ParsedContent(
        media: kind == 'video' ? ArticleMedia.video : ArticleMedia.podcast,
        mediaUrl: m.group(2)!.trim(),
        text: htmlToPlainText(m.group(3) ?? ''),
      );
    }
    // Ön ek yoksa DTO'daki mediaUrl/format'a göre medya türünü çıkar.
    final fmt = (format ?? '').toUpperCase();
    final media = fmt == 'VIDEO'
        ? ArticleMedia.video
        : fmt == 'PODCAST'
        ? ArticleMedia.podcast
        : ArticleMedia.none;
    return ParsedContent(
      media: media,
      mediaUrl: (mediaUrl?.isNotEmpty ?? false) ? mediaUrl : null,
      text: htmlToPlainText(raw),
    );
  }

  factory Article.fromJson(Map<String, dynamic> json) {
    final author = json['author'];
    return Article(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      category: json['category'] as String?,
      summary: json['summary'] as String?,
      format: json['format'] as String?,
      mediaUrl: json['mediaUrl'] as String?,
      content: json['content'] as String?,
      authorName: author is Map<String, dynamic>
          ? author['fullName'] as String?
          : null,
      viewCount: (json['viewCount'] as num?)?.toInt(),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
    );
  }
}
