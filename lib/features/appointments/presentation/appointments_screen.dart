import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../i18n/strings.g.dart';
import '../../auth/domain/app_user.dart';
import '../../auth/presentation/auth_controller.dart';
import '../data/appointment_repository.dart';
import '../domain/appointment.dart';

/// Randevular — liste + rol bazlı aksiyonlar (`/api/appointments`).
class AppointmentsScreen extends ConsumerWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final role = ref.watch(authControllerProvider).user?.role;
    final async = ref.watch(appointmentsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.appointments.title)),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            _ErrorView(onRetry: () => ref.invalidate(appointmentsProvider)),
        data: (all) {
          if (all.isEmpty) return _EmptyView(message: t.appointments.empty);

          final upcoming = all.where((a) => a.isUpcoming).toList()
            ..sort((a, b) {
              final byDate = a.date.compareTo(b.date);
              return byDate != 0 ? byDate : a.time.compareTo(b.time);
            });
          final past = all.where((a) => !a.isUpcoming).toList()
            ..sort((a, b) {
              final byDate = b.date.compareTo(a.date);
              return byDate != 0 ? byDate : b.time.compareTo(a.time);
            });

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(appointmentsProvider),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.margin,
                8,
                AppSpacing.margin,
                24,
              ),
              children: [
                if (upcoming.isNotEmpty) ...[
                  _SectionLabel(t.appointments.upcoming),
                  for (final a in upcoming)
                    _AppointmentCard(appointment: a, role: role),
                ],
                if (past.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _SectionLabel(t.appointments.past),
                  for (final a in past)
                    _AppointmentCard(appointment: a, role: role),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(color: AppColors.textTertiary),
      ),
    );
  }
}

class _AppointmentCard extends ConsumerStatefulWidget {
  const _AppointmentCard({required this.appointment, required this.role});

  final Appointment appointment;
  final UserRole? role;

  @override
  ConsumerState<_AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends ConsumerState<_AppointmentCard> {
  bool _busy = false;

  Appointment get a => widget.appointment;
  bool get isExpert => widget.role == UserRole.expert;

  Future<void> _run(Future<Appointment> Function() action, String okMsg) async {
    setState(() => _busy = true);
    try {
      await action();
      ref.invalidate(appointmentsProvider);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(okMsg)));
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() => _busy = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  Future<void> _cancel() async {
    final t = context.t;
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.appointments.cancelTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.appointments.cancelConfirm),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              minLines: 1,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: t.appointments.cancelReasonLabel,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(t.appointments.keepIt),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(t.appointments.cancel),
          ),
        ],
      ),
    );
    final reason = controller.text;
    controller.dispose();
    if (confirmed != true) return;
    await _run(
      () =>
          ref.read(appointmentRepositoryProvider).cancel(a.id, reason: reason),
      t.appointments.cancelled,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;

    // Karşı taraf: veli için uzman; uzman için veli/çocuk.
    final counterpart = isExpert
        ? (a.parentName ?? a.childName ?? '')
        : [
            a.expertName,
            a.expertTitle,
          ].where((s) => s?.isNotEmpty ?? false).join(' · ');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    counterpart.isEmpty ? a.type ?? '' : counterpart,
                    style: text.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _StatusChip(kind: a.statusKind),
              ],
            ),
            const SizedBox(height: 6),
            _InfoRow(
              icon: Icons.event_outlined,
              text: t.appointments.dateLine(
                day: a.date.day,
                month: t.common.monthsShort[a.date.month - 1],
                year: a.date.year,
                time: a.time,
              ),
            ),
            _InfoRow(
              icon: a.isOnline ? Icons.videocam_outlined : Icons.place_outlined,
              text: a.isOnline
                  ? t.appointments.typeOnline
                  : t.appointments.typeFaceToFace,
            ),
            if (isExpert && (a.childName?.isNotEmpty ?? false))
              _InfoRow(
                icon: Icons.child_care_outlined,
                text: t.appointments.withChild(name: a.childName!),
              ),
            if (a.notes?.isNotEmpty ?? false)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(a.notes!, style: text.bodySmall),
              ),
            if (a.isCancelled && (a.cancellationReason?.isNotEmpty ?? false))
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  t.appointments.cancelReasonShown(
                    reason: a.cancellationReason!,
                  ),
                  style: text.bodySmall?.copyWith(color: AppColors.error),
                ),
              ),
            if (a.isOnline &&
                !a.isCancelled &&
                (a.meetingLink?.isNotEmpty ?? false))
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    const Icon(Icons.link, size: 18, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: SelectableText(
                        a.meetingLink!,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ..._actions(t),
          ],
        ),
      ),
    );
  }

  List<Widget> _actions(Translations t) {
    final buttons = <Widget>[];
    final kind = a.statusKind;

    if (isExpert) {
      if (kind == AppointmentStatusKind.pending) {
        buttons.add(
          FilledButton.tonalIcon(
            onPressed: _busy
                ? null
                : () => _run(
                    () => ref.read(appointmentRepositoryProvider).confirm(a.id),
                    t.appointments.confirmed,
                  ),
            icon: const Icon(Icons.check, size: 18),
            label: Text(t.appointments.confirm),
          ),
        );
      } else if (kind == AppointmentStatusKind.confirmed) {
        buttons.add(
          FilledButton.tonalIcon(
            onPressed: _busy
                ? null
                : () => _run(
                    () =>
                        ref.read(appointmentRepositoryProvider).complete(a.id),
                    t.appointments.completed,
                  ),
            icon: const Icon(Icons.task_alt, size: 18),
            label: Text(t.appointments.complete),
          ),
        );
      }
    } else {
      // PARENT — onay bekleyen/onaylı ve yaklaşan randevuyu iptal edebilir.
      if (a.isUpcoming &&
          (kind == AppointmentStatusKind.pending ||
              kind == AppointmentStatusKind.confirmed)) {
        buttons.add(
          OutlinedButton.icon(
            onPressed: _busy ? null : _cancel,
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
            icon: const Icon(Icons.close, size: 18),
            label: Text(t.appointments.cancel),
          ),
        );
      }
    }

    if (buttons.isEmpty) return const [];
    return [
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_busy)
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ...buttons,
        ],
      ),
    ];
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textTertiary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.kind});
  final AppointmentStatusKind kind;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final (label, color) = switch (kind) {
      AppointmentStatusKind.pending => (
        t.appointments.statusPending,
        AppColors.warning,
      ),
      AppointmentStatusKind.confirmed => (
        t.appointments.statusConfirmed,
        AppColors.primary,
      ),
      AppointmentStatusKind.completed => (
        t.appointments.statusCompleted,
        AppColors.success,
      ),
      AppointmentStatusKind.cancelled => (
        t.appointments.statusCancelled,
        AppColors.error,
      ),
      AppointmentStatusKind.unknown => ('', AppColors.textTertiary),
    };
    if (label.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const SizedBox(height: 12),
          Text(t.common.loadError),
          const SizedBox(height: 12),
          FilledButton.tonal(onPressed: onRetry, child: Text(t.common.retry)),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.event_busy_outlined,
              size: 48,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
