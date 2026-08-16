import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/providers.dart';
import '../domain/expert.dart';
import '../domain/expert_review.dart';

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

  /// Uzmanın değerlendirmeleri + ortalama puan.
  Future<ExpertReviewSummary> getReviews(String expertId) async {
    try {
      final res = await _dio.get('/experts/$expertId/reviews');
      return ExpertReviewSummary.fromJson(
        ApiEnvelope.fromJson(res.data).requireMap(),
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Değerlendirme yazar/günceller — backend aynı kullanıcı için tek kayıt
  /// tutar, ikinci gönderim mevcut puanı günceller.
  Future<ExpertReview> submitReview(
    String expertId, {
    required int rating,
    String? comment,
  }) async {
    try {
      final res = await _dio.post(
        '/experts/$expertId/reviews',
        data: {
          'rating': rating,
          'comment': (comment ?? '').trim().isEmpty ? null : comment!.trim(),
        },
      );
      return ExpertReview.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Kendi değerlendirmesini siler (backend sahiplik kontrolü yapıyor).
  Future<void> deleteReview(String expertId, String reviewId) async {
    try {
      await _dio.delete('/experts/$expertId/reviews/$reviewId');
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

/// Bir uzmanın değerlendirmeleri.
final expertReviewsProvider =
    FutureProvider.family<ExpertReviewSummary, String>((ref, expertId) {
  return ref.watch(expertRepositoryProvider).getReviews(expertId);
});
