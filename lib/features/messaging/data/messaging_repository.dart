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

  /// Bir konuşmanın mesajları (en yeni sayfa), eskiden yeniye sıralı.
  Future<List<Message>> getMessages(String conversationId,
      {int page = 0, int size = 30}) async {
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

  Future<Message> sendMessage(String conversationId, String content) async {
    try {
      final res = await _dio.post(
        '/messages/conversations/$conversationId',
        data: {'content': content, 'messageType': 'TEXT'},
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
