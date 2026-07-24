import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/providers.dart';
import '../domain/child.dart';

/// `/api/children` uç noktasını saran depo.
class ChildRepository {
  ChildRepository(this._dio);
  final Dio _dio;

  Future<List<Child>> getChildren() async {
    try {
      final res = await _dio.get('/children');
      return ApiEnvelope.fromJson(res.data)
          .requireList()
          .whereType<Map<String, dynamic>>()
          .map(Child.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<Child> createChild(Child child) async {
    try {
      final res = await _dio.post('/children', data: child.toWriteJson());
      return Child.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<Child> updateChild(String id, Child child) async {
    try {
      final res = await _dio.put('/children/$id', data: child.toWriteJson());
      return Child.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> deleteChild(String id) async {
    try {
      await _dio.delete('/children/$id');
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<Child> getChild(String id) async {
    try {
      final res = await _dio.get('/children/$id');
      return Child.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Semptom etiketlerini kaydeder — web gibi tam gövde + `tagIds` gönderilir.
  Future<Child> updateTags(Child child, List<String> tagIds) async {
    try {
      final res = await _dio.put('/children/${child.id}', data: {
        ...child.toWriteJson(),
        'tagIds': tagIds,
      });
      return Child.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Profil fotoğrafını günceller (önce [uploadImage] ile URL alınır).
  Future<Child> updatePhoto(Child child, String imageUrl) async {
    try {
      final res = await _dio.put('/children/${child.id}', data: {
        ...child.toWriteJson(),
        'profileImageUrl': imageUrl,
      });
      return Child.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Dosya yükler — `POST /upload` multipart, `{data:{url}}` döner.
  Future<String> uploadImage(String filePath, String fileName) async {
    try {
      final form = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
      });
      final res = await _dio.post('/upload', data: form);
      final data = ApiEnvelope.fromJson(res.data).requireMap();
      final url = data['url']?.toString() ?? '';
      if (url.isEmpty) throw const ApiException('Yükleme yanıtı geçersiz');
      return url;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final childRepositoryProvider = Provider<ChildRepository>((ref) {
  return ChildRepository(ref.watch(dioProvider));
});

/// Oturum kullanıcısının çocukları.
final childrenProvider = FutureProvider<List<Child>>((ref) {
  return ref.watch(childRepositoryProvider).getChildren();
});

/// Tek çocuğun tam profili (etiketler dahil).
final childProvider = FutureProvider.family<Child, String>((ref, id) {
  return ref.watch(childRepositoryProvider).getChild(id);
});
