import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/providers.dart';
import '../domain/meetup_request.dart';

/// `/api/meetup-requests` — iki aile arasındaki buluşma isteği (topluluk
/// buluşmalarından ayrı; uç noktalar PARENT rolüne kısıtlı).
class MeetupRequestRepository {
  MeetupRequestRepository(this._dio);
  final Dio _dio;

  Future<List<MeetupRequest>> getMyRequests() async {
    try {
      final res = await _dio.get('/meetup-requests');
      return ApiEnvelope.fromJson(res.data)
          .requireList()
          .whereType<Map<String, dynamic>>()
          .map(MeetupRequest.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<MeetupRequest> create({
    required String recipientId,
    required String type,
    required String proposedDate,
    required String proposedTime,
    String? location,
    String? message,
  }) async {
    try {
      final res = await _dio.post('/meetup-requests', data: {
        'recipientId': recipientId,
        'type': type,
        'proposedDate': proposedDate,
        'proposedTime': proposedTime,
        if (location != null && location.trim().isNotEmpty)
          'location': location.trim(),
        if (message != null && message.trim().isNotEmpty)
          'message': message.trim(),
      });
      return MeetupRequest.fromJson(
        ApiEnvelope.fromJson(res.data).requireMap(),
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// ACCEPTED | DECLINED | CANCELLED.
  Future<MeetupRequest> updateStatus(String id, String status) async {
    try {
      final res = await _dio.put(
        '/meetup-requests/$id/status',
        data: {'status': status},
      );
      return MeetupRequest.fromJson(
        ApiEnvelope.fromJson(res.data).requireMap(),
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final meetupRequestRepositoryProvider =
    Provider<MeetupRequestRepository>((ref) {
  return MeetupRequestRepository(ref.watch(dioProvider));
});

/// Kullanıcının buluşma istekleri. Uç nokta PARENT'a kısıtlı olduğu için
/// yetkisiz roller boş liste görür (bağlantı ekranındaki desenle aynı).
final meetupRequestsProvider = FutureProvider<List<MeetupRequest>>((ref) async {
  try {
    return await ref.read(meetupRequestRepositoryProvider).getMyRequests();
  } on ApiException {
    return const [];
  }
});
