/// Tedavi sayfası durumu — web `TreatmentPageState` ile **birebir aynı** JSON
/// anahtarları. Blob paylaşılan DB'de `treatment_states` tablosunda (jsonb)
/// saklanır; alan adları/format ASLA değiştirilmez.
///
/// Not: Deploy'daki backend yalnızca 5 alanı kalıcılaştırır (gameFeedback,
/// customGoals, sensoryProfile, gameSessions, goalProgressHistory).
/// templateGoalToggles / completedPlanSteps / customStories web gibi gönderilir
/// ve varsa okunur; backend güncellenene dek oturum içi yaşar (web ile aynı).
library;

import 'dart:math';

import 'treatment_plan.dart';

/// Oyun geri bildirimi kodları (web `GameReflection` — veri, çevrilmez).
const kGameReflections = ['easy', 'assisted', 'independent', 'challenging'];

/// Yerel gün anahtarı — web `getDateKey` birebir (`yyyy-MM-dd`, yerel saat).
String treatmentDateKey(DateTime date) {
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '${date.year}-$m-$d';
}

String treatmentDateKeyOf(String isoString) =>
    treatmentDateKey(DateTime.tryParse(isoString)?.toLocal() ?? DateTime.now());

/// Web `crypto.randomUUID()` karşılığı — v4 UUID.
String randomUuidV4() {
  final rng = Random.secure();
  final bytes = List<int>.generate(16, (_) => rng.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;
  final hex =
      bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
      '${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
}

/// Web `EditableGoal` — velinin eklediği özel hedef.
class EditableGoal {
  const EditableGoal({
    required this.id,
    required this.title,
    required this.focusKey,
    required this.done,
    this.dueDate,
  });

  final String id;
  final String title;
  final String focusKey;
  final bool done;
  final String? dueDate; // yyyy-MM-dd

  EditableGoal copyWith({
    String? title,
    String? focusKey,
    bool? done,
    String? Function()? dueDate,
  }) {
    return EditableGoal(
      id: id,
      title: title ?? this.title,
      focusKey: focusKey ?? this.focusKey,
      done: done ?? this.done,
      dueDate: dueDate != null ? dueDate() : this.dueDate,
    );
  }

  factory EditableGoal.fromJson(Map<String, dynamic> json) {
    return EditableGoal(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      focusKey: json['focusKey'] as String? ?? 'communication',
      done: json['done'] as bool? ?? false,
      dueDate: json['dueDate'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'focusKey': focusKey,
        'done': done,
        if (dueDate != null) 'dueDate': dueDate,
      };
}

/// Web `SensoryProfileState` — duyusal profil (10–100).
class SensoryProfile {
  const SensoryProfile({
    required this.sound,
    required this.touch,
    required this.visual,
  });

  final int sound;
  final int touch;
  final int visual;

  static const SensoryProfile defaults =
      SensoryProfile(sound: 76, touch: 54, visual: 68);

  SensoryProfile copyWith({int? sound, int? touch, int? visual}) {
    return SensoryProfile(
      sound: sound ?? this.sound,
      touch: touch ?? this.touch,
      visual: visual ?? this.visual,
    );
  }

  factory SensoryProfile.fromJson(Map<String, dynamic>? json) {
    if (json == null) return defaults;
    return SensoryProfile(
      sound: (json['sound'] as num?)?.round() ?? defaults.sound,
      touch: (json['touch'] as num?)?.round() ?? defaults.touch,
      visual: (json['visual'] as num?)?.round() ?? defaults.visual,
    );
  }

  Map<String, dynamic> toJson() =>
      {'sound': sound, 'touch': touch, 'visual': visual};
}

/// Web `GameSession` — oynanan bir oyunun kaydı.
class GameSession {
  const GameSession({
    required this.gameId,
    required this.status,
    required this.focusKey,
    required this.linkedGoal,
    required this.completedAt,
  });

  final String gameId;
  final String status; // GameReflection kodu
  final String focusKey;
  final String linkedGoal; // Türkçe hedef etiketi — veri, çevrilmez
  final String completedAt; // ISO-8601

  String get dayKey => treatmentDateKeyOf(completedAt);

  factory GameSession.fromJson(Map<String, dynamic> json) {
    return GameSession(
      gameId: json['gameId']?.toString() ?? '',
      status: json['status'] as String? ?? 'assisted',
      focusKey: json['focusKey'] as String? ?? 'communication',
      linkedGoal: json['linkedGoal'] as String? ?? 'Genel hedef',
      completedAt: json['completedAt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'gameId': gameId,
        'status': status,
        'focusKey': focusKey,
        'linkedGoal': linkedGoal,
        'completedAt': completedAt,
      };
}

/// Web `GoalProgressSnapshot` — güne bir toplam hedef yüzdesi.
class GoalProgressSnapshot {
  const GoalProgressSnapshot({required this.recordedAt, required this.percent});

  final String recordedAt; // ISO-8601
  final int percent;

  String get dayKey => treatmentDateKeyOf(recordedAt);

  factory GoalProgressSnapshot.fromJson(Map<String, dynamic> json) {
    return GoalProgressSnapshot(
      recordedAt: json['recordedAt']?.toString() ?? '',
      percent: (json['percent'] as num?)?.round() ?? 0,
    );
  }

  Map<String, dynamic> toJson() =>
      {'recordedAt': recordedAt, 'percent': percent};
}

/// Web `CustomStoryData` — velinin eklediği sosyal hikâye kartı.
class CustomStory {
  const CustomStory({
    required this.id,
    required this.title,
    required this.icon,
    required this.linkedGoal,
  });

  final String id;
  final String title;
  final String icon; // emoji
  final String linkedGoal;

  factory CustomStory.fromJson(Map<String, dynamic> json) {
    return CustomStory(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      icon: json['icon'] as String? ?? '📖',
      linkedGoal: json['linkedGoal'] as String? ?? 'Genel hedef',
    );
  }

  Map<String, dynamic> toJson() =>
      {'id': id, 'title': title, 'icon': icon, 'linkedGoal': linkedGoal};
}

/// Web `TreatmentPageState` — sunucudaki blob'un tamamı.
class TreatmentPageState {
  const TreatmentPageState({
    this.customGoals = const [],
    this.sensoryProfile = SensoryProfile.defaults,
    this.gameFeedback = const {},
    this.gameSessions = const [],
    this.goalProgressHistory = const [],
    this.templateGoalToggles = const {},
    this.completedPlanSteps = const [],
    this.customStories = const [],
  });

  final List<EditableGoal> customGoals;
  final SensoryProfile sensoryProfile;

  /// Anahtar: `yyyy-MM-dd:gameId` (web `getGameFeedbackKey`).
  final Map<String, String> gameFeedback;
  final List<GameSession> gameSessions;
  final List<GoalProgressSnapshot> goalProgressHistory;

  /// Anahtar: şablon hedefin Türkçe etiketi — veri, çevrilmez.
  final Map<String, bool> templateGoalToggles;

  /// Öğeler: `yyyy-MM-dd:stepId`.
  final List<String> completedPlanSteps;
  final List<CustomStory> customStories;

  TreatmentPageState copyWith({
    List<EditableGoal>? customGoals,
    SensoryProfile? sensoryProfile,
    Map<String, String>? gameFeedback,
    List<GameSession>? gameSessions,
    List<GoalProgressSnapshot>? goalProgressHistory,
    Map<String, bool>? templateGoalToggles,
    List<String>? completedPlanSteps,
    List<CustomStory>? customStories,
  }) {
    return TreatmentPageState(
      customGoals: customGoals ?? this.customGoals,
      sensoryProfile: sensoryProfile ?? this.sensoryProfile,
      gameFeedback: gameFeedback ?? this.gameFeedback,
      gameSessions: gameSessions ?? this.gameSessions,
      goalProgressHistory: goalProgressHistory ?? this.goalProgressHistory,
      templateGoalToggles: templateGoalToggles ?? this.templateGoalToggles,
      completedPlanSteps: completedPlanSteps ?? this.completedPlanSteps,
      customStories: customStories ?? this.customStories,
    );
  }

  factory TreatmentPageState.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> maps(dynamic v) => (v is List)
        ? v.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList()
        : const [];
    return TreatmentPageState(
      customGoals: maps(json['customGoals']).map(EditableGoal.fromJson).toList(),
      sensoryProfile: SensoryProfile.fromJson(
        json['sensoryProfile'] is Map
            ? Map<String, dynamic>.from(json['sensoryProfile'] as Map)
            : null,
      ),
      gameFeedback: json['gameFeedback'] is Map
          ? (json['gameFeedback'] as Map)
              .map((k, v) => MapEntry(k.toString(), v.toString()))
          : const {},
      gameSessions: maps(json['gameSessions']).map(GameSession.fromJson).toList(),
      goalProgressHistory: maps(json['goalProgressHistory'])
          .map(GoalProgressSnapshot.fromJson)
          .toList(),
      templateGoalToggles: json['templateGoalToggles'] is Map
          ? (json['templateGoalToggles'] as Map)
              .map((k, v) => MapEntry(k.toString(), v == true))
          : const {},
      completedPlanSteps: json['completedPlanSteps'] is List
          ? (json['completedPlanSteps'] as List)
              .map((e) => e.toString())
              .toList()
          : const [],
      customStories:
          maps(json['customStories']).map(CustomStory.fromJson).toList(),
    );
  }

  /// PUT gövdesi — web `treatmentStateService.save` ile aynı alan seti.
  Map<String, dynamic> toJson() => {
        'gameFeedback': gameFeedback,
        'customGoals': customGoals.map((g) => g.toJson()).toList(),
        'sensoryProfile': sensoryProfile.toJson(),
        'gameSessions': gameSessions.map((s) => s.toJson()).toList(),
        'goalProgressHistory':
            goalProgressHistory.map((s) => s.toJson()).toList(),
        'templateGoalToggles': templateGoalToggles,
        'completedPlanSteps': completedPlanSteps,
        'customStories': customStories.map((s) => s.toJson()).toList(),
      };

  bool get hasAnyData =>
      customGoals.isNotEmpty ||
      gameSessions.isNotEmpty ||
      goalProgressHistory.isNotEmpty;
}

// ── Saf durum geçişleri — web `treatmentState.ts` birebir ────────────────────

/// Web `SESSION_RETENTION_DAYS = 90` — kayıt budama (yalnız kaydederken).
List<GameSession> pruneOldSessions(List<GameSession> sessions) {
  final cutoff = DateTime.now().subtract(const Duration(days: 90));
  return sessions.where((s) {
    final at = DateTime.tryParse(s.completedAt);
    return at != null && !at.isBefore(cutoff);
  }).toList();
}

String gameFeedbackKey(String todayKey, String gameId) => '$todayKey:$gameId';

String? gameFeedbackForDay(
  Map<String, String> gameFeedback,
  String todayKey,
  String gameId,
) =>
    gameFeedback[gameFeedbackKey(todayKey, gameId)];

Map<String, String> _removeGameFeedbackForDay(
  Map<String, String> gameFeedback,
  String todayKey,
  String gameId,
) {
  final dailyKey = gameFeedbackKey(todayKey, gameId);
  return Map.fromEntries(gameFeedback.entries
      .where((e) => e.key != dailyKey && e.key != gameId));
}

/// Web `recordGoalProgressForDay` — bugünün kaydını günceller.
List<GoalProgressSnapshot> recordGoalProgressForDay(
  List<GoalGroup> groups,
  List<GoalProgressSnapshot> history,
  String todayKey,
) {
  final total = groups.fold<int>(0, (sum, g) => sum + g.items.length);
  final done = groups.fold<int>(
      0, (sum, g) => sum + g.items.where((i) => i.status == 'done').length);
  final percent = total > 0 ? ((done / total) * 100).round() : 0;
  return [
    ...history.where((item) => item.dayKey != todayKey),
    GoalProgressSnapshot(
      recordedAt: DateTime.now().toUtc().toIso8601String(),
      percent: percent,
    ),
  ];
}

/// Web `toggleGameSessionForDay`.
({Map<String, String> gameFeedback, List<GameSession> gameSessions})
    toggleGameSessionForDay({
  required String gameId,
  required String todayKey,
  required List<GameSession> gameSessions,
  required Map<String, String> gameFeedback,
  required List<TherapyGame> games,
}) {
  final isCompleted = gameSessions
      .any((s) => s.gameId == gameId && s.dayKey == todayKey);
  final game = games.where((g) => g.id == gameId).firstOrNull;

  final nextFeedback = isCompleted
      ? _removeGameFeedbackForDay(gameFeedback, todayKey, gameId)
      : gameFeedback;

  final others = gameSessions
      .where((s) => !(s.gameId == gameId && s.dayKey == todayKey))
      .toList();
  final nextSessions = isCompleted
      ? others
      : [
          ...others,
          GameSession(
            gameId: gameId,
            status:
                gameFeedbackForDay(nextFeedback, todayKey, gameId) ?? 'assisted',
            focusKey: game?.key ?? 'communication',
            linkedGoal: game?.linkedGoal ?? 'Genel hedef',
            completedAt: DateTime.now().toUtc().toIso8601String(),
          ),
        ];

  return (gameFeedback: nextFeedback, gameSessions: nextSessions);
}

/// Web `saveGameFeedbackForDay`.
({Map<String, String> gameFeedback, List<GameSession> gameSessions})
    saveGameFeedbackForDay({
  required String gameId,
  required String status,
  required String todayKey,
  required List<GameSession> gameSessions,
  required Map<String, String> gameFeedback,
  required List<TherapyGame> games,
}) {
  final game = games.where((g) => g.id == gameId).firstOrNull;
  final nextFeedback = {
    ..._removeGameFeedbackForDay(gameFeedback, todayKey, gameId),
    gameFeedbackKey(todayKey, gameId): status,
  };
  final nextSessions = [
    ...gameSessions.where((s) => !(s.gameId == gameId && s.dayKey == todayKey)),
    GameSession(
      gameId: gameId,
      status: status,
      focusKey: game?.key ?? 'communication',
      linkedGoal: game?.linkedGoal ?? 'Genel hedef',
      completedAt: DateTime.now().toUtc().toIso8601String(),
    ),
  ];
  return (gameFeedback: nextFeedback, gameSessions: nextSessions);
}

/// Web `buildPlanStepToggleResult`.
List<String> togglePlanStep({
  required String stepId,
  required String todayKey,
  required List<String> completedPlanSteps,
}) {
  final key = '$todayKey:$stepId';
  return completedPlanSteps.contains(key)
      ? completedPlanSteps.where((s) => s != key).toList()
      : [...completedPlanSteps, key];
}
