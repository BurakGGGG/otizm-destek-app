import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/haptics.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../i18n/strings.g.dart';
import '../../data/milestone_repository.dart';
import '../../domain/milestone.dart';

/// Kilometre taşı ekleme/düzenleme sayfası (web modalı birebir): başlık,
/// açıklama, tarih, Türkçe sabit kategori. Başarıda `true` döndürür.
class MilestoneSheet extends ConsumerStatefulWidget {
  const MilestoneSheet({super.key, required this.childId, this.existing});

  final String childId;
  final Milestone? existing;

  @override
  ConsumerState<MilestoneSheet> createState() => _MilestoneSheetState();
}

class _MilestoneSheetState extends ConsumerState<MilestoneSheet> {
  late final TextEditingController _title;
  late final TextEditingController _description;
  late DateTime _date;
  String _category = '';
  bool _saving = false;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _title = TextEditingController(text: existing?.title ?? '');
    _description = TextEditingController(text: existing?.description ?? '');
    _date = existing?.achievedDate ?? DateTime.now();
    _category = existing?.category ?? '';
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  String get _dateKey =>
      '${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}';

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    final title = _title.text.trim();
    if (title.isEmpty) return;
    setState(() => _saving = true);
    try {
      final repo = ref.read(milestoneRepositoryProvider);
      if (_isEdit) {
        await repo.update(
          widget.existing!.id,
          title: title,
          description: _description.text,
          category: _category,
          achievedDate: _dateKey,
        );
      } else {
        await repo.create(
          childId: widget.childId,
          title: title,
          description: _description.text,
          category: _category,
          achievedDate: _dateKey,
        );
      }
      if (!mounted) return;
      Haptics.success();
      Navigator.of(context).pop(true);
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
    final text = Theme.of(context).textTheme;

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
              _isEdit
                  ? t.childDetail.milestoneEdit
                  : t.childDetail.milestoneAdd,
              style: text.titleMedium,
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final category in kMilestoneCategoryValues) ...[
                    ChoiceChip(
                      // Kategori değerleri paylaşılan Türkçe veri — çevrilmez.
                      label: Text(category),
                      selected: _category == category,
                      onSelected: _saving
                          ? null
                          : (_) => setState(() => _category =
                              _category == category ? '' : category),
                    ),
                    const SizedBox(width: 6),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _title,
              enabled: !_saving,
              decoration: InputDecoration(
                labelText: t.childDetail.milestoneTitleLabel,
                hintText: t.childDetail.milestoneTitleHint,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _description,
              enabled: !_saving,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: t.childDetail.milestoneDescLabel,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _saving ? null : _pickDate,
              icon: const Icon(Icons.event, size: 16),
              label: Text(_dateKey),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        _isEdit ? Icons.save_outlined : Icons.star_outline,
                        size: 16,
                        color: colors.onPrimary,
                      ),
                label: Text(
                    _isEdit ? t.childDetail.save : t.childDetail.milestoneSave),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
