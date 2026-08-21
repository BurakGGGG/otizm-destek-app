import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_keys.dart';
import '../../../core/providers.dart';
import '../../../core/router/app_router.dart';
import '../../../firebase_options.dart';
import '../../../i18n/strings.g.dart';

/// Arka plan / uygulama kapalıyken gelen mesajlar için handler.
/// Üst düzey (top-level) ve `vm:entry-point` olmalı — ayrı izolasyonda çalışır.
/// `notification` payload'lı mesajları sistem otomatik gösterir; burada ağır iş
/// yapmıyoruz.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {
    // zaten başlatılmışsa yoksay
  }
  debugPrint('Arka plan bildirimi: ${message.messageId}');
}

/// FCM cihaz push'unu yöneten servis: izin, token kaydı, ön plan + dokunma.
class PushService {
  PushService(this._ref);
  final Ref _ref;
  bool _started = false;

  FirebaseMessaging get _messaging => FirebaseMessaging.instance;

  /// Oturum açıldıktan sonra çağrılır. Bir kez kurar, tekrar çağrıda token tazeler.
  Future<void> init() async {
    if (_started) {
      await registerToken();
      return;
    }
    _started = true;

    try {
      await _messaging
          .requestPermission(); // iOS + Android 13+ çalışma anı izni
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      await registerToken();
      _messaging.onTokenRefresh.listen(_sendToken);

      FirebaseMessaging.onMessage.listen(_onForeground);
      FirebaseMessaging.onMessageOpenedApp.listen(_onOpened);

      // Uygulama bildirime dokunularak kapalıdan açıldıysa:
      final initial = await _messaging.getInitialMessage();
      if (initial != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _onOpened(initial));
      }
    } catch (e) {
      debugPrint('Push kurulum hatası: $e');
    }
  }

  /// Cihaz bildirim izni verilmiş mi? Firebase kurulmadıysa (ör. testler)
  /// `null` döner ve arayüz satırı hiç göstermez.
  Future<bool?> hasPermission() async {
    try {
      final settings = await _messaging.getNotificationSettings();
      return settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
    } catch (_) {
      return null;
    }
  }

  /// Kullanıcı isteğiyle izni yeniden ister; verilip verilmediğini döner.
  /// Kalıcı reddedilmişse sistem penceresi açılmaz, `false` döner.
  Future<bool> requestPermission() async {
    try {
      final settings = await _messaging.requestPermission();
      final granted =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
              settings.authorizationStatus == AuthorizationStatus.provisional;
      if (granted) await registerToken();
      return granted;
    } catch (_) {
      return false;
    }
  }

  /// Geçerli FCM token'ını backend'e kaydet.
  Future<void> registerToken() async {
    try {
      final token = await _messaging.getToken();
      if (token != null && token.isNotEmpty) await _sendToken(token);
    } catch (e) {
      debugPrint('FCM token alınamadı: $e');
    }
  }

  Future<void> _sendToken(String token) async {
    try {
      await _ref
          .read(dioProvider)
          .post(
            '/push/device-token',
            data: {'token': token, 'platform': 'ANDROID'},
          );
    } on DioException catch (e) {
      // Backend uç noktası henüz yoksa (404) ya da geçici hata: sessiz geç.
      debugPrint('Cihaz token kaydı atlandı (${e.response?.statusCode}).');
    }
  }

  /// Çıkışta token'ı backend'den kaldır (idempotent, hata yutulur).
  Future<void> unregister() async {
    try {
      final token = await _messaging.getToken();
      if (token == null || token.isEmpty) return;
      await _ref
          .read(dioProvider)
          .delete('/push/device-token', queryParameters: {'token': token});
    } catch (e) {
      debugPrint('Cihaz token silme atlandı: $e');
    }
  }

  void _onForeground(RemoteMessage m) {
    final n = m.notification;
    final title = n?.title ?? m.data['title']?.toString() ?? '';
    final body = n?.body ?? m.data['body']?.toString() ?? '';
    final text = [title, body].where((s) => s.isNotEmpty).join(' — ');
    if (text.isEmpty) return;

    final messenger = rootScaffoldMessengerKey.currentState;
    messenger?.showSnackBar(
      SnackBar(
        content: Text(text),
        action: _routeFor(m.data) != null
            ? SnackBarAction(
                label: t.notifications.show,
                onPressed: () => _navigate(m.data),
              )
            : null,
      ),
    );
  }

  void _onOpened(RemoteMessage m) => _navigate(m.data);

  /// `data.type`'a göre hedef rota (yoksa null).
  ({String path, Object? extra})? _routeFor(Map<String, dynamic> data) {
    switch ((data['type'] ?? '').toString().toUpperCase()) {
      case 'MESSAGE':
        final id = data['conversationId']?.toString();
        if (id != null && id.isNotEmpty) {
          return (
            path: '/messages/thread',
            extra: {
              'id': id,
              'title': data['conversationTitle']?.toString() ?? '',
            },
          );
        }
        return (path: '/messages', extra: null);
      case 'APPOINTMENT':
        return (path: '/appointments', extra: null);
      default:
        return null;
    }
  }

  void _navigate(Map<String, dynamic> data) {
    final route = _routeFor(data);
    if (route == null) return;
    _ref.read(goRouterProvider).push(route.path, extra: route.extra);
  }
}

final pushServiceProvider = Provider<PushService>((ref) => PushService(ref));

/// Cihaz bildirim izninin durumu (Ayarlar ekranındaki satır için).
final pushPermissionProvider = FutureProvider<bool?>((ref) {
  return ref.watch(pushServiceProvider).hasPermission();
});
