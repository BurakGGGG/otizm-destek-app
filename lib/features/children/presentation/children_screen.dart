import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../i18n/strings.g.dart';
import '../data/child_repository.dart';
import '../domain/child.dart';
import 'child_form_screen.dart';

/// Çocuklarım — liste + ekle/düzenle/sil (`/api/children`).
class ChildrenScreen extends ConsumerWidget {
  const ChildrenScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final async = ref.watch(childrenProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.children.title)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.add),
        label: Text(t.children.add),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            _ErrorView(onRetry: () => ref.invalidate(childrenProvider)),
        data: (children) {
          if (children.isEmpty) {
            return _EmptyView(message: t.children.empty);
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(childrenProvider),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.margin, 8, AppSpacing.margin, 96),
              itemCount: children.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _ChildCard(
                child: children[i],
                onEdit: () => _openForm(context, child: children[i]),
                onDelete: () => _confirmDelete(context, ref, children[i]),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _openForm(BuildContext context, {Child? child}) async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => ChildFormScreen(child: child)),
    );
    if (result != null && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result)));
    }
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, Child child) async {
    final t = context.t;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.children.deleteTitle),
        content: Text(t.children.deleteConfirm(name: child.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(t.children.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(t.children.delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await ref.read(childRepositoryProvider).deleteChild(child.id);
      ref.invalidate(childrenProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(t.children.deleted)));
      }
    } on ApiException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }
}

class _ChildCard extends StatelessWidget {
  const _ChildCard({
    required this.child,
    required this.onEdit,
    required this.onDelete,
  });

  final Child child;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final age = child.ageYears;
    final subtitleParts = <String>[
      if (age != null) t.children.ageYears(years: age),
      if (child.gender == 'ERKEK') t.children.genderMale,
      if (child.gender == 'KIZ') t.children.genderFemale,
    ];
    final avatar = child.profileImageUrl;

    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg)),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.primary.withValues(alpha: 0.12),
          backgroundImage:
              (avatar?.isNotEmpty ?? false) ? NetworkImage(avatar!) : null,
          child: (avatar?.isEmpty ?? true)
              ? const Icon(Icons.child_care, color: AppColors.primary)
              : null,
        ),
        title: Text(child.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.titleMedium),
        subtitle: subtitleParts.isEmpty
            ? null
            : Text(subtitleParts.join(' · '),
                maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: PopupMenuButton<String>(
          onSelected: (v) => v == 'edit' ? onEdit() : onDelete(),
          itemBuilder: (_) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  const Icon(Icons.edit_outlined, size: 20),
                  const SizedBox(width: 12),
                  Text(t.children.editTitle),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  const Icon(Icons.delete_outline,
                      size: 20, color: AppColors.error),
                  const SizedBox(width: 12),
                  Text(t.children.delete,
                      style: const TextStyle(color: AppColors.error)),
                ],
              ),
            ),
          ],
        ),
        onTap: onEdit,
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const SizedBox(height: 12),
          Text(t.common.loadError),
          const SizedBox(height: 12),
          FilledButton.tonal(onPressed: onRetry, child: Text(t.common.retry)),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.child_care_outlined,
                size: 48, color: AppColors.textTertiary),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
