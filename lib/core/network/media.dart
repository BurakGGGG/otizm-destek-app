import 'dart:async';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../config/env.dart';

/// Backend'den gelen medya adreslerini görüntülenebilir hale getirir.
///
/// İki ayrı sorun çözülür:
/// 1. Yükleme uç noktası göreli adres döner (`/api/upload/dosya.jpg`); web
///    aynı origin'de çalıştığı için sorun yaşamaz, mobilde mutlaklaştırılmalı.
/// 2. `GET /api/upload/**` artık kimlik doğrulaması ister (SecurityConfig).
///    Web bunu httpOnly `media_session` çereziyle çözüyor; mobilde istek
///    Dio üzerinden (Bearer + 401'de yenileme) yapılmalı.

/// Göreli medya adresini mutlaklaştırır. Boşsa `null`, zaten mutlaksa aynen döner.
String? absoluteMediaUrl(String? raw) {
  final url = raw?.trim();
  if (url == null || url.isEmpty) return null;
  if (url.startsWith('http://') || url.startsWith('https://')) return url;
  if (url.startsWith('data:')) return url;
  return url.startsWith('/')
      ? '${Env.apiBaseUrl}$url'
      : '${Env.apiBaseUrl}/$url';
}

/// Adres kendi backend'imize mi ait? (Bearer token yalnızca ona gönderilir.)
bool isBackendMediaUrl(String? raw) {
  final url = raw?.trim();
  if (url == null || url.isEmpty) return false;
  if (url.startsWith('http://') || url.startsWith('https://')) {
    return url.startsWith(Env.apiBaseUrl);
  }
  return !url.startsWith('data:');
}

/// Adres için uygun görsel sağlayıcıyı üretir: kendi backend'imizse kimlik
/// doğrulamalı, değilse düz [NetworkImage]. Adres boşsa `null`.
ImageProvider? mediaImageProvider(String? raw, Dio dio) {
  final url = absoluteMediaUrl(raw);
  if (url == null) return null;
  return isBackendMediaUrl(raw) ? AuthedNetworkImage(url, dio) : NetworkImage(url);
}

/// Görseli Dio ile (Authorization başlığı + 401 yenileme) indiren sağlayıcı.
///
/// Flutter'ın [ImageCache]'i anahtar eşitliğine göre önbelleklediğinden aynı
/// adres tekrar indirilmez.
@immutable
class AuthedNetworkImage extends ImageProvider<AuthedNetworkImage> {
  const AuthedNetworkImage(this.url, this.dio, {this.scale = 1.0});

  final String url;
  final Dio dio;
  final double scale;

  @override
  Future<AuthedNetworkImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<AuthedNetworkImage>(this);
  }

  @override
  ImageStreamCompleter loadImage(
    AuthedNetworkImage key,
    ImageDecoderCallback decode,
  ) {
    return MultiFrameImageStreamCompleter(
      codec: _fetch(key, decode),
      scale: key.scale,
      debugLabel: key.url,
      informationCollector: () => [ErrorDescription('Görsel adresi: ${key.url}')],
    );
  }

  Future<ui.Codec> _fetch(
    AuthedNetworkImage key,
    ImageDecoderCallback decode,
  ) async {
    try {
      final res = await dio.get<List<int>>(
        key.url,
        options: Options(responseType: ResponseType.bytes),
      );
      final data = res.data;
      if (data == null || data.isEmpty) {
        throw const FormatException('Görsel yanıtı boş');
      }
      final buffer = await ui.ImmutableBuffer.fromUint8List(
        Uint8List.fromList(data),
      );
      return decode(buffer);
    } catch (_) {
      // Hatalı sonuç önbellekte kalmasın; token yenilendikten sonra yeniden
      // denenebilsin (NetworkImage ile aynı davranış).
      scheduleMicrotask(() => PaintingBinding.instance.imageCache.evict(key));
      rethrow;
    }
  }

  @override
  bool operator ==(Object other) =>
      other is AuthedNetworkImage && other.url == url && other.scale == scale;

  @override
  int get hashCode => Object.hash(url, scale);

  @override
  String toString() => 'AuthedNetworkImage("$url", scale: $scale)';
}
