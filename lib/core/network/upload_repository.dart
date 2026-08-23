import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';

import '../../i18n/strings.g.dart';
import '../providers.dart';
import 'api_exception.dart';
import 'api_response.dart';
import 'upload_rules.dart';

/// Dosya yükleme kapsamı — web `uploadService` ile birebir. Kapsam verilmezse
/// dosya yalnızca yükleyene açık kalır (klinik veriyi paylaşan uzman göremez).
class UploadScope {
  const UploadScope({required this.type, required this.id});

  /// CHILD_PROFILE / CHILD_NOTES / CONVERSATION.
  final String type;
  final String id;
}

/// `POST /api/upload` sarmalayıcısı (web `uploadService.upload` birebir):
/// multipart `file` + `visibility`/`scopeType`/`scopeId` sorgu parametreleri,
/// yanıt `{data:{url}}`. Dönen adres göreli olabilir — göstermeden önce
/// `absoluteMediaUrl` ile mutlaklaştırılır.
class UploadRepository {
  UploadRepository(this._dio);
  final Dio _dio;

  Future<String> upload(
    String filePath,
    String fileName, {
    String visibility = 'PRIVATE',
    UploadScope? scope,
  }) async {
    // Sunucuya gitmeden önce boyut/tür kontrolü: 10 MB'lık bir dosyayı mobil
    // veriyle yükleyip sunucudan hata almak kullanıcıya pahalıya patlıyor.
    // Sınırlar backend sözleşmesiyle aynı (bkz. upload_rules.dart).
    final file = File(filePath);
    final size = file.existsSync() ? file.lengthSync() : 0;
    final rejection = uploadRejection(fileName: fileName, sizeBytes: size);
    if (rejection != null) {
      throw ApiException(switch (rejection) {
        UploadRejection.empty => t.errors.uploadEmptyFile,
        UploadRejection.tooLarge => t.errors.uploadTooLarge(
            limit: kMaxUploadBytes ~/ (1024 * 1024),
          ),
        UploadRejection.unsupportedType => t.errors.uploadTypeNotSupported,
      });
    }

    try {
      final form = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: fileName,
          // Backend içerik türü ile uzantının eşleşmesini şart koşuyor. Dio
          // dosya adından türü çıkarabiliyor ama çıkaramazsa
          // application/octet-stream yazıyor — o da sunucunun listesinde yok.
          // Türü aynı listeden açıkça vererek bu riski kapatıyoruz.
          contentType: MediaType.parse(uploadContentTypeFor(fileName)!),
        ),
      });
      final res = await _dio.post(
        '/upload',
        data: form,
        queryParameters: {
          'visibility': visibility,
          'scopeType': ?scope?.type,
          'scopeId': ?scope?.id,
        },
      );
      final data = ApiEnvelope.fromJson(res.data).requireMap();
      final url = data['url']?.toString() ?? '';
      if (url.isEmpty) throw const ApiException('Yükleme yanıtı geçersiz');
      return url;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final uploadRepositoryProvider = Provider<UploadRepository>((ref) {
  return UploadRepository(ref.watch(dioProvider));
});
