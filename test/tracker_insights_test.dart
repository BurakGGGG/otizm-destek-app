import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/features/mood/domain/mood_entry.dart';
import 'package:otizm_destek_app/features/mood/domain/tracker_insights.dart';
import 'package:otizm_destek_app/features/sleep/domain/sleep_entry.dart';

/// Günlük takip özeti (web DailyTrackerPage başlığındaki dört kutu).
void main() {
  MoodEntry mood(String date, int level, {List<String> triggers = const []}) =>
      MoodEntry(
        id: date,
        childId: 'c1',
        entryDate: date,
        moodLevel: level,
        triggers: triggers,
      );

  SleepEntry sleep(String date, {int? minutes}) => SleepEntry(
        id: date,
        childId: 'c1',
        sleepDate: date,
        durationMinutes: minutes,
      );

  test('ortalama uyku yalnızca süresi olan kayıtlardan hesaplanır', () {
    final insights = buildTrackerInsights(
      moods: const [],
      sleeps: [sleep('2026-08-01', minutes: 600), sleep('2026-08-02')],
    );
    expect(insights.averageSleepMinutes, 600);
  });

  test('kayıt yoksa ortalama ve en sık değerler boş', () {
    final insights = buildTrackerInsights(moods: const [], sleeps: const []);
    expect(insights.averageSleepMinutes, isNull);
    expect(insights.topMoodLevel, isNull);
    expect(insights.topTrigger, isNull);
    expect(insights.completeDays, 0);
  });

  test('en sık ruh hali ve tetikleyici bulunur', () {
    final insights = buildTrackerInsights(
      moods: [
        mood('2026-08-01', 4, triggers: ['Uykusuzluk']),
        mood('2026-08-02', 2, triggers: ['Uykusuzluk', 'Sosyal Kaygı']),
        mood('2026-08-03', 2),
      ],
      sleeps: const [],
    );
    expect(insights.topMoodLevel, 2);
    expect(insights.topTrigger, 'Uykusuzluk');
  });

  test('eksiksiz gün: hem ruh hali hem uyku girilmiş gün', () {
    final insights = buildTrackerInsights(
      moods: [mood('2026-08-01', 3), mood('2026-08-02', 3)],
      sleeps: [sleep('2026-08-02', minutes: 540), sleep('2026-08-03')],
    );
    expect(insights.completeDays, 1);
  });
}
