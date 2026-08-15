import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/features/legal/domain/legal_documents.dart';
import 'package:otizm_destek_app/features/legal/presentation/legal_screen.dart';

void main() {
  group('yasal metinler (web PublicInfoPage birebir)', () {
    test('beş belge de tanımlı ve bölüm sayıları web ile aynı', () {
      expect(kLegalDocuments.length, LegalDocumentKind.values.length);
      expect(kLegalDocuments[LegalDocumentKind.trust]!.sections.length, 6);
      expect(kLegalDocuments[LegalDocumentKind.kvkk]!.sections.length, 7);
      expect(kLegalDocuments[LegalDocumentKind.privacy]!.sections.length, 7);
      expect(kLegalDocuments[LegalDocumentKind.terms]!.sections.length, 6);
      expect(kLegalDocuments[LegalDocumentKind.medical]!.sections.length, 5);
    });

    test('metin sürümü backend rıza sürümüyle aynı tutulmalı', () {
      expect(kLegalPolicyVersion, '1.1');
      expect(kLegalLastUpdated, isNotEmpty);
    });

    test('hiçbir bölüm boş değil', () {
      for (final doc in kLegalDocuments.values) {
        expect(doc.title, isNotEmpty);
        expect(doc.summary, isNotEmpty);
        for (final section in doc.sections) {
          expect(section.title, isNotEmpty);
          expect(section.paragraphs, isNotEmpty);
          for (final paragraph in section.paragraphs) {
            expect(paragraph.trim(), isNotEmpty);
          }
        }
      }
    });

    test('KVKK metni açık rıza ve haklar bölümlerini içerir', () {
      final titles = kLegalDocuments[LegalDocumentKind.kvkk]!.sections
          .map((s) => s.title)
          .toList();
      expect(titles, contains('Açık rızaya bağlı işlemeler'));
      expect(titles, contains('Haklarınız ve başvuru'));
      expect(titles, contains('Saklama ve imha süresi'));
    });

    test('rota parametresi belgeye çözülür, bilinmeyen değer güvenli döner', () {
      expect(legalKindFromName('kvkk'), LegalDocumentKind.kvkk);
      expect(legalKindFromName('medical'), LegalDocumentKind.medical);
      expect(legalKindFromName('bilinmeyen'), LegalDocumentKind.trust);
      expect(legalKindFromName(null), LegalDocumentKind.trust);
    });
  });
}
