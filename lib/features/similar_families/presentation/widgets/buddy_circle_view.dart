import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/haptics.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../../../../i18n/strings.g.dart';
import '../../../auth/presentation/auth_controller.dart';
import '../../data/buddy_repository.dart';
import '../../data/meetup_request_repository.dart';
import '../../domain/buddy.dart';
import '../../domain/meetup_request.dart';

/// "Çemberim" sekmesi — gelen buluşma istekleri, bekleyen bağlantı istekleri
/// (kabul/ret) ve kurulmuş bağlantılar (mesaj/kaldır). Web'de aynı içerik
/// `SimilarFamiliesPage` içindeki "Çemberim" sekmesinde.
class BuddyCircleView extends ConsumerWidget {
  const BuddyCircleView({super.key, required this.onMessage});

  /// Bir bağlantıyla sohbeti açar (userId, görünen ad).
  final Future<void> Function(String userId, String name) onMessage;

  Future<void> _respond(
    BuildContext context,
    WidgetRef ref,
    Buddy buddy, {
    required bool accept,
  }) async {
    final id = buddy.relationshipId;
    if (id == null) return;
    final t = context.t;
    final messenger = ScaffoldMessenger.of(context);
    try {
      final repo = ref.read(buddyRepositoryProvider);
      accept ? await repo.accept(id) : await repo.reject(id);
      ref.invalidate(pendingBuddiesProvider);
      if (accept) ref.invalidate(myBuddiesProvider);
      Haptics.success();
      messenger.showSnackBar(SnackBar(
        content: Text(accept ? t.similar.accepted : t.similar.rejected),
      ));
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _remove(
    BuildContext context,
    WidgetRef ref,
    Buddy buddy,
  ) async {
    final id = buddy.relationshipId;
    if (id == null) return;
    final t = context.t;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.similar.removeBuddy),
        content: Text(t.similar.removeBuddyConfirm(name: buddy.fullName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(t.similar.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(t.similar.removeBuddy),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(buddyRepositoryProvider).remove(id);
      ref.invalidate(myBuddiesProvider);
      Haptics.warning();
      messenger.showSnackBar(SnackBar(content: Text(t.similar.removed)));
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final pendingAsync = ref.watch(pendingBuddiesProvider);
    final myAsync = ref.watch(myBuddiesProvider);
    final pending = pendingAsync.asData?.value ?? const <Buddy>[];
    final buddies = myAsync.asData?.value ?? const <Buddy>[];
    final loading = pendingAsync.isLoading || myAsync.isLoading;

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(pendingBuddiesProvider);
        ref.invalidate(myBuddiesProvider);
        ref.invalidate(meetupRequestsProvider);
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.margin,
          AppSpacing.md,
          AppSpacing.margin,
          AppSpacing.lg,
        ),
        children: [
          const MeetupRequestsSection(),
          if (pending.isNotEmpty) ...[
            Text(t.similar.circlePendingTitle, style: text.titleSmall),
            const SizedBox(height: 8),
            for (final buddy in pending)
              _PendingCard(
                buddy: buddy,
                onAccept: () => _respond(context, ref, buddy, accept: true),
                onReject: () => _respond(context, ref, buddy, accept: false),
              ),
            const SizedBox(height: 16),
          ],
          Text(t.similar.circleAcceptedTitle, style: text.titleSmall),
          const SizedBox(height: 8),
          if (loading && buddies.isEmpty)
            const SkeletonList(count: 2)
          else if (buddies.isEmpty)
            EmptyState(
              icon: Icons.handshake_outlined,
              message: t.similar.circleEmpty,
            )
          else
            for (final buddy in buddies)
              _BuddyCard(
                buddy: buddy,
                onMessage: () => onMessage(buddy.buddyId, buddy.fullName),
                onRemove: () => _remove(context, ref, buddy),
              ),
        ],
      ),
    );
  }
}

/// Gelen bekleyen bağlantı isteği kartı.
class _PendingCard extends StatelessWidget {
  const _PendingCard({
    required this.buddy,
    required this.onAccept,
    required this.onReject,
  });

  final Buddy buddy;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                UserAvatar(
                  name: buddy.fullName,
                  imageUrl: buddy.profileImageUrl,
                  radius: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(buddy.fullName, style: text.titleSmall),
                      const SizedBox(height: 2),
                      Text(
                        buddy.city?.isNotEmpty == true
                            ? buddy.city!
                            : t.similar.noCity,
                        style: text.labelSmall
                            ?.copyWith(color: colors.textTertiary),
                      ),
                    ],
                  ),
                ),
                _RelationChip(mentor: buddy.mentorRelation, request: true),
              ],
            ),
            if (buddy.requestMessage?.isNotEmpty == true) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.similar.requestNote,
                      style: text.labelSmall
                          ?.copyWith(color: colors.textSecondary),
                    ),
                    const SizedBox(height: 2),
                    Text(buddy.requestMessage!, style: text.bodySmall),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: onAccept,
                    child: Text(t.similar.accept),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReject,
                    child: Text(t.similar.reject),
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

/// Kurulmuş bağlantı kartı.
class _BuddyCard extends StatelessWidget {
  const _BuddyCard({
    required this.buddy,
    required this.onMessage,
    required this.onRemove,
  });

  final Buddy buddy;
  final VoidCallback onMessage;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final distance = buddy.distanceKm;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            UserAvatar(
              name: buddy.fullName,
              imageUrl: buddy.profileImageUrl,
              radius: 22,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          buddy.fullName,
                          style: text.titleSmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (buddy.mentorRelation) ...[
                        const SizedBox(width: 6),
                        _RelationChip(mentor: true, request: false),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    buddy.city?.isNotEmpty == true
                        ? buddy.city!
                        : t.similar.noCity,
                    style:
                        text.labelSmall?.copyWith(color: colors.textTertiary),
                  ),
                  if (distance != null)
                    Text(
                      t.similar.distance(km: distance.toStringAsFixed(1)),
                      style: text.labelSmall?.copyWith(color: colors.primary),
                    ),
                ],
              ),
            ),
            IconButton(
              tooltip: t.similar.message,
              onPressed: onMessage,
              icon: const Icon(Icons.chat_bubble_outline),
              color: colors.primary,
            ),
            IconButton(
              tooltip: t.similar.removeBuddy,
              onPressed: onRemove,
              icon: const Icon(Icons.person_remove_outlined),
              color: colors.error,
            ),
          ],
        ),
      ),
    );
  }
}

/// "Mentor / Arkadaş" rozetleri.
class _RelationChip extends StatelessWidget {
  const _RelationChip({required this.mentor, required this.request});

  final bool mentor;

  /// Bekleyen istek rozetinde farklı metin kullanılır.
  final bool request;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final label = request
        ? (mentor ? t.similar.circleMentorRequest : t.similar.circleBuddyRequest)
        : t.similar.mentor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

/// Bekleyen buluşma istekleri şeridi — gelen isteklerde onay/ret, giden
/// isteklerde iptal. İstek yoksa yer kaplamaz.
class MeetupRequestsSection extends ConsumerWidget {
  const MeetupRequestsSection({super.key});

  Future<void> _update(
    BuildContext context,
    WidgetRef ref,
    MeetupRequest request,
    String status,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref
          .read(meetupRequestRepositoryProvider)
          .updateStatus(request.id, status);
      ref.invalidate(meetupRequestsProvider);
      Haptics.selection();
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final userId = ref.watch(authControllerProvider).user?.id;
    final requests = ref.watch(meetupRequestsProvider).asData?.value ?? const [];
    final pending = [for (final r in requests) if (r.isPending) r];
    if (pending.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.similar.meetupRequestsTitle, style: text.titleSmall),
          const SizedBox(height: 8),
          for (final request in pending)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: colors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.otherName(userId) ?? t.similar.unknownFamily,
                    style: text.labelLarge,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${meetupTypeLabel(t, request.type)} · '
                    '${request.proposedDate} ${request.proposedTime}',
                    style: text.labelSmall
                        ?.copyWith(color: colors.textSecondary),
                  ),
                  if (request.location?.trim().isNotEmpty ?? false)
                    Text(
                      request.location!.trim(),
                      style: text.labelSmall
                          ?.copyWith(color: colors.textSecondary),
                    ),
                  if (request.message?.trim().isNotEmpty ?? false) ...[
                    const SizedBox(height: 4),
                    Text(request.message!.trim(), style: text.bodySmall),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (request.sentByMe(userId))
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _update(
                              context,
                              ref,
                              request,
                              kMeetupRequestCancelled,
                            ),
                            child: Text(t.similar.meetupCancel),
                          ),
                        )
                      else ...[
                        Expanded(
                          child: FilledButton.tonal(
                            onPressed: () => _update(
                              context,
                              ref,
                              request,
                              kMeetupRequestAccepted,
                            ),
                            child: Text(t.similar.meetupAccept),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _update(
                              context,
                              ref,
                              request,
                              kMeetupRequestDeclined,
                            ),
                            child: Text(t.similar.meetupDecline),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Buluşma türü etiketi (ONLINE / YUZEYUZE).
String meetupTypeLabel(Translations t, String type) =>
    type == kMeetupRequestInPerson
        ? t.similar.meetupInPerson
        : t.similar.meetupOnline;
