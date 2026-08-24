import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/visited_routes.dart';
import '../../../core/util/date_key.dart';
import '../../../core/util/person_name.dart';
import '../../calendar/data/calendar_repository.dart';
import '../../calendar/domain/calendar_event.dart';
import '../../children/data/child_repository.dart';
import '../../children/domain/child.dart';
import '../../children/data/connection_repository.dart';
import '../../children/domain/expert_connection.dart';
import '../../emergency/data/emergency_repository.dart';
import '../../emergency/domain/emergency_card.dart';
import '../../medications/data/medication_repository.dart';
import '../../medications/domain/medication.dart';
import '../../messaging/data/messaging_repository.dart';
import '../../messaging/domain/conversation.dart';
import '../../mood/data/mood_repository.dart';
import '../../mood/domain/mood_entry.dart';
import '../../notes/data/note_repository.dart';
import '../../notes/domain/development_note.dart';
import '../domain/daily_plan.dart';

/// İşaretlenmemiş bugünkü doz sayısı (web `getPendingMedicationSlots`).
int pendingMedicationSlots(List<Medication> medications) {
  return medications.where((m) => m.isActive).fold<int>(0, (count, med) {
    final pending = med.scheduledTimes
        .where((time) => med.logFor(time)?.taken != true)
        .length;
    return count + pending;
  });
}

/// Bir alt sağlayıcı hata verirse plan tümden düşmesin: web de her isteği
/// tek tek yakalayıp varsayılana dönüyor.
Future<T> _safe<T>(Future<T> future, T fallback) async {
  try {
    return await future;
  } catch (_) {
    return fallback;
  }
}

/// Ana sayfadaki günlük planın girdisi. Aktif çocuk = listedeki ilk çocuk
/// (mobilde çocuk seçici ana sayfada değil, Çocuklarım ekranında).
final dailyPlanInputProvider = FutureProvider<DailyPlanInput>((ref) async {
  final now = DateTime.now();
  final visited = ref.watch(visitedRoutesProvider);
  final visitedCommunity =
      visited.any(VisitedRoutesController.communityRoutes.contains);

  final children =
      await _safe(ref.watch(childrenProvider.future), const <Child>[]);
  if (children.isEmpty) {
    return DailyPlanInput(
      now: now,
      hasChild: false,
      visitedCommunity: visitedCommunity,
    );
  }

  final child = children.first;
  final childId = child.id;
  // Koç notu web gibi yalnızca ilk adı kullanır (unvanlar atlanır).
  final childName = personFirstName(child.name);
  final todayKey = localDateKey(now);

  final moodEntries = _safe(
      ref.watch(moodEntriesProvider(childId).future), const <MoodEntry>[]);
  final medications = _safe(
      ref.watch(medicationsProvider(childId).future), const <Medication>[]);
  final events = _safe(
      ref.watch(calendarEventsProvider(childId).future),
      const <CalendarEvent>[]);
  final notes = _safe(
      ref.watch(recentNotesProvider(childId).future),
      const <DevelopmentNote>[]);
  final conversations = _safe(
      ref.watch(conversationsProvider.future), const <Conversation>[]);
  final requests = _safe(
      ref.watch(connectionRequestsProvider.future),
      const <ExpertConnection>[]);
  final emergencyCard = _safe<EmergencyCard?>(
      ref.watch(emergencyCardProvider(childId).future), null);

  final hasMoodToday =
      (await moodEntries).any((e) => e.entryDate == todayKey);
  final unread = (await conversations)
      .fold<int>(0, (sum, c) => sum + c.unreadCount);

  // Geçmiş etkinlikler plana girmez; en yakın gelecek etkinlik alınır.
  CalendarEvent? nextEvent;
  for (final event in await events) {
    if (event.isCancelled || event.startTime.isBefore(now)) continue;
    nextEvent = event;
    break;
  }

  return DailyPlanInput(
    now: now,
    hasChild: true,
    childName: childName,
    hasMoodToday: hasMoodToday,
    pendingMedicationSlots: pendingMedicationSlots(await medications),
    unreadMessages: unread,
    connectionRequests: (await requests).length,
    nextEventTitle: nextEvent?.title,
    nextEventStart: nextEvent?.startTime,
    recentNotes: (await notes).length,
    visitedCommunity: visitedCommunity,
    hasEmergencyCard: (await emergencyCard) != null,
  );
});
