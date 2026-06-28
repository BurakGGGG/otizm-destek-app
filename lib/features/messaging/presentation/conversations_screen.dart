import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../../i18n/strings.g.dart';
import '../../auth/presentation/auth_controller.dart';
import '../data/messaging_repository.dart';
import '../domain/conversation.dart';

/// Konuşma listesi ekranı — `GET /api/messages/conversations`.
class ConversationsScreen extends ConsumerWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final currentUserId = ref.watch(authControllerProvider).user?.id;
    final async = ref.watch(conversationsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.messages.title)),
      body: async.when(
        loading: () => const SkeletonList(count: 7),
        error: (e, _) =>
            ErrorRetry(onRetry: () => ref.invalidate(conversationsProvider)),
        data: (conversations) {
          if (conversations.isEmpty) {
            return EmptyState(
              icon: Icons.forum_outlined,
              message: t.messages.noConversations,
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(conversationsProvider),
            child: ListView.separated(
              itemCount: conversations.length,
              separatorBuilder: (_, _) => const Divider(height: 1, indent: 76),
              itemBuilder: (_, i) => _ConversationTile(
                conversation: conversations[i],
                currentUserId: currentUserId,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({
    required this.conversation,
    required this.currentUserId,
  });

  final Conversation conversation;
  final String? currentUserId;

  @override
  Widget build(BuildContext context) {
    final c = conversation;
    final text = Theme.of(context).textTheme;
    final title = c.displayTitle(currentUserId);
    final avatar = c.avatarUrl(currentUserId);
    final preview = c.lastMessage?.content ?? '';

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.margin,
        vertical: 4,
      ),
      leading: UserAvatar(name: title, imageUrl: avatar, radius: 24),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: text.titleMedium,
      ),
      subtitle: preview.isEmpty
          ? null
          : Text(preview, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: c.unreadCount > 0
          ? Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 22, minHeight: 22),
              child: Text(
                '${c.unreadCount}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          : const Icon(Icons.chevron_right, color: AppColors.textTertiary),
      onTap: () =>
          context.push('/messages/thread', extra: {'id': c.id, 'title': title}),
    );
  }
}

