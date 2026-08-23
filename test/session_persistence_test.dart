import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/core/storage/secure_storage.dart';

/// Diske ne yazıldığını izleyen sahte anahtar deposu (platform kanalı yok).
class _DiskSpy extends FlutterSecureStorage {
  const _DiskSpy(this.disk);
  final Map<String, String> disk;

  @override
  Future<String?> read({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => disk[key];

  @override
  Future<void> write({
    required String key,
    required String? value,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (value == null) {
      disk.remove(key);
    } else {
      disk[key] = value;
    }
  }

  @override
  Future<void> delete({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => disk.remove(key);
}

/// "Beni hatırla" kapalıyken oturum uygulama kapanınca bitmeli: token'lar
/// diske değil belleğe yazılır.
void main() {
  test('beni hatırla açık: token diske yazılır', () async {
    final disk = <String, String>{};
    final storage = SecureStorage(_DiskSpy(disk));

    await storage.saveTokens(
      accessToken: 'a1',
      refreshToken: 'r1',
      persist: true,
    );

    expect(disk['access_token'], 'a1');
    expect(disk['refresh_token'], 'r1');
    expect(await storage.readAccessToken(), 'a1');
  });

  test('beni hatırla kapalı: token yalnızca bellekte', () async {
    final disk = <String, String>{};
    final storage = SecureStorage(_DiskSpy(disk));

    await storage.saveTokens(
      accessToken: 'a1',
      refreshToken: 'r1',
      persist: false,
    );

    expect(disk, isEmpty, reason: 'oturum içi giriş diske sızmamalı');
    expect(await storage.readAccessToken(), 'a1');
    expect(await storage.readRefreshToken(), 'r1');

    // Uygulamanın yeniden açılması: yeni örnek, bellek boş.
    final restarted = SecureStorage(_DiskSpy(disk));
    expect(await restarted.readAccessToken(), isNull);
  });

  test('token yenileme oturum kipini kalıcıya çevirmez', () async {
    final disk = <String, String>{};
    final storage = SecureStorage(_DiskSpy(disk));

    await storage.saveTokens(accessToken: 'a1', persist: false);
    // RefreshInterceptor `persist` vermeden kaydediyor.
    await storage.saveTokens(accessToken: 'a2', refreshToken: 'r2');

    expect(disk, isEmpty);
    expect(await storage.readAccessToken(), 'a2');
  });

  test('kalıcı oturumdan oturum içine geçince diskteki kopya silinir',
      () async {
    final disk = <String, String>{};
    final storage = SecureStorage(_DiskSpy(disk));

    await storage.saveTokens(
      accessToken: 'a1',
      refreshToken: 'r1',
      persist: true,
    );
    await storage.saveTokens(
      accessToken: 'a2',
      refreshToken: 'r2',
      persist: false,
    );

    expect(disk, isEmpty);
    expect(await storage.readAccessToken(), 'a2');
  });

  test('çıkışta bellek ve disk temizlenir', () async {
    final disk = <String, String>{};
    final storage = SecureStorage(_DiskSpy(disk));

    await storage.saveTokens(accessToken: 'a1', persist: false);
    await storage.clear();
    expect(await storage.readAccessToken(), isNull);

    await storage.saveTokens(accessToken: 'a2', persist: true);
    await storage.clear();
    expect(disk, isEmpty);
    expect(await storage.readAccessToken(), isNull);
  });
}
