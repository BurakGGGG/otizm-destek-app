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

  /// Çocuğun tüm notları — sayfalı `Page<DevelopmentNoteDto>`. Web NotesPage
  /// gibi tarih/oluşturulma sırasıyla (backend `createdAt` DESC) döner.
  Future<NotesPage> getNotes(String childId, {int page = 0}) async {
    try {
      final res = await _dio.get(
        '/notes/child/$childId',
        queryParameters: {'page': page, 'size': 20},
      );
      final data = ApiEnvelope.fromJson(res.data).data;
      if (data is! Map<String, dynamic>) {
        return const NotesPage(notes: [], totalPages: 1);
      }
      final content = data['content'];
      return NotesPage(
        notes: content is List
            ? content
                .whereType<Map<String, dynamic>>()
                .map(DevelopmentNote.fromJson)
                .toList()
            : const [],
        totalPages: (data['totalPages'] as num?)?.toInt() ?? 1,
      );
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

  /// Notu günceller — `PUT /notes/{id}` (web `noteService.update` birebir).
  Future<DevelopmentNote> updateNote({
    required String id,
    required String childId,
    required String title,
    String? content,
    String? category,
    String? mood,
    String? noteDateIso,
  }) async {
    try {
      final res = await _dio.put(
        '/notes/$id',
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

  /// Notu siler — `DELETE /notes/{id}`.
  Future<void> deleteNote(String id) async {
    try {
      await _dio.delete('/notes/$id');
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

/// Sayfalı not sonucu (`Page<DevelopmentNoteDto>` alt kümesi).
class NotesPage {
  const NotesPage({required this.notes, required this.totalPages});

  final List<DevelopmentNote> notes;
  final int totalPages;
}

final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  return NoteRepository(ref.watch(dioProvider));
});

/// Belirli bir çocuğun son gelişim notları.
final recentNotesProvider =
    FutureProvider.family<List<DevelopmentNote>, String>((ref, childId) {
      return ref.watch(noteRepositoryProvider).getRecentNotes(childId);
    });
