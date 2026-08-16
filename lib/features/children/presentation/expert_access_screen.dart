import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/haptics.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../i18n/strings.g.dart';
import '../data/connection_repository.dart';
import '../domain/expert_connection.dart';

/// Uzman Erişimi — velinin, uzmanların çocuk verisine erişimini yönettiği
/// ekran (web'de gösterge paneli + Çocuklarım sayfasına dağılmış bölümler).
/// Bekleyen istekler onaylanır/reddedilir, onaylı erişimler geri alınabilir.
class ExpertAccessScreen extends ConsumerStatefulWidget {
  const ExpertAccessScreen({super.key});

  @override
  ConsumerState<ExpertAccessScreen> createState() => _ExpertAccessScreenState();
}

class _ExpertAccessScreenState extends ConsumerState<ExpertAccessScreen> {
  String? _busyId;

  Future<void> _run(
    String id,
    Future<void> Function() action,
    String successMessage,
  ) async {
    setState(() => _busyId = id);
    try {
      await action();
      if (!mounted) return;
      Haptics.success();
      ref.invalidate(connectionRequestsProvider);
      ref.invalidate(activeConnectionsProvider);
      setState(() => _busyId = null);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(successMessage)));
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _busyId = null);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _confirmRevoke(ExpertConnection connection) async {
    final t = context.t;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.expertAccess.revokeTitle),
        content: Text(t.expertAccess.revokeConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(t.common.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(t.expertAccess.revoke),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await _run(
      connection.id,
      () => ref.read(connectionRepositoryProvider).revoke(connection.id),
      t.expertAccess.revoked,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final requestsAsync = ref.watch(connectionRequestsProvider);
    final activeAsync = ref.watch(activeConnectionsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.expertAccess.title)),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(connectionRequestsProvider);
            ref.invalidate(activeConnectionsProvider);
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.margin,
              AppSpacing.md,
              AppSpacing.margin,
              32,
            ),
            children: [
              Text(
                t.expertAccess.intro,
                style: text.bodySmall?.copyWith(color: colors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(t.expertAccess.pendingTitle, style: text.titleSmall),
              const SizedBox(height: 8),
              requestsAsync.when(
                loading: () => const SkeletonList(count: 2),
                error: (e, _) => Text(
                  t.common.loadError,
                  style: text.bodySmall?.copyWith(color: colors.textTertiary),
                ),
                data: (requests) {
                  if (requests.isEmpty) {
                    return Text(
                      t.expertAccess.noPending,
                      style:
                          text.bodySmall?.copyWith(color: colors.textTertiary),
                    );
                  }
                  return Column(
                    children: [
                      for (final request in requests) ...[
                        _ConnectionCard(
                          connection: request,
                          pending: true,
                          busy: _busyId == request.id,
                          onApprove: () => _run(
                            request.id,
                            () => ref
                                .read(connectionRepositoryProvider)
                                .approve(request.id),
                            t.expertAccess.approved,
                          ),
                          onReject: () => _run(
                            request.id,
                            () => ref
                                .read(connectionRepositoryProvider)
                                .reject(request.id),
                            t.expertAccess.rejected,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(t.expertAccess.activeTitle, style: text.titleSmall),
              const SizedBox(height: 8),
              activeAsync.when(
                loading: () => const SkeletonList(count: 2),
                error: (e, _) => Text(
                  t.common.loadError,
                  style: text.bodySmall?.copyWith(color: colors.textTertiary),
                ),
                data: (active) {
                  if (active.isEmpty) {
                    return Text(
                      t.expertAccess.noActive,
                      style:
                          text.bodySmall?.copyWith(color: colors.textTertiary),
                    );
                  }
                  return Column(
                    children: [
                      for (final connection in active) ...[
                        _ConnectionCard(
                          connection: connection,
                          pending: false,
                          busy: _busyId == connection.id,
                          onRevoke: () => _confirmRevoke(connection),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConnectionCard extends StatelessWidget {
  const _ConnectionCard({
    required this.connection,
    required this.pending,
    required this.busy,
    this.onApprove,
    this.onReject,
    this.onRevoke,
  });

  final ExpertConnection connection;
  final bool pending;
  final bool busy;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final VoidCallback? onRevoke;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final created = connection.createdAt;
    final accent = pending ? colors.warning : colors.success;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: accent.withValues(alpha: .40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                pending ? Icons.pending_actions : Icons.verified_user_outlined,
                size: 18,
                color: accent,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  connection.expertName ?? t.expertAccess.unknownExpert,
                  style: text.titleSmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            pending
                ? t.expertAccess.requestLine(
                    child: connection.childName ?? '—',
                  )
                : t.expertAccess.activeLine(
                    child: connection.childName ?? '—',
                  ),
            style: text.bodySmall,
          ),
          if (created != null) ...[
            const SizedBox(height: 4),
            Text(
              t.expertAccess.requestedAt(
                date:
                    '${created.day.toString().padLeft(2, '0')}.${created.month.toString().padLeft(2, '0')}.${created.year}',
              ),
              style: text.labelSmall?.copyWith(color: colors.textTertiary),
            ),
          ],
          const SizedBox(height: 10),
          if (busy)
            const Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else if (pending)
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onApprove,
                    icon: const Icon(Icons.check, size: 18),
                    label: Text(t.expertAccess.approve),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onReject,
                    icon: const Icon(Icons.close, size: 18),
                    label: Text(t.expertAccess.reject),
                  ),
                ),
              ],
            )
          else
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onRevoke,
                icon: const Icon(Icons.link_off, size: 18),
                label: Text(t.expertAccess.revoke),
              ),
            ),
        ],
      ),
    );
  }
}
