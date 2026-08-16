import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/providers.dart';
import '../domain/article.dart';
import '../domain/article_comment.dart';

/// Sayfalı makale sonucu (Spring `Page` → içerik + devamı var mı).
typedef ArticlePage = ({List<Article> items, bool hasMore});

/// Bilgi bankası araması — web `knowledgeService.search` parametreleri birebir.
class ArticleQuery {
  const ArticleQuery({this.text = '', this.category, this.format});

  /// Serbest arama (`q`).
  final String text;

  /// Kategori değeri (paylaşılan veri — `kKnowledgeCategories`).
  final String? category;

  /// TEXT | VIDEO | PODCAST (web `TYPE_TO_FORMAT`).
  final String? format;

  bool get isEmpty =>
      text.trim().isEmpty && category == null && format == null;

  Map<String, dynamic> toQueryParameters({required int page, int size = 12}) {
    return {
      if (text.trim().isNotEmpty) 'q': text.trim(),
      if (category != null) 'category': category,
      if (format != null) 'format': format,
      'page': page,
      'size': size,
    };
  }

  ArticleQuery copyWith({
    String? text,
    String? category,
    String? format,
    bool clearCategory = false,
    bool clearFormat = false,
  }) {
    return ArticleQuery(
      text: text ?? this.text,
      category: clearCategory ? null : (category ?? this.category),
      format: clearFormat ? null : (format ?? this.format),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ArticleQuery &&
      other.text == text &&
      other.category == category &&
      other.format == format;

  @override
  int get hashCode => Object.hash(text, category, format);
}

/// `/api/knowledge` uç noktalarını saran depo: yayınlanmış makaleler, arama,
/// yer imleri, ilgili içerikler ve yorumlar.
class KnowledgeRepository {
  KnowledgeRepository(this._dio);
  final Dio _dio;

  ArticlePage _pageFrom(Map<String, dynamic> data) {
    final content = data['content'];
    final items = content is List
        ? content
            .whereType<Map<String, dynamic>>()
            .map(Article.fromJson)
            .toList()
        : <Article>[];
    final last = data['last'] == true || items.isEmpty;
    return (items: items, hasMore: !last);
  }

  Future<List<Article>> getArticles({int page = 0, int size = 12}) async {
    final result = await search(const ArticleQuery(), page: page, size: size);
    return result.items;
  }

  /// Arama/filtre — `GET /knowledge/search` (filtresiz çağrıda yayınlanmış
  /// makalelerin tamamını tarih sırasıyla döner).
  Future<ArticlePage> search(
    ArticleQuery query, {
    int page = 0,
    int size = 12,
  }) async {
    try {
      final res = await _dio.get(
        '/knowledge/search',
        queryParameters: query.toQueryParameters(page: page, size: size),
      );
      return _pageFrom(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Tek makale (tam içerik + yazar + görüntülenme + yer imi durumu).
  Future<Article> getArticle(String id) async {
    try {
      final res = await _dio.get('/knowledge/$id');
      return Article.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<List<Article>> _list(String path) async {
    try {
      final res = await _dio.get(path);
      return ApiEnvelope.fromJson(res.data)
          .requireList()
          .whereType<Map<String, dynamic>>()
          .map(Article.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Kullanıcının ilgi alanlarına göre öneriler.
  Future<List<Article>> getRecommendations() =>
      _list('/knowledge/recommendations');

  /// Yer imine eklenen makaleler.
  Future<List<Article>> getBookmarks() => _list('/knowledge/bookmarks');

  /// Aynı kategori/etiketlerden ilgili makaleler.
  Future<List<Article>> getRelated(String id) =>
      _list('/knowledge/$id/related');

  /// Yer imini aç/kapat — yeni durumu döner.
  Future<bool> toggleBookmark(String id) async {
    try {
      final res = await _dio.post('/knowledge/$id/bookmark');
      return ApiEnvelope.fromJson(res.data).data == true;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<List<ArticleComment>> getComments(
    String articleId, {
    int page = 0,
    int size = 20,
  }) async {
    try {
      final res = await _dio.get(
        '/knowledge/$articleId/comments',
        queryParameters: {'page': page, 'size': size},
      );
      final data = ApiEnvelope.fromJson(res.data).requireMap();
      final content = data['content'];
      if (content is! List) return const [];
      return content
          .whereType<Map<String, dynamic>>()
          .map(ArticleComment.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Yorum ekler. Web'deki "deneyim" alanları gönderilmez: backend DTO'su
  /// `isExperience` alanını Jackson'a `experience` adıyla açtığı için web'in
  /// gönderdiği bayrak sunucuda karşılık bulmuyor — mobil düz yorum yazar.
  Future<ArticleComment> addComment(String articleId, String content) async {
    try {
      final res = await _dio.post(
        '/knowledge/$articleId/comments',
        data: {'content': content.trim()},
      );
      return ArticleComment.fromJson(
        ApiEnvelope.fromJson(res.data).requireMap(),
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final knowledgeRepositoryProvider = Provider<KnowledgeRepository>((ref) {
  return KnowledgeRepository(ref.watch(dioProvider));
});

/// Ana sayfada önerilen makaleler (ilk sayfa).
final recommendedArticlesProvider = FutureProvider<List<Article>>((ref) {
  return ref.watch(knowledgeRepositoryProvider).getArticles(size: 6);
});

/// Tek makale (id'ye göre).
final articleProvider = FutureProvider.family<Article, String>((ref, id) {
  return ref.watch(knowledgeRepositoryProvider).getArticle(id);
});

/// Makalenin ilgili içerikleri.
final relatedArticlesProvider =
    FutureProvider.family<List<Article>, String>((ref, id) {
  return ref.watch(knowledgeRepositoryProvider).getRelated(id);
});

/// Makale yorumları (ilk sayfa).
final articleCommentsProvider =
    FutureProvider.family<List<ArticleComment>, String>((ref, id) {
  return ref.watch(knowledgeRepositoryProvider).getComments(id);
});

/// Yer imine eklenen makaleler.
final bookmarkedArticlesProvider = FutureProvider<List<Article>>((ref) {
  return ref.watch(knowledgeRepositoryProvider).getBookmarks();
});
