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

  Future<List<AppNotification>> getNotifications() async {
    try {
      final res = await _dio.get('/notifications');
      return ApiEnvelope.fromJson(res.data)
          .requireList()
          .whereType<Map<String, dynamic>>()
          .map(AppNotification.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

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
}

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(ref.watch(dioProvider));
});

/// Bildirim listesi.
final notificationsProvider = FutureProvider<List<AppNotification>>((ref) {
  return ref.watch(notificationRepositoryProvider).getNotifications();
});

/// Okunmamış bildirim sayısı (AppBar rozeti). Hata olursa 0.
final unreadCountProvider = FutureProvider<int>((ref) async {
  try {
    return await ref.watch(notificationRepositoryProvider).getUnreadCount();
  } catch (_) {
    return 0;
  }
});
