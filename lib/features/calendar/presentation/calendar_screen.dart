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
import '../data/calendar_repository.dart';
import '../domain/calendar_event.dart';

/// Takvim — çocuğa özel etkinlik ajandası (`/api/calendar`).
class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  String? _selectedChildId;

  Future<void> _addEvent(String childId) async {
    final t = context.t;
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _EventFormSheet(childId: childId),
    );
    if (saved == true && mounted) {
      ref.invalidate(calendarEventsProvider(childId));
      Haptics.success();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.calendar.saved)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final childrenAsync = ref.watch(childrenProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.calendar.title)),
      body: SafeArea(
        child: childrenAsync.when(
          loading: () => const SkeletonList(count: 4),
          error: (e, _) =>
              ErrorRetry(onRetry: () => ref.invalidate(childrenProvider)),
          data: (children) {
            if (children.isEmpty) {
              return EmptyState(
                icon: Icons.child_care_outlined,
                message: t.calendar.noChild,
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
                Expanded(child: _Agenda(childId: childId)),
              ],
            );
          },
        ),
      ),
      floatingActionButton: childrenAsync.maybeWhen(
        data: (children) => children.isEmpty
            ? null
            : FloatingActionButton.extended(
                onPressed: () =>
                    _addEvent(_selectedChildId ?? children.first.id),
                icon: const Icon(Icons.add),
                label: Text(t.calendar.add),
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

String _two(int n) => n.toString().padLeft(2, '0');
String _timeLabel(DateTime d) => '${_two(d.hour)}:${_two(d.minute)}';
DateTime _dayKey(DateTime d) => DateTime(d.year, d.month, d.day);

class _Agenda extends ConsumerWidget {
  const _Agenda({required this.childId});
  final String childId;

  String _dateHeader(BuildContext context, DateTime day) {
    final t = context.t;
    final today = _dayKey(DateTime.now());
    final diff = day.difference(today).inDays;
    if (diff == 0) return t.calendar.today;
    if (diff == 1) return t.calendar.tomorrow;
    return '${day.day} ${t.common.monthsShort[day.month - 1]} ${day.year}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final async = ref.watch(calendarEventsProvider(childId));
    return async.when(
      loading: () => const SkeletonList(count: 4),
      error: (e, _) => ErrorRetry(
          onRetry: () => ref.invalidate(calendarEventsProvider(childId))),
      data: (events) {
        if (events.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async =>
                ref.invalidate(calendarEventsProvider(childId)),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.margin),
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Text(
                    t.calendar.empty,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: context.colors.textTertiary),
                  ),
                ),
              ],
            ),
          );
        }
        // Güne göre grupla (sıra zaten artan).
        final groups = <DateTime, List<CalendarEvent>>{};
        for (final e in events) {
          groups.putIfAbsent(_dayKey(e.startTime), () => []).add(e);
        }
        final days = groups.keys.toList()..sort();
        return RefreshIndicator(
          onRefresh: () async =>
              ref.invalidate(calendarEventsProvider(childId)),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.margin, 8, AppSpacing.margin, 96),
            children: [
              for (final day in days) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Text(
                    _dateHeader(context, day),
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(color: context.colors.textSecondary),
                  ),
                ),
                for (final event in groups[day]!) ...[
                  _EventCard(childId: childId, event: event),
                  const SizedBox(height: 8),
                ],
              ],
            ],
          ),
        );
      },
    );
  }
}

String _statusLabel(BuildContext context, String status) {
  final t = context.t;
  switch (status) {
    case 'COMPLETED':
      return t.calendar.statusCompleted;
    case 'CANCELLED':
      return t.calendar.statusCancelled;
    default:
      return t.calendar.statusPlanned;
  }
}

class _EventCard extends ConsumerWidget {
  const _EventCard({required this.childId, required this.event});
  final String childId;
  final CalendarEvent event;

  Future<void> _edit(BuildContext context, WidgetRef ref) async {
    final t = context.t;
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _EventFormSheet(childId: childId, event: event),
    );
    if (saved == true && context.mounted) {
      ref.invalidate(calendarEventsProvider(childId));
      Haptics.success();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.calendar.saved)));
    }
  }

  Future<void> _setStatus(
      BuildContext context, WidgetRef ref, String status) async {
    try {
      await ref.read(calendarRepositoryProvider).updateStatus(event.id, status);
      ref.invalidate(calendarEventsProvider(childId));
      Haptics.selection();
    } on ApiException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final t = context.t;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.calendar.deleteTitle),
        content: Text(t.calendar.deleteConfirm(title: event.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(t.calendar.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(t.calendar.delete),
          ),
        ],
      ),
    );
    if (ok != true) return;
    Haptics.warning();
    try {
      await ref.read(calendarRepositoryProvider).delete(event.id);
      ref.invalidate(calendarEventsProvider(childId));
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(t.calendar.deleted)));
      }
    } on ApiException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  void _openMenu(BuildContext context, WidgetRef ref) {
    final t = context.t;
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(t.calendar.editTitle),
              onTap: () {
                Navigator.of(ctx).pop();
                _edit(context, ref);
              },
            ),
            if (event.status != 'COMPLETED')
              ListTile(
                leading: Icon(Icons.check_circle_outline,
                    color: context.colors.success),
                title: Text(t.calendar.markCompleted),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _setStatus(context, ref, 'COMPLETED');
                },
              ),
            if (event.status != 'PLANNED')
              ListTile(
                leading: const Icon(Icons.event_available_outlined),
                title: Text(t.calendar.markPlanned),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _setStatus(context, ref, 'PLANNED');
                },
              ),
            if (event.status != 'CANCELLED')
              ListTile(
                leading: Icon(Icons.cancel_outlined,
                    color: context.colors.textSecondary),
                title: Text(t.calendar.markCancelled),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _setStatus(context, ref, 'CANCELLED');
                },
              ),
            ListTile(
              leading: Icon(Icons.delete_outline, color: context.colors.error),
              title: Text(t.calendar.delete),
              onTap: () {
                Navigator.of(ctx).pop();
                _delete(context, ref);
              },
            ),
          ],
        ),
      ),
    );
  }

  String _reminderLabel(BuildContext context, int minutes) {
    final t = context.t;
    if (minutes >= 1440) return t.calendar.reminderDay;
    if (minutes >= 60) return t.calendar.reminderHour(count: '${minutes ~/ 60}');
    return t.calendar.reminderMin(count: '$minutes');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final type = calendarTypeOf(event.eventType);
    final cancelled = event.isCancelled;
    final timeRange = event.endTime == null
        ? _timeLabel(event.startTime)
        : '${_timeLabel(event.startTime)} – ${_timeLabel(event.endTime!)}';
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () => _edit(context, ref),
        onLongPress: () => _openMenu(context, ref),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 4,
                height: 44,
                margin: const EdgeInsets.only(right: 12, top: 2),
                decoration: BoxDecoration(
                  color: cancelled ? colors.border : type.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(type.icon,
                            size: 15,
                            color: cancelled ? colors.textTertiary : type.color),
                        const SizedBox(width: 6),
                        Text(
                          timeRange,
                          style: text.bodySmall?.copyWith(
                            color: colors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        _StatusChip(status: event.status),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.title,
                      style: text.titleSmall?.copyWith(
                        decoration:
                            cancelled ? TextDecoration.lineThrough : null,
                        color: cancelled ? colors.textTertiary : null,
                      ),
                    ),
                    if (event.location?.isNotEmpty ?? false) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.place_outlined,
                              size: 13, color: colors.textTertiary),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event.location!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: text.bodySmall
                                  ?.copyWith(color: colors.textTertiary),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (event.reminderMinutesBefore != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.notifications_active_outlined,
                              size: 13, color: colors.textTertiary),
                          const SizedBox(width: 4),
                          Text(
                            _reminderLabel(
                                context, event.reminderMinutesBefore!),
                            style: text.bodySmall
                                ?.copyWith(color: colors.textTertiary),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                tooltip: context.t.common.a11y.options,
                visualDensity: VisualDensity.compact,
                icon: Icon(Icons.more_vert, size: 20, color: colors.textTertiary),
                onPressed: () => _openMenu(context, ref),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final Color color;
    switch (status) {
      case 'COMPLETED':
        color = colors.success;
      case 'CANCELLED':
        color = colors.textTertiary;
      default:
        color = colors.primary;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        _statusLabel(context, status),
        style: TextStyle(
            fontSize: 10, fontWeight: FontWeight.w700, color: color),
      ),
    );
  }
}

/// Etkinlik ekleme/düzenleme formu.
class _EventFormSheet extends ConsumerStatefulWidget {
  const _EventFormSheet({required this.childId, this.event});
  final String childId;
  final CalendarEvent? event;

  @override
  ConsumerState<_EventFormSheet> createState() => _EventFormSheetState();
}

class _EventFormSheetState extends ConsumerState<_EventFormSheet> {
  late String _type = widget.event?.eventType ?? 'TERAPI';
  late final TextEditingController _title =
      TextEditingController(text: widget.event?.title ?? '');
  late final TextEditingController _location =
      TextEditingController(text: widget.event?.location ?? '');
  late final TextEditingController _description =
      TextEditingController(text: widget.event?.description ?? '');
  late DateTime _start = widget.event?.startTime ?? _defaultStart();
  late DateTime? _end = widget.event?.endTime;
  late int? _reminder = widget.event?.reminderMinutesBefore;
  bool _saving = false;

  static DateTime _defaultStart() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, now.hour + 1);
  }

  @override
  void dispose() {
    _title.dispose();
    _location.dispose();
    _description.dispose();
    super.dispose();
  }

  String _typeLabel(BuildContext context, String code) {
    final t = context.t;
    switch (code) {
      case 'TERAPI':
        return t.calendar.typeTerapi;
      case 'DOKTOR':
        return t.calendar.typeDoktor;
      case 'EGITIM':
        return t.calendar.typeEgitim;
      case 'AKTIVITE':
        return t.calendar.typeAktivite;
      case 'APPOINTMENT':
        return t.calendar.typeAppointment;
      default:
        return t.calendar.typeDiger;
    }
  }

  String _reminderLabel(BuildContext context, int? value) {
    final t = context.t;
    if (value == null) return t.calendar.reminderOff;
    if (value >= 1440) return t.calendar.reminderDay;
    if (value >= 60) return t.calendar.reminderHour(count: '${value ~/ 60}');
    return t.calendar.reminderMin(count: '$value');
  }

  Future<void> _pickDateTime(bool isStart) async {
    final base = isStart ? _start : (_end ?? _start);
    final date = await showDatePicker(
      context: context,
      initialDate: base,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(base),
    );
    if (time == null) return;
    final picked =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    setState(() {
      if (isStart) {
        _start = picked;
        if (_end != null && _end!.isBefore(_start)) _end = null;
      } else {
        _end = picked;
      }
    });
  }

  String _dateTimeLabel(BuildContext context, DateTime d) {
    final t = context.t;
    return '${d.day} ${t.common.monthsShort[d.month - 1]} · '
        '${_two(d.hour)}:${_two(d.minute)}';
  }

  Future<void> _save() async {
    final t = context.t;
    if (_title.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.calendar.errorTitle)));
      return;
    }
    setState(() => _saving = true);
    try {
      final repo = ref.read(calendarRepositoryProvider);
      final color =
          '#${calendarTypeOf(_type).color.toARGB32().toRadixString(16).substring(2)}';
      if (widget.event == null) {
        await repo.create(
          childId: widget.childId,
          title: _title.text,
          eventType: _type,
          startTime: _start,
          endTime: _end,
          description: _description.text.trim(),
          location: _location.text.trim(),
          reminderMinutesBefore: _reminder,
          color: color,
        );
      } else {
        await repo.update(
          widget.event!.id,
          childId: widget.childId,
          title: _title.text,
          eventType: _type,
          startTime: _start,
          endTime: _end,
          description: _description.text.trim(),
          location: _location.text.trim(),
          reminderMinutesBefore: _reminder,
          color: color,
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
              widget.event == null
                  ? t.calendar.addTitle
                  : t.calendar.editTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Text(t.calendar.eventType,
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final type in kCalendarEventTypes)
                  _TypeChip(
                    label: _typeLabel(context, type.code),
                    icon: type.icon,
                    color: type.color,
                    selected: _type == type.code,
                    onTap: () {
                      Haptics.selection();
                      setState(() => _type = type.code);
                    },
                  ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _title,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: t.calendar.eventTitle,
                hintText: t.calendar.titleHint,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _location,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: t.calendar.location,
                hintText: t.calendar.locationHint,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _PickerTile(
                    label: t.calendar.start,
                    value: _dateTimeLabel(context, _start),
                    onTap: () => _pickDateTime(true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PickerTile(
                    label: t.calendar.end,
                    value: _end == null
                        ? '—'
                        : _dateTimeLabel(context, _end!),
                    onTap: () => _pickDateTime(false),
                    onClear:
                        _end == null ? null : () => setState(() => _end = null),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(t.calendar.reminder,
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final option in kReminderOptions)
                  ChoiceChip(
                    label: Text(_reminderLabel(context, option)),
                    selected: _reminder == option,
                    onSelected: (_) {
                      Haptics.selection();
                      setState(() => _reminder = option);
                    },
                    showCheckmark: false,
                    selectedColor: colors.primaryContainer,
                    backgroundColor: colors.surfaceVariant,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      color: _reminder == option
                          ? colors.primary
                          : colors.textSecondary,
                      fontWeight: _reminder == option
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                    side: BorderSide(
                      color: _reminder == option
                          ? colors.primary
                          : colors.border,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _description,
              minLines: 2,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration:
                  InputDecoration(labelText: t.calendar.description),
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
                  : Text(t.calendar.save),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? color.withValues(alpha: 0.14)
              : colors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(color: selected ? color : colors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 15, color: selected ? color : colors.textSecondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                color: selected ? color : colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PickerTile extends StatelessWidget {
  const _PickerTile({
    required this.label,
    required this.value,
    required this.onTap,
    this.onClear,
  });

  final String label;
  final String value;
  final VoidCallback onTap;
  final VoidCallback? onClear;

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
            Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: colors.textSecondary,
                    ),
                  ),
                ),
                if (onClear != null)
                  GestureDetector(
                    onTap: onClear,
                    child: Icon(Icons.clear,
                        size: 14, color: colors.textTertiary),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.event_outlined, size: 16, color: colors.primary),
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
