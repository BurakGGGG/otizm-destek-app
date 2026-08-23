import 'package:flutter/foundation.dart';

/// Geliştirme günlüğü — **yalnızca debug derlemesinde** yazar.
///
/// `debugPrint` adına rağmen sürüm derlemesinde de çalışır ve yazdığı satır
/// cihaz günlüğüne (logcat) düşer. Uygulamanın taşıdığı veri sağlık verisi
/// olduğu için istisna metinleri, kullanıcı adları ya da istek gövdeleri
/// oraya sızmamalı: cihaz günlüğünü aynı telefondaki başka araçlar da
/// okuyabiliyor.
///
/// Sürümde hata takibi Crashlytics üzerinden yapılır (`recordError`), günlük
/// satırına gerek yok. Bu yüzden `lib/` içinde doğrudan `debugPrint`
/// kullanılmaz; kural `test/logging_hygiene_test.dart` ile korunur.
void logDebug(String message) {
  if (kDebugMode) debugPrint(message);
}

/// Bir istisnayı günlüğe yazar: debug'da tam metin, sürümde hiç.
void logDebugError(String context, Object error) {
  if (kDebugMode) debugPrint('$context: $error');
}
