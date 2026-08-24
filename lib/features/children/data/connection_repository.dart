import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/providers.dart';
import '../domain/expert_connection.dart';

/// Uzman erişim bağlantıları — veli tarafı (`/api/patients/connections/**`).
/// Tüm uç noktalar PARENT rolüne kısıtlıdır.
class ConnectionRepository {
  ConnectionRepository(this._dio);
  final Dio _dio;

  Future<List<ExpertConnection>> _list(String path) async {
    try {
      final res = await _dio.get(path);
      return ApiEnvelope.fromJson(res.data)
          .requireList()
          .whereType<Map<String, dynamic>>()
          .map(ExpertConnection.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Onay bekleyen uzman erişim istekleri.
  Future<List<ExpertConnection>> getRequests() =>
      _list('/patients/connections/requests');

  /// Erişimi onaylanmış (bağlı) uzmanlar.
  Future<List<ExpertConnection>> getActive() =>
      _list('/patients/connections/active');

  Future<void> _post(String path) async {
    try {
      await _dio.post(path);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> approve(String id) =>
      _post('/patients/connections/$id/approve');

  Future<void> reject(String id) => _post('/patients/connections/$id/reject');

  /// Onaylanmış erişimi geri alır (uzman artık çocuğun verisini göremez).
  Future<void> revoke(String id) => _post('/patients/connections/$id/revoke');
}

final connectionRepositoryProvider = Provider<ConnectionRepository>((ref) {
  return ConnectionRepository(ref.watch(dioProvider));
});

/// Bekleyen uzman erişim istekleri. Rol veli değilse (403) boş liste döner —
/// ana sayfadaki uyarı şeridi sessizce gizlenir.
final connectionRequestsProvider =
    FutureProvider<List<ExpertConnection>>((ref) async {
  try {
    return await ref.watch(connectionRepositoryProvider).getRequests();
  } on ApiException {
    return const [];
  }
});

/// Erişimi olan uzmanlar.
final activeConnectionsProvider =
    FutureProvider<List<ExpertConnection>>((ref) async {
  try {
    return await ref.watch(connectionRepositoryProvider).getActive();
  } on ApiException {
    return const [];
  }
});
