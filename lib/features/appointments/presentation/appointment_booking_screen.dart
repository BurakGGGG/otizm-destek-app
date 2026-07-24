import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/haptics.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../i18n/strings.g.dart';
import '../../children/data/child_repository.dart';
import '../../children/domain/child.dart';
import '../../specialists/domain/expert.dart';
import '../data/appointment_repository.dart';
import '../domain/expert_availability.dart';

/// Bir uzmandan randevu alma akışı (PARENT) — `POST /api/appointments`.
class AppointmentBookingScreen extends ConsumerStatefulWidget {
  const AppointmentBookingScreen({super.key, required this.expert});
  final Expert expert;

  @override
  ConsumerState<AppointmentBookingScreen> createState() =>
      _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState
    extends ConsumerState<AppointmentBookingScreen> {
  static const _duration = 50;

  final _notes = TextEditingController();
  String? _childId;
  String _type = 'FACE_TO_FACE';
  DateTime? _date;
  String? _time;

  List<ExpertAvailability> _availability = const [];
  List<String> _slots = const [];
  bool _loadingSlots = false;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _loadAvailability();
  }

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  Future<void> _loadAvailability() async {
    try {
      final list = await ref
          .read(appointmentRepositoryProvider)
          .getAvailability(widget.expert.id);
      if (mounted) setState(() => _availability = list);
    } catch (_) {
      // müsaitlik alınamadıysa slot üretilemez; sessiz geç (boş kalır)
    }
  }

  String _iso(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 183)), // ~6 ay
    );
    if (picked == null) return;
    setState(() {
      _date = picked;
      _time = null;
      _slots = const [];
      _loadingSlots = true;
    });
    await _loadSlots(picked);
  }

  Future<void> _loadSlots(DateTime date) async {
    try {
      final booked = await ref
          .read(appointmentRepositoryProvider)
          .getBookedTimes(widget.expert.id, _iso(date), duration: _duration);
      final free = buildFreeSlots(
        availabilities: _availability,
        date: date,
        bookedTimes: booked,
        duration: _duration,
      );
      if (mounted) setState(() => _slots = free);
    } catch (_) {
      if (mounted) setState(() => _slots = const []);
    } finally {
      if (mounted) setState(() => _loadingSlots = false);
    }
  }

  Future<void> _submit() async {
    final t = context.t;
    if (_childId == null) {
      _snack(t.booking.errorSelectChild);
      return;
    }
    if (_date == null || _time == null) {
      _snack(t.booking.errorSelectTime);
      return;
    }
    setState(() => _submitting = true);
    try {
      await ref
          .read(appointmentRepositoryProvider)
          .create(
            expertId: widget.expert.id,
            childId: _childId!,
            dateIso: _iso(_date!),
            time: _time!,
            type: _type,
            duration: _duration,
            notes: _notes.text,
          );
      ref.invalidate(appointmentsProvider);
      if (!mounted) return;
      Haptics.success();
      Navigator.of(context).pop(t.booking.created);
    } on ApiException catch (e) {
      if (mounted) {
        setState(() => _submitting = false);
        _snack(e.message);
      }
    }
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final childrenAsync = ref.watch(childrenProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.booking.title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.margin),
          children: [
            Text(
              widget.expert.fullName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (widget.expert.expertTitle?.isNotEmpty ?? false)
              Text(
                widget.expert.expertTitle!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            const SizedBox(height: 20),

            // Çocuk seçimi
            _Label(t.booking.childLabel),
            childrenAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: LinearProgressIndicator(),
              ),
              error: (e, _) => Text(t.common.loadError),
              data: (children) => children.isEmpty
                  ? _EmptyHint(message: t.booking.noChild)
                  : _ChildChips(
                      children: children,
                      selectedId: _childId,
                      onSelected: (id) => setState(() => _childId = id),
                    ),
            ),
            const SizedBox(height: 20),

            // Randevu tipi
            _Label(t.booking.typeLabel),
            SegmentedButton<String>(
              segments: [
                ButtonSegment(
                  value: 'FACE_TO_FACE',
                  label: Text(t.appointments.typeFaceToFace),
                  icon: const Icon(Icons.place_outlined),
                ),
                ButtonSegment(
                  value: 'ONLINE',
                  label: Text(t.appointments.typeOnline),
                  icon: const Icon(Icons.videocam_outlined),
                ),
              ],
              selected: {_type},
              showSelectedIcon: false,
              onSelectionChanged: (s) => setState(() => _type = s.first),
            ),
            const SizedBox(height: 20),

            // Tarih
            _Label(t.booking.dateLabel),
            OutlinedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.calendar_today_outlined, size: 18),
              label: Text(
                _date == null
                    ? t.booking.selectDate
                    : t.booking.dateValue(
                        day: _date!.day,
                        month: t.common.monthsShort[_date!.month - 1],
                        year: _date!.year,
                      ),
              ),
            ),
            const SizedBox(height: 20),

            // Saat (slot)
            _Label(t.booking.timeLabel),
            _slotArea(t),
            const SizedBox(height: 20),

            // Not
            _Label(t.booking.notesLabel),
            TextField(
              controller: _notes,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(hintText: t.booking.notesHint),
            ),
            const SizedBox(height: 28),

            FilledButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(t.booking.confirm),
            ),
          ],
        ),
      ),
    );
  }

  Widget _slotArea(Translations t) {
    if (_date == null) {
      return _EmptyHint(message: t.booking.selectDateFirst);
    }
    if (_loadingSlots) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: LinearProgressIndicator(),
      );
    }
    if (_slots.isEmpty) {
      return _EmptyHint(message: t.booking.noSlots);
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final s in _slots)
          ChoiceChip(
            label: Text(s),
            selected: _time == s,
            showCheckmark: false,
            selectedColor: context.colors.primary.withValues(alpha: 0.16),
            onSelected: (_) => setState(() => _time = s),
          ),
      ],
    );
  }
}

class _ChildChips extends StatelessWidget {
  const _ChildChips({
    required this.children,
    required this.selectedId,
    required this.onSelected,
  });
  final List<Child> children;
  final String? selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final c in children)
          ChoiceChip(
            label: Text(c.name),
            selected: selectedId == c.id,
            showCheckmark: false,
            selectedColor: context.colors.primary.withValues(alpha: 0.16),
            onSelected: (_) => onSelected(c.id),
          ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Text(
        message,
        style: TextStyle(color: context.colors.textSecondary),
      ),
    );
  }
}
