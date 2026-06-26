import 'dart:convert';

/// Backend `Goal` karşılığı (jeton/ödül temelli hedef).
class Goal {
  const Goal({
    required this.id,
    required this.title,
    required this.targetCount,
    required this.doneCount,
    this.description,
    this.category,
    this.tokenEmoji,
    this.active = true,
  });

  final String id;
  final String title;
  final int targetCount;
  final int doneCount;
  final String? description;
  final String? category;
  final String? tokenEmoji;
  final bool active;

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
      doneCount: _entryCount(json['entries']),
      description: json['description'] as String?,
      category: json['category'] as String?,
      tokenEmoji: json['tokenEmoji'] as String?,
      active: json['active'] as bool? ?? true,
    );
  }

  /// `entries` JSON dizisindeki öğe sayısı (kazanılan jetonlar).
  static int _entryCount(dynamic raw) {
    if (raw is List) return raw.length;
    if (raw is String && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is List) return decoded.length;
      } catch (_) {
        // bozuk JSON → 0
      }
    }
    return 0;
  }
}
