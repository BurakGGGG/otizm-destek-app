import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/core/providers.dart';
import 'package:otizm_destek_app/core/storage/secure_storage.dart';
import 'package:otizm_destek_app/core/theme/app_theme.dart';
import 'package:dio/dio.dart';
import 'package:otizm_destek_app/features/appointments/presentation/appointment_booking_screen.dart';
import 'package:otizm_destek_app/features/appointments/data/appointment_repository.dart';
import 'package:otizm_destek_app/features/appointments/domain/expert_availability.dart';
import 'package:otizm_destek_app/features/children/data/child_repository.dart';
import 'package:otizm_destek_app/features/children/domain/child.dart';
import 'package:otizm_destek_app/features/specialists/domain/expert.dart';
import 'package:otizm_destek_app/i18n/strings.g.dart';

class _FakeSecureStorage extends SecureStorage {
  @override
  Future<String?> readAccessToken() async => null;
  @override
  Future<String?> readRefreshToken() async => null;
  @override
  Future<String?> readPreference(String key) async => null;
  @override
  Future<void> savePreference(String key, String value) async {}
}

/// Ağ çağrısı yapmayan çocuk deposu (form çocuk listesi çekiyor).
class _FakeChildRepository extends ChildRepository {
  _FakeChildRepository() : super(Dio());

  @override
  Future<List<Child>> getChildren() async =>
      const [Child(id: 'c1', name: 'Ada')];
}

/// Müsaitlik uç noktası da ağa gitmesin.
class _FakeAppointmentRepository extends AppointmentRepository {
  _FakeAppointmentRepository() : super(Dio());

  @override
  Future<List<ExpertAvailability>> getAvailability(String expertId) async =>
      const [];
}

Widget _host(Expert expert) {
  return TranslationProvider(
    child: ProviderScope(
      overrides: [
        secureStorageProvider.overrideWithValue(_FakeSecureStorage()),
        childRepositoryProvider.overrideWithValue(_FakeChildRepository()),
        appointmentRepositoryProvider
            .overrideWithValue(_FakeAppointmentRepository()),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        home: AppointmentBookingScreen(expert: expert),
      ),
    ),
  );
}

void main() {
  setUp(() => LocaleSettings.setLocaleSync(AppLocale.tr));

  testWidgets('yalnızca online çalışan uzmanda yüz yüze seçeneği yok',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1000, 2400);
    addTearDown(tester.view.reset);

    const expert = Expert(
      id: 'e1',
      fullName: 'Uzm. Ece Demir',
      offersFaceToFace: false,
    );
    await tester.pumpWidget(_host(expert));
    await tester.pump();

    final t = AppLocale.tr.buildSync();
    expect(find.text(t.appointments.typeOnline), findsOneWidget);
    expect(find.text(t.appointments.typeFaceToFace), findsNothing);
  });

  testWidgets('iki biçimi de sunan uzmanda ikisi de görünür', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1000, 2400);
    addTearDown(tester.view.reset);

    const expert = Expert(id: 'e2', fullName: 'Uzm. Psk. Selin Aksoy');
    await tester.pumpWidget(_host(expert));
    await tester.pump();

    final t = AppLocale.tr.buildSync();
    expect(find.text(t.appointments.typeOnline), findsOneWidget);
    expect(find.text(t.appointments.typeFaceToFace), findsOneWidget);
  });
}
