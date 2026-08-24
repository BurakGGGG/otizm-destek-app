import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/providers.dart';
import '../../../i18n/strings.g.dart';
import '../domain/chat_message.dart';

/// Sunucuya taşınan en fazla konuşma turu (kullanıcı + asistan mesajı = 2 tur).
///
/// Her mesajda geçmişin tamamı yeniden gönderiliyor ve modele giren jeton
/// sayısı konuşma uzadıkça kartopu gibi büyüyor: 30 mesajlık bir sohbette
/// 30. istek önceki 29 mesajı da taşır. Ne mobilde ne sunucuda bir tavan
/// vardı; 20 tur (10 karşılıklı) sıradan bir destek sohbetinin tamamını
/// kapsar, uzun oturumlarda maliyeti sabitler. Sunucu tarafına da tavan
/// konmalı (bkz. docs/security.md §22).
const int kMaxChatHistoryTurns = 20;

/// `/api/chatbot/stream` SSE uç noktasını saran depo.
class ChatbotRepository {
  ChatbotRepository(this._dio);
  final Dio _dio;

  /// Geçmişin sunucuya gidecek son [kMaxChatHistoryTurns] turu.
  static List<ChatMessage> trimHistory(List<ChatMessage> history) =>
      history.length <= kMaxChatHistoryTurns
          ? history
          : history.sublist(history.length - kMaxChatHistoryTurns);

  /// Asistan yanıtını parça parça (SSE `chunk`) yayınlar.
  /// `done` olayında biter, `error` olayında [ApiException] fırlatır.
  Stream<String> streamReply({
    required String message,
    required List<ChatMessage> history,
  }) async* {
    final Response<ResponseBody> response;
    try {
      response = await _dio.post<ResponseBody>(
        '/chatbot/stream',
        data: {
          'message': message,
          'history':
              trimHistory(history).map((m) => m.toHistoryJson()).toList(),
        },
        options: Options(
          responseType: ResponseType.stream,
          headers: {'Accept': 'text/event-stream'},
        ),
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }

    final body = response.data;
    if (body == null) throw ApiException(t.chat.errorGeneric);

    final lines = body.stream
        .cast<List<int>>()
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    var event = '';
    final data = StringBuffer();

    await for (final line in lines) {
      if (line.isEmpty) {
        // Boş satır = SSE olayının sonu → işle.
        if (event == 'chunk') {
          yield data.toString();
        } else if (event == 'done') {
          return;
        } else if (event == 'error') {
          final msg = data.toString();
          throw ApiException(msg.isEmpty ? t.chat.errorGeneric : msg);
        }
        event = '';
        data.clear();
        continue;
      }
      if (line.startsWith('event:')) {
        event = line.substring(6).trim();
      } else if (line.startsWith('data:')) {
        // Backend `data:` sonrası boşluk koymaz; boşluklar gerçek içeriktir
        // (Gemini kelime aralıkları), bu yüzden kırpmıyoruz.
        if (data.isNotEmpty) data.write('\n');
        data.write(line.substring(5));
      }
    }
  }
}

final chatbotRepositoryProvider = Provider<ChatbotRepository>((ref) {
  return ChatbotRepository(ref.watch(dioProvider));
});
