import '../../../core/util/date_key.dart';
import '../../appointments/domain/appointment.dart';
import '../../behavior/domain/abc_entry.dart';
import '../../children/domain/milestone.dart';
import '../../children/domain/screening_result.dart';
import '../../mood/domain/mood_entry.dart';
import '../../notes/domain/development_note.dart';
import '../../sleep/domain/sleep_entry.dart';

/// Gün aralığı seçenekleri — web `RANGE_OPTIONS` birebir.
const List<int> kAnalyticsRanges = [7, 14, 30, 90];

/// Günlük seri noktası (tarih + değer).
class DailyPoint {
  const DailyPoint({required this.date, required this.value});

  /// `yyyy-MM-dd`.
  final String date;
  final double value;
}

/// Kategori kırılımı: ad + adet (+ varsa ortalama şiddet).
class CategoryCount {
  const CategoryCount({
    required this.name,
    required this.count,
    this.averageIntensity,
  });

  final String name;
  final int count;
  final double? averageIntensity;
}

/// Kural tabanlı öngörü türleri (metin i18n'de).
enum InsightKind {
  moodHigh,
  moodLow,
  sleepShort,
  sleepGood,
  topMilestoneCategory,
  appointments,
}

class AnalyticsInsight {
  const AnalyticsInsight({
    required this.kind,
    this.rangeDays = 0,
    this.value = '',
    this.count = 0,
    this.secondCount = 0,
  });

  final InsightKind kind;
  final int rangeDays;

  /// Ortalama ruh hali / uyku süresi gibi biçimlenmiş değer ya da kategori adı.
  final String value;
  final int count;
  final int secondCount;
}

/// Eksik veri için önerilen adımlar (web `actionItems`).
enum AnalyticsAction { addMood, addSleep, addNote, addMilestone }

/// Takip skoru seviyesi (web `scoreMeta`).
enum WellbeingLevel { strong, growing, waiting }

class AnalyticsSummary {
  const AnalyticsSummary({
    required this.rangeDays,
    required this.moodPoints,
    required this.sleepHourPoints,
    required this.sleepQualityPoints,
    required this.behaviorCategories,
    required this.milestoneCategories,
    required this.notesByMonth,
    required this.averageMood,
    required this.averageSleepMinutes,
    required this.completedAppointments,
    required this.pendingAppointments,
    required this.wellbeingScore,
    required this.dataCoverage,
    required this.insights,
    required this.actions,
  });

  final int rangeDays;
  final List<DailyPoint> moodPoints;

  /// Uyku süresi (saat, tek ondalık) ve kalite (1-5) serileri.
  final List<DailyPoint> sleepHourPoints;
  final List<DailyPoint> sleepQualityPoints;
  final List<CategoryCount> behaviorCategories;
  final List<CategoryCount> milestoneCategories;

  /// Ay (`yyyy-MM`) → not sayısı, son 6 ay.
  final List<CategoryCount> notesByMonth;
  final double? averageMood;
  final int? averageSleepMinutes;
  final int completedAppointments;
  final int pendingAppointments;

  /// 0-100 birleşik takip skoru.
  final int wellbeingScore;

  /// Kaç veri türünde kayıt var (0-6).
  final int dataCoverage;
  final List<AnalyticsInsight> insights;
  final List<AnalyticsAction> actions;

  bool get isEmpty =>
      moodPoints.isEmpty &&
      sleepHourPoints.isEmpty &&
      behaviorCategories.isEmpty &&
      milestoneCategories.isEmpty &&
      notesByMonth.isEmpty;

  WellbeingLevel get level => wellbeingScore >= 75
      ? WellbeingLevel.strong
      : wellbeingScore >= 45
          ? WellbeingLevel.growing
          : WellbeingLevel.waiting;
}

bool _inRange(DateTime? date, DateTime from) =>
    date != null && !date.isBefore(from);

DateTime? _parseDay(String value) {
  final parsed = DateTime.tryParse(value);
  return parsed == null
      ? null
      : DateTime(parsed.year, parsed.month, parsed.day);
}

/// Web AnalyticsPage'deki türetilmiş veriyi (seriler, kırılımlar, skor,
/// öngörüler) tek yerde hesaplar. Metin üretmez: arayüz i18n'den yazar.
AnalyticsSummary buildAnalyticsSummary({
  required int rangeDays,
  required DateTime now,
  List<MoodEntry> moods = const [],
  List<SleepEntry> sleeps = const [],
  List<DevelopmentNote> notes = const [],
  List<Milestone> milestones = const [],
  List<AbcEntry> behaviors = const [],
  List<Appointment> appointments = const [],
  List<ScreeningResult> screenings = const [],
}) {
  final today = DateTime(now.year, now.month, now.day);
  final from = today.subtract(Duration(days: rangeDays - 1));

  int compareByDate(DailyPoint a, DailyPoint b) => a.date.compareTo(b.date);

  final moodPoints = <DailyPoint>[
    for (final entry in moods)
      if (_inRange(_parseDay(entry.entryDate), from))
        DailyPoint(date: entry.entryDate, value: entry.moodLevel.toDouble()),
  ]..sort(compareByDate);

  final rangeSleeps = [
    for (final entry in sleeps)
      if (_inRange(_parseDay(entry.sleepDate), from)) entry,
  ];
  final sleepHourPoints = <DailyPoint>[
    for (final entry in rangeSleeps)
      DailyPoint(
        date: entry.sleepDate,
        // Web: dakikayı saate çevirip tek ondalığa yuvarlar.
        value: ((entry.durationMinutes ?? 0) / 60 * 10).round() / 10,
      ),
  ]..sort(compareByDate);
  final sleepQualityPoints = <DailyPoint>[
    for (final entry in rangeSleeps)
      DailyPoint(date: entry.sleepDate, value: (entry.quality ?? 0).toDouble()),
  ]..sort(compareByDate);

  final rangeNotes = [
    for (final note in notes)
      if (_inRange(note.noteDate ?? note.createdAt, from)) note,
  ];
  final rangeMilestones = [
    for (final milestone in milestones)
      if (_inRange(milestone.achievedDate ?? milestone.createdAt, from))
        milestone,
  ];
  final rangeBehaviors = [
    for (final entry in behaviors)
      if (_inRange(_parseDay(entry.entryDate), from)) entry,
  ];

  // Davranış kategorileri: adet + ortalama şiddet.
  final behaviorCounts = <String, int>{};
  final behaviorIntensity = <String, int>{};
  for (final entry in rangeBehaviors) {
    final key = (entry.category?.trim().isNotEmpty ?? false)
        ? entry.category!.trim()
        : kAnalyticsOtherCategory;
    behaviorCounts[key] = (behaviorCounts[key] ?? 0) + 1;
    behaviorIntensity[key] = (behaviorIntensity[key] ?? 0) + entry.intensity;
  }
  final behaviorCategories = [
    for (final entry in behaviorCounts.entries)
      CategoryCount(
        name: entry.key,
        count: entry.value,
        averageIntensity: entry.value == 0
            ? null
            : (behaviorIntensity[entry.key]! / entry.value),
      ),
  ]..sort((a, b) => b.count.compareTo(a.count));

  final milestoneCounts = <String, int>{};
  for (final milestone in rangeMilestones) {
    final key = (milestone.category?.trim().isNotEmpty ?? false)
        ? milestone.category!.trim()
        : kAnalyticsOtherCategory;
    milestoneCounts[key] = (milestoneCounts[key] ?? 0) + 1;
  }
  final milestoneCategories = [
    for (final entry in milestoneCounts.entries)
      CategoryCount(name: entry.key, count: entry.value),
  ]..sort((a, b) => b.count.compareTo(a.count));

  // Not aktivitesi: son 6 ay (aralıktan bağımsız — web de aylık bakıyor).
  final notesByMonthMap = <String, int>{};
  for (final note in notes) {
    final date = note.noteDate ?? note.createdAt;
    if (date == null) continue;
    final key = localDateKey(date).substring(0, 7);
    notesByMonthMap[key] = (notesByMonthMap[key] ?? 0) + 1;
  }
  final months = notesByMonthMap.keys.toList()..sort();
  final notesByMonth = [
    for (final month in months.length > 6 ? months.sublist(months.length - 6) : months)
      CategoryCount(name: month, count: notesByMonthMap[month]!),
  ];

  final averageMood = moodPoints.isEmpty
      ? null
      : moodPoints.fold<double>(0, (sum, p) => sum + p.value) /
          moodPoints.length;
  final durations = [
    for (final entry in rangeSleeps)
      if ((entry.durationMinutes ?? 0) > 0) entry.durationMinutes!,
  ];
  final averageSleepMinutes = durations.isEmpty
      ? null
      : (durations.reduce((a, b) => a + b) / durations.length).round();

  final completed = appointments
      .where((a) => a.statusKind == AppointmentStatusKind.completed)
      .length;
  final pending = appointments
      .where((a) =>
          a.statusKind == AppointmentStatusKind.pending ||
          a.statusKind == AppointmentStatusKind.confirmed)
      .length;

  // Skor: web birebir (ruh hali %30, uyku %30, aktivite %20, kapsam %20).
  final moodScore = (averageMood ?? 0) / 5 * 100;
  final sleepScore = averageSleepMinutes == null
      ? 0.0
      : (averageSleepMinutes / 600).clamp(0, 1) * 100;
  final activityScore = ((rangeNotes.length +
                  rangeMilestones.length +
                  completed +
                  screenings.length) /
              8)
          .clamp(0, 1) *
      100;
  final coverage = [
    moodPoints.isNotEmpty,
    rangeSleeps.isNotEmpty,
    rangeNotes.isNotEmpty,
    rangeMilestones.isNotEmpty,
    appointments.isNotEmpty,
    screenings.isNotEmpty,
  ].where((has) => has).length;
  final coverageScore = (coverage / 6 * 100).round();
  final wellbeingScore = (moodScore * 0.3 +
          sleepScore * 0.3 +
          activityScore * 0.2 +
          coverageScore * 0.2)
      .round();

  // Öngörüler — web'deki sıra ve eşikler.
  final insights = <AnalyticsInsight>[];
  if (moodPoints.length >= 3 && averageMood != null) {
    final value = averageMood.toStringAsFixed(1);
    if (averageMood >= 4) {
      insights.add(AnalyticsInsight(
        kind: InsightKind.moodHigh,
        rangeDays: rangeDays,
        value: value,
      ));
    } else if (averageMood < 3) {
      insights.add(AnalyticsInsight(
        kind: InsightKind.moodLow,
        rangeDays: rangeDays,
        value: value,
      ));
    }
  }
  if (averageSleepMinutes != null && averageSleepMinutes > 0) {
    final hours = averageSleepMinutes ~/ 60;
    insights.add(AnalyticsInsight(
      kind: hours < 8 ? InsightKind.sleepShort : InsightKind.sleepGood,
      value: formatSleepDuration(averageSleepMinutes),
    ));
  }
  if (milestoneCategories.isNotEmpty) {
    insights.add(AnalyticsInsight(
      kind: InsightKind.topMilestoneCategory,
      value: milestoneCategories.first.name,
      count: milestoneCategories.first.count,
    ));
  }
  if (completed > 0) {
    insights.add(AnalyticsInsight(
      kind: InsightKind.appointments,
      count: completed,
      secondCount: pending,
    ));
  }

  // Eksik veri önerileri — en fazla üç tanesi (web birebir; tarama adımı
  // mobilde yok, tarama anketi web'de de bulunmuyor).
  final actions = <AnalyticsAction>[
    if (moodPoints.isEmpty) AnalyticsAction.addMood,
    if (rangeSleeps.isEmpty) AnalyticsAction.addSleep,
    if (rangeNotes.isEmpty) AnalyticsAction.addNote,
    if (rangeMilestones.isEmpty) AnalyticsAction.addMilestone,
  ].take(3).toList();

  return AnalyticsSummary(
    rangeDays: rangeDays,
    moodPoints: moodPoints,
    sleepHourPoints: sleepHourPoints,
    sleepQualityPoints: sleepQualityPoints,
    behaviorCategories: behaviorCategories,
    milestoneCategories: milestoneCategories,
    notesByMonth: notesByMonth,
    averageMood: averageMood,
    averageSleepMinutes: averageSleepMinutes,
    completedAppointments: completed,
    pendingAppointments: pending,
    wellbeingScore: wellbeingScore,
    dataCoverage: coverage,
    insights: insights,
    actions: actions,
  );
}

/// Kategorisi olmayan kayıtların toplandığı ad (web `'Diğer'`).
const String kAnalyticsOtherCategory = 'Diğer';

/// Dakikayı "7s 45dk" biçimine çevirir (web `avgSleepHours`).
String formatSleepDuration(int minutes) {
  final hours = minutes ~/ 60;
  final rest = minutes % 60;
  return rest == 0 ? '${hours}s' : '${hours}s ${rest}dk';
}

/// Paylaşılabilir CSV — web `exportCsv` ile aynı sütunlar (tür/tarih/değer/not).
String analyticsCsv({
  required List<MoodEntry> moods,
  required List<SleepEntry> sleeps,
  required List<Milestone> milestones,
}) {
  String escape(String value) => '"${value.replaceAll('"', '""')}"';
  final rows = <List<String>>[
    ['tür', 'tarih', 'değer', 'not'],
    for (final entry in moods)
      [
        'Ruh Hali',
        entry.entryDate,
        entry.moodLevel.toString(),
        entry.notes ?? '',
      ],
    for (final entry in sleeps)
      [
        'Uyku',
        entry.sleepDate,
        entry.durationMinutes == null
            ? ''
            : formatSleepDuration(entry.durationMinutes!),
        entry.notes ?? '',
      ],
    for (final milestone in milestones)
      [
        'Kilometre Taşı',
        milestone.achievedDate == null
            ? ''
            : localDateKey(milestone.achievedDate!),
        milestone.title,
        milestone.category ?? '',
      ],
  ];
  return rows.map((row) => row.map(escape).join(',')).join('\n');
}
