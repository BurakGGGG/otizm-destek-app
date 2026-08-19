import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/providers.dart';
import '../domain/search_result.dart';

/// `GET /api/search` — forum gönderileri, makaleler, gruplar ve uzmanlar
/// arasında tek sorguda arama (web sidebar'daki komut paleti ile aynı uç).
class SearchRepository {
  SearchRepository(this._dio);
  final Dio _dio;

  Future<List<SearchResult>> search(String query, {String? type}) async {
    final q = query.trim();
    if (q.isEmpty) return const [];
    try {
      final res = await _dio.get('/search', queryParameters: {
        'q': q,
        'type': ?type,
      });
      return ApiEnvelope.fromJson(res.data)
          .requireList()
          .whereType<Map<String, dynamic>>()
          .map(SearchResult.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepository(ref.watch(dioProvider));
});
