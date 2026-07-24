import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Hassas verilerin (token vb.) güvenli saklanması için ince sarmalayıcı.
class SecureStorage {
  SecureStorage([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _kAccessToken = 'access_token';
  static const _kRefreshToken = 'refresh_token';
  static const _kThemeMode = 'theme_mode';

  Future<String?> readAccessToken() => _storage.read(key: _kAccessToken);
  Future<String?> readRefreshToken() => _storage.read(key: _kRefreshToken);

  /// Tema modu tercihi ('system' | 'light' | 'dark'). Çıkışta silinmez.
  Future<String?> readThemeMode() => _storage.read(key: _kThemeMode);
  Future<void> saveThemeMode(String value) =>
      _storage.write(key: _kThemeMode, value: value);

  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _storage.write(key: _kAccessToken, value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: _kRefreshToken, value: refreshToken);
    }
  }

  Future<void> clear() async {
    await _storage.delete(key: _kAccessToken);
    await _storage.delete(key: _kRefreshToken);
  }
}
