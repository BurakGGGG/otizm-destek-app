import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/providers.dart';
import '../domain/wall_post.dart';

/// Dertleşme Duvarı deposu — forum'un `SUPPORT_WALL` kategorisini saran API.
class WallRepository {
  WallRepository(this._dio);
  final Dio _dio;

  static const _category = 'SUPPORT_WALL';

  /// Sayfalı `PageResponseDto`'nun `content` listesini çıkarır.
  List<Map<String, dynamic>> _content(dynamic data) {
    if (data is Map<String, dynamic> && data['content'] is List) {
      return (data['content'] as List).whereType<Map<String, dynamic>>().toList();
    }
    return const [];
  }

  Future<List<WallPost>> getPosts({int page = 0}) async {
    try {
      final res = await _dio.get(
        '/forum/posts/category/$_category',
        queryParameters: {'page': page},
      );
      return _content(ApiEnvelope.fromJson(res.data).data)
          .map(WallPost.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<WallPost> getPost(String id) async {
    try {
      final res = await _dio.get('/forum/posts/$id');
      return WallPost.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<WallPost> createPost({
    required String title,
    required String content,
    required bool anonymous,
  }) async {
    try {
      final res = await _dio.post('/forum/posts', data: {
        'title': title.trim(),
        'content': content.trim(),
        'category': _category,
        'postType': 'DENEYIM',
        'anonymous': anonymous,
      });
      return WallPost.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<WallPost> updatePost(
    String id, {
    required String title,
    required String content,
  }) async {
    try {
      final res = await _dio.put('/forum/posts/$id', data: {
        'title': title.trim(),
        'content': content.trim(),
      });
      return WallPost.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
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

  Future<List<WallComment>> getComments(String postId, {int page = 0}) async {
    try {
      final res = await _dio.get(
        '/forum/posts/$postId/comments',
        queryParameters: {'page': page},
      );
      return _content(ApiEnvelope.fromJson(res.data).data)
          .map(WallComment.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<WallComment> createComment(
    String postId, {
    required String content,
    bool anonymous = true,
  }) async {
    try {
      final res = await _dio.post('/forum/posts/$postId/comments', data: {
        'content': content.trim(),
        'anonymous': anonymous,
      });
      return WallComment.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
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

  /// Beğeni/destek aç-kapa (`POST /votes`, toggle).
  Future<void> toggleLike(String postId) async {
    try {
      await _dio.post('/votes', data: {
        'targetType': 'POST',
        'targetId': postId,
        'voteValue': 1,
      });
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final wallRepositoryProvider = Provider<WallRepository>((ref) {
  return WallRepository(ref.watch(dioProvider));
});

/// Duvar paylaşımları (ilk sayfa).
final wallPostsProvider = FutureProvider<List<WallPost>>((ref) {
  return ref.watch(wallRepositoryProvider).getPosts();
});

/// Tek bir paylaşımın detayı (yorum sayısı/beğeni dahil).
final wallPostProvider =
    FutureProvider.family<WallPost, String>((ref, id) {
  return ref.watch(wallRepositoryProvider).getPost(id);
});

/// Bir paylaşımın yorumları.
final wallCommentsProvider =
    FutureProvider.family<List<WallComment>, String>((ref, postId) {
  return ref.watch(wallRepositoryProvider).getComments(postId);
});
