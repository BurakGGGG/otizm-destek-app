import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/core/network/upload_rules.dart';
import 'package:otizm_destek_app/features/chatbot/data/chatbot_repository.dart';
import 'package:otizm_destek_app/features/chatbot/domain/chat_message.dart';
import 'package:otizm_destek_app/core/util/input_rules.dart';
import 'package:otizm_destek_app/features/auth/domain/login_throttle.dart';

/// Girişe sınır, girdi doğrulama ve yükleme sınırlarının saf kuralları.
/// Sınırlar backend sözleşmesiyle aynı tutulmalı (bkz. docs/security.md).
void main() {
  group('giriş denemesi sınırı', () {
    test('ilk denemeler beklemesiz', () {
      for (var i = 0; i <= LoginThrottle.freeAttempts; i++) {
        expect(LoginThrottle.cooldownAfter(i), Duration.zero, reason: '$i');
      }
    });

    test('sonraki denemelerde bekleme ikiye katlanır', () {
      expect(
        LoginThrottle.cooldownAfter(LoginThrottle.freeAttempts + 1),
        const Duration(seconds: 15),
      );
      expect(
        LoginThrottle.cooldownAfter(LoginThrottle.freeAttempts + 2),
        const Duration(seconds: 30),
      );
      expect(
        LoginThrottle.cooldownAfter(LoginThrottle.freeAttempts + 3),
        const Duration(seconds: 60),
      );
    });

    test('bekleme üst sınırı aşılmaz', () {
      expect(LoginThrottle.cooldownAfter(50), LoginThrottle.maxCooldown);
      expect(
        LoginThrottle.cooldownAfter(9).inSeconds,
        lessThanOrEqualTo(LoginThrottle.maxCooldown.inSeconds),
      );
    });
  });

  group('e-posta biçimi', () {
    test('geçerli adresler kabul edilir', () {
      for (final email in [
        'veli@example.com',
        'uzman.psk@klinik.example.org',
        'a+etiket@alt.alan.com',
        '  bosluklu@example.com  ',
      ]) {
        expect(isValidEmail(email), isTrue, reason: email);
      }
    });

    test('bozuk adresler elenir', () {
      for (final email in [
        '',
        'veli',
        'veli@',
        '@example.com',
        'veli@example',
        'veli @example.com',
        'veli@exa mple.com',
      ]) {
        expect(isValidEmail(email), isFalse, reason: email);
      }
    });
  });

  group('tek satır temizliği', () {
    test('satır sonu ve kontrol karakterleri boşluğa döner', () {
      expect(sanitizeSingleLine('Ada\nYılmaz'), 'Ada Yılmaz');
      expect(sanitizeSingleLine('Ada\tYılmaz'), 'Ada Yılmaz');
      expect(sanitizeSingleLine('  Ada   Yılmaz  '), 'Ada Yılmaz');
    });

    test('metin kırpılır', () {
      expect(limitLength('abcdef', 3), 'abc');
      expect(limitLength('ab', 5), 'ab');
    });
  });

  group('yükleme sınırları', () {
    test('desteklenen türler backend listesiyle aynı', () {
      expect(
        kAllowedUploadTypes.values.toSet(),
        {
          'image/jpeg',
          'image/png',
          'image/webp',
          'image/gif',
          'application/pdf',
          'text/plain',
        },
      );
      expect(uploadContentTypeFor('foto.JPG'), 'image/jpeg');
      expect(uploadContentTypeFor('rapor.pdf'), 'application/pdf');
    });

    test('sınır 10 MB', () {
      expect(kMaxUploadBytes, 10 * 1024 * 1024);
      expect(
        uploadRejection(fileName: 'foto.jpg', sizeBytes: kMaxUploadBytes),
        isNull,
      );
      expect(
        uploadRejection(fileName: 'foto.jpg', sizeBytes: kMaxUploadBytes + 1),
        UploadRejection.tooLarge,
      );
    });

    test('boş dosya ve desteklenmeyen tür reddedilir', () {
      expect(
        uploadRejection(fileName: 'foto.jpg', sizeBytes: 0),
        UploadRejection.empty,
      );
      expect(
        uploadRejection(fileName: 'video.mp4', sizeBytes: 1024),
        UploadRejection.unsupportedType,
      );
      expect(
        uploadRejection(fileName: 'uzantisiz', sizeBytes: 1024),
        UploadRejection.unsupportedType,
      );
      // Uzantı gizlemeye çalışan ad: son uzantı dikkate alınır.
      expect(
        uploadRejection(fileName: 'zararli.jpg.exe', sizeBytes: 1024),
        UploadRejection.unsupportedType,
      );
    });
  });

  group('sohbet geçmişi tavanı', () {
    ChatMessage msg(int i) => ChatMessage(
          role: i.isEven ? ChatRole.user : ChatRole.assistant,
          text: 'mesaj $i',
        );

    test('kısa geçmiş olduğu gibi gider', () {
      final history = List.generate(6, msg);
      expect(ChatbotRepository.trimHistory(history), hasLength(6));
    });

    test('uzun geçmişte yalnızca son turlar gider', () {
      final history = List.generate(60, msg);
      final trimmed = ChatbotRepository.trimHistory(history);
      expect(trimmed, hasLength(kMaxChatHistoryTurns));
      // En yeni mesaj korunur, en eskiler düşer.
      expect(trimmed.last.text, 'mesaj 59');
      expect(trimmed.first.text, 'mesaj ${60 - kMaxChatHistoryTurns}');
    });
  });
}
