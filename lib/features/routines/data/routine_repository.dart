import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/providers.dart';
import '../domain/routine.dart';

/// `/api/routines` uç noktalarını saran depo.
class RoutineRepository {
  RoutineRepository(this._dio);
  final Dio _dio;

  Future<List<Routine>> getRoutines(String childId) async {
    try {
      final res = await _dio.get('/routines/child/$childId');
      return ApiEnvelope.fromJson(res.data)
          .requireList()
          .whereType<Map<String, dynamic>>()
          .map(Routine.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<Routine> createRoutine({
    required String childId,
    required String name,
    String? description,
  }) async {
    try {
      final res = await _dio.post('/routines', data: {
        'childId': childId,
        'name': name.trim(),
        if (description != null && description.trim().isNotEmpty)
          'description': description.trim(),
        'isActive': true,
      });
      return Routine.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> deleteRoutine(String routineId) async {
    try {
      await _dio.delete('/routines/$routineId');
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<RoutineItem> addItem(
    String routineId, {
    required String title,
    String? scheduledTime,
    String? iconName,
  }) async {
    try {
      final res = await _dio.post('/routines/$routineId/items', data: {
        'title': title.trim(),
        'scheduledTime': ?scheduledTime,
        'iconName': ?iconName,
      });
      return RoutineItem.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> deleteItem(String routineId, String itemId) async {
    try {
      await _dio.delete('/routines/$routineId/items/$itemId');
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final routineRepositoryProvider = Provider<RoutineRepository>((ref) {
  return RoutineRepository(ref.watch(dioProvider));
});

/// Belirli bir çocuğun aktif rutinleri.
final routinesProvider =
    FutureProvider.family<List<Routine>, String>((ref, childId) {
  return ref.watch(routineRepositoryProvider).getRoutines(childId);
});
