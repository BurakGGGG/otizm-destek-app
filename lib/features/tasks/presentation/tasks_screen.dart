import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/network/media.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../i18n/strings.g.dart';
import '../../auth/presentation/auth_controller.dart';
import '../data/tasks_repository.dart';
import '../domain/expert_task.dart';
import 'widgets/task_submit_sheet.dart';

/// Ödevlerim — uzmanın veliye atadığı görevler (web `/gorevler` birebir).
/// Bekleyen/tamamlanan filtreleri, son tarih uyarısı, teslim (not + kanıt
/// bağlantısı) ve uzman geri bildirimi görünümü.
class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

enum _TaskFilter { all, pending, completed }

class _TasksScreenState extends ConsumerState<TasksScreen> {
  _TaskFilter _filter = _TaskFilter.all;

  Future<void> _openSubmitSheet(ExpertTask task) async {
    final t = context.t;
    final parentId = ref.read(authControllerProvider).user?.id;
    if (parentId == null) return;
    final submitted = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => TaskSubmitSheet(task: task, parentId: parentId),
    );
    if (submitted == true && mounted) {
      ref.invalidate(myTasksProvider);
      ref.invalidate(taskSubmissionsProvider(task.id));
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.tasks.submitted)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final async = ref.watch(myTasksProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.tasks.title)),
      body: SafeArea(
        child: async.when(
          loading: () => const SkeletonList(count: 4),
          error: (e, _) =>
              ErrorRetry(onRetry: () => ref.invalidate(myTasksProvider)),
          data: (tasks) {
            final sorted = sortTasksForDisplay(tasks);
            final pending = sorted.where((x) => x.isPending).length;
            final completed = sorted.where((x) => x.isCompleted).length;
            final overdue = sorted.where((x) => x.isOverdue).length;
            final displayed = switch (_filter) {
              _TaskFilter.all => sorted,
              _TaskFilter.pending =>
                sorted.where((x) => x.isPending).toList(),
              _TaskFilter.completed =>
                sorted.where((x) => x.isCompleted).toList(),
            };

            return RefreshIndicator(
              onRefresh: () async => ref.invalidate(myTasksProvider),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.margin,
                  AppSpacing.md,
                  AppSpacing.margin,
                  40,
                ),
                children: [
                  _SummaryCard(
                    pending: pending,
                    completed: completed,
                    overdue: overdue,
                    total: sorted.length,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _FilterChips(
                    filter: _filter,
                    all: sorted.length,
                    pending: pending,
                    completed: completed,
                    onChanged: (f) => setState(() => _filter = f),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (displayed.isEmpty)
                    SizedBox(
                      height: 300,
                      child: EmptyState(
                        icon: Icons.assignment_outlined,
                        message: switch (_filter) {
                          _TaskFilter.all => t.tasks.emptyAll,
                          _TaskFilter.pending => t.tasks.emptyPending,
                          _TaskFilter.completed => t.tasks.emptyCompleted,
                        },
                      ),
                    )
                  else
                    for (final task in displayed) ...[
                      _TaskCard(
                        key: ValueKey(task.id),
                        task: task,
                        onSubmit: () => _openSubmitSheet(task),
                      ),
                      const SizedBox(height: 12),
                    ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Başlık kartı: bekleyen/tamamlanan sayaçları + ilerleme çubuğu + gecikme uyarısı.
class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.pending,
    required this.completed,
    required this.overdue,
    required this.total,
  });

  final int pending;
  final int completed;
  final int overdue;
  final int total;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final percent = total > 0 ? (completed / total) : 0.0;

    return Container(
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
              Icon(Icons.assignment_turned_in_outlined,
                  color: colors.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  t.tasks.subtitle,
                  style: text.bodySmall
                      ?.copyWith(color: colors.textSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  value: '$pending',
                  label: t.tasks.pendingLabel,
                  color: colors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatBox(
                  value: '$completed',
                  label: t.tasks.completedLabel,
                  color: colors.success,
                ),
              ),
            ],
          ),
          if (total > 0) ...[
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t.tasks.progressLabel,
                  style: text.labelSmall
                      ?.copyWith(color: colors.textSecondary),
                ),
                Text(
                  '${(percent * 100).round()}%',
                  style: text.labelMedium?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.full),
              child: LinearProgressIndicator(
                value: percent,
                minHeight: 8,
                backgroundColor: colors.surfaceVariant,
              ),
            ),
          ],
          if (overdue > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: colors.error.withValues(alpha: .08),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, size: 16, color: colors.error),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      t.tasks.overdueSummary(count: overdue),
                      style: text.labelSmall?.copyWith(
                        color: colors.error,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: text.titleLarge
                ?.copyWith(color: color, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: text.labelSmall?.copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({
    required this.filter,
    required this.all,
    required this.pending,
    required this.completed,
    required this.onChanged,
  });

  final _TaskFilter filter;
  final int all;
  final int pending;
  final int completed;
  final ValueChanged<_TaskFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final (f, label) in [
            (_TaskFilter.all, t.tasks.filterAll(count: all)),
            (_TaskFilter.pending, t.tasks.filterPending(count: pending)),
            (
              _TaskFilter.completed,
              t.tasks.filterCompleted(count: completed)
            ),
          ]) ...[
            ChoiceChip(
              label: Text(label),
              selected: filter == f,
              onSelected: (_) => onChanged(f),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

/// Tek görev kartı — dokununca genişler; bekleyense teslim butonu, teslim
/// edildiyse teslim kaydı + uzman geri bildirimi gösterilir.
class _TaskCard extends ConsumerStatefulWidget {
  const _TaskCard({super.key, required this.task, required this.onSubmit});

  final ExpertTask task;
  final VoidCallback onSubmit;

  @override
  ConsumerState<_TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends ConsumerState<_TaskCard> {
  bool _expanded = false;

  Future<void> _openMaterial(String url) async {
    // Backend'den gelen dosya adresleri göreli olabiliyor (`/api/upload/...`).
    final uri = Uri.tryParse(absoluteMediaUrl(url) ?? url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  String _difficultyLabel(Translations t, String code) {
    return switch (code) {
      'EASY' => t.tasks.difficultyEasy,
      'MEDIUM' => t.tasks.difficultyMedium,
      'HARD' => t.tasks.difficultyHard,
      _ => code,
    };
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final task = widget.task;
    final done = task.isCompleted;
    final overdue = task.isOverdue;
    final due = task.dueDate;
    final difficulty = task.difficulty;
    final borderColor = done
        ? colors.success.withValues(alpha: .45)
        : overdue
            ? colors.error.withValues(alpha: .55)
            : colors.border;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: borderColor),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: () => setState(() => _expanded = !_expanded),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (overdue) ...[
                Row(
                  children: [
                    Icon(Icons.error_outline, size: 14, color: colors.error),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        t.tasks.overdueBanner,
                        style: text.labelSmall?.copyWith(
                          color: colors.error,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    done
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: done ? colors.success : colors.textTertiary,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      task.title,
                      style: text.titleSmall?.copyWith(
                        decoration:
                            done ? TextDecoration.lineThrough : null,
                        color: done
                            ? colors.textTertiary
                            : colors.textPrimary,
                      ),
                    ),
                  ),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: colors.textTertiary,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  if (task.category case final category?)
                    _TagChip(label: category, color: colors.secondary),
                  if (difficulty != null)
                    _TagChip(
                      label: _difficultyLabel(t, difficulty),
                      color: switch (difficulty) {
                        'EASY' => colors.success,
                        'HARD' => colors.error,
                        _ => colors.warning,
                      },
                    ),
                  if (task.frequency case final frequency?)
                    _TagChip(label: frequency, color: colors.textSecondary),
                  if (due != null)
                    _TagChip(
                      label: t.tasks.dueLabel(
                        date:
                            '${due.day.toString().padLeft(2, '0')}.${due.month.toString().padLeft(2, '0')}.${due.year}',
                      ),
                      color:
                          overdue ? colors.error : colors.textSecondary,
                    ),
                ],
              ),
              if (_expanded) ...[
                const SizedBox(height: 12),
                if (task.description case final description?
                    when description.trim().isNotEmpty) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.surfaceVariant,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.tasks.detailLabel,
                          style: text.labelSmall?.copyWith(
                            color: colors.textTertiary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(description, style: text.bodySmall),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                if (task.materialUrl case final materialUrl?
                    when materialUrl.trim().isNotEmpty) ...[
                  OutlinedButton.icon(
                    onPressed: () => _openMaterial(materialUrl),
                    icon: const Icon(Icons.open_in_new, size: 16),
                    label: Text(t.tasks.openMaterial),
                  ),
                  const SizedBox(height: 10),
                ],
                if (!done)
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: widget.onSubmit,
                      icon: const Icon(Icons.check_circle_outline, size: 18),
                      label: Text(t.tasks.submitTask),
                    ),
                  )
                else
                  _SubmissionSection(taskId: task.id),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

/// Tamamlanan görevin teslim kaydı: veli notu + kanıt bağlantısı ve uzman
/// geri bildirimi (yoksa "değerlendirme bekleniyor").
class _SubmissionSection extends ConsumerWidget {
  const _SubmissionSection({required this.taskId});

  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final async = ref.watch(taskSubmissionsProvider(taskId));

    return async.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(12),
        child: Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      error: (e, _) => Text(
        t.tasks.submissionsError,
        style: text.bodySmall?.copyWith(color: colors.textTertiary),
      ),
      data: (submissions) {
        if (submissions.isEmpty) {
          return Text(
            t.tasks.noSubmission,
            style: text.bodySmall?.copyWith(color: colors.textTertiary),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final sub in submissions) ...[
              if ((sub.parentNote ?? '').isNotEmpty ||
                  (sub.evidenceUrl ?? '').isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.tasks.yourNote,
                        style: text.labelSmall?.copyWith(
                          color: colors.textTertiary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (sub.parentNote case final note?
                          when note.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(note, style: text.bodySmall),
                      ],
                      if (sub.evidenceUrl case final evidence?
                          when evidence.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        InkWell(
                          onTap: () async {
                            final uri = Uri.tryParse(
                              absoluteMediaUrl(evidence) ?? evidence,
                            );
                            if (uri != null) {
                              await launchUrl(uri,
                                  mode: LaunchMode.externalApplication);
                            }
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.link,
                                  size: 14, color: colors.primary),
                              const SizedBox(width: 4),
                              Text(
                                t.tasks.evidenceLink,
                                style: text.labelSmall?.copyWith(
                                  color: colors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
              if (sub.expertReviewed)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.success.withValues(alpha: .08),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.verified_outlined,
                              size: 14, color: colors.success),
                          const SizedBox(width: 4),
                          Text(
                            t.tasks.expertFeedback,
                            style: text.labelSmall?.copyWith(
                              color: colors.success,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        (sub.expertFeedback ?? '').isNotEmpty
                            ? sub.expertFeedback!
                            : t.tasks.expertApprovedNoNote,
                        style: text.bodySmall,
                      ),
                    ],
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: colors.warning.withValues(alpha: .10),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.schedule, size: 14, color: colors.warning),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          t.tasks.awaitingReview,
                          style: text.labelSmall?.copyWith(
                            color: colors.warning,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
            ],
          ],
        );
      },
    );
  }
}
