import 'package:dio/dio.dart';

/// Geçerli kimlik token'ını sağlayan callback.
///
/// Faz 2'de Firebase Auth'a bağlanacak:
///   `() => FirebaseAuth.instance.currentUser?.getIdToken()`
/// Şimdilik güvenli depodaki token'ı döndürebilir.
typedef TokenProvider = Future<String?> Function();

/// Her isteğe `Authorization: Bearer <token>` ekler.
///
/// Backend, mobil için Firebase ID token'larını doğrulayacak şekilde
/// genişletilecek (bkz. plan: FirebaseTokenAuthFilter).
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenProvider);

  final TokenProvider _tokenProvider;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Auth uç noktaları token gerektirmez.
    final skipAuth = options.extra['skipAuth'] == true;
    if (!skipAuth) {
      final token = await _tokenProvider();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }
}
