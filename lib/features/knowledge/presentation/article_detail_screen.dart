import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../i18n/strings.g.dart';
import '../data/knowledge_repository.dart';
import '../domain/article.dart';
import 'widgets/article_format_badge.dart';

/// Makale detay ekranı — `/api/knowledge/{id}` (tam içerik + yazar).
class ArticleDetailScreen extends ConsumerWidget {
  const ArticleDetailScreen({super.key, required this.id, this.initialTitle});

  final String id;
  final String? initialTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final async = ref.watch(articleProvider(id));

    return Scaffold(
      appBar: AppBar(title: Text(initialTitle ?? t.knowledge.title)),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            _ErrorView(onRetry: () => ref.invalidate(articleProvider(id))),
        data: (article) => _Content(article: article),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.article});
  final Article article;

  @override
  Widget build(BuildContext context) {
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
          SelectableText(
            url,
            style: TextStyle(color: context.colors.primary, fontSize: 13),
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
