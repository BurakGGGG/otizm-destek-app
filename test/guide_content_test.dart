import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/core/util/search_text.dart';
import 'package:otizm_destek_app/features/guide/domain/guide_content.dart';
import 'package:otizm_destek_app/i18n/strings.g.dart';

void main() {
  LocaleSettings.setLocaleSync(AppLocale.tr); // deterministik dil
  final t = AppLocale.tr.buildSync();

  group('arama normalleştirme (web normalizeSearchText birebir)', () {
    test('Türkçe küçük harf ve aksan katlama', () {
      expect(searchNormalize('Günlük Takip'), 'gunluk takip');
      expect(searchNormalize('İLAÇ'), 'ilac');
      // Türkçe: büyük I → ı, sonra katlanarak i olur.
      expect(searchNormalize('IŞIK'), 'isik');
    });

    test('aksansız yazım da eşleşir', () {
      expect(searchMatches('gunluk', ['Günlük Takip']), isTrue);
      expect(searchMatches('ilac', ['İlaç takibi']), isTrue);
      expect(searchMatches('uyku', ['Günlük Takip']), isFalse);
    });

    test('birden çok terimin hepsi bulunmalı', () {
      expect(searchMatches('acil kart', ['Acil Durum Kartı']), isTrue);
      expect(searchMatches('acil takvim', ['Acil Durum Kartı']), isFalse);
    });

    test('boş sorgu her şeyi eşler', () {
      expect(searchMatches('   ', ['herhangi bir metin']), isTrue);
    });
  });

  group('rehber kataloğu', () {
    test('veli rehberi üç grup ve dolu sayfalar içerir', () {
      final groups = parentGuideGroups(t);
      expect(groups.length, 3);
      expect(guidePageCount(groups), greaterThan(15));
      for (final group in groups) {
        expect(group.pages, isNotEmpty);
        for (final page in group.pages) {
          expect(page.title, isNotEmpty);
          expect(page.purpose, isNotEmpty);
          expect(page.useWhen, isNotEmpty);
          expect(page.route.startsWith('/'), isTrue);
        }
      }
    });

    test('arama grupları süzer, boş grupları düşürür', () {
      final groups = parentGuideGroups(t);
      final result = filterGuideGroups(groups, 'uyku');
      expect(result, isNotEmpty);
      expect(
        result.expand((group) => group.pages).map((page) => page.route),
        contains('/daily-tracker'),
      );
      // Yalnızca eşleşen sayfalar kalır.
      expect(guidePageCount(result), lessThan(guidePageCount(groups)));
    });

    test('anahtar kelimeler de aranır (başlıkta geçmeyen terim)', () {
      final groups = parentGuideGroups(t);
      final result = filterGuideGroups(groups, 'qr');
      expect(
        result.expand((group) => group.pages).map((page) => page.route),
        contains('/emergency'),
      );
    });

    test('eşleşme yoksa boş liste döner', () {
      expect(filterGuideGroups(parentGuideGroups(t), 'zzzz'), isEmpty);
    });

    test('uzman rehberi yalnızca mobildeki uzman bölümlerini listeler', () {
      final routes = expertGuideGroups(t)
          .expand((group) => group.pages)
          .map((page) => page.route)
          .toList();
      expect(routes, contains('/appointments'));
      // Danışanlar ve BEP mobil kapsam dışı.
      expect(routes, isNot(contains('/patients')));
      expect(routes, isNot(contains('/bep')));
    });

    test('başlangıç adımları role göre değişir', () {
      final parent = guideStartSteps(t, expert: false);
      final expert = guideStartSteps(t, expert: true);
      expect(parent.first.route, '/children');
      expect(expert.first.route, '/appointments');
      expect(parent.map((s) => s.title), isNot(equals(expert.map((s) => s.title))));
    });
  });

  group('eğitim videoları', () {
    test('web kimlikleri 01-15 (GENERAL + PARENT) korunur', () {
      final videos = parentTutorialVideos(t);
      expect(videos.length, 15);
      expect(videos.first.id, '01');
      expect(videos.last.id, '15');
      for (final video in videos) {
        expect(video.id.length, 2);
        expect(video.title, isNotEmpty);
        expect(video.duration, isNotEmpty);
      }
    });

    test('videolar da aranabilir', () {
      final videos = parentTutorialVideos(t);
      final matches = videos.where((video) => video.matches('ilac')).toList();
      expect(matches.map((video) => video.id), contains('07'));
    });
  });
}
