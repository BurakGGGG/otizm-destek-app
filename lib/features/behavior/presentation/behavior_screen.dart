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
import '../data/abc_repository.dart';
import '../domain/abc_entry.dart';

/// Davranış Günlüğü — ABC (Öncesi-Davranış-Sonuç) kayıtları (`/api/abc-entries`).
class BehaviorScreen extends ConsumerStatefulWidget {
  const BehaviorScreen({super.key});

  @override
  ConsumerState<BehaviorScreen> createState() => _BehaviorScreenState();
}

class _BehaviorScreenState extends ConsumerState<BehaviorScreen> {
  String? _selectedChildId;

  Future<void> _addEntry(String childId) async {
    final t = context.t;
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _AbcFormSheet(childId: childId),
    );
    if (saved == true && mounted) {
      ref.invalidate(abcEntriesProvider(childId));
      Haptics.success();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.behavior.saved)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final childrenAsync = ref.watch(childrenProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.behavior.title)),
      body: SafeArea(
        child: childrenAsync.when(
          loading: () => const SkeletonList(count: 3),
          error: (e, _) =>
              ErrorRetry(onRetry: () => ref.invalidate(childrenProvider)),
          data: (children) {
            if (children.isEmpty) {
              return EmptyState(
                icon: Icons.child_care_outlined,
                message: t.behavior.noChild,
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
                Expanded(child: _EntriesBody(childId: childId)),
              ],
            );
          },
        ),
      ),
      floatingActionButton: childrenAsync.maybeWhen(
        data: (children) => children.isEmpty
            ? null
            : FloatingActionButton.extended(
                onPressed: () => _addEntry(_selectedChildId ?? children.first.id),
                icon: const Icon(Icons.add),
                label: Text(t.behavior.add),
              ),
        orElse: () => null,
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

class _EntriesBody extends ConsumerWidget {
  const _EntriesBody({required this.childId});
  final String childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final async = ref.watch(abcEntriesProvider(childId));
    return async.when(
      loading: () => const SkeletonList(count: 3),
      error: (e, _) => ErrorRetry(
          onRetry: () => ref.invalidate(abcEntriesProvider(childId))),
      data: (entries) {
        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(abcEntriesProvider(childId)),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.margin, 4, AppSpacing.margin, 96),
            children: [
              Text(
                t.behavior.subtitle,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: context.colors.textTertiary),
              ),
              const SizedBox(height: 12),
              if (entries.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    t.behavior.empty,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.colors.textTertiary),
                  ),
                )
              else
                for (final entry in entries) ...[
                  _EntryCard(childId: childId, entry: entry),
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

String _formatTimeOfDay(TimeOfDay t) =>
    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

String _intensityLabel(BuildContext context, int level) {
  final t = context.t;
  switch (level) {
    case 1:
      return t.behavior.intensity1;
    case 2:
      return t.behavior.intensity2;
    case 3:
      return t.behavior.intensity3;
    case 4:
      return t.behavior.intensity4;
    default:
      return t.behavior.intensity5;
  }
}

Color _intensityColor(BuildContext context, int level) {
  final colors = context.colors;
  if (level <= 2) return colors.success;
  if (level == 3) return colors.warning;
  return colors.error;
}

class _EntryCard extends ConsumerWidget {
  const _EntryCard({required this.childId, required this.entry});
  final String childId;
  final AbcEntry entry;

  String _dateLine(BuildContext context) {
    final t = context.t;
    final d = entry.date;
    if (d == null) return entry.entryDate;
    final base = t.dailyTracker.dateLine(
      day: '${d.day}',
      month: t.common.monthsShort[d.month - 1],
      year: '${d.year}',
    );
    final time = entry.entryTime;
    return time == null ? base : '$base · $time';
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final t = context.t;
    final dateLine = _dateLine(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.behavior.deleteTitle),
        content: Text(t.behavior.deleteConfirm(date: dateLine)),
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
      await ref.read(abcRepositoryProvider).delete(entry.id);
      ref.invalidate(abcEntriesProvider(childId));
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(t.behavior.deleted)));
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
    final colors = context.colors;
    final intensityColor = _intensityColor(context, entry.intensity);
    final headline = [
      if (entry.category?.isNotEmpty ?? false) entry.category!,
      if (entry.location?.isNotEmpty ?? false) entry.location!,
    ].join(' · ');
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: intensityColor.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    '${entry.intensity} · '
                    '${_intensityLabel(context, entry.intensity)}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: intensityColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _dateLine(context),
                    textAlign: TextAlign.end,
                    style: text.bodySmall
                        ?.copyWith(color: colors.textTertiary),
                  ),
                ),
                IconButton(
                  tooltip: context.t.common.a11y.delete,
                  visualDensity: VisualDensity.compact,
                  icon: Icon(Icons.delete_outline,
                      size: 20, color: colors.textTertiary),
                  onPressed: () => _delete(context, ref),
                ),
              ],
            ),
            if (headline.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(headline, style: text.titleSmall),
            ],
            const SizedBox(height: 8),
            _AbcLine(letter: 'A', value: entry.antecedent),
            const SizedBox(height: 6),
            _AbcLine(letter: 'B', value: entry.behavior),
            const SizedBox(height: 6),
            _AbcLine(letter: 'C', value: entry.consequence),
            if (entry.notes?.isNotEmpty ?? false) ...[
              const SizedBox(height: 8),
              Text(
                entry.notes!,
                style: text.bodySmall?.copyWith(
                  color: colors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AbcLine extends StatelessWidget {
  const _AbcLine({required this.letter, required this.value});
  final String letter;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 20,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            letter,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: colors.primary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: colors.textPrimary),
          ),
        ),
      ],
    );
  }
}

/// Yeni ABC kaydı formu.
class _AbcFormSheet extends ConsumerStatefulWidget {
  const _AbcFormSheet({required this.childId});
  final String childId;

  @override
  ConsumerState<_AbcFormSheet> createState() => _AbcFormSheetState();
}

class _AbcFormSheetState extends ConsumerState<_AbcFormSheet> {
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  String? _category;
  String? _location;
  String? _antecedent; // seçili çip; 'Diğer...' için null + custom
  bool _antecedentOther = false;
  String? _consequence;
  bool _consequenceOther = false;
  int _intensity = 3;
  late final TextEditingController _antecedentCustom =
      TextEditingController();
  late final TextEditingController _behavior = TextEditingController();
  late final TextEditingController _consequenceCustom =
      TextEditingController();
  late final TextEditingController _notes = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _antecedentCustom.dispose();
    _behavior.dispose();
    _consequenceCustom.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now,
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null) setState(() => _time = picked);
  }

  String? get _antecedentValue {
    if (_antecedentOther) {
      final v = _antecedentCustom.text.trim();
      return v.isEmpty ? null : v;
    }
    return _antecedent;
  }

  String? get _consequenceValue {
    if (_consequenceOther) {
      final v = _consequenceCustom.text.trim();
      return v.isEmpty ? null : v;
    }
    return _consequence;
  }

  Future<void> _save() async {
    final t = context.t;
    final antecedent = _antecedentValue;
    final consequence = _consequenceValue;
    final behavior = _behavior.text.trim();
    if (_category == null ||
        _location == null ||
        antecedent == null ||
        behavior.isEmpty ||
        consequence == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.behavior.errorRequired)));
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(abcRepositoryProvider).create(
            childId: widget.childId,
            entryDate: _isoDate(_date),
            entryTime: _formatTimeOfDay(_time),
            antecedent: antecedent,
            behavior: behavior,
            consequence: consequence,
            intensity: _intensity,
            category: _category!,
            location: _location!,
            notes: _notes.text,
          );
      if (mounted) Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.margin,
        right: AppSpacing.margin,
        top: AppSpacing.md,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.md,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.behavior.addTitle,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _PickerField(
                    label: t.behavior.date,
                    icon: Icons.calendar_today_outlined,
                    value: _isoDate(_date),
                    onTap: _pickDate,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PickerField(
                    label: t.behavior.time,
                    icon: Icons.schedule_outlined,
                    value: _formatTimeOfDay(_time),
                    onTap: _pickTime,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _category,
                    isExpanded: true,
                    decoration:
                        InputDecoration(labelText: t.behavior.category),
                    items: [
                      for (final c in kAbcCategories)
                        DropdownMenuItem(
                          value: c,
                          child: Text(c,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14)),
                        ),
                    ],
                    onChanged: (v) => setState(() => _category = v),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _location,
                    isExpanded: true,
                    decoration:
                        InputDecoration(labelText: t.behavior.location),
                    items: [
                      for (final l in kAbcLocations)
                        DropdownMenuItem(
                          value: l,
                          child: Text(l,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14)),
                        ),
                    ],
                    onChanged: (v) => setState(() => _location = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(t.behavior.antecedentLabel,
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final a in kAbcAntecedents)
                  _choiceChip(
                    a,
                    !_antecedentOther && _antecedent == a,
                    () => setState(() {
                      _antecedentOther = false;
                      _antecedent = a;
                    }),
                  ),
                _choiceChip(
                  t.behavior.other,
                  _antecedentOther,
                  () => setState(() => _antecedentOther = true),
                ),
              ],
            ),
            if (_antecedentOther) ...[
              const SizedBox(height: 8),
              TextField(
                controller: _antecedentCustom,
                textCapitalization: TextCapitalization.sentences,
                decoration:
                    InputDecoration(hintText: t.behavior.antecedentHint),
              ),
            ],
            const SizedBox(height: 16),
            Text(t.behavior.behaviorLabel,
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _behavior,
              minLines: 2,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(hintText: t.behavior.behaviorHint),
            ),
            const SizedBox(height: 16),
            Text(t.behavior.consequenceLabel,
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in kAbcConsequences)
                  _choiceChip(
                    c,
                    !_consequenceOther && _consequence == c,
                    () => setState(() {
                      _consequenceOther = false;
                      _consequence = c;
                    }),
                  ),
                _choiceChip(
                  t.behavior.other,
                  _consequenceOther,
                  () => setState(() => _consequenceOther = true),
                ),
              ],
            ),
            if (_consequenceOther) ...[
              const SizedBox(height: 8),
              TextField(
                controller: _consequenceCustom,
                textCapitalization: TextCapitalization.sentences,
                decoration:
                    InputDecoration(hintText: t.behavior.consequenceHint),
              ),
            ],
            const SizedBox(height: 16),
            Text(t.behavior.intensityLabel,
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                for (var level = 1; level <= 5; level++) ...[
                  if (level > 1) const SizedBox(width: 8),
                  Expanded(
                    child: _IntensityOption(
                      level: level,
                      selected: _intensity == level,
                      onTap: () {
                        Haptics.selection();
                        setState(() => _intensity = level);
                      },
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 6),
            Center(
              child: Text(
                _intensityLabel(context, _intensity),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _intensityColor(context, _intensity),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notes,
              minLines: 2,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(labelText: t.behavior.notesLabel),
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
                  : Text(t.behavior.save),
            ),
          ],
        ),
      ),
    );
  }

  Widget _choiceChip(String label, bool selected, VoidCallback onTap) {
    final colors = context.colors;
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) {
        Haptics.selection();
        onTap();
      },
      showCheckmark: false,
      selectedColor: colors.primaryContainer,
      backgroundColor: colors.surfaceVariant,
      labelStyle: TextStyle(
        fontSize: 12,
        color: selected ? colors.primary : colors.textSecondary,
        fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
      ),
      side: BorderSide(
        color: selected ? colors.primary : colors.border,
      ),
    );
  }
}

class _PickerField extends StatelessWidget {
  const _PickerField({
    required this.label,
    required this.icon,
    required this.value,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: colors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(icon, size: 16, color: colors.primary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _IntensityOption extends StatelessWidget {
  const _IntensityOption({
    required this.level,
    required this.selected,
    required this.onTap,
  });

  final int level;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = _intensityColor(context, level);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? color.withValues(alpha: 0.14)
              : colors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: selected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            '$level',
            style: TextStyle(
              fontSize: 14,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? color : colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
