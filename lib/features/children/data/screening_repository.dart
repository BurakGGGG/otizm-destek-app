import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/providers.dart';
import '../domain/screening_result.dart';

/// `/api/screening` deposu — çocuk bazlı tarama sonuçları (salt okunur).
class ScreeningRepository {
  ScreeningRepository(this._dio);
  final Dio _dio;

  Future<List<ScreeningResult>> getByChild(String childId) async {
    try {
      final res = await _dio.get('/screening/child/$childId');
      return ApiEnvelope.fromJson(res.data)
          .requireList()
          .whereType<Map<String, dynamic>>()
          .map(ScreeningResult.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final screeningRepositoryProvider = Provider<ScreeningRepository>((ref) {
  return ScreeningRepository(ref.watch(dioProvider));
});

/// Çocuğun tarama sonuçları (yeniden eskiye).
final screeningResultsProvider =
    FutureProvider.family<List<ScreeningResult>, String>((ref, childId) async {
  final results =
      await ref.watch(screeningRepositoryProvider).getByChild(childId);
  results.sort((a, b) => (b.createdAt ?? DateTime(0))
      .compareTo(a.createdAt ?? DateTime(0)));
  return results;
});
