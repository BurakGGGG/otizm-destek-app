import 'package:dio/dio.dart';

import '../config/env.dart';
import '../storage/secure_storage.dart';
import 'api_response.dart';
import 'auth_cookies.dart';

/// Yenilenmesi anlamsız olan (token'sız çalışan) auth uç noktaları.
/// `/auth/me` bilinçli olarak listede değil: uygulama açılışında süresi dolmuş
/// access token'la çağrıldığında oturum yenilenip geri yüklenebilmeli.
const _noRetryAuthPaths = {
  '/auth/login',
  '/auth/register',
  '/auth/refresh',
  '/auth/logout',
  '/auth/forgot-password',
  '/auth/reset-password',
  '/auth/verify-email',
  '/auth/resend-verification',
  '/auth/check-email',
};

/// 401 alındığında refresh token ile yeni access token alıp isteği tekrar dener.
///
/// [QueuedInterceptor] sayesinde eşzamanlı 401'ler tek bir yenileme tetikler.
class RefreshInterceptor extends QueuedInterceptor {
  RefreshInterceptor({required this.storage, required this.onSessionExpired})
    : _refreshDio = Dio(
        BaseOptions(
          baseUrl: Env.apiBase,
          connectTimeout: Env.connectTimeout,
          receiveTimeout: Env.receiveTimeout,
        ),
      );

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
    final isNoRetryCall = _noRetryAuthPaths.any(options.path.startsWith);
    final alreadyRetried = options.extra['retried'] == true;

    if (err.response?.statusCode != 401 || isNoRetryCall || alreadyRetried) {
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
      final bodyRefresh = data['refreshToken'] as String?;

      if (newAccess == null || newAccess.isEmpty) {
        await _expire();
        return handler.next(err);
      }

      // Refresh token'lar tek kullanımlıktır ve her yenilemede rotasyona
      // girer; yenisi gövdede değil `Set-Cookie` başlığında döner. Yeni token
      // okunamazsa eskisini saklamak yerine temizleriz: kullanılmış token'ın
      // tekrar gönderilmesi sunucuda kullanıcının TÜM oturumlarını iptal eder.
      final newRefresh = (bodyRefresh != null && bodyRefresh.isNotEmpty)
          ? bodyRefresh
          : refreshTokenFromHeaders(res.headers) ?? '';

      await storage.saveTokens(
        accessToken: newAccess,
        refreshToken: newRefresh,
      );

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
