import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../config/env.dart';
import '../providers.dart';
import '../storage/secure_storage.dart';

/// Tek bir STOMP/SockJS bağlantısını yönetir (backend `/ws`).
///
/// Bağlantı ilk abonelikte kurulur; kopması durumunda otomatik yeniden bağlanır
/// ve mevcut abonelikler yenilenir. CONNECT, backend'in beklediği gibi
/// `Authorization: Bearer <token>` native header'ı ile kimlik doğrular.
class StompService {
  StompService(this._storage);

  final SecureStorage _storage;
  StompClient? _client;
  final List<_Subscription> _subs = [];

  Future<void> _ensureClient() async {
    if (_client != null) return;
    final token = await _storage.readAccessToken() ?? '';
    final headers = {'Authorization': 'Bearer $token'};
    _client = StompClient(
      config: StompConfig.sockJS(
        url: Env.wsUrl,
        stompConnectHeaders: headers,
        webSocketConnectHeaders: headers,
        onConnect: _onConnect,
        reconnectDelay: const Duration(seconds: 5),
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
