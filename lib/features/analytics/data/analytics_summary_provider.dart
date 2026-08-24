import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../appointments/data/appointment_repository.dart';
import '../../appointments/domain/appointment.dart';
import '../../behavior/data/abc_repository.dart';
import '../../behavior/domain/abc_entry.dart';
import '../../children/data/milestone_repository.dart';
import '../../children/data/screening_repository.dart';
import '../../children/domain/milestone.dart';
import '../../children/domain/screening_result.dart';
import '../../mood/data/mood_repository.dart';
import '../../mood/domain/mood_entry.dart';
import '../../notes/data/note_repository.dart';
import '../../notes/domain/development_note.dart';
import '../../sleep/data/sleep_repository.dart';
import '../../sleep/domain/sleep_entry.dart';
import '../domain/analytics_summary.dart';

/// Gelişim panelinin ham veri kaynakları — hepsi ayrı ayrı yakalanır ki
/// biri düşse bile panel çizilsin (web de her isteği tek tek yakalıyor).
class AnalyticsSources {
  const AnalyticsSources({
    this.moods = const [],
    this.sleeps = const [],
    this.notes = const [],
    this.milestones = const [],
    this.behaviors = const [],
    this.appointments = const [],
    this.screenings = const [],
  });

  final List<MoodEntry> moods;
  final List<SleepEntry> sleeps;
  final List<DevelopmentNote> notes;
  final List<Milestone> milestones;
  final List<AbcEntry> behaviors;
  final List<Appointment> appointments;
  final List<ScreeningResult> screenings;
}

Future<T> _safe<T>(Future<T> future, T fallback) async {
  try {
    return await future;
  } catch (_) {
    return fallback;
  }
}

/// Seçili çocuğun panel verisi. Aralık değişince yeniden hesaplanır ama
/// kaynaklar aynı sağlayıcılardan geldiği için tekrar indirilmez.
final analyticsSourcesProvider =
    FutureProvider.family<AnalyticsSources, String>((ref, childId) async {
  final moods = _safe(
      ref.watch(moodEntriesProvider(childId).future), const <MoodEntry>[]);
  final sleeps = _safe(
      ref.watch(sleepEntriesProvider(childId).future), const <SleepEntry>[]);
  final notes = _safe(ref.watch(recentNotesProvider(childId).future),
      const <DevelopmentNote>[]);
  final milestones = _safe(
      ref.watch(milestonesProvider(childId).future), const <Milestone>[]);
  final behaviors =
      _safe(ref.watch(abcEntriesProvider(childId).future), const <AbcEntry>[]);
  final appointments =
      _safe(ref.watch(appointmentsProvider.future), const <Appointment>[]);
  final screenings = _safe(ref.watch(screeningResultsProvider(childId).future),
      const <ScreeningResult>[]);

  return AnalyticsSources(
    moods: await moods,
    sleeps: await sleeps,
    notes: await notes,
    milestones: await milestones,
    behaviors: await behaviors,
    appointments: await appointments,
    screenings: await screenings,
  );
});

/// Aralığa göre hesaplanmış özet (seriler, kırılımlar, skor, öngörüler).
final analyticsSummaryProvider = FutureProvider.family<AnalyticsSummary,
    ({String childId, int rangeDays})>((ref, key) async {
  final sources = await ref.watch(analyticsSourcesProvider(key.childId).future);
  return buildAnalyticsSummary(
    rangeDays: key.rangeDays,
    now: DateTime.now(),
    moods: sources.moods,
    sleeps: sources.sleeps,
    notes: sources.notes,
    milestones: sources.milestones,
    behaviors: sources.behaviors,
    appointments: sources.appointments,
    screenings: sources.screenings,
  );
});
