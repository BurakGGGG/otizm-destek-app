import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/providers.dart';
import '../domain/treatment_state.dart';

/// Tedavi durumu deposu — `/api/treatment-state/{childId}`.
///
/// DİKKAT: Bu uç diğerlerinden farklı olarak `{success,message,data}` zarfı
/// KULLANMAZ — ham `TreatmentStateDto` döner (web `treatmentStateService`
/// birebir). Kilometre taşı ucu (`/api/milestones`) ise zarflıdır.
class TreatmentRepository {
  TreatmentRepository(this._dio);
  final Dio _dio;

  Future<TreatmentPageState> getState(String childId) async {
    try {
      final res = await _dio.get('/treatment-state/$childId');
      final data = res.data;
      return TreatmentPageState.fromJson(
        data is Map ? Map<String, dynamic>.from(data) : const {},
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Tam durumu yazar (web gibi: 90 günden eski oyun kayıtları budanır).
  Future<TreatmentPageState> saveState(
    String childId,
    TreatmentPageState state,
  ) async {
    final pruned =
        state.copyWith(gameSessions: pruneOldSessions(state.gameSessions));
    try {
      await _dio.put('/treatment-state/$childId', data: pruned.toJson());
      return pruned;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Büyük başarı (kilometre taşı) hızlı kaydı — `POST /api/milestones`.
  Future<void> createMilestone({
    required String childId,
    required String title,
    required String category,
  }) async {
    try {
      final res = await _dio.post('/milestones', data: {
        'childId': childId,
        'title': title.trim(),
        'category': category,
      });
      ApiEnvelope.fromJson(res.data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final treatmentRepositoryProvider = Provider<TreatmentRepository>((ref) {
  return TreatmentRepository(ref.watch(dioProvider));
});

/// Çocuğa ait tedavi durumu blob'u.
final treatmentStateProvider =
    FutureProvider.family<TreatmentPageState, String>((ref, childId) {
  return ref.watch(treatmentRepositoryProvider).getState(childId);
});
