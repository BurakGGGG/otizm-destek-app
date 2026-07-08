import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/providers.dart';
import '../domain/sleep_entry.dart';

/// `/api/sleep` uç noktasını saran depo (gün başına upsert).
class SleepRepository {
  SleepRepository(this._dio);
  final Dio _dio;

  Future<List<SleepEntry>> getEntries(String childId) async {
    try {
      final res = await _dio.get('/sleep/child/$childId');
      return ApiEnvelope.fromJson(res.data)
          .requireList()
          .whereType<Map<String, dynamic>>()
          .map(SleepEntry.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Gün başına tek kayıt: aynı tarihe ikinci gönderim mevcut kaydı günceller.
  Future<SleepEntry> upsert({
    required String childId,
    required String sleepDate,
    required String bedtime,
    required String wakeTime,
    required int quality,
    required int nightWakings,
    required String notes,
  }) async {
    try {
      final res = await _dio.post(
        '/sleep',
        data: {
          'childId': childId,
          'sleepDate': sleepDate,
          'bedtime': bedtime,
          'wakeTime': wakeTime,
          'quality': quality,
          'nightWakings': nightWakings,
          'notes': notes,
        },
      );
      return SleepEntry.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> delete(String id) async {
    try {
      await _dio.delete('/sleep/$id');
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final sleepRepositoryProvider = Provider<SleepRepository>((ref) {
  return SleepRepository(ref.watch(dioProvider));
});

/// Çocuğun uyku kayıtları (tarihe göre azalan).
final sleepEntriesProvider =
    FutureProvider.family<List<SleepEntry>, String>((ref, childId) async {
  final entries =
      await ref.watch(sleepRepositoryProvider).getEntries(childId);
  entries.sort((a, b) => b.sleepDate.compareTo(a.sleepDate));
  return entries;
});
