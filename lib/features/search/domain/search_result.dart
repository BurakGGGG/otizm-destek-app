/// Genel arama sonucu türleri — backend `SearchResultDto.type` kodları.
const String kSearchTypePost = 'POST';
const String kSearchTypeArticle = 'ARTICLE';
const String kSearchTypeGroup = 'GROUP';
const String kSearchTypeExpert = 'EXPERT';

/// Süzgeç çubuğundaki sıra (null = tümü).
const List<String?> kSearchTypeFilters = [
  null,
  kSearchTypeArticle,
  kSearchTypePost,
  kSearchTypeExpert,
  kSearchTypeGroup,
];

/// `GET /api/search` sonucu.
class SearchResult {
  const SearchResult({
    required this.id,
    required this.type,
    required this.title,
    this.excerpt,
    this.createdAt,
    this.rank = 0,
  });

  final String id;
  final String type;
  final String title;

  /// Eşleşen metnin kısa parçası (backend üretir).
  final String? excerpt;
  final DateTime? createdAt;
  final double rank;

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      id: json['id']?.toString() ?? '',
      type: json['type'] as String? ?? '',
      title: json['title'] as String? ?? '',
      excerpt: json['excerpt'] as String?,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      rank: (json['rank'] as num?)?.toDouble() ?? 0,
    );
  }
}
