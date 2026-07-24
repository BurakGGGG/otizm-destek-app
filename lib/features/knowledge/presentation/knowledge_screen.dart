import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../i18n/strings.g.dart';
import '../data/knowledge_repository.dart';
import '../domain/article.dart';
import 'article_detail_screen.dart';
import 'widgets/article_format_badge.dart';

/// Bilgi Bankası — yayınlanmış makale listesi (`/api/knowledge`) + format filtresi.
class KnowledgeScreen extends ConsumerStatefulWidget {
  const KnowledgeScreen({super.key});

  @override
  ConsumerState<KnowledgeScreen> createState() => _KnowledgeScreenState();
}

class _KnowledgeScreenState extends ConsumerState<KnowledgeScreen> {
  // null = Tümü; aksi halde içerik türüne göre süzülür.
  ArticleMedia? _filter;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final async = ref.watch(articlesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.knowledge.title)),
      body: async.when(
        loading: () => const SkeletonList(count: 5),
        error: (e, _) =>
            ErrorRetry(onRetry: () => ref.invalidate(articlesProvider)),
        data: (articles) {
          if (articles.isEmpty) {
            return EmptyState(
              icon: Icons.menu_book_outlined,
              message: t.knowledge.empty,
            );
          }
          final filtered = _filter == null
              ? articles
              : articles
                    .where((a) => a.parsedContent.media == _filter)
                    .toList();
          return Column(
            children: [
              _FilterBar(
                selected: _filter,
                onSelect: (f) => setState(() => _filter = f),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? EmptyState(
                        icon: Icons.filter_list_off,
                        message: t.knowledge.noResults,
                      )
                    : RefreshIndicator(
                        onRefresh: () async =>
                            ref.invalidate(articlesProvider),
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.margin,
                            4,
                            AppSpacing.margin,
                            24,
                          ),
                          itemCount: filtered.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 12),
                          itemBuilder: (_, i) =>
                              _ArticleTile(article: filtered[i]),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Format filtre çubuğu: Tümü / Makale / Video / Podcast.
class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.selected, required this.onSelect});

  final ArticleMedia? selected;
  final ValueChanged<ArticleMedia?> onSelect;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final items = <({ArticleMedia? value, String label})>[
      (value: null, label: t.knowledge.filterAll),
      (value: ArticleMedia.none, label: t.knowledge.formatArticle),
      (value: ArticleMedia.video, label: t.knowledge.formatVideo),
      (value: ArticleMedia.podcast, label: t.knowledge.formatPodcast),
    ];
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.margin,
          vertical: 8,
        ),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final it = items[i];
          final isSel = selected == it.value;
          return ChoiceChip(
            label: Text(it.label),
            selected: isSel,
            showCheckmark: false,
            selectedColor: context.colors.primary,
            backgroundColor: context.colors.surface,
            side: BorderSide(color: context.colors.border),
            labelStyle: TextStyle(
              color: isSel ? Colors.white : context.colors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            onSelected: (_) => onSelect(it.value),
          );
        },
      ),
    );
  }
}

class _ArticleTile extends StatelessWidget {
  const _ArticleTile({required this.article});
  final Article article;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final summary = article.summary;

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ArticleDetailScreen(
              id: article.id,
              initialTitle: article.title,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ArticleFormatBadge(media: article.parsedContent.media),
                  if (article.category?.isNotEmpty ?? false) ...[
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        article.category!,
                        style: text.labelSmall?.copyWith(
                          color: context.colors.textTertiary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Text(
                article.title,
                style: text.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (summary?.isNotEmpty ?? false) ...[
                const SizedBox(height: 4),
                Text(
                  summary!,
                  style: text.bodySmall?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
