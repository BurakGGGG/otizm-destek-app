import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/haptics.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../i18n/strings.g.dart';
import '../data/sleep_repository.dart';
import '../domain/sleep_entry.dart';

/// Günlük Takip — Uyku sekmesi (`/api/sleep`, gün başına upsert).
class SleepTab extends ConsumerWidget {
  const SleepTab({super.key, required this.childId});
  final String childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final async = ref.watch(sleepEntriesProvider(childId));
    return async.when(
      loading: () => const SkeletonList(count: 3),
      error: (e, _) => ErrorRetry(
          onRetry: () => ref.invalidate(sleepEntriesProvider(childId))),
      data: (entries) {
        final todayIso = _isoDate(DateTime.now());
        SleepEntry? today;
        for (final e in entries) {
          if (e.sleepDate == todayIso) {
            today = e;
            break;
          }
        }
        final history =
            entries.where((e) => e.sleepDate != todayIso).toList();
        return RefreshIndicator(
          onRefresh: () async =>
              ref.invalidate(sleepEntriesProvider(childId)),
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
                    t.sleep.empty,
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

String _formatTimeOfDay(TimeOfDay t) =>
    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

TimeOfDay _parseTime(String? hhmm, TimeOfDay fallback) {
  final parts = (hhmm ?? '').split(':');
  if (parts.length != 2) return fallback;
  final h = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  if (h == null || m == null || h < 0 || h > 23 || m < 0 || m > 59) {
    return fallback;
  }
  return TimeOfDay(hour: h, minute: m);
}

/// Bugünün uyku formu — dünkü gece/bu sabah; mevcut kayıt varsa doldurur.
class _TodayCard extends ConsumerStatefulWidget {
  const _TodayCard({super.key, required this.childId, this.entry});
  final String childId;
  final SleepEntry? entry;

  @override
  ConsumerState<_TodayCard> createState() => _TodayCardState();
}

class _TodayCardState extends ConsumerState<_TodayCard> {
  late TimeOfDay _bedtime = _parseTime(
      widget.entry?.bedtime, const TimeOfDay(hour: 21, minute: 0));
  late TimeOfDay _wakeTime = _parseTime(
      widget.entry?.wakeTime, const TimeOfDay(hour: 7, minute: 0));
  late int _quality = widget.entry?.quality ?? 3;
  late int _nightWakings = widget.entry?.nightWakings ?? 0;
  late final SleepNotes _parsed = SleepNotes.parse(widget.entry?.notes);
  late bool _weighted = _parsed.weightedBlanket;
  late bool _sensory = _parsed.sensoryIssues;
  late bool _melatonin = _parsed.melatonin;
  late bool _noise = _parsed.noiseLightDisturbance;
  late final TextEditingController _notes =
      TextEditingController(text: _parsed.text);
  bool _saving = false;

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickTime(bool bedtime) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: bedtime ? _bedtime : _wakeTime,
    );
    if (picked == null) return;
    setState(() => bedtime ? _bedtime = picked : _wakeTime = picked);
  }

  Future<void> _save() async {
    final t = context.t;
    setState(() => _saving = true);
    try {
      await ref.read(sleepRepositoryProvider).upsert(
            childId: widget.childId,
            sleepDate: _isoDate(DateTime.now()),
            bedtime: _formatTimeOfDay(_bedtime),
            wakeTime: _formatTimeOfDay(_wakeTime),
            quality: _quality,
            nightWakings: _nightWakings,
            notes: SleepNotes(
              weightedBlanket: _weighted,
              sensoryIssues: _sensory,
              melatonin: _melatonin,
              noiseLightDisturbance: _noise,
              text: _notes.text,
            ).serialize(),
          );
      ref.invalidate(sleepEntriesProvider(widget.childId));
      if (!mounted) return;
      Haptics.success();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.sleep.saved)));
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
    final qualityLabels = [
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
                  child: Text(t.sleep.todayTitle,
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
                Expanded(
                  child: _TimeField(
                    label: t.sleep.bedtime,
                    icon: Icons.bedtime_outlined,
                    value: _formatTimeOfDay(_bedtime),
                    onTap: () => _pickTime(true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _TimeField(
                    label: t.sleep.wakeTime,
                    icon: Icons.wb_sunny_outlined,
                    value: _formatTimeOfDay(_wakeTime),
                    onTap: () => _pickTime(false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(t.sleep.quality,
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                for (var q = 1; q <= 5; q++) ...[
                  if (q > 1) const SizedBox(width: 8),
                  Expanded(
                    child: _QualityOption(
                      value: q,
                      selected: _quality == q,
                      onTap: () {
                        Haptics.selection();
                        setState(() => _quality = q);
                      },
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 6),
            Center(
              child: Text(
                qualityLabels[_quality - 1],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: context.colors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: context.colors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(t.sleep.nightWakings,
                        style: Theme.of(context).textTheme.labelLarge),
                  ),
                  IconButton(
                    tooltip: context.t.common.a11y.decrease,
                    icon: const Icon(Icons.remove_circle_outline),
                    color: context.colors.textSecondary,
                    onPressed: _nightWakings > 0
                        ? () {
                            Haptics.selection();
                            setState(() => _nightWakings--);
                          }
                        : null,
                  ),
                  SizedBox(
                    width: 24,
                    child: Center(
                      child: Text(
                        '$_nightWakings',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: context.t.common.a11y.increase,
                    icon: const Icon(Icons.add_circle_outline),
                    color: context.colors.textSecondary,
                    onPressed: () {
                      Haptics.selection();
                      setState(() => _nightWakings++);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(t.sleep.factorsLabel,
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _factorChip(t.sleep.factorWeighted, _weighted,
                    (v) => setState(() => _weighted = v)),
                _factorChip(t.sleep.factorSensory, _sensory,
                    (v) => setState(() => _sensory = v)),
                _factorChip(t.sleep.factorMelatonin, _melatonin,
                    (v) => setState(() => _melatonin = v)),
                _factorChip(t.sleep.factorNoise, _noise,
                    (v) => setState(() => _noise = v)),
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

  Widget _factorChip(String label, bool selected, ValueChanged<bool> onSel) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (v) {
        Haptics.selection();
        onSel(v);
      },
      showCheckmark: false,
      selectedColor: context.colors.primaryContainer,
      backgroundColor: context.colors.surfaceVariant,
      labelStyle: TextStyle(
        fontSize: 12,
        color: selected ? context.colors.primary : context.colors.textSecondary,
        fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
      ),
      side: BorderSide(
        color: selected ? context.colors.primary : context.colors.border,
      ),
    );
  }
}

class _TimeField extends StatelessWidget {
  const _TimeField({
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
                Icon(icon, size: 18, color: colors.primary),
                const SizedBox(width: 6),
                Text(
                  value,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QualityOption extends StatelessWidget {
  const _QualityOption({
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final int value;
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
        child: Center(
          child: Text(
            '$value⭐',
            style: TextStyle(
              fontSize: 13,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? colors.primary : colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _HistoryCard extends ConsumerWidget {
  const _HistoryCard({required this.childId, required this.entry});
  final String childId;
  final SleepEntry entry;

  String _dateLine(BuildContext context) {
    final t = context.t;
    final d = entry.date;
    if (d == null) return entry.sleepDate;
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
        content: Text(t.sleep.deleteConfirm(date: dateLine)),
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
      await ref.read(sleepRepositoryProvider).delete(entry.id);
      ref.invalidate(sleepEntriesProvider(childId));
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(t.sleep.deleted)));
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
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final colors = context.colors;
    final parsed = SleepNotes.parse(entry.notes);
    final duration = entry.durationMinutes;
    final factors = [
      if (parsed.weightedBlanket) t.sleep.factorWeighted,
      if (parsed.sensoryIssues) t.sleep.factorSensory,
      if (parsed.melatonin) t.sleep.factorMelatonin,
      if (parsed.noiseLightDisturbance) t.sleep.factorNoise,
    ];
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bedtime_outlined,
                    size: 20, color: colors.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${entry.bedtime ?? '?'} → ${entry.wakeTime ?? '?'}',
                    style: text.titleSmall,
                  ),
                ),
                Text(
                  _dateLine(context),
                  style: text.bodySmall
                      ?.copyWith(color: colors.textTertiary),
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
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (duration != null)
                  _miniChip(
                    context,
                    t.sleep.duration(
                        h: '${duration ~/ 60}', m: '${duration % 60}'),
                  ),
                if ((entry.quality ?? 0) > 0)
                  Text('⭐' * entry.quality!.clamp(1, 5),
                      style: const TextStyle(fontSize: 11)),
                if (entry.nightWakings > 0)
                  _miniChip(
                      context, t.sleep.wakings(count: '${entry.nightWakings}')),
                for (final f in factors) _miniChip(context, f),
              ],
            ),
            if (parsed.text.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                parsed.text,
                style:
                    text.bodySmall?.copyWith(color: colors.textSecondary),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _miniChip(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: context.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, color: context.colors.textSecondary),
      ),
    );
  }
}
