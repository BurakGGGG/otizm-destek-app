import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/core/providers.dart';
import 'package:otizm_destek_app/core/storage/secure_storage.dart';
import 'package:otizm_destek_app/features/routines/data/routine_progress_controller.dart';
import 'package:otizm_destek_app/features/routines/presentation/routines_screen.dart';
import 'package:otizm_destek_app/i18n/strings.g.dart';

import 'support/fake_backend.dart';

/// Rutin adımlarının günlük işaretlenmesi cihazda saklanır (web'de de
/// localStorage). Yıldız sayacı tamamlamada artar, geri almada azalır.
/// Not: gerçek uygulama anahtarları `pref_` önekiyle yazar; burada
/// [SecureStorage.readPreference] doğrudan ezildiği için önek yok.
class _MemoryStorage extends SecureStorage {
  final values = <String, String>{};

  @override
  Future<String?> readPreference(String key) async => values[key];

  @override
  Future<void> savePreference(String key, String value) async {
    values[key] = value;
  }
}

void main() {
  setUpAll(loadTestFonts);

  ProviderContainer container(_MemoryStorage storage) {
    final c = ProviderContainer(
      overrides: [secureStorageProvider.overrideWithValue(storage)],
    );
    addTearDown(c.dispose);
    return c;
  }

  test('adım işaretlenir, yıldız artar ve kaydedilir', () async {
    final storage = _MemoryStorage();
    final c = container(storage);
    final notifier = c.read(routineProgressProvider.notifier);

    expect(await notifier.toggle('r1', 'i1'), isTrue);
    expect(c.read(routineProgressProvider).isDone('r1', 'i1'), isTrue);
    expect(c.read(routineProgressProvider).stars, 1);
    expect(storage.values['routine_stars'], '1');
    expect(storage.values['routine_completed'], contains('i1'));
  });

  test('geri alınca yıldız düşer ama eksiye inmez', () async {
    final c = container(_MemoryStorage());
    final notifier = c.read(routineProgressProvider.notifier);

    await notifier.toggle('r1', 'i1');
    expect(await notifier.toggle('r1', 'i1'), isFalse);
    expect(c.read(routineProgressProvider).isDone('r1', 'i1'), isFalse);
    expect(c.read(routineProgressProvider).stars, 0);

    await notifier.toggle('r1', 'i1');
    await notifier.toggle('r1', 'i1');
    await notifier.toggle('r1', 'i1');
    expect(c.read(routineProgressProvider).stars, 1);
  });

  test('tamamlanma yüzdesi adım sayısına göre hesaplanır', () async {
    final c = container(_MemoryStorage());
    final notifier = c.read(routineProgressProvider.notifier);
    await notifier.toggle('r1', 'i1');
    await notifier.toggle('r1', 'i2');

    final progress = c.read(routineProgressProvider);
    expect(progress.percentOf('r1', 4), 50);
    expect(progress.percentOf('r1', 0), 0);
    expect(progress.percentOf('bilinmeyen', 3), 0);
  });

  test('dünün kayıtları bugüne taşınmaz, yıldız korunur', () async {
    final storage = _MemoryStorage()
      ..values['routine_stars'] = '7'
      ..values['routine_completed'] =
          '{"date":"2020-01-01","items":{"r1":["i1"]}}';
    final c = container(storage);
    await c.read(routineProgressProvider.notifier).ready;

    final progress = c.read(routineProgressProvider);
    expect(progress.stars, 7);
    expect(progress.isDone('r1', 'i1'), isFalse);
  });

  testWidgets('rutin adımına dokununca tamamlandı işaretlenir',
      (tester) async {
    final t = AppLocale.tr.buildSync();
    usePhoneSurface(tester);
    await tester.pumpWidget(hostApp(const RoutinesScreen()));
    await settleScreen(tester);

    expect(find.text(t.routines.starWallet(count: '0')), findsOneWidget);

    await tester.tap(find.text('Diş fırçalama'));
    await tester.pumpAndSettle();

    expect(find.text(t.routines.starWallet(count: '1')), findsOneWidget);
    expect(find.text(t.routines.stepDone), findsOneWidget);
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
  });
}
