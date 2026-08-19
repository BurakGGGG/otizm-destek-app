import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/env.dart';
import '../storage/secure_storage.dart';
import 'auth_interceptor.dart';
import 'refresh_interceptor.dart';

/// Yapılandırılmış [Dio] örneği üretir.
///
/// Tüm özellikler bu istemciyi yeniden kullanır; özellik başına elle HTTP yazılmaz.
Dio buildDioClient({
  required TokenProvider tokenProvider,
  required SecureStorage storage,
  required Future<void> Function() onSessionExpired,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: Env.apiBase,
      connectTimeout: Env.connectTimeout,
      receiveTimeout: Env.receiveTimeout,
      contentType: 'application/json',
      headers: {'Accept': 'application/json'},
    ),
  );

  dio.interceptors.add(AuthInterceptor(tokenProvider));
  dio.interceptors.add(
    RefreshInterceptor(storage: storage, onSessionExpired: onSessionExpired),
  );

  if (Env.enableNetworkLogs) {
    // Gövde ve başlık loglanmaz: istek gövdeleri kişisel sağlık verisi ve
    // şifre taşıyor, başlıklar Bearer token taşıyor. Yöntem + yol + durum
    // kodu hata ayıklamak için yeterli.
    dio.interceptors.add(_MinimalLogInterceptor());
  }

  return dio;
}

/// Yalnızca yöntem, yol ve sonuç bilgisini yazar (gövde/başlık yok).
class _MinimalLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _log('→ ${options.method} ${options.path}');
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    _log(
      '← ${response.statusCode} '
      '${response.requestOptions.method} ${response.requestOptions.path}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _log(
      '✖ ${err.response?.statusCode ?? err.type.name} '
      '${err.requestOptions.method} ${err.requestOptions.path}',
    );
    handler.next(err);
  }
}

void _log(String message) {
  debugPrint('[DIO] $message');
}
