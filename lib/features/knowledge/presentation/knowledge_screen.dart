import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../i18n/strings.g.dart';
import '../data/knowledge_repository.dart';
import '../domain/article.dart';
import '../domain/knowledge_categories.dart';
import 'article_detail_screen.dart';
import 'article_list_controller.dart';
import 'widgets/article_format_badge.dart';

/// Bilgi Bankası — arama, kategori ve içerik türü filtreleri, yer imleri ve
/// sayfalı liste (web KnowledgePage'in aile tarafındaki akışı).
class KnowledgeScreen extends ConsumerStatefulWidget {
  const KnowledgeScreen({super.key});

  @override
  ConsumerState<KnowledgeScreen> createState() => _KnowledgeScreenState();
}

class _KnowledgeScreenState extends ConsumerState<KnowledgeScreen> {
  final _search = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  /// Web'deki gibi yazarken beklenir, her tuşta istek atılmaz.
  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      final state = ref.read(articleListProvider).asData?.value;
      final query = (state?.query ?? const ArticleQuery()).copyWith(
        text: value,
      );
      ref.read(articleListProvider.notifier).setQuery(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final async = ref.watch(articleListProvider);
    final controller = ref.read(articleListProvider.notifier);
    final state = async.asData?.value;
    final query = state?.query ?? const ArticleQuery();

    return Scaffold(
      appBar: AppBar(
        title: Text(t.knowledge.title),
        actions: [
          IconButton(
            tooltip: t.knowledge.bookmarks,
            onPressed: () =>
                controller.setBookmarksOnly(!(state?.bookmarksOnly ?? false)),
            icon: Icon(
              (state?.bookmarksOnly ?? false)
                  ? Icons.bookmark
                  : Icons.bookmark_border,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.margin,
                8,
                AppSpacing.margin,
                0,
              ),
              child: TextField(
                controller: _search,
                onChanged: _onSearchChanged,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: t.knowledge.searchHint,
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _search.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () {
                            _search.clear();
                            controller.setQuery(query.copyWith(text: ''));
                            setState(() {});
                          },
                        ),
                ),
              ),
            ),
            _FormatBar(
              selected: query.format,
              onSelect: (format) => controller.setQuery(
                format == null
                    ? query.copyWith(clearFormat: true)
                    : query.copyWith(format: format),
              ),
            ),
            _CategoryBar(
              selected: query.category,
              onSelect: (category) => controller.setQuery(
                category == null
                    ? query.copyWith(clearCategory: true)
                    : query.copyWith(category: category),
              ),
            ),
            Expanded(
              child: async.when(
                loading: () => const SkeletonList(count: 5),
                error: (e, _) => ErrorRetry(onRetry: controller.refresh),
                data: (data) {
                  if (data.items.isEmpty) {
                    return EmptyState(
                      icon: data.bookmarksOnly
                          ? Icons.bookmark_border
                          : Icons.menu_book_outlined,
                      message: data.bookmarksOnly
                          ? t.knowledge.noBookmarks
                          : query.isEmpty
                              ? t.knowledge.empty
                              : t.knowledge.noResults,
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: controller.refresh,
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.margin,
                        8,
                        AppSpacing.margin,
                        24,
                      ),
                      itemCount: data.items.length + (data.hasMore ? 1 : 0),
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (_, i) {
                        if (i >= data.items.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: OutlinedButton(
                              onPressed: data.loadingMore
                                  ? null
                                  : controller.loadMore,
                              child: Text(
                                data.loadingMore
                                    ? t.common.loading
                                    : t.common.more,
                              ),
                            ),
                          );
                        }
                        return _ArticleTile(article: data.items[i]);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// İçerik türü çubuğu: Tümü / Makale / Video / Podcast (sunucu tarafı filtre).
class _FormatBar extends StatelessWidget {
  const _FormatBar({required this.selected, required this.onSelect});

  final String? selected;
  final ValueChanged<String?> onSelect;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final items = <({String? value, String label})>[
      (value: null, label: t.knowledge.filterAll),
      (value: kFormatText, label: t.knowledge.formatArticle),
      (value: kFormatVideo, label: t.knowledge.formatVideo),
      (value: kFormatPodcast, label: t.knowledge.formatPodcast),
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
          final item = items[i];
          final isSelected = selected == item.value;
          return ChoiceChip(
            label: Text(item.label),
            selected: isSelected,
            showCheckmark: false,
            selectedColor: context.colors.primary,
            backgroundColor: context.colors.surface,
            side: BorderSide(color: context.colors.border),
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : context.colors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            onSelected: (_) => onSelect(item.value),
          );
        },
      ),
    );
  }
}

/// Kategori çubuğu — değerler makale kaydındaki paylaşılan veridir.
class _CategoryBar extends StatelessWidget {
  const _CategoryBar({required this.selected, required this.onSelect});

  final String? selected;
  final ValueChanged<String?> onSelect;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.margin),
        itemCount: kKnowledgeCategories.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final category = i == 0 ? null : kKnowledgeCategories[i - 1];
          final label = category?.label ?? t.knowledge.filterAll;
          final isSelected = selected == category?.key;
          return FilterChip(
            label: Text(label),
            selected: isSelected,
            showCheckmark: false,
            onSelected: (_) => onSelect(category?.key),
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
                  if (article.bookmarked) ...[
                    const SizedBox(width: 6),
                    Icon(
                      Icons.bookmark,
                      size: 14,
                      color: context.colors.primary,
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
