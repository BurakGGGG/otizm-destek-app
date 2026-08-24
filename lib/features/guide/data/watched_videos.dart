import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';

/// İzlenen eğitim videolarının kimlikleri (cihazda saklanır — web'in
/// localStorage'daki `otizm-tutorial-videos-watched` listesiyle aynı amaç,
/// sunucuda tutulmaz).
class WatchedVideosController extends Notifier<Set<String>> {
  static const _storageKey = 'tutorial-videos-watched';

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
      state = raw.split(',').where((id) => id.isNotEmpty).toSet();
    } catch (_) {
      // Depo okunamazsa liste boş kalır; işaretleme yine çalışır.
    }
  }

  Future<void> _persist() async {
    try {
      await ref
          .read(secureStorageProvider)
          .savePreference(_storageKey, state.join(','));
    } catch (_) {
      // Kayıt başarısızsa işaret oturum içinde geçerli kalır.
    }
  }

  Future<void> markWatched(String id) async {
    if (state.contains(id)) return;
    state = {...state, id};
    await _persist();
  }

  Future<void> toggle(String id) async {
    state = state.contains(id)
        ? ({...state}..remove(id))
        : {...state, id};
    await _persist();
  }
}

final watchedVideosProvider =
    NotifierProvider<WatchedVideosController, Set<String>>(
      WatchedVideosController.new,
    );
