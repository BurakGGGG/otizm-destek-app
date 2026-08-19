import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../i18n/strings.g.dart';
import '../../data/appointment_repository.dart';
import '../../domain/appointment.dart';
import '../../../../core/util/external_link.dart';

/// Randevu detay sayfası — web AppointmentPage'deki "Randevu Detayı"
/// penceresi: tüm alanlar + durum geçmişi zaman çizelgesi.
class AppointmentDetailSheet extends ConsumerWidget {
  const AppointmentDetailSheet({super.key, required this.appointment});

  final Appointment appointment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final a = appointment;

    final rows = <({String label, String value})>[
      (
        label: t.appointments.dateLine(
          day: a.date.day,
          month: t.common.monthsShort[a.date.month - 1],
          year: a.date.year,
          time: a.time,
        ),
        value: '',
      ),
      (
        label: t.appointments.detailDuration,
        value: t.appointments.detailDurationValue(count: a.duration ?? 50),
      ),
      if (a.expertName?.isNotEmpty ?? false)
        (label: t.appointments.detailExpert, value: a.expertName!),
      if (a.parentName?.isNotEmpty ?? false)
        (label: t.appointments.detailParent, value: a.parentName!),
      if (a.childName?.isNotEmpty ?? false)
        (label: t.appointments.detailChild, value: a.childName!),
      (
        label: t.appointments.detailType,
        value: a.isOnline
            ? t.appointments.typeOnline
            : t.appointments.typeFaceToFace,
      ),
      if (a.appointmentTopic?.trim().isNotEmpty ?? false)
        (label: t.appointments.detailTopic, value: a.appointmentTopic!.trim()),
      if (a.notes?.trim().isNotEmpty ?? false)
        (label: t.appointments.detailNote, value: a.notes!.trim()),
      if (a.preSessionNotes?.trim().isNotEmpty ?? false)
        (
          label: t.appointments.detailPreSession,
          value: a.preSessionNotes!.trim(),
        ),
      if (a.sessionNotes?.trim().isNotEmpty ?? false)
        (
          label: t.appointments.detailSessionNote,
          value: a.sessionNotes!.trim(),
        ),
      if (a.sessionSummary?.trim().isNotEmpty ?? false)
        (
          label: t.appointments.detailSessionSummary,
          value: a.sessionSummary!.trim(),
        ),
      if (a.followUpRecommendations?.trim().isNotEmpty ?? false)
        (
          label: t.appointments.detailFollowUp,
          value: a.followUpRecommendations!.trim(),
        ),
      if (a.followUpTask?.trim().isNotEmpty ?? false)
        (
          label: t.appointments.detailFollowUpTask,
          value: a.followUpTask!.trim(),
        ),
      if (a.cancellationReason?.trim().isNotEmpty ?? false)
        (
          label: t.appointments.cancelReasonShown(
            reason: a.cancellationReason!.trim(),
          ),
          value: '',
        ),
      if (a.rating != null)
        (
          label: t.appointments.detailRating,
          value: t.appointments.detailRatingValue(rating: a.rating!),
        ),
      if (a.ratingComment?.trim().isNotEmpty ?? false)
        (label: '', value: a.ratingComment!.trim()),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.margin),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      t.appointments.detailTitle,
                      style: text.titleMedium,
                    ),
                  ),
                  _StatusText(status: a.status),
                ],
              ),
              const SizedBox(height: 12),
              for (final row in rows) ...[
                _DetailRow(label: row.label, value: row.value),
                const SizedBox(height: 8),
              ],
              if (a.cancellationBy?.isNotEmpty ?? false)
                _DetailRow(
                  label: t.appointments.detailCancelledBy(
                    who: a.cancellationBy!,
                  ),
                  value: a.lateCancellation
                      ? t.appointments.detailLateCancellation
                      : '',
                ),
              if (a.isOnline &&
                  !a.isCancelled &&
                  (a.meetingLink?.isNotEmpty ?? false)) ...[
                const SizedBox(height: 4),
                FilledButton.tonalIcon(
                  // Görüşme bağlantısını uzman giriyor: yalnızca http/https.
                  onPressed: () => openExternalLink(a.meetingLink),
                  icon: const Icon(Icons.videocam_outlined, size: 18),
                  label: Text(t.appointments.joinMeeting),
                ),
              ],
              const Divider(height: 28),
              Text(t.appointments.historyTitle, style: text.titleSmall),
              const SizedBox(height: 8),
              _History(appointmentId: a.id),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    if (label.isEmpty) return Text(value, style: text.bodySmall);
    if (value.isEmpty) {
      return Text(
        label,
        style: text.bodySmall?.copyWith(color: colors.textSecondary),
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130,
          child: Text(
            label,
            style: text.labelSmall?.copyWith(color: colors.textSecondary),
          ),
        ),
        Expanded(child: Text(value, style: text.bodySmall)),
      ],
    );
  }
}

class _StatusText extends StatelessWidget {
  const _StatusText({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final label = appointmentStatusLabel(t, status);
    if (label.isEmpty) return const SizedBox.shrink();
    return Text(
      label,
      style: Theme.of(context)
          .textTheme
          .labelLarge
          ?.copyWith(color: context.colors.primary),
    );
  }
}

/// Durum geçmişi zaman çizelgesi. Kayıt yoksa ya da uç nokta hata verirse
/// (web de hatayı sessiz geçiyor) tek satırlık bilgi gösterilir.
class _History extends ConsumerWidget {
  const _History({required this.appointmentId});
  final String appointmentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final async = ref.watch(appointmentHistoryProvider(appointmentId));

    return async.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: SizedBox(
          height: 18,
          width: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (_, _) => Text(
        t.appointments.historyEmpty,
        style: text.labelSmall?.copyWith(color: colors.textTertiary),
      ),
      data: (entries) {
        if (entries.isEmpty) {
          return Text(
            t.appointments.historyEmpty,
            style: text.labelSmall?.copyWith(color: colors.textTertiary),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final entry in entries) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _statusColor(context, entry.newStatus),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.oldStatus == null
                              ? appointmentStatusLabel(t, entry.newStatus)
                              : t.appointments.historyChange(
                                  from: appointmentStatusLabel(
                                    t,
                                    entry.oldStatus!,
                                  ),
                                  to: appointmentStatusLabel(
                                    t,
                                    entry.newStatus,
                                  ),
                                ),
                          style: text.labelLarge,
                        ),
                        if (entry.changedByName != null ||
                            entry.changedAt != null)
                          Text(
                            t.appointments.historyMeta(
                              name: entry.changedByName ?? '',
                              date: _formatChangedAt(t, entry.changedAt),
                            ),
                            style: text.labelSmall
                                ?.copyWith(color: colors.textTertiary),
                          ),
                        if (entry.note?.trim().isNotEmpty ?? false)
                          Text(
                            entry.note!.trim(),
                            style: text.bodySmall
                                ?.copyWith(color: colors.textSecondary),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ],
        );
      },
    );
  }
}

String _formatChangedAt(Translations t, DateTime? value) {
  if (value == null) return '';
  final local = value.toLocal();
  final hh = local.hour.toString().padLeft(2, '0');
  final mm = local.minute.toString().padLeft(2, '0');
  return '${local.day} ${t.common.monthsShort[local.month - 1]} $hh:$mm';
}

Color _statusColor(BuildContext context, String status) {
  final colors = context.colors;
  return switch (status.toUpperCase()) {
    'PENDING' => colors.warning,
    'CONFIRMED' => colors.primary,
    'COMPLETED' => colors.success,
    'CANCELLED' => colors.error,
    _ => colors.textTertiary,
  };
}

/// Durum kodunun yerelleştirilmiş etiketi (geçmiş satırlarında da kullanılır).
String appointmentStatusLabel(Translations t, String status) {
  return switch (status.toUpperCase()) {
    'PENDING' => t.appointments.statusPending,
    'CONFIRMED' => t.appointments.statusConfirmed,
    'COMPLETED' => t.appointments.statusCompleted,
    'CANCELLED' => t.appointments.statusCancelled,
    _ => status,
  };
}
