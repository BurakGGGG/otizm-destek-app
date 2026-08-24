import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/features/analytics/domain/analytics_summary.dart';
import 'package:otizm_destek_app/features/appointments/domain/appointment.dart';
import 'package:otizm_destek_app/features/behavior/domain/abc_entry.dart';
import 'package:otizm_destek_app/features/children/domain/milestone.dart';
import 'package:otizm_destek_app/features/mood/domain/mood_entry.dart';
import 'package:otizm_destek_app/features/notes/domain/development_note.dart';
import 'package:otizm_destek_app/features/sleep/domain/sleep_entry.dart';

void main() {
  final now = DateTime(2026, 8, 20, 10);

  String day(int back) {
    final d = now.subtract(Duration(days: back));
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }

  MoodEntry mood(int back, int level) => MoodEntry(
        id: 'm$back',
        childId: 'c1',
        entryDate: day(back),
        moodLevel: level,
      );

  SleepEntry sleep(int back, {int minutes = 480, int quality = 4}) =>
      SleepEntry(
        id: 's$back',
        childId: 'c1',
        sleepDate: day(back),
        durationMinutes: minutes,
        quality: quality,
      );

  AbcEntry behavior(int back, {String? category, int intensity = 3}) =>
      AbcEntry(
        id: 'b$back',
        childId: 'c1',
        entryDate: day(back),
        antecedent: 'a',
        behavior: 'b',
        consequence: 'c',
        intensity: intensity,
        category: category,
      );

  group('aralık süzme', () {
    test('aralık dışındaki kayıtlar seriye girmez', () {
      final summary = buildAnalyticsSummary(
        rangeDays: 7,
        now: now,
        moods: [mood(0, 4), mood(3, 5), mood(20, 1)],
      );
      expect(summary.moodPoints.length, 2);
      expect(summary.averageMood, closeTo(4.5, 0.001));
    });

    test('seriler tarihe göre artan sıralanır', () {
      final summary = buildAnalyticsSummary(
        rangeDays: 30,
        now: now,
        moods: [mood(1, 3), mood(5, 4), mood(0, 5)],
      );
      expect(summary.moodPoints.map((p) => p.date).toList(),
          [day(5), day(1), day(0)]);
    });

    test('uyku saati tek ondalığa yuvarlanır (web birebir)', () {
      final summary = buildAnalyticsSummary(
        rangeDays: 7,
        now: now,
        sleeps: [sleep(0, minutes: 585)],
      );
      expect(summary.sleepHourPoints.single.value, 9.8);
      expect(summary.averageSleepMinutes, 585);
    });
  });

  group('kırılımlar', () {
    test('davranış kategorileri adete göre sıralanır ve şiddet ortalanır', () {
      final summary = buildAnalyticsSummary(
        rangeDays: 30,
        now: now,
        behaviors: [
          behavior(1, category: 'Duyusal', intensity: 4),
          behavior(2, category: 'Duyusal', intensity: 2),
          behavior(3, category: 'Geçiş', intensity: 5),
        ],
      );
      expect(summary.behaviorCategories.first.name, 'Duyusal');
      expect(summary.behaviorCategories.first.count, 2);
      expect(summary.behaviorCategories.first.averageIntensity, 3);
    });

    test('kategorisiz kayıtlar Diğer altında toplanır', () {
      final summary = buildAnalyticsSummary(
        rangeDays: 30,
        now: now,
        behaviors: [behavior(1), behavior(2, category: '   ')],
      );
      expect(summary.behaviorCategories.single.name, kAnalyticsOtherCategory);
      expect(summary.behaviorCategories.single.count, 2);
    });

    test('not aktivitesi son altı ayla sınırlanır', () {
      final notes = [
        for (var i = 0; i < 9; i++)
          DevelopmentNote(
            id: 'n$i',
            title: 'not',
            noteDate: DateTime(2026, 1 + i, 5),
          ),
      ];
      final summary =
          buildAnalyticsSummary(rangeDays: 30, now: now, notes: notes);
      expect(summary.notesByMonth.length, 6);
      expect(summary.notesByMonth.first.name, '2026-04');
      expect(summary.notesByMonth.last.name, '2026-09');
    });
  });

  group('skor ve öngörüler', () {
    test('veri yoksa skor düşük ve öneriler dolu', () {
      final summary = buildAnalyticsSummary(rangeDays: 30, now: now);
      expect(summary.wellbeingScore, 0);
      expect(summary.level, WellbeingLevel.waiting);
      expect(summary.actions.length, 3); // en fazla üç öneri
      expect(summary.isEmpty, isTrue);
    });

    test('iyi ruh hali ve uyku skoru yükseltir', () {
      final summary = buildAnalyticsSummary(
        rangeDays: 30,
        now: now,
        moods: [mood(0, 5), mood(1, 5), mood(2, 4)],
        sleeps: [sleep(0, minutes: 600), sleep(1, minutes: 600)],
        milestones: [
          Milestone(
            id: 'ms1',
            title: 'İlk cümle',
            category: 'Dil',
            achievedDate: now.subtract(const Duration(days: 3)),
          ),
        ],
        notes: [
          DevelopmentNote(id: 'n1', title: 'not', noteDate: now),
        ],
        appointments: [
          Appointment(
            id: 'a1',
            date: now.subtract(const Duration(days: 5)),
            time: '10:00',
            status: 'COMPLETED',
          ),
        ],
      );
      expect(summary.wellbeingScore, greaterThan(75));
      expect(summary.level, WellbeingLevel.strong);
      expect(summary.actions, isEmpty);
      expect(
        summary.insights.map((i) => i.kind),
        containsAll([
          InsightKind.moodHigh,
          InsightKind.sleepGood,
          InsightKind.topMilestoneCategory,
          InsightKind.appointments,
        ]),
      );
    });

    test('üç kayıttan az ruh hali öngörü üretmez', () {
      final summary = buildAnalyticsSummary(
        rangeDays: 30,
        now: now,
        moods: [mood(0, 5), mood(1, 5)],
      );
      expect(
        summary.insights.where((i) => i.kind == InsightKind.moodHigh),
        isEmpty,
      );
    });

    test('kısa uyku uyarısı sekiz saatin altında çıkar', () {
      final summary = buildAnalyticsSummary(
        rangeDays: 30,
        now: now,
        sleeps: [sleep(0, minutes: 420)],
      );
      expect(summary.insights.first.kind, InsightKind.sleepShort);
      expect(summary.insights.first.value, '7s');
    });
  });

  group('CSV', () {
    test('başlık satırı ve kayıtlar tırnaklanır', () {
      final csv = analyticsCsv(
        moods: [mood(0, 4)],
        sleeps: [sleep(1, minutes: 465)],
        milestones: [
          Milestone(
            id: 'ms1',
            title: 'İlk "merhaba"',
            achievedDate: DateTime(2026, 8, 10),
          ),
        ],
      );
      final lines = csv.split('\n');
      expect(lines.first, '"tür","tarih","değer","not"');
      expect(lines[1], contains('"Ruh Hali"'));
      expect(lines[2], contains('"7s 45dk"'));
      // Metindeki tırnak ikilenir.
      expect(lines[3], contains('İlk ""merhaba""'));
    });
  });
}
