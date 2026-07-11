import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/providers.dart';
import '../domain/expert_task.dart';

/// Uzman ödevleri deposu — `/api/patients/my-tasks` + `/api/task-submissions`.
/// Veli rolünde `my-tasks` veliye atanan görevleri döner; teslim POST'u görevi
/// COMPLETED yapar ve uzmana bildirim gönderir (backend tarafında).
class TasksRepository {
  TasksRepository(this._dio);
  final Dio _dio;

  Future<List<ExpertTask>> getMyTasks() async {
    try {
      final res = await _dio.get('/patients/my-tasks');
      return ApiEnvelope.fromJson(res.data)
          .requireList()
          .whereType<Map<String, dynamic>>()
          .map(ExpertTask.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Görevi teslim eder — `POST /task-submissions`
  /// `{taskId, parentId, parentNote, evidenceUrl}` (web `submitTask` birebir).
  Future<TaskSubmission> submitTask({
    required String taskId,
    required String parentId,
    String? note,
    String? evidenceUrl,
  }) async {
    try {
      final res = await _dio.post('/task-submissions', data: {
        'taskId': taskId,
        'parentId': parentId,
        'parentNote': (note ?? '').trim().isEmpty ? null : note!.trim(),
        'evidenceUrl':
            (evidenceUrl ?? '').trim().isEmpty ? null : evidenceUrl!.trim(),
      });
      return TaskSubmission.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Görevin teslim kayıtları (veli notu + uzman geri bildirimi).
  Future<List<TaskSubmission>> getSubmissions(String taskId) async {
    try {
      final res = await _dio.get('/task-submissions/task/$taskId');
      return ApiEnvelope.fromJson(res.data)
          .requireList()
          .whereType<Map<String, dynamic>>()
          .map(TaskSubmission.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final tasksRepositoryProvider = Provider<TasksRepository>((ref) {
  return TasksRepository(ref.watch(dioProvider));
});

/// Veliye atanan tüm görevler.
final myTasksProvider = FutureProvider<List<ExpertTask>>((ref) {
  return ref.watch(tasksRepositoryProvider).getMyTasks();
});

/// Bir görevin teslim kayıtları.
final taskSubmissionsProvider =
    FutureProvider.family<List<TaskSubmission>, String>((ref, taskId) {
  return ref.watch(tasksRepositoryProvider).getSubmissions(taskId);
});
