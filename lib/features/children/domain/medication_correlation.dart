import '../../behavior/domain/abc_entry.dart';
import '../../medications/domain/medication.dart';

/// Bir günün ilaç uyumu ve davranış kaydı özeti.
class CorrelationDay {
  const CorrelationDay({
    required this.date,
    required this.behaviorCount,
    required this.takenCount,
    required this.totalCount,
    this.sideEffects = const [],
  });

  /// `yyyy-MM-dd`.
  final String date;

  /// O gün girilen davranış (ABC) kaydı sayısı.
  final int behaviorCount;

  /// Alınan ve planlanan doz sayısı.
  final int takenCount;
  final int totalCount;

  /// O gün işaretlenen yan etkiler (tekrarsız).
  final List<String> sideEffects;

  /// Doz uyum yüzdesi; o gün hiç doz kaydı yoksa null.
  int? get adherence =>
      totalCount == 0 ? null : ((takenCount / totalCount) * 100).round();
}

/// İlaç uyumu ile davranış kayıtlarını gün bazında eşleştirir.
///
/// Web `ChildDetailPage` içindeki "İlaç Uyum & Davranış Korelasyon Grafiği"
/// hesabıyla birebir: iki kaynağın tarihleri birleştirilir, artan sıralanır
/// ve son [limit] gün alınır (web 30).
List<CorrelationDay> buildMedicationCorrelation({
  required List<AbcEntry> behaviors,
  required List<MedicationLog> logs,
  int limit = 30,
}) {
  final behaviorByDate = <String, int>{};
  for (final entry in behaviors) {
    final date = entry.entryDate;
    if (date.isEmpty) continue;
    behaviorByDate[date] = (behaviorByDate[date] ?? 0) + 1;
  }

  final medByDate = <String, ({int taken, int total, List<String> effects})>{};
  for (final log in logs) {
    final date = log.logDate;
    if (date.isEmpty) continue;
    final current =
        medByDate[date] ?? (taken: 0, total: 0, effects: <String>[]);
    final effects = [...current.effects];
    for (final effect in log.sideEffects) {
      if (effect.trim().isEmpty || effects.contains(effect)) continue;
      effects.add(effect);
    }
    medByDate[date] = (
      taken: current.taken + (log.taken ? 1 : 0),
      total: current.total + 1,
      effects: effects,
    );
  }

  final dates = {...behaviorByDate.keys, ...medByDate.keys}.toList()..sort();
  final window = dates.length > limit
      ? dates.sublist(dates.length - limit)
      : dates;

  return [
    for (final date in window)
      CorrelationDay(
        date: date,
        behaviorCount: behaviorByDate[date] ?? 0,
        takenCount: medByDate[date]?.taken ?? 0,
        totalCount: medByDate[date]?.total ?? 0,
        sideEffects: medByDate[date]?.effects ?? const [],
      ),
  ];
}
