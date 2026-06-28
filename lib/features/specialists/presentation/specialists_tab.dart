import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../../i18n/strings.g.dart';
import '../data/expert_repository.dart';
import '../domain/expert.dart';
import 'expert_detail_screen.dart';

/// Uzmanlar sekmesi — `GET /api/experts` gerçek verisi + arama/filtre.
class SpecialistsTab extends ConsumerStatefulWidget {
  const SpecialistsTab({super.key});

  @override
  ConsumerState<SpecialistsTab> createState() => _SpecialistsTabState();
}

class _SpecialistsTabState extends ConsumerState<SpecialistsTab> {
  int _filter = 0;
  String _query = '';

  // Filtre anahtarları backend verisine (Türkçe) göre eşleşir; etiketler yerelleştirilir.
  static const List<String?> _filterKeywords = [
    null, // Tümü
    'psikolo', // Psikolog / Psikoloğu
    'eğitim', // Özel Eğitim
    'dil', // Dil ve Konuşma
  ];

  bool _matches(Expert e) {
    final keyword = _filterKeywords[_filter];
    if (keyword != null && !_hasKeyword(e, keyword)) return false;
    if (_query.isEmpty) return true;
    final q = _query.toLowerCase();
    return e.fullName.toLowerCase().contains(q) ||
        (e.expertTitle?.toLowerCase().contains(q) ?? false) ||
        e.specializations.any((s) => s.toLowerCase().contains(q));
  }

  bool _hasKeyword(Expert e, String keyword) {
    return (e.expertTitle?.toLowerCase().contains(keyword) ?? false) ||
        e.specializations.any((s) => s.toLowerCase().contains(keyword));
  }

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
    final expertsAsync = ref.watch(expertsProvider);

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.margin,
              8,
              AppSpacing.margin,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.specialists.title, style: text.headlineLarge),
                const SizedBox(height: 16),
                TextField(
                  onChanged: (v) => setState(() => _query = v.trim()),
                  decoration: InputDecoration(
                    hintText: t.specialists.searchHint,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.textTertiary,
                    ),
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
                        color: _filter == i
                            ? Colors.white
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          Expanded(
            child: expertsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) =>
                  _ErrorView(onRetry: () => ref.invalidate(expertsProvider)),
              data: (experts) {
                final filtered = experts.where(_matches).toList();
                if (filtered.isEmpty) {
                  return _EmptyView(message: t.specialists.noResults);
                }
                return RefreshIndicator(
                  onRefresh: () async => ref.invalidate(expertsProvider),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.margin,
                      8,
                      AppSpacing.margin,
                      24,
                    ),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => _ExpertCard(expert: filtered[i]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpertCard extends StatelessWidget {
  const _ExpertCard({required this.expert});
  final Expert expert;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final e = expert;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ExpertDetailScreen(expert: e)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserAvatar(
                name: e.fullName,
                imageUrl: e.profileImageUrl,
                radius: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  e.fullName,
                                  style: text.titleMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (e.verified) ...[
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.verified,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                              ],
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: AppColors.warning,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          e.hasRating
                              ? e.avgRating.toStringAsFixed(1)
                              : t.specialists.ratingNew,
                          style: text.bodySmall,
                        ),
                      ],
                    ),
                    if (e.expertTitle?.isNotEmpty ?? false)
                      Text(e.expertTitle!, style: text.bodySmall),
                    if (e.city?.isNotEmpty ?? false)
                      Text(
                        e.city!,
                        style: text.bodySmall?.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    if (e.specializations.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          for (final tag in e.specializations.take(4))
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(
                                  alpha: 0.10,
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppRadius.sm,
                                ),
                              ),
                              child: Text(
                                tag,
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
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
              Icons.search_off,
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
