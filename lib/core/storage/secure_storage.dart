import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Hassas verilerin (token vb.) güvenli saklanması için ince sarmalayıcı.
///
/// iOS/macOS'ta anahtarlık öğeleri `first_unlock_this_device` ile yazılır:
/// paketin varsayılanı (`unlocked`) yedeklemeyle **başka bir cihaza taşınır**,
/// oturum token'ının taşınmasını istemiyoruz. `first_unlock` (kilidin ilk
/// açılmasından sonra) seçildi ki arka planda gelen push'ta token okunabilsin.
///
/// Android'de paket zaten KeyStore destekli AES-GCM kullanıyor (v10'da
/// `encryptedSharedPreferences` kullanımdan kalktı), ek seçenek gerekmiyor.
class SecureStorage {
  SecureStorage([FlutterSecureStorage? storage])
    : _storage =
          storage ??
          const FlutterSecureStorage(
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock_this_device,
            ),
            mOptions: MacOsOptions(
              accessibility: KeychainAccessibility.first_unlock_this_device,
            ),
          );

  final FlutterSecureStorage _storage;

  /// "Beni hatırla" kapalıyken token'lar diske değil buraya yazılır: uygulama
  /// kapanınca oturum biter (ortak kullanılan cihazlarda beklenen davranış).
  final Map<String, String> _sessionTokens = {};
  bool _sessionOnly = false;

  static const _kAccessToken = 'access_token';
  static const _kRefreshToken = 'refresh_token';
  static const _kThemeMode = 'theme_mode';

  Future<String?> readAccessToken() async =>
      _sessionTokens[_kAccessToken] ?? await _storage.read(key: _kAccessToken);
  Future<String?> readRefreshToken() async =>
      _sessionTokens[_kRefreshToken] ??
      await _storage.read(key: _kRefreshToken);

  /// Tema modu tercihi ('system' | 'light' | 'dark'). Çıkışta silinmez.
  Future<String?> readThemeMode() => _storage.read(key: _kThemeMode);
  Future<void> saveThemeMode(String value) =>
      _storage.write(key: _kThemeMode, value: value);

  /// Uygulama tercihleri (bildirim/gizlilik/erişilebilirlik). Oturum verisi
  /// değildir; çıkışta silinmez.
  Future<String?> readPreference(String key) =>
      _storage.read(key: 'pref_$key');
  Future<void> savePreference(String key, String value) =>
      _storage.write(key: 'pref_$key', value: value);

  /// [persist] verilmezse mevcut oturum kipi korunur — token yenileme
  /// (`RefreshInterceptor`) oturum içi bir girişi kalıcıya çeviremesin.
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
    bool? persist,
  }) async {
    if (persist != null) _sessionOnly = !persist;

    if (_sessionOnly) {
      _sessionTokens[_kAccessToken] = accessToken;
      if (refreshToken != null) _sessionTokens[_kRefreshToken] = refreshToken;
      // Daha önce kalıcı bir oturum varsa diskte kalmasın.
      await _storage.delete(key: _kAccessToken);
      await _storage.delete(key: _kRefreshToken);
      return;
    }

    _sessionTokens.clear();
    await _storage.write(key: _kAccessToken, value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: _kRefreshToken, value: refreshToken);
    }
  }

  Future<void> clear() async {
    _sessionTokens.clear();
    _sessionOnly = false;
    await _storage.delete(key: _kAccessToken);
    await _storage.delete(key: _kRefreshToken);
  }
}
