import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/core/network/api_exception.dart';
import 'package:otizm_destek_app/i18n/strings.g.dart';

/// Kullanıcıya gösterilen hata metni ve cihaz günlüğü hijyeni.
void main() {
  setUpAll(() => LocaleSettings.setLocaleSync(AppLocale.tr));

  group('sunucu mesajı süzgeci', () {
    test('kısa ve anlaşılır mesaj olduğu gibi geçer', () {
      expect(
        ApiException.safeServerMessage(
          'Bu e-posta adresi zaten kullanılıyor',
          statusCode: 409,
        ),
        'Bu e-posta adresi zaten kullanılıyor',
      );
      expect(
        ApiException.safeServerMessage(
          'Giriş yapmadan önce e-posta adresinizi doğrulayın',
          statusCode: 400,
        ),
        isNotNull,
      );
    });

    test('sunucu hatasında (5xx) metin gösterilmez', () {
      expect(
        ApiException.safeServerMessage('Herhangi bir metin', statusCode: 500),
        isNull,
      );
      expect(
        ApiException.safeServerMessage('Bir şey oldu', statusCode: 503),
        isNull,
      );
    });

    test('iç ayrıntı taşıyan metinler elenir', () {
      const leaks = [
        'java.lang.NullPointerException: null',
        'org.springframework.dao.DataIntegrityViolationException',
        'Caused by: com.autismsupport.platform.service.ChildService',
        'ERROR: duplicate key value violates unique constraint SQLSTATE 23505',
        'SELECT u.id FROM users u WHERE u.email = ?',
        '<html><body>502 Bad Gateway</body></html>',
      ];
      for (final leak in leaks) {
        expect(
          ApiException.safeServerMessage(leak, statusCode: 400),
          isNull,
          reason: leak,
        );
      }
    });

    test('boş metin ve aşırı uzun metin elenir', () {
      expect(ApiException.safeServerMessage('   ', statusCode: 400), isNull);
      expect(ApiException.safeServerMessage(null, statusCode: 400), isNull);
      expect(
        ApiException.safeServerMessage('a' * 301, statusCode: 400),
        isNull,
      );
      expect(
        ApiException.safeServerMessage('a' * 300, statusCode: 400),
        isNotNull,
      );
    });
  });

  test('lib/ içinde doğrudan debugPrint kullanılmıyor', () {
    // Sürüm derlemesinde de yazdığı için istisna metinleri cihaz günlüğüne
    // düşüyordu; günlükler `logDebug`/`logDebugError` üzerinden geçmeli.
    final offenders = <String>[];
    for (final file in Directory('lib').listSync(recursive: true)) {
      if (file is! File || !file.path.endsWith('.dart')) continue;
      if (file.path.endsWith('core/util/app_log.dart')) continue;
      final content = file.readAsStringSync();
      if (content.contains('debugPrint(')) offenders.add(file.path);
    }
    expect(
      offenders,
      isEmpty,
      reason: 'Bu dosyalar doğrudan debugPrint kullanıyor: $offenders',
    );
  });
}
