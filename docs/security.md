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

## 5. Girişe sınır

**Sunucu (asıl koruma).** `@RateLimit` ek açıklaması ilgili uçlarda pencere
başına istek sayısını sınırlıyor; aşılınca HTTP 429 + JSON mesaj dönüyor:

| Uç nokta | Sınır |
| --- | --- |
| `POST /api/auth/login` | 10 / 60 sn |
| `POST /api/auth/register` | 20 / 60 sn |
| `GET /api/auth/check-email` | 30 / 60 sn |
| `POST /api/auth/forgot-password` | 5 / 60 sn |
| `POST /api/auth/refresh` | 60 / 60 sn |
| e-posta doğrulama tekrar gönder | 3 / saat |
| `POST /api/upload` | 30 / 60 sn |
| Sohbet botu | 20 ve 10 / 60 sn |

Anahtar: oturum açıksa kullanıcı kimliği, değilse IP. Sayaç Redis'te
(`RATE_LIMIT_REDIS_ENABLED`, varsayılan açık), Redis erişilemezse süreç
belleğine düşüyor.

⚠️ **Yapılandırma uyarısı:** `app.rate-limit.trust-proxy-headers` varsayılanı
`false`. Uygulama bir ters vekilin (Render, nginx) arkasındaysa bütün istekler
vekilin IP'siyle görünür; o zaman IP başına sınır çalışmaz — herkes tek bir
kovayı paylaşır ve tek bir saldırgan bütün kullanıcıların girişini 429'a
sokabilir. Ters vekil arkasında `TRUST_PROXY_HEADERS=true` verilmeli (vekilin
`X-Forwarded-For` başlığını kendisi yazdığından emin olarak).

**Not:** başarısız denemeye bağlı hesap kilidi yok; koruma yalnızca hız
sınırı. Farklı IP'lerden dağıtılmış kimlik denemesi bu kuralla engellenmez.

**Mobil (tamamlayıcı).** `LoginThrottle`: ilk 4 başarısız deneme beklemesiz,
sonrası 15 sn'den başlayıp ikiye katlanarak 5 dakikaya kadar çıkıyor; sunucu
429 döndüyse doğrudan 60 sn bekleniyor. Bekleme sırasında giriş düğmesi kapalı
ve kalan süreyi yazıyor. `ApiException.isRateLimited` (429) arayüze bu bilgiyi
taşıyor; backend `Retry-After` göndermediği için süre istemcide belirleniyor.
Kurallar saf ve `test/input_and_limits_test.dart` ile korunuyor.

## 6. Girdi doğrulama

**Sunucu.** DTO'larda 70 `@NotBlank`, 18 `@Size`, 5 `@Email`, `@Min`/`@Pattern`
kısıtları var ve controller'lar `@Valid` ile çağırıyor. Kayıt akışında rol,
KVKK onayı ve uzman lisansı ayrıca kontrol ediliyor.

**Mobil.** `core/util/input_rules.dart` sunucudaki `@Size` sınırlarını
yansıtır (başlık 200, kısa metin 500, yorum 1000, metin 2000, uzun metin
4000). Metin alanlarına `lengthLimit(...)` biçimlendiricisi takılıyor —
`maxLength` yerine bu kullanılıyor, çünkü sayaç bütün formların düzenini
değiştirirdi. E-posta biçimi tek yerden (`isValidEmail`) kontrol ediliyor;
giriş, kayıt ve şifre sıfırlama ekranları aynı kuralı kullanıyor (kayıt ekranı
eskiden yalnızca "@ ve . var mı" bakıyordu, şifremi unuttum ekranının kendi
kopyası vardı). `sanitizeSingleLine` tek satırlık alanlara yapıştırılan
satır sonu/kontrol karakterlerini temizler.

**Yeni alan eklerken:** sunucudaki `@Size` karşılığını bul, `input_rules.dart`
sabitlerinden uygun olanı `inputFormatters: lengthLimit(...)` ile ver.

## 7. Yükleme sınırları

**Sunucu.** `FileStorageService` sırasıyla: boş dosya reddi → içerik türü
allowlist'i (`image/jpeg|png|webp|gif`, `application/pdf`, `text/plain`) →
uzantının içerik türüyle eşleşmesi → **dosya imzası (magic bytes)** kontrolü →
UUID'li yeni dosya adı → yol geçişi (path traversal) kontrolü. Multipart
sınırı 10 MB, uç nokta 30/60 sn hız sınırlı, indirme (`GET /api/upload/**`)
kimlik doğrulaması istiyor ve kapsam (`scopeType`/`scopeId`) yükleyene göre
doğrulanıyor.

**Mobil.** Fotoğraflar zaten `image_picker` ile küçültülüyor (maxWidth
1024/1600, kalite %85). Buna ek olarak `UploadRepository` istek göndermeden
önce `upload_rules.dart` ile boyut (≤10 MB) ve uzantı kontrolü yapıp
anlaşılır bir hata veriyor, ayrıca parça başlığına içerik türünü **açıkça**
yazıyor (Dio dosya adından çıkaramadığında `application/octet-stream`
yazıyor; sunucunun listesinde olmadığı için yükleme reddedilirdi).

## 8. CORS

CORS yalnızca tarayıcıyı ilgilendirir; mobil uygulama etkilenmez ama aynı
backend'i web PWA ile paylaştığı için yapılandırma buraya da not edildi.

`SecurityConfig.corsConfigurationSource()`:

- **Origin allowlist**, joker yok: `app.cors.allowed-origins` (env
  `CORS_ORIGINS`) virgülle ayrılmış listeden okunuyor.
- Yöntemler açıkça sayılı (GET/POST/PUT/DELETE/PATCH/OPTIONS).
- `allowCredentials(true)` — httpOnly refresh çerezi için gerekli. Bu bayrak
  açıkken Spring `*` origin'i zaten reddeder, yani yanlışlıkla herkese
  açılamaz.
- `allowedHeaders("*")` — kimlik doğrulama origin ve çerezle yapıldığı için
  risk düşük; istenirse `Authorization, Content-Type, X-Requested-With` ile
  daraltılabilir.

⚠️ **Üretimde doğrulanacak:** `CORS_ORIGINS` varsayılanı
`http://localhost:5173`. Sunucuda gerçek origin'ler tam ve şemasıyla
verilmeli, sonunda eğik çizgi olmadan:

```bash
CORS_ORIGINS=https://otizmdestek.com,https://www.otizmdestek.com
```

Vercel önizleme adresleri kalıcı listeye girmemeli (her dağıtımda değişir ve
tahmin edilebilir alt alan adları allowlist'i genişletir).

## 9. Güvenlik başlıkları

**Canlı doğrulama (2026-08-23, prod başlıkları):** `X-Content-Type-Options:
nosniff` ✓, `X-Frame-Options: DENY` ✓, `Strict-Transport-Security:
max-age=31536000; includeSubDomains` ✓ — HSTS **var** ama Spring'den değil,
önündeki **Cloudflare**'den geliyor (`server: cloudflare`; §10'daki "HSTS
çıkmaz" tahminim bu yüzden yanlıştı, edge ekliyor). `Server:` başlığı Spring/
Tomcat sürümünü sızdırmıyor (Cloudflare maskeliyor) ✓. **Eksik olanlar:**
`Content-Security-Policy`, `Referrer-Policy`, `Permissions-Policy` — üçü de
yanıtta yok. `SecurityConfig`'te açık bir `.headers(...)` bloğu yok. Önerilen
ek (backend deposunda; CSP/Referrer/Permissions için — HSTS'yi Cloudflare
zaten veriyor):

```java
http.headers(headers -> headers
    // HSTS: tarayıcı bir daha http ile denemesin
    .httpStrictTransportSecurity(hsts -> hsts
        .includeSubDomains(true)
        .maxAgeInSeconds(31536000))
    .referrerPolicy(rp -> rp.policy(
        ReferrerPolicyHeaderWriter.ReferrerPolicy.STRICT_ORIGIN_WHEN_CROSS_ORIGIN))
    // API yalnızca JSON döndürüyor: her şeyi kapatmak güvenli
    .contentSecurityPolicy(csp -> csp.policyDirectives(
        "default-src 'none'; frame-ancestors 'none'; base-uri 'none'"))
    .permissionsPolicy(pp -> pp.policy(
        "camera=(), microphone=(), geolocation=()"))
);
```

ℹ️ Not: HSTS'yi üretimde Cloudflare ekliyor (canlı doğrulandı), yani başlık
bugün mevcut. Yine de `server.forward-headers-strategy: framework` verilmesi
iyi olur ki Spring de isteği HTTPS görsün (aksi halde `secure` çerez ve
uygulama düzeyli HTTPS mantığı isteği http sanabilir).

Mobil uygulama için başlıkların doğrudan etkisi yok (WebView kullanılmıyor,
yanıtlar JSON olarak ayrıştırılıyor); başlıklar web PWA'yı korur.

## 10. HTTPS zorunlu

**Mobil (bu depoda yapıldı).**

- `android/app/src/main/res/xml/network_security_config.xml`: açık metin
  trafiği kapalı, manifestte `usesCleartextTraffic="false"` ile birlikte
  bağlandı. Android 9+ zaten varsayılan olarak engelliyor; açıkça yazmak bir
  bağımlılığın manifestine `usesCleartextTraffic="true"` eklemesi durumunda
  birleşmede bizim kuralımızın kazanmasını sağlıyor.
- Debug derlemesi için ayrı yapılandırma (`src/debug/res/xml/...`) yalnızca
  `localhost`, `127.0.0.1` ve `10.0.2.2` için açık metne izin verir; sürüm
  derlemesine sızmaz.
- iOS'ta `Info.plist` içinde ATS istisnası yok, yani varsayılan (açık metin
  kapalı) geçerli.
- `test/env_https_test.dart` derleme öncesi bekçi: varsayılan adresler ve
  `config/*.json` profilleri `https://` ile başlamazsa ya da manifestten
  cleartext kuralı düşerse takım kırılır.
- Sertifika sabitleme (pinning) bilinçli olarak **yok**: sertifika otomatik
  yenileniyor, sabit bir pin yenilemede uygulamayı tamamen offline'a düşürür.

**Sunucu.** Uygulama düzeyinde `requiresChannel().requiresSecure()` yok; TLS
ters vekilde sonlanıyor. Yapılması gerekenler: vekilde http→https yönlendirme,
`server.forward-headers-strategy: framework` (uygulama isteğin HTTPS geldiğini
görsün) ve §9'daki HSTS başlığı.

## 11. Şifre saklama

**Sunucu.** `BCryptPasswordEncoder` (Spring Security), kayıtta ve yönetici
tohumlamasında `passwordEncoder.encode(...)` ile hash'leniyor; doğrulama
`matches` ile yapılıyor. Şifre hiçbir yerde düz metin saklanmıyor.
`passwordHash` alanı hiçbir DTO'da ya da controller yanıtında geçmiyor.

Öneriler (backend): `new BCryptPasswordEncoder(12)` ile maliyeti artırmak
(varsayılan 10) ve `User` varlığındaki `passwordHash` alanına `@JsonIgnore`
eklemek — bugün sızmıyor ama bir gün varlık doğrudan döndürülürse diye.

**Mobil.** Şifre hiçbir yere yazılmıyor: "Beni hatırla" yalnızca oturum
token'ının kalıcılığını belirler (şifreyi saklamaz), ağ günlüğü istek
gövdelerini yazmaz, şifre alanları `obscureText` ve autofill ipuçlarıyla
çalışır. Şifre kuralları `core/util/password_rules.dart` ile backend'in
`StrongPasswordValidator`'ıyla birebir.

## 12. Oturum ve çerez güvenliği

**Sunucu.** Refresh ve medya çerezleri `httpOnly`, yola göre sınırlı
(`/api/auth`, `/api/upload`), `maxAge` verilmiş ve her yenilemede refresh
token rotasyona giriyor.

⚠️ `app.auth.refresh-cookie-secure` (env `REFRESH_COOKIE_SECURE`) varsayılanı
**false**. Üretimde `true` verilmezse çerezler `Secure` bayrağı olmadan yazılır
— yani araya giren bir http isteğinde açık metin gidebilirler. Aynı ayar
`SameSite`'ı da belirliyor (true → `None`, false → `Strict`); §1'deki CSRF
notu nedeniyle `app.auth.cookie-same-site=Lax` önerilir.

**Mobil (bu depoda yapıldı).**

- Anahtarlık öğeleri artık `first_unlock_this_device` ile yazılıyor. Paketin
  varsayılanı (`unlocked`) öğenin yedekle **başka bir cihaza taşınmasına** izin
  veriyordu; oturum token'ının taşınmasını istemiyoruz. `first_unlock`
  seçilmesinin nedeni arka planda gelen push'ta token'ın okunabilmesi.
- Android'de paket zaten KeyStore destekli AES-GCM kullanıyor (v10'da
  `encryptedSharedPreferences` kullanımdan kalktı), ek ayar gerekmiyor.
- **"Beni hatırla" kutusu hiçbir şey yapmıyordu** — işaretlense de
  işaretlenmese de oturum diske yazılıyordu. Artık kapalıyken token'lar yalnızca
  bellekte tutulur ve uygulama kapanınca oturum biter; açıkken (varsayılan,
  bugünkü davranış) güvenli depoya yazılır. Token yenileme oturum içi bir
  girişi kalıcıya çeviremez. Davranış `test/session_persistence_test.dart`
  ile korunuyor.

## 13. Hata mesajları

**Sunucu.** `GlobalExceptionHandler` tipli istisnalarda geliştiricinin yazdığı
kısa Türkçe mesajı, yakalanmayan her şeyde ise sabit bir metin döndürüyor
("Sistemde geçici bir aksaklık oluştu…"); istisna mesajı yanıta değil yalnızca
sunucu günlüğüne, üstelik tipi ve korelasyon kimliğiyle yazılıyor. Yani 500
yanıtları altyapıyı ifşa etmiyor.

**Mobil.** İstemci yine de sunucudan gelen metni körlemesine göstermiyor
(`ApiException.safeServerMessage`):

- 5xx yanıtlarında metin ne olursa olsun genel mesaja düşülür,
- 300 karakterden uzun metin (yığın izi/HTML hata sayfası göstergesi) elenir,
- `Exception`, `Caused by`, `java.`, `org.springframework`,
  `com.autismsupport`, `SQLSTATE`, `SELECT … FROM`, `<html` gibi iç ayrıntı
  işaretleri taşıyan metin elenir.

Ayrıca Dio'nun varsayılan hata dalı artık `e.message` döndürmüyor: o metin
istek adresini ve host'u içeriyordu ve doğrudan kullanıcıya gösteriliyordu.
Kurallar `test/error_and_logging_test.dart` ile korunuyor.

## 14. Günlük hijyeni

**Mobil.**

- Ağ günlükçüsü yalnızca yöntem + yol + durum kodu yazar; istek gövdesi
  (çocuk sağlık kaydı, acil durum kartı, şifre) ve `Authorization` başlığı
  hiçbir derlemede günlüğe düşmez (`test/network_logging_test.dart`) ve
  varsayılan olarak yalnızca debug'da açıktır.
- **`debugPrint` sürüm derlemesinde de yazar** ve yazdığı satır cihaz
  günlüğüne (logcat) düşer; istisna metinleri oraya sızıyordu. Artık günlükler
  `core/util/app_log.dart` üzerinden geçiyor (`logDebug`/`logDebugError`,
  sürümde no-op). Sürümde hata takibi Crashlytics'te. `lib/` içinde doğrudan
  `debugPrint` kullanımı testle yasaklandı.

**Sunucu.** `logging.level.com.autismsupport` varsayılanı `INFO`, Spring
Security `WARN`; SQL günlüğü kapalı. `LOG_LEVEL=DEBUG` üretimde açılırsa
sağlık verisi günlüğe düşebilir — kontrol listesine eklendi.

## 15. Sorgu parametreleme

Depodaki 104 `@Query` JPQL ya da native SQL; hepsi **adlandırılmış
parametre** kullanıyor (`:userId`, `:q`). Kaynakta görünen `+` işaretleri
kullanıcı girdisini değil, çok satırlı sorgu metnini birleştiriyor.

Dinamik kurulan tek yer `SearchService`: filtre varsa `WHERE` cümlesine
**sabit** parçalar ekleniyor (`AND p.category = :category` gibi), değerlerin
tamamı `setParameter` ile bağlanıyor, `LIMIT` sabit. Yani birleştirilen metne
kullanıcı girdisi hiç girmiyor — enjeksiyon yüzeyi yok.

Mobil tarafta yerel veritabanı yok (sqflite/drift kullanılmıyor), istemcide
sorgu kurulmuyor.

## 16. XSS

**Mobil (risk yok).** Uygulama WebView kullanmıyor; bilgi bankası ve forum
içerikleri `htmlToPlainText` ile düz metne çevrilip `Text` bileşenleriyle
çiziliyor, yani içerikteki işaretleme çalıştırılamaz. Dış bağlantılar
`core/util/external_link.dart` ile yalnızca `http`/`https` şemasına açık —
tarayıcı bağlamında XSS taşıyıcısı olan `javascript:` adresleri engelli.
Paylaşım bağlantısındaki jeton sunucuda `Base64.getUrlEncoder()` ile
üretiliyor, URL güvenli.

**Sunucu.** `HtmlSanitizer` var ama yalnızca `ForumService` içinde
uygulanıyor; bilgi bankası makalesi içeriği temizlenmeden saklanıyor.

⚠️ **Web'de açık bir XSS yolu var** (bu depoda düzeltilemez):

| Yer | Durum |
| --- | --- |
| `frontend/src/pages/ForumPage.tsx:471` | `sanitizeHtml(...)` ile temizlenip basılıyor ✓ |
| `frontend/src/pages/KnowledgePage.tsx:749` | `dangerouslySetInnerHTML={{ __html: parsed.text }}` — **temizlenmiyor** ⚠️ |

Makale içeriğini yazabilen biri (uzman/yönetici hesabı ya da o hesabı ele
geçiren biri) makaleyi okuyan herkesin tarayıcısında betik çalıştırabilir.
İki katmanlı çözüm: web'de aynı `sanitizeHtml` ile sarmak **ve** sunucuda
kaydederken `HtmlSanitizer`'ı bilgi bankası içeriğine de uygulamak.

## 17. Webhook imzası

Bu üründe **gelen webhook yok**. Backend'de `webhook`, `/callback`,
`X-Signature`, `HmacSHA256` gibi bir uç nokta ya da doğrulama kodu bulunmuyor;
dış servislerle ilişki tek yönlü ve dışa doğru: FCM push gönderimi, SMTP,
Gemini çağrısı, Turnstile doğrulaması. Yani bugün imzalanacak bir istek yok.

Mobil tarafta da dışarıdan tetiklenen bir giriş noktası yok: Android
manifestinde yalnızca `MAIN`/`LAUNCHER` intent filtresi var, özel şema
(deep link) tanımlı değil — başka bir uygulama bu uygulamada bir akış
başlatamıyor.

**Bir gün webhook eklenirse** (ödeme, e-posta bounce, SMS durumu) uyulacak
kural:

1. İmza **ham gövde** üzerinden doğrulanır — JSON'a çevirdikten sonra yeniden
   serileştirilen metin baytı baytına aynı olmaz.
2. `HMAC-SHA256(secret, timestamp + "." + body)`; secret ortam değişkeninden.
3. Karşılaştırma **sabit zamanlı** (`MessageDigest.isEqual`), `equals` değil.
4. Zaman damgası ±5 dakika penceresi dışındaysa reddedilir (tekrar saldırısı).
5. Doğrulama, gövde ayrıştırılmadan ve iş mantığı çalıştırılmadan önce yapılır;
   reddedilen istekler 401 döner ve günlüğe yazılır.
6. Uç nokta `SecurityConfig`'te `permitAll` olur ama kendi imza kontrolü
   vardır; hız sınırı (`@RateLimit`) eklenir.

## 18. Yönetici rolü

`AdminController` **sınıf düzeyinde** `@PreAuthorize("hasRole('ADMIN')")`
taşıyor, yani `/api/admin/**` altındaki her uç nokta yöneticiye kapalı.
`DataSubjectRequestController` (KVKK başvuruları) ve `ForumController`
(moderasyon) yönetici gerektiren metotlarını tek tek işaretlemiş. Swagger
arayüzü hem `hasRole('ADMIN')` ile korunuyor hem de üretim compose'unda
kapatılmış (`SPRINGDOC_*_ENABLED=false`).

Mimari not: controller'ların çoğunda `@PreAuthorize` yok; onlar filtre
zincirindeki `anyRequest().authenticated()` ile korunuyor ve **yetki kontrolü
servis katmanında** yapılıyor. Örneklerle doğrulandı: makale oluşturmada
`PARENT` reddediliyor, yayınlamak için `ADMIN` şart, çocuk/acil kart/ilaç
servislerinde sahiplik kontrolü var.

⚠️ **Bulgu:** servis içindeki bu kontroller düz `RuntimeException` fırlatıyor
(ör. `throw new RuntimeException("Sadece uzmanlar makale yazabilir")`).
`GlobalExceptionHandler` tipli olmayan istisnayı 500 + "Sistemde geçici bir
aksaklık oluştu" ile karşılıyor; yani **yetki hatası kullanıcıya sunucu
arızası gibi görünüyor** ve hata metriklerini şişiriyor. Depoda zaten
`UnauthorizedException` / `AccessDeniedException` var (403'e eşleniyor);
bu atışlar onlarla değiştirilmeli.

## 19. Paket denetimi

Dart/pub tarafında `npm audit` karşılığı bir komut **yok** (SDK 3.12).
Yapılabilecek denetim `tool/audit_deps.sh` ile betiğe bağlandı: kısıt içinde
güncellenebilirler, kullanımdan kaldırılmış paket uyarısı ve elle bakılacak
adımlar (pub.dev "Security advisories" bölümü, Android eklenti sürümleri).

Bu turda yapılan denetim sonucu:

- Kullanımdan kaldırılmış/geri çekilmiş paket **yok**.
- Kısıt içindeki güncellemeler alındı: `dio` 5.9.2→5.11.0, `firebase_core`
  4.11→4.13, `firebase_messaging` 16.4→16.5, `firebase_crashlytics` 5.2.4→
  5.2.7, `firebase_analytics` 12.4.3→12.4.6, `go_router` 17.3→17.5, `slang`
  4.16→4.19 ve 27 geçişli paket. Analyze temiz, 352 test geçti, sürüm APK'sı
  derlendi.
- **Bilerek ertelenenler:** `flutter_secure_storage` 11.0.0 (büyük sürüm —
  yükseltmenin depodaki token'ları taşıyıp taşımadığı denenmeden alınmamalı,
  aksi halde bütün kullanıcılar oturumdan düşer) ve `flutter_riverpod` 3.4.2
  (dev bağımlılığı `riverpod_generator` eski sürümde tutuyor).
- Daha önce hiç kullanılmayan beş paket kaldırılmıştı (§2): en iyi denetim,
  bağımlı olmadığın pakettir.

## 20. Otomatik yedek

**Mobil.** Cihazda yedeklenecek kalıcı veri yok; yine de Android manifestinde
`allowBackup=false` ve `fullBackupContent=false` — sağlık verisi Google'ın
otomatik yedeğine girmesin. iOS anahtarlık öğeleri `first_unlock_this_device`
olduğu için yedekle başka cihaza taşınmıyor (§12).

**Sunucu.** `docker-compose.prod.yml` içinde bir `db-backup` servisi var:
24 saatte bir `/scripts/backup-db.sh` çalıştırıyor, `BACKUP_ENCRYPTION_PASSWORD`
zorunlu, `BACKUP_RETENTION_DAYS` varsayılanı 30 ve çıktı `encrypted_backups`
adlı docker volume'una yazılıyor.

⚠️ **Bulgu 1:** çalıştırılan betik (`./scripts/backup-db.sh`) **depoda yok**.
Sunucuda elle oluşturulmadıysa kapsayıcı her gün "not found" ile dönüp hiçbir
şey yedeklemiyor demektir — üstelik sessizce, çünkü döngü hatayı yutuyor.
Doğrulama:

```bash
docker logs --tail 50 autism-platform-db-backup
docker run --rm -v <proje>_encrypted_backups:/b alpine ls -lh /b
```

⚠️ **Bulgu 2:** yedekler veritabanıyla **aynı makinedeki** bir volume'da.
Disk/sunucu kaybında yedek de gider. Şifreli dosyanın günlük olarak dış bir
depoya (S3/R2, farklı sağlayıcı) kopyalanması ve düzenli **geri yükleme
provası** gerekiyor — hiç denenmemiş yedek yedek sayılmaz.

Ayrıca dosyalar artık S3'te (`STORAGE_TYPE=s3`): kovada sürümleme ve yaşam
döngüsü kuralı ayrıca ayarlanmalı, veritabanı yedeği onları kapsamıyor.

Eksik betik için başlangıç (platform deposundaki `scripts/backup-db.sh`):

```sh
#!/bin/sh
set -eu
STAMP=$(date +%Y%m%d-%H%M%S)
OUT="/backups/autism-$STAMP.sql.gz.enc"
PGPASSWORD="$DB_PASSWORD" pg_dump -h "$DB_HOST" -U "$DB_USERNAME" -d "$DB_NAME" \
  | gzip -9 \
  | openssl enc -aes-256-cbc -pbkdf2 -pass env:BACKUP_ENCRYPTION_PASSWORD -out "$OUT"
# Bozuk/boş çıktı yedek sayılmasın
[ -s "$OUT" ] || { echo "BOŞ YEDEK: $OUT" >&2; rm -f "$OUT"; exit 1; }
find /backups -name 'autism-*.sql.gz.enc' -mtime "+${BACKUP_RETENTION_DAYS:-30}" -delete
echo "yedek tamam: $OUT ($(stat -c%s "$OUT") bayt)"
```

Geri yükleme: `openssl enc -d -aes-256-cbc -pbkdf2 -pass env:… -in dosya |
gunzip | psql …`

## 22. Hesap silme

**Akış.** Mobil: Ayarlar → hesabı sil; mevcut şifre + onay kelimesi isteniyor,
`DELETE /api/users/me` çağrılıyor. Sunucu şifreyi doğrulayıp
`AccountDeletionService.delete(user)` çalıştırıyor: kullanıcının dosyaları
`storage_deletion_queue`'ya yazılıyor (`StorageDeletionWorker` kuyruğu tüketip
depodan siliyor, hata sayacıyla birlikte), refresh token'lar siliniyor ve
kullanıcı satırı **gerçekten** siliniyor (`userRepository.delete`) — pasife
çekme/soft delete yok.

⚠️ **Bulgu — silme büyük olasılıkla hiç çalışmıyor.** Şemada `users(id)`'ye
bakan 58 yabancı anahtarın 50'si `ON DELETE CASCADE`, 2'si `SET NULL`, ama
**6'sında kural yok** (varsayılan NO ACTION → silmeyi engeller):

| Tablo.sütun | Sütun | Öneri |
| --- | --- | --- |
| `notifications.user_id` | NOT NULL | `ON DELETE CASCADE` |
| `reports.reporter_id` | NOT NULL | nullable + `SET NULL` (moderasyon kaydı kalsın) |
| `expert_reviews.expert_id` | NOT NULL | `CASCADE` |
| `expert_reviews.reviewer_id` | NOT NULL | `CASCADE` |
| `social_story_comments.author_id` | NOT NULL | `CASCADE` |
| `knowledge_articles.reviewed_by_id` | nullable | `SET NULL` |

Bunlar `User` varlığında da eşlenmemiş (yalnızca children, expertConnections,
assignedTasks, expertAppointments `cascade = ALL`), yani Hibernate da
temizlemiyor. **Bildirimi olan her kullanıcı** — pratikte herkes — silinmeye
çalışıldığında yabancı anahtar ihlali alır; `GlobalExceptionHandler` bunu 500 +
"Sistemde geçici bir aksaklık oluştu" ile karşılar, yani kullanıcı hesabının
silindiğini sanır ama silinmez. KVKK açısından da sorunlu.

Kaynaktan (şema dökümü + varlık eşlemeleri + migration'lar) çıkarıldı, canlıda
denenmedi: bir deneme hesabıyla doğrulanmalı. Düzeltme migration'ı:

```sql
ALTER TABLE notifications DROP CONSTRAINT fk9y21adhxn0ayjhfocscqox7bh,
  ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id)
  REFERENCES users(id) ON DELETE CASCADE;
-- expert_reviews (expert_id, reviewer_id) ve social_story_comments.author_id
-- için aynı desen; knowledge_articles.reviewed_by_id → ON DELETE SET NULL;
-- reports.reporter_id için önce ALTER COLUMN reporter_id DROP NOT NULL.
```

**Mobil (bu depoda yapıldı).** Hesap silindikten sonra yalnızca token'lar
temizleniyordu; rutin yıldızları (çocuğun ilerlemesi), uzman favorileri,
izlenen videolar, kapatılan kart işaretleri ve erişilebilirlik tercihleri
cihazda kalıyordu. Artık `SecureStorage.wipeAll()` çağrılıyor: silinen hesabın
hiçbir izi kalmıyor. Normal çıkışta davranış değişmedi (tema/dil tercihi
korunur). `test/session_persistence_test.dart` ikisini de doğruluyor.

## 23. Harcama uyarısı

**Para harcayan yüzeyler:** Gemini çağrıları (sohbet botu, yapay zekâ analizi,
makale taslağı, AI arama), S3/R2 depolama ve indirme trafiği, SMTP, sunucu.

**Bugün var olan sınırlar:** yanıt başına `maxOutputTokens` 1024/2048;
kullanıcı başına hız sınırı (sohbet 20/dk, akış 10/dk, analiz 10/dk); ve
`PlatformSettings.aiEnabled` — yani yöneticinin elinde çalışan bir **kapatma
anahtarı** var.

⚠️ **Boşluk:** günlük/aylık kota yok, toplam harcama sayacı yok, uyarı yok.
Tek bir hesap mevcut sınırlar içinde günde **14.400 akış isteği** atabilir
(10/dk × 60 × 24); bu tamamen meşru görünen bir kullanım örüntüsüyle bile
faturayı beklenmedik yere taşır.

**Konsolda kurulacak uyarılar (sizde):**

1. Google Cloud → Billing → Budgets & alerts: Gemini anahtarının bulunduğu
   proje için aylık bütçe + %50/%90/%100 e-posta uyarısı. Uyarı faturayı
   durdurmaz; asıl fren 2. madde.
2. Google Cloud → APIs & Services → Generative Language API → Quotas:
   dakika/gün başına **sert tavan**. Tavana çarpınca istekler reddedilir,
   ücret işlemez.
3. Cloudflare R2 / S3: depolama ve çıkış trafiği için uyarı; kovada yaşam
   döngüsü kuralı.
4. Sunucu sağlayıcısı: fatura uyarısı.

**Sunucuda önerilen fren (backend işi):** mevcut hız sınırı altyapısıyla
kullanıcı başına **günlük** kota (ör. 100 AI çağrısı/gün), toplam günlük
sayaç ve eşiği aşınca `aiEnabled` bayrağını otomatik kapatma; ayrıca
micrometer'a `ai.calls` sayacı ekleyip uyarıyı oradan kurmak.

**Mobil (bu depoda yapıldı).** Sohbet ekranı her mesajda **geçmişin tamamını**
yeniden gönderiyordu ve ne mobilde ne sunucuda tavan vardı: 30 mesajlık bir
sohbette 30. istek önceki 29 mesajı da taşıyor, yani modele giren jeton
konuşma uzadıkça kartopu gibi büyüyor. Artık son 20 tur gönderiliyor
(`kMaxChatHistoryTurns`) — sıradan bir destek sohbeti tamamen kapsanıyor,
uzun oturumlarda maliyet sabitleniyor. Sunucu tarafına da aynı tavan
konmalı; istemciye güvenilmez.

## 24. Saldırgan gözüyle test (2026-08-23)

Yetkili kırmızı takım turu. İki tür kanıt: **statik** (üretilen sürüm APK'sı +
istemci kaynağı) ve **canlı/zararsız** (paylaşılan prod'a yalnızca okuma
amaçlı, veri değiştirmeyen, kaba kuvvet olmayan bir avuç istek). Hiçbir
POST/PUT/DELETE atılmadı, kimlik denemesi yapılmadı, kullanıcı verisi
okunmadı/değiştirilmedi.

### Sağlam çıkanlar (denenip kırılamayanlar)

| Test | Sonuç |
| --- | --- |
| Korumalı uca kimliksiz erişim (`/api/children`, `/api/users/me`) | 401 ✓ |
| Rastgele origin ile CORS preflight (`Origin: evil.example.com`) | 403 — origin reddedildi ✓ |
| Bozuk JSON ile hata ayrıntısı sızıntısı | Temiz kullanıcı mesajı, yığın izi yok ✓ |
| Yol geçişi (`/api/upload/..%2f..%2fapplication.yml`) | 400 ✓ |
| Acil kart paylaşımı, geçersiz/rastgele jeton | 404, jeton varlığını sızdırmıyor ✓ |
| Güvenlik başlıkları (canlı) | HSTS + nosniff + frame-DENY var; sürüm sızmıyor ✓ |
| İstemci mutasyon gövdelerinde sahip kimliği | Gönderilmiyor — IDOR yüzeyi yok ✓ |
| İstemci rol kontrolleri | Hepsi arayüz kapısı; APK repackage ile yetki kazanılamaz (sunucu zorluyor) ✓ |
| STOMP/WS kimlik | `Authorization: Bearer` native header, sunucu doğruluyor ✓ |
| Görsel yükleyici (`mediaImageProvider`) | Bearer yalnızca backend host'una; yabancı host'a düz NetworkImage ✓ |
| eval / Process / dart:mirrors | İstemcide yok ✓ |
| Açık metin (`http://`) | Yalnızca şema kontrolünde; gerçek çağrı yok ✓ |

### Bu turda kapatılan gerçek bulgular (mobil)

1. **Bearer token host'a çıpalanmadı (savunma katmanı).** `AuthInterceptor`
   token'ı host kontrolü yapmadan **her** isteğe ekliyordu. Bugün sızıntı yok
   (uygulama Dio'yu hep göreli yolla çağırıyor), ama biri ileride mutlak bir
   dış adres geçirseydi token o host'a giderdi — tek satır uzaklıkta bir
   felaket. Artık token yalnızca backend host'una ekleniyor; alt alan adı
   hilesi (`backend...evil.net`) host eşitliğiyle engelli.
   `test/auth_interceptor_test.dart`.

2. **Ek dosya indirme yabancı host'a kapatıldı.** `downloadAttachment` mesaj
   gövdesinden gelen mutlak adresi körlemesine indiriyordu; kötü niyetli bir
   mesaj `fileUrl`'ü saldırganın adresini gösterirse uygulama dokunulan
   mesajla oraya istek atıp cihaz IP'sini sızdırır ve rastgele baytı paylaşım
   sayfasına verirdi. Artık yalnızca kendi backend'imizden indiriliyor.

(Bu turdan bağımsız ama aynı sınıftan, önceki turlarda kapatılanlar: hesap
silmede cihaz temizliği §22, "Beni hatırla" oturum kipi §12, hata metni
süzgeci §13, günlük hijyeni §14, sohbet geçmişi tavanı §23.)

### Doğrulanan açık bulgular (sizde/backend'de)

- **APK'daki Firebase anahtarı gerçekten kısıtsız.** Sürüm ikilisinden
  çıkarılan anahtar (`AIzaSy…x6Ro`) Google Identity Toolkit çağrısında
  reddedilmeden kabul edildi (`CONFIGURATION_NOT_FOUND` — anahtar geçerli,
  yalnızca Firebase Auth yapılandırılmamış). Yani anahtar her yerden
  kullanılabiliyor; konsolda uygulama+API kısıtlaması hâlâ yapılmamış (§2).
- **CSP / Referrer-Policy / Permissions-Policy başlıkları yok** (§9, canlı
  doğrulandı).
- Önceki turların backend bulguları geçerliliğini koruyor: hesap silmeyi
  engelleyen 6 yabancı anahtar (§22), AI harcama kotasının olmayışı (§23),
  yetki hatalarının 500 olarak dönmesi (§18), yedek betiğinin depoda
  olmayışı (§20).

### Kapsam dışı bırakılanlar (bilinçli)

Canlı prod'a karşı **yapılmadı**: giriş kaba kuvveti / hız sınırı taşması
(gerçek kullanıcıları 429'a sokar), herhangi bir yazma işlemi (paylaşılan
DB'yi kirletir), kimlik denemesi, kullanıcı verisi enumerasyonu. Bunların
uçtan uca doğrulaması bir deneme/staging hesabına bırakıldı.

## 25. Üretim kontrol listesi

Bu depodan doğrulanamayan, sunucuda bakılması gerekenler:

- [ ] `JWT_SECRET`, `ENCRYPTION_KEY`, `APP_BOOTSTRAP_ADMIN_PASSWORD`,
      `DB_PASSWORD` tanımlı mı (§1'deki varsayılanlara düşmüyor mu)?
- [x] `TRUST_PROXY_HEADERS=true` — üretim compose'unda ayarlı (§5).
- [ ] `CORS_ORIGINS` gerçek alan adlarıyla dolu mu — §8.
- [ ] `app.auth.cookie-same-site` değeri (§1'deki CSRF notu).
- [ ] Firebase kuralları yayınlandı mı: `firebase deploy --only storage` — §3.
- [ ] Google Cloud Console'da Android API anahtarı kısıtlandı mı — §2.
- [x] `REFRESH_COOKIE_SECURE=true` — üretim compose'unda ayarlı (§12).
- [ ] `server.forward-headers-strategy=framework` ve vekilde http→https
      yönlendirme var mı — §10.
- [ ] Güvenlik başlıkları (HSTS/CSP/Referrer-Policy) eklendi mi — §9.
- [x] `LOG_LEVEL=WARN` — üretim compose'unda ayarlı (§14).
- [x] Swagger/OpenAPI üretimde kapalı — compose'da `SPRINGDOC_*_ENABLED=false`.
- [ ] Bilgi bankası içeriği web'de temizlenerek mi basılıyor — §16.
- [ ] `scripts/backup-db.sh` sunucuda var mı, yedekler gerçekten yazılıyor mu
      ve dış depoya kopyalanıyor mu — §20.
- [ ] Geri yükleme provası yapıldı mı — §20.
- [ ] Hesap silme bir deneme hesabıyla uçtan uca denendi mi; 6 yabancı anahtar
      düzeltildi mi — §22.
- [ ] Gemini bütçe uyarısı + API kota tavanı kuruldu mu — §23.
- [ ] Kullanıcı başına günlük AI kotası eklendi mi — §23.
- [ ] S3 kovasında sürümleme/yaşam döngüsü açık mı — §20.
- [ ] `JWT_SECRET`/`ENCRYPTION_KEY` compose'da `${VAR:?...}` ile zorunlu
      kılınmalı; şu an boş geçilebiliyor (S3 değişkenleri gibi) — §1.
