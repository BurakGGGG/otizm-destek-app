import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/providers.dart';
import '../domain/mood_entry.dart';

/// `/api/mood` uç noktalarını saran depo.
class MoodRepository {
  MoodRepository(this._dio);
  final Dio _dio;

  Future<List<MoodEntry>> getEntries(String childId) async {
    try {
      final res = await _dio.get('/mood/child/$childId');
      return ApiEnvelope.fromJson(res.data)
          .requireList()
          .whereType<Map<String, dynamic>>()
          .map(MoodEntry.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Aynı çocuk + gün için kayıt varsa backend günceller (upsert).
  Future<MoodEntry> upsert({
    required String childId,
    required String entryDate,
    required int moodLevel,
    String? notes,
    List<String> triggers = const [],
  }) async {
    try {
      final res = await _dio.post('/mood', data: {
        'childId': childId,
        'entryDate': entryDate,
        'moodLevel': moodLevel,
        if (notes != null && notes.trim().isNotEmpty) 'notes': notes.trim(),
        'triggers': triggers,
      });
      return MoodEntry.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> delete(String entryId) async {
    try {
      await _dio.delete('/mood/$entryId');
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final moodRepositoryProvider = Provider<MoodRepository>((ref) {
  return MoodRepository(ref.watch(dioProvider));
});

/// Belirli bir çocuğun ruh hali kayıtları (yeniden eskiye).
final moodEntriesProvider =
    FutureProvider.family<List<MoodEntry>, String>((ref, childId) async {
  final entries =
      await ref.watch(moodRepositoryProvider).getEntries(childId);
  entries.sort((a, b) => b.entryDate.compareTo(a.entryDate));
  return entries;
});
