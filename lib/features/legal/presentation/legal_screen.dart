import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../i18n/strings.g.dart';
import '../domain/legal_documents.dart';

/// Yasal metin listesi (`/legal`) — web'in genel sayfalarının uygulama içi
/// karşılığı. Metinler Türkçe ve bağlayıcı olduğundan çevrilmez.
class LegalIndexScreen extends StatelessWidget {
  const LegalIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(t.legal.title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.margin),
          children: [
            Text(t.legal.subtitle, style: text.bodySmall),
            const SizedBox(height: AppSpacing.md),
            for (final doc in kLegalDocuments.values)
              Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Icon(_iconFor(doc.kind), color: colors.primary),
                  title: Text(doc.title),
                  subtitle: Text(doc.eyebrow, style: text.bodySmall),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/legal/${doc.kind.name}'),
                ),
              ),
            const SizedBox(height: 8),
            Text(
              t.legal.versionLine(
                version: kLegalPolicyVersion,
                date: kLegalLastUpdated,
              ),
              style: text.labelSmall?.copyWith(color: colors.textTertiary),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tek bir yasal metin (`/legal/:kind`).
class LegalDocumentScreen extends StatelessWidget {
  const LegalDocumentScreen({super.key, required this.kind});

  final LegalDocumentKind kind;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final doc = kLegalDocuments[kind]!;

    return Scaffold(
      appBar: AppBar(title: Text(doc.title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.margin),
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: colors.primary.withValues(alpha: .12),
                  child: Icon(_iconFor(doc.kind), color: colors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    doc.eyebrow,
                    style: text.labelSmall?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(doc.summary, style: text.bodyMedium),
            const SizedBox(height: AppSpacing.md),
            for (final section in doc.sections) ...[
              Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(section.title, style: text.titleSmall),
                      const SizedBox(height: 8),
                      for (final paragraph in section.paragraphs) ...[
                        Text(paragraph, style: text.bodySmall),
                        if (paragraph != section.paragraphs.last)
                          const SizedBox(height: 8),
                      ],
                    ],
                  ),
                ),
              ),
            ],
            Text(
              t.legal.versionLine(
                version: kLegalPolicyVersion,
                date: kLegalLastUpdated,
              ),
              style: text.labelSmall?.copyWith(color: colors.textTertiary),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: colors.warning.withValues(alpha: .10),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Text(
                kLegalDraftNotice,
                style: text.labelSmall?.copyWith(color: colors.textSecondary),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

IconData _iconFor(LegalDocumentKind kind) => switch (kind) {
  LegalDocumentKind.trust => Icons.verified_user_outlined,
  LegalDocumentKind.kvkk => Icons.shield_outlined,
  LegalDocumentKind.privacy => Icons.lock_outline,
  LegalDocumentKind.terms => Icons.description_outlined,
  LegalDocumentKind.medical => Icons.medical_information_outlined,
};

/// Rota parametresinden belge türü (bilinmeyen değerde güven merkezi).
LegalDocumentKind legalKindFromName(String? name) {
  return LegalDocumentKind.values.firstWhere(
    (kind) => kind.name == name,
    orElse: () => LegalDocumentKind.trust,
  );
}
