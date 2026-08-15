import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/core/util/password_rules.dart';

void main() {
  group('şifre doğrulama (backend StrongPasswordValidator birebir)', () {
    test('kurallara uyan şifre geçerli', () {
      expect(validatePassword('Ebeveyn2026!'), isNull);
      expect(isPasswordValid('Ebeveyn2026!'), isTrue);
    });

    test('kısa şifre reddedilir', () {
      expect(validatePassword('Ab1!'), PasswordIssue.tooShort);
    });

    test('64 karakterden uzun şifre reddedilir', () {
      final long = 'A1!${'a' * 62}';
      expect(long.length, greaterThan(kPasswordMaxLength));
      expect(validatePassword(long), PasswordIssue.tooLong);
    });

    test('büyük harf yoksa reddedilir', () {
      expect(validatePassword('ebeveyn2026!'), PasswordIssue.noUppercase);
    });

    test('rakam yoksa reddedilir', () {
      expect(validatePassword('EbeveynDestek!'), PasswordIssue.noDigit);
    });

    test('özel karakter yoksa reddedilir', () {
      expect(validatePassword('Ebeveyn2026'), PasswordIssue.noSpecial);
    });

    test('yaygın şifreler önce diğer kurallara takılır (backend sırası)', () {
      // Listedeki şifrelerin tamamı alfanümerik olduğundan "yaygın" kontrolüne
      // sıra gelmeden özel karakter/büyük harf kuralında elenirler.
      expect(validatePassword('Password123'), PasswordIssue.noSpecial);
      expect(validatePassword('Sifre123'), PasswordIssue.noSpecial);
      expect(validatePassword('12345678'), PasswordIssue.noUppercase);
    });

    test('Türkçe büyük harf ve boşluk backend ile aynı sayılır', () {
      // 'Ç' büyük harf (Lu), boşluk harf/rakam olmadığı için özel karakter.
      expect(validatePassword('Çocuk 2026'), isNull);
      // 'ı' küçük harf; büyük harf yok.
      expect(validatePassword('çocuk 2026'), PasswordIssue.noUppercase);
    });
  });

  group('şifre gücü (web getPasswordStrength birebir)', () {
    test('boş şifre 0', () => expect(passwordStrength(''), 0));

    test('yalnızca uzunluk', () {
      expect(passwordStrength('abcdefgh'), 1);
      expect(passwordStrength('abcdefghijkl'), 2);
    });

    test('tüm ölçütler 5', () {
      expect(passwordStrength('Ebeveyn2026!xy'), 5);
    });
  });

  group('kural rozetleri', () {
    test('her kural ayrı ayrı değerlendirilir', () {
      expect(passwordRuleSatisfied(PasswordRule.minLength, 'abcdefgh'), isTrue);
      expect(passwordRuleSatisfied(PasswordRule.uppercase, 'abcdefgh'), isFalse);
      expect(passwordRuleSatisfied(PasswordRule.digit, 'abcdefg1'), isTrue);
      expect(passwordRuleSatisfied(PasswordRule.special, 'abcdefg1'), isFalse);
      expect(passwordRuleSatisfied(PasswordRule.special, 'abcdefg1!'), isTrue);
    });
  });
}
