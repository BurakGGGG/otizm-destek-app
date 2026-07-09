import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/haptics.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../i18n/strings.g.dart';
import '../data/wall_repository.dart';
import '../domain/wall_post.dart';
import 'support_wall_screen.dart';

/// Dertleşme paylaşımı detayı — tam metin + destek mesajları (yorumlar) +
/// destek mesajı yazma. Beğeni iyimser güncellenir.
class SupportWallDetailScreen extends ConsumerStatefulWidget {
  const SupportWallDetailScreen({super.key, required this.postId});

  final String postId;

  @override
  ConsumerState<SupportWallDetailScreen> createState() =>
      _SupportWallDetailScreenState();
}

class _SupportWallDetailScreenState
    extends ConsumerState<SupportWallDetailScreen> {
  final TextEditingController _comment = TextEditingController();
  ({int count, bool liked})? _likeOverride;
  bool _sending = false;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _toggleLike(WallPost post) async {
    final current =
        _likeOverride ?? (count: post.likeCount, liked: post.likedByMe);
    final next = current.liked
        ? (count: current.count - 1, liked: false)
        : (count: current.count + 1, liked: true);
    setState(() => _likeOverride = next);
    Haptics.selection();
    try {
      await ref.read(wallRepositoryProvider).toggleLike(post.id);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _likeOverride = current);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _sendComment() async {
    final t = context.t;
    final content = _comment.text.trim();
    if (content.isEmpty) return;
    setState(() => _sending = true);
    try {
      await ref
          .read(wallRepositoryProvider)
          .createComment(widget.postId, content: content);
      if (!mounted) return;
      _comment.clear();
      FocusScope.of(context).unfocus();
      setState(() => _sending = false);
      ref.invalidate(wallCommentsProvider(widget.postId));
      ref.invalidate(wallPostProvider(widget.postId));
      Haptics.success();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.wall.commentSent)));
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _sending = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _deleteComment(WallComment comment) async {
    final t = context.t;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.wall.commentDeleteTitle),
        content: Text(t.wall.commentDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(t.wall.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(t.wall.delete),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref
          .read(wallRepositoryProvider)
          .deleteComment(widget.postId, comment.id);
      if (!mounted) return;
      ref.invalidate(wallCommentsProvider(widget.postId));
      ref.invalidate(wallPostProvider(widget.postId));
      Haptics.warning();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.wall.commentDeleted)));
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final postAsync = ref.watch(wallPostProvider(widget.postId));
    final commentsAsync = ref.watch(wallCommentsProvider(widget.postId));

    return Scaffold(
      appBar: AppBar(title: Text(t.wall.detailTitle)),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: postAsync.when(
                loading: () => const SkeletonList(count: 4),
                error: (e, _) => ErrorRetry(
                  onRetry: () =>
                      ref.invalidate(wallPostProvider(widget.postId)),
                ),
                data: (post) {
                  final ov = _likeOverride;
                  return RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(wallPostProvider(widget.postId));
                      ref.invalidate(wallCommentsProvider(widget.postId));
                    },
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.margin,
                        AppSpacing.md,
                        AppSpacing.margin,
                        24,
                      ),
                      children: [
                        _PostHeader(
                          post: post,
                          likeCount: ov?.count ?? post.likeCount,
                          liked: ov?.liked ?? post.likedByMe,
                          onLike: () => _toggleLike(post),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          t.wall.commentsTitle,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 12),
                        _CommentsList(
                          async: commentsAsync,
                          onDelete: _deleteComment,
                          onRetry: () => ref.invalidate(
                            wallCommentsProvider(widget.postId),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            _CommentComposer(
              controller: _comment,
              sending: _sending,
              onSend: _sendComment,
            ),
          ],
        ),
      ),
    );
  }
}

class _PostHeader extends StatelessWidget {
  const _PostHeader({
    required this.post,
    required this.likeCount,
    required this.liked,
    required this.onLike,
  });

  final WallPost post;
  final int likeCount;
  final bool liked;
  final VoidCallback onLike;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final author = post.displayAuthor ?? t.wall.anonymousUser;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor:
                      context.colors.primary.withValues(alpha: 0.12),
                  child: Icon(
                    post.anonymous ? Icons.person_outline : Icons.face,
                    color: context.colors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(author, style: text.labelLarge),
                      Text(
                        wallRelativeTime(t, post.createdAt),
                        style: text.labelSmall?.copyWith(
                          color: context.colors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (post.title.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(post.title, style: text.titleMedium),
            ],
            const SizedBox(height: 8),
            Text(post.content, style: text.bodyLarge),
            const Divider(height: 24),
            InkWell(
              borderRadius: BorderRadius.circular(AppRadius.full),
              onTap: onLike,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      liked ? Icons.favorite : Icons.favorite_border,
                      size: 20,
                      color: liked
                          ? context.colors.primary
                          : context.colors.textTertiary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      t.wall.supportCount(count: likeCount),
                      style: text.labelLarge?.copyWith(
                        color: liked
                            ? context.colors.primary
                            : context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommentsList extends StatelessWidget {
  const _CommentsList({
    required this.async,
    required this.onDelete,
    required this.onRetry,
  });

  final AsyncValue<List<WallComment>> async;
  final ValueChanged<WallComment> onDelete;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return async.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => ErrorRetry(onRetry: onRetry),
      data: (comments) {
        if (comments.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: EmptyState(
              icon: Icons.volunteer_activism_outlined,
              message: t.wall.commentEmpty,
            ),
          );
        }
        return Column(
          children: [
            for (final c in comments) ...[
              _CommentTile(comment: c, onDelete: () => onDelete(c)),
              const SizedBox(height: 10),
            ],
          ],
        );
      },
    );
  }
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({required this.comment, required this.onDelete});

  final WallComment comment;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final author = comment.displayAuthor ?? t.wall.anonymousUser;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.favorite,
                size: 14,
                color: context.colors.primary.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  author,
                  style: text.labelMedium?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ),
              Text(
                wallRelativeTime(t, comment.createdAt),
                style: text.labelSmall?.copyWith(
                  color: context.colors.textTertiary,
                ),
              ),
              if (comment.ownedByMe)
                InkWell(
                  onTap: onDelete,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: context.colors.textTertiary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(comment.content, style: text.bodyMedium),
        ],
      ),
    );
  }
}

class _CommentComposer extends StatelessWidget {
  const _CommentComposer({
    required this.controller,
    required this.sending,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool sending;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: 8,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 8,
      ),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(top: BorderSide(color: context.colors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: t.wall.commentHint,
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            onPressed: sending ? null : onSend,
            icon: sending
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send),
            tooltip: t.wall.commentSend,
          ),
        ],
      ),
    );
  }
}
