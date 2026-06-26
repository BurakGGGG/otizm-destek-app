import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../i18n/strings.g.dart';

/// Uzmanlar sekmesi — Stitch "Uzman Bulun" tasarımı.
/// Veriler şimdilik örnek; Faz 2'de backend (/api/experts) bağlanacak.
class SpecialistsTab extends StatefulWidget {
  const SpecialistsTab({super.key});

  @override
  State<SpecialistsTab> createState() => _SpecialistsTabState();
}

class _SpecialistsTabState extends State<SpecialistsTab> {
  int _filter = 0;

  // Örnek veri — Faz 2'de /api/experts'tan gelecek.
  static const _specialists = <_Specialist>[
    _Specialist('Dr. Ayşe Yılmaz', 'Çocuk Psikoloğu', 4.9, ['Otizm', 'DEHB']),
    _Specialist('Ahmet Kaya', 'Özel Eğitim Uzmanı', 4.8, ['Davranış Terapisi']),
    _Specialist('Elif Demir', 'Dil ve Konuşma Terapisti', 5.0,
        ['Artikülasyon', 'Gecikmiş Konuşma']),
  ];

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final filters = [
      t.specialists.filterAll,
      t.specialists.filterPsychologist,
      t.specialists.filterSpecialEducation,
      t.specialists.filterSpeech,
    ];

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.margin, 8, AppSpacing.margin, 24),
        children: [
          Text(t.specialists.title, style: text.headlineLarge),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: t.specialists.searchHint,
              prefixIcon:
                  const Icon(Icons.search, color: AppColors.textTertiary),
              fillColor: AppColors.surface,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) => ChoiceChip(
                label: Text(filters[i]),
                selected: _filter == i,
                onSelected: (_) => setState(() => _filter = i),
                showCheckmark: false,
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.surface,
                side: const BorderSide(color: AppColors.border),
                labelStyle: TextStyle(
                  color: _filter == i ? Colors.white : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          for (final s in _specialists) ...[
            _SpecialistCard(specialist: s),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _Specialist {
  const _Specialist(this.name, this.title, this.rating, this.tags);
  final String name;
  final String title;
  final double rating;
  final List<String> tags;
}

class _SpecialistCard extends StatelessWidget {
  const _SpecialistCard({required this.specialist});
  final _Specialist specialist;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
              child: const Icon(Icons.person, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Text(specialist.name, style: text.titleMedium)),
                      const Icon(Icons.star,
                          size: 16, color: AppColors.warning),
                      const SizedBox(width: 2),
                      Text(specialist.rating.toString(), style: text.bodySmall),
                    ],
                  ),
                  Text(specialist.title, style: text.bodySmall),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final tag in specialist.tags)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Text(tag,
                              style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600)),
                        ),
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
