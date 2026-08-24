/// Girdi kuralları — sınırlar backend DTO kısıtlarıyla (`@Size`) **aynı**.
///
/// Sunucu zaten doğruluyor; buradaki kurallar iki işe yarar: kullanıcı 4000
/// karakteri yazıp gönderdikten sonra hata almasın, ve tek satırlık alanlara
/// yapıştırılan çok satırlı/kontrol karakterli metin veritabanına olduğu gibi
/// gitmesin. Sunucudaki sınır değişirse burası da güncellenmeli.
library;

import 'package:flutter/services.dart';

/// `@Size(max = 200)` — başlık alanları (not, forum gönderisi, buluşma).
const int kMaxTitleLength = 200;

/// `@Size(max = 500)` — kısa açıklama, biyografi, görüşme bağlantısı.
const int kMaxShortTextLength = 500;

/// `@Size(max = 1000)` — yorumlar.
const int kMaxCommentLength = 1000;

/// `@Size(max = 2000)` — mesaj gövdesi, geri bildirim, açıklama.
const int kMaxTextLength = 2000;

/// `@Size(max = 4000)` — uzun serbest metin (gönderi içeriği, açıklama).
const int kMaxLongTextLength = 4000;

/// Basit e-posta biçim kontrolü.
///
/// Amaç yazım hatasını yakalamak; adresin gerçekten var olduğunu yalnızca
/// doğrulama e-postası gösterir. RFC'nin tamamını uygulamaya çalışmak geçerli
/// adresleri eleyip kullanıcıyı kilitler.
bool isValidEmail(String value) {
  final email = value.trim();
  if (email.isEmpty || email.length > 254) return false;
  return _emailPattern.hasMatch(email);
}

final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s.]+(\.[^@\s.]+)+$');

/// Tek satırlık alanlar için: kenar boşluklarını atar, satır sonu ve kontrol
/// karakterlerini boşluğa çevirir, art arda boşlukları tekler.
String sanitizeSingleLine(String value) {
  final cleaned = value.replaceAll(_controlChars, ' ');
  return cleaned.replaceAll(_repeatedSpaces, ' ').trim();
}

/// C0/C1 kontrol karakterleri (satır sonu dahil).
final RegExp _controlChars = RegExp(r'[\u0000-\u001F\u007F]');
final RegExp _repeatedSpaces = RegExp(r'\s{2,}');

/// Metni [max] karaktere kırpar — alanlarda [lengthLimit] varken son çare
/// (ör. yapıştırılan metin başka bir yoldan geldiyse).
String limitLength(String value, int max) =>
    value.length <= max ? value : value.substring(0, max);

/// Metin alanına takılacak uzunluk sınırlayıcı.
///
/// `maxLength` yerine bunu kullanıyoruz: sayaç göstermeden, sessizce sınırı
/// uygular (sayaç bütün formların düzenini değiştirirdi).
List<TextInputFormatter> lengthLimit(int max) => [
      LengthLimitingTextInputFormatter(max),
    ];
