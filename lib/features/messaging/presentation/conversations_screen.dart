import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../../i18n/strings.g.dart';
import '../../auth/presentation/auth_controller.dart';
import '../data/messaging_repository.dart';
import '../domain/conversation.dart';
import '../domain/pecs_cards.dart';

/// Konuşma listesi süzgeçleri — web MessagesPage `ConvFilter` birebir.
enum ConversationFilter { all, unread, experts, groups, archived }

/// Süzgeci uygular. Arşiv dışındaki sekmeler arşivlenmiş konuşmaları gizler.
List<Conversation> filterConversations(
  List<Conversation> conversations,
  ConversationFilter filter,
  String? currentUserId,
) {
  return [
    for (final c in conversations)
      if (switch (filter) {
        ConversationFilter.archived => c.archived,
        ConversationFilter.unread => c.unreadCount > 0 && !c.archived,
        ConversationFilter.groups => c.isGroup && !c.archived,
        ConversationFilter.experts =>
          !c.isGroup && c.hasExpert(currentUserId) && !c.archived,
        ConversationFilter.all => !c.archived,
      })
        c,
  ];
}

/// Konuşma listesi ekranı — `GET /api/messages/conversations`.
class ConversationsScreen extends ConsumerStatefulWidget {
  const ConversationsScreen({super.key});

  @override
  ConsumerState<ConversationsScreen> createState() =>
      _ConversationsScreenState();
}

class _ConversationsScreenState extends ConsumerState<ConversationsScreen> {
  ConversationFilter _filter = ConversationFilter.all;

  @override
  Widget build(BuildContext context) {
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
          final filtered = filterConversations(
            conversations,
            _filter,
            currentUserId,
          );
          return Column(
            children: [
              _FilterBar(
                selected: _filter,
                onSelect: (filter) => setState(() => _filter = filter),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? EmptyState(
                        icon: Icons.forum_outlined,
                        message: _emptyMessage(t, _filter),
                      )
                    : RefreshIndicator(
                        onRefresh: () async =>
                            ref.invalidate(conversationsProvider),
                        child: ListView.separated(
                          itemCount: filtered.length,
                          separatorBuilder: (_, _) =>
                              const Divider(height: 1, indent: 76),
                          itemBuilder: (_, i) => _ConversationTile(
                            conversation: filtered[i],
                            currentUserId: currentUserId,
                          ),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _emptyMessage(Translations t, ConversationFilter filter) {
    return switch (filter) {
      ConversationFilter.archived => t.messages.emptyArchived,
      ConversationFilter.unread => t.messages.emptyUnread,
      ConversationFilter.groups => t.messages.emptyGroups,
      ConversationFilter.experts => t.messages.emptyExperts,
      ConversationFilter.all => t.messages.noConversations,
    };
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.selected, required this.onSelect});

  final ConversationFilter selected;
  final ValueChanged<ConversationFilter> onSelect;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final labels = <ConversationFilter, String>{
      ConversationFilter.all: t.messages.filterAll,
      ConversationFilter.unread: t.messages.filterUnread,
      ConversationFilter.experts: t.messages.filterExperts,
      ConversationFilter.groups: t.messages.filterGroups,
      ConversationFilter.archived: t.messages.filterArchived,
    };
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.margin,
          vertical: 8,
        ),
        children: [
          for (final entry in labels.entries) ...[
            ChoiceChip(
              label: Text(entry.value),
              selected: selected == entry.key,
              showCheckmark: false,
              onSelected: (_) => onSelect(entry.key),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _ConversationTile extends ConsumerWidget {
  const _ConversationTile({
    required this.conversation,
    required this.currentUserId,
  });

  final Conversation conversation;
  final String? currentUserId;

  Future<void> _run(
    BuildContext context,
    WidgetRef ref,
    Future<void> Function() action,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await action();
      ref.invalidate(conversationsProvider);
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final c = conversation;
    final text = Theme.of(context).textTheme;
    final title = c.displayTitle(currentUserId);
    final avatar = c.avatarUrl(currentUserId);
    final lastContent = c.lastMessage?.content ?? '';
    // Son mesaj bir PECS kartıysa listede de emojisiyle görünür.
    final card = pecsCardForContent(lastContent);
    final preview = card == null ? lastContent : '${card.emoji} ${card.label}';
    final repository = ref.read(messagingRepositoryProvider);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.margin,
        vertical: 4,
      ),
      leading: UserAvatar(name: title, imageUrl: avatar, radius: 24),
      title: Row(
        children: [
          Flexible(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: text.titleMedium,
            ),
          ),
          if (c.muted) ...[
            const SizedBox(width: 6),
            Icon(
              Icons.notifications_off_outlined,
              size: 14,
              color: context.colors.textTertiary,
            ),
          ],
        ],
      ),
      subtitle: preview.isEmpty
          ? null
          : Text(preview, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (c.unreadCount > 0)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: context.colors.primary,
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
            ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: context.colors.textTertiary),
            onSelected: (value) => _run(context, ref, () async {
              if (value == 'archive') {
                await repository.setArchived(c.id, !c.archived);
              } else {
                await repository.setMuted(c.id, !c.muted);
              }
            }),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'archive',
                child: Text(
                  c.archived ? t.messages.unarchive : t.messages.archive,
                ),
              ),
              PopupMenuItem(
                value: 'mute',
                child: Text(c.muted ? t.messages.unmute : t.messages.mute),
              ),
            ],
          ),
        ],
      ),
      onTap: () =>
          context.push('/messages/thread', extra: {'id': c.id, 'title': title}),
    );
  }
}
