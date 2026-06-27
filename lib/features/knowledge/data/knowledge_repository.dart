import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/providers.dart';
import '../domain/article.dart';

/// `/api/knowledge` uç noktasını saran depo (yayınlanmış makaleler, sayfalı).
class KnowledgeRepository {
  KnowledgeRepository(this._dio);
  final Dio _dio;

  Future<List<Article>> getArticles({int page = 0, int size = 12}) async {
    try {
      final res = await _dio.get(
        '/knowledge',
        queryParameters: {'page': page, 'size': size},
      );
      // Yanıt bir Spring Page: data.content listeyi içerir.
      final pageData = ApiEnvelope.fromJson(res.data).requireMap();
      final content = pageData['content'];
      if (content is! List) return const [];
      return content
          .whereType<Map<String, dynamic>>()
          .map(Article.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Tek makale (tam içerik + yazar + görüntülenme).
  Future<Article> getArticle(String id) async {
    try {
      final res = await _dio.get('/knowledge/$id');
      return Article.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
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

/// Bilgi bankası liste ekranı (ilk sayfa, daha geniş).
final articlesProvider = FutureProvider<List<Article>>((ref) {
  return ref.watch(knowledgeRepositoryProvider).getArticles(size: 20);
});

/// Tek makale (id'ye göre).
final articleProvider = FutureProvider.family<Article, String>((ref, id) {
  return ref.watch(knowledgeRepositoryProvider).getArticle(id);
});
