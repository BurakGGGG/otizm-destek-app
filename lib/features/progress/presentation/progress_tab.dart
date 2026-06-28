import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
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
            _ErrorView(onRetry: () => ref.invalidate(childrenProvider)),
        data: (children) {
          if (children.isEmpty) {
            return _EmptyView(message: t.progress.noChild);
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
            selectedColor: AppColors.primary,
            backgroundColor: AppColors.surface,
            side: const BorderSide(color: AppColors.border),
            labelStyle: TextStyle(
              color: selected ? Colors.white : AppColors.textSecondary,
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
                      _GoalCard(goal: g),
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

class _GoalCard extends StatelessWidget {
  const _GoalCard({required this.goal});
  final Goal goal;

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
                backgroundColor: AppColors.surfaceVariant,
                color: AppColors.primary,
              ),
            ),
            if (goal.category?.isNotEmpty ?? false) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  goal.category!,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
            TextButton.icon(
              onPressed: () =>
                  _openForm(context, NoteFormScreen(childId: childId)),
              icon: const Icon(Icons.add, size: 18),
              label: Text(t.progress.addNote),
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
            if ((note.category?.isNotEmpty ?? false) ||
                (note.mood?.isNotEmpty ?? false)) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  if (note.category?.isNotEmpty ?? false)
                    Text(
                      note.category!,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  const Spacer(),
                  if (note.mood?.isNotEmpty ?? false)
                    Text(note.mood!, style: text.bodySmall),
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
            const Icon(Icons.error_outline, color: AppColors.error),
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
            Icon(icon, color: AppColors.textTertiary),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const SizedBox(height: 12),
          Text(t.common.loadError),
          const SizedBox(height: 12),
          FilledButton.tonal(onPressed: onRetry, child: Text(t.common.retry)),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.child_care_outlined,
              size: 48,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
