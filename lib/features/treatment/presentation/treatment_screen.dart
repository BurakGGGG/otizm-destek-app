import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/haptics.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../i18n/strings.g.dart';
import '../../appointments/data/appointment_repository.dart';
import '../../appointments/domain/appointment.dart';
import '../../calendar/data/calendar_repository.dart';
import '../../calendar/domain/calendar_event.dart';
import '../../children/data/child_repository.dart';
import '../../children/domain/child.dart';
import '../../mood/data/mood_repository.dart';
import '../../mood/domain/mood_entry.dart';
import '../../notes/data/note_repository.dart';
import '../../notes/domain/development_note.dart';
import '../data/treatment_repository.dart';
import '../domain/treatment_plan.dart';
import '../domain/treatment_state.dart';
import 'tabs/treatment_games_tab.dart';
import 'tabs/treatment_goals_tab.dart';
import 'tabs/treatment_today_tab.dart';
import 'tabs/treatment_tools_tab.dart';

/// Sekmelerin ortak veri paketi (web `useTreatmentPageData` çıktısının karşılığı).
class TreatmentData {
  const TreatmentData({
    required this.child,
    required this.state,
    required this.plan,
    required this.mergedGroups,
    required this.notes,
    required this.activeAppointments,
    required this.events,
    required this.todayMood,
    required this.todayKey,
    required this.saving,
  });

  final Child child;
  final TreatmentPageState state;
  final SupportPlan plan;
  final List<GoalGroup> mergedGroups;
  final List<DevelopmentNote> notes;
  final List<Appointment> activeAppointments;
  final List<CalendarEvent> events;
  final MoodEntry? todayMood;
  final String todayKey;
  final bool saving;

  int get totalGoalCount =>
      mergedGroups.fold(0, (sum, g) => sum + g.items.length);

  int get completedGoalCount => mergedGroups.fold(
      0, (sum, g) => sum + g.items.where((i) => i.status == 'done').length);

  /// Bugün tamamlanan oyunların id listesi (tekilleştirilmiş).
  List<String> get todayCompletedGames => state.gameSessions
      .where((s) => s.dayKey == todayKey)
      .map((s) => s.gameId)
      .toSet()
      .toList();

  /// Bugünün oyun geri bildirimi — düz gameId anahtarıyla.
  Map<String, String> get todayGameFeedback {
    final map = <String, String>{};
    for (final game in plan.games) {
      final status = gameFeedbackForDay(state.gameFeedback, todayKey, game.id);
      if (status != null) map[game.id] = status;
    }
    return map;
  }

  /// Bugün tamamlanan plan adımı id'leri.
  Set<String> get todayCompletedPlanSteps => state.completedPlanSteps
      .where((s) => s.startsWith('$todayKey:'))
      .map((s) => s.substring(todayKey.length + 1))
      .toSet();

  bool get showMilestoneBanner =>
      plan.games.isNotEmpty && todayCompletedGames.length >= plan.games.length;

  /// Web `streakDays` — art arda aktif gün sayısı.
  int get streakDays {
    final activeDays = <String>{
      ...state.gameSessions.map((s) => s.dayKey),
      ...state.goalProgressHistory.map((s) => s.dayKey),
    };
    final startFrom = activeDays.contains(todayKey) ? 0 : 1;
    var count = 0;
    for (var i = startFrom; i <= 365; i++) {
      final d = DateTime.now().subtract(Duration(days: i));
      if (activeDays.contains(treatmentDateKey(d))) {
        count++;
      } else if (i > startFrom) {
        break;
      }
    }
    return count;
  }

  /// Son 7 gün içinde (gün+oyun) bazında tekil tamamlanan oyun sayısı.
  int get weeklyCompletedGameCount {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 6));
    final cutoffKey = treatmentDateKey(sevenDaysAgo);
    return state.gameSessions
        .where((s) => s.dayKey.compareTo(cutoffKey) >= 0)
        .map((s) => '${s.dayKey}:${s.gameId}')
        .toSet()
        .length;
  }

  /// Web `weeklyProgress` — 7 günlük oyun/hedef çubukları.
  List<({String key, String label, int gameCount, int goalPercent})>
      weeklyProgress(List<String> dayLabels) {
    return List.generate(7, (index) {
      final date = DateTime.now().subtract(Duration(days: 6 - index));
      final key = treatmentDateKey(date);
      final daySessions =
          state.gameSessions.where((s) => s.dayKey == key).toList();
      final dayGoals =
          state.goalProgressHistory.where((s) => s.dayKey == key).toList();
      final goalPercent = dayGoals.isNotEmpty
          ? dayGoals.last.percent
          : key == todayKey
              ? ((completedGoalCount /
                          (totalGoalCount > 0 ? totalGoalCount : 1)) *
                      100)
                  .round()
              : 0;
      return (
        key: key,
        label: dayLabels[date.weekday % 7],
        gameCount: daySessions.map((s) => s.gameId).toSet().length,
        goalPercent: goalPercent,
      );
    });
  }
}

/// Sekmelerin tetiklediği eylemler (iyimser uygula → kaydet → hata: geri al).
class TreatmentActions {
  const TreatmentActions({
    required this.togglePlanStep,
    required this.addGoal,
    required this.toggleGoal,
    required this.updateGoal,
    required this.deleteGoal,
    required this.toggleTemplateGoal,
    required this.toggleGameCompletion,
    required this.saveGameFeedback,
    required this.addStory,
    required this.deleteStory,
    required this.updateSensory,
    required this.saveSensory,
    required this.addMilestone,
  });

  final Future<void> Function(String stepId) togglePlanStep;
  final Future<bool> Function(String title, String focusKey, String? dueDate)
      addGoal;
  final Future<void> Function(String goalId) toggleGoal;
  final Future<bool> Function(
      String goalId, String title, String focusKey, String? dueDate) updateGoal;
  final Future<void> Function(String goalId) deleteGoal;
  final Future<void> Function(String label) toggleTemplateGoal;
  final Future<void> Function(String gameId) toggleGameCompletion;
  final Future<void> Function(String gameId, String status) saveGameFeedback;
  final Future<bool> Function(String title, String icon, String linkedGoal)
      addStory;
  final Future<void> Function(String storyId) deleteStory;
  final void Function(SensoryProfile profile) updateSensory;
  final Future<void> Function() saveSensory;
  final Future<bool> Function(String title, String category) addMilestone;
}

/// Tedavi Paneli — web `/tedavi` sayfasının veli tarafı.
/// Durum blob'u `/api/treatment-state/{childId}` ile paylaşılan DB'de tutulur.
class TreatmentScreen extends ConsumerStatefulWidget {
  const TreatmentScreen({super.key});

  @override
  ConsumerState<TreatmentScreen> createState() => _TreatmentScreenState();
}

class _TreatmentScreenState extends ConsumerState<TreatmentScreen> {
  String? _selectedChildId;
  String? _loadedChildId;
  TreatmentPageState? _state;
  bool _loadingState = false;
  String? _stateError;
  bool _saving = false;
  bool _onboardDismissed = false;

  Future<void> _loadState(String childId) async {
    setState(() {
      _loadingState = true;
      _stateError = null;
      _loadedChildId = childId;
      _state = null;
    });
    try {
      final state =
          await ref.read(treatmentRepositoryProvider).getState(childId);
      if (!mounted || _loadedChildId != childId) return;
      setState(() {
        _state = state;
        _loadingState = false;
      });
    } on ApiException catch (e) {
      if (!mounted || _loadedChildId != childId) return;
      setState(() {
        _stateError = e.message;
        _loadingState = false;
      });
    }
  }

  /// Web `persistTreatmentState` — iyimser uygula, hatada geri al.
  Future<bool> _persist(
    String childId,
    TreatmentPageState next,
    TreatmentPageState rollback, {
    String? successMessage,
  }) async {
    setState(() {
      _state = next;
      _saving = true;
    });
    try {
      final saved =
          await ref.read(treatmentRepositoryProvider).saveState(childId, next);
      if (!mounted) return true;
      setState(() {
        if (_loadedChildId == childId) _state = saved;
        _saving = false;
      });
      if (successMessage != null) {
        Haptics.success();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(successMessage)));
      }
      return true;
    } on ApiException {
      if (!mounted) return false;
      setState(() {
        if (_loadedChildId == childId) _state = rollback;
        _saving = false;
      });
      Haptics.warning();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.t.treatment.saveError)),
      );
      return false;
    }
  }

  List<Appointment> _activeAppointmentsFor(String childId) {
    final all = ref.read(appointmentsProvider).value ?? const <Appointment>[];
    final mine = all.where((a) => a.childId == childId).toList()
      ..sort((a, b) => '${treatmentDateKey(a.date)} ${a.time}'
          .compareTo('${treatmentDateKey(b.date)} ${b.time}'));
    return mine
        .where((a) =>
            a.statusKind != AppointmentStatusKind.cancelled &&
            a.statusKind != AppointmentStatusKind.completed)
        .toList();
  }

  SupportPlan _buildPlan(Child child) {
    final notes =
        ref.read(recentNotesProvider(child.id)).value ?? const <DevelopmentNote>[];
    return buildSupportPlan(
      splitTherapies(child.therapies),
      notes,
      _activeAppointmentsFor(child.id),
      ref.read(calendarEventsProvider(child.id)).value ?? const <CalendarEvent>[],
    );
  }

  TreatmentActions _actions(Child child) {
    final todayKey = treatmentDateKey(DateTime.now());
    final t = context.t;

    return TreatmentActions(
      togglePlanStep: (stepId) async {
        final state = _state;
        if (state == null || _saving) return;
        Haptics.selection();
        final next = state.copyWith(
          completedPlanSteps: togglePlanStep(
            stepId: stepId,
            todayKey: todayKey,
            completedPlanSteps: state.completedPlanSteps,
          ),
        );
        await _persist(child.id, next, state);
      },
      addGoal: (title, focusKey, dueDate) async {
        final state = _state;
        if (state == null || _saving || title.trim().isEmpty) return false;
        final nextGoals = [
          ...state.customGoals,
          EditableGoal(
            id: randomUuidV4(),
            title: title.trim(),
            focusKey: focusKey,
            done: false,
            dueDate: (dueDate?.isEmpty ?? true) ? null : dueDate,
          ),
        ];
        final next = state.copyWith(
          customGoals: nextGoals,
          goalProgressHistory: recordGoalProgressForDay(
            mergeGoalGroups(
                _buildPlan(child).goalGroups, nextGoals, state.templateGoalToggles),
            state.goalProgressHistory,
            todayKey,
          ),
        );
        return _persist(child.id, next, state,
            successMessage: t.treatment.goalAdded);
      },
      toggleGoal: (goalId) async {
        final state = _state;
        if (state == null || _saving) return;
        Haptics.selection();
        final nextGoals = state.customGoals
            .map((g) => g.id == goalId ? g.copyWith(done: !g.done) : g)
            .toList();
        final next = state.copyWith(
          customGoals: nextGoals,
          goalProgressHistory: recordGoalProgressForDay(
            mergeGoalGroups(
                _buildPlan(child).goalGroups, nextGoals, state.templateGoalToggles),
            state.goalProgressHistory,
            todayKey,
          ),
        );
        await _persist(child.id, next, state,
            successMessage: t.treatment.goalUpdated);
      },
      updateGoal: (goalId, title, focusKey, dueDate) async {
        final state = _state;
        if (state == null || _saving || title.trim().isEmpty) return false;
        final nextGoals = state.customGoals
            .map((g) => g.id == goalId
                ? g.copyWith(
                    title: title.trim(),
                    focusKey: focusKey,
                    dueDate: () => (dueDate?.isEmpty ?? true) ? null : dueDate,
                  )
                : g)
            .toList();
        final next = state.copyWith(
          customGoals: nextGoals,
          goalProgressHistory: recordGoalProgressForDay(
            mergeGoalGroups(
                _buildPlan(child).goalGroups, nextGoals, state.templateGoalToggles),
            state.goalProgressHistory,
            todayKey,
          ),
        );
        return _persist(child.id, next, state,
            successMessage: t.treatment.goalEdited);
      },
      deleteGoal: (goalId) async {
        final state = _state;
        if (state == null || _saving) return;
        final nextGoals =
            state.customGoals.where((g) => g.id != goalId).toList();
        final next = state.copyWith(
          customGoals: nextGoals,
          goalProgressHistory: recordGoalProgressForDay(
            mergeGoalGroups(
                _buildPlan(child).goalGroups, nextGoals, state.templateGoalToggles),
            state.goalProgressHistory,
            todayKey,
          ),
        );
        await _persist(child.id, next, state,
            successMessage: t.treatment.goalDeleted);
      },
      toggleTemplateGoal: (label) async {
        final state = _state;
        if (state == null || _saving) return;
        Haptics.selection();
        final current = state.templateGoalToggles[label] ?? false;
        final nextToggles = {...state.templateGoalToggles, label: !current};
        final next = state.copyWith(
          templateGoalToggles: nextToggles,
          goalProgressHistory: recordGoalProgressForDay(
            mergeGoalGroups(
                _buildPlan(child).goalGroups, state.customGoals, nextToggles),
            state.goalProgressHistory,
            todayKey,
          ),
        );
        await _persist(child.id, next, state,
            successMessage: t.treatment.goalUpdated);
      },
      toggleGameCompletion: (gameId) async {
        final state = _state;
        if (state == null || _saving) return;
        Haptics.selection();
        final result = toggleGameSessionForDay(
          gameId: gameId,
          todayKey: todayKey,
          gameSessions: state.gameSessions,
          gameFeedback: state.gameFeedback,
          games: _buildPlan(child).games,
        );
        final next = state.copyWith(
          gameFeedback: result.gameFeedback,
          gameSessions: result.gameSessions,
        );
        await _persist(child.id, next, state);
      },
      saveGameFeedback: (gameId, status) async {
        final state = _state;
        if (state == null || _saving) return;
        Haptics.selection();
        final result = saveGameFeedbackForDay(
          gameId: gameId,
          status: status,
          todayKey: todayKey,
          gameSessions: state.gameSessions,
          gameFeedback: state.gameFeedback,
          games: _buildPlan(child).games,
        );
        final next = state.copyWith(
          gameFeedback: result.gameFeedback,
          gameSessions: result.gameSessions,
        );
        await _persist(child.id, next, state,
            successMessage: t.treatment.feedbackSaved);
      },
      addStory: (title, icon, linkedGoal) async {
        final state = _state;
        if (state == null || _saving || title.trim().isEmpty) return false;
        final next = state.copyWith(customStories: [
          ...state.customStories,
          CustomStory(
            id: randomUuidV4(),
            title: title.trim(),
            icon: icon.trim().isEmpty ? '📖' : icon.trim(),
            linkedGoal:
                linkedGoal.trim().isEmpty ? 'Genel hedef' : linkedGoal.trim(),
          ),
        ]);
        return _persist(child.id, next, state,
            successMessage: t.treatment.storyAdded);
      },
      deleteStory: (storyId) async {
        final state = _state;
        if (state == null || _saving) return;
        final next = state.copyWith(
          customStories:
              state.customStories.where((s) => s.id != storyId).toList(),
        );
        await _persist(child.id, next, state,
            successMessage: t.treatment.storyDeleted);
      },
      updateSensory: (profile) {
        final state = _state;
        if (state == null) return;
        setState(() => _state = state.copyWith(sensoryProfile: profile));
      },
      saveSensory: () async {
        final state = _state;
        if (state == null || _saving) return;
        await _persist(child.id, state, state,
            successMessage: t.treatment.sensorySaved);
      },
      addMilestone: (title, category) async {
        if (title.trim().isEmpty) return false;
        try {
          await ref.read(treatmentRepositoryProvider).createMilestone(
                childId: child.id,
                title: title,
                category: category,
              );
          if (!mounted) return true;
          Haptics.success();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(t.treatment.milestoneSaved)),
          );
          return true;
        } on ApiException catch (e) {
          if (!mounted) return false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.message)));
          return false;
        }
      },
    );
  }

  Future<void> _refresh(Child child) async {
    ref.invalidate(recentNotesProvider(child.id));
    ref.invalidate(appointmentsProvider);
    ref.invalidate(calendarEventsProvider(child.id));
    ref.invalidate(moodEntriesProvider(child.id));
    await _loadState(child.id);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final childrenAsync = ref.watch(childrenProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.treatment.title)),
      body: childrenAsync.when(
        loading: () => const SkeletonList(),
        error: (e, _) => ErrorRetry(
          message: e is ApiException ? e.message : null,
          onRetry: () => ref.invalidate(childrenProvider),
        ),
        data: (children) {
          if (children.isEmpty) {
            return EmptyState(
              icon: Icons.child_care_outlined,
              message:
                  '${t.treatment.noChildrenTitle}\n${t.treatment.noChildrenBody}',
              actionLabel: t.treatment.addChild,
              actionIcon: Icons.add,
              onAction: () => context.push('/children'),
            );
          }

          final active = children.firstWhere(
            (c) => c.id == _selectedChildId,
            orElse: () => children.first,
          );
          if (_loadedChildId != active.id && !_loadingState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _loadState(active.id);
            });
          }

          return Column(
            children: [
              if (children.length > 1)
                _ChildSelector(
                  children: children,
                  selectedId: active.id,
                  onSelect: (id) => setState(() => _selectedChildId = id),
                ),
              Expanded(child: _buildBody(active)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(Child child) {
    final t = context.t;
    final state = _state;

    if (_stateError != null) {
      return ErrorRetry(
        message: _stateError,
        onRetry: () => _loadState(child.id),
      );
    }
    if (state == null || _loadingState || _loadedChildId != child.id) {
      return const SkeletonList();
    }

    // Destek verileri (plan girişleri) — yüklenmemişse boş listeyle ilerler.
    final notes =
        ref.watch(recentNotesProvider(child.id)).value ?? const <DevelopmentNote>[];
    ref.watch(appointmentsProvider);
    final events =
        ref.watch(calendarEventsProvider(child.id)).value ?? const <CalendarEvent>[];
    final moodEntries =
        ref.watch(moodEntriesProvider(child.id)).value;
    final todayIso = treatmentDateKey(DateTime.now());
    final todayMood = moodEntries
        ?.where((e) => e.entryDate == todayIso)
        .firstOrNull;

    final activeAppointments = _activeAppointmentsFor(child.id);
    final plan = buildSupportPlan(
      splitTherapies(child.therapies),
      notes,
      activeAppointments,
      events,
    );
    final data = TreatmentData(
      child: child,
      state: state,
      plan: plan,
      mergedGroups: mergeGoalGroups(
          plan.goalGroups, state.customGoals, state.templateGoalToggles),
      notes: notes,
      activeAppointments: activeAppointments,
      events: events,
      todayMood: todayMood,
      todayKey: todayIso,
      saving: _saving,
    );
    final actions = _actions(child);

    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          _PlanHeader(child: child, plan: plan),
          TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: t.treatment.tabToday),
              Tab(text: t.treatment.tabGoals),
              Tab(text: t.treatment.tabGames),
              Tab(text: t.treatment.tabTools),
            ],
          ),
          if (!data.state.hasAnyData && !_onboardDismissed)
            _OnboardingCard(
              onDismiss: () => setState(() => _onboardDismissed = true),
            ),
          Expanded(
            child: TabBarView(
              children: [
                RefreshIndicator(
                  onRefresh: () => _refresh(child),
                  child: TreatmentTodayTab(data: data, actions: actions),
                ),
                TreatmentGoalsTab(data: data, actions: actions),
                TreatmentGamesTab(data: data, actions: actions),
                TreatmentToolsTab(data: data, actions: actions),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Üst şerit: günlük destek planı etiketi + odak alanı rozetleri.
class _PlanHeader extends StatelessWidget {
  const _PlanHeader({required this.child, required this.plan});

  final Child child;
  final SupportPlan plan;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(
          AppSpacing.margin, 8, AppSpacing.margin, 8),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.treatment.subtitle.toUpperCase(),
            style: text.labelSmall?.copyWith(
              color: context.colors.primary,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 2),
          Text(child.name, style: text.titleLarge),
          const SizedBox(height: 2),
          Text(
            plan.activeProgramLabel == kDefaultProgramLabel
                ? t.treatment.programActiveDefault
                : t.treatment.programActive(name: plan.activeProgramLabel),
            style: text.bodySmall?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final area in plan.focusAreas)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    border: Border.all(color: context.colors.border),
                  ),
                  child: Text(
                    area.label,
                    style: text.labelSmall?.copyWith(
                      color: context.colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// İlk kullanım kartı (web `TreatmentOnboarding` — veri yokken).
class _OnboardingCard extends StatelessWidget {
  const _OnboardingCard({required this.onDismiss});

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.fromLTRB(
          AppSpacing.margin, 8, AppSpacing.margin, 0),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  t.treatment.onboardTitle,
                  style: text.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: onDismiss,
                icon: Icon(Icons.close,
                    size: 18, color: context.colors.textTertiary),
              ),
            ],
          ),
          Text(t.treatment.onboardBody, style: text.bodySmall),
          const SizedBox(height: 6),
          Text(t.treatment.onboardStep1, style: text.bodySmall),
          Text(t.treatment.onboardStep2, style: text.bodySmall),
          Text(t.treatment.onboardStep3, style: text.bodySmall),
        ],
      ),
    );
  }
}

class _ChildSelector extends StatelessWidget {
  const _ChildSelector({
    required this.children,
    required this.selectedId,
    required this.onSelect,
  });

  final List<Child> children;
  final String selectedId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.margin,
          vertical: 8,
        ),
        itemCount: children.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final c = children[i];
          final sel = c.id == selectedId;
          return ChoiceChip(
            label: Text(c.name),
            selected: sel,
            onSelected: (_) => onSelect(c.id),
            showCheckmark: false,
            selectedColor: context.colors.primary,
            backgroundColor: context.colors.surface,
            side: BorderSide(color: context.colors.border),
            labelStyle: TextStyle(
              color: sel ? Colors.white : context.colors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          );
        },
      ),
    );
  }
}
