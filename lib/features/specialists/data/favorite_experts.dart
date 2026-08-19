import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';

/// Favori uzmanlar — cihazda saklanır (web localStorage
/// `expert_favorites_v1` ile aynı amaç; sunucuda tutulmaz).
class FavoriteExpertsController extends Notifier<Set<String>> {
  static const _storageKey = 'expert_favorites_v1';

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
      state = {...state, ...raw.split(',').where((id) => id.isNotEmpty)};
    } catch (_) {
      // Depo okunamazsa liste boş kalır; işaretleme yine çalışır.
    }
  }

  Future<void> toggle(String expertId) async {
    state = state.contains(expertId)
        ? ({...state}..remove(expertId))
        : {...state, expertId};
    try {
      await ref
          .read(secureStorageProvider)
          .savePreference(_storageKey, state.join(','));
    } catch (_) {
      // Kayıt başarısızsa seçim oturum içinde geçerli kalır.
    }
  }
}

final favoriteExpertsProvider =
    NotifierProvider<FavoriteExpertsController, Set<String>>(
      FavoriteExpertsController.new,
    );
