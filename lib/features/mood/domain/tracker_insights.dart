import '../../sleep/domain/sleep_entry.dart';
import 'mood_entry.dart';

/// Günlük takip özeti — web `DailyTrackerPage` başlığındaki dört kutu.
class TrackerInsights {
  const TrackerInsights({
    this.averageSleepMinutes,
    this.topMoodLevel,
    this.topTrigger,
    this.completeDays = 0,
  });

  /// Kayıtlı gecelerin ortalama uyku süresi (dakika); kayıt yoksa null.
  final int? averageSleepMinutes;

  /// En sık girilen ruh hali seviyesi (1-5); kayıt yoksa null.
  final int? topMoodLevel;

  /// En sık işaretlenen tetikleyici; yoksa null.
  final String? topTrigger;

  /// Hem ruh hali hem uyku kaydı girilmiş gün sayısı.
  final int completeDays;
}

/// Ruh hali ve uyku kayıtlarından özet çıkarır (web ile aynı kurallar:
/// ortalama yalnızca süresi olan kayıtlardan, "eksiksiz gün" ikisi de
/// girilmiş gün).
TrackerInsights buildTrackerInsights({
  required List<MoodEntry> moods,
  required List<SleepEntry> sleeps,
}) {
  var totalMinutes = 0;
  var counted = 0;
  for (final sleep in sleeps) {
    final minutes = sleep.durationMinutes;
    if (minutes == null || minutes <= 0) continue;
    totalMinutes += minutes;
    counted++;
  }

  final moodCounts = <int, int>{};
  final triggerCounts = <String, int>{};
  for (final mood in moods) {
    if (mood.moodLevel > 0) {
      moodCounts[mood.moodLevel] = (moodCounts[mood.moodLevel] ?? 0) + 1;
    }
    for (final trigger in mood.triggers) {
      if (trigger.trim().isEmpty) continue;
      triggerCounts[trigger] = (triggerCounts[trigger] ?? 0) + 1;
    }
  }

  int? topKeyOf(Map<int, int> counts) {
    int? top;
    var max = 0;
    for (final entry in counts.entries) {
      if (entry.value > max) {
        max = entry.value;
        top = entry.key;
      }
    }
    return top;
  }

  String? topTriggerOf(Map<String, int> counts) {
    String? top;
    var max = 0;
    for (final entry in counts.entries) {
      if (entry.value > max) {
        max = entry.value;
        top = entry.key;
      }
    }
    return top;
  }

  final moodDays = {for (final mood in moods) mood.entryDate};
  final sleepDays = {for (final sleep in sleeps) sleep.sleepDate};
  final completeDays =
      moodDays.where((day) => day.isNotEmpty && sleepDays.contains(day)).length;

  return TrackerInsights(
    averageSleepMinutes: counted == 0 ? null : (totalMinutes / counted).round(),
    topMoodLevel: topKeyOf(moodCounts),
    topTrigger: topTriggerOf(triggerCounts),
    completeDays: completeDays,
  );
}
