import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import 'api_exception.dart';
import 'api_response.dart';

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
    try {
      final form = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
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
