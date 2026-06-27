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

  /// Yeni gelişim notu oluştur — `POST /notes` (childId gövdede).
  Future<DevelopmentNote> createNote({
    required String childId,
    required String title,
    String? content,
    String? category,
    String? mood,
    String? noteDateIso,
  }) async {
    try {
      final res = await _dio.post(
        '/notes',
        data: {
          'childId': childId,
          'title': title.trim(),
          if (content != null && content.trim().isNotEmpty)
            'content': content.trim(),
          'category': ?category,
          'mood': ?mood,
          'noteDate': ?noteDateIso,
        },
      );
      return DevelopmentNote.fromJson(
        ApiEnvelope.fromJson(res.data).requireMap(),
      );
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
