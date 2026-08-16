import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/haptics.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/upload_repository.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../i18n/strings.g.dart';
import '../../data/tasks_repository.dart';
import '../../domain/exercise_outcome.dart';
import '../../domain/expert_task.dart';

/// Günlük Egzersiz Sihirbazı (web `DailyExerciseWizard` birebir): görevleri
/// tek tek gezdirip "nasıl geçti?" sorusuyla teslim eder. Sonuç seçimi velinin
/// notunun başına işaret olarak eklenir ([exerciseSubmissionNote]); kanıt
/// fotoğrafı `AUTHENTICATED` görünürlükle yüklenir (uzman görebilsin).
///
/// Web'den tek ayrım: tamamlanmış bir görev tekrar teslim edilemez (web'de
/// buton açık kalıyor ve aynı görev için ikinci kayıt + uzmana ikinci bildirim
/// oluşuyor). Sihirbaz ilk bekleyen görevle açılır.
class DailyExerciseWizard extends ConsumerStatefulWidget {
  const DailyExerciseWizard({
    super.key,
    required this.tasks,
    required this.parentId,
    required this.onSubmitted,
  });

  /// Sıralanmış görevler (bkz. [wizardTasks]) — ilerleme bunlar üzerinden.
  final List<ExpertTask> tasks;
  final String parentId;

  /// Teslim başarılı olduğunda çağrılır (liste tazelenir).
  final ValueChanged<ExpertTask> onSubmitted;

  @override
  ConsumerState<DailyExerciseWizard> createState() =>
      _DailyExerciseWizardState();
}

class _DailyExerciseWizardState extends ConsumerState<DailyExerciseWizard> {
  final _note = TextEditingController();
  int _index = 0;
  ExerciseOutcome? _outcome;
  String? _evidenceUrl;
  bool _uploading = false;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _index = firstPendingIndex(widget.tasks);
  }

  @override
  void didUpdateWidget(covariant DailyExerciseWizard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Liste tazelendiğinde sıra dışına çıkmayalım.
    if (_index >= widget.tasks.length) {
      _index = widget.tasks.isEmpty ? 0 : widget.tasks.length - 1;
    }
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    setState(() {
      _index = index;
      _outcome = null;
      _evidenceUrl = null;
      _note.clear();
    });
  }

  Future<void> _pickEvidence() async {
    final t = context.t;
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(t.tasks.wizardSourceGallery),
              onTap: () => Navigator.of(sheetContext).pop(ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(t.tasks.wizardSourceCamera),
              onTap: () => Navigator.of(sheetContext).pop(ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source == null || !mounted) return;

    final picked = await ImagePicker().pickImage(
      source: source,
      maxWidth: 1600,
      imageQuality: 85,
    );
    if (picked == null || !mounted) return;

    setState(() => _uploading = true);
    try {
      final url = await ref.read(uploadRepositoryProvider).upload(
            picked.path,
            picked.name,
            // Web sihirbazıyla aynı: kanıt fotoğrafını uzman da görebilmeli.
            visibility: 'AUTHENTICATED',
          );
      if (!mounted) return;
      setState(() {
        _uploading = false;
        _evidenceUrl = url;
      });
      Haptics.success();
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _uploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  }

  Future<void> _submit(ExpertTask task) async {
    final outcome = _outcome;
    if (outcome == null) return;
    setState(() => _submitting = true);
    try {
      await ref.read(tasksRepositoryProvider).submitTask(
            taskId: task.id,
            parentId: widget.parentId,
            note: exerciseSubmissionNote(outcome, _note.text),
            evidenceUrl: _evidenceUrl,
          );
      if (!mounted) return;
      Haptics.success();
      setState(() {
        _submitting = false;
        _outcome = null;
        _evidenceUrl = null;
        _note.clear();
        if (_index < widget.tasks.length - 1) _index++;
      });
      widget.onSubmitted(task);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasks = widget.tasks;
    if (tasks.isEmpty) return const _AllDoneCard();

    final completed = tasks.where((task) => task.isCompleted).length;
    final stage =
        exerciseStageFor(completed: completed, total: tasks.length);
    final index = _index.clamp(0, tasks.length - 1);
    final task = tasks[index];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _WizardHeader(
          stage: stage,
          completed: completed,
          total: tasks.length,
        ),
        const SizedBox(height: AppSpacing.md),
        _ExerciseCard(
          task: task,
          index: index,
          total: tasks.length,
          note: _note,
          outcome: _outcome,
          evidenceUrl: _evidenceUrl,
          uploading: _uploading,
          submitting: _submitting,
          onPrev: index > 0 ? () => _goTo(index - 1) : null,
          onNext: index < tasks.length - 1 ? () => _goTo(index + 1) : null,
          onOutcome: (value) => setState(() => _outcome = value),
          onPickEvidence: _pickEvidence,
          onRemoveEvidence: () => setState(() => _evidenceUrl = null),
          onSubmit: () => _submit(task),
        ),
        const SizedBox(height: AppSpacing.md),
        _ProgressTree(stage: stage),
      ],
    );
  }
}

/// Görev yokken gösterilen kutlama kartı (web'in boş durumu).
class _AllDoneCard extends StatelessWidget {
  const _AllDoneCard();

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: colors.primary.withValues(alpha: .20)),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(Icons.emoji_events_outlined,
                color: colors.primary, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            t.tasks.wizardAllDoneTitle,
            style: text.titleSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            t.tasks.wizardAllDoneBody,
            style: text.bodySmall?.copyWith(color: colors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Üst banner: günlük akış rozeti + seviye kartı.
class _WizardHeader extends StatelessWidget {
  const _WizardHeader({
    required this.stage,
    required this.completed,
    required this.total,
  });

  final ExerciseStage stage;
  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: colors.primary.withValues(alpha: .18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, size: 16, color: colors.primary),
              const SizedBox(width: 6),
              Text(
                t.tasks.wizardBadge,
                style: text.labelSmall?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(t.tasks.wizardTitle, style: text.titleMedium),
          const SizedBox(height: 4),
          Text(
            t.tasks.wizardIntro,
            style: text.bodySmall?.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: colors.border),
            ),
            child: Row(
              children: [
                Text(stage.emoji, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.tasks.wizardStageLevel(
                          label: stageLabel(context, stage),
                        ),
                        style: text.labelLarge,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        t.tasks.wizardStageCount(
                          done: completed,
                          total: total,
                        ),
                        style: text.labelSmall
                            ?.copyWith(color: colors.textSecondary),
                      ),
                    ],
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

/// Aktif egzersiz kartı: adım sayacı, uygulama rehberi, sonuç seçimi,
/// ipucu, not + fotoğraf ve teslim butonu.
class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({
    required this.task,
    required this.index,
    required this.total,
    required this.note,
    required this.outcome,
    required this.evidenceUrl,
    required this.uploading,
    required this.submitting,
    required this.onPrev,
    required this.onNext,
    required this.onOutcome,
    required this.onPickEvidence,
    required this.onRemoveEvidence,
    required this.onSubmit,
  });

  final ExpertTask task;
  final int index;
  final int total;
  final TextEditingController note;
  final ExerciseOutcome? outcome;
  final String? evidenceUrl;
  final bool uploading;
  final bool submitting;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final ValueChanged<ExerciseOutcome> onOutcome;
  final VoidCallback onPickEvidence;
  final VoidCallback onRemoveEvidence;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final description = (task.description ?? '').trim();
    final busy = submitting || uploading;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: .08),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  t.tasks.wizardStepCounter(index: index + 1, total: total),
                  style: text.labelMedium?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: onPrev,
                icon: const Icon(Icons.chevron_left),
                tooltip: t.tasks.wizardPrev,
              ),
              IconButton(
                onPressed: onNext,
                icon: const Icon(Icons.chevron_right),
                tooltip: t.tasks.wizardNext,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            // Kategori uzmanın serbest metni; yoksa genel etiket.
            (task.category ?? '').trim().isNotEmpty
                ? task.category!.trim()
                : t.tasks.wizardDefaultCategory,
            style: text.labelSmall?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(task.title, style: text.titleSmall),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.flag_outlined, size: 15, color: colors.primary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        t.tasks.wizardHowTo,
                        style: text.labelSmall?.copyWith(
                          color: colors.textSecondary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  description.isNotEmpty
                      ? description
                      : t.tasks.wizardDefaultDescription,
                  style: text.bodySmall,
                ),
                if (task.frequency case final frequency?
                    when frequency.trim().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.repeat, size: 13, color: colors.primary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          t.tasks.wizardFrequency(value: frequency.trim()),
                          style: text.labelSmall?.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
          if (task.isCompleted)
            _DoneNotice(hasNext: onNext != null)
          else ...[
            Text(
              t.tasks.wizardOutcomeQuestion,
              style: text.labelMedium?.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: 8),
            for (final option in ExerciseOutcome.values) ...[
              _OutcomeTile(
                outcome: option,
                selected: outcome == option,
                enabled: !busy,
                onTap: () => onOutcome(option),
              ),
              const SizedBox(height: 8),
            ],
            if (outcome == ExerciseOutcome.hard) ...[
              const SizedBox(height: 2),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.warning.withValues(alpha: .10),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border:
                      Border.all(color: colors.warning.withValues(alpha: .30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb_outline,
                            size: 16, color: colors.warning),
                        const SizedBox(width: 6),
                        Text(
                          t.tasks.wizardTipTitle,
                          style: text.labelSmall?.copyWith(
                            color: colors.warning,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(t.tasks.wizardTipBody, style: text.bodySmall),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 4),
            Text(
              t.tasks.wizardNoteLabel,
              style: text.labelMedium?.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: note,
              enabled: !busy,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(hintText: t.tasks.wizardNoteHint),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: busy ? null : onPickEvidence,
                    icon: uploading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.add_a_photo_outlined, size: 18),
                    label: Text(
                      evidenceUrl == null
                          ? t.tasks.wizardAddPhoto
                          : t.tasks.wizardChangePhoto,
                    ),
                  ),
                ),
              ],
            ),
            if (evidenceUrl != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.attachment, size: 15, color: colors.success),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      t.tasks.wizardPhotoAdded,
                      style: text.labelSmall?.copyWith(
                        color: colors.success,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: busy ? null : onRemoveEvidence,
                    child: Text(t.tasks.wizardRemovePhoto),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: outcome == null || busy ? null : onSubmit,
                icon: submitting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check_circle_outline, size: 18),
                label: Text(t.tasks.wizardSubmit),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Tamamlanmış görevde sonuç formu yerine gösterilen bilgi kutusu.
class _DoneNotice extends StatelessWidget {
  const _DoneNotice({required this.hasNext});

  final bool hasNext;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.success.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, size: 18, color: colors.success),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.tasks.wizardDone,
                  style: text.labelMedium?.copyWith(
                    color: colors.success,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (hasNext) ...[
                  const SizedBox(height: 2),
                  Text(
                    t.tasks.wizardDoneHint,
                    style:
                        text.labelSmall?.copyWith(color: colors.textSecondary),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// "Bugün bu egzersiz nasıl geçti?" seçenekleri.
class _OutcomeTile extends StatelessWidget {
  const _OutcomeTile({
    required this.outcome,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final ExerciseOutcome outcome;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final (emoji, title, description, accent) = switch (outcome) {
      ExerciseOutcome.easy => (
          '🎉',
          t.tasks.outcomeEasyTitle,
          t.tasks.outcomeEasyDesc,
          colors.success,
        ),
      ExerciseOutcome.supported => (
          '🙂',
          t.tasks.outcomeSupportedTitle,
          t.tasks.outcomeSupportedDesc,
          colors.warning,
        ),
      ExerciseOutcome.hard => (
          '💬',
          t.tasks.outcomeHardTitle,
          t.tasks.outcomeHardDesc,
          colors.error,
        ),
    };

    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: enabled ? onTap : null,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected ? accent.withValues(alpha: .08) : colors.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: selected ? accent : colors.border,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: text.labelLarge?.copyWith(
                        color: selected ? accent : colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: text.labelSmall
                          ?.copyWith(color: colors.textSecondary),
                    ),
                  ],
                ),
              ),
              if (selected)
                Icon(Icons.check_circle, size: 20, color: accent),
            ],
          ),
        ),
      ),
    );
  }
}

/// İlerleme ağacı — ulaşılan seviyeler renkli, sonrakiler soluk.
class _ProgressTree extends StatelessWidget {
  const _ProgressTree({required this.stage});

  final ExerciseStage stage;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.emoji_events_outlined,
                  size: 18, color: colors.warning),
              const SizedBox(width: 6),
              Expanded(
                child: Text(t.tasks.wizardTreeTitle, style: text.titleSmall),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final value in ExerciseStage.values) ...[
            Opacity(
              opacity: value.index <= stage.index ? 1 : .45,
              child: Row(
                children: [
                  Text(value.emoji, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(stageLabel(context, value),
                            style: text.labelLarge),
                        const SizedBox(height: 2),
                        Text(
                          stageDescription(context, value),
                          style: text.labelSmall
                              ?.copyWith(color: colors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  if (value.index <= stage.index)
                    Icon(Icons.check_circle,
                        size: 18, color: colors.success),
                ],
              ),
            ),
            if (value != ExerciseStage.values.last)
              const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

/// Seviye etiketi (arayüz metni — sonuç öneklerinin aksine çevrilir).
String stageLabel(BuildContext context, ExerciseStage stage) {
  final t = context.t;
  return switch (stage) {
    ExerciseStage.seed => t.tasks.stageSeed,
    ExerciseStage.sprout => t.tasks.stageSprout,
    ExerciseStage.flower => t.tasks.stageFlower,
    ExerciseStage.tree => t.tasks.stageTree,
  };
}

String stageDescription(BuildContext context, ExerciseStage stage) {
  final t = context.t;
  return switch (stage) {
    ExerciseStage.seed => t.tasks.stageSeedDesc,
    ExerciseStage.sprout => t.tasks.stageSproutDesc,
    ExerciseStage.flower => t.tasks.stageFlowerDesc,
    ExerciseStage.tree => t.tasks.stageTreeDesc,
  };
}
