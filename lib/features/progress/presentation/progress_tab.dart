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
import '../../children/data/child_repository.dart';
import '../../children/domain/child.dart';
import '../../goals/data/goal_repository.dart';
import '../../goals/domain/goal.dart';
import '../../goals/presentation/goal_form_screen.dart';
import '../../notes/data/note_repository.dart';
import '../../notes/domain/development_note.dart';
import '../../notes/presentation/note_form_screen.dart';
import '../../notes/presentation/notes_screen.dart';

/// Gelişim sekmesi — seçili çocuğun hedefleri (`/api/goals`) ve son gelişim
/// notları (`/api/notes`).
class ProgressTab extends ConsumerStatefulWidget {
  const ProgressTab({super.key});

  @override
  ConsumerState<ProgressTab> createState() => _ProgressTabState();
}

class _ProgressTabState extends ConsumerState<ProgressTab> {
  String? _selectedChildId;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final childrenAsync = ref.watch(childrenProvider);

    return SafeArea(
      child: childrenAsync.when(
        loading: () => const SkeletonList(count: 4),
        error: (e, _) =>
            ErrorRetry(onRetry: () => ref.invalidate(childrenProvider)),
        data: (children) {
          if (children.isEmpty) {
            return EmptyState(
              icon: Icons.child_care_outlined,
              message: t.progress.noChild,
              actionLabel: t.children.add,
              actionIcon: Icons.child_care_outlined,
              onAction: () => context.push('/children'),
            );
          }
          final selectedId = _selectedChildId ??= children.first.id;

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(goalsProvider(selectedId));
              ref.invalidate(recentNotesProvider(selectedId));
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.margin,
                8,
                AppSpacing.margin,
                24,
              ),
              children: [
                Text(t.progress.title, style: text.headlineLarge),
                const SizedBox(height: 4),
                Text(t.progress.subtitle, style: text.bodySmall),
                const SizedBox(height: 16),
                if (children.length > 1) ...[
                  _ChildSelector(
                    children: children,
                    selectedId: selectedId,
                    onSelect: (id) => setState(() => _selectedChildId = id),
                  ),
                  const SizedBox(height: 16),
                ],
                const _QuickLinks(),
                const SizedBox(height: 20),
                _GoalsSection(childId: selectedId),
                const SizedBox(height: 24),
                _NotesSection(childId: selectedId),
              ],
            ),
          );
        },
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
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: children.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final c = children[i];
          final selected = c.id == selectedId;
          return ChoiceChip(
            label: Text(c.name),
            selected: selected,
            onSelected: (_) => onSelect(c.id),
            showCheckmark: false,
            selectedColor: context.colors.primary,
            backgroundColor: context.colors.surface,
            side: BorderSide(color: context.colors.border),
            labelStyle: TextStyle(
              color: selected ? Colors.white : context.colors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          );
        },
      ),
    );
  }
}

/// Form ekranını açar; başarıyla dönerse (mesaj) SnackBar gösterir.
/// İlgili provider form içinde invalidate edilir.
Future<void> _openForm(BuildContext context, Widget form) async {
  final result = await Navigator.of(
    context,
  ).push<String>(MaterialPageRoute(builder: (_) => form));
  if (result != null && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
  }
}

/// Günlük Takip ve Gelişim Paneli kısayolları.
class _QuickLinks extends StatelessWidget {
  const _QuickLinks();

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Column(
      children: [
        // İki kart aynı yükseklikte dursun: etiketi iki satıra sığan kart
        // (ör. "Gelişim Paneli") diğerini de büyütür. Satırın yüksekliği
        // yukarıdan sınırlı olmadığı için stretch tek başına yetmiyor.
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _QuickLinkCard(
                  icon: Icons.mood_outlined,
                  label: t.dailyTracker.title,
                  onTap: () => context.push('/daily-tracker'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickLinkCard(
                  icon: Icons.insights_outlined,
                  label: t.analytics.title,
                  onTap: () => context.push('/analytics'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _QuickLinkCard(
          icon: Icons.psychology_outlined,
          label: t.behavior.title,
          onTap: () => context.push('/behavior'),
        ),
      ],
    );
  }
}

class _QuickLinkCard extends StatelessWidget {
  const _QuickLinkCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icon, size: 22, color: context.colors.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right,
                  size: 18, color: context.colors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Hedefler
// ---------------------------------------------------------------------------
class _GoalsSection extends ConsumerWidget {
  const _GoalsSection({required this.childId});
  final String childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(t.progress.goalsTitle, style: text.titleMedium),
            ),
            TextButton.icon(
              onPressed: () =>
                  _openForm(context, GoalFormScreen(childId: childId)),
              icon: const Icon(Icons.add, size: 18),
              label: Text(t.progress.addGoal),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ref
            .watch(goalsProvider(childId))
            .when(
              loading: () => const _SectionLoading(),
              error: (e, _) => _SectionError(
                onRetry: () => ref.invalidate(goalsProvider(childId)),
              ),
              data: (goals) {
                if (goals.isEmpty) {
                  return _EmptyCard(
                    message: t.progress.noGoals,
                    icon: Icons.flag_outlined,
                  );
                }
                return Column(
                  children: [
                    for (final g in goals) ...[
                      _GoalCard(childId: childId, goal: g),
                      const SizedBox(height: 12),
                    ],
                  ],
                );
              },
            ),
      ],
    );
  }
}

class _GoalCard extends ConsumerStatefulWidget {
  const _GoalCard({required this.childId, required this.goal});
  final String childId;
  final Goal goal;

  @override
  ConsumerState<_GoalCard> createState() => _GoalCardState();
}

class _GoalCardState extends ConsumerState<_GoalCard> {
  bool _busy = false;

  Future<void> _mutate(Future<Goal> Function(GoalRepository) op) async {
    final t = context.t;
    setState(() => _busy = true);
    try {
      final updated = await op(ref.read(goalRepositoryProvider));
      ref.invalidate(goalsProvider(widget.childId));
      if (!mounted) return;
      final grew = updated.doneCount > widget.goal.doneCount;
      if (grew) {
        Haptics.success();
      } else {
        Haptics.selection();
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(updated.completed && grew
            ? t.progress.goalCompleted
            : grew
                ? t.progress.tokenAdded
                : t.progress.tokenRemoved),
      ));
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final goal = widget.goal;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  goal.tokenEmoji ?? '⭐',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(goal.title, style: text.titleMedium)),
                Text(
                  t.progress.goalProgress(
                    done: goal.doneCount.toString(),
                    total: goal.targetCount.toString(),
                  ),
                  style: text.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.full),
              child: LinearProgressIndicator(
                value: goal.progress,
                minHeight: 8,
                backgroundColor: context.colors.surfaceVariant,
                color: goal.completed
                    ? context.colors.success
                    : context.colors.primary,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                if (goal.category?.isNotEmpty ?? false)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: context.colors.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Text(
                      goal.category!,
                      style: TextStyle(
                        color: context.colors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const Spacer(),
                if (goal.doneCount > 0 && !goal.completed)
                  IconButton(
                    tooltip: t.progress.tokenRemoved,
                    visualDensity: VisualDensity.compact,
                    icon: Icon(Icons.undo,
                        size: 18, color: context.colors.textTertiary),
                    onPressed: _busy
                        ? null
                        : () => _mutate((repo) =>
                            repo.removeLastToken(goal)),
                  ),
                if (goal.completed)
                  Row(
                    children: [
                      Icon(Icons.check_circle,
                          size: 18, color: context.colors.success),
                      const SizedBox(width: 6),
                      Text(
                        t.progress.goalCompleted,
                        style: TextStyle(
                          color: context.colors.success,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                else
                  FilledButton.tonalIcon(
                    style: AppButtonStyles.inlineTonal(context),
                    onPressed: _busy
                        ? null
                        : () => _mutate((repo) => repo.addToken(goal)),
                    icon: _busy
                        ? const SizedBox(
                            height: 14,
                            width: 14,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.add, size: 18),
                    label: Text(t.progress.addToken),
                  ),
              ],
            ),
            if (goal.completed && (goal.rewardTitle?.isNotEmpty ?? false)) ...[
              const SizedBox(height: 6),
              Text(
                t.progress.rewardLine(title: goal.rewardTitle!),
                style: text.bodySmall
                    ?.copyWith(color: context.colors.textSecondary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Notlar
// ---------------------------------------------------------------------------
class _NotesSection extends ConsumerWidget {
  const _NotesSection({required this.childId});
  final String childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(t.progress.recentNotes, style: text.titleMedium),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => NotesScreen(initialChildId: childId),
                ),
              ),
              child: Text(t.common.seeAll),
            ),
            IconButton(
              tooltip: t.progress.addNote,
              onPressed: () =>
                  _openForm(context, NoteFormScreen(childId: childId)),
              icon: const Icon(Icons.add, size: 20),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ref
            .watch(recentNotesProvider(childId))
            .when(
              loading: () => const _SectionLoading(),
              error: (e, _) => _SectionError(
                onRetry: () => ref.invalidate(recentNotesProvider(childId)),
              ),
              data: (notes) {
                if (notes.isEmpty) {
                  return _EmptyCard(
                    message: t.progress.noNotes,
                    icon: Icons.note_outlined,
                  );
                }
                return Column(
                  children: [
                    for (final n in notes) ...[
                      _NoteCard(note: n),
                      const SizedBox(height: 12),
                    ],
                  ],
                );
              },
            ),
      ],
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.note});
  final DevelopmentNote note;

  @override
  Widget build(BuildContext context) {
    final mood = noteMoodDisplay(context.t, note.mood);
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final date = note.noteDate;
    final dateLabel = date == null
        ? ''
        : '${date.day} ${t.common.monthsShort[date.month - 1]}';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(note.title, style: text.titleMedium)),
                if (dateLabel.isNotEmpty)
                  Text(dateLabel, style: text.bodySmall),
              ],
            ),
            if (note.content?.isNotEmpty ?? false) ...[
              const SizedBox(height: 4),
              Text(
                note.content!,
                style: text.bodySmall,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if ((note.category?.isNotEmpty ?? false) || mood != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  if (note.category?.isNotEmpty ?? false)
                    Text(
                      note.category!,
                      style: TextStyle(
                        color: context.colors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  const Spacer(),
                  // Ruh hâli kodu (happy/neutral/sad) veridir; ekranda
                  // emoji + yerelleştirilmiş etiketle gösterilir.
                  if (mood != null)
                    Text(
                      '${mood.emoji} ${mood.label}',
                      style: text.bodySmall,
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Ortak durum bileşenleri
// ---------------------------------------------------------------------------
class _SectionLoading extends StatelessWidget {
  const _SectionLoading();

  @override
  Widget build(BuildContext context) {
    return const SkeletonList(count: 2, padding: EdgeInsets.zero);
  }
}

class _SectionError extends StatelessWidget {
  const _SectionError({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: context.colors.error),
            const SizedBox(width: 12),
            Expanded(child: Text(t.common.loadError)),
            TextButton(onPressed: onRetry, child: Text(t.common.retry)),
          ],
        ),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.message, required this.icon});
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Icon(icon, color: context.colors.textTertiary),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }
}
