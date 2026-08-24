import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/util/search_text.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../../i18n/strings.g.dart';
import '../data/expert_repository.dart';
import '../domain/expert.dart';
import 'expert_detail_screen.dart';
import '../data/favorite_experts.dart';

/// Uzmanlar sekmesi — `GET /api/experts` gerçek verisi + arama/filtre.
class SpecialistsTab extends ConsumerStatefulWidget {
  const SpecialistsTab({super.key});

  @override
  ConsumerState<SpecialistsTab> createState() => _SpecialistsTabState();
}

/// Sıralama seçenekleri (web ExpertsPage `sortBy` karşılığı).
enum _ExpertSort { none, rating, name }

class _SpecialistsTabState extends ConsumerState<SpecialistsTab> {
  int _filter = 0;
  String _query = '';
  String? _city;
  bool _onlyAccepting = false;
  bool _onlyVerified = false;
  bool _onlyOnline = false;
  bool _onlyFavorites = false;
  _ExpertSort _sort = _ExpertSort.none;

  bool get _hasExtraFilters =>
      _city != null ||
      _onlyAccepting ||
      _onlyVerified ||
      _onlyOnline ||
      _onlyFavorites ||
      _sort != _ExpertSort.none;

  // Filtre anahtarları backend verisine (Türkçe) göre eşleşir; etiketler yerelleştirilir.
  static const List<String?> _filterKeywords = [
    null, // Tümü
    'psikolo', // Psikolog / Psikoloğu
    'eğitim', // Özel Eğitim
    'dil', // Dil ve Konuşma
  ];

  bool _matches(Expert e, Set<String> favorites) {
    final keyword = _filterKeywords[_filter];
    if (keyword != null && !_hasKeyword(e, keyword)) return false;
    if (_city != null && e.city != _city) return false;
    if (_onlyAccepting && !e.acceptingPatients) return false;
    if (_onlyVerified && !e.verified) return false;
    if (_onlyOnline && !e.offersOnline) return false;
    if (_onlyFavorites && !favorites.contains(e.id)) return false;
    if (_query.isEmpty) return true;
    return searchMatches(_query, [
      e.fullName,
      e.expertTitle ?? '',
      e.institution ?? '',
      e.city ?? '',
      ...e.specializations,
    ]);
  }

  /// Seçili sıralamayı uygular (varsayılan: backend sırası).
  List<Expert> _sorted(List<Expert> experts) {
    final list = [...experts];
    switch (_sort) {
      case _ExpertSort.rating:
        list.sort((a, b) => b.avgRating.compareTo(a.avgRating));
      case _ExpertSort.name:
        list.sort((a, b) => a.fullName.compareTo(b.fullName));
      case _ExpertSort.none:
        break;
    }
    return list;
  }

  Future<void> _openFilters(List<Expert> experts) async {
    final cities = experts
        .map((e) => e.city)
        .whereType<String>()
        .where((city) => city.trim().isNotEmpty)
        .toSet()
        .toList()
      ..sort();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => _FilterSheet(
        cities: cities,
        city: _city,
        onlyAccepting: _onlyAccepting,
        onlyVerified: _onlyVerified,
        onlyOnline: _onlyOnline,
        onlyFavorites: _onlyFavorites,
        sort: _sort,
        onApply: (selection) {
          setState(() {
            _city = selection.city;
            _onlyAccepting = selection.accepting;
            _onlyVerified = selection.verified;
            _onlyOnline = selection.online;
            _onlyFavorites = selection.favorites;
            _sort = selection.sort;
          });
        },
      ),
    );
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
    // Favori değişince "yalnızca favorilerim" listesi anında güncellensin.
    final favorites = ref.watch(favoriteExpertsProvider);

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
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (v) => setState(() => _query = v.trim()),
                        decoration: InputDecoration(
                          hintText: t.specialists.searchHint,
                          prefixIcon: Icon(
                            Icons.search,
                            color: context.colors.textTertiary,
                          ),
                          fillColor: context.colors.surface,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      tooltip: t.specialists.filters,
                      onPressed: () =>
                          _openFilters(expertsAsync.asData?.value ?? const []),
                      icon: Badge(
                        isLabelVisible: _hasExtraFilters,
                        smallSize: 8,
                        child: const Icon(Icons.tune, size: 20),
                      ),
                    ),
                  ],
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
                      selectedColor: context.colors.primary,
                      backgroundColor: context.colors.surface,
                      side: BorderSide(color: context.colors.border),
                      labelStyle: TextStyle(
                        color: _filter == i
                            ? Colors.white
                            : context.colors.textSecondary,
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
              loading: () => const SkeletonList(count: 6),
              error: (e, _) =>
                  ErrorRetry(onRetry: () => ref.invalidate(expertsProvider)),
              data: (experts) {
                final filtered = _sorted(
                  experts.where((e) => _matches(e, favorites)).toList(),
                );
                if (filtered.isEmpty) {
                  return EmptyState(
                    icon: Icons.person_search_outlined,
                    message: t.specialists.noResults,
                  );
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

class _ExpertCard extends ConsumerWidget {
  const _ExpertCard({required this.expert});
  final Expert expert;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final isFavorite = ref.watch(favoriteExpertsProvider).contains(expert.id);
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
                                Icon(
                                  Icons.verified,
                                  size: 16,
                                  color: context.colors.primary,
                                ),
                              ],
                            ],
                          ),
                        ),
                        Icon(
                          Icons.star,
                          size: 16,
                          color: context.colors.warning,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          e.hasRating
                              ? e.avgRating.toStringAsFixed(1)
                              : t.specialists.ratingNew,
                          style: text.bodySmall,
                        ),
                        IconButton(
                          tooltip: isFavorite
                              ? t.specialists.removeFavorite
                              : t.specialists.addFavorite,
                          visualDensity: VisualDensity.compact,
                          onPressed: () => ref
                              .read(favoriteExpertsProvider.notifier)
                              .toggle(e.id),
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 18,
                            color: isFavorite
                                ? context.colors.error
                                : context.colors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                    if (e.expertTitle?.isNotEmpty ?? false)
                      Text(e.expertTitle!, style: text.bodySmall),
                    if (e.city?.isNotEmpty ?? false)
                      Text(
                        e.city!,
                        style: text.bodySmall?.copyWith(
                          color: context.colors.textTertiary,
                        ),
                      ),
                    // Hizmet biçimi ve ücret — web kartındaki rozetler.
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        if (e.offersOnline)
                          _MetaChip(
                            label: t.expertDetail.serviceOnline,
                            color: context.colors.primary,
                          ),
                        if (e.offersFaceToFace)
                          _MetaChip(
                            label: t.expertDetail.serviceFaceToFace,
                            color: context.colors.success,
                          ),
                        if (expertFeeLabel(e) != null)
                          _MetaChip(
                            label: expertFeeLabel(e)!,
                            color: context.colors.textSecondary,
                          ),
                      ],
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
                                color: context.colors.primary.withValues(
                                  alpha: 0.10,
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppRadius.sm,
                                ),
                              ),
                              child: Text(
                                tag,
                                style: TextStyle(
                                  color: context.colors.primary,
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

/// Uzman filtreleri (web'deki şehir/durum/sıralama filtrelerinin mobil
/// karşılığı; "Uygula" denene kadar liste değişmez).
/// Filtre sayfasının sonucu (alan sayısı arttıkça konumsal parametreler
/// okunmaz hale geldiği için tek kayıt olarak taşınır).
typedef ExpertFilterSelection = ({
  String? city,
  bool accepting,
  bool verified,
  bool online,
  bool favorites,
  _ExpertSort sort,
});

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({
    required this.cities,
    required this.city,
    required this.onlyAccepting,
    required this.onlyVerified,
    required this.onlyOnline,
    required this.onlyFavorites,
    required this.sort,
    required this.onApply,
  });

  final List<String> cities;
  final String? city;
  final bool onlyAccepting;
  final bool onlyVerified;
  final bool onlyOnline;
  final bool onlyFavorites;
  final _ExpertSort sort;
  final ValueChanged<ExpertFilterSelection> onApply;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late String? _city = widget.city;
  late bool _accepting = widget.onlyAccepting;
  late bool _verified = widget.onlyVerified;
  late bool _online = widget.onlyOnline;
  late bool _favorites = widget.onlyFavorites;
  late _ExpertSort _sort = widget.sort;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.margin),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.specialists.filters, style: text.titleMedium),
              const SizedBox(height: 12),
              if (widget.cities.isNotEmpty) ...[
                Text(
                  t.specialists.cityLabel,
                  style: text.labelMedium
                      ?.copyWith(color: context.colors.textSecondary),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      label: Text(t.specialists.filterAll),
                      selected: _city == null,
                      onSelected: (_) => setState(() => _city = null),
                    ),
                    for (final city in widget.cities)
                      ChoiceChip(
                        label: Text(city),
                        selected: _city == city,
                        onSelected: (_) => setState(() => _city = city),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
              Text(
                t.specialists.sortLabel,
                style: text.labelMedium
                    ?.copyWith(color: context.colors.textSecondary),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children: [
                  for (final option in [
                    (_ExpertSort.none, t.specialists.sortDefault),
                    (_ExpertSort.rating, t.specialists.sortRating),
                    (_ExpertSort.name, t.specialists.sortName),
                  ])
                    ChoiceChip(
                      label: Text(option.$2),
                      selected: _sort == option.$1,
                      onSelected: (_) => setState(() => _sort = option.$1),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _accepting,
                onChanged: (v) => setState(() => _accepting = v),
                title: Text(t.specialists.onlyAccepting),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _verified,
                onChanged: (v) => setState(() => _verified = v),
                title: Text(t.specialists.onlyVerified),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _online,
                onChanged: (v) => setState(() => _online = v),
                title: Text(t.specialists.onlyOnline),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _favorites,
                onChanged: (v) => setState(() => _favorites = v),
                title: Text(t.specialists.onlyFavorites),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        widget.onApply((
                          city: null,
                          accepting: false,
                          verified: false,
                          online: false,
                          favorites: false,
                          sort: _ExpertSort.none,
                        ));
                        Navigator.of(context).pop();
                      },
                      child: Text(t.specialists.clearFilters),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        widget.onApply((
                          city: _city,
                          accepting: _accepting,
                          verified: _verified,
                          online: _online,
                          favorites: _favorites,
                          sort: _sort,
                        ));
                        Navigator.of(context).pop();
                      },
                      child: Text(t.specialists.applyFilters),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Kart üstündeki küçük bilgi rozeti (hizmet biçimi, ücret).
class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: color),
      ),
    );
  }
}
