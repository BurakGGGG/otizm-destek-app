import 'package:flutter/material.dart';

import '../../i18n/strings.g.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../util/password_rules.dart';

/// [PasswordIssue] için kullanıcıya gösterilecek yerelleştirilmiş mesaj.
String passwordIssueMessage(BuildContext context, PasswordIssue issue) {
  final t = context.t;
  return switch (issue) {
    PasswordIssue.tooShort => t.password.errorTooShort,
    PasswordIssue.tooLong => t.password.errorTooLong,
    PasswordIssue.noUppercase => t.password.errorNoUppercase,
    PasswordIssue.noDigit => t.password.errorNoDigit,
    PasswordIssue.noSpecial => t.password.errorNoSpecial,
    PasswordIssue.common => t.password.errorCommon,
  };
}

/// Şifre gücü çubuğu + kural rozetleri (web kayıt ekranı birebir).
///
/// Boş şifrede yalnızca kural listesini gösterir; kullanıcı yazmaya başlayınca
/// çubuk ve etiket görünür.
class PasswordStrengthMeter extends StatelessWidget {
  const PasswordStrengthMeter({super.key, required this.password});

  final String password;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final score = passwordStrength(password);
    final (label, color) = switch (score) {
      <= 1 => (t.password.strengthVeryWeak, colors.error),
      2 => (t.password.strengthWeak, const Color(0xFFF97316)),
      3 => (t.password.strengthMedium, const Color(0xFFEAB308)),
      4 => (t.password.strengthStrong, const Color(0xFF10B981)),
      _ => (t.password.strengthVeryStrong, const Color(0xFF059669)),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (password.isNotEmpty) ...[
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  child: LinearProgressIndicator(
                    value: score / 5,
                    minHeight: 6,
                    backgroundColor: colors.surfaceVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: text.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 4,
          children: [
            for (final rule in PasswordRule.values)
              _RuleChip(
                label: switch (rule) {
                  PasswordRule.minLength => t.password.ruleMinLength,
                  PasswordRule.uppercase => t.password.ruleUppercase,
                  PasswordRule.digit => t.password.ruleDigit,
                  PasswordRule.special => t.password.ruleSpecial,
                },
                satisfied: passwordRuleSatisfied(rule, password),
              ),
          ],
        ),
      ],
    );
  }
}

class _RuleChip extends StatelessWidget {
  const _RuleChip({required this.label, required this.satisfied});

  final String label;
  final bool satisfied;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = satisfied ? colors.success : colors.textTertiary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          satisfied ? Icons.check_circle : Icons.circle_outlined,
          size: 14,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: color),
        ),
      ],
    );
  }
}
