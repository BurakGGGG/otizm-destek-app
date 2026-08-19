import '../../../core/util/date_key.dart';

/// Ana sayfadaki "bugün ne yapmalı" planı ve günlük koç notu — web gösterge
/// panelindeki `todayTasks` + `dailyCoachNote` kural setinin saf karşılığı.
///
/// Burada yalnızca kurallar vardır: metinler i18n'de, veri toplama ise
/// `data/daily_plan_provider.dart` içindedir. Böylece sıralama/koç notu
/// mantığı arayüzsüz test edilebilir.

/// Günün bölümü (koç notundaki "sabah/öğleden sonra/akşam").
enum DayPart { morning, afternoon, evening }

DayPart dayPartOf(DateTime now) => now.hour < 12
    ? DayPart.morning
    : now.hour < 17
        ? DayPart.afternoon
        : DayPart.evening;

/// Plan satırının türü. Başlık/açıklama metni arayüzde bu türe göre seçilir.
enum DailyTaskKind {
  /// Bugünün kısa kaydı (duygu/uyku/ilaç).
  dailyLog,

  /// İşaretlenmemiş ilaç dozu.
  medication,

  /// Okunmamış mesaj.
  messages,

  /// Bekleyen uzman erişim isteği.
  expertRequest,

  /// Bugün/yarın olan takvim etkinliği.
  urgentEvent,

  /// Gözlem notu.
  notes,

  /// Topluluk alanları.
  community,

  /// Takvim (acil etkinlik yokken genel kontrol).
  calendar,

  /// Acil durum kartı (güvenlik önerisi).
  emergency,

  /// Çocuk profili yokken: ilk profil.
  firstChild,

  /// Çocuk profili yokken: kullanıcı rehberi.
  guide,

  /// Çocuk profili yokken: uzmanları keşfet.
  experts,
}

class DailyTask {
  const DailyTask({
    required this.kind,
    required this.route,
    required this.done,
    required this.urgency,
    required this.minutes,
    this.count = 0,
    this.label,
    this.eventStart,
    this.safety = false,
  });

  final DailyTaskKind kind;
  final String route;
  final bool done;

  /// Küçük değer = daha acil (web `urgency` alanıyla aynı ölçek).
  final int urgency;

  /// Tahmini süre (dakika) — bekleyen işlerin toplamı koç notunda kullanılır.
  final int minutes;

  /// Doz / mesaj / istek / not sayısı (metinde gösterilir).
  final int count;

  /// Etkinlik başlığı gibi kullanıcı verisi (çevrilmez).
  final String? label;

  /// Etkinlik satırlarında başlangıç zamanı (saat rozetinde gösterilir).
  final DateTime? eventStart;

  /// Güvenlik önerisi (acil durum kartı) — sıralamada değil, etikette etkili.
  final bool safety;
}

/// Plan kurallarının girdisi. Alanların hepsi ucuz sayılabilir değerlerdir;
/// ağ çağrıları sağlayıcıda yapılır.
class DailyPlanInput {
  const DailyPlanInput({
    required this.now,
    this.hasChild = false,
    this.childName = '',
    this.hasMoodToday = false,
    this.pendingMedicationSlots = 0,
    this.unreadMessages = 0,
    this.connectionRequests = 0,
    this.nextEventTitle,
    this.nextEventStart,
    this.recentNotes = 0,
    this.visitedCommunity = false,
    this.hasEmergencyCard = false,
  });

  final DateTime now;
  final bool hasChild;

  /// Aktif çocuğun ilk adı — koç notunda geçer (kullanıcı verisi).
  final String childName;
  final bool hasMoodToday;
  final int pendingMedicationSlots;
  final int unreadMessages;
  final int connectionRequests;
  final String? nextEventTitle;
  final DateTime? nextEventStart;
  final int recentNotes;
  final bool visitedCommunity;
  final bool hasEmergencyCard;

  /// Etkinlik bugün ya da yarınsa "acil" sayılır (web `getEventCountdown`).
  bool get hasUrgentEvent =>
      nextEventStart != null && isUrgentEvent(nextEventStart!, now);
}

bool isUrgentEvent(DateTime start, DateTime now) {
  final key = localDateKey(start);
  return key == localDateKey(now) ||
      key == localDateKey(now.add(const Duration(days: 1)));
}

/// Günün planı — bekleyenler aciliyete göre, tamamlananlar sona.
List<DailyTask> buildDailyPlan(DailyPlanInput input) {
  final tasks = <DailyTask>[];

  if (!input.hasChild) {
    tasks.add(const DailyTask(
      kind: DailyTaskKind.firstChild,
      route: '/children',
      done: false,
      urgency: 1,
      minutes: 3,
    ));
    tasks.add(const DailyTask(
      kind: DailyTaskKind.guide,
      route: '/guide',
      done: false,
      urgency: 2,
      minutes: 1,
    ));
    tasks.add(const DailyTask(
      kind: DailyTaskKind.experts,
      route: '/home?tab=1',
      done: false,
      urgency: 3,
      minutes: 2,
    ));
    return sortDailyPlan(tasks);
  }

  // Günlük kayıt — her zaman listede.
  tasks.add(DailyTask(
    kind: DailyTaskKind.dailyLog,
    route: '/daily-tracker',
    done: input.hasMoodToday,
    urgency: 1,
    minutes: 1,
  ));

  // Gecikmiş doz her zaman en acil iştir.
  if (input.pendingMedicationSlots > 0) {
    tasks.add(DailyTask(
      kind: DailyTaskKind.medication,
      route: '/daily-tracker',
      done: false,
      urgency: 0,
      minutes: 2,
      count: input.pendingMedicationSlots,
    ));
  }

  if (input.unreadMessages > 0) {
    tasks.add(DailyTask(
      kind: DailyTaskKind.messages,
      route: '/messages',
      done: false,
      urgency: 2,
      minutes: 2,
      count: input.unreadMessages,
    ));
  }

  if (input.connectionRequests > 0) {
    tasks.add(DailyTask(
      kind: DailyTaskKind.expertRequest,
      route: '/expert-access',
      done: false,
      urgency: 2,
      minutes: 1,
      count: input.connectionRequests,
    ));
  }

  // Bugün/yarın etkinlik varsa kendi kartı; yoksa genel takvim kontrolü.
  if (input.hasUrgentEvent) {
    tasks.add(DailyTask(
      kind: DailyTaskKind.urgentEvent,
      route: '/calendar',
      done: false,
      urgency: 0,
      minutes: 1,
      label: input.nextEventTitle,
      eventStart: input.nextEventStart,
    ));
  } else {
    tasks.add(DailyTask(
      kind: DailyTaskKind.calendar,
      route: '/calendar',
      done: input.nextEventStart != null,
      urgency: 4,
      minutes: 1,
      label: input.nextEventTitle,
      eventStart: input.nextEventStart,
    ));
  }

  tasks.add(DailyTask(
    kind: DailyTaskKind.notes,
    route: '/notes',
    done: input.recentNotes > 0,
    urgency: 3,
    minutes: 2,
    count: input.recentNotes,
  ));

  // Topluluk — haber verir ama günlük akışı bölmeyecek kadar düşük öncelikli.
  tasks.add(DailyTask(
    kind: DailyTaskKind.community,
    route: '/community',
    done: input.visitedCommunity,
    urgency: 6,
    minutes: 1,
  ));

  if (!input.hasEmergencyCard) {
    tasks.add(const DailyTask(
      kind: DailyTaskKind.emergency,
      route: '/emergency',
      done: false,
      urgency: 5,
      minutes: 2,
      safety: true,
    ));
  }

  return sortDailyPlan(tasks);
}

/// Bekleyenler gerçek aciliyete göre öne alınır (ekleme sırasına değil);
/// tamamlananlar akışı bölmemesi için sona taşınır.
List<DailyTask> sortDailyPlan(List<DailyTask> tasks) {
  final sorted = [...tasks];
  sorted.sort((a, b) {
    if (a.done != b.done) return a.done ? 1 : -1;
    return a.urgency.compareTo(b.urgency);
  });
  return sorted;
}

class DailyPlanProgress {
  const DailyPlanProgress({
    required this.completed,
    required this.total,
    required this.pendingMinutes,
  });

  final int completed;
  final int total;
  final int pendingMinutes;

  int get pending => total - completed;
  bool get allDone => total > 0 && completed == total;
  int get percent => total == 0 ? 0 : ((completed / total) * 100).round();
}

DailyPlanProgress planProgress(List<DailyTask> tasks) {
  final completed = tasks.where((t) => t.done).length;
  final minutes = tasks
      .where((t) => !t.done)
      .fold<int>(0, (sum, t) => sum + t.minutes);
  return DailyPlanProgress(
    completed: completed,
    total: tasks.length,
    pendingMinutes: minutes,
  );
}

/// Koç notunun hangi varyantının gösterileceği (metin i18n'de).
enum CoachNoteKind { noChild, allDone, medication, noMood, event, progress, plan }

class CoachNote {
  const CoachNote({
    required this.kind,
    required this.dayPart,
    this.pending = 0,
    this.completed = 0,
    this.minutes = 0,
  });

  final CoachNoteKind kind;
  final DayPart dayPart;

  /// `medication` varyantında ilaç dışında kalan iş sayısı.
  final int pending;
  final int completed;
  final int minutes;
}

/// Web `dailyCoachNote` kaskadı: profil → hepsi tamam → ilaç → kayıt →
/// etkinlik → ilerleme → genel plan.
CoachNote coachNoteFor(DailyPlanInput input, List<DailyTask> tasks) {
  final dayPart = dayPartOf(input.now);
  if (!input.hasChild) {
    return CoachNote(kind: CoachNoteKind.noChild, dayPart: dayPart);
  }
  final progress = planProgress(tasks);
  if (progress.allDone) {
    return CoachNote(kind: CoachNoteKind.allDone, dayPart: dayPart);
  }
  if (input.pendingMedicationSlots > 0) {
    return CoachNote(
      kind: CoachNoteKind.medication,
      dayPart: dayPart,
      // İlaç işinin kendisi hariç kalanlar.
      pending: progress.pending - 1,
    );
  }
  if (!input.hasMoodToday) {
    return CoachNote(kind: CoachNoteKind.noMood, dayPart: dayPart);
  }
  if (input.nextEventStart != null) {
    return CoachNote(
      kind: CoachNoteKind.event,
      dayPart: dayPart,
      pending: progress.pending,
    );
  }
  if (progress.completed > 0) {
    return CoachNote(
      kind: CoachNoteKind.progress,
      dayPart: dayPart,
      pending: progress.pending,
      completed: progress.completed,
    );
  }
  return CoachNote(
    kind: CoachNoteKind.plan,
    dayPart: dayPart,
    pending: progress.pending,
    minutes: progress.pendingMinutes,
  );
}

// ---------------------------------------------------------------------------
// Yeni kullanıcı başlangıç kontrol listesi (web "Hızlı Başlangıç Rehberi")
// ---------------------------------------------------------------------------

enum StartStep { childProfile, dailyLog, crisisGuide }

class StartChecklistItem {
  const StartChecklistItem({
    required this.step,
    required this.done,
    required this.route,
  });

  final StartStep step;
  final bool done;
  final String route;
}

/// Üç adımlı ilk gün listesi. "Görüldü" bilgisi cihazda tutulan ziyaret
/// kaydından gelir (web'de de sunucuya yazılmaz).
List<StartChecklistItem> startChecklist({
  required bool hasChild,
  required bool hasMoodToday,
  required bool visitedTracker,
  required bool visitedCrisis,
}) {
  return [
    StartChecklistItem(
      step: StartStep.childProfile,
      done: hasChild,
      route: '/children',
    ),
    StartChecklistItem(
      step: StartStep.dailyLog,
      done: visitedTracker || hasMoodToday,
      route: '/daily-tracker',
    ),
    StartChecklistItem(
      step: StartStep.crisisGuide,
      done: visitedCrisis,
      route: '/crisis',
    ),
  ];
}

int startChecklistPercent(List<StartChecklistItem> items) {
  if (items.isEmpty) return 0;
  final done = items.where((i) => i.done).length;
  return ((done / items.length) * 100).round();
}
