import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/providers.dart';
import '../domain/buddy.dart';

/// Buddy/Mentor deposu — `/api/buddies` (aile bağlantı istekleri ve çember).
class BuddyRepository {
  BuddyRepository(this._dio);
  final Dio _dio;

  /// Bir aileye buddy (veya mentor) bağlantı isteği gönderir.
  Future<void> sendRequest(
    String receiverId, {
    required bool isMentorRequest,
    String? message,
  }) async {
    try {
      await _dio.post('/buddies/request', data: {
        'receiverId': receiverId,
        'isMentorRequest': isMentorRequest,
        'message': ?(message == null || message.trim().isEmpty
            ? null
            : message.trim()),
      });
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Kabul edilmiş bağlantılar (arkadaşlar + mentorlar).
  Future<List<Buddy>> getMyBuddies() => _list('/buddies/my-list');

  /// Kullanıcıya gelen, yanıt bekleyen istekler.
  Future<List<Buddy>> getPendingRequests() => _list('/buddies/pending');

  Future<List<Buddy>> _list(String path) async {
    try {
      final res = await _dio.get(path);
      return ApiEnvelope.fromJson(res.data)
          .requireList()
          .whereType<Map<String, dynamic>>()
          .map(Buddy.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Gelen isteği kabul eder.
  Future<void> accept(String relationshipId) =>
      _post('/buddies/accept/$relationshipId');

  /// Gelen isteği reddeder.
  Future<void> reject(String relationshipId) =>
      _post('/buddies/reject/$relationshipId');

  /// Kurulmuş bağlantıyı kaldırır.
  Future<void> remove(String relationshipId) =>
      _delete('/buddies/remove/$relationshipId');

  /// Gönderilmiş ama henüz yanıtlanmamış isteği geri çeker.
  Future<void> withdraw(String relationshipId) =>
      _delete('/buddies/request/$relationshipId');

  Future<void> _post(String path) async {
    try {
      await _dio.post(path);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> _delete(String path) async {
    try {
      await _dio.delete(path);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final buddyRepositoryProvider = Provider<BuddyRepository>((ref) {
  return BuddyRepository(ref.watch(dioProvider));
});

/// Kabul edilmiş bağlantılar ("Çemberim").
final myBuddiesProvider = FutureProvider<List<Buddy>>((ref) {
  return ref.watch(buddyRepositoryProvider).getMyBuddies();
});

/// Gelen bekleyen bağlantı istekleri.
final pendingBuddiesProvider = FutureProvider<List<Buddy>>((ref) {
  return ref.watch(buddyRepositoryProvider).getPendingRequests();
});
