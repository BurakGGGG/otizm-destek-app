import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/core/providers.dart';
import 'package:otizm_destek_app/core/storage/secure_storage.dart';
import 'package:otizm_destek_app/core/theme/app_theme.dart';
import 'package:otizm_destek_app/features/community/presentation/community_screen.dart';
import 'package:otizm_destek_app/features/guide/presentation/guide_screen.dart';
import 'package:otizm_destek_app/features/tasks/domain/exercise_outcome.dart';
import 'package:otizm_destek_app/features/tasks/domain/expert_task.dart';
import 'package:otizm_destek_app/features/tasks/presentation/widgets/daily_exercise_wizard.dart';
import 'package:otizm_destek_app/i18n/strings.g.dart';

/// Platform kanalı olmadan çalışan bellek içi depo.
class _FakeSecureStorage extends SecureStorage {
  final _values = <String, String>{};

  @override
  Future<String?> readAccessToken() async => null;

  @override
  Future<String?> readRefreshToken() async => null;

  @override
  Future<String?> readPreference(String key) async => _values[key];

  @override
  Future<void> savePreference(String key, String value) async {
    _values[key] = value;
  }
}

Widget _host(Widget child) {
  return TranslationProvider(
    child: ProviderScope(
      overrides: [
        secureStorageProvider.overrideWithValue(_FakeSecureStorage()),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        home: child,
      ),
    ),
  );
}

void main() {
  setUp(() => LocaleSettings.setLocaleSync(AppLocale.tr));

  /// Uzun listelerin tamamı tek karede kurulsun diye yüksek bir yüzey.
  void useTallSurface(WidgetTester tester) {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1000, 4000);
    addTearDown(tester.view.reset);
  }

  testWidgets('Topluluk merkezi bütün alanları listeler', (tester) async {
    useTallSurface(tester);
    await tester.pumpWidget(_host(const CommunityScreen()));
    await tester.pump();

    final t = AppLocale.tr.buildSync();
    expect(find.text(t.community.title), findsOneWidget);
    expect(find.text(t.forum.title), findsOneWidget);
    expect(find.text(t.wall.title), findsOneWidget);
    expect(find.text(t.community.safetyTitle), findsOneWidget);
  });

  testWidgets('Egzersiz sihirbazı ilk bekleyen görevle açılır',
      (tester) async {
    useTallSurface(tester);
    final tasks = wizardTasks([
      ExpertTask(id: '1', title: 'Tamamlanan', status: kTaskCompleted),
      const ExpertTask(id: '2', title: 'Sıradaki egzersiz'),
    ]);
    await tester.pumpWidget(
      _host(
        Scaffold(
          body: SingleChildScrollView(
            child: DailyExerciseWizard(
              tasks: tasks,
              parentId: 'p1',
              onSubmitted: (_) {},
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    final t = AppLocale.tr.buildSync();
    expect(find.text('Sıradaki egzersiz'), findsOneWidget);
    expect(find.text(t.tasks.outcomeEasyTitle), findsOneWidget);
    // İlerleme: 2 görevin 1'i tamamlanmış → %50, Çiçek seviyesi.
    expect(find.text(t.tasks.wizardStageLevel(label: t.tasks.stageFlower)),
        findsOneWidget);

    // Sonuç seçilmeden teslim butonu kapalı.
    final submit = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, t.tasks.wizardSubmit),
    );
    expect(submit.onPressed, isNull);
  });

  testWidgets('Rehber arama sonuçları süzer', (tester) async {
    useTallSurface(tester);
    await tester.pumpWidget(_host(const GuideScreen()));
    await tester.pump();

    final t = AppLocale.tr.buildSync();
    // Arama öncesi: başlangıç adımları ve ilk kategori görünür.
    expect(find.text(t.guide.startTitle), findsOneWidget);
    expect(find.text(t.guide.pageHome), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'uyku');
    await tester.pump();

    // Arama sırasında başlangıç paneli gizlenir, eşleşen bölüm kalır.
    expect(find.text(t.guide.startTitle), findsNothing);
    expect(find.text(t.guide.pageTracker), findsOneWidget);
    expect(find.text(t.guide.pageHome), findsNothing);
  });
}
