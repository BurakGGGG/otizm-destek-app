/// Şifre güvenlik kuralları — backend `StrongPasswordValidator` ile birebir.
///
/// Kayıt, şifre sıfırlama ve şifre değiştirme akışlarında kullanılır
/// (girişte KULLANILMAZ: eski şifreli hesaplar giriş yapabilmeli).
/// Kontroller Java `Character.isUpperCase/isDigit/isLetterOrDigit` ile aynı
/// Unicode kategorilerine bakar; web'deki ASCII+Türkçe regex'i yerine tam
/// karşılık kullanılır ki istemci kabul edip sunucu reddetmesin.
library;

const int kPasswordMinLength = 8;

/// BCrypt yalnızca ilk 72 baytı dikkate alır; backend 64 ile sınırlıyor.
const int kPasswordMaxLength = 64;

/// Sık kullanılan / kolay tahmin edilebilen şifreler (backend listesi birebir).
const Set<String> kCommonPasswords = {
  '12345678', '123456789', '1234567890', 'password', 'password1', 'password123',
  'qwerty123', 'qwertyuiop', '11111111', '00000000', 'abc12345', 'iloveyou',
  'admin123', 'sifre123', 'parola123', '1q2w3e4r', 'q1w2e3r4', '12345678a',
  'aaaaaaaa', '1234abcd', '987654321', 'asdfghjkl', 'zxcvbnm1', 'sifre1234',
  'deneme123', 'test1234', 'welcome1', 'letmein1',
};

/// Şifrenin hangi kuralı çiğnediği. Kullanıcıya gösterilecek metin i18n'de.
enum PasswordIssue { tooShort, tooLong, noUppercase, noDigit, noSpecial, common }

final _upper = RegExp(r'\p{Lu}', unicode: true);
final _digit = RegExp(r'\p{Nd}', unicode: true);
final _special = RegExp(r'[^\p{L}\p{Nd}]', unicode: true);

/// Geçerliyse `null`, değilse ilk çiğnenen kural (backend sırasıyla aynı).
PasswordIssue? validatePassword(String password) {
  if (password.length < kPasswordMinLength) return PasswordIssue.tooShort;
  if (password.length > kPasswordMaxLength) return PasswordIssue.tooLong;
  if (!_upper.hasMatch(password)) return PasswordIssue.noUppercase;
  if (!_digit.hasMatch(password)) return PasswordIssue.noDigit;
  if (!_special.hasMatch(password)) return PasswordIssue.noSpecial;
  if (kCommonPasswords.contains(password.toLowerCase())) {
    return PasswordIssue.common;
  }
  return null;
}

bool isPasswordValid(String password) => validatePassword(password) == null;

/// 0–5 arası güç puanı (web `getPasswordStrength` birebir).
int passwordStrength(String password) {
  if (password.isEmpty) return 0;
  var score = 0;
  if (password.length >= kPasswordMinLength) score++;
  if (password.length >= 12) score++;
  if (_upper.hasMatch(password)) score++;
  if (_digit.hasMatch(password)) score++;
  if (_special.hasMatch(password)) score++;
  return score;
}

/// Kayıt ekranındaki kural rozetleri (web `PASSWORD_RULES` birebir sıra).
enum PasswordRule { minLength, uppercase, digit, special }

bool passwordRuleSatisfied(PasswordRule rule, String password) {
  return switch (rule) {
    PasswordRule.minLength => password.length >= kPasswordMinLength,
    PasswordRule.uppercase => _upper.hasMatch(password),
    PasswordRule.digit => _digit.hasMatch(password),
    PasswordRule.special => _special.hasMatch(password),
  };
}
