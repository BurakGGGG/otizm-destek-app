import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/providers.dart';

/// Buddy/Mentor deposu — `/api/buddies` (aile bağlantı istekleri).
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
}

final buddyRepositoryProvider = Provider<BuddyRepository>((ref) {
  return BuddyRepository(ref.watch(dioProvider));
});
