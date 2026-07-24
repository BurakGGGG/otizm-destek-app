import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../i18n/strings.g.dart';
import '../../domain/article.dart';

/// Makale format rozeti (Makale / Video / Podcast) — ikon + etiket.
class ArticleFormatBadge extends StatelessWidget {
  const ArticleFormatBadge({super.key, required this.media});
  final ArticleMedia media;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final (label, icon, color) = switch (media) {
      ArticleMedia.video => (
        t.knowledge.formatVideo,
        Icons.play_circle_outline,
        context.colors.error,
      ),
      ArticleMedia.podcast => (
        t.knowledge.formatPodcast,
        Icons.mic_none,
        context.colors.secondary,
      ),
      ArticleMedia.none => (
        t.knowledge.formatArticle,
        Icons.article_outlined,
        context.colors.primary,
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
