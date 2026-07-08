/// Aylık trend noktası — `month` "YYYY-AA" formatında (örn. "2026-07").
class TrendPoint {
  const TrendPoint({required this.month, required this.value});

  final String month;
  final double value;

  /// Ay numarası (1-12); ayrıştırılamazsa 0.
  int get monthNumber {
    final parts = month.split('-');
    return parts.length == 2 ? int.tryParse(parts[1]) ?? 0 : 0;
  }
}

/// `GET /api/analytics/child/{id}/trends` yanıtı — dört aylık seri.
class AnalyticsTrends {
  const AnalyticsTrends({
    required this.milestones,
    required this.moods,
    required this.sleeps,
    required this.behaviors,
  });

  /// Aylık kazanılan kilometre taşı sayısı (`count`).
  final List<TrendPoint> milestones;

  /// Aylık ruh hali ortalaması, 1-5 (`avgLevel`).
  final List<TrendPoint> moods;

  /// Aylık ortalama uyku süresi, dakika (`avgDuration`).
  final List<TrendPoint> sleeps;

  /// Aylık davranış (ABC) kayıt sayısı (`count`).
  final List<TrendPoint> behaviors;

  factory AnalyticsTrends.fromJson(Map<String, dynamic> json) {
    List<TrendPoint> parse(String listKey, String valueKey) {
      final list = json[listKey] as List? ?? const [];
      return [
        for (final raw in list.whereType<Map<String, dynamic>>())
          TrendPoint(
            month: raw['month'] as String? ?? '',
            value: (raw[valueKey] as num?)?.toDouble() ?? 0,
          ),
      ];
    }

    return AnalyticsTrends(
      milestones: parse('milestoneTrends', 'count'),
      moods: parse('moodTrends', 'avgLevel'),
      sleeps: parse('sleepTrends', 'avgDuration'),
      behaviors: parse('behaviorTrends', 'count'),
    );
  }
}
