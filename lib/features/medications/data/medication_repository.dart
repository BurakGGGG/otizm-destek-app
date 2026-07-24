import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/providers.dart';
import '../domain/medication.dart';

/// `/api/medications` uç noktasını saran depo.
class MedicationRepository {
  MedicationRepository(this._dio);
  final Dio _dio;

  Future<List<Medication>> getMedications(String childId) async {
    try {
      final res = await _dio.get('/medications/child/$childId');
      return ApiEnvelope.fromJson(res.data)
          .requireList()
          .whereType<Map<String, dynamic>>()
          .map(Medication.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<Medication> create({
    required String childId,
    required String name,
    String? dosage,
    String? unit,
    String? frequency,
    List<String> scheduledTimes = const [],
    String? notes,
  }) {
    return _send(
      (dio, data) => dio.post('/medications', data: data),
      childId: childId,
      name: name,
      dosage: dosage,
      unit: unit,
      frequency: frequency,
      scheduledTimes: scheduledTimes,
      notes: notes,
      isActive: true,
    );
  }

  Future<Medication> update(
    Medication medication, {
    required String name,
    String? dosage,
    String? unit,
    String? frequency,
    List<String> scheduledTimes = const [],
    String? notes,
  }) {
    return _send(
      (dio, data) => dio.put('/medications/${medication.id}', data: data),
      childId: medication.childId,
      name: name,
      dosage: dosage,
      unit: unit,
      frequency: frequency,
      scheduledTimes: scheduledTimes,
      notes: notes,
      isActive: medication.isActive,
    );
  }

  Future<Medication> _send(
    Future<Response<dynamic>> Function(Dio dio, Map<String, dynamic> data)
        request, {
    required String childId,
    required String name,
    required bool isActive,
    String? dosage,
    String? unit,
    String? frequency,
    List<String> scheduledTimes = const [],
    String? notes,
  }) async {
    try {
      final res = await request(_dio, {
        'childId': childId,
        'name': name.trim(),
        'dosage': ?dosage,
        'unit': ?unit,
        'frequency': ?frequency,
        'scheduledTimes': scheduledTimes,
        'notes': ?notes,
        // Jackson Lombok alanını "active" bekler; uyumluluk için ikisi de.
        'active': isActive,
        'isActive': isActive,
      });
      return Medication.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> delete(String id) async {
    try {
      await _dio.delete('/medications/$id');
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Doz günlüğü upsert: aynı gün+saat için mevcut kayıt güncellenir.
  Future<MedicationLog> saveLog(
    String medicationId, {
    required String logDate,
    required String scheduledTime,
    required bool taken,
    String? notes,
    List<String> sideEffects = const [],
  }) async {
    try {
      final res = await _dio.post(
        '/medications/$medicationId/log',
        data: {
          'logDate': logDate,
          'scheduledTime': scheduledTime,
          'taken': taken,
          'notes': ?notes,
          'sideEffects': sideEffects,
        },
      );
      return MedicationLog.fromJson(
          ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final medicationRepositoryProvider = Provider<MedicationRepository>((ref) {
  return MedicationRepository(ref.watch(dioProvider));
});

/// Çocuğun ilaçları (bugünün doz kayıtlarıyla birlikte).
final medicationsProvider =
    FutureProvider.family<List<Medication>, String>((ref, childId) {
  return ref.watch(medicationRepositoryProvider).getMedications(childId);
});
