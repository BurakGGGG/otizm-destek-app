import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../i18n/strings.g.dart';
import '../../appointments/presentation/appointment_booking_screen.dart';
import '../../auth/domain/app_user.dart';
import '../../auth/presentation/auth_controller.dart';
import '../domain/expert.dart';

/// Uzman detay ekranı — liste öğesinden gelen [Expert] ile beslenir.
class ExpertDetailScreen extends ConsumerWidget {
  const ExpertDetailScreen({super.key, required this.expert});
  final Expert expert;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final auth = ref.watch(authControllerProvider);
    final isParent = auth.user?.role == UserRole.parent;
    final isSelf = auth.user?.id == expert.id;
    final canBook = isParent && !isSelf && expert.verified;

    return Scaffold(
      appBar: AppBar(title: Text(expert.fullName)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.margin),
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                  backgroundImage: (expert.profileImageUrl?.isNotEmpty ?? false)
                      ? NetworkImage(expert.profileImageUrl!)
                      : null,
                  child: (expert.profileImageUrl?.isEmpty ?? true)
                      ? const Icon(
                          Icons.person,
                          size: 36,
                          color: AppColors.primary,
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              expert.fullName,
                              style: text.titleLarge,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (expert.verified) ...[
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.verified,
                              size: 18,
                              color: AppColors.primary,
                            ),
                          ],
                        ],
                      ),
                      if (expert.expertTitle?.isNotEmpty ?? false)
                        Text(
                          expert.expertTitle!,
                          style: text.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      const SizedBox(height: 6),
                      _RatingLine(expert: expert),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Konum / kurum / makale bilgisi
            if (expert.city?.isNotEmpty ?? false)
              _InfoRow(icon: Icons.place_outlined, text: expert.city!),
            if (expert.institution?.isNotEmpty ?? false)
              _InfoRow(
                icon: Icons.business_outlined,
                text: expert.institution!,
              ),
            if (expert.articleCount > 0)
              _InfoRow(
                icon: Icons.article_outlined,
                text: t.expertDetail.articleCount(count: expert.articleCount),
              ),

            // Uzmanlık alanları
            if (expert.specializations.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(t.expertDetail.specializationsTitle, style: text.titleSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final s in expert.specializations)
                    Chip(
                      label: Text(s),
                      backgroundColor: AppColors.primary.withValues(
                        alpha: 0.08,
                      ),
                      side: BorderSide.none,
                    ),
                ],
              ),
            ],

            const SizedBox(height: 28),

            if (canBook)
              FilledButton.icon(
                onPressed: () => _book(context),
                icon: const Icon(Icons.event_available_outlined),
                label: Text(t.expertDetail.bookAppointment),
              )
            else if (isParent && !isSelf && !expert.verified)
              _EmptyHint(message: t.expertDetail.notAcceptingPatients),
          ],
        ),
      ),
    );
  }

  Future<void> _book(BuildContext context) async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => AppointmentBookingScreen(expert: expert),
      ),
    );
    if (result != null && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result)));
    }
  }
}

class _RatingLine extends StatelessWidget {
  const _RatingLine({required this.expert});
  final Expert expert;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    if (!expert.hasRating) {
      return Text(
        t.specialists.ratingNew,
        style: const TextStyle(color: AppColors.textTertiary, fontSize: 13),
      );
    }
    return Row(
      children: [
        const Icon(Icons.star, size: 16, color: AppColors.warning),
        const SizedBox(width: 4),
        Text(
          expert.avgRating.toStringAsFixed(1),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 6),
        Text(
          t.specialists.reviews(count: expert.reviewCount),
          style: const TextStyle(color: AppColors.textTertiary, fontSize: 13),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textTertiary),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Text(
        message,
        style: const TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}
