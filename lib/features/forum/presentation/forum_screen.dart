import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/haptics.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/util/html_text.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../i18n/strings.g.dart';
import '../data/forum_repository.dart';
import '../domain/forum_post.dart';
import 'forum_post_detail_screen.dart';
import 'widgets/forum_post_sheet.dart';

/// Gönderi tipi kodunun i18n etiketi.
String forumTypeLabel(Translations t, String type) {
  return switch (type) {
    'DENEYIM' => t.forum.typeExperience,
    'QUESTION' => t.forum.typeQuestion,
    'TAVSIYE' => t.forum.typeAdvice,
    'BASARI_HIKAYESI' => t.forum.typeSuccess,
    _ => type,
  };
}

/// Etiket kategori kodunun i18n etiketi.
String forumTagCategoryLabel(Translations t, String category) {
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

/// Göreli zaman (az önce / dk / sa / gün).
String forumRelativeTime(Translations t, DateTime? dt) {
  if (dt == null) return '';
  final diff = DateTime.now().difference(dt);
  if (diff.inMinutes < 1) return t.forum.justNow;
  if (diff.inMinutes < 60) return t.forum.minsAgo(count: diff.inMinutes);
  if (diff.inHours < 24) return t.forum.hoursAgo(count: diff.inHours);
  return t.forum.daysAgo(count: diff.inDays);
}

/// Topluluk Forumu — web ForumPage birebir: 4 gönderi tipi sekmesi, arama,
/// sıralama (yeni/sıcak/cevapsız/uzmanlı), semptom etiketi filtresi, sayfalı
/// liste, gönderi detayı (yorum + yanıt + oy + en iyi cevap).
class ForumScreen extends ConsumerStatefulWidget {
  const ForumScreen({super.key});

  @override
  ConsumerState<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends ConsumerState<ForumScreen> {
  String _type = 'DENEYIM';
  String _sort = 'new';
  final Set<String> _tagIds = {};
  final TextEditingController _search = TextEditingController();
  String _appliedSearch = '';
  bool _showTagFilter = false;

  List<ForumPost> _posts = const [];
  int _page = 0;
  int _totalPages = 1;
  bool _loading = true;
  bool _loadingMore = false;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = false;
    });
    try {
      final result = await ref.read(forumRepositoryProvider).getPosts(
            type: _type,
            tagIds: _tagIds.toList(),
            query: _appliedSearch,
            sort: _sort,
          );
      if (!mounted) return;
      setState(() {
        _posts = result.posts;
        _page = 0;
        _totalPages = result.totalPages;
        _loading = false;
      });
    } on ApiException {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  Future<void> _loadMore() async {
    if (_loadingMore || _page >= _totalPages - 1) return;
    setState(() => _loadingMore = true);
    try {
      final result = await ref.read(forumRepositoryProvider).getPosts(
            type: _type,
            tagIds: _tagIds.toList(),
            query: _appliedSearch,
            sort: _sort,
            page: _page + 1,
          );
      if (!mounted) return;
      setState(() {
        _posts = [..._posts, ...result.posts];
        _page += 1;
        _totalPages = result.totalPages;
        _loadingMore = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _loadingMore = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _toggleLike(ForumPost post) async {
    final index = _posts.indexWhere((p) => p.id == post.id);
    if (index < 0) return;
    final next = post.copyWith(
      likedByMe: !post.likedByMe,
      likeCount: post.likedByMe ? post.likeCount - 1 : post.likeCount + 1,
    );
    setState(() => _posts = [..._posts]..[index] = next);
    Haptics.selection();
    try {
      await ref.read(forumRepositoryProvider).toggleVote(
            targetType: 'POST',
            targetId: post.id,
            voteValue: 1,
          );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _posts = [..._posts]..[index] = post);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _createPost() async {
    final t = context.t;
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ForumPostSheet(initialType: _type),
    );
    if (saved == true && mounted) {
      Haptics.success();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.forum.posted)));
      await _load();
    }
  }

  Future<void> _openDetail(ForumPost post) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ForumPostDetailScreen(postId: post.id),
      ),
    );
    if (mounted) await _load();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final tagsAsync = ref.watch(forumTagsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.forum.title)),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.margin,
                AppSpacing.sm,
                AppSpacing.margin,
                0,
              ),
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final type in kForumPostTypes) ...[
                          ChoiceChip(
                            label: Text(forumTypeLabel(t, type)),
                            selected: _type == type,
                            onSelected: (_) {
                              setState(() => _type = type);
                              _load();
                            },
                          ),
                          const SizedBox(width: 8),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _search,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (v) {
                            _appliedSearch = v.trim();
                            _load();
                          },
                          decoration: InputDecoration(
                            hintText: t.forum.searchHint,
                            prefixIcon: const Icon(Icons.search, size: 18),
                            isDense: true,
                            suffixIcon: _appliedSearch.isEmpty
                                ? null
                                : IconButton(
                                    icon: const Icon(Icons.close, size: 16),
                                    onPressed: () {
                                      _search.clear();
                                      _appliedSearch = '';
                                      _load();
                                    },
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        tooltip: t.forum.tagFilter,
                        onPressed: () => setState(
                            () => _showTagFilter = !_showTagFilter),
                        icon: Badge(
                          isLabelVisible: _tagIds.isNotEmpty,
                          label: Text('${_tagIds.length}'),
                          child: Icon(
                            Icons.sell_outlined,
                            color: _showTagFilter || _tagIds.isNotEmpty
                                ? colors.primary
                                : colors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final sort in kForumSortModes) ...[
                          ChoiceChip(
                            label: Text(switch (sort) {
                              'new' => t.forum.sortNew,
                              'hot' => t.forum.sortHot,
                              'unanswered' => t.forum.sortUnanswered,
                              _ => t.forum.sortExpert,
                            }),
                            visualDensity: VisualDensity.compact,
                            selected: _sort == sort,
                            onSelected: (_) {
                              setState(() => _sort = sort);
                              _load();
                            },
                          ),
                          const SizedBox(width: 6),
                        ],
                      ],
                    ),
                  ),
                  if (_showTagFilter)
                    tagsAsync.when(
                      loading: () => const Padding(
                        padding: EdgeInsets.all(12),
                        child: LinearProgressIndicator(minHeight: 2),
                      ),
                      error: (e, _) => const SizedBox.shrink(),
                      data: (grouped) => _TagFilterPanel(
                        grouped: grouped,
                        selected: _tagIds,
                        onToggle: (id) {
                          setState(() {
                            if (!_tagIds.add(id)) _tagIds.remove(id);
                          });
                          _load();
                        },
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: _loading
                  ? const SkeletonList(count: 4)
                  : _error
                      ? ErrorRetry(onRetry: _load)
                      : _posts.isEmpty
                          ? EmptyState(
                              icon: Icons.forum_outlined,
                              message: _type == 'QUESTION'
                                  ? t.forum.emptyQuestion
                                  : t.forum.empty,
                              actionLabel: t.forum.add,
                              actionIcon: Icons.edit_outlined,
                              onAction: _createPost,
                            )
                          : RefreshIndicator(
                              onRefresh: _load,
                              child: ListView.separated(
                                padding: const EdgeInsets.fromLTRB(
                                  AppSpacing.margin,
                                  4,
                                  AppSpacing.margin,
                                  96,
                                ),
                                itemCount: _posts.length +
                                    (_page < _totalPages - 1 ? 1 : 0),
                                separatorBuilder: (_, _) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (_, i) {
                                  if (i == _posts.length) {
                                    return Center(
                                      child: _loadingMore
                                          ? const Padding(
                                              padding: EdgeInsets.all(12),
                                              child: SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                        strokeWidth: 2),
                                              ),
                                            )
                                          : TextButton(
                                              onPressed: _loadMore,
                                              child:
                                                  Text(t.forum.loadMore),
                                            ),
                                    );
                                  }
                                  final post = _posts[i];
                                  return _PostCard(
                                    post: post,
                                    onLike: () => _toggleLike(post),
                                    onOpen: () => _openDetail(post),
                                  );
                                },
                              ),
                            ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createPost,
        icon: const Icon(Icons.edit_outlined),
        label: Text(t.forum.add),
      ),
    );
  }
}

/// Kategoriye göre gruplu etiket filtre paneli.
class _TagFilterPanel extends StatelessWidget {
  const _TagFilterPanel({
    required this.grouped,
    required this.selected,
    required this.onToggle,
  });

  final Map<String, List<ForumTag>> grouped;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      constraints: const BoxConstraints(maxHeight: 220),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: colors.border),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final entry in grouped.entries) ...[
              Text(
                forumTagCategoryLabel(t, entry.key),
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
                      selected: selected.contains(tag.id),
                      onSelected: (_) => onToggle(tag.id),
                    ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}

/// Liste gönderi kartı: yazar + rozetler, başlık, düz metin önizleme,
/// etiketler, beğeni/yorum sayaçları.
class _PostCard extends StatelessWidget {
  const _PostCard({
    required this.post,
    required this.onLike,
    required this.onOpen,
  });

  final ForumPost post;
  final VoidCallback onLike;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final author = post.displayAuthor ?? t.forum.anonymousUser;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: colors.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 6,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    author,
                    style: text.labelMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  if (post.authorIsExpert)
                    _Badge(label: t.forum.expertBadge, color: colors.success),
                  if (post.pinned)
                    _Badge(label: t.forum.pinnedBadge, color: colors.warning),
                  if (post.isQuestion && post.answered)
                    _Badge(
                        label: t.forum.answeredBadge, color: colors.success),
                  Text(
                    forumRelativeTime(t, post.createdAt),
                    style: text.labelSmall
                        ?.copyWith(color: colors.textTertiary),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(post.title, style: text.titleSmall),
              const SizedBox(height: 4),
              Text(
                htmlToPlainText(post.content),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style:
                    text.bodySmall?.copyWith(color: colors.textSecondary),
              ),
              if (post.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    for (final tag in post.tags.take(5))
                      _Badge(label: tag.name, color: colors.textSecondary),
                    if (post.tags.length > 5)
                      _Badge(
                        label: '+${post.tags.length - 5}',
                        color: colors.textTertiary,
                      ),
                  ],
                ),
              ],
              const SizedBox(height: 10),
              Row(
                children: [
                  InkWell(
                    onTap: onLike,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      child: Row(
                        children: [
                          Icon(
                            post.likedByMe
                                ? Icons.favorite
                                : Icons.favorite_outline,
                            size: 16,
                            color: post.likedByMe
                                ? colors.error
                                : colors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${post.likeCount}',
                            style: text.labelSmall
                                ?.copyWith(color: colors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Icon(Icons.chat_bubble_outline,
                      size: 15, color: colors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    '${post.commentCount}',
                    style: text.labelSmall
                        ?.copyWith(color: colors.textSecondary),
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

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

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
