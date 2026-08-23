/// Yükleme sınırları — backend sözleşmesiyle **birebir**.
///
/// Sunucu tarafı `FileStorageService` içerik türü + uzantı eşleşmesi + dosya
/// imzası (magic bytes) doğruluyor ve `spring.servlet.multipart.max-file-size`
/// 10 MB. Buradaki kontroller onun yerine geçmez; amaç kullanıcıyı mobil
/// veriyle koca bir dosyayı yükleyip sunucudan anlamsız bir hata almaktan
/// kurtarmak. Sınırlar sunucudakiyle aynı tutulmalı: gevşetmek yüklemenin
/// sunucuda reddedilmesine, sıkmak ise kabul edilebilir dosyaların
/// engellenmesine yol açar.
library;

/// `spring.servlet.multipart.max-file-size: 10MB`.
const int kMaxUploadBytes = 10 * 1024 * 1024;

/// Uzantı → içerik türü (backend `ALLOWED_EXTENSIONS_BY_TYPE` ile aynı küme).
const Map<String, String> kAllowedUploadTypes = {
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.png': 'image/png',
  '.webp': 'image/webp',
  '.gif': 'image/gif',
  '.pdf': 'application/pdf',
  '.txt': 'text/plain',
};

/// Dosya adının uzantısı (küçük harf, noktayla; yoksa boş metin).
String uploadExtensionOf(String fileName) {
  final dot = fileName.lastIndexOf('.');
  if (dot < 0 || dot == fileName.length - 1) return '';
  return fileName.substring(dot).toLowerCase();
}

/// Uzantıya karşılık gelen içerik türü; desteklenmiyorsa `null`.
String? uploadContentTypeFor(String fileName) =>
    kAllowedUploadTypes[uploadExtensionOf(fileName)];

/// Yükleme neden reddedildi? Sorun yoksa `null`.
///
/// Dönen değer bir hata **kodu**dur; kullanıcıya gösterilecek metin arayüz
/// katmanında çevrilir (bu dosya i18n'e bağlı değil ki saf kalsın).
UploadRejection? uploadRejection({
  required String fileName,
  required int sizeBytes,
}) {
  if (sizeBytes <= 0) return UploadRejection.empty;
  if (sizeBytes > kMaxUploadBytes) return UploadRejection.tooLarge;
  if (uploadContentTypeFor(fileName) == null) {
    return UploadRejection.unsupportedType;
  }
  return null;
}

/// Reddetme nedeni.
enum UploadRejection { empty, tooLarge, unsupportedType }
