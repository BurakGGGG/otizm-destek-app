import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/presentation/auth_controller.dart';
import 'network/dio_client.dart';
import 'storage/secure_storage.dart';

/// Güvenli depo (token saklama).
final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorage();
});

/// Backend için yapılandırılmış Dio istemcisi.
///
/// Token sağlayıcı güvenli depodaki backend access token'ını gönderir;
/// 401'de refresh interceptor devreye girer, yenileme de başarısızsa oturum kapanır.
final dioProvider = Provider<Dio>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return buildDioClient(
    tokenProvider: () => storage.readAccessToken(),
    storage: storage,
    onSessionExpired: () async {
      ref.read(authControllerProvider.notifier).onSessionExpired();
    },
  );
});
