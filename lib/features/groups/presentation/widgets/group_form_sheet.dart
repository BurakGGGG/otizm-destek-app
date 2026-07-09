import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../i18n/strings.g.dart';
import '../../data/group_repository.dart';
import '../../domain/group.dart';

/// Yeni grup oluşturma alt sayfası. `name` zorunlu; kategori seçilebilir.
class GroupFormSheet extends ConsumerStatefulWidget {
  const GroupFormSheet({super.key});

  @override
  ConsumerState<GroupFormSheet> createState() => _GroupFormSheetState();
}

class _GroupFormSheetState extends ConsumerState<GroupFormSheet> {
  final _name = TextEditingController();
  final _description = TextEditingController();
  String? _category;
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
      await ref.read(groupRepositoryProvider).create(
            name: _name.text,
            description: _description.text,
            category: _category,
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
            Text(t.groups.addTitle,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            TextField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: t.groups.nameLabel,
                hintText: t.groups.nameHint,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _description,
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
