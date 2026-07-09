import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../i18n/strings.g.dart';
import '../../data/community_repository.dart';
import '../../domain/community_meetup.dart';

/// Yeni buluşma oluşturma alt sayfası. `title`/`city`/`date` zorunlu.
class MeetupFormSheet extends ConsumerStatefulWidget {
  const MeetupFormSheet({super.key});

  @override
  ConsumerState<MeetupFormSheet> createState() => _MeetupFormSheetState();
}

class _MeetupFormSheetState extends ConsumerState<MeetupFormSheet> {
  final _title = TextEditingController();
  final _district = TextEditingController();
  final _venue = TextEditingController();
  final _description = TextEditingController();
  String? _city;
  DateTime? _date;
  TimeOfDay? _time;
  bool _saving = false;

  @override
  void dispose() {
    _title.dispose();
    _district.dispose();
    _venue.dispose();
    _description.dispose();
    super.dispose();
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _time = picked);
  }

  Future<void> _save() async {
    final t = context.t;
    if (_title.text.trim().isEmpty || _city == null || _date == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.meetup.errorRequired)));
      return;
    }
    setState(() => _saving = true);
    try {
      final d = _date!;
      await ref.read(communityRepositoryProvider).createMeetup(
            title: _title.text,
            city: _city!,
            date: '${d.year}-${_two(d.month)}-${_two(d.day)}',
            district: _district.text,
            venue: _venue.text,
            time: _time == null
                ? null
                : '${_two(_time!.hour)}:${_two(_time!.minute)}',
            description: _description.text,
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
    final dateLabel = _date == null
        ? t.meetup.dateLabel
        : '${_date!.day} ${t.common.monthsShort[_date!.month - 1]} ${_date!.year}';
    final timeLabel = _time == null
        ? t.meetup.timeLabel
        : '${_two(_time!.hour)}:${_two(_time!.minute)}';

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
            Text(t.meetup.addTitle,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            TextField(
              controller: _title,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: t.meetup.titleLabel,
                hintText: t.meetup.titleHint,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _city,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: t.meetup.cityLabel,
                hintText: t.meetup.cityHint,
              ),
              items: [
                for (final c in kTurkishCities)
                  DropdownMenuItem(value: c, child: Text(c)),
              ],
              onChanged: (v) => setState(() => _city = v),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _district,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: t.meetup.districtLabel,
                hintText: t.meetup.districtHint,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _venue,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: t.meetup.venueLabel,
                hintText: t.meetup.venueHint,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _PickerField(
                    label: dateLabel,
                    icon: Icons.calendar_today_outlined,
                    onTap: _pickDate,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PickerField(
                    label: timeLabel,
                    icon: Icons.schedule_outlined,
                    onTap: _pickTime,
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
              decoration: InputDecoration(
                labelText: t.meetup.descriptionLabel,
                hintText: t.meetup.descriptionHint,
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.add, size: 18),
                label: Text(t.meetup.create),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PickerField extends StatelessWidget {
  const _PickerField({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.md),
      onTap: onTap,
      child: InputDecorator(
        decoration: const InputDecoration(),
        child: Row(
          children: [
            Icon(icon, size: 18, color: context.colors.textTertiary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
