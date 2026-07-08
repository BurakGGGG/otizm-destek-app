import 'dart:convert';

/// Backend `Goal` karşılığı (jeton/ödül temelli hedef). `entries` kazanılan
/// jetonların ham listesidir (`{id, date, achieved, note?}`); web ile aynı
/// yapıda saklanır ve ilerletme PUT ile tüm liste gönderilerek yapılır.
class Goal {
  const Goal({
    required this.id,
    required this.title,
    required this.targetCount,
    this.entries = const [],
    this.description,
    this.category,
    this.tokenEmoji,
    this.rewardTitle,
    this.active = true,
  });

  final String id;
  final String title;
  final int targetCount;
  final List<Map<String, dynamic>> entries;
  final String? description;
  final String? category;
  final String? tokenEmoji;
  final String? rewardTitle;
  final bool active;

  /// Kazanılan jeton sayısı.
  int get doneCount => entries.length;

  /// Hedefe ulaşıldı mı?
  bool get completed => targetCount > 0 && doneCount >= targetCount;

  /// 0..1 arası ilerleme oranı.
  double get progress {
    if (targetCount <= 0) return 0;
    return (doneCount / targetCount).clamp(0.0, 1.0);
  }

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      targetCount: (json['targetCount'] as num?)?.toInt() ?? 0,
      entries: _parseEntries(json['entries']),
      description: json['description'] as String?,
      category: json['category'] as String?,
      tokenEmoji: json['tokenEmoji'] as String?,
      rewardTitle: json['rewardTitle'] as String?,
      active: json['active'] as bool? ?? true,
    );
  }

  /// `entries` alanı JSON dizisi ya da dizi içeren string olabilir.
  static List<Map<String, dynamic>> _parseEntries(dynamic raw) {
    dynamic decoded = raw;
    if (raw is String && raw.isNotEmpty) {
      try {
        decoded = jsonDecode(raw);
      } catch (_) {
        return const []; // bozuk JSON
      }
    }
    if (decoded is List) {
      return decoded.whereType<Map<String, dynamic>>().toList();
    }
    return const [];
  }
}
