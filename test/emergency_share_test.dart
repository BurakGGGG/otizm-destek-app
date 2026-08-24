import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/core/config/env.dart';
import 'package:otizm_destek_app/features/emergency/domain/emergency_card.dart';
import 'package:otizm_destek_app/features/emergency/presentation/emergency_share_card.dart';

void main() {
  group('acil durum kartı paylaşım durumu', () {
    test('etkin paylaşım jetonuyla birlikte okunur', () {
      final status = EmergencyShareStatus.fromJson(const {
        'shareEnabled': true,
        'shareToken': 'abc123',
        'expiresAt': '2026-08-20T10:30:00',
        'consentGranted': true,
      });
      expect(status.isActive, isTrue);
      expect(status.shareToken, 'abc123');
      expect(status.expiresAt, DateTime(2026, 8, 20, 10, 30));
      expect(status.consentGranted, isTrue);
    });

    test('jeton yoksa paylaşım etkin sayılmaz', () {
      final status = EmergencyShareStatus.fromJson(const {
        'shareEnabled': true,
        'shareToken': null,
        'expiresAt': null,
        'consentGranted': true,
      });
      expect(status.isActive, isFalse);
      expect(status.expiresAt, isNull);
    });

    test('rıza yokken paylaşım kapalı gelir', () {
      final status = EmergencyShareStatus.fromJson(const {
        'shareEnabled': false,
        'consentGranted': false,
      });
      expect(status.isActive, isFalse);
      expect(status.consentGranted, isFalse);
    });
  });

  group('paylaşım bağlantısı', () {
    test('web adresine yönlenir (alıcı tarayıcıda açar)', () {
      expect(
        emergencyShareUrl('tok3n'),
        '${Env.webBaseUrl}/acil-profil/tok3n',
      );
    });

    test('süre seçenekleri backend sınırları içinde', () {
      expect(kEmergencyShareHours, [24, 72, 168, 720]);
      for (final hours in kEmergencyShareHours) {
        expect(hours, greaterThanOrEqualTo(1));
        expect(hours, lessThanOrEqualTo(720)); // MAX_SHARE_HOURS
      }
    });
  });
}
