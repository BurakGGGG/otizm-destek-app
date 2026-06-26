import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/providers.dart';
import '../domain/development_note.dart';

/// `/api/notes` uç noktasını saran depo.
class NoteRepository {
  NoteRepository(this._dio);
  final Dio _dio;

  Future<List<DevelopmentNote>> getRecentNotes(String childId) async {
    try {
      final res = await _dio.get('/notes/child/$childId/recent');
      return ApiEnvelope.fromJson(res.data)
          .requireList()
          .whereType<Map<String, dynamic>>()
          .map(DevelopmentNote.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  return NoteRepository(ref.watch(dioProvider));
});

/// Belirli bir çocuğun son gelişim notları.
final recentNotesProvider =
    FutureProvider.family<List<DevelopmentNote>, String>((ref, childId) {
  return ref.watch(noteRepositoryProvider).getRecentNotes(childId);
});
