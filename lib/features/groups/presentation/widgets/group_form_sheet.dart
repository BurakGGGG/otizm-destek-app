import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/util/input_rules.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../i18n/strings.g.dart';
import '../../data/group_repository.dart';
import '../../domain/group.dart';

/// Grup oluşturma / düzenleme alt sayfası. `name` zorunlu; kategori
/// seçilebilir. [existing] verilirse düzenleme modudur (yalnızca grubu kuran
/// çağırır; yetkiyi backend de doğrular).
class GroupFormSheet extends ConsumerStatefulWidget {
  const GroupFormSheet({super.key, this.existing});

  final Group? existing;

  @override
  ConsumerState<GroupFormSheet> createState() => _GroupFormSheetState();
}

class _GroupFormSheetState extends ConsumerState<GroupFormSheet> {
  late final _name = TextEditingController(text: widget.existing?.name ?? '');
  late final _description =
      TextEditingController(text: widget.existing?.description ?? '');
  late String? _category = widget.existing?.category;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final t = context.t;
    if (_name.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.groups.errorName)));
      return;
    }
    setState(() => _saving = true);
    try {
      final repository = ref.read(groupRepositoryProvider);
      final existing = widget.existing;
      if (existing == null) {
        await repository.create(
          name: _name.text,
          description: _description.text,
          category: _category,
        );
      } else {
        await repository.update(
          existing.id,
          name: _name.text,
          description: _description.text,
          category: _category,
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
              widget.existing == null
                  ? t.groups.addTitle
                  : t.groups.editTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _name,
              inputFormatters: lengthLimit(kMaxTitleLength),
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: t.groups.nameLabel,
                hintText: t.groups.nameHint,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _description,
              inputFormatters: lengthLimit(kMaxShortTextLength),
              minLines: 2,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: t.groups.descriptionLabel,
                hintText: t.groups.descriptionHint,
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              t.groups.categoryLabel,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                for (final c in kGroupCategories)
                  ChoiceChip(
                    label: Text(c),
                    selected: _category == c,
                    showCheckmark: false,
                    onSelected: (_) => setState(
                      () => _category = _category == c ? null : c,
                    ),
                  ),
              ],
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
                label: Text(t.groups.create),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
