import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/providers.dart';
import '../../auth/domain/app_user.dart';

/// Kullanıcı engelleme — `/api/users/{id}/block` ve `/api/users/me/blocked`.
///
/// Web engellemeyi yalnızca "benzer aileler" sohbet çekmecesinde sunuyor ve
/// engeli kaldırma arayüzü yok; mobilde engelleme mesaj başlığından yapılır,
/// liste ve kaldırma Ayarlar > Gizlilik altında (aynı uç noktalar).
class BlockRepository {
  BlockRepository(this._dio);
  final Dio _dio;

  Future<void> block(String userId) async {
    try {
      await _dio.post('/users/$userId/block');
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> unblock(String userId) async {
    try {
      await _dio.delete('/users/$userId/block');
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<List<AppUser>> getBlocked() async {
    try {
      final res = await _dio.get('/users/me/blocked');
      final data = ApiEnvelope.fromJson(res.data).data;
      return data is List
          ? data
              .whereType<Map<String, dynamic>>()
              .map(AppUser.fromJson)
              .toList()
          : const [];
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final blockRepositoryProvider = Provider<BlockRepository>((ref) {
  return BlockRepository(ref.watch(dioProvider));
});

/// Engellenen kullanıcılar.
final blockedUsersProvider = FutureProvider<List<AppUser>>((ref) {
  return ref.watch(blockRepositoryProvider).getBlocked();
});
