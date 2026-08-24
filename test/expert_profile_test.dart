import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/features/reports/domain/report_reasons.dart';
import 'package:otizm_destek_app/features/specialists/domain/expert.dart';
import 'package:otizm_destek_app/features/specialists/presentation/expert_detail_screen.dart';

void main() {
  group('uzman profili alanları', () {
    test('profil bilgileri backend yanıtından okunur', () {
      final expert = Expert.fromJson({
        'id': 'e1',
        'fullName': 'Uzm. Ada Yılmaz',
        'bio': 'On yıldır otizmli çocuklarla çalışıyorum.',
        'ageGroups': ['3-6', '7-12'],
        'supportTopics': ['Dil gelişimi', 'Sosyal beceri'],
        'spokenLanguages': ['Türkçe', 'İngilizce'],
        'sessionDurationMinutes': 45,
        'cancellationPolicy': '24 saat önce haber verin.',
        'sessionFeeMin': 900,
        'sessionFeeMax': 1200,
        'licenseVerified': true,
      });
      expect(expert.bio, startsWith('On yıldır'));
      expect(expert.ageGroups, ['3-6', '7-12']);
      expect(expert.supportTopics.length, 2);
      expect(expert.spokenLanguages, ['Türkçe', 'İngilizce']);
      expect(expert.sessionDurationMinutes, 45);
      expect(expert.licenseVerified, isTrue);
      expect(expert.hasFee, isTrue);
    });

    test('hizmet biçimi bayrakları yalnızca false ise kapanır (web birebir)',
        () {
      final missing = Expert.fromJson({'id': 'e1', 'fullName': 'A'});
      expect(missing.offersOnline, isTrue);
      expect(missing.offersFaceToFace, isTrue);

      final closed = Expert.fromJson({
        'id': 'e1',
        'fullName': 'A',
        'offersOnline': false,
      });
      expect(closed.offersOnline, isFalse);
      expect(closed.offersFaceToFace, isTrue);
    });

    test('boş liste öğeleri ayıklanır', () {
      final expert = Expert.fromJson({
        'id': 'e1',
        'fullName': 'A',
        'ageGroups': ['3-6', '', null, '  '],
      });
      expect(expert.ageGroups, ['3-6']);
    });

    test('ücret etiketi tek fiyat ve aralık olarak biçimlenir', () {
      Expert fee(num? min, num? max) => Expert(
            id: 'e1',
            fullName: 'A',
            sessionFeeMin: min,
            sessionFeeMax: max,
          );
      expect(expertFeeLabel(fee(null, null)), isNull);
      expect(expertFeeLabel(fee(900, null)), '₺900');
      expect(expertFeeLabel(fee(null, 900)), '₺900');
      expect(expertFeeLabel(fee(900, 900)), '₺900');
      expect(expertFeeLabel(fee(900, 1200)), '₺900 – ₺1200');
    });
  });

  group('şikayet metni', () {
    test('neden listesi web REPORT_REASONS ile birebir', () {
      expect(kExpertReportReasons, [
        'Sahte/yanıltıcı profil bilgileri',
        'Lisans belgesi doğrulanamıyor',
        'Uygunsuz veya zararlı içerik',
        'Taciz veya kötüye kullanım',
        'İzinsiz reklam/ticari mesaj',
        'Diğer',
      ]);
    });

    test('açıklama yeni satırla eklenir, boşsa neden tek başına gider', () {
      expect(composeReportReason('Diğer', 'Detay'), 'Diğer\nDetay');
      expect(composeReportReason('Diğer', '   '), 'Diğer');
      expect(composeReportReason('Diğer', null), 'Diğer');
    });
  });
}
