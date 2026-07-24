import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../i18n/strings.g.dart';
import '../../../mood/domain/mood_entry.dart';
import '../../../notes/domain/development_note.dart';
import '../../domain/treatment_plan.dart';
import '../../domain/treatment_state.dart';
import '../treatment_screen.dart';

/// Bugün sekmesi — günün kısa planı, öneriler, son not ve haftalık özet.
class TreatmentTodayTab extends StatelessWidget {
  const TreatmentTodayTab({super.key, required this.data, required this.actions});

  final TreatmentData data;
  final TreatmentActions actions;

  @override
  Widget build(BuildContext context) {
    final completedSteps = data.todayCompletedPlanSteps;
    final doneCount =
        data.plan.todayPlan.where((s) => completedSteps.contains(s.id)).length;
    final totalCount = data.plan.todayPlan.length;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.margin),
      children: [
        _PlanCard(
          data: data,
          actions: actions,
          doneCount: doneCount,
          totalCount: totalCount,
        ),
        const SizedBox(height: 12),
        _MoodCard(todayMood: data.todayMood),
        const SizedBox(height: 12),
        if (data.plan.smartSuggestions.isNotEmpty) ...[
          _SuggestionsCard(suggestions: data.plan.smartSuggestions),
          const SizedBox(height: 12),
        ],
        _LatestNoteCard(note: data.notes.firstOrNull),
        const SizedBox(height: 12),
        _WeeklySummaryCard(data: data),
        const SizedBox(height: 12),
        _MicroProgressCard(data: data),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.data,
    required this.actions,
    required this.doneCount,
    required this.totalCount,
  });

  final TreatmentData data;
  final TreatmentActions actions;
  final int doneCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final completedSteps = data.todayCompletedPlanSteps;
    final percentDone =
        totalCount > 0 ? ((doneCount / totalCount) * 100).round() : 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.treatment.todayTitle, style: text.titleMedium),
            const SizedBox(height: 4),
            Text(
              t.treatment.todaySubtitle,
              style: text.bodySmall?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                if (data.streakDays >= 2)
                  _Pill(
                    label: t.treatment
                        .streakDays(count: data.streakDays)
                        .toUpperCase(),
                    color: context.colors.warning,
                  ),
                if (doneCount > 0)
                  _Pill(
                    label: t.treatment
                        .doneOf(done: doneCount, total: totalCount)
                        .toUpperCase(),
                    color: context.colors.success,
                  ),
                _Pill(
                  label: t.treatment.stepCount(count: totalCount).toUpperCase(),
                  color: context.colors.textSecondary,
                ),
              ],
            ),
            if (totalCount > 0) ...[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.full),
                child: LinearProgressIndicator(
                  value: percentDone / 100,
                  minHeight: 6,
                  backgroundColor: context.colors.surfaceVariant,
                  color: context.colors.success,
                ),
              ),
            ],
            const SizedBox(height: 12),
            if (totalCount == 0)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: context.colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.treatment.emptyPlanTitle,
                      style: text.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      t.treatment.emptyPlanBody,
                      style: text.bodySmall?.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            for (final step in data.plan.todayPlan) ...[
              _PlanStepTile(
                step: step,
                done: completedSteps.contains(step.id),
                saving: data.saving,
                onTap: () => actions.togglePlanStep(step.id),
              ),
              const SizedBox(height: 8),
            ],
            if (totalCount > 0 && doneCount == totalCount)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: context.colors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: context.colors.success.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: context.colors.success),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.treatment.planDone,
                            style: text.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            t.treatment.planDoneSub,
                            style: text.bodySmall?.copyWith(
                              color: context.colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PlanStepTile extends StatelessWidget {
  const _PlanStepTile({
    required this.step,
    required this.done,
    required this.saving,
    required this.onTap,
  });

  final TodayPlanStep step;
  final bool done;
  final bool saving;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return InkWell(
      onTap: saving ? null : onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: done
              ? context.colors.success.withValues(alpha: 0.08)
              : context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: done
                ? context.colors.success.withValues(alpha: 0.4)
                : context.colors.border,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: done ? context.colors.success : context.colors.surface,
                border: Border.all(
                  color:
                      done ? context.colors.success : context.colors.border,
                  width: 2,
                ),
              ),
              child: done
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: text.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      decoration: done ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    step.detail,
                    style: text.bodySmall?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      _MetaChip(
                          icon: Icons.schedule, label: step.duration),
                      _MetaChip(label: step.linkedGoal),
                      _MetaChip(label: step.linkedTool),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoodCard extends StatelessWidget {
  const _MoodCard({required this.todayMood});

  final MoodEntry? todayMood;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final mood = todayMood;
    final labels = <int, String>{
      1: t.treatment.moodLevel1,
      2: t.treatment.moodLevel2,
      3: t.treatment.moodLevel3,
      4: t.treatment.moodLevel4,
      5: t.treatment.moodLevel5,
    };

    return Card(
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        leading: Icon(
          mood != null ? Icons.psychology : Icons.psychology_outlined,
          color: context.colors.primary,
        ),
        title: Text(
          mood != null
              ? t.treatment.moodTodayLabel(
                  label: labels[mood.moodLevel] ?? t.treatment.moodLevel3,
                )
              : t.treatment.moodSaveTitle,
          style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          mood != null ? t.treatment.moodPlanned : t.treatment.moodSaveSub,
          style: text.bodySmall,
        ),
        trailing:
            Icon(Icons.chevron_right, color: context.colors.textTertiary),
        onTap: () => context.push('/daily-tracker'),
      ),
    );
  }
}

class _SuggestionsCard extends StatelessWidget {
  const _SuggestionsCard({required this.suggestions});

  final List<SmartSuggestion> suggestions;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outline, color: context.colors.primary),
                const SizedBox(width: 8),
                Text(t.treatment.suggestionsTitle, style: text.titleSmall),
              ],
            ),
            const SizedBox(height: 10),
            for (final s in suggestions) ...[
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: context.colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.title,
                      style: text.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      s.detail,
                      style: text.bodySmall?.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LatestNoteCard extends StatelessWidget {
  const _LatestNoteCard({required this.note});

  final DevelopmentNote? note;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final n = note;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.treatment.latestNoteTitle, style: text.titleSmall),
            const SizedBox(height: 10),
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: context.colors.primaryContainer,
                  child: Icon(
                    n != null ? Icons.badge_outlined : Icons.smart_toy_outlined,
                    size: 16,
                    color: context.colors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              n != null
                                  ? t.treatment.defaultExpert
                                  : t.treatment.noNoteAuthor,
                              style: text.bodySmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                          if (n != null) ...[
                            const SizedBox(width: 6),
                            _Pill(
                              label: treatmentMoodLabel(n.mood),
                              color: context.colors.warning,
                            ),
                          ],
                        ],
                      ),
                      Text(
                        n != null ? n.title : t.treatment.noNoteRole,
                        style: text.labelSmall?.copyWith(
                          color: context.colors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: context.colors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Text(
                n != null
                    ? ((n.content?.isNotEmpty ?? false)
                        ? n.content!
                        : t.treatment.noteEmptyContent)
                    : t.treatment.noNoteBody,
                style: text.bodySmall?.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ),
            if (n != null && (n.createdAt ?? n.noteDate) != null) ...[
              const SizedBox(height: 8),
              Text(
                treatmentDateKey((n.createdAt ?? n.noteDate)!),
                style: text.labelSmall?.copyWith(
                  color: context.colors.textTertiary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _WeeklySummaryCard extends StatelessWidget {
  const _WeeklySummaryCard({required this.data});

  final TreatmentData data;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final weekly = data.weeklyProgress(t.treatment.daysShort);
    final games = data.weeklyCompletedGameCount;
    final sessionCount =
        data.activeAppointments.length + data.events.length;

    final stats = [
      (
        title: t.treatment.weekGamesTitle,
        value: '$games',
        detail:
            games > 0 ? t.treatment.weekGamesDetail : t.treatment.weekGamesEmpty,
      ),
      (
        title: t.treatment.weekGoalsTitle,
        value: data.totalGoalCount > 0
            ? '${data.completedGoalCount}/${data.totalGoalCount}'
            : '—',
        detail: data.totalGoalCount > 0
            ? t.treatment.weekGoalsDetail
            : t.treatment.weekGoalsEmpty,
      ),
      (
        title: t.treatment.weekSessionsTitle,
        value: '$sessionCount',
        detail: sessionCount > 0
            ? t.treatment.weekSessionsDetail
            : t.treatment.weekSessionsEmpty,
      ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child:
                      Text(t.treatment.weeklyTitle, style: text.titleSmall),
                ),
                _LegendDot(
                    color: context.colors.primary,
                    label: t.treatment.legendGame),
                const SizedBox(width: 8),
                _LegendDot(
                    color: context.colors.success,
                    label: t.treatment.legendGoal),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              t.treatment.weeklySubtitle,
              style: text.bodySmall?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            for (final stat in stats) ...[
              Row(
                children: [
                  Expanded(
                    child: Text(
                      stat.title,
                      style: text.bodySmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  _Pill(label: stat.value, color: context.colors.success),
                ],
              ),
              Text(
                stat.detail,
                style: text.labelSmall?.copyWith(
                  color: context.colors.textTertiary,
                ),
              ),
              const SizedBox(height: 8),
            ],
            const SizedBox(height: 4),
            _WeeklyChart(items: weekly, gamesTotal: data.plan.games.length),
          ],
        ),
      ),
    );
  }
}

/// Web `WeeklyProgressChart` — gün başına iki dikey çubuk (oyun + hedef).
class _WeeklyChart extends StatelessWidget {
  const _WeeklyChart({required this.items, required this.gamesTotal});

  final List<({String key, String label, int gameCount, int goalPercent})>
      items;
  final int gamesTotal;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (final item in items)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Column(
                children: [
                  SizedBox(
                    height: 72,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _Bar(
                          fraction: gamesTotal > 0
                              ? (item.gameCount / gamesTotal).clamp(
                                  item.gameCount > 0 ? 0.1 : 0.0, 1.0)
                              : 0,
                          color: context.colors.primary,
                          track: context.colors.surfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        _Bar(
                          fraction: (item.goalPercent / 100).clamp(
                              item.goalPercent > 0 ? 0.1 : 0.0, 1.0),
                          color: context.colors.success,
                          track: context.colors.surfaceVariant,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    style: text.labelSmall?.copyWith(
                      color: context.colors.textTertiary,
                    ),
                  ),
                  Text(
                    t.treatment.chartGames(count: item.gameCount),
                    style: text.labelSmall
                        ?.copyWith(fontSize: 9, color: context.colors.textSecondary),
                  ),
                  Text(
                    t.treatment.chartGoal(percent: item.goalPercent),
                    style: text.labelSmall
                        ?.copyWith(fontSize: 9, color: context.colors.textTertiary),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.fraction, required this.color, required this.track});

  final double fraction;
  final Color color;
  final Color track;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 72,
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        color: track,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: FractionallySizedBox(
        heightFactor: fraction,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
        ),
      ),
    );
  }
}

class _MicroProgressCard extends StatelessWidget {
  const _MicroProgressCard({required this.data});

  final TreatmentData data;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.treatment.microTitle, style: text.titleSmall),
            const SizedBox(height: 2),
            Text(
              t.treatment.microSubtitle,
              style: text.bodySmall?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            for (final group in data.mergedGroups) ...[
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: context.colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.trending_up,
                            size: 16, color: context.colors.success),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            group.title,
                            style: text.bodySmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        _Pill(
                          label: '%${group.percent}',
                          color: context.colors.success,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      group.summary,
                      style: text.labelSmall?.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      child: LinearProgressIndicator(
                        value: group.percent / 100,
                        minHeight: 5,
                        backgroundColor: context.colors.surface,
                        color: context.colors.success,
                      ),
                    ),
                    Builder(builder: (context) {
                      final game = data.plan.games
                          .where((g) => g.key == group.key)
                          .firstOrNull;
                      if (game == null) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '${t.treatment.microLinkedGame} ${game.title}',
                          style: text.labelSmall?.copyWith(
                            color: context.colors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({this.icon, required this.label});

  final IconData? icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: context.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: context.colors.textSecondary),
            const SizedBox(width: 3),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: context.colors.textSecondary,
          ),
        ),
      ],
    );
  }
}
