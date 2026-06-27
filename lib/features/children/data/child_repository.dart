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
}

final childRepositoryProvider = Provider<ChildRepository>((ref) {
  return ChildRepository(ref.watch(dioProvider));
});

/// Oturum kullanıcısının çocukları.
final childrenProvider = FutureProvider<List<Child>>((ref) {
  return ref.watch(childRepositoryProvider).getChildren();
});
