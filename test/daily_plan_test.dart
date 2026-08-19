import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/features/home/data/daily_plan_provider.dart';
import 'package:otizm_destek_app/features/home/domain/daily_plan.dart';
import 'package:otizm_destek_app/features/medications/domain/medication.dart';

void main() {
  final now = DateTime(2026, 8, 19, 9); // sabah

  DailyPlanInput input({
    bool hasChild = true,
    bool hasMoodToday = false,
    int meds = 0,
    int unread = 0,
    int requests = 0,
    DateTime? eventStart,
    int notes = 0,
    bool community = false,
    bool emergencyCard = false,
  }) {
    return DailyPlanInput(
      now: now,
      hasChild: hasChild,
      childName: 'Ada',
      hasMoodToday: hasMoodToday,
      pendingMedicationSlots: meds,
      unreadMessages: unread,
      connectionRequests: requests,
      nextEventTitle: eventStart == null ? null : 'Terapi',
      nextEventStart: eventStart,
      recentNotes: notes,
      visitedCommunity: community,
      hasEmergencyCard: emergencyCard,
    );
  }

  group('plan sıralaması', () {
    test('çocuk yoksa yalnızca başlangıç adımları listelenir', () {
      final tasks = buildDailyPlan(input(hasChild: false));
      expect(tasks.map((t) => t.kind), [
        DailyTaskKind.firstChild,
        DailyTaskKind.guide,
        DailyTaskKind.experts,
      ]);
    });

    test('bekleyen doz her şeyin önüne geçer', () {
      final tasks = buildDailyPlan(input(meds: 2, unread: 3));
      expect(tasks.first.kind, DailyTaskKind.medication);
      expect(tasks.first.count, 2);
    });

    test('tamamlanan işler listenin sonuna taşınır', () {
      final tasks = buildDailyPlan(
        input(hasMoodToday: true, notes: 4, community: true),
      );
      final firstDone = tasks.indexWhere((t) => t.done);
      expect(firstDone, greaterThan(0));
      expect(tasks.skip(firstDone).every((t) => t.done), isTrue);
    });

    test('acil etkinlik ayrı satır olur, takvim satırı düşer', () {
      final tasks = buildDailyPlan(
        input(eventStart: DateTime(2026, 8, 19, 15)),
      );
      expect(tasks.any((t) => t.kind == DailyTaskKind.urgentEvent), isTrue);
      expect(tasks.any((t) => t.kind == DailyTaskKind.calendar), isFalse);
      expect(tasks.first.kind, DailyTaskKind.urgentEvent);
    });

    test('uzak etkinlik takvim satırını tamamlanmış yapar', () {
      final tasks = buildDailyPlan(
        input(eventStart: DateTime(2026, 9, 2, 15)),
      );
      final calendar =
          tasks.firstWhere((t) => t.kind == DailyTaskKind.calendar);
      expect(calendar.done, isTrue);
      expect(tasks.any((t) => t.kind == DailyTaskKind.urgentEvent), isFalse);
    });

    test('acil durum kartı varsa güvenlik satırı gösterilmez', () {
      final tasks = buildDailyPlan(input(emergencyCard: true));
      expect(tasks.any((t) => t.kind == DailyTaskKind.emergency), isFalse);
    });
  });

  group('ilerleme', () {
    test('yüzde tamamlanan iş oranıdır', () {
      final tasks = buildDailyPlan(
        input(hasMoodToday: true, notes: 2, community: true),
      );
      final progress = planProgress(tasks);
      expect(progress.total, tasks.length);
      expect(progress.completed, 3);
      expect(
        progress.percent,
        ((3 / tasks.length) * 100).round(),
      );
    });

    test('kalan süre yalnızca bekleyen işleri toplar', () {
      final tasks = buildDailyPlan(input(hasMoodToday: true));
      final pendingMinutes = tasks
          .where((t) => !t.done)
          .fold<int>(0, (sum, t) => sum + t.minutes);
      expect(planProgress(tasks).pendingMinutes, pendingMinutes);
    });
  });

  group('koç notu', () {
    CoachNote noteFor(DailyPlanInput i) => coachNoteFor(i, buildDailyPlan(i));

    test('çocuk yoksa profil önerisi', () {
      expect(noteFor(input(hasChild: false)).kind, CoachNoteKind.noChild);
    });

    test('bekleyen doz ilaç notunu seçer ve kalanı sayar', () {
      final tasks = buildDailyPlan(input(meds: 1));
      final note = coachNoteFor(input(meds: 1), tasks);
      expect(note.kind, CoachNoteKind.medication);
      expect(note.pending, planProgress(tasks).pending - 1);
    });

    test('kayıt yoksa günlük kayıt notu', () {
      expect(noteFor(input()).kind, CoachNoteKind.noMood);
    });

    test('kayıt varsa ve etkinlik varsa etkinlik notu', () {
      final i = input(hasMoodToday: true, eventStart: DateTime(2026, 8, 25));
      expect(noteFor(i).kind, CoachNoteKind.event);
    });

    test('kayıt varsa ve etkinlik yoksa ilerleme notu', () {
      expect(noteFor(input(hasMoodToday: true)).kind, CoachNoteKind.progress);
    });

    test('her iş bittiyse kutlama notu', () {
      final i = input(
        hasMoodToday: true,
        notes: 1,
        community: true,
        emergencyCard: true,
        eventStart: DateTime(2026, 9, 10),
      );
      expect(noteFor(i).kind, CoachNoteKind.allDone);
    });

    test('günün bölümü saate göre seçilir', () {
      expect(dayPartOf(DateTime(2026, 8, 19, 8)), DayPart.morning);
      expect(dayPartOf(DateTime(2026, 8, 19, 13)), DayPart.afternoon);
      expect(dayPartOf(DateTime(2026, 8, 19, 21)), DayPart.evening);
    });
  });

  group('başlangıç listesi', () {
    test('ziyaret ya da kayıt adımı tamamlar', () {
      final items = startChecklist(
        hasChild: true,
        hasMoodToday: false,
        visitedTracker: true,
        visitedCrisis: false,
      );
      expect(items[0].done, isTrue);
      expect(items[1].done, isTrue); // ziyaret yeterli
      expect(items[2].done, isFalse);
      expect(startChecklistPercent(items), 67);
    });

    test('kayıt girildiyse ziyaret gerekmez', () {
      final items = startChecklist(
        hasChild: true,
        hasMoodToday: true,
        visitedTracker: false,
        visitedCrisis: true,
      );
      expect(items.every((i) => i.done), isTrue);
      expect(startChecklistPercent(items), 100);
    });
  });

  group('ilaç dozu sayımı', () {
    Medication med({
      required List<String> times,
      List<MedicationLog> logs = const [],
      bool active = true,
    }) {
      return Medication(
        id: 'm1',
        childId: 'c1',
        name: 'D vitamini',
        dosage: '1 damla',
        scheduledTimes: times,
        todayLogs: logs,
        isActive: active,
      );
    }

    MedicationLog log(String time, bool taken) => MedicationLog(
          id: 'l',
          medicationId: 'm1',
          logDate: '2026-08-19',
          scheduledTime: time,
          taken: taken,
        );

    test('işaretlenmemiş dozlar sayılır', () {
      final list = [
        med(times: ['08:00', '20:00'], logs: [log('08:00', true)]),
      ];
      expect(pendingMedicationSlots(list), 1);
    });

    test('alınmadı işaretli doz da bekleyen sayılır', () {
      final list = [
        med(times: ['08:00'], logs: [log('08:00', false)]),
      ];
      expect(pendingMedicationSlots(list), 1);
    });

    test('pasif ilaçlar sayılmaz', () {
      final list = [
        med(times: ['08:00'], active: false),
      ];
      expect(pendingMedicationSlots(list), 0);
    });
  });
}
