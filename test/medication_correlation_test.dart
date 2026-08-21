import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/features/behavior/domain/abc_entry.dart';
import 'package:otizm_destek_app/features/children/domain/medication_correlation.dart';
import 'package:otizm_destek_app/features/medications/domain/medication.dart';

/// İlaç uyumu ↔ davranış korelasyonu (web ChildDetailPage hesabıyla aynı).
void main() {
  AbcEntry behavior(String date) => AbcEntry(
        id: date,
        childId: 'c1',
        entryDate: date,
        antecedent: 'a',
        behavior: 'b',
        consequence: 'c',
        intensity: 3,
      );

  MedicationLog log(String date, {required bool taken, List<String> se = const []}) =>
      MedicationLog(
        id: '$date-${taken ? 1 : 0}-${se.length}',
        medicationId: 'm1',
        logDate: date,
        scheduledTime: '09:00',
        taken: taken,
        sideEffects: se,
      );

  test('gün bazında davranış sayısı ve doz uyumu birleşir', () {
    final days = buildMedicationCorrelation(
      behaviors: [behavior('2026-08-01'), behavior('2026-08-01')],
      logs: [
        log('2026-08-01', taken: true),
        log('2026-08-01', taken: false, se: ['Uykusuzluk']),
      ],
    );
    expect(days, hasLength(1));
    expect(days.single.behaviorCount, 2);
    expect(days.single.takenCount, 1);
    expect(days.single.totalCount, 2);
    expect(days.single.adherence, 50);
    expect(days.single.sideEffects, ['Uykusuzluk']);
  });

  test('yalnızca bir kaynakta olan günler de listelenir', () {
    final days = buildMedicationCorrelation(
      behaviors: [behavior('2026-08-02')],
      logs: [log('2026-08-01', taken: true)],
    );
    expect(days.map((d) => d.date), ['2026-08-01', '2026-08-02']);
    // Doz kaydı olmayan günde uyum yüzdesi yok (web'de "Kayıt Yok").
    expect(days.last.adherence, isNull);
    expect(days.first.behaviorCount, 0);
  });

  test('yan etkiler tekrarsız toplanır', () {
    final days = buildMedicationCorrelation(
      behaviors: const [],
      logs: [
        log('2026-08-01', taken: true, se: ['Uykusuzluk', 'İştahsızlık']),
        log('2026-08-01', taken: true, se: ['Uykusuzluk']),
      ],
    );
    expect(days.single.sideEffects, ['Uykusuzluk', 'İştahsızlık']);
    expect(days.single.adherence, 100);
  });

  test('son 30 gün penceresi uygulanır', () {
    final logs = [
      for (var i = 0; i < 40; i++)
        log('2026-07-${(i + 1).toString().padLeft(2, '0')}', taken: true),
    ];
    final days = buildMedicationCorrelation(behaviors: const [], logs: logs);
    expect(days, hasLength(30));
    // En eski 10 gün düşer.
    expect(days.first.date, '2026-07-11');
  });
}
