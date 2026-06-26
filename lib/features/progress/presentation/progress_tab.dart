import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../i18n/strings.g.dart';

/// Gelişim sekmesi — Stitch "Gelişim Takibi" tasarımı.
/// Veriler şimdilik örnek; Faz 2'de backend (/api/notes, /api/goals).
class ProgressTab extends StatelessWidget {
  const ProgressTab({super.key});

  static const _weekValues = [0.4, 0.6, 0.3, 0.9, 0.5, 0.7, 0.2];
  static const _todayIndex = 3;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.margin, 8, AppSpacing.margin, 24),
        children: [
          Text(t.progress.title, style: text.headlineLarge),
          const SizedBox(height: 4),
          Text(t.progress.subtitle, style: text.bodySmall),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: Text(t.progress.addRecord),
          ),
          const SizedBox(height: 16),
          _WeeklyActivityCard(
            days: t.progress.weekdays,
            values: _weekValues,
            todayIndex: _todayIndex,
          ),
          const SizedBox(height: 24),
          Text(t.progress.completedTasks, style: text.titleMedium),
          const SizedBox(height: 12),
          // Örnek veri — Faz 2'de /api/notes'tan gelecek.
          _TaskTile(
            icon: Icons.extension_outlined,
            title: 'Eğitici Oyunlar',
            description:
                'Şekil eşleştirme bulmacası 15 dakika boyunca tamamlandı.',
            category: t.progress.categoryCognitive,
            status: t.progress.statusCompleted,
            statusColor: AppColors.success,
            date: 'Bugün, 14:30',
          ),
          _TaskTile(
            icon: Icons.groups_outlined,
            title: 'Sosyal Etkileşim',
            description: 'Parkta diğer çocuklarla 20 dakika oyun oynandı.',
            category: t.progress.categoryCommunication,
            status: t.progress.statusCompleted,
            statusColor: AppColors.success,
            date: 'Dün, 16:00',
          ),
          _TaskTile(
            icon: Icons.record_voice_over_outlined,
            title: 'Konuşma Pratiği',
            description: 'Yeni kelime tekrarları yapıldı, süre kısa tutuldu.',
            category: t.progress.categoryCommunication,
            status: t.progress.statusPartial,
            statusColor: AppColors.warning,
            date: 'Dün, 10:15',
          ),
        ],
      ),
    );
  }
}

class _WeeklyActivityCard extends StatelessWidget {
  const _WeeklyActivityCard({
    required this.days,
    required this.values,
    required this.todayIndex,
  });

  final List<String> days;
  final List<double> values;
  final int todayIndex;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(t.progress.weeklyActivity, style: text.titleMedium),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Text(t.progress.thisWeek,
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (var i = 0; i < days.length; i++)
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 90 * values[i] + 8,
                            decoration: BoxDecoration(
                              color: i == todayIndex
                                  ? AppColors.primary
                                  : AppColors.primary.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(days[i],
                              style: TextStyle(
                                fontSize: 11,
                                color: i == todayIndex
                                    ? AppColors.primary
                                    : AppColors.textTertiary,
                                fontWeight: i == todayIndex
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                              )),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.statusColor,
    required this.date,
  });

  final IconData icon;
  final String title;
  final String description;
  final String category;
  final String status;
  final Color statusColor;
  final String date;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(icon, size: 20, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(title, style: text.titleMedium)),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Text(status,
                            style: TextStyle(
                                color: statusColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(description,
                      style: text.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(category,
                          style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                      const Spacer(),
                      Text(date, style: text.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
