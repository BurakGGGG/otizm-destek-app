import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/haptics.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../i18n/strings.g.dart';
import '../../children/data/child_repository.dart';
import '../../children/domain/child.dart';
import '../../messaging/data/messaging_repository.dart';
import '../../messaging/presentation/conversation_thread_screen.dart';
import '../data/buddy_repository.dart';
import '../data/matching_repository.dart';
import '../domain/similar_family.dart';

/// Benzer Aileler — eşleştirme motorunun çocuğa yakın bulduğu aileler.
/// Keşfedilebilirlik anahtarı + mesaj/arkadaş/mentor bağlantı istekleri.
class SimilarFamiliesScreen extends ConsumerStatefulWidget {
  const SimilarFamiliesScreen({super.key});

  @override
  ConsumerState<SimilarFamiliesScreen> createState() =>
      _SimilarFamiliesScreenState();
}

class _SimilarFamiliesScreenState
    extends ConsumerState<SimilarFamiliesScreen> {
  String? _selectedChildId;
  bool _togglingStatus = false;

  /// Gönderilen istekler için iyimser durum: parentId → relationshipStatus.
  final Map<String, String> _statusOverride = {};

  Future<void> _toggleStatus(bool current) async {
    setState(() => _togglingStatus = true);
    Haptics.selection();
    try {
      await ref.read(matchingRepositoryProvider).toggleMatching();
      if (!mounted) return;
      ref.invalidate(matchingStatusProvider);
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _togglingStatus = false);
    }
  }

  Future<void> _message(SimilarFamily family) async {
    try {
      final conv = await ref
          .read(messagingRepositoryProvider)
          .getOrCreateDirect(family.parentId);
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ConversationThreadScreen(
            conversationId: conv.id,
            title: family.parentName,
          ),
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _requestBuddy(SimilarFamily family, {required bool mentor}) async {
    final t = context.t;
    final controller =
        TextEditingController(text: t.similar.requestDefault);
    final send = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.margin,
          right: AppSpacing.margin,
          top: AppSpacing.md,
          bottom: MediaQuery.viewInsetsOf(ctx).bottom + AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mentor ? t.similar.mentorRequestTitle : t.similar.requestTitle,
              style: Theme.of(ctx).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              family.parentName,
              style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                    color: ctx.colors.textSecondary,
                  ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              minLines: 2,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(hintText: t.similar.requestHint),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => Navigator.of(ctx).pop(true),
                icon: const Icon(Icons.send_outlined, size: 18),
                label: Text(t.similar.send),
              ),
            ),
          ],
        ),
      ),
    );
    final message = controller.text;
    controller.dispose();
    if (send != true) return;
    try {
      await ref.read(buddyRepositoryProvider).sendRequest(
            family.parentId,
            isMentorRequest: mentor,
            message: message,
          );
      if (!mounted) return;
      setState(() => _statusOverride[family.parentId] = 'PENDING');
      Haptics.success();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.similar.sent)));
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final childrenAsync = ref.watch(childrenProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.similar.title)),
      body: SafeArea(
        child: childrenAsync.when(
          loading: () => const SkeletonList(count: 3),
          error: (e, _) =>
              ErrorRetry(onRetry: () => ref.invalidate(childrenProvider)),
          data: (children) {
            if (children.isEmpty) {
              return EmptyState(
                icon: Icons.child_care_outlined,
                message: t.similar.noChild,
                actionLabel: t.children.add,
                actionIcon: Icons.child_care_outlined,
                onAction: () => context.push('/children'),
              );
            }
            final childId = _selectedChildId ??= children.first.id;
            return Column(
              children: [
                _MatchingStatusCard(
                  busy: _togglingStatus,
                  onToggle: _toggleStatus,
                ),
                if (children.length > 1)
                  _ChildSelector(
                    children: children,
                    selectedId: childId,
                    onSelect: (id) => setState(() => _selectedChildId = id),
                  ),
                Expanded(
                  child: _FamiliesBody(
                    childId: childId,
                    statusOf: (f) => _statusOverride[f.parentId],
                    onMessage: _message,
                    onBuddy: (f) => _requestBuddy(f, mentor: false),
                    onMentor: (f) => _requestBuddy(f, mentor: true),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Keşfedilebilirlik anahtarı — kullanıcı eşleştirmede görünür mü.
class _MatchingStatusCard extends ConsumerWidget {
  const _MatchingStatusCard({required this.busy, required this.onToggle});

  final bool busy;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final async = ref.watch(matchingStatusProvider);
    final enabled = async.value ?? true;
    return Card(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.margin,
        AppSpacing.md,
        AppSpacing.margin,
        4,
      ),
      child: SwitchListTile(
        value: enabled,
        onChanged: busy || async.isLoading ? null : onToggle,
        secondary: Icon(
          enabled ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: context.colors.primary,
        ),
        title: Text(enabled ? t.similar.discoverable : t.similar.hidden),
        subtitle: Text(
          t.similar.discoverableHint,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ),
    );
  }
}

class _FamiliesBody extends ConsumerWidget {
  const _FamiliesBody({
    required this.childId,
    required this.statusOf,
    required this.onMessage,
    required this.onBuddy,
    required this.onMentor,
  });

  final String childId;
  final String? Function(SimilarFamily) statusOf;
  final ValueChanged<SimilarFamily> onMessage;
  final ValueChanged<SimilarFamily> onBuddy;
  final ValueChanged<SimilarFamily> onMentor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final async = ref.watch(similarFamiliesProvider(childId));
    return async.when(
      loading: () => const SkeletonList(count: 3),
      error: (e, _) => ErrorRetry(
        onRetry: () => ref.invalidate(similarFamiliesProvider(childId)),
      ),
      data: (families) {
        if (families.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async =>
                ref.invalidate(similarFamiliesProvider(childId)),
            child: ListView(
              children: [
                SizedBox(
                  height: 320,
                  child: EmptyState(
                    icon: Icons.diversity_3_outlined,
                    message: t.similar.empty,
                  ),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async =>
              ref.invalidate(similarFamiliesProvider(childId)),
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.margin,
              8,
              AppSpacing.margin,
              24,
            ),
            itemCount: families.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final base = families[i];
              final override = statusOf(base);
              final family = override == null
                  ? base
                  : base.copyWith(relationshipStatus: override);
              return _FamilyCard(
                family: family,
                onMessage: () => onMessage(family),
                onBuddy: () => onBuddy(family),
                onMentor: () => onMentor(family),
              );
            },
          ),
        );
      },
    );
  }
}

class _FamilyCard extends StatelessWidget {
  const _FamilyCard({
    required this.family,
    required this.onMessage,
    required this.onBuddy,
    required this.onMentor,
  });

  final SimilarFamily family;
  final VoidCallback onMessage;
  final VoidCallback onBuddy;
  final VoidCallback onMentor;

  String? _relationLabel(Translations t) {
    switch (family.relationshipStatus) {
      case 'ACCEPTED':
        return family.mentorRelation
            ? t.similar.mentorLabel
            : t.similar.buddyLabel;
      case 'PENDING':
        return t.similar.pendingLabel;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final locked = family.hasRelationship;
    final relationLabel = _relationLabel(t);
    final title = family.childName?.isNotEmpty == true
        ? family.childName!
        : family.parentName;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor:
                      context.colors.primary.withValues(alpha: 0.12),
                  child: Icon(Icons.family_restroom, color: context.colors.primary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: text.titleMedium),
                      const SizedBox(height: 2),
                      Wrap(
                        spacing: 8,
                        children: [
                          if (family.childAgeRange.isNotEmpty)
                            Text(
                              t.similar.ageRange(range: family.childAgeRange),
                              style: text.labelSmall?.copyWith(
                                color: context.colors.textTertiary,
                              ),
                            ),
                          if (family.parentCity?.isNotEmpty == true)
                            Text(
                              family.parentCity!,
                              style: text.labelSmall?.copyWith(
                                color: context.colors.textTertiary,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                _MatchPill(percent: family.scorePercent),
              ],
            ),
            if (relationLabel != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.link, size: 14, color: context.colors.primary),
                  const SizedBox(width: 4),
                  Text(
                    relationLabel,
                    style: text.labelSmall?.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
            if (family.commonTags.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                t.similar.commonTagsTitle,
                style: text.labelMedium?.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final tag in family.commonTags.take(6))
                    _TagChip(label: tag.name),
                  if (family.commonTags.length > 6)
                    _TagChip(
                      label: t.similar.moreTags(
                        count: family.commonTags.length - 6,
                      ),
                    ),
                ],
              ),
            ],
            if (family.matchReasons.isNotEmpty) ...[
              const SizedBox(height: 12),
              for (final reason in family.matchReasons.take(3))
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 14,
                        color: context.colors.success,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          reason,
                          style: text.bodySmall?.copyWith(
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
            const Divider(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onMessage,
                    icon: const Icon(Icons.chat_bubble_outline, size: 16),
                    label: Text(t.similar.message),
                  ),
                ),
                const SizedBox(width: 8),
                _ConnectButton(
                  icon: Icons.handshake_outlined,
                  label: t.similar.buddy,
                  onTap: locked ? null : onBuddy,
                ),
                const SizedBox(width: 8),
                _ConnectButton(
                  icon: Icons.school_outlined,
                  label: t.similar.mentor,
                  onTap: locked ? null : onMentor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MatchPill extends StatelessWidget {
  const _MatchPill({required this.percent});
  final int percent;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: context.colors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Column(
        children: [
          Text(
            '%$percent',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: context.colors.primary,
                  fontWeight: FontWeight.w800,
                ),
          ),
          Text(
            t.similar.matchLabel,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: context.colors.primary,
                ),
          ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: context.colors.border),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: context.colors.textSecondary,
            ),
      ),
    );
  }
}

class _ConnectButton extends StatelessWidget {
  const _ConnectButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}

/// Çocuk seçici — yatay ChoiceChip'ler (davranış/günlük ekranlarıyla aynı).
class _ChildSelector extends StatelessWidget {
  const _ChildSelector({
    required this.children,
    required this.selectedId,
    required this.onSelect,
  });

  final List<Child> children;
  final String selectedId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.margin,
          vertical: 8,
        ),
        itemCount: children.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final c = children[i];
          final sel = c.id == selectedId;
          return ChoiceChip(
            label: Text(c.name),
            selected: sel,
            onSelected: (_) => onSelect(c.id),
            showCheckmark: false,
            selectedColor: context.colors.primary,
            backgroundColor: context.colors.surface,
            side: BorderSide(color: context.colors.border),
            labelStyle: TextStyle(
              color: sel ? Colors.white : context.colors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          );
        },
      ),
    );
  }
}
