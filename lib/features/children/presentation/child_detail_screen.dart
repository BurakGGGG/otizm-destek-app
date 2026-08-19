import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/haptics.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/media.dart';
import '../../../core/network/upload_repository.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../i18n/strings.g.dart';
import '../data/child_repository.dart';
import '../data/milestone_repository.dart';
import '../data/screening_repository.dart';
import '../domain/child.dart';
import '../domain/milestone.dart';
import 'child_form_screen.dart';
import 'widgets/milestone_sheet.dart';
import '../../tags/data/tag_repository.dart';

/// Tarama risk kodunun i18n etiketi + rengi.
({String label, Color color}) screeningRisk(
    BuildContext context, String? risk) {
  final t = context.t;
  final colors = context.colors;
  return switch (risk) {
    'LOW' => (label: t.childDetail.riskLow, color: colors.success),
    'MEDIUM' => (label: t.childDetail.riskMedium, color: colors.warning),
    'HIGH' => (label: t.childDetail.riskHigh, color: colors.error),
    _ => (label: risk ?? '', color: colors.textSecondary),
  };
}

/// Çocuk detay paneli (web `/cocuklarim/:id` özgün bölümleri): foto,
/// profil bilgileri, semptom etiketleri, kilometre taşları, tarama sonuçları
/// ve mevcut ekranlara kısayollar. Diğer web bölümlerinin (duygu/uyku/ilaç/
/// davranış/notlar) mobilde kendi ekranları var.
class ChildDetailScreen extends ConsumerStatefulWidget {
  const ChildDetailScreen({super.key, required this.childId});

  final String childId;

  @override
  ConsumerState<ChildDetailScreen> createState() => _ChildDetailScreenState();
}

class _ChildDetailScreenState extends ConsumerState<ChildDetailScreen> {
  bool _uploadingPhoto = false;

  Future<void> _changePhoto(Child child) async {
    final t = context.t;
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      imageQuality: 85,
    );
    if (picked == null || !mounted) return;
    setState(() => _uploadingPhoto = true);
    try {
      final url = await ref.read(uploadRepositoryProvider).upload(
            picked.path,
            picked.name,
            scope: UploadScope(type: 'CHILD_PROFILE', id: child.id),
          );
      await ref.read(childRepositoryProvider).updatePhoto(child, url);
      if (!mounted) return;
      setState(() => _uploadingPhoto = false);
      ref.invalidate(childProvider(widget.childId));
      ref.invalidate(childrenProvider);
      Haptics.success();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.childDetail.photoUpdated)));
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _uploadingPhoto = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _editProfile(Child child) async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => ChildFormScreen(child: child)),
    );
    if (!mounted) return;
    ref.invalidate(childProvider(widget.childId));
    if (result != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result)));
    }
  }

  Future<void> _editTags(Child child) async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _TagEditSheet(child: child),
    );
    if (saved == true && mounted) {
      ref.invalidate(childProvider(widget.childId));
      Haptics.success();
    }
  }

  Future<void> _openMilestoneSheet({Milestone? existing}) async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) =>
          MilestoneSheet(childId: widget.childId, existing: existing),
    );
    if (saved == true && mounted) {
      ref.invalidate(milestonesProvider(widget.childId));
    }
  }

  Future<void> _deleteMilestone(Milestone milestone) async {
    final t = context.t;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.childDetail.milestoneDeleteTitle),
        content: Text(t.childDetail.milestoneDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(t.childDetail.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(t.childDetail.delete),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      await ref.read(milestoneRepositoryProvider).delete(milestone.id);
      if (!mounted) return;
      Haptics.warning();
      ref.invalidate(milestonesProvider(widget.childId));
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _refresh() async {
    ref.invalidate(childProvider(widget.childId));
    ref.invalidate(milestonesProvider(widget.childId));
    ref.invalidate(screeningResultsProvider(widget.childId));
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final async = ref.watch(childProvider(widget.childId));

    return Scaffold(
      appBar: AppBar(
        title: Text(async.value?.name ?? t.childDetail.title),
        actions: [
          if (async.value case final child?)
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              tooltip: t.childDetail.editProfile,
              onPressed: () => _editProfile(child),
            ),
        ],
      ),
      body: SafeArea(
        child: async.when(
          loading: () => const SkeletonList(count: 4),
          error: (e, _) => Center(
            child: TextButton(
              onPressed: _refresh,
              child: Text(t.common.retry),
            ),
          ),
          data: (child) => RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.margin,
                AppSpacing.md,
                AppSpacing.margin,
                40,
              ),
              children: [
                _Header(
                  child: child,
                  uploading: _uploadingPhoto,
                  onChangePhoto: () => _changePhoto(child),
                ),
                const SizedBox(height: AppSpacing.md),
                _InfoCard(child: child),
                const SizedBox(height: AppSpacing.md),
                _TagsCard(child: child, onEdit: () => _editTags(child)),
                const SizedBox(height: AppSpacing.md),
                _MilestonesCard(
                  childId: widget.childId,
                  onAdd: () => _openMilestoneSheet(),
                  onEdit: (m) => _openMilestoneSheet(existing: m),
                  onDelete: _deleteMilestone,
                ),
                const SizedBox(height: AppSpacing.md),
                _ScreeningCard(childId: widget.childId),
                const SizedBox(height: AppSpacing.md),
                _ShortcutsCard(childName: child.name),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header({
    required this.child,
    required this.uploading,
    required this.onChangePhoto,
  });

  final Child child;
  final bool uploading;
  final VoidCallback onChangePhoto;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final photo = mediaImageProvider(
      child.profileImageUrl,
      ref.watch(dioProvider),
    );
    final age = child.ageYears;

    return Row(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: colors.primary.withValues(alpha: .12),
              backgroundImage: photo,
              child: photo == null
                  ? Text(
                      child.name.isNotEmpty
                          ? child.name.characters.first.toUpperCase()
                          : '?',
                      style: text.headlineSmall
                          ?.copyWith(color: colors.primary),
                    )
                  : null,
            ),
            Positioned(
              right: -2,
              bottom: -2,
              child: Material(
                color: colors.primary,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: uploading ? null : onChangePhoto,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: uploading
                        ? SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colors.onPrimary,
                            ),
                          )
                        : Icon(Icons.photo_camera_outlined,
                            size: 14, color: colors.onPrimary),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(child.name, style: text.titleLarge),
              const SizedBox(height: 4),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  if (age != null)
                    _Chip(
                      label: t.childDetail.ageYears(age: age),
                      color: colors.primary,
                    ),
                  if (child.gender case final gender?
                      when gender.isNotEmpty)
                    _Chip(
                      label: gender == 'ERKEK'
                          ? t.childDetail.genderBoy
                          : gender == 'KIZ'
                              ? t.childDetail.genderGirl
                              : gender,
                      color: colors.secondary,
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.child});

  final Child child;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final rows = [
      (t.childDetail.diagnosis, child.diagnosisInfo),
      (t.childDetail.educationProgram, child.educationProgram),
      (t.childDetail.therapies, child.therapies),
    ].where((r) => r.$2 != null && r.$2!.trim().isNotEmpty).toList();

    return _SectionCard(
      icon: Icons.badge_outlined,
      title: t.childDetail.infoTitle,
      child: rows.isEmpty
          ? _EmptyText(t.childDetail.infoEmpty)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final (label, value) in rows) ...[
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: context.colors.textTertiary,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(value!,
                      style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 8),
                ],
              ],
            ),
    );
  }
}

class _TagsCard extends StatelessWidget {
  const _TagsCard({required this.child, required this.onEdit});

  final Child child;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;

    return _SectionCard(
      icon: Icons.sell_outlined,
      title: t.childDetail.tagsTitle,
      action: TextButton(
        onPressed: onEdit,
        child: Text(t.childDetail.edit),
      ),
      child: child.tags.isEmpty
          ? _EmptyText(t.childDetail.tagsEmpty)
          : Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final tag in child.tags)
                  _Chip(label: tag.name, color: colors.secondary),
              ],
            ),
    );
  }
}

class _MilestonesCard extends ConsumerWidget {
  const _MilestonesCard({
    required this.childId,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  final String childId;
  final VoidCallback onAdd;
  final ValueChanged<Milestone> onEdit;
  final ValueChanged<Milestone> onDelete;

  static const _icons = {
    'İletişim': Icons.chat_bubble_outline,
    'Sosyal': Icons.group_outlined,
    'Duyusal': Icons.visibility_outlined,
    'Davranış': Icons.bolt_outlined,
    'Motor': Icons.directions_run_outlined,
    'Eğitim': Icons.school_outlined,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final async = ref.watch(milestonesProvider(childId));

    return _SectionCard(
      icon: Icons.star_outline,
      title: t.childDetail.milestonesTitle,
      action: TextButton.icon(
        onPressed: onAdd,
        icon: const Icon(Icons.add, size: 16),
        label: Text(t.childDetail.milestoneAdd),
      ),
      child: async.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(12),
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        error: (e, _) => _EmptyText(t.childDetail.milestonesError),
        data: (milestones) {
          if (milestones.isEmpty) {
            return _EmptyText(t.childDetail.milestonesEmpty);
          }
          final sorted = [...milestones]..sort((a, b) =>
              (b.achievedDate ?? b.createdAt ?? DateTime(0)).compareTo(
                  a.achievedDate ?? a.createdAt ?? DateTime(0)));
          return Column(
            children: [
              for (final milestone in sorted)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colors.warning.withValues(alpha: .10),
                          borderRadius:
                              BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Icon(
                          _icons[milestone.category] ?? Icons.star_outline,
                          size: 16,
                          color: colors.warning,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(milestone.title,
                                style: text.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w700)),
                            if (milestone.description
                                case final description?
                                when description.trim().isNotEmpty)
                              Text(description, style: text.bodySmall),
                            const SizedBox(height: 2),
                            Wrap(
                              spacing: 6,
                              children: [
                                if (milestone.category
                                    case final category?
                                    when category.isNotEmpty)
                                  // Kategori paylaşılan Türkçe veri.
                                  _Chip(
                                      label: category,
                                      color: colors.textSecondary),
                                if (milestone.achievedDate
                                    case final date?)
                                  Text(
                                    '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}',
                                    style: text.labelSmall?.copyWith(
                                        color: colors.textTertiary),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 15),
                        visualDensity: VisualDensity.compact,
                        onPressed: () => onEdit(milestone),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 15),
                        visualDensity: VisualDensity.compact,
                        onPressed: () => onDelete(milestone),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ScreeningCard extends ConsumerWidget {
  const _ScreeningCard({required this.childId});

  final String childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final async = ref.watch(screeningResultsProvider(childId));

    return _SectionCard(
      icon: Icons.fact_check_outlined,
      title: t.childDetail.screeningTitle,
      child: async.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(12),
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        error: (e, _) => _EmptyText(t.childDetail.screeningEmpty),
        data: (results) {
          if (results.isEmpty) {
            return _EmptyText(t.childDetail.screeningEmpty);
          }
          return Column(
            children: [
              for (final result in results.take(5))
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(result.testType,
                                style: text.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w700)),
                            if (result.createdAt case final date?)
                              Text(
                                '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}',
                                style: text.labelSmall?.copyWith(
                                    color: colors.textTertiary),
                              ),
                          ],
                        ),
                      ),
                      Text(
                        t.childDetail.scoreOf(score: result.score),
                        style: text.labelMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(width: 8),
                      Builder(builder: (context) {
                        final risk =
                            screeningRisk(context, result.riskLevel);
                        return _Chip(label: risk.label, color: risk.color);
                      }),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ShortcutsCard extends StatelessWidget {
  const _ShortcutsCard({required this.childName});

  final String childName;

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return _SectionCard(
      icon: Icons.apps_outlined,
      title: t.childDetail.shortcutsTitle,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final (label, icon, route) in [
            (t.childDetail.shortcutTracker, Icons.track_changes_outlined,
                '/daily-tracker'),
            (t.childDetail.shortcutBehavior, Icons.psychology_outlined,
                '/behavior'),
            (t.childDetail.shortcutTreatment,
                Icons.volunteer_activism_outlined, '/treatment'),
            (t.childDetail.shortcutAnalytics, Icons.insights_outlined,
                '/analytics'),
          ])
            ActionChip(
              avatar: Icon(icon, size: 16),
              label: Text(label),
              onPressed: () => context.push(route),
            ),
        ],
      ),
    );
  }
}

/// Etiket düzenleme sayfası: `/tags/grouped` içinden çoklu seçim,
/// kaydette tam gövde + `tagIds` PUT edilir (web birebir).
class _TagEditSheet extends ConsumerStatefulWidget {
  const _TagEditSheet({required this.child});

  final Child child;

  @override
  ConsumerState<_TagEditSheet> createState() => _TagEditSheetState();
}

class _TagEditSheetState extends ConsumerState<_TagEditSheet> {
  late final Set<String> _selected;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _selected = widget.child.tags.map((tag) => tag.id).toSet();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ref
          .read(childRepositoryProvider)
          .updateTags(widget.child, _selected.toList());
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  /// Etiket kategori kodu etiketi (forumdaki ile aynı kod seti).
  String _categoryLabel(Translations t, String category) {
    return switch (category) {
      'ILETISIM' => t.forum.catCommunication,
      'SOSYAL' => t.forum.catSocial,
      'DUYUSAL' => t.forum.catSensory,
      'DAVRANIS' => t.forum.catBehavior,
      'MOTOR' => t.forum.catMotor,
      'EGITIM' => t.forum.catEducation,
      _ => category,
    };
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final tagsAsync = ref.watch(symptomTagsGroupedProvider);

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.margin,
        right: AppSpacing.margin,
        top: AppSpacing.md,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.childDetail.tagsEdit, style: text.titleMedium),
          const SizedBox(height: 12),
          Flexible(
            child: tagsAsync.when(
              loading: () => const LinearProgressIndicator(minHeight: 2),
              error: (e, _) => _EmptyText(t.childDetail.tagsError),
              data: (grouped) => SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final entry in grouped.entries) ...[
                      Text(
                        _categoryLabel(t, entry.key),
                        style: text.labelSmall?.copyWith(
                          color: colors.textTertiary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          for (final tag in entry.value)
                            FilterChip(
                              label: Text(tag.name),
                              visualDensity: VisualDensity.compact,
                              selected: _selected.contains(tag.id),
                              onSelected: _saving
                                  ? null
                                  : (_) => setState(() {
                                        if (!_selected.add(tag.id)) {
                                          _selected.remove(tag.id);
                                        }
                                      }),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(t.childDetail.save),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
    this.action,
  });

  final IconData icon;
  final String title;
  final Widget child;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

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
              Icon(icon, size: 18, color: colors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              ?action,
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _EmptyText extends StatelessWidget {
  const _EmptyText(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: Theme.of(context)
          .textTheme
          .bodySmall
          ?.copyWith(color: context.colors.textTertiary),
    );
  }
}
