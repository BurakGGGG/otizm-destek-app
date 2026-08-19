import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/features/messaging/domain/conversation.dart';
import 'package:otizm_destek_app/features/messaging/domain/message.dart';
import 'package:otizm_destek_app/features/messaging/domain/pecs_cards.dart';
import 'package:otizm_destek_app/features/messaging/presentation/conversations_screen.dart';

void main() {
  Conversation conv({
    required String id,
    String type = 'DIRECT',
    int unread = 0,
    bool archived = false,
    String? otherRole,
  }) {
    return Conversation(
      id: id,
      type: type,
      unreadCount: unread,
      archived: archived,
      participants: [
        const Participant(id: 'me', fullName: 'Ben', role: 'PARENT'),
        if (otherRole != null)
          Participant(id: 'o', fullName: 'Diğer', role: otherRole),
      ],
    );
  }

  group('konuşma süzgeçleri (web ConvFilter birebir)', () {
    final list = [
      conv(id: 'a', unread: 2, otherRole: 'PARENT'),
      conv(id: 'b', otherRole: 'EXPERT'),
      conv(id: 'c', type: 'GROUP'),
      conv(id: 'd', unread: 5, archived: true, otherRole: 'EXPERT'),
    ];

    List<String> ids(ConversationFilter f) =>
        filterConversations(list, f, 'me').map((c) => c.id).toList();

    test('varsayılan sekme arşivi gizler', () {
      expect(ids(ConversationFilter.all), ['a', 'b', 'c']);
    });

    test('okunmamış sekmesi arşivdekini saymaz', () {
      expect(ids(ConversationFilter.unread), ['a']);
    });

    test('uzmanlar sekmesi grupları dışarıda bırakır', () {
      expect(ids(ConversationFilter.experts), ['b']);
    });

    test('gruplar sekmesi yalnızca grupları verir', () {
      expect(ids(ConversationFilter.groups), ['c']);
    });

    test('arşiv sekmesi yalnızca arşivi verir', () {
      expect(ids(ConversationFilter.archived), ['d']);
    });
  });

  group('PECS kartları paylaşılan veri', () {
    test('web PECS_CARDS ile aynı etiketler ve sıra', () {
      expect(kPecsCards.map((c) => c.label).toList(), [
        'Mutluyum',
        'Üzgünüm',
        'Öfkeliyim',
        'Korkuyorum',
        'Açım',
        'Susadım',
        'Tuvalet',
        'Yardım',
        'Dinlenmek',
        'Oynamak',
        'Uyumak',
        'Eve Gitmek',
      ]);
    });

    test('mesaj içeriği kart etiketiyle eşleşince emoji çıkar', () {
      expect(pecsCardForContent('Açım')?.emoji, '🍔');
      expect(pecsCardForContent('  Tuvalet ')?.emoji, '🚽');
      expect(pecsCardForContent('merhaba'), isNull);
    });

    test('kategoriler web ile aynı ve hepsi kart içerir', () {
      expect(kPecsCategories, ['Duygular', 'İhtiyaçlar', 'Günlük']);
      for (final category in kPecsCategories) {
        expect(pecsCardsOf(category), isNotEmpty);
      }
      expect(
        kPecsCategories.fold<int>(0, (n, c) => n + pecsCardsOf(c).length),
        kPecsCards.length,
      );
    });
  });

  group('mesaj ayrıştırma', () {
    test('ek, yanıt ve tepkiler okunur', () {
      final message = Message.fromJson({
        'id': 'm1',
        'conversationId': 'cv1',
        'senderId': 'u2',
        'content': 'Bak bu haftaki program',
        'messageType': 'IMAGE',
        'fileUrl': '/api/upload/plan.png',
        'fileName': 'plan.png',
        'fileType': 'image/png',
        'replyToId': 'm0',
        'replyToContent': 'Programı paylaşır mısın?',
        'replyToSenderName': 'Elif',
        'reactions': {
          '👍': {'count': 2, 'reactedByMe': true},
          '❤️': {'count': 1, 'reactedByMe': false},
        },
      });
      expect(message.hasImage, isTrue);
      expect(message.hasFile, isFalse);
      expect(message.replyToSenderName, 'Elif');
      expect(message.reactions['👍']?.count, 2);
      expect(message.reactions['👍']?.reactedByMe, isTrue);
      expect(message.reactions['❤️']?.reactedByMe, isFalse);
    });

    test('görsel olmayan ek dosya sayılır', () {
      final message = Message.fromJson({
        'id': 'm2',
        'senderId': 'u2',
        'messageType': 'FILE',
        'fileUrl': '/api/upload/rapor.pdf',
        'fileType': 'application/pdf',
      });
      expect(message.hasFile, isTrue);
      expect(message.hasImage, isFalse);
    });

    test('eksik alanlar güvenli varsayılana düşer', () {
      final message = Message.fromJson({'id': 'm3', 'senderId': 'u2'});
      expect(message.reactions, isEmpty);
      expect(message.hasImage, isFalse);
      expect(message.hasFile, isFalse);
      expect(message.messageType, kMessageTypeText);
    });

    test('hızlı tepkiler web listesiyle aynı', () {
      expect(kQuickReactions, ['👍', '❤️', '😂', '😮', '😢', '🙏']);
    });
  });
}
