import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/haptics.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../i18n/strings.g.dart';
import '../../messaging/data/messaging_repository.dart';
import '../../messaging/presentation/conversation_thread_screen.dart';
import '../data/group_repository.dart';
import '../domain/group.dart';
import 'widgets/group_form_sheet.dart';

/// Destek Grupları — Gruplarım + Keşfet (arama/kategori). Katıl/ayrıl, grup
/// sohbeti, grup oluşturma. Veli tarafına yönelik topluluk özelliği.
class GroupsScreen extends ConsumerStatefulWidget {
  const GroupsScreen({super.key});

  @override
  ConsumerState<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends ConsumerState<GroupsScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  String _category = '';
  String? _openingChatId;

  GroupDiscoverKey get _discoverKey => (query: _query, category: _category);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _refreshLists() {
    ref.invalidate(myGroupsProvider);
    ref.invalidate(discoverGroupsProvider(_discoverKey));
  }

  Future<void> _create() async {
    final t = context.t;
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const GroupFormSheet(),
    );
    if (saved == true && mounted) {
      _refreshLists();
      Haptics.success();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.groups.created)));
    }
  }

  Future<void> _join(Group group) async {
    final t = context.t;
    try {
      await ref.read(groupRepositoryProvider).join(group.id);
      if (!mounted) return;
      _refreshLists();
      Haptics.success();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.groups.joinedMsg)));
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _leave(Group group) async {
    final t = context.t;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.groups.leaveTitle),
        content: Text(t.groups.leaveConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(t.groups.leave),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(t.groups.leave),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(groupRepositoryProvider).leave(group.id);
      if (!mounted) return;
      _refreshLists();
      Haptics.warning();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.groups.leftMsg)));
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _openChat(Group group) async {
    setState(() => _openingChatId = group.id);
    try {
      final conv =
          await ref.read(messagingRepositoryProvider).getOrCreateGroup(group.id);
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ConversationThreadScreen(
            conversationId: conv.id,
            title: group.name,
          ),
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _openingChatId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(t.groups.title),
          bottom: TabBar(
            tabs: [
              Tab(text: t.groups.tabMy),
              Tab(text: t.groups.tabDiscover),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              _MyGroupsTab(
                onJoin: _join,
                onLeave: _leave,
                onChat: _openChat,
                openingChatId: _openingChatId,
              ),
              _DiscoverTab(
                searchController: _searchController,
                query: _query,
                category: _category,
                discoverKey: _discoverKey,
                onSearch: (q) => setState(() => _query = q),
                onCategory: (c) => setState(() {
                  _category = c;
                  _query = '';
                  _searchController.clear();
                }),
                onJoin: _join,
                onLeave: _leave,
                onChat: _openChat,
                openingChatId: _openingChatId,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _create,
          icon: const Icon(Icons.add),
          label: Text(t.groups.add),
        ),
      ),
    );
  }
}

class _MyGroupsTab extends ConsumerWidget {
  const _MyGroupsTab({
    required this.onJoin,
    required this.onLeave,
    required this.onChat,
    required this.openingChatId,
  });

  final ValueChanged<Group> onJoin;
  final ValueChanged<Group> onLeave;
  final ValueChanged<Group> onChat;
  final String? openingChatId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final async = ref.watch(myGroupsProvider);
    return async.when(
      loading: () => const SkeletonList(count: 3),
      error: (e, _) =>
          ErrorRetry(onRetry: () => ref.invalidate(myGroupsProvider)),
      data: (groups) {
        if (groups.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(myGroupsProvider),
            child: ListView(
              children: [
                SizedBox(
                  height: 320,
                  child: EmptyState(
                    icon: Icons.groups_2_outlined,
                    message: t.groups.emptyMy,
                  ),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(myGroupsProvider),
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.margin,
              AppSpacing.md,
              AppSpacing.margin,
              96,
            ),
            itemCount: groups.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _GroupCard(
              group: groups[i],
              opening: openingChatId == groups[i].id,
              onJoin: () => onJoin(groups[i]),
              onLeave: () => onLeave(groups[i]),
              onChat: () => onChat(groups[i]),
            ),
          ),
        );
      },
    );
  }
}

class _DiscoverTab extends ConsumerWidget {
  const _DiscoverTab({
    required this.searchController,
    required this.query,
    required this.category,
    required this.discoverKey,
    required this.onSearch,
    required this.onCategory,
    required this.onJoin,
    required this.onLeave,
    required this.onChat,
    required this.openingChatId,
  });

  final TextEditingController searchController;
  final String query;
  final String category;
  final GroupDiscoverKey discoverKey;
  final ValueChanged<String> onSearch;
  final ValueChanged<String> onCategory;
  final ValueChanged<Group> onJoin;
  final ValueChanged<Group> onLeave;
  final ValueChanged<Group> onChat;
  final String? openingChatId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final async = ref.watch(discoverGroupsProvider(discoverKey));
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.margin,
            AppSpacing.md,
            AppSpacing.margin,
            4,
          ),
          child: TextField(
            controller: searchController,
            textInputAction: TextInputAction.search,
            onSubmitted: onSearch,
            decoration: InputDecoration(
              hintText: t.groups.searchHint,
              prefixIcon: const Icon(Icons.search),
              isDense: true,
              suffixIcon: query.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        searchController.clear();
                        onSearch('');
                      },
                    ),
            ),
          ),
        ),
        _CategoryFilter(selected: category, onSelect: onCategory),
        Expanded(
          child: async.when(
            loading: () => const SkeletonList(count: 3),
            error: (e, _) => ErrorRetry(
              onRetry: () => ref.invalidate(discoverGroupsProvider(discoverKey)),
            ),
            data: (groups) {
              if (groups.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () async =>
                      ref.invalidate(discoverGroupsProvider(discoverKey)),
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 280,
                        child: EmptyState(
                          icon: Icons.search_off,
                          message: t.groups.emptyDiscover,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () async =>
                    ref.invalidate(discoverGroupsProvider(discoverKey)),
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.margin,
                    4,
                    AppSpacing.margin,
                    96,
                  ),
                  itemCount: groups.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => _GroupCard(
                    group: groups[i],
                    opening: openingChatId == groups[i].id,
                    onJoin: () => onJoin(groups[i]),
                    onLeave: () => onLeave(groups[i]),
                    onChat: () => onChat(groups[i]),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  const _CategoryFilter({required this.selected, required this.onSelect});

  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final items = <({String value, String label})>[
      (value: '', label: t.groups.allCategories),
      for (final c in kGroupCategories) (value: c, label: c),
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

class _GroupCard extends StatelessWidget {
  const _GroupCard({
    required this.group,
    required this.opening,
    required this.onJoin,
    required this.onLeave,
    required this.onChat,
  });

  final Group group;
  final bool opening;
  final VoidCallback onJoin;
  final VoidCallback onLeave;
  final VoidCallback onChat;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final trimmed = group.name.trim();
    final initial = trimmed.isNotEmpty ? trimmed.substring(0, 1).toUpperCase() : '?';

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor:
                      context.colors.primary.withValues(alpha: 0.12),
                  child: Text(
                    initial,
                    style: text.titleMedium?.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              group.name,
                              style: text.titleMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (group.verified) ...[
                            const SizedBox(width: 4),
                            Icon(
                              Icons.verified,
                              size: 16,
                              color: context.colors.primary,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Wrap(
                        spacing: 10,
                        children: [
                          if (group.category?.isNotEmpty == true)
                            Text(
                              group.category!,
                              style: text.labelSmall?.copyWith(
                                color: context.colors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          Text(
                            t.groups.memberCount(count: group.memberCount),
                            style: text.labelSmall?.copyWith(
                              color: context.colors.textTertiary,
                            ),
                          ),
                          if (group.expertCount > 0)
                            Text(
                              t.groups.expertCount(count: group.expertCount),
                              style: text.labelSmall?.copyWith(
                                color: context.colors.textTertiary,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (group.description?.isNotEmpty == true) ...[
              const SizedBox(height: 10),
              Text(
                group.description!,
                style: text.bodyMedium?.copyWith(
                  color: context.colors.textSecondary,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                if (group.isMember) ...[
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: opening ? null : onChat,
                      icon: opening
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.forum_outlined, size: 18),
                      label: Text(t.groups.chat),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    style: AppButtonStyles.inlineOutlined,
                    onPressed: onLeave,
                    child: Text(t.groups.leave),
                  ),
                ] else
                  Expanded(
                    child: FilledButton.tonalIcon(
                      onPressed: onJoin,
                      icon: const Icon(Icons.add, size: 18),
                      label: Text(t.groups.join),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
