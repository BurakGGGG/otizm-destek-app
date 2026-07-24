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

  /// Jeton listesini günceller — `PUT /goals/{goalId}`. Backend doğrulaması
  /// title + category zorunlu tuttuğu için mevcut değerler birlikte gönderilir;
  /// `entries` gerçek JSON dizisi olarak gider (string değil).
  Future<Goal> updateEntries(
    Goal goal,
    List<Map<String, dynamic>> entries,
  ) async {
    try {
      final res = await _dio.put('/goals/${goal.id}', data: {
        'title': goal.title,
        'category': goal.category ?? 'Genel',
        'entries': entries,
      });
      return Goal.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Bir jeton ekler (+1 ilerleme).
  Future<Goal> addToken(Goal goal) {
    return updateEntries(goal, [
      ...goal.entries,
      {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'date': DateTime.now().toIso8601String(),
        'achieved': true,
      },
    ]);
  }

  /// Son jetonu geri alır (yanlış dokunma için).
  Future<Goal> removeLastToken(Goal goal) {
    if (goal.entries.isEmpty) return Future.value(goal);
    return updateEntries(
      goal,
      goal.entries.sublist(0, goal.entries.length - 1),
    );
  }
}

final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  return GoalRepository(ref.watch(dioProvider));
});

/// Belirli bir çocuğun hedefleri.
final goalsProvider = FutureProvider.family<List<Goal>, String>((ref, childId) {
  return ref.watch(goalRepositoryProvider).getGoals(childId);
});
