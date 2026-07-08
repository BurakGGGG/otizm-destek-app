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
import '../data/mood_repository.dart';
import '../domain/mood_entry.dart';

/// Günlük Takip — seçili çocuğun günlük ruh hali kayıtları (`/api/mood`).
class DailyTrackerScreen extends ConsumerStatefulWidget {
  const DailyTrackerScreen({super.key});

  @override
  ConsumerState<DailyTrackerScreen> createState() =>
      _DailyTrackerScreenState();
}

class _DailyTrackerScreenState extends ConsumerState<DailyTrackerScreen> {
  String? _selectedChildId;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final childrenAsync = ref.watch(childrenProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.dailyTracker.title)),
      body: SafeArea(
        child: childrenAsync.when(
          loading: () => const SkeletonList(count: 3),
          error: (e, _) =>
              ErrorRetry(onRetry: () => ref.invalidate(childrenProvider)),
          data: (children) {
            if (children.isEmpty) {
              return EmptyState(
                icon: Icons.child_care_outlined,
                message: t.dailyTracker.noChild,
                actionLabel: t.children.add,
                actionIcon: Icons.child_care_outlined,
                onAction: () => context.push('/children'),
              );
            }
            final childId = _selectedChildId ??= children.first.id;
            return Column(
              children: [
                if (children.length > 1)
                  _ChildSelector(
                    children: children,
                    selectedId: childId,
                    onSelect: (id) => setState(() => _selectedChildId = id),
                  ),
                Expanded(child: _TrackerBody(childId: childId)),
              ],
            );
          },
        ),
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
            horizontal: AppSpacing.margin, vertical: 8),
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

class _TrackerBody extends ConsumerWidget {
  const _TrackerBody({required this.childId});
  final String childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final async = ref.watch(moodEntriesProvider(childId));
    return async.when(
      loading: () => const SkeletonList(count: 3),
      error: (e, _) => ErrorRetry(
          onRetry: () => ref.invalidate(moodEntriesProvider(childId))),
      data: (entries) {
        final todayIso = _isoDate(DateTime.now());
        MoodEntry? today;
        for (final e in entries) {
          if (e.entryDate == todayIso) {
            today = e;
            break;
          }
        }
        final history =
            entries.where((e) => e.entryDate != todayIso).toList();
        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(moodEntriesProvider(childId)),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.margin, 4, AppSpacing.margin, 24),
            children: [
              _TodayCard(
                key: ValueKey('$childId:${today?.id ?? ''}'),
                childId: childId,
                entry: today,
              ),
              const SizedBox(height: 24),
              Text(t.dailyTracker.historyTitle,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              if (history.isEmpty && today == null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    t.dailyTracker.empty,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.colors.textTertiary),
                  ),
                )
              else
                for (final entry in history) ...[
                  _HistoryCard(childId: childId, entry: entry),
                  const SizedBox(height: 12),
                ],
            ],
          ),
        );
      },
    );
  }
}

String _isoDate(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// Bugünün ruh hali formu — mevcut kayıt varsa doldurur, kayıt upsert edilir.
class _TodayCard extends ConsumerStatefulWidget {
  const _TodayCard({super.key, required this.childId, this.entry});
  final String childId;
  final MoodEntry? entry;

  @override
  ConsumerState<_TodayCard> createState() => _TodayCardState();
}

class _TodayCardState extends ConsumerState<_TodayCard> {
  late int _level = widget.entry?.moodLevel ?? 0;
  late final Set<String> _triggers = {...?widget.entry?.triggers};
  late final TextEditingController _notes =
      TextEditingController(text: widget.entry?.notes ?? '');
  bool _saving = false;

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final t = context.t;
    if (_level == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.dailyTracker.errorSelectMood)));
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(moodRepositoryProvider).upsert(
            childId: widget.childId,
            entryDate: _isoDate(DateTime.now()),
            moodLevel: _level,
            notes: _notes.text,
            triggers: _triggers.toList(),
          );
      ref.invalidate(moodEntriesProvider(widget.childId));
      if (!mounted) return;
      Haptics.success();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.dailyTracker.saved)));
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final labels = [
      t.dailyTracker.mood1,
      t.dailyTracker.mood2,
      t.dailyTracker.mood3,
      t.dailyTracker.mood4,
      t.dailyTracker.mood5,
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
                  child: Text(t.dailyTracker.todayTitle,
                      style: Theme.of(context).textTheme.titleMedium),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: context.colors.primaryContainer,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    t.dailyTracker.today,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: context.colors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                for (var level = 1; level <= 5; level++) ...[
                  if (level > 1) const SizedBox(width: 8),
                  Expanded(
                    child: _MoodOption(
                      emoji: kMoodEmojis[level - 1],
                      label: labels[level - 1],
                      selected: _level == level,
                      onTap: () {
                        Haptics.selection();
                        setState(() => _level = level);
                      },
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            Text(t.dailyTracker.triggersLabel,
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final trigger in kMoodTriggers)
                  FilterChip(
                    label: Text(trigger),
                    selected: _triggers.contains(trigger),
                    onSelected: (sel) => setState(() =>
                        sel ? _triggers.add(trigger) : _triggers.remove(trigger)),
                    showCheckmark: false,
                    selectedColor: context.colors.primaryContainer,
                    backgroundColor: context.colors.surfaceVariant,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      color: _triggers.contains(trigger)
                          ? context.colors.primary
                          : context.colors.textSecondary,
                      fontWeight: _triggers.contains(trigger)
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                    side: BorderSide(
                      color: _triggers.contains(trigger)
                          ? context.colors.primary
                          : context.colors.border,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notes,
              minLines: 2,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: t.dailyTracker.notesLabel,
                hintText: t.dailyTracker.notesHint,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(widget.entry == null
                      ? t.dailyTracker.save
                      : t.dailyTracker.update),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoodOption extends StatelessWidget {
  const _MoodOption({
    required this.emoji,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? colors.primaryContainer : colors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: selected ? colors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color:
                    selected ? colors.primary : colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryCard extends ConsumerWidget {
  const _HistoryCard({required this.childId, required this.entry});
  final String childId;
  final MoodEntry entry;

  String _dateLine(BuildContext context) {
    final t = context.t;
    final d = entry.date;
    if (d == null) return entry.entryDate;
    return t.dailyTracker.dateLine(
      day: '${d.day}',
      month: t.common.monthsShort[d.month - 1],
      year: '${d.year}',
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final t = context.t;
    final dateLine = _dateLine(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.dailyTracker.deleteTitle),
        content: Text(t.dailyTracker.deleteConfirm(date: dateLine)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(t.dailyTracker.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(t.dailyTracker.delete),
          ),
        ],
      ),
    );
    if (ok != true) return;
    Haptics.warning();
    try {
      await ref.read(moodRepositoryProvider).delete(entry.id);
      ref.invalidate(moodEntriesProvider(childId));
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(t.dailyTracker.deleted)));
      }
    } on ApiException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final level = entry.moodLevel.clamp(1, 5);
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(kMoodEmojis[level - 1],
                    style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(_dateLine(context), style: text.titleSmall),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: Icon(Icons.delete_outline,
                      size: 20, color: context.colors.textTertiary),
                  onPressed: () => _delete(context, ref),
                ),
              ],
            ),
            if (entry.triggers.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final trigger in entry.triggers)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: context.colors.surfaceVariant,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Text(
                        trigger,
                        style: TextStyle(
                          fontSize: 11,
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ),
                ],
              ),
            ],
            if (entry.notes?.isNotEmpty ?? false) ...[
              const SizedBox(height: 8),
              Text(
                entry.notes!,
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
