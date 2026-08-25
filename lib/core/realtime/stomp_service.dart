import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../config/env.dart';
import '../providers.dart';
import '../storage/secure_storage.dart';

/// Tek bir STOMP/SockJS bağlantısını yönetir (backend `/ws`).
///
/// Bağlantı ilk abonelikte kurulur; kopması durumunda taze token ile yeniden
/// bağlanır ve mevcut abonelikler yenilenir. CONNECT, backend'in beklediği
/// gibi `Authorization: Bearer <token>` native header'ı ile kimlik doğrular.
///
/// Yeniden bağlanma kütüphaneye değil bu sınıfa bırakılmıştır: kütüphanenin
/// kendi `reconnectDelay`'i aynı yapılandırmayı (eski token'ı) tekrar
/// kullanır; token yenilenmişse sonsuz başarısız döngüye girer. Bu yüzden
/// `reconnectDelay: Duration.zero` ile kapatılır, `onWebSocketDone`'da eski
/// istemci atılıp depodan taze token okunarak yeni istemci kurulur.
class StompService {
  StompService(this._storage);

  final SecureStorage _storage;
  StompClient? _client;
  final List<_Subscription> _subs = [];
  bool _disposed = false;

  Future<void> _ensureClient() async {
    if (_client != null || _disposed) return;
    final token = await _storage.readAccessToken() ?? '';
    final headers = {'Authorization': 'Bearer $token'};
    _client = StompClient(
      config: StompConfig.sockJS(
        url: Env.wsUrl,
        stompConnectHeaders: headers,
        webSocketConnectHeaders: headers,
        onConnect: _onConnect,
        onWebSocketDone: _scheduleReconnect,
        // Kütüphanenin yeniden bağlanmasını kapatıyoruz (bkz. sınıf yorumu).
        reconnectDelay: Duration.zero,
      ),
    );
    _client!.activate();
  }

  void _onConnect(StompFrame frame) {
    // (Yeniden) bağlanınca tüm aktif abonelikleri kur.
    for (final s in _subs) {
      _bind(s);
    }
  }

  /// WebSocket kapandığında eski istemciyi atıp taze token ile yeniden kur.
  void _scheduleReconnect() {
    _client = null;
    if (_disposed || _subs.isEmpty) return;
    Future<void>.delayed(const Duration(seconds: 5), () {
      if (!_disposed && _subs.isNotEmpty && _client == null) {
        _ensureClient();
      }
    });
  }

  void _bind(_Subscription s) {
    s.unsubscribe = _client!.subscribe(
      destination: s.destination,
      callback: s.callback,
    );
  }

  /// [destination]'a abone olur; iptal eden fonksiyonu döndürür.
  Future<void Function()> subscribe(
    String destination,
    void Function(StompFrame) callback,
  ) async {
    final sub = _Subscription(destination, callback);
    _subs.add(sub);
    await _ensureClient();
    if (_client?.connected ?? false) _bind(sub);
    return () {
      sub.unsubscribe?.call();
      _subs.remove(sub);
    };
  }

  void dispose() {
    _disposed = true;
    _client?.deactivate();
    _client = null;
    _subs.clear();
  }
}

class _Subscription {
  _Subscription(this.destination, this.callback);
  final String destination;
  final void Function(StompFrame) callback;
  StompUnsubscribe? unsubscribe;
}

final stompServiceProvider = Provider<StompService>((ref) {
  final service = StompService(ref.watch(secureStorageProvider));
  ref.onDispose(service.dispose);
  return service;
});
