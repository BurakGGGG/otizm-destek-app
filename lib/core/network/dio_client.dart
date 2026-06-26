import 'package:dio/dio.dart';

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
    dio.interceptors.add(
      LogInterceptor(
        requestHeader: false,
        requestBody: true,
        responseBody: false,
        logPrint: (o) => _log(o.toString()),
      ),
    );
  }

  return dio;
}

void _log(String message) {
  // ignore: avoid_print
  print('[DIO] $message');
}
