import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/haptics.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../../i18n/strings.g.dart';
import '../../profile/data/block_repository.dart';

/// Engellenen kullanıcılar — `GET /users/me/blocked`, engeli kaldırma
/// `DELETE /users/{id}/block`.
///
/// Web'de engelleme var ama listeleme/kaldırma arayüzü yok; aynı uç noktalar
/// kullanıldığı için mobildeki kaldırma web'i de etkiler.
class BlockedUsersScreen extends ConsumerWidget {
  const BlockedUsersScreen({super.key});

  Future<void> _unblock(
    BuildContext context,
    WidgetRef ref,
    String userId,
  ) async {
    final t = context.t;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(blockRepositoryProvider).unblock(userId);
      ref.invalidate(blockedUsersProvider);
      Haptics.selection();
      messenger.showSnackBar(
        SnackBar(content: Text(t.settings.blockedRemoved)),
      );
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final async = ref.watch(blockedUsersProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.settings.blockedTitle)),
      body: SafeArea(
        child: async.when(
          loading: () => const SkeletonList(count: 3),
          error: (e, _) =>
              ErrorRetry(onRetry: () => ref.invalidate(blockedUsersProvider)),
          data: (users) {
            if (users.isEmpty) {
              return EmptyState(
                icon: Icons.block_outlined,
                message: t.settings.blockedEmpty,
              );
            }
            return RefreshIndicator(
              onRefresh: () async => ref.invalidate(blockedUsersProvider),
              child: ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.margin),
                itemCount: users.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final user = users[i];
                  return Card(
                    margin: EdgeInsets.zero,
                    child: ListTile(
                      leading: UserAvatar(name: user.fullName, radius: 20),
                      title: Text(user.fullName),
                      subtitle: user.city?.isNotEmpty == true
                          ? Text(user.city!)
                          : null,
                      trailing: TextButton(
                        onPressed: () => _unblock(context, ref, user.id),
                        child: Text(t.settings.blockedRemove),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
