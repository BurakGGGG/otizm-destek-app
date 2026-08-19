import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/util/date_key.dart';
import '../../../../i18n/strings.g.dart';
import '../../data/daily_plan_provider.dart';
import '../../domain/daily_plan.dart';

/// "Bugün ne yapalım?" kartı — kural tabanlı günlük plan + koç notu
/// (web gösterge panelindeki `todayTasks` + `dailyCoachNote` karşılığı).
///
/// Veri gelene kadar ya da hata durumunda yer kaplamaz: ana sayfanın geri
/// kalanı (çocuklar, randevular, makaleler) tek başına çalışmaya devam eder.
class DailyPlanCard extends ConsumerWidget {
  const DailyPlanCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final input = ref.watch(dailyPlanInputProvider).asData?.value;
    if (input == null) return const SizedBox.shrink();

    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final tasks = buildDailyPlan(input);
    final progress = planProgress(tasks);
    final pending = tasks.where((task) => !task.done).toList();

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.dailyPlan.title, style: text.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      progress.allDone
                          ? t.dailyPlan.subtitleDone
                          : t.dailyPlan.subtitle(
                              count: progress.pending,
                              minutes: progress.pendingMinutes,
                            ),
                      style: text.labelSmall
                          ?.copyWith(color: colors.textSecondary),
                    ),
                  ],
                ),
              ),
              Text(
                '%${progress.percent}',
                style: text.titleMedium?.copyWith(
                  color: progress.allDone ? colors.success : colors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: LinearProgressIndicator(
              value: progress.total == 0 ? 0 : progress.completed / progress.total,
              minHeight: 6,
              backgroundColor: colors.surfaceVariant,
              valueColor: AlwaysStoppedAnimation(
                progress.allDone ? colors.success : colors.primary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _CoachNote(note: coachNoteFor(input, tasks), childName: input.childName),
          if (progress.allDone) ...[
            const SizedBox(height: 12),
            const _AllDoneNotice(),
          ],
          const SizedBox(height: 12),
          for (var i = 0; i < tasks.length; i++) ...[
            _TaskRow(
              task: tasks[i],
              stepNumber: tasks[i].done ? null : pending.indexOf(tasks[i]) + 1,
            ),
            if (i < tasks.length - 1) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

/// Koç notu — hangi varyantın gösterileceği saf kuralda belirlenir.
class _CoachNote extends StatelessWidget {
  const _CoachNote({required this.note, required this.childName});

  final CoachNote note;
  final String childName;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final part = switch (note.dayPart) {
      DayPart.morning => t.dailyPlan.partMorning,
      DayPart.afternoon => t.dailyPlan.partAfternoon,
      DayPart.evening => t.dailyPlan.partEvening,
    };
    final message = switch (note.kind) {
      CoachNoteKind.noChild => t.dailyPlan.coachNoChild,
      CoachNoteKind.allDone => t.dailyPlan.coachAllDone(name: childName),
      CoachNoteKind.medication => t.dailyPlan.coachMedication(
          name: childName,
          part: part,
          count: note.pending,
        ),
      CoachNoteKind.noMood =>
        t.dailyPlan.coachNoMood(name: childName, part: part),
      CoachNoteKind.event =>
        t.dailyPlan.coachEvent(name: childName, count: note.pending),
      CoachNoteKind.progress => t.dailyPlan.coachProgress(
          name: childName,
          done: note.completed,
          count: note.pending,
        ),
      CoachNoteKind.plan => t.dailyPlan.coachPlan(
          name: childName,
          part: part,
          minutes: note.minutes,
        ),
    };

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: .07),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.auto_awesome_outlined, size: 18, color: colors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.dailyPlan.coachLabel,
                  style: text.labelSmall?.copyWith(color: colors.primary),
                ),
                const SizedBox(height: 2),
                Text(message, style: text.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AllDoneNotice extends StatelessWidget {
  const _AllDoneNotice();

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.success.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, size: 18, color: colors.success),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.dailyPlan.allDoneTitle, style: text.labelLarge),
                const SizedBox(height: 2),
                Text(
                  t.dailyPlan.allDoneDetail,
                  style: text.labelSmall
                      ?.copyWith(color: colors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({required this.task, required this.stepNumber});

  final DailyTask task;

  /// Bekleyen işler için sıra numarası; tamamlananlarda null.
  final int? stepNumber;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final isPrimary = stepNumber == 1;
    final accent = task.done
        ? colors.success
        : isPrimary
            ? colors.primary
            : colors.textTertiary;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.md),
      // Uzmanlar sekmesi kabuğun içinde açılır; diğerleri üste itilir.
      onTap: () => task.route.startsWith('/home')
          ? context.go(task.route)
          : context.push(task.route),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: task.done
              ? colors.success.withValues(alpha: .06)
              : colors.surfaceVariant.withValues(alpha: .5),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isPrimary ? colors.primary.withValues(alpha: .35) : colors.border,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: task.done
                  ? Icon(Icons.check, size: 18, color: colors.success)
                  : Icon(_iconFor(task.kind), size: 18, color: accent),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _titleFor(t, task),
                    style: text.labelLarge?.copyWith(
                      color: task.done ? colors.textSecondary : null,
                      decoration: task.done ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _detailFor(t, task),
                    style: text.labelSmall
                        ?.copyWith(color: colors.textSecondary),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _Chip(
                        label: _badgeFor(t, task, stepNumber),
                        color: accent,
                      ),
                      const SizedBox(width: 6),
                      _Chip(
                        label: t.dailyPlan.durationMinutes(count: task.minutes),
                        color: colors.textTertiary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 20, color: colors.textTertiary),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: color),
      ),
    );
  }
}

IconData _iconFor(DailyTaskKind kind) => switch (kind) {
      DailyTaskKind.dailyLog => Icons.favorite_outline,
      DailyTaskKind.medication => Icons.medication_outlined,
      DailyTaskKind.messages => Icons.chat_bubble_outline,
      DailyTaskKind.expertRequest => Icons.person_add_alt_outlined,
      DailyTaskKind.urgentEvent => Icons.event_available_outlined,
      DailyTaskKind.notes => Icons.sticky_note_2_outlined,
      DailyTaskKind.community => Icons.groups_outlined,
      DailyTaskKind.calendar => Icons.event_outlined,
      DailyTaskKind.emergency => Icons.health_and_safety_outlined,
      DailyTaskKind.firstChild => Icons.child_care_outlined,
      DailyTaskKind.guide => Icons.menu_book_outlined,
      DailyTaskKind.experts => Icons.school_outlined,
    };

String _titleFor(Translations t, DailyTask task) => switch (task.kind) {
      DailyTaskKind.dailyLog =>
        task.done ? t.dailyPlan.taskDailyLogDone : t.dailyPlan.taskDailyLog,
      DailyTaskKind.medication => t.dailyPlan.taskMedication,
      DailyTaskKind.messages => t.dailyPlan.taskMessages,
      DailyTaskKind.expertRequest => t.dailyPlan.taskExpertRequest,
      // Etkinlik başlığı kullanıcı verisidir, çevrilmez.
      DailyTaskKind.urgentEvent =>
        task.label ?? t.dailyPlan.taskCalendarUpcoming,
      DailyTaskKind.notes =>
        task.done ? t.dailyPlan.taskNotesDone : t.dailyPlan.taskNotes,
      DailyTaskKind.community =>
        task.done ? t.dailyPlan.taskCommunityDone : t.dailyPlan.taskCommunity,
      DailyTaskKind.calendar =>
        task.done ? t.dailyPlan.taskCalendarUpcoming : t.dailyPlan.taskCalendar,
      DailyTaskKind.emergency => t.dailyPlan.taskEmergency,
      DailyTaskKind.firstChild => t.dailyPlan.taskFirstChild,
      DailyTaskKind.guide => t.dailyPlan.taskGuide,
      DailyTaskKind.experts => t.dailyPlan.taskExperts,
    };

String _detailFor(Translations t, DailyTask task) => switch (task.kind) {
      DailyTaskKind.dailyLog => task.done
          ? t.dailyPlan.taskDailyLogDoneDetail
          : t.dailyPlan.taskDailyLogDetail,
      DailyTaskKind.medication =>
        t.dailyPlan.taskMedicationDetail(count: task.count),
      DailyTaskKind.messages =>
        t.dailyPlan.taskMessagesDetail(count: task.count),
      DailyTaskKind.expertRequest =>
        t.dailyPlan.taskExpertRequestDetail(count: task.count),
      DailyTaskKind.urgentEvent => task.eventDetail(t),
      DailyTaskKind.notes => task.done
          ? t.dailyPlan.taskNotesDoneDetail(count: task.count)
          : t.dailyPlan.taskNotesDetail,
      DailyTaskKind.community => task.done
          ? t.dailyPlan.taskCommunityDoneDetail
          : t.dailyPlan.taskCommunityDetail,
      DailyTaskKind.calendar =>
        task.label ?? t.dailyPlan.taskCalendarDetail,
      DailyTaskKind.emergency => t.dailyPlan.taskEmergencyDetail,
      DailyTaskKind.firstChild => t.dailyPlan.taskFirstChildDetail,
      DailyTaskKind.guide => t.dailyPlan.taskGuideDetail,
      DailyTaskKind.experts => t.dailyPlan.taskExpertsDetail,
    };

String _badgeFor(Translations t, DailyTask task, int? stepNumber) {
  if (task.done) return t.dailyPlan.badgeDone;
  if (stepNumber == 1) return t.dailyPlan.badgeNow;
  if (stepNumber == 2) return t.dailyPlan.badgeNext;
  if (task.safety) return t.dailyPlan.badgeSafety;
  return t.dailyPlan.badgeOptional;
}

extension on DailyTask {
  /// Bugün/yarın etkinliğinin saat bilgisi (başlık veridir, saat metni i18n).
  String eventDetail(Translations t) {
    final start = eventStart;
    if (start == null) return t.dailyPlan.taskCalendarDetail;
    final hh = start.hour.toString().padLeft(2, '0');
    final mm = start.minute.toString().padLeft(2, '0');
    final time = '$hh:$mm';
    final isToday = localDateKey(start) == localDateKey(DateTime.now());
    return isToday
        ? t.dailyPlan.taskEventDetail(time: time)
        : t.dailyPlan.taskEventTomorrowDetail(time: time);
  }
}
