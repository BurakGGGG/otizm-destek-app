import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/haptics.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../i18n/strings.g.dart';
import '../data/goal_repository.dart';
import '../domain/goal_categories.dart';

/// Yeni hedef formu — `POST /goals/child/{childId}`.
class GoalFormScreen extends ConsumerStatefulWidget {
  const GoalFormScreen({super.key, required this.childId});
  final String childId;

  @override
  ConsumerState<GoalFormScreen> createState() => _GoalFormScreenState();
}

class _GoalFormScreenState extends ConsumerState<GoalFormScreen> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  String _category = kDevelopmentCategories.last; // "Genel"
  int _target = 5;
  bool _saving = false;
  String? _titleError;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final t = context.t;
    if (_title.text.trim().isEmpty) {
      setState(() => _titleError = t.goalForm.errorTitle);
      return;
    }
    setState(() {
      _titleError = null;
      _saving = true;
    });
    try {
      await ref
          .read(goalRepositoryProvider)
          .createGoal(
            childId: widget.childId,
            title: _title.text,
            category: _category,
            description: _description.text,
            targetCount: _target,
          );
      ref.invalidate(goalsProvider(widget.childId));
      if (!mounted) return;
      Haptics.success();
      Navigator.of(context).pop(t.goalForm.created);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Scaffold(
      appBar: AppBar(title: Text(t.goalForm.title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.margin),
          children: [
            TextField(
              controller: _title,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: t.goalForm.nameLabel,
                hintText: t.goalForm.nameHint,
                errorText: _titleError,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              t.goalForm.categoryLabel,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in kDevelopmentCategories)
                  ChoiceChip(
                    label: Text(c),
                    selected: _category == c,
                    showCheckmark: false,
                    selectedColor: AppColors.primary.withValues(alpha: 0.16),
                    onSelected: (_) => setState(() => _category = c),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  t.goalForm.targetLabel,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const Spacer(),
                IconButton.outlined(
                  onPressed: _target > 1
                      ? () => setState(() => _target--)
                      : null,
                  icon: const Icon(Icons.remove),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    '$_target',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton.outlined(
                  onPressed: _target < 50
                      ? () => setState(() => _target++)
                      : null,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _description,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: t.goalForm.descriptionLabel,
                hintText: t.goalForm.descriptionHint,
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
                  : Text(t.goalForm.save),
            ),
          ],
        ),
      ),
    );
  }
}
