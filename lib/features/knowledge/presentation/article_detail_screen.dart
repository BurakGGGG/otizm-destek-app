import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/haptics.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/tts/speech_service.dart';
import '../../../i18n/strings.g.dart';
import '../data/knowledge_repository.dart';
import '../domain/article.dart';
import '../domain/article_comment.dart';
import 'article_list_controller.dart';
import 'widgets/article_format_badge.dart';
import '../../../core/util/external_link.dart';

/// Makale detayı — `/api/knowledge/{id}`: tam içerik, yer imi, sesli dinleme,
/// ilgili içerikler ve aile yorumları.
class ArticleDetailScreen extends ConsumerStatefulWidget {
  const ArticleDetailScreen({super.key, required this.id, this.initialTitle});

  final String id;
  final String? initialTitle;

  @override
  ConsumerState<ArticleDetailScreen> createState() =>
      _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends ConsumerState<ArticleDetailScreen> {
  bool? _bookmarkOverride;
  bool _bookmarkBusy = false;
  bool _speaking = false;

  @override
  void dispose() {
    if (_speaking) ref.read(speechServiceProvider).stop();
    super.dispose();
  }

  Future<void> _toggleBookmark(Article article) async {
    if (_bookmarkBusy) return;
    setState(() => _bookmarkBusy = true);
    try {
      final value =
          await ref.read(knowledgeRepositoryProvider).toggleBookmark(article.id);
      if (!mounted) return;
      Haptics.success();
      setState(() {
        _bookmarkOverride = value;
        _bookmarkBusy = false;
      });
      ref.read(articleListProvider.notifier).applyBookmark(article.id, value);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _bookmarkBusy = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  /// Makaleyi sesli okur — ekrana bakamayan kullanıcılar için (kriz
  /// rehberindeki dinleme ile aynı servis).
  Future<void> _toggleSpeech(Article article) async {
    final t = context.t;
    final speech = ref.read(speechServiceProvider);
    if (_speaking) {
      await speech.stop();
      if (mounted) setState(() => _speaking = false);
      return;
    }
    final body = article.parsedContent.text;
    speech.onDone = () {
      if (mounted) setState(() => _speaking = false);
    };
    setState(() => _speaking = true);
    final started = await speech.speak(
      '${article.title}. $body',
      languageCode: LocaleSettings.currentLocale.languageCode,
    );
    if (!mounted) return;
    if (!started) {
      setState(() => _speaking = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.crisis.listenUnavailable)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final async = ref.watch(articleProvider(widget.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialTitle ?? t.knowledge.title),
        actions: [
          if (async.asData?.value case final article?) ...[
            IconButton(
              tooltip: _speaking ? t.crisis.listenStop : t.crisis.listen,
              onPressed: () => _toggleSpeech(article),
              icon: Icon(
                _speaking ? Icons.stop_circle_outlined : Icons.volume_up,
              ),
            ),
            IconButton(
              tooltip: t.knowledge.bookmark,
              onPressed: _bookmarkBusy ? null : () => _toggleBookmark(article),
              icon: Icon(
                (_bookmarkOverride ?? article.bookmarked)
                    ? Icons.bookmark
                    : Icons.bookmark_border,
              ),
            ),
          ],
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorView(
          onRetry: () => ref.invalidate(articleProvider(widget.id)),
        ),
        data: (article) => _Content(article: article),
      ),
    );
  }
}

class _Content extends ConsumerWidget {
  const _Content({required this.article});
  final Article article;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final parsed = article.parsedContent;
    final created = article.createdAt;

    final meta = <String>[
      if (article.authorName?.isNotEmpty ?? false) article.authorName!,
      if (created != null)
        t.knowledge.dateLine(
          day: created.day,
          month: t.common.monthsShort[created.month - 1],
          year: created.year,
        ),
      if (article.viewCount != null)
        t.knowledge.views(count: article.viewCount!),
    ];

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.margin),
      children: [
        Row(
          children: [
            ArticleFormatBadge(media: parsed.media),
            if (article.category?.isNotEmpty ?? false) ...[
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  article.category!,
                  style: text.labelMedium?.copyWith(
                    color: context.colors.textTertiary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        Text(article.title, style: text.headlineSmall),
        if (meta.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            meta.join(' · '),
            style: text.bodySmall?.copyWith(color: context.colors.textTertiary),
          ),
        ],
        const SizedBox(height: 16),
        if (parsed.media != ArticleMedia.none &&
            (parsed.mediaUrl?.isNotEmpty ?? false))
          _MediaLink(media: parsed.media, url: parsed.mediaUrl!),
        if (parsed.text.isNotEmpty) ...[
          const SizedBox(height: 8),
          SelectableText(
            parsed.text,
            style: text.bodyLarge?.copyWith(height: 1.5),
          ),
        ],
        const SizedBox(height: 24),
        _RelatedArticles(articleId: article.id),
        const SizedBox(height: 24),
        _Comments(articleId: article.id),
      ],
    );
  }
}

/// İlgili içerikler — `GET /knowledge/{id}/related`.
class _RelatedArticles extends ConsumerWidget {
  const _RelatedArticles({required this.articleId});
  final String articleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final async = ref.watch(relatedArticlesProvider(articleId));
    final related = async.asData?.value ?? const <Article>[];
    if (related.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t.knowledge.relatedTitle, style: text.titleSmall),
        const SizedBox(height: 8),
        for (final item in related)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.md),
              onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => ArticleDetailScreen(
                    id: item.id,
                    initialTitle: item.title,
                  ),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Row(
                  children: [
                    Icon(Icons.article_outlined,
                        size: 18, color: context.colors.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item.title,
                        style: text.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(Icons.chevron_right,
                        size: 18, color: context.colors.textTertiary),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Makale yorumları — okuma + yeni yorum (`/knowledge/{id}/comments`).
class _Comments extends ConsumerStatefulWidget {
  const _Comments({required this.articleId});
  final String articleId;

  @override
  ConsumerState<_Comments> createState() => _CommentsState();
}

class _CommentsState extends ConsumerState<_Comments> {
  final _controller = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final content = _controller.text.trim();
    if (content.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      await ref
          .read(knowledgeRepositoryProvider)
          .addComment(widget.articleId, content);
      if (!mounted) return;
      _controller.clear();
      setState(() => _sending = false);
      Haptics.success();
      ref.invalidate(articleCommentsProvider(widget.articleId));
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
    final async = ref.watch(articleCommentsProvider(widget.articleId));
    final comments = async.asData?.value ?? const <ArticleComment>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.knowledge.commentsTitle(count: comments.length),
          style: text.titleSmall,
        ),
        const SizedBox(height: 8),
        if (async.isLoading && comments.isEmpty)
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
        else if (comments.isEmpty)
          Text(
            t.knowledge.noComments,
            style: text.bodySmall?.copyWith(color: colors.textTertiary),
          ),
        for (final comment in comments)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: colors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          comment.authorName ?? t.knowledge.someone,
                          style: text.labelLarge,
                        ),
                      ),
                      if (comment.isExpert)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colors.primary.withValues(alpha: .10),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Text(
                            t.knowledge.expertBadge,
                            style: text.labelSmall?.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(comment.content, style: text.bodySmall),
                  if (comment.isExperience) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.science_outlined,
                            size: 13, color: colors.success),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            [
                              if (comment.durationTried case final duration?
                                  when duration.isNotEmpty)
                                t.knowledge.triedFor(duration: duration),
                              if (comment.effectivenessRating case final rating?)
                                t.knowledge.effectiveness(rating: rating),
                            ].join(' · '),
                            style: text.labelSmall
                                ?.copyWith(color: colors.success),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        const SizedBox(height: 4),
        TextField(
          controller: _controller,
          enabled: !_sending,
          minLines: 2,
          maxLines: 4,
          decoration: InputDecoration(hintText: t.knowledge.commentHint),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _sending ? null : _send,
            icon: _sending
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send, size: 18),
            label: Text(t.knowledge.commentSend),
          ),
        ),
      ],
    );
  }
}

class _MediaLink extends StatelessWidget {
  const _MediaLink({required this.media, required this.url});
  final ArticleMedia media;
  final String url;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final label = media == ArticleMedia.podcast
        ? t.knowledge.podcastLink
        : t.knowledge.videoLink;
    final icon = media == ArticleMedia.podcast
        ? Icons.mic_none
        : Icons.play_circle_outline;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: context.colors.primary),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: context.colors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          InkWell(
            // Medya adresi makaleyi yazan uzmandan geliyor: yalnızca
            // http/https açılır.
            onTap: () => openExternalLink(url),
            child: Text(
              url,
              style: TextStyle(
                color: context.colors.primary,
                fontSize: 13,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
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
          Icon(Icons.error_outline, size: 48, color: context.colors.error),
          const SizedBox(height: 12),
          Text(t.common.loadError),
          const SizedBox(height: 12),
          FilledButton.tonal(onPressed: onRetry, child: Text(t.common.retry)),
        ],
      ),
    );
  }
}
