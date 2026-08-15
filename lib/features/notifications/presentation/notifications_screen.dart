import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/haptics.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/settings/app_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../i18n/strings.g.dart';
import '../data/notification_repository.dart';
import '../domain/app_notification.dart';
import '../domain/notification_category.dart';
import 'notification_list_controller.dart';

/// Bildirimler — `/api/notifications` (kategori sekmeleri, tarih gruplama,
/// okundu işaretleme, tekli/çoklu silme; web NotificationsPage karşılığı).
class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  /// Web `link`'ini mobil rotaya eşler (bilinmiyorsa null).
  static String? mobileRoute(String? link) {
    if (link == null || link.isEmpty) return null;
    if (link.startsWith('/randevular') || link.startsWith('/appointments')) {
      return '/appointments';
    }
    if (link.startsWith('/mesajlar') || link.startsWith('/messages')) {
      return '/messages';
    }
    if (link.startsWith('/bilgi-bankasi') || link.startsWith('/knowledge')) {
      return '/knowledge';
    }
    if (link.startsWith('/cocuklarim') || link.startsWith('/children')) {
      return '/children';
    }
    if (link.startsWith('/gorevler') || link.startsWith('/tasks')) {
      return '/tasks';
    }
    if (link.startsWith('/forum')) return '/forum';
    if (link.startsWith('/gruplar') || link.startsWith('/groups')) {
      return '/groups';
    }
    if (link.startsWith('/bulusmalar') || link.startsWith('/meetups')) {
      return '/meetups';
    }
    if (link.startsWith('/takvim') || link.startsWith('/calendar')) {
      return '/calendar';
    }
    if (link.startsWith('/benzer-aileler') ||
        link.startsWith('/similar-families')) {
      return '/similar-families';
    }
    return null;
  }

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  NotificationCategory _category = NotificationCategory.all;
  bool _unreadOnly = false;
  final Set<String> _selected = {};
  bool _busy = false;

  bool get _selecting => _selected.isNotEmpty;

  Future<void> _onTap(AppNotification n) async {
    if (_selecting) {
      _toggleSelection(n.id);
      return;
    }
    if (!n.read) {
      try {
        await ref.read(notificationRepositoryProvider).markRead(n.id);
        ref.invalidate(notificationListProvider);
        ref.invalidate(unreadCountProvider);
      } on ApiException catch (_) {
        // okundu işareti başarısızsa yönlendirmeyi yine de dene
      }
    }
    final route = NotificationsScreen.mobileRoute(n.link);
    if (route != null && mounted) context.push(route);
  }

  void _toggleSelection(String id) {
    setState(() {
      if (!_selected.add(id)) _selected.remove(id);
    });
  }

  Future<void> _markAll() async {
    Haptics.success();
    try {
      await ref.read(notificationRepositoryProvider).markAllRead();
      ref.invalidate(notificationListProvider);
      ref.invalidate(unreadCountProvider);
    } on ApiException catch (e) {
      _snack(e.message);
    }
  }

  Future<void> _delete(AppNotification n) async {
    try {
      await ref.read(notificationRepositoryProvider).delete(n.id);
      ref.invalidate(notificationListProvider);
      ref.invalidate(unreadCountProvider);
    } on ApiException catch (e) {
      _snack(e.message);
    }
  }

  Future<void> _deleteSelected() async {
    setState(() => _busy = true);
    try {
      await ref
          .read(notificationRepositoryProvider)
          .deleteMany(_selected.toList());
      ref.invalidate(notificationListProvider);
      ref.invalidate(unreadCountProvider);
      if (mounted) setState(_selected.clear);
    } on ApiException catch (e) {
      _snack(e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final async = ref.watch(notificationListProvider);
    final prefs = ref.watch(appPreferencesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selecting
              ? t.notifications.selectedCount(count: _selected.length)
              : t.notifications.title,
        ),
        leading: _selecting
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => setState(_selected.clear),
              )
            : null,
        actions: [
          if (_selecting)
            IconButton(
              tooltip: t.notifications.deleteSelected,
              onPressed: _busy ? null : _deleteSelected,
              icon: Icon(Icons.delete_outline, color: context.colors.error),
            )
          else
            async.maybeWhen(
              data: (data) => data.items.any((n) => !n.read)
                  ? IconButton(
                      tooltip: t.notifications.markAllRead,
                      onPressed: _markAll,
                      icon: const Icon(Icons.done_all),
                    )
                  : const SizedBox.shrink(),
              orElse: () => const SizedBox.shrink(),
            ),
        ],
      ),
      body: async.when(
        loading: () => const SkeletonList(count: 6),
        error: (e, _) =>
            ErrorRetry(onRetry: () => ref.invalidate(notificationListProvider)),
        data: (data) {
          // Kullanıcının kapattığı bildirim türleri listede de gösterilmez.
          final visible = data.items
              .where((n) => shouldShowNotification(n.type, prefs))
              .toList();
          final filtered = visible.where((n) {
            if (_unreadOnly && n.read) return false;
            if (_category == NotificationCategory.all) return true;
            return notificationCategoryOf(n.type) == _category;
          }).toList();
          final grouped = groupNotificationsByDate(filtered);

          return Column(
            children: [
              _CategoryBar(
                items: visible,
                selected: _category,
                unreadOnly: _unreadOnly,
                onSelect: (c) => setState(() => _category = c),
                onToggleUnread: () =>
                    setState(() => _unreadOnly = !_unreadOnly),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? EmptyState(
                        icon: Icons.notifications_none,
                        message: visible.isEmpty
                            ? t.notifications.empty
                            : t.notifications.noneInFilter,
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          ref.invalidate(notificationListProvider);
                          ref.invalidate(unreadCountProvider);
                        },
                        child: ListView(
                          padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                          children: [
                            for (final entry in grouped.entries) ...[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  AppSpacing.margin,
                                  16,
                                  AppSpacing.margin,
                                  6,
                                ),
                                child: Text(
                                  '${_groupLabel(context, entry.key)} '
                                  '(${entry.value.length})',
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: context.colors.textTertiary,
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                              ),
                              for (final n in entry.value)
                                _NotificationTile(
                                  notification: n,
                                  selected: _selected.contains(n.id),
                                  selecting: _selecting,
                                  onTap: () => _onTap(n),
                                  onLongPress: () => _toggleSelection(n.id),
                                  onDismissed: () => _delete(n),
                                ),
                            ],
                            if (data.hasMore)
                              Padding(
                                padding: const EdgeInsets.all(AppSpacing.md),
                                child: OutlinedButton(
                                  onPressed: data.loadingMore
                                      ? null
                                      : () => ref
                                            .read(
                                              notificationListProvider.notifier,
                                            )
                                            .loadMore(),
                                  child: data.loadingMore
                                      ? const SizedBox(
                                          height: 18,
                                          width: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(t.common.more),
                                ),
                              ),
                          ],
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _groupLabel(BuildContext context, NotificationDateGroup group) {
    final t = context.t;
    return switch (group) {
      NotificationDateGroup.today => t.notifications.groupToday,
      NotificationDateGroup.yesterday => t.notifications.groupYesterday,
      NotificationDateGroup.thisWeek => t.notifications.groupThisWeek,
      NotificationDateGroup.older => t.notifications.groupOlder,
    };
  }
}

/// Kategori sekmeleri + okunmamış filtresi.
class _CategoryBar extends StatelessWidget {
  const _CategoryBar({
    required this.items,
    required this.selected,
    required this.unreadOnly,
    required this.onSelect,
    required this.onToggleUnread,
  });

  final List<AppNotification> items;
  final NotificationCategory selected;
  final bool unreadOnly;
  final ValueChanged<NotificationCategory> onSelect;
  final VoidCallback onToggleUnread;

  int _count(NotificationCategory category) {
    if (category == NotificationCategory.all) return items.length;
    return items
        .where((n) => notificationCategoryOf(n.type) == category)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return SizedBox(
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.margin,
          vertical: 8,
        ),
        children: [
          FilterChip(
            label: Text(t.notifications.unreadOnly),
            selected: unreadOnly,
            avatar: const Icon(Icons.mark_email_unread_outlined, size: 16),
            onSelected: (_) => onToggleUnread(),
          ),
          const SizedBox(width: 12),
          for (final category in NotificationCategory.values) ...[
            if (category == NotificationCategory.all ||
                _count(category) > 0) ...[
              ChoiceChip(
                label: Text(
                  '${categoryLabel(context, category)} (${_count(category)})',
                ),
                selected: selected == category,
                onSelected: (_) => onSelect(category),
              ),
              const SizedBox(width: 8),
            ],
          ],
        ],
      ),
    );
  }
}

String categoryLabel(BuildContext context, NotificationCategory category) {
  final t = context.t;
  return switch (category) {
    NotificationCategory.all => t.notifications.catAll,
    NotificationCategory.appointments => t.notifications.catAppointments,
    NotificationCategory.messages => t.notifications.catMessages,
    NotificationCategory.forum => t.notifications.catForum,
    NotificationCategory.tasks => t.notifications.catTasks,
    NotificationCategory.social => t.notifications.catSocial,
    NotificationCategory.system => t.notifications.catSystem,
  };
}

/// Bildirim tipine göre ikon (web ICON_MAP'in sadeleştirilmiş karşılığı).
IconData notificationIcon(String? type) {
  return switch (notificationCategoryOf(type)) {
    NotificationCategory.appointments => Icons.event_available_outlined,
    NotificationCategory.messages => Icons.chat_bubble_outline,
    NotificationCategory.forum => Icons.forum_outlined,
    NotificationCategory.tasks => Icons.assignment_turned_in_outlined,
    NotificationCategory.social => Icons.diversity_3_outlined,
    NotificationCategory.system => Icons.info_outline,
    NotificationCategory.all => Icons.notifications_none,
  };
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.notification,
    required this.selected,
    required this.selecting,
    required this.onTap,
    required this.onLongPress,
    required this.onDismissed,
  });

  final AppNotification notification;
  final bool selected;
  final bool selecting;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final n = notification;
    final created = n.createdAt;
    final dateLabel = created == null
        ? ''
        : t.notifications.dateLine(
            day: created.day,
            month: t.common.monthsShort[created.month - 1],
            time:
                '${created.hour.toString().padLeft(2, '0')}:'
                '${created.minute.toString().padLeft(2, '0')}',
          );

    final tile = ListTile(
      tileColor: selected
          ? colors.primary.withValues(alpha: 0.16)
          : n.read
          ? null
          : colors.primary.withValues(alpha: 0.06),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.margin,
        vertical: 6,
      ),
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: colors.primary.withValues(alpha: 0.12),
        child: Icon(
          selected ? Icons.check : notificationIcon(n.type),
          color: colors.primary,
          size: 20,
        ),
      ),
      title: Text(
        n.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: text.titleMedium?.copyWith(
          fontWeight: n.read ? FontWeight.w500 : FontWeight.w700,
        ),
      ),
      subtitle: (n.body?.isNotEmpty ?? false)
          ? Text(n.body!, maxLines: 2, overflow: TextOverflow.ellipsis)
          : null,
      trailing: dateLabel.isEmpty
          ? null
          : Text(
              dateLabel,
              style: text.bodySmall?.copyWith(color: colors.textTertiary),
            ),
      onTap: onTap,
      onLongPress: onLongPress,
    );

    // Seçim modunda kaydırarak silme kapalı: seçimle çakışmasın.
    if (selecting) return tile;
    return Dismissible(
      key: ValueKey(n.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.margin),
        color: colors.error.withValues(alpha: .14),
        child: Icon(Icons.delete_outline, color: colors.error),
      ),
      onDismissed: (_) => onDismissed(),
      child: tile,
    );
  }
}
