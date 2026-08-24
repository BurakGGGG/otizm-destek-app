import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/media.dart';
import '../util/person_name.dart';
import '../providers.dart';

/// İsim baş harfli (veya görselli) yuvarlak avatar. Profil görseli varsa onu,
/// yoksa isimden türetilen baş harfleri sabit bir renkle gösterir.
///
/// Görsel yüklenemezse (ör. dosya silinmiş) sessizce baş harflere döner.
class UserAvatar extends ConsumerStatefulWidget {
  const UserAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.radius = 24,
    this.fallbackIcon,
  });

  final String name;
  final String? imageUrl;
  final double radius;

  /// İsim boşsa kullanılacak ikon (varsayılan: kişi).
  final IconData? fallbackIcon;

  @override
  ConsumerState<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends ConsumerState<UserAvatar> {
  bool _imageFailed = false;

  @override
  void didUpdateWidget(UserAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) _imageFailed = false;
  }

  String get name => widget.name;
  double get radius => widget.radius;

  // Sakin, düşük uyarımlı palet (tema ile uyumlu).
  static const _palette = [
    Color(0xFF2563EB), // mavi
    Color(0xFF6366F1), // indigo
    Color(0xFF0EA5E9), // gök
    Color(0xFF10B981), // yeşil
    Color(0xFF8B5CF6), // mor
    Color(0xFFF59E0B), // amber
    Color(0xFFEC4899), // pembe
    Color(0xFF14B8A6), // teal
  ];

  String get _initials => personInitials(name);

  Color get _color {
    if (name.isEmpty) return _palette.first;
    var sum = 0;
    for (final c in name.codeUnits) {
      sum += c;
    }
    return _palette[sum % _palette.length];
  }

  @override
  Widget build(BuildContext context) {
    final image = _imageFailed
        ? null
        : mediaImageProvider(widget.imageUrl, ref.watch(dioProvider));
    if (image != null) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: _color.withValues(alpha: 0.15),
        backgroundImage: image,
        onBackgroundImageError: (_, _) {
          if (mounted) setState(() => _imageFailed = true);
        },
      );
    }
    final initials = _initials;
    final color = _color;
    return CircleAvatar(
      radius: radius,
      backgroundColor: color.withValues(alpha: 0.15),
      child: initials.isNotEmpty
          ? Text(
              initials,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: radius * 0.72,
              ),
            )
          : Icon(
              widget.fallbackIcon ?? Icons.person,
              color: color,
              size: radius,
            ),
    );
  }
}
