import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/providers.dart';
import '../domain/symptom_tag.dart';

/// `/api/tags` uç noktalarını saran depo (semptom etiketleri).
class TagRepository {
  TagRepository(this._dio);
  final Dio _dio;

  /// Kategoriye göre gruplu etiketler — `GET /tags/grouped`.
  Future<Map<String, List<SymptomTag>>> getGrouped() async {
    try {
      final res = await _dio.get('/tags/grouped');
      final data = ApiEnvelope.fromJson(res.data).data;
      if (data is! Map<String, dynamic>) return const {};
      return data.map((category, tags) => MapEntry(
            category,
            tags is List
                ? tags
                    .whereType<Map<String, dynamic>>()
                    .map(SymptomTag.fromJson)
                    .toList()
                : const <SymptomTag>[],
          ));
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final tagRepositoryProvider = Provider<TagRepository>((ref) {
  return TagRepository(ref.watch(dioProvider));
});

/// Kategoriye göre gruplu etiketler (forum filtresi, çocuk profili, ilk
/// kurulum, bilgi bankası).
final symptomTagsGroupedProvider =
    FutureProvider<Map<String, List<SymptomTag>>>((ref) {
  return ref.watch(tagRepositoryProvider).getGrouped();
});

/// Düz etiket listesi. Web bunun için ayrı `GET /tags` çağırıyor; mobil
/// gruplu yanıtı düzleştirerek ikinci isteği yapmaz.
final symptomTagsProvider = FutureProvider<List<SymptomTag>>((ref) async {
  final grouped = await ref.watch(symptomTagsGroupedProvider.future);
  return [for (final tags in grouped.values) ...tags];
});
