import 'package:dio/dio.dart';

import '../config/env.dart';
import '../storage/secure_storage.dart';
import 'api_response.dart';

/// 401 alındığında refresh token ile yeni access token alıp isteği tekrar dener.
///
/// [QueuedInterceptor] sayesinde eşzamanlı 401'ler tek bir yenileme tetikler.
class RefreshInterceptor extends QueuedInterceptor {
  RefreshInterceptor({
    required this.storage,
    required this.onSessionExpired,
  }) : _refreshDio = Dio(BaseOptions(
          baseUrl: Env.apiBase,
          connectTimeout: Env.connectTimeout,
          receiveTimeout: Env.receiveTimeout,
        ));

  final SecureStorage storage;

  /// Yenileme başarısızsa (oturum gerçekten bitti) çağrılır.
  final Future<void> Function() onSessionExpired;

  final Dio _refreshDio;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final isAuthCall = options.path.contains('/auth/');
    final alreadyRetried = options.extra['retried'] == true;

    if (err.response?.statusCode != 401 || isAuthCall || alreadyRetried) {
      return handler.next(err);
    }

    final refreshToken = await storage.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      await _expire();
      return handler.next(err);
    }

    try {
      final res = await _refreshDio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );
      final data = ApiEnvelope.fromJson(res.data).requireMap();
      final newAccess = data['accessToken'] as String?;
      final newRefresh = data['refreshToken'] as String?;

      if (newAccess == null || newAccess.isEmpty) {
        await _expire();
        return handler.next(err);
      }

      await storage.saveTokens(accessToken: newAccess, refreshToken: newRefresh);

      // Orijinal isteği yeni token ile tekrar dene.
      options.extra['retried'] = true;
      options.headers['Authorization'] = 'Bearer $newAccess';
      final clone = await _refreshDio.fetch<dynamic>(options);
      return handler.resolve(clone);
    } catch (_) {
      await _expire();
      return handler.next(err);
    }
  }

  Future<void> _expire() async {
    await storage.clear();
    await onSessionExpired();
  }
}
