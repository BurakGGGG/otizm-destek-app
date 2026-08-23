# Güvenlik notları

Bu dosya mobil uygulamanın güvenlik modelini ve 2026-08-23'te yapılan
denetimin sonuçlarını tutar. Backend ayrı bir depodadır
(`EnesKotay/otizm-destek-platformu`, `backend/`); buradaki iddialar o
deponun kaynağından doğrulanmıştır, tahmin değildir.

## 1. Yetki sunucuda durur

**Kural:** mobil taraftaki hiçbir kontrol yetki vermez. Rol, sahiplik ve rıza
kontrollerinin tamamı backend'de yapılır; istemcideki karşılıkları yalnızca
arayüzü sadeleştirmek içindir (menüden gizlemek, düğmeyi pasifleştirmek).
Sunucuda karşılığı olmayan bir "yetki" özelliği güvenli değildir.

Uygulamanın buna uyduğunu gösteren noktalar:

- **Kimlik sunucudan gelir.** Açılışta depodaki access token ile
  `GET /api/auth/me` çağrılır ve kullanıcı (rol dahil) yanıttan kurulur
  (`auth_controller.dart` → `_restore`). Rol cihazda saklanan bir JSON'dan
  okunmaz; cihazdaki veri değiştirilse bile yalnızca arayüz yanılır, istek
  yine JWT ile yetkilendirilir.
- **Token'lar** `flutter_secure_storage`'da; refresh token backend'in
  httpOnly `refresh_token` çerezinde ve her yenilemede rotasyona giriyor.
- **Ağ günlüğü** yalnızca yöntem + yol + durum kodu yazar; istek gövdesi
  (çocuk sağlık kaydı, acil durum kartı, şifre) ve `Authorization` başlığı
  hiçbir derlemede loglanmaz (`test/network_logging_test.dart`).

Backend tarafında doğrulananlar:

| Alan | Bulgu |
| --- | --- |
| `SecurityConfig` | `anyRequest().authenticated()`, `SessionCreationPolicy.STATELESS`. Açık uçlar sınırlı: `/api/auth/**` (ama `GET /api/auth/me` kimlik ister), `/api/public/**`, `GET /api/forum/**`, `/ws/**`, `actuator/health\|info`. Swagger `hasRole('ADMIN')`. |
| Metot düzeyi | 13 sınıfta `@PreAuthorize`: EXPERT 23, PARENT 10, `isAuthenticated()` 9, ADMIN 4, EXPERT/ADMIN 3. |
| Kayıt | `AuthService.resolvePublicRegistrationRole` yalnızca PARENT ve EXPERT'e izin verir; başka rol istenirse `ValidationException`. Yani istemci kendini ADMIN yapamaz. EXPERT kaydında unvan + lisans zorunlu. |
| Sahiplik | `ChildService.validateOwnership` / `validateReadAccess`, `EmergencyCardService.requireParent`, `MedicationService`'te çocuk-veli eşleşmesi. |
| İstemci kimliği yok sayılır | `POST /api/task-submissions` gövdesinde `parentId` gitse de sunucu görevin sahibini kullanır ve `task.getParent().getId().equals(currentUserId)` değilse `AccessDenied` atar. |

**Backend'e taşınacak kritik not (bu depoda düzeltilemez):**
`backend/src/main/resources/application.yml` gizli değerleri ortam
değişkeninden okuyor ama **yerel geliştirme için varsayılan** da veriyor:

```yaml
jwt.secret:        ${JWT_SECRET:YXV0aXNtc3VwcG9ydHBsYXRmb3Jt…}   # depoda açık
encryption.secret-key: ${ENCRYPTION_KEY:autism-support-local-dev-encryption-key-32b}
app.bootstrap.admin-password: ${APP_BOOTSTRAP_ADMIN_PASSWORD:Admin123!}
spring.datasource.password: ${DB_PASSWORD:changeme}
```

Üretim sunucusunda bu değişkenler tanımlı **değilse** JWT imza anahtarı
herkesin okuyabileceği bir sabite düşer; o durumda dışarıdan istenen rol ve
kullanıcı için geçerli token üretilebilir, yani §1'deki bütün yetki kontrolü
anlamsızlaşır. Yayına almadan önce sunucuda doğrulanmalı:

```bash
# uygulamanın çalıştığı ortamda
printenv | grep -E 'JWT_SECRET|ENCRYPTION_KEY|APP_BOOTSTRAP_ADMIN_PASSWORD|DB_PASSWORD'
```

Dördü de dolu olmalı; boşsa önce değer verilip servis yeniden başlatılmalı.
(Bu depodan doğrulanamaz, canlı sisteme istek atarak denenmedi.)

**İkinci not:** üretimde refresh
çerezi `SameSite=None` ile yazılıyor (`refreshCookieSecure` true iken) ve CSRF
koruması kapalı. Yanıt gövdesi CORS nedeniyle saldırganın sayfasından
okunamaz, ama üçüncü bir siteden `POST /api/auth/refresh` ya da `/logout`
tetiklenip kullanıcının oturumu rotasyona/kapanmaya zorlanabilir. Çözüm:
`app.auth.cookie-same-site=Lax` (mobil için çerez zaten `Set-Cookie`
başlığından okunuyor, çapraz site senaryosu gerekmiyor) ya da bu iki uç nokta
için CSRF jetonu.

## 2. Anahtarlar depoda tutulmaz

Sürüm kontrolüne girmeyen dosyalar (`.gitignore`):

- `android/app/google-services.json` → şablon: `…json.example`
- `ios/Runner/GoogleService-Info.plist` (Mac'te eklenecek)
- `lib/firebase_options.dart` → şablon: `lib/firebase_options.example.dart`
- `android/key.properties`, `*.jks`, `*.keystore` (imza anahtarı)
- `.env`, `.env.*`, `config/*.local.json`

Yeniden üretmek:

```bash
flutterfire configure --project=otizm-destek-app --platforms=android,ios
# ya da şablonu kopyalayıp konsoldaki değerleri doldurun:
cp lib/firebase_options.example.dart lib/firebase_options.dart
```

Değerler eksikse `main.dart` Firebase başlatmayı sessizce atlar; uygulama
push/analytics olmadan çalışmaya devam eder.

**Dürüst olalım:** Firebase mobil API anahtarı gizli bir sır değildir — her
APK'nın içinde kullanıcıya gider ve Google da bunu erişim kontrolü için
kullanmaz. Depodan çıkarmak yalnızca "toplu tarayıcıların kolayca bulup başka
bir uygulamada kota harcamasını" zorlaştırır. Verinin asıl koruması iki
maddede: güvenlik kuralları (§3) ve sunucudaki yetkilendirme (§1).
Tamamlaması gereken konsol adımları:

1. Google Cloud Console → Credentials → Android anahtarına **uygulama
   kısıtlaması** (paket adı `com.otizmdestek.otizm_destek_app` + sürüm imzası
   SHA-1) ve **API kısıtlaması** (yalnızca kullanılan Firebase API'leri).
2. Anahtarın geçmişte herkese açık kaldığı süre önemliyse konsoldan yeni
   anahtar üretip eskisini silin, sonra `flutterfire configure`.

**Geçmişteki kopyalar (karar, 2026-08-23):** iki dosya ilk commit'ten beri
git geçmişinde duruyor. Geçmiş **yeniden yazılmadı**: depo private, anahtar
zaten her APK'nın içinde dağıtılıyor ve 142 commit'lik `develop` ile `main`'i
force push'lamanın pratik bir koruma değeri yok. Koruma yukarıdaki konsol
kısıtlamasıyla sağlanıyor. Depo bir gün herkese açılacaksa karar yeniden
gözden geçirilmeli (`git filter-repo --path … --invert-paths`).

**Kaldırılan istemci yüzeyi:** hiç çağrılmayan `firebase_auth`,
`firebase_storage`, `firebase_remote_config`, `google_sign_in` ve
`hive_flutter` paketleri bağımlılıklardan çıkarıldı. Uygulama artık yalnızca
`firebase_core`, `firebase_messaging`, `firebase_crashlytics`,
`firebase_analytics` içeriyor; Storage ve Auth istemci SDK'ları APK'da yok.

**Koruma:** `test/secrets_scan_test.dart` her `flutter test` koşusunda git'in
izlediği dosyaları tarar; yasak dosya adı (`.env`, `google-services.json`,
`key.properties`, `*.jks`…) ya da gömülü anahtar deseni (`AIza…`, PEM özel
anahtar) bulursa takım kırmızıya döner.

## 3. Firebase izin kuralları

Kurallar depoda ve `firebase.json` ile bağlı:

| Dosya | Kural | Gerekçe |
| --- | --- | --- |
| `storage.rules` | `allow read, write: if false` | Dosya yükleme/okuma backend'in `/api/upload` uç noktasından geçiyor; istemcide Firebase kimliği hiç oluşmadığı için "kimliği doğrulanmışa izin ver" varsayılanı bu mimaride yanlış (projede bir Auth sağlayıcısı açıksa dışarıdan hesap açan biri kovanın tamamına erişir). |
| `firestore.rules` | `allow read, write: if false` | Firestore kullanılmıyor; API sonradan etkinleşirse "test modu" varsayılanı veritabanını 30 gün herkese açar. |
| `database.rules.json` | `.read/.write: false` | Realtime Database kullanılmıyor. |

Yayınlamak:

```bash
firebase login
firebase deploy --only storage,firestore:rules,database
```

İlgili ürün projede etkin değilse o kısım hata verir; sorun değil, etkin
olanları tek tek yayınlayın (`--only storage` gibi).

## 4. Android izinleri

Manifest tek izin istiyor: `POST_NOTIFICATIONS` (FCM). Ayrıca `url_launcher`
için `VIEW` + `http(s)` paket görünürlük sorguları var — izin değil, Android
11+ paket görünürlüğü. Kamera/galeri erişimi `image_picker`'ın sistem
seçicisiyle yapılır, ayrı izin istenmez. Yeni izin eklemeden önce özelliğin
onsuz çalışıp çalışmadığını kontrol edin.
