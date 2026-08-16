import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/haptics.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../../../../i18n/strings.g.dart';
import '../../../auth/presentation/auth_controller.dart';
import '../../data/expert_repository.dart';
import '../../domain/expert.dart';
import '../../domain/expert_review.dart';

/// Uzman değerlendirmeleri (web ExpertsPage "Değerlendirmeler" sekmesi):
/// ortalama puan, yorum listesi ve velinin kendi değerlendirmesi
/// (yazma/güncelleme/silme — backend kullanıcı başına tek kayıt tutar).
class ExpertReviewsSection extends ConsumerWidget {
  const ExpertReviewsSection({
    super.key,
    required this.expert,
    required this.canReview,
  });

  final Expert expert;
  final bool canReview;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final async = ref.watch(expertReviewsProvider(expert.id));
    final userId = ref.watch(authControllerProvider).user?.id;
    final summary = async.asData?.value ?? ExpertReviewSummary.empty;
    final mine = summary.mine(userId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                t.reviews.title(count: summary.totalCount),
                style: text.titleSmall,
              ),
            ),
            if (summary.totalCount > 0) ...[
              Icon(Icons.star_rounded, size: 18, color: colors.warning),
              const SizedBox(width: 4),
              Text(
                summary.averageRating.toStringAsFixed(1),
                style: text.titleSmall?.copyWith(color: colors.warning),
              ),
            ],
          ],
        ),
        const SizedBox(height: 10),
        if (canReview)
          OutlinedButton.icon(
            onPressed: () => _openReviewSheet(context, ref, mine),
            icon: Icon(
              mine == null ? Icons.rate_review_outlined : Icons.edit_outlined,
              size: 18,
            ),
            label: Text(mine == null ? t.reviews.write : t.reviews.edit),
          ),
        if (async.isLoading && summary.totalCount == 0)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          )
        else if (summary.reviews.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              t.reviews.empty,
              style: text.bodySmall?.copyWith(color: colors.textTertiary),
            ),
          ),
        for (final review in summary.reviews) ...[
          const SizedBox(height: 10),
          _ReviewCard(
            review: review,
            isMine: review.reviewerId != null && review.reviewerId == userId,
            onDelete: () => _delete(context, ref, review),
          ),
        ],
      ],
    );
  }

  Future<void> _openReviewSheet(
    BuildContext context,
    WidgetRef ref,
    ExpertReview? existing,
  ) async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _ReviewSheet(expertId: expert.id, existing: existing),
    );
    if (saved == true) ref.invalidate(expertReviewsProvider(expert.id));
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    ExpertReview review,
  ) async {
    final t = context.t;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.reviews.deleteTitle),
        content: Text(t.reviews.deleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(t.common.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(t.reviews.delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      await ref
          .read(expertRepositoryProvider)
          .deleteReview(expert.id, review.id);
      ref.invalidate(expertReviewsProvider(expert.id));
    } on ApiException catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({
    required this.review,
    required this.isMine,
    required this.onDelete,
  });

  final ExpertReview review;
  final bool isMine;
  final VoidCallback onDelete;

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
              UserAvatar(
                name: review.reviewerName ?? '',
                imageUrl: review.reviewerImageUrl,
                radius: 16,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.reviewerName ?? t.reviews.someone,
                      style: text.labelLarge,
                    ),
                    _Stars(rating: review.rating),
                  ],
                ),
              ),
              if (isMine)
                IconButton(
                  tooltip: t.reviews.delete,
                  onPressed: onDelete,
                  icon: Icon(Icons.delete_outline,
                      size: 18, color: colors.textTertiary),
                ),
            ],
          ),
          if (review.comment case final comment? when comment.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(comment, style: text.bodySmall),
          ],
        ],
      ),
    );
  }
}

class _Stars extends StatelessWidget {
  const _Stars({required this.rating});
  final int rating;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 1; i <= 5; i++)
          Icon(
            i <= rating ? Icons.star_rounded : Icons.star_border_rounded,
            size: 15,
            color: i <= rating ? colors.warning : colors.textTertiary,
          ),
      ],
    );
  }
}

/// Değerlendirme yazma/düzenleme sayfası (1-5 yıldız + isteğe bağlı yorum).
class _ReviewSheet extends ConsumerStatefulWidget {
  const _ReviewSheet({required this.expertId, required this.existing});

  final String expertId;
  final ExpertReview? existing;

  @override
  ConsumerState<_ReviewSheet> createState() => _ReviewSheetState();
}

class _ReviewSheetState extends ConsumerState<_ReviewSheet> {
  late int _rating = widget.existing?.rating ?? 0;
  late final _comment =
      TextEditingController(text: widget.existing?.comment ?? '');
  bool _saving = false;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_rating < 1) return;
    setState(() => _saving = true);
    try {
      await ref.read(expertRepositoryProvider).submitReview(
            widget.expertId,
            rating: _rating,
            comment: _comment.text,
          );
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.existing == null ? t.reviews.write : t.reviews.edit,
            style: text.titleMedium,
          ),
          const SizedBox(height: 12),
          Text(
            t.reviews.ratingLabel,
            style: text.labelMedium?.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              for (var i = 1; i <= 5; i++)
                IconButton(
                  onPressed: _saving ? null : () => setState(() => _rating = i),
                  icon: Icon(
                    i <= _rating
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    size: 30,
                    color: i <= _rating ? colors.warning : colors.textTertiary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _comment,
            enabled: !_saving,
            minLines: 2,
            maxLines: 5,
            decoration: InputDecoration(hintText: t.reviews.commentHint),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _rating < 1 || _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check, size: 18),
              label: Text(t.reviews.save),
            ),
          ),
        ],
      ),
    );
  }
}
