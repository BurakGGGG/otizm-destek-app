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
}

final childRepositoryProvider = Provider<ChildRepository>((ref) {
  return ChildRepository(ref.watch(dioProvider));
});

/// Oturum kullanıcısının çocukları.
final childrenProvider = FutureProvider<List<Child>>((ref) {
  return ref.watch(childRepositoryProvider).getChildren();
});
