import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/providers.dart';
import '../domain/expert.dart';

/// `/api/experts` uç noktasını saran depo.
class ExpertRepository {
  ExpertRepository(this._dio);
  final Dio _dio;

  Future<List<Expert>> getExperts({
    String? city,
    String? specialization,
  }) async {
    try {
      final res = await _dio.get(
        '/experts',
        queryParameters: {'city': ?city, 'specialization': ?specialization},
      );
      return ApiEnvelope.fromJson(res.data)
          .requireList()
          .whereType<Map<String, dynamic>>()
          .map(Expert.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final expertRepositoryProvider = Provider<ExpertRepository>((ref) {
  return ExpertRepository(ref.watch(dioProvider));
});

/// Tüm uzmanlar (filtreleme istemci tarafında yapılır).
final expertsProvider = FutureProvider<List<Expert>>((ref) {
  return ref.watch(expertRepositoryProvider).getExperts();
});
