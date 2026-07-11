import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/haptics.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../i18n/strings.g.dart';
import '../../data/tasks_repository.dart';
import '../../domain/expert_task.dart';

/// Görev teslim sayfası (web "Görevi Teslim Et" modali birebir): uzmana
/// iletilecek not + isteğe bağlı kanıt/video bağlantısı. Başarıda `true`
/// döndürür; teslim backend'de görevi COMPLETED yapar.
class TaskSubmitSheet extends ConsumerStatefulWidget {
  const TaskSubmitSheet({
    super.key,
    required this.task,
    required this.parentId,
  });

  final ExpertTask task;
  final String parentId;

  @override
  ConsumerState<TaskSubmitSheet> createState() => _TaskSubmitSheetState();
}

class _TaskSubmitSheetState extends ConsumerState<TaskSubmitSheet> {
  final _note = TextEditingController();
  final _evidenceUrl = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _note.dispose();
    _evidenceUrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _sending = true);
    try {
      await ref.read(tasksRepositoryProvider).submitTask(
            taskId: widget.task.id,
            parentId: widget.parentId,
            note: _note.text,
            evidenceUrl: _evidenceUrl.text,
          );
      if (!mounted) return;
      Haptics.success();
      Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _sending = false);
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
            Text(t.tasks.submitTitle, style: text.titleMedium),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: .06),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.tasks.selectedTask,
                    style: text.labelSmall?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(widget.task.title, style: text.bodyMedium),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(
              t.tasks.noteLabel,
              style: text.labelMedium
                  ?.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _note,
              enabled: !_sending,
              minLines: 3,
              maxLines: 5,
              decoration: InputDecoration(hintText: t.tasks.noteHint),
            ),
            const SizedBox(height: 14),
            Text(
              t.tasks.evidenceLabel,
              style: text.labelMedium
                  ?.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _evidenceUrl,
              enabled: !_sending,
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
                hintText: 'https://…',
                prefixIcon: const Icon(Icons.link, size: 18),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              t.tasks.evidenceHint,
              style: text.labelSmall?.copyWith(color: colors.textTertiary),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _sending ? null : _submit,
                icon: _sending
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check_circle_outline, size: 18),
                label: Text(t.tasks.submitConfirm),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
