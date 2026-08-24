#!/usr/bin/env bash
# Bağımlılık denetimi — elle çalıştırılır:  bash tool/audit_deps.sh
#
# Dart/pub'da `npm audit` karşılığı bir komut YOK (SDK 3.12 itibarıyla).
# Bilinen açıklar pub.dev'de paket sayfasındaki "Security advisories"
# bölümünde ve OSV veritabanında yayımlanıyor; bu betik makinede
# yapılabilecek kısmı otomatikleştirir:
#   1. kısıt içinde güncelleme var mı,
#   2. büyük sürüm geride kalan doğrudan bağımlılıklar,
#   3. kullanımdan kaldırılmış (discontinued) paket uyarısı.
set -uo pipefail
cd "$(dirname "$0")/.."

echo "== 1) Kısıt içinde güncellenebilir olanlar =="
flutter pub outdated --no-dev-dependencies --no-transitive || true

echo
echo "== 2) Kullanımdan kaldırılmış paket uyarısı =="
flutter pub get 2>&1 | grep -iE "discontinued|retracted|deprecated" \
  || echo "Uyarı yok."

echo
echo "== 3) Sonraki adım (elle) =="
cat <<'TXT'
- Büyük sürüm atlayan doğrudan bağımlılıklar için değişiklik günlüğünü oku;
  sürüm yükseltmesini ayrı bir commit'te yap ve testleri koştur.
- pub.dev paket sayfalarındaki "Security advisories" bölümüne bak
  (özellikle dio, firebase_*, flutter_secure_storage, url_launcher).
- Android tarafı: android/app/build.gradle.kts ve settings.gradle.kts
  içindeki eklenti sürümleri (google-services, crashlytics) ayrı takip edilir.
TXT
