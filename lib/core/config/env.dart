/// Ortam (environment) yapılandırması.
///
/// Değerler derleme sırasında `--dart-define` (ya da hazır profillerle
/// `--dart-define-from-file`) ile override edilebilir:
///   flutter run --dart-define-from-file=config/render.json
///   flutter run --dart-define-from-file=config/otizmdestek.json
///
/// Varsayılanlar bugün **canlı olan** dağıtıma işaret eder: API Render'daki
/// instance (web PWA'nın da konuştuğu adres), paylaşılan bağlantılar ise
/// Vercel'deki web dağıtımı. Özel alan adı (`otizmdestek.com`) DNS'te
/// yayına girdiğinde `config/otizmdestek.json` profiliyle geçilir.
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

  /// Web platformunun genel adresi. Paylaşılan bağlantılar (acil durum kartı)
  /// ve rehber videoları alıcının tarayıcısında bu adreste açılır.
  ///
  /// Varsayılan, `apiBaseUrl` ile **aynı backend'e** bağlı olan canlı web
  /// dağıtımıdır; böylece mobilden paylaşılan bağlantı aynı veriyi gösterir.
  static const String webBaseUrl = String.fromEnvironment(
    'WEB_BASE_URL',
    defaultValue: 'https://otizm-destek-platformu.vercel.app',
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
