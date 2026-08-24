import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/core/config/env.dart';

void main() {
  test('ağ günlüğü sürüm derlemesinde kapalı', () {
    // Sürümde istek gövdeleri (sağlık kaydı, şifre) cihaz günlüğüne
    // düşmemeli; varsayılan debug bayrağına bağlı.
    expect(Env.enableNetworkLogs, kDebugMode);
  });
}
