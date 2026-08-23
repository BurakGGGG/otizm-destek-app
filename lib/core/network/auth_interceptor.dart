import 'package:dio/dio.dart';

/// Geçerli kimlik token'ını sağlayan callback.
typedef TokenProvider = Future<String?> Function();

/// İsteğe `Authorization: Bearer <token>` ekler — **yalnızca kendi
/// backend'imize giden isteklere**.
///
/// Host kontrolü savunma katmanıdır: bugün uygulama Dio'yu hep göreli yolla
/// (baseUrl = backend) çağırıyor, ama biri ileride mutlak bir dış adres
/// (ör. kullanıcının girdiği bir bağlantı) geçirirse token o host'a
/// sızmamalı. `allowedHost` verilmezse yalnızca göreli isteklere token eklenir.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenProvider, {this.allowedHost});

  final TokenProvider _tokenProvider;

  /// Token'ın gönderilebileceği tek host (backend). Genelde `Env` kök adresi.
  final String? allowedHost;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Auth uç noktaları token gerektirmez.
    final skipAuth = options.extra['skipAuth'] == true;
    if (!skipAuth && _isTrustedTarget(options)) {
      final token = await _tokenProvider();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  /// İstek kendi backend'imize mi gidiyor?
  ///
  /// Göreli yol (baseUrl'e çözülür) her zaman güvenli. Mutlak adreste host,
  /// izin verilen host'la birebir eşleşmeli — alt alan adı hilesi
  /// (`backend.example.com.evil.net`) geçmesin diye `endsWith` değil eşitlik.
  bool _isTrustedTarget(RequestOptions options) {
    final path = options.path;
    final isAbsolute =
        path.startsWith('http://') || path.startsWith('https://');
    if (!isAbsolute) return true;
    final host = allowedHost;
    if (host == null) return false;
    return Uri.tryParse(path)?.host == Uri.tryParse(host)?.host;
  }
}
