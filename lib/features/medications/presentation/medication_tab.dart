import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/haptics.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../i18n/strings.g.dart';
import '../data/medication_repository.dart';
import '../domain/medication.dart';

/// Günlük Takip — İlaç sekmesi (`/api/medications` CRUD + doz günlüğü).
class MedicationTab extends ConsumerWidget {
  const MedicationTab({super.key, required this.childId});
  final String childId;

  Future<void> _openForm(BuildContext context, WidgetRef ref,
      {Medication? medication}) async {
    final t = context.t;
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _MedFormSheet(childId: childId, medication: medication),
    );
    if (saved == true && context.mounted) {
      ref.invalidate(medicationsProvider(childId));
      Haptics.success();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text(medication == null ? t.meds.added : t.meds.updated)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final async = ref.watch(medicationsProvider(childId));
    return async.when(
      loading: () => const SkeletonList(count: 3),
      error: (e, _) => ErrorRetry(
          onRetry: () => ref.invalidate(medicationsProvider(childId))),
      data: (medications) {
        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(medicationsProvider(childId)),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.margin, 4, AppSpacing.margin, 24),
            children: [
              const _SafetyNote(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(t.dailyTracker.today,
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  FilledButton.tonalIcon(
                    style: AppButtonStyles.inlineFilled,
                    onPressed: () => _openForm(context, ref),
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(t.meds.add),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (medications.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    t.meds.empty,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.colors.textTertiary),
                  ),
                )
              else
                for (final med in medications) ...[
                  _MedicationCard(
                    childId: childId,
                    medication: med,
                    onEdit: () =>
                        _openForm(context, ref, medication: med),
                  ),
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

String _frequencyLabel(BuildContext context, String? value) {
  final t = context.t;
  switch (value) {
    case 'DAILY':
      return t.meds.freqDaily;
    case 'TWICE_DAILY':
      return t.meds.freqTwiceDaily;
    case 'THREE_DAILY':
      return t.meds.freqThreeDaily;
    case 'AS_NEEDED':
      return t.meds.freqAsNeeded;
    case 'WEEKLY':
      return t.meds.freqWeekly;
    default:
      return value ?? '';
  }
}

/// İlaç güvenliği uyarısı — tıbbi kararlar yalnızca doktorla verilmeli.
class _SafetyNote extends StatelessWidget {
  const _SafetyNote();

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: colors.warning.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_outlined, size: 20, color: colors.warning),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.meds.safetyTitle,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  t.meds.safetyBody,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MedicationCard extends ConsumerWidget {
  const _MedicationCard({
    required this.childId,
    required this.medication,
    required this.onEdit,
  });

  final String childId;
  final Medication medication;
  final VoidCallback onEdit;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final t = context.t;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.meds.deleteTitle),
        content: Text(t.meds.deleteConfirm(name: medication.name)),
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
      await ref.read(medicationRepositoryProvider).delete(medication.id);
      ref.invalidate(medicationsProvider(childId));
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(t.meds.deleted)));
      }
    } on ApiException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  Future<void> _openLog(
      BuildContext context, WidgetRef ref, String time) async {
    final t = context.t;
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _DoseLogSheet(medication: medication, time: time),
    );
    if (saved == true && context.mounted) {
      ref.invalidate(medicationsProvider(childId));
      Haptics.success();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.meds.logSaved)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final times = medication.scheduledTimes.isNotEmpty
        ? medication.scheduledTimes
        : [''];
    final subtitleParts = [
      if (medication.dosage?.isNotEmpty ?? false)
        '${medication.dosage} ${medication.unit ?? ''}'.trim(),
      if (medication.frequency?.isNotEmpty ?? false)
        _frequencyLabel(context, medication.frequency),
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
                CircleAvatar(
                  radius: 20,
                  backgroundColor: colors.primaryContainer,
                  child: Icon(Icons.medication_outlined,
                      size: 20, color: colors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(medication.name, style: text.titleSmall),
                      if (subtitleParts.isNotEmpty)
                        Text(
                          subtitleParts.join(' · '),
                          style: text.bodySmall
                              ?.copyWith(color: colors.textSecondary),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: Icon(Icons.edit_outlined,
                      size: 20, color: colors.textTertiary),
                  onPressed: onEdit,
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: Icon(Icons.delete_outline,
                      size: 20, color: colors.textTertiary),
                  onPressed: () => _delete(context, ref),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final time in times)
                  _doseChip(context, ref, time, t),
              ],
            ),
            if (medication.notes?.isNotEmpty ?? false) ...[
              const SizedBox(height: 8),
              Text(
                medication.notes!,
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

  Widget _doseChip(
      BuildContext context, WidgetRef ref, String time, Translations t) {
    final colors = context.colors;
    final log = medication.logFor(time);
    final taken = log?.taken ?? false;
    final hasSideEffects = (log?.sideEffects.isNotEmpty ?? false) && taken;
    return InkWell(
      onTap: () => _openLog(context, ref, time),
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: taken ? colors.primary : colors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(color: taken ? colors.primary : colors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              taken ? Icons.check : Icons.radio_button_unchecked,
              size: 15,
              color: taken ? colors.onPrimary : colors.textTertiary,
            ),
            const SizedBox(width: 6),
            Text(
              time.isEmpty ? t.meds.noTime : time,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: taken ? colors.onPrimary : colors.textSecondary,
              ),
            ),
            if (hasSideEffects) ...[
              const SizedBox(width: 6),
              Icon(Icons.warning_amber_outlined,
                  size: 14, color: colors.warning),
            ],
          ],
        ),
      ),
    );
  }
}

/// Doz günlüğü — alındı işareti + yan etkiler + gözlem notu (gün+saat upsert).
class _DoseLogSheet extends ConsumerStatefulWidget {
  const _DoseLogSheet({required this.medication, required this.time});
  final Medication medication;
  final String time;

  @override
  ConsumerState<_DoseLogSheet> createState() => _DoseLogSheetState();
}

class _DoseLogSheetState extends ConsumerState<_DoseLogSheet> {
  late final MedicationLog? _existing = widget.medication.logFor(widget.time);
  late bool _taken = _existing?.taken ?? true;
  late final Set<String> _sideEffects = {...?_existing?.sideEffects};
  late final TextEditingController _notes =
      TextEditingController(text: _existing?.notes ?? '');
  bool _saving = false;

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ref.read(medicationRepositoryProvider).saveLog(
            widget.medication.id,
            logDate: _isoDate(DateTime.now()),
            scheduledTime: widget.time,
            taken: _taken,
            notes: _notes.text.trim(),
            sideEffects: _taken ? _sideEffects.toList() : const [],
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
    final colors = context.colors;
    final med = widget.medication;
    final doseLine = [
      if (med.dosage?.isNotEmpty ?? false)
        '${med.dosage} ${med.unit ?? ''}'.trim(),
      widget.time.isEmpty ? t.meds.noTime : widget.time,
    ].join(' · ');
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
            Text(t.meds.logTitle,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(med.name,
                      style: Theme.of(context).textTheme.titleSmall),
                  Text(
                    doseLine,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: colors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(t.meds.taken,
                  style: Theme.of(context).textTheme.labelLarge),
              value: _taken,
              onChanged: (v) {
                Haptics.selection();
                setState(() => _taken = v);
              },
            ),
            if (_taken) ...[
              Text(t.meds.sideEffectsLabel,
                  style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final effect in kMedicationSideEffects)
                    FilterChip(
                      label: Text(effect),
                      selected: _sideEffects.contains(effect),
                      onSelected: (sel) => setState(() => sel
                          ? _sideEffects.add(effect)
                          : _sideEffects.remove(effect)),
                      showCheckmark: false,
                      selectedColor: colors.primaryContainer,
                      backgroundColor: colors.surfaceVariant,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: _sideEffects.contains(effect)
                            ? colors.primary
                            : colors.textSecondary,
                        fontWeight: _sideEffects.contains(effect)
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                      side: BorderSide(
                        color: _sideEffects.contains(effect)
                            ? colors.primary
                            : colors.border,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            TextField(
              controller: _notes,
              minLines: 2,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: t.meds.logNotesLabel,
                hintText: t.meds.logNotesHint,
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
                  : Text(t.dailyTracker.save),
            ),
          ],
        ),
      ),
    );
  }
}

/// İlaç ekleme/düzenleme formu.
class _MedFormSheet extends ConsumerStatefulWidget {
  const _MedFormSheet({required this.childId, this.medication});
  final String childId;
  final Medication? medication;

  @override
  ConsumerState<_MedFormSheet> createState() => _MedFormSheetState();
}

class _MedFormSheetState extends ConsumerState<_MedFormSheet> {
  late final TextEditingController _name =
      TextEditingController(text: widget.medication?.name ?? '');
  late final TextEditingController _dosage =
      TextEditingController(text: widget.medication?.dosage ?? '');
  late final TextEditingController _notes =
      TextEditingController(text: widget.medication?.notes ?? '');
  late String _unit = kMedicationUnits.contains(widget.medication?.unit)
      ? widget.medication!.unit!
      : kMedicationUnits.first;
  late String _frequency =
      kMedicationFrequencies.contains(widget.medication?.frequency)
          ? widget.medication!.frequency!
          : kMedicationFrequencies.first;
  late final List<String> _times = [...?widget.medication?.scheduledTimes];
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _dosage.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _addTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0),
    );
    if (picked == null) return;
    final formatted = _formatTimeOfDay(picked);
    if (!_times.contains(formatted)) {
      setState(() {
        _times
          ..add(formatted)
          ..sort();
      });
    }
  }

  Future<void> _save() async {
    final t = context.t;
    if (_name.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.meds.errorName)));
      return;
    }
    setState(() => _saving = true);
    try {
      final repo = ref.read(medicationRepositoryProvider);
      final med = widget.medication;
      if (med == null) {
        await repo.create(
          childId: widget.childId,
          name: _name.text,
          dosage: _dosage.text.trim(),
          unit: _unit,
          frequency: _frequency,
          scheduledTimes: _times,
          notes: _notes.text.trim(),
        );
      } else {
        await repo.update(
          med,
          name: _name.text,
          dosage: _dosage.text.trim(),
          unit: _unit,
          frequency: _frequency,
          scheduledTimes: _times,
          notes: _notes.text.trim(),
        );
      }
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
    final colors = context.colors;
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
            Text(
              widget.medication == null ? t.meds.addTitle : t.meds.editTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _name,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: t.meds.name,
                hintText: t.meds.nameHint,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: _dosage,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(labelText: t.meds.dosage),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _unit,
                    decoration: InputDecoration(labelText: t.meds.unit),
                    items: [
                      for (final u in kMedicationUnits)
                        DropdownMenuItem(value: u, child: Text(u)),
                    ],
                    onChanged: (v) =>
                        setState(() => _unit = v ?? kMedicationUnits.first),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _frequency,
              decoration: InputDecoration(labelText: t.meds.frequency),
              items: [
                for (final f in kMedicationFrequencies)
                  DropdownMenuItem(
                      value: f, child: Text(_frequencyLabel(context, f))),
              ],
              onChanged: (v) => setState(
                  () => _frequency = v ?? kMedicationFrequencies.first),
            ),
            const SizedBox(height: 16),
            Text(t.meds.timesLabel,
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final time in _times)
                  InputChip(
                    label: Text(time),
                    onDeleted: () => setState(() => _times.remove(time)),
                    backgroundColor: colors.surfaceVariant,
                    side: BorderSide(color: colors.border),
                    labelStyle: TextStyle(
                      fontSize: 12,
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ActionChip(
                  avatar: Icon(Icons.add_alarm_outlined,
                      size: 16, color: colors.primary),
                  label: Text(t.meds.addTime),
                  onPressed: _addTime,
                  backgroundColor: colors.primaryContainer,
                  side: BorderSide(color: colors.primary),
                  labelStyle: TextStyle(
                    fontSize: 12,
                    color: colors.primary,
                    fontWeight: FontWeight.w600,
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
              decoration: InputDecoration(labelText: t.dailyTracker.notesLabel),
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
                  : Text(t.dailyTracker.save),
            ),
          ],
        ),
      ),
    );
  }
}
