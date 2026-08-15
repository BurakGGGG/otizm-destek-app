/// Ortam (environment) yapılandırması.
///
/// Değerler derleme sırasında `--dart-define` ile override edilebilir, ör:
///   flutter run --dart-define=API_BASE_URL=https://otizm-backend.onrender.com
///
/// Varsayılanlar mevcut canlı backend'e işaret eder.
class Env {
  const Env._();

  /// Spring Boot backend kök adresi.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://otizm-backend.onrender.com',
  );

  /// REST uç noktalarının ön eki (ör. /api/cocuklarim).
  static const String apiPrefix = String.fromEnvironment(
    'API_PREFIX',
    defaultValue: '/api',
  );

  /// Web platformunun genel adresi. Paylaşılan bağlantılar (ör. acil durum
  /// kartı) alıcının tarayıcısında bu adreste açılır.
  static const String webBaseUrl = String.fromEnvironment(
    'WEB_BASE_URL',
    defaultValue: 'https://otizmdestek.com',
  );

  /// STOMP/SockJS WebSocket yolu (gerçek zamanlı mesajlaşma).
  static const String wsPath = String.fromEnvironment(
    'WS_PATH',
    defaultValue: '/ws',
  );

  /// `true` ise ağ istekleri/cevapları loglanır (yalnızca geliştirme).
  static const bool enableNetworkLogs = bool.fromEnvironment(
    'ENABLE_NETWORK_LOGS',
    defaultValue: true,
  );

  /// Render ücretsiz katmanı soğuk başlatma yapabildiği için cömert timeout.
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static String get apiBase => '$apiBaseUrl$apiPrefix';
  static String get wsUrl => '$apiBaseUrl$wsPath';
}
