import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/providers.dart';
import '../domain/forum_post.dart';

/// Tam forum deposu — `/api/forum/posts` (+ `/api/tags`, `/api/votes`,
/// `/api/reports`). Dertleşme Duvarı (`SUPPORT_WALL`) ayrı özellikte kalır;
/// buradaki akış web ForumPage birebir: tip sekmeleri + arama + sıralama +
/// etiket filtresi, soru-cevap (en iyi cevap), yorum yanıtları ve oylar.
class ForumRepository {
  ForumRepository(this._dio);
  final Dio _dio;

  /// Sayfalı `PageResponseDto` gövdesini çözer.
  ForumPageResult _page(dynamic data) {
    if (data is! Map<String, dynamic>) {
      return const ForumPageResult(posts: [], totalPages: 1);
    }
    final content = data['content'];
    return ForumPageResult(
      posts: content is List
          ? content
              .whereType<Map<String, dynamic>>()
              .map(ForumPost.fromJson)
              .toList()
          : const [],
      totalPages: (data['totalPages'] as num?)?.toInt() ?? 1,
    );
  }

  Future<ForumPageResult> getPosts({
    String? type,
    List<String> tagIds = const [],
    String? query,
    String sort = 'new',
    int page = 0,
    int size = 20,
  }) async {
    try {
      final res = await _dio.get('/forum/posts', queryParameters: {
        'type': ?type,
        if (tagIds.isNotEmpty) 'tagIds': tagIds,
        if (query != null && query.trim().isNotEmpty) 'q': query.trim(),
        'order': sort,
        'page': page,
        'size': size,
      });
      return _page(ApiEnvelope.fromJson(res.data).data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<ForumPost> getPost(String id) async {
    try {
      final res = await _dio.get('/forum/posts/$id');
      return ForumPost.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Gönderi oluştur — web `handleCreatePost` birebir; `privacySettings`
  /// varsayılanları web `defaultPrivacy` (anonimse ad+tanı kapalı).
  Future<ForumPost> createPost({
    required String title,
    required String content,
    required String postType,
    List<String> tagIds = const [],
    bool anonymous = false,
    Map<String, bool>? privacySettings,
  }) async {
    try {
      final res = await _dio.post('/forum/posts', data: {
        'title': title.trim(),
        'content': content.trim(),
        'postType': postType,
        'tagIds': tagIds,
        'anonymous': anonymous,
        'privacySettings': privacySettings ??
            {
              'showRealName': !anonymous,
              'showChildAge': true,
              'showSymptoms': true,
              'showDiagnosis': false,
              'allowMatching': true,
            },
      });
      return ForumPost.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<ForumPost> updatePost(
    String id, {
    required String title,
    required String content,
  }) async {
    try {
      final res = await _dio.put('/forum/posts/$id', data: {
        'title': title.trim(),
        'content': content.trim(),
      });
      return ForumPost.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> deletePost(String id) async {
    try {
      await _dio.delete('/forum/posts/$id');
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Soru sahibinin bir yorumu "en iyi cevap" işaretlemesi; güncel gönderiyi döner.
  Future<ForumPost> acceptAnswer(String postId, String commentId) async {
    try {
      final res = await _dio.post('/forum/posts/$postId/accept/$commentId');
      return ForumPost.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Bir gönderinin tüm yorumlarını çeker. Yorumlar sayfalıdır ve yanıtlar
  /// (parentCommentId) da aynı listede döndüğü için tek sayfayla yetinmek
  /// üst-seviye yorumları/yanıtları görünmez bırakabilir; bu yüzden makul bir
  /// üst sınıra (10 sayfa × 50 = 500) kadar tüm sayfalar toplanır.
  Future<List<ForumComment>> getComments(String postId) async {
    const size = 50;
    const maxPages = 10;
    final comments = <ForumComment>[];
    try {
      var page = 0;
      var totalPages = 1;
      while (page < totalPages && page < maxPages) {
        final res = await _dio.get(
          '/forum/posts/$postId/comments',
          queryParameters: {'page': page, 'size': size},
        );
        final data = ApiEnvelope.fromJson(res.data).data;
        if (data is! Map<String, dynamic> || data['content'] is! List) break;
        comments.addAll((data['content'] as List)
            .whereType<Map<String, dynamic>>()
            .map(ForumComment.fromJson));
        totalPages = (data['totalPages'] as num?)?.toInt() ?? 1;
        page++;
      }
      return comments;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Yorum ya da yanıt (parentCommentId ile) ekler — web forum yorumları
  /// duvardan farklı olarak anonim değildir (bayrak gönderilmez).
  Future<ForumComment> createComment(
    String postId, {
    required String content,
    String? parentCommentId,
  }) async {
    try {
      final res = await _dio.post('/forum/posts/$postId/comments', data: {
        'content': content.trim(),
        'parentCommentId': ?parentCommentId,
      });
      return ForumComment.fromJson(
          ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<ForumComment> updateComment(
    String postId,
    String commentId,
    String content,
  ) async {
    try {
      final res = await _dio.put(
        '/forum/posts/$postId/comments/$commentId',
        data: {'content': content.trim()},
      );
      return ForumComment.fromJson(
          ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await _dio.delete('/forum/posts/$postId/comments/$commentId');
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Oy aç-kapa — gönderide beğeni (+1), yorumda +1/-1 (web birebir).
  Future<void> toggleVote({
    required String targetType,
    required String targetId,
    required int voteValue,
  }) async {
    try {
      await _dio.post('/votes', data: {
        'targetType': targetType,
        'targetId': targetId,
        'voteValue': voteValue,
      });
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// İçerik şikayeti — `POST /reports {targetType, targetId, reason}`.
  Future<void> report({
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

final forumRepositoryProvider = Provider<ForumRepository>((ref) {
  return ForumRepository(ref.watch(dioProvider));
});

/// Bir gönderinin yorumları.
final forumCommentsProvider =
    FutureProvider.family<List<ForumComment>, String>((ref, postId) {
  return ref.watch(forumRepositoryProvider).getComments(postId);
});
