import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Yükleme sırasında içerik yerini tutan, nazikçe yanıp sönen iskelet liste.
/// Render soğuk başlatmada (uzun ilk istek) spinner yerine daha iyi his verir.
/// Tek bir AnimationController ile tüm kutuları sürer (verimli).
class SkeletonList extends StatefulWidget {
  const SkeletonList({
    super.key,
    this.count = 4,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.margin,
      vertical: 12,
    ),
  });

  final int count;
  final EdgeInsets padding;

  @override
  State<SkeletonList> createState() => _SkeletonListState();
}

class _SkeletonListState extends State<SkeletonList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  static const _base = Color(0xFFE2E8F0); // border
  static const _highlight = Color(0xFFF1F5F9); // surfaceVariant

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final color = Color.lerp(_base, _highlight, _c.value)!;
        return ListView.separated(
          padding: widget.padding,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.count,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (_, _) => _SkeletonCard(color: color),
        );
      },
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard({required this.color});
  final Color color;

  Widget _box(double w, double h, {double r = 6}) => Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(r),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _box(48, 48, r: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _box(width * 0.45, 14),
                  const SizedBox(height: 10),
                  _box(width * 0.7, 12),
                  const SizedBox(height: 8),
                  _box(width * 0.3, 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
