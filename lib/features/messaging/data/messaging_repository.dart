import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/providers.dart';
import '../domain/conversation.dart';
import '../domain/message.dart';

/// `/api/messages` uç noktalarını saran depo.
class MessagingRepository {
  MessagingRepository(this._dio);
  final Dio _dio;

  Future<List<Conversation>> getConversations() async {
    try {
      final res = await _dio.get('/messages/conversations');
      return ApiEnvelope.fromJson(res.data)
          .requireList()
          .whereType<Map<String, dynamic>>()
          .map(Conversation.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Bir kullanıcıyla birebir konuşmayı getir/oluştur — varsa mevcut döner.
  Future<Conversation> getOrCreateDirect(String userId) async {
    try {
      final res = await _dio.post('/messages/conversations/direct/$userId');
      return Conversation.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Bir grubun sohbet konuşmasını getir/oluştur (grup üyeleri için).
  Future<Conversation> getOrCreateGroup(String groupId) async {
    try {
      final res = await _dio.post('/messages/conversations/group/$groupId');
      return Conversation.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Bir konuşmanın mesajları (en yeni sayfa), eskiden yeniye sıralı.
  Future<List<Message>> getMessages(
    String conversationId, {
    int page = 0,
    int size = 30,
  }) async {
    try {
      final res = await _dio.get(
        '/messages/conversations/$conversationId',
        queryParameters: {'page': page, 'size': size},
      );
      final pageData = ApiEnvelope.fromJson(res.data).requireMap();
      final content = pageData['content'];
      if (content is! List) return const [];
      final messages = content
          .whereType<Map<String, dynamic>>()
          .map(Message.fromJson)
          .toList();
      messages.sort((a, b) {
        final at = a.sentAt, bt = b.sentAt;
        if (at == null || bt == null) return 0;
        return at.compareTo(bt);
      });
      return messages;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Konuşmayı okundu işaretle — `POST /conversations/{id}/read`.
  /// Okunmamış sayacı yalnızca bu çağrıyla sıfırlanır (web de thread açılınca
  /// çağırıyor).
  Future<void> markAsRead(String conversationId) async {
    try {
      await _dio.post('/messages/conversations/$conversationId/read');
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Bildirimleri sessize al / aç — `POST /conversations/{id}/mute`.
  Future<void> setMuted(String conversationId, bool muted) async {
    try {
      await _dio.post(
        '/messages/conversations/$conversationId/mute',
        data: {'muted': muted},
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Arşivle / arşivden çıkar — `POST /conversations/{id}/archive`.
  Future<void> setArchived(String conversationId, bool archived) async {
    try {
      await _dio.post(
        '/messages/conversations/$conversationId/archive',
        data: {'archived': archived},
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Mesaj gönderir. Web ile aynı gövde: içerik + isteğe bağlı dosya,
  /// yanıtlanan mesaj ve tür (TEXT/IMAGE/FILE/PECS).
  Future<Message> sendMessage(
    String conversationId,
    String content, {
    String messageType = kMessageTypeText,
    String? replyToId,
    String? fileUrl,
    String? fileName,
    String? fileType,
  }) async {
    try {
      final res = await _dio.post(
        '/messages/conversations/$conversationId',
        data: {
          'content': content,
          'messageType': messageType,
          'replyToId': ?replyToId,
          'fileUrl': ?fileUrl,
          'fileName': ?fileName,
          'fileType': ?fileType,
        },
      );
      return Message.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Ekli dosyayı indirir (uç nokta kimlik doğrulaması istediği için
  /// tarayıcıda açılamıyor; Dio ile Bearer'lı indirilip paylaşılır).
  Future<List<int>> downloadAttachment(String url) async {
    try {
      final res = await _dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      return res.data ?? const [];
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Emoji tepkisini açar/kapatır — `POST /messages/{id}/react`. Sunucu
  /// mesajın güncel hâlini döner.
  Future<Message> toggleReaction(String messageId, String emoji) async {
    try {
      final res = await _dio.post(
        '/messages/$messageId/react',
        data: {'emoji': emoji},
      );
      return Message.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final messagingRepositoryProvider = Provider<MessagingRepository>((ref) {
  return MessagingRepository(ref.watch(dioProvider));
});

/// Kullanıcının konuşmaları.
final conversationsProvider = FutureProvider<List<Conversation>>((ref) {
  return ref.watch(messagingRepositoryProvider).getConversations();
});
