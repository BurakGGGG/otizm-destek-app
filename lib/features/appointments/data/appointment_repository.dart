import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/providers.dart';
import '../domain/appointment.dart';
import '../domain/expert_availability.dart';

/// `/api/appointments` uç noktasını saran depo.
class AppointmentRepository {
  AppointmentRepository(this._dio);
  final Dio _dio;

  Future<List<Appointment>> getAppointments() async {
    try {
      final res = await _dio.get('/appointments');
      return ApiEnvelope.fromJson(res.data)
          .requireList()
          .whereType<Map<String, dynamic>>()
          .map(Appointment.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Randevuyu iptal et (PARENT). Opsiyonel [reason] gönderilir.
  Future<Appointment> cancel(String id, {String? reason}) {
    return _patch(
      '/appointments/$id/cancel',
      data: reason != null && reason.trim().isNotEmpty
          ? {'reason': reason.trim()}
          : null,
    );
  }

  /// Randevuyu onayla (EXPERT).
  Future<Appointment> confirm(String id) => _patch('/appointments/$id/confirm');

  /// Randevuyu tamamlandı işaretle (EXPERT).
  Future<Appointment> complete(String id) =>
      _patch('/appointments/$id/complete');

  Future<Appointment> _patch(String path, {Object? data}) async {
    try {
      final res = await _dio.patch(path, data: data);
      return Appointment.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Uzmanın haftalık müsaitlik planı.
  Future<List<ExpertAvailability>> getAvailability(String expertId) async {
    try {
      final res = await _dio.get(
        '/appointments/experts/$expertId/availability',
      );
      return ApiEnvelope.fromJson(res.data)
          .requireList()
          .whereType<Map<String, dynamic>>()
          .map(ExpertAvailability.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Bir gün için dolu/engelli başlangıç saatleri ("HH:mm").
  Future<List<String>> getBookedTimes(
    String expertId,
    String dateIso, {
    int duration = 50,
  }) async {
    try {
      final res = await _dio.get(
        '/appointments/experts/$expertId/booked-times',
        queryParameters: {'date': dateIso, 'duration': duration},
      );
      return ApiEnvelope.fromJson(
        res.data,
      ).requireList().map((e) => e.toString()).toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Yeni randevu oluştur (PARENT).
  Future<Appointment> create({
    required String expertId,
    required String childId,
    required String dateIso,
    required String time,
    required String type, // ONLINE | FACE_TO_FACE
    int duration = 50,
    String? notes,
  }) async {
    try {
      final res = await _dio.post(
        '/appointments',
        data: {
          'expertId': expertId,
          'childId': childId,
          'date': dateIso,
          'time': time,
          'type': type,
          'duration': duration,
          if (notes != null && notes.trim().isNotEmpty) 'notes': notes.trim(),
        },
      );
      return Appointment.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final appointmentRepositoryProvider = Provider<AppointmentRepository>((ref) {
  return AppointmentRepository(ref.watch(dioProvider));
});

/// Tüm randevular.
final appointmentsProvider = FutureProvider<List<Appointment>>((ref) {
  return ref.watch(appointmentRepositoryProvider).getAppointments();
});

/// Yaklaşan randevular (tarihe göre artan; ilk birkaçı).
final upcomingAppointmentsProvider = FutureProvider<List<Appointment>>((
  ref,
) async {
  final all = await ref.watch(appointmentsProvider.future);
  final upcoming = all.where((a) => a.isUpcoming).toList()
    ..sort((a, b) {
      final byDate = a.date.compareTo(b.date);
      return byDate != 0 ? byDate : a.time.compareTo(b.time);
    });
  return upcoming;
});
