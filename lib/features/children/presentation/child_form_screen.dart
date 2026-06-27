import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../i18n/strings.g.dart';
import '../data/child_repository.dart';
import '../domain/child.dart';

/// Çocuk ekleme/düzenleme formu. [child] null ise yeni kayıt.
class ChildFormScreen extends ConsumerStatefulWidget {
  const ChildFormScreen({super.key, this.child});

  final Child? child;

  bool get isEdit => child != null;

  @override
  ConsumerState<ChildFormScreen> createState() => _ChildFormScreenState();
}

class _ChildFormScreenState extends ConsumerState<ChildFormScreen> {
  late final TextEditingController _name;
  late final TextEditingController _diagnosis;
  late final TextEditingController _education;
  late final TextEditingController _therapies;

  DateTime? _birthDate;
  String? _gender; // ERKEK | KIZ | null
  bool _saving = false;
  String? _nameError;

  @override
  void initState() {
    super.initState();
    final c = widget.child;
    _name = TextEditingController(text: c?.name ?? '');
    _diagnosis = TextEditingController(text: c?.diagnosisInfo ?? '');
    _education = TextEditingController(text: c?.educationProgram ?? '');
    _therapies = TextEditingController(text: c?.therapies ?? '');
    _birthDate = c?.birthDate;
    _gender = c?.gender;
  }

  @override
  void dispose() {
    _name.dispose();
    _diagnosis.dispose();
    _education.dispose();
    _therapies.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(now.year - 5),
      firstDate: DateTime(now.year - 25),
      lastDate: now,
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  Future<void> _save() async {
    final t = context.t;
    final name = _name.text.trim();
    if (name.isEmpty) {
      setState(() => _nameError = t.children.errorNameRequired);
      return;
    }
    setState(() {
      _nameError = null;
      _saving = true;
    });

    final draft = Child(
      id: widget.child?.id ?? '',
      name: name,
      birthDate: _birthDate,
      gender: _gender,
      diagnosisInfo: _diagnosis.text.trim(),
      educationProgram: _education.text.trim(),
      therapies: _therapies.text.trim(),
    );

    try {
      final repo = ref.read(childRepositoryProvider);
      if (widget.isEdit) {
        await repo.updateChild(widget.child!.id, draft);
      } else {
        await repo.createChild(draft);
      }
      ref.invalidate(childrenProvider);
      if (!mounted) return;
      Navigator.of(context).pop(
        widget.isEdit ? t.children.updated : t.children.created,
      );
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? t.children.editTitle : t.children.addTitle),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.margin),
          children: [
            TextField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: t.children.nameLabel,
                hintText: t.children.nameHint,
                errorText: _nameError,
              ),
            ),
            const SizedBox(height: 16),
            _DateField(
              label: t.children.birthDateLabel,
              placeholder: t.children.birthDateSelect,
              value: _birthDate,
              onTap: _pickDate,
              onClear: _birthDate == null
                  ? null
                  : () => setState(() => _birthDate = null),
            ),
            const SizedBox(height: 16),
            Text(t.children.genderLabel,
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                _GenderChip(
                  label: t.children.genderMale,
                  selected: _gender == 'ERKEK',
                  onTap: () => setState(
                      () => _gender = _gender == 'ERKEK' ? null : 'ERKEK'),
                ),
                const SizedBox(width: 12),
                _GenderChip(
                  label: t.children.genderFemale,
                  selected: _gender == 'KIZ',
                  onTap: () =>
                      setState(() => _gender = _gender == 'KIZ' ? null : 'KIZ'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _diagnosis,
              minLines: 1,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: t.children.diagnosisLabel,
                hintText: t.children.diagnosisHint,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _education,
              minLines: 1,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: t.children.educationLabel,
                hintText: t.children.educationHint,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _therapies,
              minLines: 1,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: t.children.therapiesLabel,
                hintText: t.children.therapiesHint,
              ),
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(t.children.save),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.placeholder,
    required this.value,
    required this.onTap,
    required this.onClear,
  });

  final String label;
  final String placeholder;
  final DateTime? value;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final v = value;
    final text = v == null
        ? placeholder
        : '${v.day} ${t.common.monthsShort[v.month - 1]} ${v.year}';
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: onClear != null
              ? IconButton(icon: const Icon(Icons.clear), onPressed: onClear)
              : const Icon(Icons.calendar_today_outlined),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: v == null ? AppColors.textTertiary : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _GenderChip extends StatelessWidget {
  const _GenderChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      selectedColor: AppColors.primary.withValues(alpha: 0.16),
      labelStyle: TextStyle(
        color: selected ? AppColors.primary : AppColors.textPrimary,
        fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
      ),
    );
  }
}
