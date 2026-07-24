import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/providers.dart';
import '../domain/analytics_trends.dart';

/// `/api/analytics` uç noktalarını saran depo.
class AnalyticsRepository {
  AnalyticsRepository(this._dio);
  final Dio _dio;

  Future<AnalyticsTrends> getTrends(String childId, {int months = 6}) async {
    try {
      final res = await _dio.get(
        '/analytics/child/$childId/trends',
        queryParameters: {'months': months},
      );
      return AnalyticsTrends.fromJson(
          ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  return AnalyticsRepository(ref.watch(dioProvider));
});

/// Belirli bir çocuğun son 6 aylık gelişim trendleri.
final analyticsTrendsProvider =
    FutureProvider.family<AnalyticsTrends, String>((ref, childId) {
  return ref.watch(analyticsRepositoryProvider).getTrends(childId);
});
