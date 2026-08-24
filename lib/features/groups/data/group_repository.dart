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

  /// Grubu düzenler (yalnızca grubu kuran; backend de doğruluyor).
  Future<Group> update(
    String id, {
    required String name,
    String? description,
    String? category,
  }) async {
    String? clean(String? v) => (v == null || v.trim().isEmpty) ? null : v.trim();
    try {
      final res = await _dio.put('/groups/$id', data: {
        'name': name.trim(),
        'description': ?clean(description),
        'category': ?clean(category),
      });
      return Group.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Grubu siler (grubu kuran ya da yönetici).
  Future<void> delete(String id) async {
    try {
      await _dio.delete('/groups/$id');
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

  /// Grup üyeleri — yalnızca üyeler (ve yönetici) görebilir.
  Future<List<GroupMember>> getMembers(String id) async {
    try {
      final res = await _dio.get('/groups/$id/members');
      final data = ApiEnvelope.fromJson(res.data).data;
      return data is List
          ? data
              .whereType<Map<String, dynamic>>()
              .map(GroupMember.fromJson)
              .toList()
          : const [];
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Grup buluşmaları (başlangıç saatine göre sıralı gelir).
  Future<List<GroupMeeting>> getMeetings(String id) async {
    try {
      final res = await _dio.get('/groups/$id/meetings');
      final data = ApiEnvelope.fromJson(res.data).data;
      return data is List
          ? data
              .whereType<Map<String, dynamic>>()
              .map(GroupMeeting.fromJson)
              .toList()
          : const [];
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Buluşma planlar (yalnızca grubu kuran ya da yönetici).
  Future<GroupMeeting> createMeeting(
    String id, {
    required String title,
    required DateTime startTime,
    String? description,
    String? meetingUrl,
    DateTime? endTime,
  }) async {
    try {
      final res = await _dio.post('/groups/$id/meetings', data: {
        'title': title.trim(),
        'startTime': _localDateTime(startTime),
        'description': ?(description?.trim().isEmpty ?? true
            ? null
            : description!.trim()),
        'meetingUrl': ?(meetingUrl?.trim().isEmpty ?? true
            ? null
            : meetingUrl!.trim()),
        'endTime': ?(endTime == null ? null : _localDateTime(endTime)),
      });
      final data = ApiEnvelope.fromJson(res.data).data;
      return GroupMeeting.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Buluşmayı iptal eder (yalnızca grubu kuran ya da yönetici).
  Future<void> deleteMeeting(String id, String meetingId) async {
    try {
      await _dio.delete('/groups/$id/meetings/$meetingId');
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Saat dilimsiz `LocalDateTime` biçimi (backend böyle bekliyor).
  static String _localDateTime(DateTime value) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${value.year}-${two(value.month)}-${two(value.day)}'
        'T${two(value.hour)}:${two(value.minute)}:00';
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

/// Bir grubun üyeleri (üye değilse backend yetki hatası döner).
final groupMembersProvider =
    FutureProvider.family<List<GroupMember>, String>((ref, groupId) {
  return ref.watch(groupRepositoryProvider).getMembers(groupId);
});

/// Bir grubun buluşmaları.
final groupMeetingsProvider =
    FutureProvider.family<List<GroupMeeting>, String>((ref, groupId) {
  return ref.watch(groupRepositoryProvider).getMeetings(groupId);
});
