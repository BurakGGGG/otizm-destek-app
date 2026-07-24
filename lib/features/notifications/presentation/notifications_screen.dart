import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/haptics.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../i18n/strings.g.dart';
import '../data/notification_repository.dart';
import '../domain/app_notification.dart';

/// Bildirimler — `/api/notifications` (liste + okundu işaretle + yönlendirme).
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  /// Web `link`'ini mobil rotaya eşler (bilinmiyorsa null).
  static String? _mobileRoute(String? link) {
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
    return null;
  }

  Future<void> _onTap(
      BuildContext context, WidgetRef ref, AppNotification n) async {
    if (!n.read) {
      try {
        await ref.read(notificationRepositoryProvider).markRead(n.id);
        ref.invalidate(notificationsProvider);
        ref.invalidate(unreadCountProvider);
      } catch (_) {
        // okundu işareti başarısızsa yönlendirmeyi yine de dene
      }
    }
    final route = _mobileRoute(n.link);
    if (route != null && context.mounted) context.push(route);
  }

  Future<void> _markAll(BuildContext context, WidgetRef ref) async {
    Haptics.success();
    try {
      await ref.read(notificationRepositoryProvider).markAllRead();
      ref.invalidate(notificationsProvider);
      ref.invalidate(unreadCountProvider);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final async = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.notifications.title),
        actions: [
          async.maybeWhen(
            data: (items) => items.any((n) => !n.read)
                ? IconButton(
                    tooltip: t.notifications.markAllRead,
                    onPressed: () => _markAll(context, ref),
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
            ErrorRetry(onRetry: () => ref.invalidate(notificationsProvider)),
        data: (items) {
          if (items.isEmpty) {
            return EmptyState(
              icon: Icons.notifications_none,
              message: t.notifications.empty,
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(notificationsProvider);
              ref.invalidate(unreadCountProvider);
            },
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, _) => const Divider(height: 1, indent: 72),
              itemBuilder: (_, i) => _NotificationTile(
                notification: items[i],
                onTap: () => _onTap(context, ref, items[i]),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification, required this.onTap});

  final AppNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final n = notification;
    final created = n.createdAt;
    final dateLabel = created == null
        ? ''
        : t.notifications.dateLine(
            day: created.day,
            month: t.common.monthsShort[created.month - 1],
            time:
                '${created.hour.toString().padLeft(2, '0')}:${created.minute.toString().padLeft(2, '0')}',
          );

    return ListTile(
      tileColor: n.read
          ? null
          : context.colors.primary.withValues(alpha: 0.06),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.margin, vertical: 6),
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: context.colors.primary.withValues(alpha: 0.12),
        child: Icon(
          n.read ? Icons.notifications_none : Icons.notifications_active,
          color: context.colors.primary,
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
              style: text.bodySmall?.copyWith(color: context.colors.textTertiary),
            ),
      onTap: onTap,
    );
  }
}
