/// Girişe cihaz tarafında sınır — art arda başarısız denemelerde bekleme.
///
/// Asıl koruma sunucuda: backend `/api/auth/login` için 60 saniyede 10 istekle
/// sınırlı (`@RateLimit`) ve limit aşılınca HTTP 429 döner. Buradaki kural onun
/// yerine geçmez; iki işi yapar:
///
/// * kullanıcı yanlış şifreyi üst üste denerken tuşa basmayı sürdürüp
///   sunucudan 429 yemeden önce ne olduğunu anlatır,
/// * uygulamanın sunucuyu gereksizce dövmesini engeller.
///
/// Backend 429 yanıtında `Retry-After` göndermiyor; o durumda [rateLimited]
/// süresi kullanılır.
class LoginThrottle {
  const LoginThrottle._();

  /// Bu sayıya kadar başarısız deneme serbest.
  static const int freeAttempts = 4;

  /// 429 sonrası beklenen süre (sunucu limiti 60 saniyelik pencerede).
  static const Duration rateLimited = Duration(seconds: 60);

  /// En uzun bekleme.
  static const Duration maxCooldown = Duration(minutes: 5);

  /// [failedAttempts] başarısız denemeden sonra beklenecek süre.
  ///
  /// İlk [freeAttempts] deneme beklemesiz (yazım hatası cezalandırılmasın);
  /// sonrası 15 sn'den başlayıp her denemede ikiye katlanır, [maxCooldown] ile
  /// sınırlanır.
  static Duration cooldownAfter(int failedAttempts) {
    if (failedAttempts <= freeAttempts) return Duration.zero;
    final step = failedAttempts - freeAttempts; // 1, 2, 3…
    final seconds = 15 * (1 << (step - 1));
    if (seconds >= maxCooldown.inSeconds) return maxCooldown;
    return Duration(seconds: seconds);
  }
}
