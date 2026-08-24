import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/providers.dart';
import '../domain/emergency_card.dart';

/// `/api/emergency-card` uç noktasını saran depo.
///
/// Backend kartı JSON string olarak `data` içinde döndürür (yoksa null); kayıt
/// PUT ile Map olarak gönderilir.
class EmergencyRepository {
  EmergencyRepository(this._dio);
  final Dio _dio;

  /// Kart yoksa null döner.
  Future<EmergencyCard?> getCard(String childId) async {
    try {
      final res = await _dio.get('/emergency-card/$childId');
      final raw = ApiEnvelope.fromJson(res.data).data;
      final map = _decode(raw);
      if (map == null) return null;
      return EmergencyCard.fromJson(map);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> save(EmergencyCard card) async {
    try {
      await _dio.put('/emergency-card/${card.childId}', data: card.toJson());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Paylaşım durumu — `GET /emergency-card/{childId}/share`.
  Future<EmergencyShareStatus> shareStatus(String childId) async {
    try {
      final res = await _dio.get('/emergency-card/$childId/share');
      return EmergencyShareStatus.fromJson(
        ApiEnvelope.fromJson(res.data).requireMap(),
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Süreli paylaşım bağlantısı açar — `POST /emergency-card/{childId}/share`.
  /// [hours] backend sınırları içinde olmalı (1–720; geçersizse 24 uygulanır).
  Future<void> enableShare(String childId, int hours) async {
    try {
      await _dio.post(
        '/emergency-card/$childId/share',
        queryParameters: {'hours': hours},
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Paylaşımı kapatır — mevcut bağlantı da geçersiz olur.
  Future<void> disableShare(String childId) async {
    try {
      await _dio.delete('/emergency-card/$childId/share');
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// `data` string ya da Map olabilir; ikisini de Map'e çevirir.
  Map<String, dynamic>? _decode(dynamic raw) {
    if (raw == null) return null;
    if (raw is Map<String, dynamic>) return raw;
    if (raw is String) {
      if (raw.trim().isEmpty) return null;
      final decoded = jsonDecode(raw);
      return decoded is Map<String, dynamic> ? decoded : null;
    }
    return null;
  }
}

final emergencyRepositoryProvider = Provider<EmergencyRepository>((ref) {
  return EmergencyRepository(ref.watch(dioProvider));
});

/// Seçili çocuğun acil durum kartı (yoksa null).
final emergencyCardProvider =
    FutureProvider.family<EmergencyCard?, String>((ref, childId) {
  return ref.watch(emergencyRepositoryProvider).getCard(childId);
});

/// Seçili çocuğun paylaşım bağlantısı durumu.
final emergencyShareProvider =
    FutureProvider.family<EmergencyShareStatus, String>((ref, childId) {
  return ref.watch(emergencyRepositoryProvider).shareStatus(childId);
});
