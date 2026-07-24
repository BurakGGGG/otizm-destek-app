import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/providers.dart';
import '../domain/similar_family.dart';

/// Eşleştirme deposu — `/api/matching` (benzer aileler + keşfedilebilirlik).
class MatchingRepository {
  MatchingRepository(this._dio);
  final Dio _dio;

  Future<List<SimilarFamily>> findSimilarFamilies(String childId) async {
    try {
      final res = await _dio.get('/matching/similar/$childId');
      return ApiEnvelope.fromJson(res.data)
          .requireList()
          .whereType<Map<String, dynamic>>()
          .map(SimilarFamily.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Eşleştirme (keşfedilebilirlik) açık mı.
  Future<bool> getMatchingStatus() async {
    try {
      final res = await _dio.get('/matching/status');
      return ApiEnvelope.fromJson(res.data).data == true;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Eşleştirmeyi aç-kapa; yeni durumu (açık mı) döner.
  Future<bool> toggleMatching() async {
    try {
      final res = await _dio.put('/matching/opt-out');
      return ApiEnvelope.fromJson(res.data).data == true;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final matchingRepositoryProvider = Provider<MatchingRepository>((ref) {
  return MatchingRepository(ref.watch(dioProvider));
});

/// Kullanıcının eşleştirmede keşfedilebilir olup olmadığı.
final matchingStatusProvider = FutureProvider<bool>((ref) {
  return ref.watch(matchingRepositoryProvider).getMatchingStatus();
});

/// Seçili çocuğa benzer aileler.
final similarFamiliesProvider =
    FutureProvider.family<List<SimilarFamily>, String>((ref, childId) {
  return ref.watch(matchingRepositoryProvider).findSimilarFamilies(childId);
});
