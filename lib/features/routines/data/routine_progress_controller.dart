import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/util/date_key.dart';

/// Bugün tamamlanan rutin adımları ve yıldız cüzdanı.
class RoutineProgress {
  const RoutineProgress({
    this.dateKey = '',
    this.completed = const {},
    this.stars = 0,
  });

  /// Kayıtların ait olduğu gün (yerel saat, `yyyy-MM-dd`).
  final String dateKey;

  /// rutin kimliği → tamamlanan adım kimlikleri.
  final Map<String, Set<String>> completed;

  /// Toplanan yıldız sayısı (gün geçse de sıfırlanmaz).
  final int stars;

  bool isDone(String routineId, String itemId) =>
      completed[routineId]?.contains(itemId) ?? false;

  /// Rutinin bugünkü tamamlanma yüzdesi (0..100).
  int percentOf(String routineId, int itemCount) {
    if (itemCount == 0) return 0;
    final done = completed[routineId]?.length ?? 0;
    return ((done / itemCount) * 100).round().clamp(0, 100);
  }
}

/// Rutin adımlarının günlük işaretlenmesi — cihazda saklanır, backend'e
/// gitmez (web de `localStorage` kullanıyor).
///
/// Web her gün için ayrı bir anahtar (`routine_completed_<tarih>`) açıp
/// eskileri hiç silmiyor; mobilde tek anahtarda gün bilgisiyle tutuyoruz,
/// böylece depo her günle birlikte büyümüyor. Yıldız sayacı web'deki gibi
/// `routine_stars`.
class RoutineProgressController extends Notifier<RoutineProgress> {
  static const _completedKey = 'routine_completed';
  static const _starsKey = 'routine_stars';

  late final Future<void> _ready;

  /// Cihazdaki kayıt okunana kadar bekler. [toggle] bunu kendisi bekler;
  /// testler de sıralamayı buradan garantiler.
  Future<void> get ready => _ready;

  @override
  RoutineProgress build() {
    _ready = _restore();
    return RoutineProgress(dateKey: localDateKey(DateTime.now()));
  }

  Future<void> _restore() async {
    final storage = ref.read(secureStorageProvider);
    final today = localDateKey(DateTime.now());
    var stars = 0;
    var completed = <String, Set<String>>{};
    try {
      final rawStars = await storage.readPreference(_starsKey);
      stars = int.tryParse(rawStars ?? '') ?? 0;

      final raw = await storage.readPreference(_completedKey);
      if (raw != null && raw.isNotEmpty) {
        final decoded = jsonDecode(raw);
        if (decoded is Map && decoded['date'] == today) {
          final items = decoded['items'];
          if (items is Map) {
            completed = {
              for (final entry in items.entries)
                '${entry.key}': {
                  if (entry.value is List)
                    for (final id in entry.value as List) '$id',
                },
            };
          }
        }
      }
    } catch (_) {
      // Bozuk kayıt: bugün boş başlar, yıldız korunur.
    }
    state = RoutineProgress(
      dateKey: today,
      completed: completed,
      stars: stars,
    );
  }

  /// Bir adımı tamamlandı/tamamlanmadı yapar; tamamlamada +1 yıldız,
  /// geri almada -1 (web ile aynı davranış, sıfırın altına inmez).
  Future<bool> toggle(String routineId, String itemId) async {
    // Geri yükleme bitmeden işaretlenirse kayıt üzerine yazılırdı.
    await _ready;
    final today = localDateKey(DateTime.now());
    final base = state.dateKey == today
        ? state.completed
        : const <String, Set<String>>{};
    final next = {
      for (final entry in base.entries) entry.key: {...entry.value},
    };
    final set = next.putIfAbsent(routineId, () => <String>{});
    final done = !set.contains(itemId);
    done ? set.add(itemId) : set.remove(itemId);
    if (set.isEmpty) next.remove(routineId);

    final stars = done ? state.stars + 1 : (state.stars - 1).clamp(0, 1 << 31);
    state = RoutineProgress(dateKey: today, completed: next, stars: stars);

    final storage = ref.read(secureStorageProvider);
    try {
      await storage.savePreference(
        _completedKey,
        jsonEncode({
          'date': today,
          'items': {
            for (final entry in next.entries) entry.key: entry.value.toList(),
          },
        }),
      );
      await storage.savePreference(_starsKey, '$stars');
    } catch (_) {
      // Yazılamazsa oturum içi durum korunur.
    }
    return done;
  }
}

final routineProgressProvider =
    NotifierProvider<RoutineProgressController, RoutineProgress>(
  RoutineProgressController.new,
);
