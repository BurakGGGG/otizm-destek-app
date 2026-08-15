import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/providers.dart';
import '../domain/app_notification.dart';

/// `/api/notifications` uç noktalarını saran depo.
class NotificationRepository {
  NotificationRepository(this._dio);
  final Dio _dio;

  Future<int> getUnreadCount() async {
    try {
      final res = await _dio.get('/notifications/unread-count');
      final data = ApiEnvelope.fromJson(res.data).requireMap();
      return (data['count'] as num?)?.toInt() ?? 0;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> markRead(String id) async {
    try {
      await _dio.put('/notifications/$id/read');
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> markAllRead() async {
    try {
      await _dio.put('/notifications/read-all');
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Sayfalı liste — `GET /notifications/paged?page=&size=`
  /// (`PageResponse.content`; son sayfada `last` true).
  Future<({List<AppNotification> items, bool hasMore})> getPage(
    int page, {
    int size = 20,
  }) async {
    try {
      final res = await _dio.get(
        '/notifications/paged',
        queryParameters: {'page': page, 'size': size},
      );
      final data = ApiEnvelope.fromJson(res.data).requireMap();
      final content = data['content'];
      final items = content is List
          ? content
                .whereType<Map<String, dynamic>>()
                .map(AppNotification.fromJson)
                .toList()
          : <AppNotification>[];
      final last = data['last'] == true || items.isEmpty;
      return (items: items, hasMore: !last);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> delete(String id) async {
    try {
      await _dio.delete('/notifications/$id');
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Toplu silme — `DELETE /notifications/bulk` gövdesinde `{ids: [...]}`.
  Future<void> deleteMany(List<String> ids) async {
    if (ids.isEmpty) return;
    try {
      await _dio.delete('/notifications/bulk', data: {'ids': ids});
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(ref.watch(dioProvider));
});

/// Okunmamış bildirim sayısı (AppBar rozeti). Hata olursa 0.
final unreadCountProvider = FutureProvider<int>((ref) async {
  try {
    return await ref.watch(notificationRepositoryProvider).getUnreadCount();
  } catch (_) {
    return 0;
  }
});
