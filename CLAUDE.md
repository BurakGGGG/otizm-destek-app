# Otizm Destek — Flutter Mobil Uygulama

Otizm destek ürünü için Flutter + Firebase mobil uygulama. Mevcut web platformuyla
**aynı canlı backend'i** paylaşır.

## Mimari özet

- **İstemci:** Flutter (Dart 3.12), state: Riverpod (manuel sağlayıcılar), nav: go_router,
  ağ: Dio, gerçek zamanlı: stomp_dart_client, güvenli depo: flutter_secure_storage.
- **Backend (mevcut, ayrı repo):** Spring Boot (Java) — `https://otizm-backend.onrender.com`.
  - JWT auth (`/api/auth/login`, `/register`; access+refresh; `Authorization: Bearer`).
  - Gerçek zamanlı: STOMP over SockJS, `/ws`.
  - AI sohbet botu: SSE streaming, `/api/chatbot/stream`.
  - REST ön eki: `/api`.
- **Firebase (proje: `otizm-destek-app`):** mobilde FCM push, Crashlytics, Analytics,
  Remote Config, Storage. **Kimlik (Auth) DEĞİL**, **Firestore DEĞİL** — kaynak doğruluk
  Spring backend + Postgres.
- **Auth (KARAR: backend JWT — Seçenek B):** Mobil doğrudan backend'in kendi JWT auth'unu
  kullanır (`/api/auth/login`, `/register`, `/refresh`, `/logout`, `/me`). Access+refresh
  token `flutter_secure_storage`'da; Dio `AuthInterceptor` Bearer ekler, `RefreshInterceptor`
  401'de yeniler. Backend'de auth değişikliği YOK; Firebase Auth/köprü kullanılmıyor.
  Backend rolleri: **PARENT, EXPERT, ADMIN**. Yanıt zarfı `{success,message,data}`.
  API referansı: `docs/backend_api.md`.

## Klasör yapısı

```
lib/
  main.dart, app.dart, firebase_options.dart
  core/      config (env), theme, router, network (dio/interceptor), storage, providers.dart
  features/  auth/ home/ splash/ ... (her biri data/ domain/ presentation/)
```

`core/network` Dio istemcisi (`dioProvider`) her yerde yeniden kullanılır — özellik başına
elle HTTP yazma. Backend adresleri `lib/core/config/env.dart` (--dart-define ile override).

## Çalıştırma

```bash
flutter pub get
flutter analyze
flutter test
flutter run                 # Android emülatör/cihaz
flutter build apk --debug
```

`flutterfire` CLI: `~/.pub-cache/bin` PATH'te olmalı. Yeniden yapılandırma:
`flutterfire configure --project=otizm-destek-app --platforms=android,ios`.

## Durum / sonraki adımlar

- ✅ Faz 1: iskelet, core katman, tema (Stitch "Serene Path"), router, Firebase yapılandırma
  (Android tam; iOS plist Mac'te eklenecek). Debug APK derlendi.
- ✅ Stitch tasarımları: Giriş, Ana Sayfa, Uzmanlar (Uzman Bulun), Gelişim (Gelişim Takibi),
  Profil ekranları tasarıma göre yapıldı (veriler şimdilik mock).
- ✅ Faz 2 auth: backend JWT login/refresh/logout/me + oturum geri yükleme. Canlı backend'e
  karşı doğrulandı (login HTTP 200, role PARENT).
- ✅ i18n (TR/EN): **slang** + YAML (`lib/i18n/tr.i18n.yaml`, `en.i18n.yaml` → `strings.g.dart`).
  Tüm UI metni `t.*`; kodda sabit metin yok. Profil'de TR/EN dil seçici (anlık geçiş).
  Yeni metin: YAML'a ekle + `dart run slang`. Çekirdek (hata) mesajları global `t` kullanır.
- ✅ Kayıt ekranı (`/register`, Veli/Uzman + KVKK) → `/api/auth/register`.
- ✅ Ana Sayfa gerçek veriye bağlı: `/api/children`, `/api/appointments` (yaklaşanlar),
  `/api/knowledge` (Page→content). Yükleniyor/boş/hata durumları + RefreshIndicator.
  Canlı doğrulandı (2 çocuk döndü).
- ⏳ Sonraki: Uzmanlar/Gelişim sekmelerini backend'e bağla; mesajlaşma (STOMP /ws),
  chatbot SSE; FCM (backend cihaz-token uç noktası gerekli — mevcut push Web Push/VAPID).
- Modül kapsamı ve fazlar: bkz. plan `~/.claude/plans/bir-otizm-destek-mobil-compressed-fog.md`.

## Notlar

- Giriş ekranındaki "Veli/Uzman kaydol" butonları henüz tam kayıt ekranına bağlı değil
  (snackbar). Mock veri içeren ekranlar: Ana Sayfa, Uzmanlar, Gelişim.
