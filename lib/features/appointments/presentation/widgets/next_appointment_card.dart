import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../i18n/strings.g.dart';
import '../../domain/appointment.dart';

/// "Sıradaki randevu" kartı — web AppointmentPage başlığındaki geri sayımlı
/// kutunun mobil karşılığı: karşı taraf, tarih/saat, görüşme tipi rozeti ve
/// saniye saniye işleyen geri sayım.
class NextAppointmentCard extends StatelessWidget {
  const NextAppointmentCard({
    super.key,
    required this.appointment,
    required this.isExpert,
  });

  final Appointment appointment;
  final bool isExpert;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final counterpart = isExpert
        ? (appointment.parentName ?? '')
        : (appointment.expertName ?? '');
    final months = t.common.monthsShort;
    final date = appointment.date;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(date.year, date.month, date.day);
    final dayLabel = day == today
        ? t.appointments.today
        : day == today.add(const Duration(days: 1))
            ? t.appointments.tomorrow
            : '${date.day} ${months[date.month - 1]}';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: colors.primary.withValues(alpha: .18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.schedule, size: 16, color: colors.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  t.appointments.nextTitle,
                  style: text.labelSmall?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      appointment.isOnline
                          ? Icons.videocam_outlined
                          : Icons.place_outlined,
                      size: 13,
                      color: colors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      appointment.isOnline
                          ? t.appointments.typeOnline
                          : t.appointments.typeFaceToFace,
                      style: text.labelSmall
                          ?.copyWith(color: colors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            counterpart.isEmpty
                ? '$dayLabel · ${appointment.time}'
                : '$counterpart · $dayLabel ${appointment.time}',
            style: text.titleSmall,
          ),
          const SizedBox(height: 6),
          _Countdown(startsAt: appointment.startsAt),
        ],
      ),
    );
  }
}

/// Saniyede bir yenilenen geri sayım (web `AppointmentCountdown` birebir).
class _Countdown extends StatefulWidget {
  const _Countdown({required this.startsAt});

  final DateTime startsAt;

  @override
  State<_Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<_Countdown> {
  Timer? _timer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final remaining = widget.startsAt.difference(_now);
    final label = countdownLabel(t, remaining);

    return Row(
      children: [
        Icon(Icons.hourglass_bottom, size: 14, color: colors.primary),
        const SizedBox(width: 4),
        Text(
          label,
          style: text.labelMedium?.copyWith(
            color: colors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

/// Kalan süre metni: gün varsa gün+saat+dakika, yoksa saat+dakika+saniye;
/// süre dolduysa "görüşme zamanı".
String countdownLabel(Translations t, Duration remaining) {
  if (remaining.isNegative || remaining == Duration.zero) {
    return t.appointments.countdownNow;
  }
  final days = remaining.inDays;
  final hours = remaining.inHours % 24;
  final minutes = remaining.inMinutes % 60;
  final seconds = remaining.inSeconds % 60;
  if (days > 0) {
    return t.appointments.countdownDays(
      days: days,
      hours: hours,
      minutes: minutes,
    );
  }
  return t.appointments.countdownToday(
    hours: hours,
    minutes: minutes,
    seconds: seconds,
  );
}
