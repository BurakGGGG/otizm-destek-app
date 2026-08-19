import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/core/util/external_link.dart';

void main() {
  group('dış bağlantı güvenliği', () {
    test('http ve https açılır', () {
      expect(isSafeExternalLink('https://meet.example.com/oda'), isTrue);
      expect(isSafeExternalLink('http://ornek.com/dosya.pdf'), isTrue);
      expect(safeExternalUri('  https://ornek.com  ')?.host, 'ornek.com');
    });

    test('diğer şemalar reddedilir', () {
      // Uzmanın girdiği serbest metin cihazda başka uygulama tetiklememeli.
      expect(isSafeExternalLink('intent://evil#Intent;end'), isFalse);
      expect(isSafeExternalLink('file:///etc/passwd'), isFalse);
      expect(isSafeExternalLink('market://details?id=x'), isFalse);
      expect(isSafeExternalLink('javascript:alert(1)'), isFalse);
      expect(isSafeExternalLink('tel:+905550000000'), isFalse);
    });

    test('şemasız, boş ve bozuk adresler reddedilir', () {
      expect(isSafeExternalLink(null), isFalse);
      expect(isSafeExternalLink(''), isFalse);
      expect(isSafeExternalLink('   '), isFalse);
      expect(isSafeExternalLink('ornek.com/dosya'), isFalse);
      expect(isSafeExternalLink('https://'), isFalse);
    });
  });
}
