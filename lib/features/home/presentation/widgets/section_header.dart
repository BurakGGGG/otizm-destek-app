import 'package:flutter/material.dart';

import '../../../../i18n/strings.g.dart';

/// Bölüm başlığı + opsiyonel aksiyon ("Tümünü Gör" / "Daha Fazla").
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;

  /// Boş bırakılırsa "Tümünü Gör" (yerelleştirilmiş) kullanılır.
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        if (onAction != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: const Size(0, 36),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(actionLabel ?? context.t.common.seeAll),
          ),
      ],
    );
  }
}
