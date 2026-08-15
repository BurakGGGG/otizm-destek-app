import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/core/network/auth_cookies.dart';

const _jwt = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI0Mi01In0.Rr-3_signature';

void main() {
  group('refresh token Set-Cookie ayrıştırma', () {
    test('tam çerez satırından token okunur', () {
      const header =
          'refresh_token=$_jwt; Path=/api/auth; Max-Age=604800; '
          'Expires=Sat, 22 Aug 2026 22:09:56 GMT; HttpOnly; Secure; SameSite=None';
      expect(refreshTokenFromSetCookie(header), _jwt);
    });

    test('başka çerezler yok sayılır', () {
      const header =
          'media_session=$_jwt; Path=/api/upload; Max-Age=900; HttpOnly';
      expect(refreshTokenFromSetCookie(header), isNull);
    });

    test('çıkışta gönderilen boş çerez null döner', () {
      const header =
          'refresh_token=; Path=/api/auth; Max-Age=0; '
          'Expires=Thu, 01 Jan 1970 00:00:00 GMT; HttpOnly';
      expect(refreshTokenFromSetCookie(header), isNull);
    });

    test('tek satırda virgülle birleşmiş çerezlerde token bulunur', () {
      const header =
          'media_session=abc; Path=/api/upload; '
          'Expires=Sat, 22 Aug 2026 22:09:56 GMT, '
          'refresh_token=$_jwt; Path=/api/auth; HttpOnly';
      expect(refreshTokenFromSetCookie(header), _jwt);
    });

    test('benzer adlı çerez token sanılmaz', () {
      const header = 'app_refresh_token=sahte; Path=/';
      expect(refreshTokenFromSetCookie(header), isNull);
    });

    test('birden çok Set-Cookie başlığı arasından doğru olan seçilir', () {
      final headers = Headers.fromMap({
        'set-cookie': [
          'media_session=abc; Path=/api/upload; HttpOnly',
          'refresh_token=$_jwt; Path=/api/auth; HttpOnly; Secure',
        ],
      });
      expect(refreshTokenFromHeaders(headers), _jwt);
    });

    test('Set-Cookie yoksa null döner', () {
      final headers = Headers.fromMap({
        'content-type': ['application/json'],
      });
      expect(refreshTokenFromHeaders(headers), isNull);
    });
  });
}
