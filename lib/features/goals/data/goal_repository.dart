import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/providers.dart';
import '../domain/goal.dart';

/// `/api/goals` uç noktasını saran depo.
class GoalRepository {
  GoalRepository(this._dio);
  final Dio _dio;

  Future<List<Goal>> getGoals(String childId) async {
    try {
      final res = await _dio.get('/goals/child/$childId');
      return ApiEnvelope.fromJson(res.data)
          .requireList()
          .whereType<Map<String, dynamic>>()
          .map(Goal.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Yeni hedef oluştur — `POST /goals/child/{childId}`.
  Future<Goal> createGoal({
    required String childId,
    required String title,
    required String category,
    String? description,
    int? targetCount,
  }) async {
    try {
      final res = await _dio.post(
        '/goals/child/$childId',
        data: {
          'title': title.trim(),
          'category': category,
          if (description != null && description.trim().isNotEmpty)
            'description': description.trim(),
          'targetCount': ?targetCount,
        },
      );
      return Goal.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  return GoalRepository(ref.watch(dioProvider));
});

/// Belirli bir çocuğun hedefleri.
final goalsProvider = FutureProvider.family<List<Goal>, String>((ref, childId) {
  return ref.watch(goalRepositoryProvider).getGoals(childId);
});
