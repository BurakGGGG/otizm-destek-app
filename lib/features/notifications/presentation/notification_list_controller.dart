import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/notification_repository.dart';
import '../domain/app_notification.dart';

/// Sayfalı bildirim listesi durumu.
class NotificationListState {
  const NotificationListState({
    this.items = const [],
    this.hasMore = false,
    this.loadingMore = false,
  });

  final List<AppNotification> items;
  final bool hasMore;
  final bool loadingMore;

  NotificationListState copyWith({
    List<AppNotification>? items,
    bool? hasMore,
    bool? loadingMore,
  }) {
    return NotificationListState(
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      loadingMore: loadingMore ?? this.loadingMore,
    );
  }
}

/// `GET /notifications/paged` üzerinden sayfalı liste (web'deki "Daha fazla
/// yükle" akışıyla aynı): ilk sayfa açılışta, sonrakiler istek üzerine.
class NotificationListController extends AsyncNotifier<NotificationListState> {
  static const int _pageSize = 20;
  int _page = 0;

  @override
  Future<NotificationListState> build() async {
    _page = 0;
    final result = await ref
        .watch(notificationRepositoryProvider)
        .getPage(0, size: _pageSize);
    return NotificationListState(items: result.items, hasMore: result.hasMore);
  }

  Future<void> loadMore() async {
    final current = state.asData?.value;
    if (current == null || !current.hasMore || current.loadingMore) return;
    state = AsyncData(current.copyWith(loadingMore: true));
    try {
      final next = await ref
          .read(notificationRepositoryProvider)
          .getPage(_page + 1, size: _pageSize);
      _page++;
      state = AsyncData(
        current.copyWith(
          items: [...current.items, ...next.items],
          hasMore: next.hasMore,
          loadingMore: false,
        ),
      );
    } catch (_) {
      // Sayfa yüklenemezse mevcut liste korunur; kullanıcı tekrar deneyebilir.
      state = AsyncData(current.copyWith(loadingMore: false));
    }
  }

  /// Listeyi baştan yükler (yenileme / mutasyon sonrası).
  void reload() => ref.invalidateSelf();
}

final notificationListProvider =
    AsyncNotifierProvider<NotificationListController, NotificationListState>(
      NotificationListController.new,
    );
