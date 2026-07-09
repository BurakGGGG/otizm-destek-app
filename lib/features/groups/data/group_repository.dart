import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/providers.dart';
import '../domain/group.dart';

/// Grup deposu — `/api/groups` (destek grupları + üyelik).
class GroupRepository {
  GroupRepository(this._dio);
  final Dio _dio;

  List<Group> _list(dynamic data) => (data is List)
      ? data.whereType<Map<String, dynamic>>().map(Group.fromJson).toList()
      : const [];

  Future<List<Group>> getMyGroups() async {
    try {
      final res = await _dio.get('/groups/my');
      return _list(ApiEnvelope.fromJson(res.data).data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<List<Group>> search(String query) async {
    try {
      final res = await _dio.get(
        '/groups/search',
        queryParameters: {'query': query},
      );
      return _list(ApiEnvelope.fromJson(res.data).data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<List<Group>> getByCategory(String category) async {
    try {
      final res = await _dio.get('/groups/category/$category');
      return _list(ApiEnvelope.fromJson(res.data).data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<Group> create({
    required String name,
    String? description,
    String? category,
  }) async {
    String? clean(String? v) => (v == null || v.trim().isEmpty) ? null : v.trim();
    try {
      final res = await _dio.post('/groups', data: {
        'name': name.trim(),
        'description': ?clean(description),
        'category': ?clean(category),
      });
      return Group.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> join(String id) async {
    try {
      await _dio.post('/groups/$id/join');
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> leave(String id) async {
    try {
      await _dio.post('/groups/$id/leave');
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final groupRepositoryProvider = Provider<GroupRepository>((ref) {
  return GroupRepository(ref.watch(dioProvider));
});

/// Kullanıcının üye olduğu gruplar.
final myGroupsProvider = FutureProvider<List<Group>>((ref) {
  return ref.watch(groupRepositoryProvider).getMyGroups();
});

/// Keşfet sekmesi filtresi: arama sorgusu ve/veya kategori.
typedef GroupDiscoverKey = ({String query, String category});

/// Keşfet grupları — sorgu varsa arama, yoksa kategori (ya da tümü).
final discoverGroupsProvider =
    FutureProvider.family<List<Group>, GroupDiscoverKey>((ref, key) {
  final repo = ref.watch(groupRepositoryProvider);
  if (key.query.trim().isNotEmpty) return repo.search(key.query.trim());
  if (key.category.isNotEmpty) return repo.getByCategory(key.category);
  return repo.search('');
});
