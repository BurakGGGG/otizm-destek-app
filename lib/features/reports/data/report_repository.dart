import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/providers.dart';

/// `POST /api/reports` — forum gönderisi/yorumu ve uzman profili şikayeti
/// aynı uç noktayı kullanır. Aynı hedefi ikinci kez şikayet etmek backend'de
/// hata döner ("Bu içeriği zaten şikayet ettiniz"); mesaj kullanıcıya
/// olduğu gibi gösterilir.
class ReportRepository {
  ReportRepository(this._dio);
  final Dio _dio;

  Future<void> create({
    required String targetType,
    required String targetId,
    required String reason,
  }) async {
    try {
      await _dio.post('/reports', data: {
        'targetType': targetType,
        'targetId': targetId,
        'reason': reason.trim(),
      });
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return ReportRepository(ref.watch(dioProvider));
});
