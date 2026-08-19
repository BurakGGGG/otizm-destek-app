import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../i18n/strings.g.dart';
import '../../forum/presentation/forum_post_detail_screen.dart';
import '../../knowledge/presentation/article_detail_screen.dart';
import '../../specialists/data/expert_repository.dart';
import '../../specialists/presentation/expert_detail_screen.dart';
import '../data/search_repository.dart';
import '../domain/search_result.dart';

/// Genel arama — makale, forum gönderisi, grup ve uzman tek sorguda
/// (`GET /api/search`). Web bunu kenar çubuğundaki komut paletinde sunuyor;
/// mobilde ana kabuktaki arama düğmesinden açılır.
///
/// Web'den ayrım: sonuca dokunmak bölüm listesine değil **doğrudan içeriğe**
/// gider (makale/gönderi detayı, uzman profili).
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;
  String? _type;
  List<SearchResult> _results = const [];
  bool _searching = false;
  bool _searched = false;
  String? _error;
  bool _opening = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), _search);
  }

  Future<void> _search() async {
    final query = _controller.text.trim();
    if (query.isEmpty) {
      setState(() {
        _results = const [];
        _searched = false;
        _error = null;
      });
      return;
    }
    setState(() {
      _searching = true;
      _error = null;
    });
    try {
      final results = await ref
          .read(searchRepositoryProvider)
          .search(query, type: _type);
      if (mounted) {
        setState(() {
          _results = results;
          _searched = true;
        });
      }
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  Future<void> _open(SearchResult result) async {
    if (_opening) return;
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    switch (result.type) {
      case kSearchTypeArticle:
        navigator.push(
          MaterialPageRoute(
            builder: (_) => ArticleDetailScreen(
              id: result.id,
              initialTitle: result.title,
            ),
          ),
        );
      case kSearchTypePost:
        navigator.push(
          MaterialPageRoute(
            builder: (_) => ForumPostDetailScreen(postId: result.id),
          ),
        );
      case kSearchTypeGroup:
        context.push('/groups');
      case kSearchTypeExpert:
        // Arama yalnızca kimlik döndüğü için profil ayrıca çekilir.
        setState(() => _opening = true);
        try {
          final expert =
              await ref.read(expertRepositoryProvider).getExpert(result.id);
          navigator.push(
            MaterialPageRoute(
              builder: (_) => ExpertDetailScreen(expert: expert),
            ),
          );
        } on ApiException catch (e) {
          messenger.showSnackBar(SnackBar(content: Text(e.message)));
        } finally {
          if (mounted) setState(() => _opening = false);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(title: Text(t.search.title)),
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
                controller: _controller,
                autofocus: true,
                textInputAction: TextInputAction.search,
                onChanged: _onChanged,
                onSubmitted: (_) => _search(),
                decoration: InputDecoration(
                  hintText: t.search.hint,
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _controller.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () {
                            _controller.clear();
                            _search();
                            setState(() {});
                          },
                        ),
                ),
              ),
            ),
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.margin,
                  vertical: 8,
                ),
                children: [
                  for (final type in kSearchTypeFilters) ...[
                    ChoiceChip(
                      label: Text(searchTypeLabel(t, type)),
                      selected: _type == type,
                      showCheckmark: false,
                      onSelected: (_) {
                        setState(() => _type = type);
                        _search();
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (_searching && _results.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (_error != null) {
                    return EmptyState(
                      icon: Icons.error_outline,
                      message: _error!,
                    );
                  }
                  if (_results.isEmpty) {
                    return EmptyState(
                      icon: Icons.search,
                      message: _searched ? t.search.noResults : t.search.help,
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.margin,
                      4,
                      AppSpacing.margin,
                      24,
                    ),
                    itemCount: _results.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (_, i) {
                      final result = _results[i];
                      return InkWell(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        onTap: () => _open(result),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            border: Border.all(color: colors.border),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                searchTypeIcon(result.type),
                                size: 20,
                                color: colors.primary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      result.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                    if (result.excerpt?.trim().isNotEmpty ??
                                        false) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        result.excerpt!.trim(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                              color: colors.textSecondary,
                                            ),
                                      ),
                                    ],
                                    const SizedBox(height: 4),
                                    Text(
                                      searchTypeLabel(t, result.type),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(color: colors.primary),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                size: 20,
                                color: colors.textTertiary,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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

String searchTypeLabel(Translations t, String? type) => switch (type) {
      kSearchTypeArticle => t.search.typeArticle,
      kSearchTypePost => t.search.typePost,
      kSearchTypeGroup => t.search.typeGroup,
      kSearchTypeExpert => t.search.typeExpert,
      _ => t.search.typeAll,
    };

IconData searchTypeIcon(String type) => switch (type) {
      kSearchTypeArticle => Icons.menu_book_outlined,
      kSearchTypePost => Icons.forum_outlined,
      kSearchTypeGroup => Icons.groups_outlined,
      kSearchTypeExpert => Icons.person_outline,
      _ => Icons.search,
    };
