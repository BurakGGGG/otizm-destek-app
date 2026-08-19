import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

/// Kullanıcının açtığı ekranların yolları (cihazda saklanır).
///
/// Ana sayfadaki başlangıç kontrol listesi ve "topluluğu keşfet" adımı,
/// bir bölümün görülüp görülmediğini buradan bilir. Web aynı bilgiyi
/// `guide-visited-routes` anahtarıyla localStorage'da tutar; orada yalnızca
/// rehberden tıklanan bağlantılar sayılır, mobilde gerçek ziyaretler işlenir.
class VisitedRoutesController extends Notifier<Set<String>> {
  static const _storageKey = 'visited-routes';

  /// Topluluk sayılan yollar (web'deki liste + mobildeki topluluk merkezi).
  static const communityRoutes = {
    '/community',
    '/weekly-question',
    '/forum',
    '/similar-families',
    '/support-wall',
    '/meetups',
    '/groups',
  };

  @override
  Set<String> build() {
    _restore();
    return const {};
  }

  Future<void> _restore() async {
    try {
      final raw =
          await ref.read(secureStorageProvider).readPreference(_storageKey);
      if (raw == null || raw.isEmpty) return;
      // Geri yükleme, oturum içinde işaretlenenleri silmemeli.
      state = {...state, ...raw.split(',').where((r) => r.isNotEmpty)};
    } catch (_) {
      // Depo okunamazsa liste boş kalır; işaretleme yine çalışır.
    }
  }

  /// Bir yolu ziyaret edilmiş işaretler. Aynı yol tekrar gelirse yazma yapmaz.
  Future<void> mark(String route) async {
    if (route.isEmpty || state.contains(route)) return;
    state = {...state, route};
    try {
      await ref
          .read(secureStorageProvider)
          .savePreference(_storageKey, state.join(','));
    } catch (_) {
      // Kayıt başarısızsa işaret oturum içinde geçerli kalır.
    }
  }

  bool has(String route) => state.contains(route);

  bool hasAny(Iterable<String> routes) => routes.any(state.contains);
}

final visitedRoutesProvider =
    NotifierProvider<VisitedRoutesController, Set<String>>(
      VisitedRoutesController.new,
    );
