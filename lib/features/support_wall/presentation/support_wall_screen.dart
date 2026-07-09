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
import 'support_wall_detail_screen.dart';
import 'widgets/wall_post_sheet.dart';

/// Bir paylaşımın anlık `createdAt`'ini göreli metne çevirir (az önce / dk / sa / gün).
String wallRelativeTime(Translations t, DateTime? dt) {
  if (dt == null) return '';
  final diff = DateTime.now().difference(dt);
  if (diff.inMinutes < 1) return t.wall.justNow;
  if (diff.inMinutes < 60) return t.wall.minsAgo(count: diff.inMinutes);
  if (diff.inHours < 24) return t.wall.hoursAgo(count: diff.inHours);
  return t.wall.daysAgo(count: diff.inDays);
}

/// Dertleşme Duvarı — forum'un `SUPPORT_WALL` kategorisi (anonim paylaşım +
/// destek yorumları + beğeni). Veli tarafına yönelik topluluk desteği ekranı.
class SupportWallScreen extends ConsumerStatefulWidget {
  const SupportWallScreen({super.key});

  @override
  ConsumerState<SupportWallScreen> createState() => _SupportWallScreenState();
}

class _SupportWallScreenState extends ConsumerState<SupportWallScreen> {
  /// İyimser beğeni/destek üst-katmanı: post id → (destek sayısı, beğenildi mi).
  final Map<String, ({int count, bool liked})> _likeOverride = {};

  Future<void> _createPost() async {
    final t = context.t;
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const WallPostSheet(),
    );
    if (saved == true && mounted) {
      ref.invalidate(wallPostsProvider);
      Haptics.success();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.wall.posted)));
    }
  }

  Future<void> _toggleLike(WallPost post) async {
    final current = _likeOverride[post.id] ??
        (count: post.likeCount, liked: post.likedByMe);
    final next = current.liked
        ? (count: current.count - 1, liked: false)
        : (count: current.count + 1, liked: true);
    setState(() => _likeOverride[post.id] = next);
    Haptics.selection();
    try {
      await ref.read(wallRepositoryProvider).toggleLike(post.id);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _likeOverride[post.id] = current);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _editPost(WallPost post) async {
    final t = context.t;
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => WallPostSheet(existing: post),
    );
    if (saved == true && mounted) {
      ref.invalidate(wallPostsProvider);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.wall.updated)));
    }
  }

  Future<void> _deletePost(WallPost post) async {
    final t = context.t;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.wall.deleteTitle),
        content: Text(t.wall.deleteConfirm),
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
      await ref.read(wallRepositoryProvider).deletePost(post.id);
      if (!mounted) return;
      ref.invalidate(wallPostsProvider);
      Haptics.warning();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.wall.deleted)));
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final async = ref.watch(wallPostsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.wall.title)),
      body: SafeArea(
        child: async.when(
          loading: () => const SkeletonList(count: 4),
          error: (e, _) =>
              ErrorRetry(onRetry: () => ref.invalidate(wallPostsProvider)),
          data: (posts) {
            if (posts.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async => ref.invalidate(wallPostsProvider),
                child: ListView(
                  children: [
                    const _WallIntro(),
                    SizedBox(
                      height: 320,
                      child: EmptyState(
                        icon: Icons.forum_outlined,
                        message: t.wall.empty,
                        actionLabel: t.wall.add,
                        actionIcon: Icons.edit_outlined,
                        onAction: _createPost,
                      ),
                    ),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async => ref.invalidate(wallPostsProvider),
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.margin,
                  0,
                  AppSpacing.margin,
                  96,
                ),
                itemCount: posts.length + 1,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  if (i == 0) return const _WallIntro();
                  final post = posts[i - 1];
                  final ov = _likeOverride[post.id];
                  return _PostCard(
                    post: post,
                    likeCount: ov?.count ?? post.likeCount,
                    liked: ov?.liked ?? post.likedByMe,
                    onLike: () => _toggleLike(post),
                    onEdit: () => _editPost(post),
                    onDelete: () => _deletePost(post),
                    onOpen: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SupportWallDetailScreen(postId: post.id),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createPost,
        icon: const Icon(Icons.edit_outlined),
        label: Text(t.wall.add),
      ),
    );
  }
}

/// Duvar başlığı/altbaşlığı — listenin en üstünde bir kez gösterilir.
class _WallIntro extends StatelessWidget {
  const _WallIntro();

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.favorite_outline, color: context.colors.primary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              t.wall.subtitle,
              style: text.bodySmall?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tek bir duvar paylaşımı kartı: yazar/zaman, başlık, içerik önizleme,
/// destek (beğeni) + yorum sayacı; sahibiyse düzenle/sil menüsü.
class _PostCard extends StatelessWidget {
  const _PostCard({
    required this.post,
    required this.likeCount,
    required this.liked,
    required this.onLike,
    required this.onEdit,
    required this.onDelete,
    required this.onOpen,
  });

  final WallPost post;
  final int likeCount;
  final bool liked;
  final VoidCallback onLike;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final author = post.displayAuthor ?? t.wall.anonymousUser;

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: context.colors.primary.withValues(
                      alpha: 0.12,
                    ),
                    child: Icon(
                      post.anonymous ? Icons.person_outline : Icons.face,
                      size: 18,
                      color: context.colors.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          author,
                          style: text.labelLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          wallRelativeTime(t, post.createdAt),
                          style: text.labelSmall?.copyWith(
                            color: context.colors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (post.ownedByMe)
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_horiz,
                        color: context.colors.textTertiary,
                      ),
                      onSelected: (v) => v == 'edit' ? onEdit() : onDelete(),
                      itemBuilder: (_) => [
                        PopupMenuItem(value: 'edit', child: Text(t.wall.edit)),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text(t.wall.delete),
                        ),
                      ],
                    ),
                ],
              ),
              if (post.title.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(post.title, style: text.titleMedium),
              ],
              const SizedBox(height: 6),
              Text(
                post.content,
                style: text.bodyMedium?.copyWith(
                  color: context.colors.textSecondary,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _CountAction(
                    icon: liked ? Icons.favorite : Icons.favorite_border,
                    active: liked,
                    label: t.wall.supportCount(count: likeCount),
                    onTap: onLike,
                  ),
                  const SizedBox(width: 20),
                  _CountAction(
                    icon: Icons.mode_comment_outlined,
                    active: false,
                    label: t.wall.commentCount(count: post.commentCount),
                    onTap: onOpen,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountAction extends StatelessWidget {
  const _CountAction({
    required this.icon,
    required this.active,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final bool active;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? context.colors.primary : context.colors.textTertiary;
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.full),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
