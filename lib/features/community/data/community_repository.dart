import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/providers.dart';
import '../domain/weekly_question.dart';

/// Topluluk deposu — `/api/community` (Haftanın Sorusu + Buluşmalar).
class CommunityRepository {
  CommunityRepository(this._dio);
  final Dio _dio;

  Future<List<WeeklyQuestion>> getWeeklyQuestions() async {
    try {
      final res = await _dio.get('/community/weekly-questions');
      return ApiEnvelope.fromJson(res.data)
          .requireList()
          .whereType<Map<String, dynamic>>()
          .map(WeeklyQuestion.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Bir soruya cevap paylaşır. [rawText] meta önekleri içerebilir
  /// (bkz. [WeeklyAnswer.encode]).
  Future<WeeklyAnswer> createWeeklyAnswer(
    String questionId,
    String rawText,
  ) async {
    try {
      final res = await _dio.post(
        '/community/weekly-questions/$questionId/answers',
        data: {'text': rawText},
      );
      return WeeklyAnswer.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Cevap beğenisini aç-kapa; güncel cevabı (likes/liked) döner.
  Future<WeeklyAnswer> toggleWeeklyAnswerLike(String answerId) async {
    try {
      final res = await _dio.post('/community/weekly-answers/$answerId/like');
      return WeeklyAnswer.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  return CommunityRepository(ref.watch(dioProvider));
});

/// Haftanın Soruları (cevaplarıyla birlikte).
final weeklyQuestionsProvider = FutureProvider<List<WeeklyQuestion>>((ref) {
  return ref.watch(communityRepositoryProvider).getWeeklyQuestions();
});
