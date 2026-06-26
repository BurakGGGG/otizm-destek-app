import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/providers.dart';
import '../domain/appointment.dart';

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
}

final appointmentRepositoryProvider = Provider<AppointmentRepository>((ref) {
  return AppointmentRepository(ref.watch(dioProvider));
});

/// Tüm randevular.
final appointmentsProvider = FutureProvider<List<Appointment>>((ref) {
  return ref.watch(appointmentRepositoryProvider).getAppointments();
});

/// Yaklaşan randevular (tarihe göre artan; ilk birkaçı).
final upcomingAppointmentsProvider = FutureProvider<List<Appointment>>((ref) async {
  final all = await ref.watch(appointmentsProvider.future);
  final upcoming = all.where((a) => a.isUpcoming).toList()
    ..sort((a, b) {
      final byDate = a.date.compareTo(b.date);
      return byDate != 0 ? byDate : a.time.compareTo(b.time);
    });
  return upcoming;
});
