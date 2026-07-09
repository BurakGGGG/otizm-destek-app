import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/providers.dart';
import '../domain/community_meetup.dart';
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

  /// Buluşmaları getirir. [city] verilir ve `Tümü` değilse şehre göre süzülür.
  Future<List<CommunityMeetup>> getMeetups({String? city}) async {
    try {
      final res = await _dio.get(
        '/community/meetups',
        queryParameters:
            (city != null && city.isNotEmpty && city != 'Tümü')
                ? {'city': city}
                : null,
      );
      return ApiEnvelope.fromJson(res.data)
          .requireList()
          .whereType<Map<String, dynamic>>()
          .map(CommunityMeetup.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Yeni buluşma oluşturur. `title`/`city`/`date` zorunlu; `date` `yyyy-MM-dd`,
  /// `time` `HH:mm`.
  Future<CommunityMeetup> createMeetup({
    required String title,
    required String city,
    required String date,
    String? district,
    String? venue,
    String? time,
    String? description,
  }) async {
    // Boş isteğe bağlı alanları `null`'a indir; `?` ile JSON'dan tümüyle çıkar.
    String? clean(String? v) => (v == null || v.trim().isEmpty) ? null : v.trim();
    try {
      final res = await _dio.post('/community/meetups', data: {
        'title': title.trim(),
        'city': city,
        'date': date,
        'district': ?clean(district),
        'venue': ?clean(venue),
        'time': ?clean(time),
        'description': ?clean(description),
        'emoji': '📍',
      });
      return CommunityMeetup.fromJson(
          ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Katılımı aç-kapa; güncel buluşmayı (attendees/joined) döner.
  Future<CommunityMeetup> toggleMeetupAttendance(String meetupId) async {
    try {
      final res =
          await _dio.post('/community/meetups/$meetupId/attendance');
      return CommunityMeetup.fromJson(
          ApiEnvelope.fromJson(res.data).requireMap());
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

/// Şehir filtresine göre buluşmalar (`Tümü` = tüm şehirler).
final meetupsProvider =
    FutureProvider.family<List<CommunityMeetup>, String>((ref, city) {
  return ref.watch(communityRepositoryProvider).getMeetups(city: city);
});
