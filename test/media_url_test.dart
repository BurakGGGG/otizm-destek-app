import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/core/config/env.dart';
import 'package:otizm_destek_app/core/network/media.dart';

void main() {
  group('medya adresi mutlaklaştırma', () {
    test('göreli yükleme adresi backend köküyle birleştirilir', () {
      expect(
        absoluteMediaUrl('/api/upload/abc.jpg'),
        '${Env.apiBaseUrl}/api/upload/abc.jpg',
      );
    });

    test('baştaki eğik çizgi yoksa eklenir', () {
      expect(
        absoluteMediaUrl('api/upload/abc.jpg'),
        '${Env.apiBaseUrl}/api/upload/abc.jpg',
      );
    });

    test('mutlak adres olduğu gibi kalır', () {
      expect(
        absoluteMediaUrl('https://cdn.example.com/a.png'),
        'https://cdn.example.com/a.png',
      );
    });

    test('boş/null adres null döner', () {
      expect(absoluteMediaUrl(null), isNull);
      expect(absoluteMediaUrl('   '), isNull);
    });
  });

  group('backend medyası ayrımı (token sızıntısı koruması)', () {
    test('göreli adres backend sayılır', () {
      expect(isBackendMediaUrl('/api/upload/abc.jpg'), isTrue);
    });

    test('kendi backend adresimiz backend sayılır', () {
      expect(isBackendMediaUrl('${Env.apiBaseUrl}/api/upload/abc.jpg'), isTrue);
    });

    test('üçüncü taraf adrese Bearer gönderilmez', () {
      expect(isBackendMediaUrl('https://cdn.example.com/a.png'), isFalse);
    });

    test('data URI backend sayılmaz', () {
      expect(isBackendMediaUrl('data:image/png;base64,AAAA'), isFalse);
    });
  });
}
