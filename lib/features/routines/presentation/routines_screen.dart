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
import '../data/routine_progress_controller.dart';
import '../data/routine_repository.dart';
import '../domain/routine.dart';
import '../domain/routine_icons.dart';
import 'routine_form_screen.dart';

/// Rutinler — seçili çocuğun görsel programları (`/api/routines`).
class RoutinesScreen extends ConsumerStatefulWidget {
  const RoutinesScreen({super.key});

  @override
  ConsumerState<RoutinesScreen> createState() => _RoutinesScreenState();
}

class _RoutinesScreenState extends ConsumerState<RoutinesScreen> {
  String? _selectedChildId;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final childrenAsync = ref.watch(childrenProvider);

    final stars = ref.watch(routineProgressProvider).stars;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.routines.title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: Center(child: _StarWallet(stars: stars)),
          ),
        ],
      ),
      body: SafeArea(
        child: childrenAsync.when(
          loading: () => const SkeletonList(count: 3),
          error: (e, _) =>
              ErrorRetry(onRetry: () => ref.invalidate(childrenProvider)),
          data: (children) {
            if (children.isEmpty) {
              return EmptyState(
                icon: Icons.child_care_outlined,
                message: t.routines.noChild,
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
                Expanded(child: _RoutinesList(childId: childId)),
              ],
            );
          },
        ),
      ),
      floatingActionButton: _selectedChildId == null
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _addRoutine(_selectedChildId!),
              icon: const Icon(Icons.add),
              label: Text(t.routines.add),
            ),
    );
  }

  Future<void> _addRoutine(String childId) async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => RoutineFormScreen(childId: childId)),
    );
    if (result != null && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result)));
    }
  }
}

/// Toplanan yıldızlar (web'deki "Yıldız Cüzdanı").
class _StarWallet extends StatelessWidget {
  const _StarWallet({required this.stars});

  final int stars;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: colors.warning.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 16, color: colors.warning),
          const SizedBox(width: 4),
          Text(
            context.t.routines.starWallet(count: '$stars'),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
          ),
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

class _RoutinesList extends ConsumerWidget {
  const _RoutinesList({required this.childId});
  final String childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final async = ref.watch(routinesProvider(childId));
    return async.when(
      loading: () => const SkeletonList(count: 3),
      error: (e, _) =>
          ErrorRetry(onRetry: () => ref.invalidate(routinesProvider(childId))),
      data: (routines) {
        if (routines.isEmpty) {
          return EmptyState(
            icon: Icons.checklist_outlined,
            message: t.routines.empty,
          );
        }
        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(routinesProvider(childId)),
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.margin, 4, AppSpacing.margin, 96),
            itemCount: routines.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, i) =>
                _RoutineCard(childId: childId, routine: routines[i]),
          ),
        );
      },
    );
  }
}

class _RoutineCard extends ConsumerWidget {
  const _RoutineCard({required this.childId, required this.routine});
  final String childId;
  final Routine routine;

  Future<void> _toggle(WidgetRef ref, BuildContext context, String id) async {
    final done = await ref
        .read(routineProgressProvider.notifier)
        .toggle(routine.id, id);
    if (!done || !context.mounted) return;
    Haptics.success();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(context.t.routines.stepDone),
        duration: const Duration(seconds: 2),
      ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final progress = ref.watch(routineProgressProvider);
    final percent = progress.percentOf(routine.id, routine.items.length);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(routine.name, style: text.titleMedium),
                      if (routine.description?.isNotEmpty ?? false)
                        Text(
                          routine.description!,
                          style: text.bodySmall
                              ?.copyWith(color: context.colors.textSecondary),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: t.routines.deleteRoutineTitle,
                  icon: const Icon(Icons.delete_outline,
                      size: 20, color: AppColors.error),
                  onPressed: () => _deleteRoutine(context, ref),
                ),
              ],
            ),
            if (routine.items.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      child: LinearProgressIndicator(
                        value: percent / 100,
                        minHeight: 6,
                        backgroundColor: context.colors.surfaceVariant,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          context.colors.success,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    t.routines.progressDone(percent: '$percent'),
                    style: text.labelSmall
                        ?.copyWith(color: context.colors.textSecondary),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 8),
            if (routine.items.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(t.routines.noItems,
                    style: text.bodySmall
                        ?.copyWith(color: context.colors.textTertiary)),
              )
            else
              for (final item in routine.items)
                _ItemRow(
                  item: item,
                  done: progress.isDone(routine.id, item.id),
                  onToggle: () => _toggle(ref, context, item.id),
                  onDelete: () => _deleteItem(context, ref, item),
                ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => _addItem(context, ref),
                icon: const Icon(Icons.add, size: 18),
                label: Text(t.routines.addItem),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addItem(BuildContext context, WidgetRef ref) async {
    final result = await showModalBottomSheet<_NewItem>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _AddItemSheet(),
    );
    if (result == null) return;
    try {
      await ref.read(routineRepositoryProvider).addItem(
            routine.id,
            title: result.title,
            scheduledTime: result.time,
            iconName: result.iconName,
          );
      ref.invalidate(routinesProvider(childId));
      if (context.mounted) {
        Haptics.success();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(context.t.routines.itemAdded)));
      }
    } on ApiException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  Future<void> _deleteItem(
      BuildContext context, WidgetRef ref, RoutineItem item) async {
    try {
      await ref.read(routineRepositoryProvider).deleteItem(routine.id, item.id);
      ref.invalidate(routinesProvider(childId));
    } on ApiException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  Future<void> _deleteRoutine(BuildContext context, WidgetRef ref) async {
    final t = context.t;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.routines.deleteRoutineTitle),
        content: Text(t.routines.deleteRoutineConfirm(name: routine.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(t.routines.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(t.routines.delete),
          ),
        ],
      ),
    );
    if (ok != true) return;
    Haptics.warning();
    try {
      await ref.read(routineRepositoryProvider).deleteRoutine(routine.id);
      ref.invalidate(routinesProvider(childId));
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(t.routines.deleted)));
      }
    } on ApiException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }
}

/// Rutin adımı — dokununca bugün için tamamlandı işaretlenir (cihazda).
class _ItemRow extends StatelessWidget {
  const _ItemRow({
    required this.item,
    required this.done,
    required this.onToggle,
    required this.onDelete,
  });
  final RoutineItem item;
  final bool done;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final colors = context.colors;
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: done
                  ? colors.success.withValues(alpha: 0.16)
                  : colors.primary.withValues(alpha: 0.12),
              child: Icon(
                done ? Icons.check_rounded : routineIconFor(item.iconName),
                size: 18,
                color: done ? colors.success : colors.primary,
              ),
            ),
            const SizedBox(width: 12),
            if (item.scheduledTime?.isNotEmpty ?? false) ...[
              Text(item.scheduledTime!,
                  style: text.labelMedium?.copyWith(color: colors.primary)),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: done
                    ? TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: colors.textTertiary,
                      )
                    : null,
              ),
            ),
            IconButton(
              tooltip: context.t.common.a11y.delete,
              visualDensity: VisualDensity.compact,
              icon: Icon(Icons.close, size: 18, color: colors.textTertiary),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

/// Adım ekleme sonucu.
class _NewItem {
  const _NewItem({required this.title, this.time, this.iconName});
  final String title;
  final String? time;
  final String? iconName;
}

class _AddItemSheet extends StatefulWidget {
  const _AddItemSheet();

  @override
  State<_AddItemSheet> createState() => _AddItemSheetState();
}

class _AddItemSheetState extends State<_AddItemSheet> {
  final _title = TextEditingController();
  TimeOfDay? _time;
  String? _iconName;
  String? _error;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  String? get _timeString => _time == null
      ? null
      : '${_time!.hour.toString().padLeft(2, '0')}:${_time!.minute.toString().padLeft(2, '0')}';

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? const TimeOfDay(hour: 8, minute: 0),
    );
    if (picked != null) setState(() => _time = picked);
  }

  void _submit() {
    final t = context.t;
    if (_title.text.trim().isEmpty) {
      setState(() => _error = t.routines.errorItemTitle);
      return;
    }
    Navigator.of(context).pop(_NewItem(
      title: _title.text.trim(),
      time: _timeString,
      iconName: _iconName,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.margin,
        right: AppSpacing.margin,
        top: AppSpacing.lg,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(t.routines.addItem,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          TextField(
            controller: _title,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: t.routines.itemTitleLabel,
              hintText: t.routines.itemTitleHint,
              errorText: _error,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _pickTime,
            icon: const Icon(Icons.schedule, size: 18),
            label: Text(_timeString ?? t.routines.selectTime),
          ),
          const SizedBox(height: 16),
          Text(t.routines.itemIconLabel,
              style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final entry in kRoutineIcons.entries)
                _IconChoice(
                  icon: entry.value,
                  selected: _iconName == entry.key,
                  onTap: () => setState(() =>
                      _iconName = _iconName == entry.key ? null : entry.key),
                ),
            ],
          ),
          const SizedBox(height: 20),
          FilledButton(onPressed: _submit, child: Text(t.routines.itemSave)),
        ],
      ),
    );
  }
}

class _IconChoice extends StatelessWidget {
  const _IconChoice({
    required this.icon,
    required this.selected,
    required this.onTap,
  });
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colors.primary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: selected
              ? color.withValues(alpha: 0.16)
              : context.colors.surfaceVariant,
          shape: BoxShape.circle,
          border: selected ? Border.all(color: color, width: 2) : null,
        ),
        child: Icon(icon,
            size: 22, color: selected ? color : context.colors.textSecondary),
      ),
    );
  }
}
