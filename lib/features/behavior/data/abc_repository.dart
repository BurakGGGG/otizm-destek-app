import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/providers.dart';
import '../domain/abc_entry.dart';

/// `/api/abc-entries` uç noktasını saran depo (davranış günlüğü).
class AbcRepository {
  AbcRepository(this._dio);
  final Dio _dio;

  Future<List<AbcEntry>> getByChild(String childId) async {
    try {
      final res = await _dio.get('/abc-entries/child/$childId');
      return ApiEnvelope.fromJson(res.data)
          .requireList()
          .whereType<Map<String, dynamic>>()
          .map(AbcEntry.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Not: DB'de category ve location NOT NULL — boş gönderilmemeli.
  Future<AbcEntry> create({
    required String childId,
    required String entryDate,
    required String entryTime,
    required String antecedent,
    required String behavior,
    required String consequence,
    required int intensity,
    required String category,
    required String location,
    String? notes,
  }) async {
    try {
      final res = await _dio.post(
        '/abc-entries',
        data: {
          'childId': childId,
          'entryDate': entryDate,
          'entryTime': entryTime,
          'antecedent': antecedent,
          'behavior': behavior,
          'consequence': consequence,
          'intensity': intensity,
          'category': category,
          'location': location,
          if (notes != null && notes.trim().isNotEmpty) 'notes': notes.trim(),
        },
      );
      return AbcEntry.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> delete(String id) async {
    try {
      await _dio.delete('/abc-entries/$id');
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final abcRepositoryProvider = Provider<AbcRepository>((ref) {
  return AbcRepository(ref.watch(dioProvider));
});

/// Çocuğun ABC kayıtları (backend tarih+saat azalan sıralı döner).
final abcEntriesProvider =
    FutureProvider.family<List<AbcEntry>, String>((ref, childId) {
  return ref.watch(abcRepositoryProvider).getByChild(childId);
});
