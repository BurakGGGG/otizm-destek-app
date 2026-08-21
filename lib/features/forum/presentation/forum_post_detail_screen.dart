import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/haptics.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/util/html_text.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../i18n/strings.g.dart';
import '../data/forum_repository.dart';
import '../domain/forum_post.dart';
import 'forum_screen.dart';
import 'widgets/forum_post_sheet.dart';
import '../../reports/data/report_repository.dart';

/// Forum gönderi detayı: tam metin, beğeni, etiketler; yorumlar (uzman onaylı
/// önce) + tek seviye yanıtlar + yorum oyları; soru sahibiyse "en iyi cevap"
/// işaretleme; kendi gönderi/yorumunu düzenleme-silme; şikayet.
class ForumPostDetailScreen extends ConsumerStatefulWidget {
  const ForumPostDetailScreen({super.key, required this.postId});

  final String postId;

  @override
  ConsumerState<ForumPostDetailScreen> createState() =>
      _ForumPostDetailScreenState();
}

class _ForumPostDetailScreenState
    extends ConsumerState<ForumPostDetailScreen> {
  ForumPost? _post;
  bool _loading = true;
  bool _error = false;

  final TextEditingController _comment = TextEditingController();
  ForumComment? _replyingTo;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final post =
          await ref.read(forumRepositoryProvider).getPost(widget.postId);
      if (!mounted) return;
      setState(() {
        _post = post;
        _loading = false;
        _error = false;
      });
      ref.invalidate(forumCommentsProvider(widget.postId));
    } on ApiException {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  Future<void> _toggleLike() async {
    final post = _post;
    if (post == null) return;
    setState(() {
      _post = post.copyWith(
        likedByMe: !post.likedByMe,
        likeCount: post.likedByMe ? post.likeCount - 1 : post.likeCount + 1,
      );
    });
    Haptics.selection();
    try {
      await ref.read(forumRepositoryProvider).toggleVote(
            targetType: 'POST',
            targetId: post.id,
            voteValue: 1,
          );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _post = post);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _voteComment(ForumComment comment, int value) async {
    Haptics.selection();
    try {
      await ref.read(forumRepositoryProvider).toggleVote(
            targetType: 'COMMENT',
            targetId: comment.id,
            voteValue: value,
          );
      ref.invalidate(forumCommentsProvider(widget.postId));
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _acceptAnswer(ForumComment comment) async {
    final t = context.t;
    try {
      final updated = await ref
          .read(forumRepositoryProvider)
          .acceptAnswer(widget.postId, comment.id);
      if (!mounted) return;
      setState(() => _post = updated);
      ref.invalidate(forumCommentsProvider(widget.postId));
      Haptics.success();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.forum.answerAccepted)));
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _sendComment() async {
    final content = _comment.text.trim();
    final post = _post;
    if (content.isEmpty || post == null || _sending) return;
    setState(() => _sending = true);
    try {
      await ref.read(forumRepositoryProvider).createComment(
            post.id,
            content: content,
            parentCommentId: _replyingTo?.id,
          );
      if (!mounted) return;
      _comment.clear();
      setState(() {
        _sending = false;
        _replyingTo = null;
        _post = post.copyWith(commentCount: post.commentCount + 1);
      });
      Haptics.success();
      ref.invalidate(forumCommentsProvider(post.id));
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _sending = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _editPost() async {
    final post = _post;
    if (post == null) return;
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ForumPostSheet(existing: post),
    );
    if (saved == true && mounted) await _load();
  }

  Future<void> _deletePost() async {
    final t = context.t;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.forum.deleteTitle),
        content: Text(t.forum.deleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(t.forum.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(t.forum.delete),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      await ref.read(forumRepositoryProvider).deletePost(widget.postId);
      if (!mounted) return;
      Haptics.warning();
      Navigator.of(context).pop();
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _editComment(ForumComment comment) async {
    final t = context.t;
    final controller = TextEditingController(text: comment.content);
    final content = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.forum.editComment),
        content: TextField(controller: controller, maxLines: 4, minLines: 2),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(t.forum.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
            child: Text(t.forum.save),
          ),
        ],
      ),
    );
    controller.dispose();
    if (content == null || content.isEmpty || !mounted) return;
    try {
      await ref
          .read(forumRepositoryProvider)
          .updateComment(widget.postId, comment.id, content);
      ref.invalidate(forumCommentsProvider(widget.postId));
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _deleteComment(ForumComment comment) async {
    final t = context.t;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.forum.deleteCommentTitle),
        content: Text(t.forum.deleteCommentConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(t.forum.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(t.forum.delete),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      await ref
          .read(forumRepositoryProvider)
          .deleteComment(widget.postId, comment.id);
      if (!mounted) return;
      final post = _post;
      if (post != null) {
        setState(() => _post = post.copyWith(
            commentCount:
                post.commentCount > 0 ? post.commentCount - 1 : 0));
      }
      ref.invalidate(forumCommentsProvider(widget.postId));
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _report(String targetType, String targetId) async {
    final t = context.t;
    final controller = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.forum.reportTitle),
        content: TextField(
          controller: controller,
          maxLines: 3,
          minLines: 2,
          decoration: InputDecoration(hintText: t.forum.reportHint),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(t.forum.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
            child: Text(t.forum.reportSend),
          ),
        ],
      ),
    );
    controller.dispose();
    if (reason == null || reason.isEmpty || !mounted) return;
    try {
      await ref.read(reportRepositoryProvider).create(
            targetType: targetType,
            targetId: targetId,
            reason: reason,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.forum.reportSent)));
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final post = _post;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.forum.postTitle),
        actions: [
          if (post != null && post.ownedByMe) ...[
            IconButton(
              tooltip: context.t.common.a11y.edit,
              icon: const Icon(Icons.edit_outlined, size: 20),
              onPressed: _editPost,
            ),
            IconButton(
              tooltip: context.t.common.a11y.delete,
              icon: const Icon(Icons.delete_outline, size: 20),
              onPressed: _deletePost,
            ),
          ] else if (post != null)
            IconButton(
              tooltip: t.forum.reportTitle,
              icon: const Icon(Icons.flag_outlined, size: 20),
              onPressed: () => _report('POST', post.id),
            ),
        ],
      ),
      body: SafeArea(
        child: _loading
            ? const SkeletonList(count: 3)
            : _error || post == null
                ? Center(
                    child: TextButton(
                      onPressed: _load,
                      child: Text(t.common.retry),
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: _load,
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
                                onLike: _toggleLike,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                t.forum.commentsHeader(
                                    count: post.commentCount),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall,
                              ),
                              const SizedBox(height: 8),
                              _CommentList(
                                postId: post.id,
                                post: post,
                                onVote: _voteComment,
                                onAccept: _acceptAnswer,
                                onReply: (c) =>
                                    setState(() => _replyingTo = c),
                                onEdit: _editComment,
                                onDelete: _deleteComment,
                                onReport: (c) =>
                                    _report('COMMENT', c.id),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: AppSpacing.margin,
                          right: AppSpacing.margin,
                          top: 8,
                          bottom:
                              MediaQuery.viewInsetsOf(context).bottom + 8,
                        ),
                        decoration: BoxDecoration(
                          color: colors.surface,
                          border:
                              Border(top: BorderSide(color: colors.border)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_replyingTo case final replying?)
                              Row(
                                children: [
                                  Icon(Icons.reply,
                                      size: 14,
                                      color: colors.textSecondary),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      t.forum.replyingTo(
                                        name: replying.displayAuthor ??
                                            t.forum.anonymousUser,
                                      ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                              color:
                                                  colors.textSecondary),
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: context.t.common.a11y.cancelReply,
                                    icon: const Icon(Icons.close, size: 14),
                                    visualDensity: VisualDensity.compact,
                                    onPressed: () =>
                                        setState(() => _replyingTo = null),
                                  ),
                                ],
                              ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _comment,
                                    enabled: !_sending,
                                    minLines: 1,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      hintText: _replyingTo == null
                                          ? t.forum.commentHint
                                          : t.forum.replyHint,
                                      isDense: true,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton.filled(
                                  tooltip: context.t.common.a11y.send,
                                  onPressed: _sending ? null : _sendComment,
                                  icon: _sending
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2),
                                        )
                                      : const Icon(Icons.send, size: 18),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}

/// Gönderi başlığı: rozetler, başlık, tam düz metin, etiketler, beğeni.
class _PostHeader extends StatelessWidget {
  const _PostHeader({required this.post, required this.onLike});

  final ForumPost post;
  final VoidCallback onLike;

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
          Wrap(
            spacing: 6,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                post.displayAuthor ?? t.forum.anonymousUser,
                style:
                    text.labelMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              if (post.authorIsExpert)
                _DetailBadge(
                    label: t.forum.expertBadge, color: colors.success),
              _DetailBadge(
                label: forumTypeLabel(t, post.postType),
                color: colors.primary,
              ),
              if (post.isQuestion && post.answered)
                _DetailBadge(
                    label: t.forum.answeredBadge, color: colors.success),
              Text(
                forumRelativeTime(t, post.createdAt),
                style: text.labelSmall?.copyWith(color: colors.textTertiary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(post.title, style: text.titleMedium),
          const SizedBox(height: 8),
          Text(htmlToPlainText(post.content), style: text.bodyMedium),
          if (post.tags.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                for (final tag in post.tags)
                  _DetailBadge(label: tag.name, color: colors.textSecondary),
              ],
            ),
          ],
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: onLike,
            icon: Icon(
              post.likedByMe ? Icons.favorite : Icons.favorite_outline,
              size: 16,
              color: post.likedByMe ? colors.error : null,
            ),
            label: Text('${post.likeCount}'),
          ),
        ],
      ),
    );
  }
}

/// Yorumlar: uzman onaylılar önce; tek seviye yanıt ağacı.
class _CommentList extends ConsumerWidget {
  const _CommentList({
    required this.postId,
    required this.post,
    required this.onVote,
    required this.onAccept,
    required this.onReply,
    required this.onEdit,
    required this.onDelete,
    required this.onReport,
  });

  final String postId;
  final ForumPost post;
  final void Function(ForumComment, int) onVote;
  final ValueChanged<ForumComment> onAccept;
  final ValueChanged<ForumComment> onReply;
  final ValueChanged<ForumComment> onEdit;
  final ValueChanged<ForumComment> onDelete;
  final ValueChanged<ForumComment> onReport;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final colors = context.colors;
    final async = ref.watch(forumCommentsProvider(postId));

    return async.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          t.forum.commentsError,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: colors.textTertiary),
        ),
      ),
      data: (comments) {
        if (comments.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                t.forum.noComments,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: colors.textTertiary),
              ),
            ),
          );
        }
        final topLevel = comments
            .where((c) => c.parentCommentId == null)
            .toList()
          ..sort((a, b) => (b.expertApproved ? 1 : 0)
              .compareTo(a.expertApproved ? 1 : 0));
        final replies = <String, List<ForumComment>>{};
        for (final c in comments) {
          final parent = c.parentCommentId;
          if (parent != null) (replies[parent] ??= []).add(c);
        }
        return Column(
          children: [
            for (final comment in topLevel) ...[
              _CommentTile(
                comment: comment,
                post: post,
                onVote: onVote,
                onAccept: onAccept,
                onReply: onReply,
                onEdit: onEdit,
                onDelete: onDelete,
                onReport: onReport,
              ),
              for (final reply in replies[comment.id] ?? const [])
                Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: _CommentTile(
                    comment: reply,
                    post: post,
                    isReply: true,
                    onVote: onVote,
                    onAccept: onAccept,
                    onReply: onReply,
                    onEdit: onEdit,
                    onDelete: onDelete,
                    onReport: onReport,
                  ),
                ),
            ],
          ],
        );
      },
    );
  }
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({
    required this.comment,
    required this.post,
    required this.onVote,
    required this.onAccept,
    required this.onReply,
    required this.onEdit,
    required this.onDelete,
    required this.onReport,
    this.isReply = false,
  });

  final ForumComment comment;
  final ForumPost post;
  final bool isReply;
  final void Function(ForumComment, int) onVote;
  final ValueChanged<ForumComment> onAccept;
  final ValueChanged<ForumComment> onReply;
  final ValueChanged<ForumComment> onEdit;
  final ValueChanged<ForumComment> onDelete;
  final ValueChanged<ForumComment> onReport;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final highlight = comment.expertApproved
        ? colors.secondary
        : comment.accepted
            ? colors.success
            : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: highlight?.withValues(alpha: .06) ?? colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: highlight?.withValues(alpha: .4) ?? colors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 6,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                comment.displayAuthor ?? t.forum.anonymousUser,
                style:
                    text.labelMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              if (comment.authorIsExpert)
                _DetailBadge(
                    label: t.forum.expertBadge, color: colors.success),
              if (comment.expertApproved)
                _DetailBadge(
                    label: t.forum.expertApproved, color: colors.secondary),
              if (comment.accepted)
                _DetailBadge(
                    label: t.forum.acceptedBadge, color: colors.success),
              Text(
                forumRelativeTime(t, comment.createdAt),
                style: text.labelSmall?.copyWith(color: colors.textTertiary),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(comment.content, style: text.bodySmall),
          const SizedBox(height: 6),
          Row(
            children: [
              _VoteButton(
                icon: Icons.keyboard_arrow_up,
                active: comment.upvotedByMe,
                onTap: () => onVote(comment, 1),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  '${comment.voteCount}',
                  style: text.labelSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              _VoteButton(
                icon: Icons.keyboard_arrow_down,
                active: comment.downvotedByMe,
                onTap: () => onVote(comment, -1),
              ),
              const SizedBox(width: 8),
              if (!isReply)
                TextButton(
                  onPressed: () => onReply(comment),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                  ),
                  child: Text(t.forum.reply,
                      style: text.labelSmall
                          ?.copyWith(fontWeight: FontWeight.w700)),
                ),
              if (post.isQuestion && post.ownedByMe && !comment.accepted)
                TextButton(
                  onPressed: () => onAccept(comment),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                  ),
                  child: Text(t.forum.acceptAnswer,
                      style: text.labelSmall?.copyWith(
                        color: colors.success,
                        fontWeight: FontWeight.w700,
                      )),
                ),
              const Spacer(),
              if (comment.ownedByMe) ...[
                IconButton(
                  tooltip: context.t.common.a11y.edit,
                  icon: const Icon(Icons.edit_outlined, size: 15),
                  visualDensity: VisualDensity.compact,
                  onPressed: () => onEdit(comment),
                ),
                IconButton(
                  tooltip: context.t.common.a11y.delete,
                  icon: const Icon(Icons.delete_outline, size: 15),
                  visualDensity: VisualDensity.compact,
                  onPressed: () => onDelete(comment),
                ),
              ] else
                IconButton(
                  tooltip: context.t.common.a11y.report,
                  icon: const Icon(Icons.flag_outlined, size: 15),
                  visualDensity: VisualDensity.compact,
                  onPressed: () => onReport(comment),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VoteButton extends StatelessWidget {
  const _VoteButton({
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: active
              ? colors.primary.withValues(alpha: .12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Icon(
          icon,
          size: 18,
          color: active ? colors.primary : colors.textSecondary,
        ),
      ),
    );
  }
}

class _DetailBadge extends StatelessWidget {
  const _DetailBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
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
