import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/providers.dart';

/// Analiz türleri — backend `AiInsightsService.AnalysisType` kodları
/// (veri, çevrilmez; etiketleri i18n'de). Web `ANALYSIS_TYPES` ile aynı
/// dört tür gösterilir (DAILY_COACH web'de de listelenmiyor).
const List<String> kAnalysisTypes = [
  'GENERAL',
  'BEHAVIORAL',
  'PROGRESS',
  'WEEKLY',
];

/// `/api/ai-insights/{childId}` — çocuğun kayıtlarından yapay zekâ özeti.
///
/// Veli **açık rızası** (`AI_ANALIZ`) yoksa backend hata döner; ekran rızayı
/// önceden kontrol edip KVKK sayfasına yönlendirir.
class AiInsightsRepository {
  AiInsightsRepository(this._dio);
  final Dio _dio;

  /// Akış (SSE): `chunk` olayları parça parça gelir, `done` bitirir.
  /// Sohbet botundaki ayrıştırıcının aynısı — `data:` sonrası boşluklar
  /// gerçek içeriktir, kırpılmaz.
  Stream<String> streamInsights(String childId, String type) async* {
    final Response<ResponseBody> response;
    try {
      response = await _dio.get<ResponseBody>(
        '/ai-insights/$childId/stream',
        queryParameters: {'type': type},
        options: Options(
          responseType: ResponseType.stream,
          headers: {'Accept': 'text/event-stream'},
        ),
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }

    final body = response.data;
    if (body == null) return;

    final lines = body.stream
        .cast<List<int>>()
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    var event = '';
    final data = StringBuffer();

    await for (final line in lines) {
      if (line.isEmpty) {
        if (event == 'chunk') {
          yield data.toString();
        } else if (event == 'done') {
          return;
        } else if (event == 'error') {
          final message = data.toString();
          throw ApiException(message.isEmpty ? 'AI analizi alınamadı' : message);
        }
        event = '';
        data.clear();
        continue;
      }
      if (line.startsWith('event:')) {
        event = line.substring(6).trim();
      } else if (line.startsWith('data:')) {
        if (data.isNotEmpty) data.write('\n');
        data.write(line.substring(5));
      }
    }
  }

  /// Akış kurulamazsa kullanılan tek seferlik uç nokta (web de böyle yapıyor).
  Future<String> getInsights(String childId, String type) async {
    try {
      final res = await _dio.get(
        '/ai-insights/$childId',
        queryParameters: {'type': type},
      );
      return ApiEnvelope.fromJson(res.data).data?.toString() ?? '';
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final aiInsightsRepositoryProvider = Provider<AiInsightsRepository>((ref) {
  return AiInsightsRepository(ref.watch(dioProvider));
});
