import 'package:dio/dio.dart';

import '../../i18n/strings.g.dart';

/// UI katmanının tüketebileceği, kullanıcı dostu hata modeli.
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode, this.isNetwork = false});

  final String message;
  final int? statusCode;
  final bool isNetwork;

  bool get isUnauthorized => statusCode == 401;

  /// Sunucu hız sınırı (HTTP 429) — arayüz bekleme süresi gösterebilir.
  bool get isRateLimited => statusCode == 429;

  @override
  String toString() => 'ApiException($statusCode): $message';

  /// Dio hatasını anlaşılır bir [ApiException]'a çevirir.
  factory ApiException.fromDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(t.errors.timeout, isNetwork: true);
      case DioExceptionType.connectionError:
        return ApiException(t.errors.noConnection, isNetwork: true);
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        final serverMsg = _extractMessage(e.response?.data);
        // Backend kullanıcı dostu mesaj döndürdüyse onu göster; 429'da
        // gövde boş gelirse genel "hata (429)" yerine anlaşılır metin.
        final fallback = code == 429
            ? t.errors.tooManyRequests
            : t.errors.generic(code: code?.toString() ?? '?');
        return ApiException(serverMsg ?? fallback, statusCode: code);
      case DioExceptionType.cancel:
        return ApiException(t.errors.cancelled);
      default:
        return ApiException(e.message ?? t.errors.unexpected);
    }
  }

  static String? _extractMessage(dynamic data) {
    if (data is Map) {
      for (final key in ['message', 'error', 'detail']) {
        final v = data[key];
        if (v is String && v.isNotEmpty) return v;
      }
    }
    return null;
  }
}
