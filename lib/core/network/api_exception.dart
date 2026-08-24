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
        return ApiException(
          safeServerMessage(serverMsg, statusCode: code) ?? fallback,
          statusCode: code,
        );
      case DioExceptionType.cancel:
        return ApiException(t.errors.cancelled);
      default:
        // `e.message` istek adresini ve host'u içerebiliyor; kullanıcıya
        // gösterilecek metin sunucu altyapısını anlatmamalı.
        return ApiException(t.errors.unexpected);
    }
  }

  /// Sunucudan gelen metni kullanıcıya göstermeden önce süzer.
  ///
  /// Backend'in kendi yazdığı kısa Türkçe mesajlar (ör. "Bu e-posta adresi
  /// zaten kullanılıyor") olduğu gibi geçer. 5xx yanıtlarında ve yığın izi /
  /// SQL / sınıf adı gibi iç ayrıntı taşıyan metinlerde `null` döner; çağıran
  /// genel mesaja düşer. Amaç, bir gün ham istisna metni dönen bir uç noktanın
  /// altyapıyı kullanıcı ekranında ifşa etmemesi.
  static String? safeServerMessage(String? raw, {int? statusCode}) {
    final message = raw?.trim();
    if (message == null || message.isEmpty) return null;
    // Sunucu hatasında metin ne olursa olsun gösterilmez.
    if (statusCode != null && statusCode >= 500) return null;
    // Kullanıcıya gösterilecek bir uyarı kısa olur; uzun metin genelde
    // yığın izi ya da HTML hata sayfasıdır.
    if (message.length > 300) return null;
    if (_internalDetail.hasMatch(message)) return null;
    return message;
  }

  /// İç ayrıntı işaretleri: istisna/paket adları, yığın izi, SQL, HTML.
  static final RegExp _internalDetail = RegExp(
    r'(Exception|Throwable|Caused by|\bat [a-z]+\.[a-z]+\.|java\.|jakarta\.|'
    r'org\.springframework|com\.autismsupport|SQLSTATE|\bSELECT\b.*\bFROM\b|'
    r'<html|<!DOCTYPE)',
    caseSensitive: false,
  );

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
