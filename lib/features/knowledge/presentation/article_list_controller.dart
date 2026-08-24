import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/knowledge_repository.dart';
import '../domain/article.dart';

/// Bilgi bankası liste durumu: arama/filtre + sayfalı sonuçlar.
class ArticleListState {
  const ArticleListState({
    required this.query,
    this.items = const [],
    this.hasMore = false,
    this.loadingMore = false,
    this.bookmarksOnly = false,
  });

  final ArticleQuery query;
  final List<Article> items;
  final bool hasMore;
  final bool loadingMore;

  /// Yer imleri görünümü (sunucu tarafı filtre yerine ayrı uç nokta).
  final bool bookmarksOnly;

  ArticleListState copyWith({
    ArticleQuery? query,
    List<Article>? items,
    bool? hasMore,
    bool? loadingMore,
    bool? bookmarksOnly,
  }) {
    return ArticleListState(
      query: query ?? this.query,
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      loadingMore: loadingMore ?? this.loadingMore,
      bookmarksOnly: bookmarksOnly ?? this.bookmarksOnly,
    );
  }
}

/// Arama + kategori/format filtresi + sayfalama (web KnowledgePage akışı):
/// filtresiz çağrı da `/knowledge/search` üzerinden gider.
class ArticleListController extends AsyncNotifier<ArticleListState> {
  static const int _pageSize = 12;

  ArticleQuery _query = const ArticleQuery();
  bool _bookmarksOnly = false;
  int _page = 0;

  @override
  Future<ArticleListState> build() => _fetchFirstPage();

  Future<ArticleListState> _fetchFirstPage() async {
    final repo = ref.read(knowledgeRepositoryProvider);
    _page = 0;
    if (_bookmarksOnly) {
      final items = await repo.getBookmarks();
      return ArticleListState(
        query: _query,
        items: items,
        bookmarksOnly: true,
      );
    }
    final result = await repo.search(_query, page: 0, size: _pageSize);
    return ArticleListState(
      query: _query,
      items: result.items,
      hasMore: result.hasMore,
    );
  }

  Future<void> _reload() async {
    state = const AsyncLoading();
    try {
      state = AsyncData(await _fetchFirstPage());
    } catch (error, stack) {
      state = AsyncError(error, stack);
    }
  }

  Future<void> setQuery(ArticleQuery query) async {
    if (query == _query && !_bookmarksOnly) return;
    _query = query;
    _bookmarksOnly = false;
    await _reload();
  }

  Future<void> setBookmarksOnly(bool value) async {
    if (_bookmarksOnly == value) return;
    _bookmarksOnly = value;
    await _reload();
  }

  Future<void> refresh() => _reload();

  Future<void> loadMore() async {
    final current = state.asData?.value;
    if (current == null ||
        !current.hasMore ||
        current.loadingMore ||
        _bookmarksOnly) {
      return;
    }
    state = AsyncData(current.copyWith(loadingMore: true));
    try {
      final next = await ref
          .read(knowledgeRepositoryProvider)
          .search(_query, page: _page + 1, size: _pageSize);
      _page++;
      state = AsyncData(current.copyWith(
        items: [...current.items, ...next.items],
        hasMore: next.hasMore,
        loadingMore: false,
      ));
    } catch (_) {
      // Sayfa gelmezse mevcut liste korunur.
      state = AsyncData(current.copyWith(loadingMore: false));
    }
  }

  /// Detayda yer imi değişince listeyi de günceller (yer imleri görünümünde
  /// çıkarılan makale listeden düşer).
  void applyBookmark(String articleId, bool bookmarked) {
    final current = state.asData?.value;
    if (current == null) return;
    final items = current.items
        .map((article) =>
            article.id == articleId ? article.copyWith(bookmarked: bookmarked) : article)
        .where((article) => !current.bookmarksOnly || article.bookmarked)
        .toList();
    state = AsyncData(current.copyWith(items: items));
  }
}

final articleListProvider =
    AsyncNotifierProvider<ArticleListController, ArticleListState>(
      ArticleListController.new,
    );
