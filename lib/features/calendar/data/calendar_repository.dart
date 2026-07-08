import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/providers.dart';
import '../domain/calendar_event.dart';

/// `/api/calendar` uç noktasını saran depo.
class CalendarRepository {
  CalendarRepository(this._dio);
  final Dio _dio;

  /// Backend `LocalDateTime` bekler — saniyeye kadar, saat dilimsiz ISO.
  static String formatLocal(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)}'
        'T${two(d.hour)}:${two(d.minute)}:${two(d.second)}';
  }

  Future<List<CalendarEvent>> getByChild(String childId) async {
    try {
      final res = await _dio.get('/calendar/child/$childId');
      return ApiEnvelope.fromJson(res.data)
          .requireList()
          .whereType<Map<String, dynamic>>()
          .map(CalendarEvent.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<CalendarEvent> create({
    required String childId,
    required String title,
    required String eventType,
    required DateTime startTime,
    DateTime? endTime,
    String? description,
    String? location,
    int? reminderMinutesBefore,
    String? color,
  }) {
    return _write(
      (dio, data) => dio.post('/calendar', data: data),
      childId: childId,
      title: title,
      eventType: eventType,
      startTime: startTime,
      endTime: endTime,
      description: description,
      location: location,
      reminderMinutesBefore: reminderMinutesBefore,
      color: color,
    );
  }

  Future<CalendarEvent> update(
    String id, {
    required String childId,
    required String title,
    required String eventType,
    required DateTime startTime,
    DateTime? endTime,
    String? description,
    String? location,
    int? reminderMinutesBefore,
    String? color,
  }) {
    return _write(
      (dio, data) => dio.put('/calendar/$id', data: data),
      childId: childId,
      title: title,
      eventType: eventType,
      startTime: startTime,
      endTime: endTime,
      description: description,
      location: location,
      reminderMinutesBefore: reminderMinutesBefore,
      color: color,
    );
  }

  Future<CalendarEvent> _write(
    Future<Response<dynamic>> Function(Dio dio, Map<String, dynamic> data)
        request, {
    required String childId,
    required String title,
    required String eventType,
    required DateTime startTime,
    DateTime? endTime,
    String? description,
    String? location,
    int? reminderMinutesBefore,
    String? color,
  }) async {
    try {
      final res = await request(_dio, {
        'childId': childId,
        'title': title.trim(),
        'eventType': eventType,
        'startTime': formatLocal(startTime),
        'endTime': ?(endTime == null ? null : formatLocal(endTime)),
        'description': ?description,
        'location': ?location,
        'reminderMinutesBefore': ?reminderMinutesBefore,
        'color': ?color,
      });
      return CalendarEvent.fromJson(
          ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<CalendarEvent> updateStatus(String id, String status) async {
    try {
      final res = await _dio.patch(
        '/calendar/$id/status',
        queryParameters: {'status': status},
      );
      return CalendarEvent.fromJson(
          ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> delete(String id) async {
    try {
      await _dio.delete('/calendar/$id');
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final calendarRepositoryProvider = Provider<CalendarRepository>((ref) {
  return CalendarRepository(ref.watch(dioProvider));
});

/// Çocuğun takvim etkinlikleri (başlangıç zamanına göre artan).
final calendarEventsProvider =
    FutureProvider.family<List<CalendarEvent>, String>((ref, childId) async {
  final events =
      await ref.watch(calendarRepositoryProvider).getByChild(childId);
  events.sort((a, b) => a.startTime.compareTo(b.startTime));
  return events;
});
