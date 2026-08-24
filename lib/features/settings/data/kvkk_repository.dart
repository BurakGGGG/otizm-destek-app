import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/providers.dart';
import '../../auth/domain/app_user.dart';
import '../domain/kvkk.dart';

/// KVKK rızaları ve veri sahibi başvuruları
/// (`/api/users/me/consents*`, `/api/kvkk/requests`).
class KvkkRepository {
  KvkkRepository(this._dio);

  final Dio _dio;

  Future<ConsentOverview> getConsents() async {
    try {
      final res = await _dio.get('/users/me/consents');
      return ConsentOverview.fromJson(
        ApiEnvelope.fromJson(res.data).requireMap(),
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Rıza durumunu değiştirir; güncel kullanıcıyı döner.
  Future<AppUser> setConsent(String type, bool consent) async {
    try {
      final res = await _dio.post(
        '/users/me/consents/$type',
        queryParameters: {'consent': consent},
      );
      return AppUser.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Aydınlatma metni güncellendiğinde yeniden rıza verir.
  Future<AppUser> reconsent() async {
    try {
      final res = await _dio.post('/users/me/consents/reconsent');
      return AppUser.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<List<KvkkRequest>> myRequests() async {
    try {
      final res = await _dio.get('/kvkk/requests');
      return ApiEnvelope.fromJson(res.data)
          .requireList()
          .whereType<Map<String, dynamic>>()
          .map(KvkkRequest.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<KvkkRequest> createRequest({
    required String requestType,
    required String description,
    String? contactEmail,
  }) async {
    try {
      final res = await _dio.post(
        '/kvkk/requests',
        data: {
          'requestType': requestType,
          'description': description,
          'contactEmail': ?contactEmail,
        },
      );
      return KvkkRequest.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final kvkkRepositoryProvider = Provider<KvkkRepository>((ref) {
  return KvkkRepository(ref.watch(dioProvider));
});

final consentOverviewProvider = FutureProvider<ConsentOverview>((ref) {
  return ref.watch(kvkkRepositoryProvider).getConsents();
});

final kvkkRequestsProvider = FutureProvider<List<KvkkRequest>>((ref) {
  return ref.watch(kvkkRepositoryProvider).myRequests();
});
