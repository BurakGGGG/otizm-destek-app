import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/core/util/person_name.dart';

void main() {
  group('ad ayrıştırma (web getFirstName birebir)', () {
    test('unvanlar atlanır', () {
      // Web'de 'Psk.' unvan listesinde olmadığı için ad "Psk." çıkıyor;
      // mobilde liste genişletildi.
      expect(personFirstName('Uzm. Psk. Selin Aksoy'), 'Selin');
      expect(personFirstName('Dr. Kemal Aydın'), 'Kemal');
      expect(personFirstName('Ada Yılmaz'), 'Ada');
    });

    test('boş ve tek parçalı adlar', () {
      expect(personFirstName(null), '');
      expect(personFirstName('   '), '');
      expect(personFirstName('ada'), 'Ada');
    });
  });

  group('avatar baş harfleri', () {
    test('unvan atlanır, iki harf alınır', () {
      expect(personInitials('Uzm. Psk. Selin Aksoy'), 'SA');
      expect(personInitials('Dr. Kemal Aydın'), 'KA');
      expect(personInitials('Ada Yılmaz'), 'AY');
    });

    test('tek isimde tek harf, boş adda boş', () {
      expect(personInitials('Ada'), 'A');
      expect(personInitials(''), '');
    });
  });
}
