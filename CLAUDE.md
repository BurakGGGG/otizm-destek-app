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
  Profil ekranları tasarıma göre yapıldı (tümü gerçek veriye bağlandı — aşağıya bkz.).
- ✅ Faz 2 auth: backend JWT login/refresh/logout/me + oturum geri yükleme. Canlı backend'e
  karşı doğrulandı (login HTTP 200, role PARENT).
- ✅ i18n (TR/EN): **slang** + YAML (`lib/i18n/tr.i18n.yaml`, `en.i18n.yaml` → `strings.g.dart`).
  Tüm UI metni `t.*`; kodda sabit metin yok. Profil'de TR/EN dil seçici (anlık geçiş).
  Yeni metin: YAML'a ekle + `dart run slang`. Çekirdek (hata) mesajları global `t` kullanır.
- ✅ Kayıt ekranı (`/register`, Veli/Uzman + KVKK) → `/api/auth/register`.
- ✅ Tüm çekirdek ekranlar gerçek backend verisine bağlı (mock kalmadı):
  - **Ana Sayfa:** `/api/children`, `/api/appointments` (yaklaşanlar), `/api/knowledge`.
  - **Uzmanlar:** `/api/experts` + arama/filtre; **uzman detayı** → "Randevu Al" / "Mesaj Gönder".
  - **Gelişim:** `/api/goals`, `/api/notes` (okuma + **hedef/not ekleme**).
  - **Çocuklarım:** `/api/children` CRUD (ekle/düzenle/sil).
  - **Randevular:** `/api/appointments` liste + iptal (veli) / onayla·tamamla (uzman);
    **randevu alma akışı** (müsaitlik slotları + `POST /appointments`);
    **erteleme** (`PATCH /{id}/reschedule`, veli+uzman, müsaitlik slotlu).
  - **Bilgi Bankası:** `/api/knowledge` liste + makale detayı (HTML→düz metin).
  - **Mesajlaşma:** REST geçmiş + **STOMP /ws** canlı; konuşma başlatma
    (`/messages/conversations/direct/{userId}`).
  - **AI Asistan:** `/api/chatbot/stream` (SSE) streaming.
  - **Hesap:** `PUT /api/users/me` ile profil düzenleme.
  - **Bildirimler:** `/api/notifications` liste + okundu işaretleme; Ana Sayfa'da
    okunmamış rozeti.
  - **Şifremi unuttum / sıfırla:** `/api/auth/forgot-password|reset-password`.
  - **Rutinler:** `/api/routines` — çocuk bazlı görsel program; rutin/adım
    ekleme-silme (saat + ikon). Profil menüsünden `/routines`.
  - **Günlük Takip:** 3 sekme — `/daily-tracker`. **Duygu** `/api/mood` (5'li emoji
    + tetikleyiciler + not, gün başına upsert); **Uyku** `/api/sleep` (yatış/uyanış,
    kalite 1-5, gece uyanma, duyusal faktörler — faktörler web ile aynı
    `Weighted:..|Sensory:..|Melatonin:..|Disturbance:..|Notes:..` formatında notes
    içinde serileşir!); **İlaç** `/api/medications` (CRUD + doz günlüğü
    `POST /{id}/log`: alındı + yan etkiler + not). Tetikleyici ve yan etki
    metinleri web ile birebir aynı düz metin (çevrilmez!).
  - **Gelişim Paneli:** `/api/analytics/child/{id}/trends` — 4 aylık trend
    çubuk grafiği (kilometre taşı, ruh hali, uyku, davranış). `/analytics`.
  - **Davranış Günlüğü:** `/api/abc-entries` — ABC (Öncesi-Davranış-Sonuç)
    kayıtları; kategori/yer/tetikleyici/sonuç sabitleri web ile birebir düz
    metin (çevrilmez!), şiddet 1-5. category+location DB'de NOT NULL. `/behavior`,
    Gelişim sekmesi kısayolu.
  - **Kriz Rehberi:** statik içerik (API yok) — 4 kriz kartı (meltdown, duyusal
    aşırı yüklenme, saldırganlık, kaygı) adım-adım müdahale + kaçınılacaklar +
    acil hat; nefes egzersizi (4sn al / 6sn ver animasyonlu halka); acil
    numaralar (112/183) dokun-ara. İçerik i18n'de (TR birebir web'den, EN
    dikkatli çeviri). `/crisis`, Profil menüsü kısayolu.
  - **Takvim:** `/api/calendar` — çocuğa özel etkinlik ajandası (terapi/doktor/
    eğitim/aktivite/randevu/diğer). Ekle/düzenle/sil + durum (PLANNED/COMPLETED/
    CANCELLED, PATCH `?status=`) + hatırlatma (15/30/60/120/1440 dk). Tip kodları
    DB'de sabit (etiketler çevrilebilir); `startTime`/`endTime` saat dilimsiz
    LocalDateTime (`yyyy-MM-ddTHH:mm:ss`). Güne göre gruplu liste. `/calendar`,
    Profil menüsü kısayolu.
  - **Acil Durum Kartı:** `/api/emergency-card/{childId}` — çocuğun kritik
    bilgileri (tanı, kan grubu, iletişim seviyesi, acil kişiler, doktor,
    ilaç/alerji, tetikleyici/sakinleştirme/yapılmayacaklar). Backend serbest
    JSON blob'u; `data` string olarak gelir (jsonDecode). Alan anahtarları web
    `EmergencyProfile` ile birebir aynı. Telefon alanlarında **dokun-ara**
    (`url_launcher` tel:). `/emergency`, Profil menüsü kısayolu.
  - **Dertleşme Duvarı:** forum'un `SUPPORT_WALL` kategorisi — veli topluluğu
    desteği. `GET /api/forum/posts/category/SUPPORT_WALL` (sayfalı
    `PageResponseDto.content`); paylaşım oluştur (`POST /forum/posts`
    `{category:'SUPPORT_WALL', postType:'DENEYIM', anonymous}`, başlık boşsa web
    gibi varsayılan başlık), düzenle/sil (sahibi); destek mesajları
    (`/forum/posts/{id}/comments`, yorum daima `anonymous:true`); beğeni/destek
    aç-kapa (`POST /votes` `{targetType:'POST', targetId, voteValue:1}`, iyimser
    UI). Liste + detay (tam metin + yorumlar + yazma çubuğu). `/support-wall`,
    Profil menüsü kısayolu.
  - **Haftanın Sorusu:** `/api/community/weekly-questions` — topluluk sorusu +
    aile cevapları. Soru listesi → detay (cevaplar + cevap yazma). Cevap
    (`POST /weekly-questions/{id}/answers` `{text}`, `text` zorunlu),
    beğeni aç-kapa (`POST /weekly-answers/{id}/like`, güncel cevabı döner,
    iyimser UI). Cevap metnine web ile **birebir aynı** meta gömülür:
    `[ANONYMOUS_META:true]` + `[TAGS:a,b]` önekleri (`WeeklyAnswer.encode`/parse);
    etiket kodları (`kWeeklyAnswerTags`) çevrilmez. Uzman rozeti: rol EXPERT ya
    da ad "Uzm."/"Dr." içerir. `/weekly-question`, Profil menüsü kısayolu.
  - **Yerel Buluşmalar:** `/api/community/meetups` — şehir bazlı aile
    buluşmaları. Şehir filtresi (`kMeetupFilterCities`, `Tümü` sunucuya
    gönderilmez), liste + oluşturma (`POST /meetups`, title/city/date zorunlu;
    `date` `yyyy-MM-dd` LocalDate, `time` `HH:mm` LocalTime; emoji varsayılan
    '📍'), katılım aç-kapa (`POST /meetups/{id}/attendance`, güncel buluşmayı
    döner, iyimser UI). Oluşturma formu şehir seçici `kTurkishCities` (81 il,
    web `TURKISH_CITIES` birebir). Geri sayım rozeti (Bugün/Yarın/X gün sonra).
    `/meetups`, Profil menüsü kısayolu.
  - **Benzer Aileler:** `/api/matching` + `/api/buddies` — eşleştirme motorunun
    çocuğa yakın bulduğu aileler. Çocuk seçici → `GET /matching/similar/{childId}`
    (uyum skoru %, ortak etiketler, eşleşme nedenleri); keşfedilebilirlik
    anahtarı (`GET /matching/status` + `PUT /matching/opt-out`, toggle → yeni
    durumu döner). Kart aksiyonları: **Mesaj** (mevcut `getOrCreateDirect` →
    thread), **Arkadaş** ve **Mentor** (`POST /buddies/request`
    `{receiverId, isMentorRequest, message}`, iyimser → PENDING).
    `relationshipStatus` PENDING/ACCEPTED ise buddy/mentor kilitli, rozet
    gösterilir. `/similar-families`, Profil menüsü kısayolu. (Not: web'deki
    per-aile "Buluşma" isteği akışı kapsam dışı — topluluk buluşmaları ayrı
    `/meetups` özelliğinde.)
  - **Destek Grupları:** `/api/groups` — kategori bazlı aile/uzman toplulukları
    + grup sohbeti. İki sekme: **Gruplarım** (`/groups/my`) ve **Keşfet** (arama
    `/groups/search?query=` + kategori `/groups/category/{cat}`). Katıl
    (`POST /groups/{id}/join`), ayrıl (`/leave`), oluştur (`POST /groups`,
    name zorunlu; kategori `kGroupCategories` web `groupCategories` birebir —
    veri, çevrilmez). Üyeyse **Grup Sohbeti** →
    `POST /messages/conversations/group/{groupId}` (messaging repo'ya
    `getOrCreateGroup` eklendi) → mevcut `ConversationThreadScreen`.
    Mutasyon sonrası her iki liste invalidate edilir. `/groups`, Profil menüsü
    kısayolu.
  - **Tedavi Paneli:** `/api/treatment-state/{childId}` — günlük destek planı
    (web `/tedavi` birebir). **DİKKAT: bu uç nokta zarfsız** — GET/PUT ham
    `TreatmentStateDto` döner/alır (`{success,data}` yok, tek istisna). Backend
    yalnızca 5 alanı kalıcılaştırır (gameFeedback, customGoals, sensoryProfile,
    gameSessions, goalProgressHistory); templateGoalToggles/completedPlanSteps/
    customStories sunucuda düşer (web'de de oturum içi) — mobil aynı davranışı
    yansıtır. Plan şablonu (hedef etiketleri, 18 oyunluk kütüphane, hikayeler,
    plan adımları, linkedGoal/linkedTool, kilometre taşı kategorileri) web
    treatmentPlan.tsx'ten **birebir Türkçe** — paylaşılan blob'da saklanan
    VERİ, çevrilmez. Anahtar formatları: gameFeedback `yyyy-MM-dd:gameId`,
    completedPlanSteps `yyyy-MM-dd:stepId`; tarih anahtarı YEREL saat
    (`treatmentDateKey`). 4 sekme: **Bugün** (plan adımları, duygu, öneriler,
    son not, haftalık grafik), **Hedefler** (özel hedef CRUD + şablon toggle +
    kilometre taşı `POST /api/milestones`), **Oyunlar** (geri bildirim 4'lü +
    uyum ipuçları + **Uzmana Bildir** gerçek mesajlaşma REST'iyle + hikayeler),
    **Araçlar** (duyusal profil kaydırıcıları kalıcı; jeton panosu oturum içi;
    /crisis ve /chat kısayolları). İyimser kaydet + hatada geri alma (web
    `persistTreatmentState` deseni); 90 günlük oturum budama. Web'in statik
    demo işbirliği paneli (sabit sahte veri) kapsam dışı. Saf geçişler
    `test/treatment_state_test.dart` ile korunur. `/treatment`, Profil menüsü
    kısayolu.
  - **Ödevlerim:** `GET /api/patients/my-tasks` — uzmanın veliye atadığı
    görevler (web `/gorevler` PARENT_EXPERT; CLAUDE.md'deki eski "uzman rolü"
    notu yanlıştı, veli tarafı var). Filtreler (Tümü/Yapılacaklar/Teslim
    Edilenler), bekleyenler son tarihe göre sıralı (tarihsiz sona), CANCELLED
    listelenmez; gün bazlı gecikme uyarısı (bugün son gün ise gecikmiş
    sayılmaz). Teslim: `POST /api/task-submissions`
    `{taskId, parentId, parentNote, evidenceUrl}` — görevi backend'de
    COMPLETED yapar + uzmana bildirim gider. Teslim kayıtları
    `GET /task-submissions/task/{id}` (veli notu + kanıt linki + uzman geri
    bildirimi `expertReviewed`). `category`/`frequency` uzmanın serbest Türkçe
    metni (veri, çevrilmez); `difficulty` EASY/MEDIUM/HARD ve `status`
    PENDING/COMPLETED/CANCELLED enum kodları (etiketler i18n).
    `dueDate` `yyyy-MM-dd` LocalDate. Sıralama/gecikme mantığı
    `test/expert_task_test.dart` ile korunur. `/tasks`, Profil menüsü kısayolu.
  - **Topluluk Forumu:** `GET /api/forum/posts?type=&tagIds=&q=&order=` —
    tam forum (web ForumPage; Dertleşme Duvarı `SUPPORT_WALL` ayrı özellikte
    kalır). 4 tip sekmesi (DENEYIM/QUESTION/TAVSIYE/BASARI_HIKAYESI — kodlar
    sabit, etiketler i18n), arama, sıralama (`order` new/hot/unanswered/
    expert), semptom etiketi filtresi (`GET /tags/grouped`; kategori kodları
    ILETISIM/SOSYAL/... i18n etiketli, **etiket adları veri — çevrilmez**),
    sayfalı liste (Daha Fazla Yükle). Detay: tam metin (HTML→düz metin),
    beğeni (`POST /votes` POST +1 toggle), yorumlar (uzman onaylı önce) +
    tek seviye yanıt (`parentCommentId`) + yorum oyu (+1/-1,
    upvotedByMe/downvotedByMe), soru sahibi **en iyi cevap**
    (`POST /forum/posts/{id}/accept/{commentId}`), kendi gönderi/yorum
    düzenle-sil, şikayet (`POST /reports {targetType,targetId,reason}`).
    Oluşturma: tip + başlık + içerik + etiketler + anonimlik + gizlilik
    ayarları (web `defaultPrivacy` birebir; anonimse ad+tanı kapalı). Forum
    yorumları duvardan farklı: `anonymous` bayrağı gönderilmez. `/forum`,
    Profil menüsü kısayolu.
  - **Çocuk Detayı:** `GET /api/children/{id}` — web `/cocuklarim/:id`
    panelinin mobilde eksik olan özgün bölümleri (duygu/uyku/ilaç/davranış/
    not bölümlerinin kendi ekranları zaten var; kısayol çipleri verildi).
    Bölümler: **profil fotoğrafı** (image_picker galeri → `POST /upload`
    multipart `{data:{url}}` → child PUT `profileImageUrl`), bilgiler (tanı/
    eğitim/terapi + mevcut form ekranına düzenleme), **semptom etiketleri**
    (`/tags/grouped` çoklu seçim; kayıt tam gövde + `tagIds` PUT — web
    birebir; Child modeline `tags` eklendi), **kilometre taşları**
    (`/api/milestones` tam CRUD; kategori değerleri Türkçe sabit veri
    `kMilestoneCategoryValues` — çevrilmez; `achievedDate` `yyyy-MM-dd`),
    **tarama sonuçları** (salt okunur `GET /screening/child/{id}`, skor /20 +
    LOW/MEDIUM/HIGH). Çocuklarım listesinde karta dokunmak detayı açar
    (düzenle/sil menüde kaldı). Tarama anketi web'de olmadığı için mobilde de
    yok.
- ✅ Firebase: Crashlytics + Analytics kod entegrasyonu (debug'da kapalı, sürümde açık).
- ✅ FCM push: mobil taraf hazır; **backend uç noktaları da yazıldı** (POST/DELETE
  `/api/push/device-token`, MESSAGE/APPOINTMENT data payload — sözleşme
  `docs/backend_fcm_spec.md` ile birebir). Render'a deploy edilince uçtan uca
  çalışır; mobil 404'ü sessiz geçtiği için kod değişikliği gerekmez.
- ✅ UI cilası: isim baş harfli avatarlar, skeleton yükleme, paylaşılan boş/hata
  bileşenleri (+CTA), haptics, **karanlık tema** (theme-aware `AppPalette` + `context.colors`,
  Profil'de Sistem/Açık/Koyu seçici, kalıcı).
- ✅ Hedef ilerletme (+jeton geri alma) — `PUT /api/goals/{id}` (entries JSON dizisi;
  title+category zorunlu). Gelişim sekmesindeki hedef kartlarında.
- ⏳ Sonraki adaylar: backend FCM deploy sonrası uçtan uca push testi (mobil
  kod hazır). **Veli tarafı web pariteye ulaştı** — kalan web rotaları kapsam
  dışı: BEP oluşturucu + danışanlar EXPERT_ONLY; tarama anketi web'de YOK
  (yalnızca sonuç gösterimi, `/tarama` → `/cocuklarim` redirect); admin
  paneli mobil hedefi değil. Not: sosyal hikayeler (`/api/social-stories`)
  ve wellbeing backend'de var ama web'de tam bir CRUD arayüzü yok (mirror
  edilecek UX yok) — düşük öncelik.
- Modül kapsamı ve fazlar: bkz. plan `~/.claude/plans/bir-otizm-destek-mobil-compressed-fog.md`.

## Notlar

- **Renkler:** widget'lar `context.colors.X` (AppPalette) kullanır; sabit palet
  `lib/core/theme/app_colors.dart` (`AppPalette.light`/`dark`). Tema kurarken `AppColors`
  (sabit, açık) kullanılır. Yeni ekranlarda `AppColors.*` yerine `context.colors.*`.
- Backend mutasyonları (POST/PUT/DELETE) canlı paylaşılan DB'yi kirletmemek için sözleşme
  bazında kaynaktan doğrulandı; canlı deneme kullanıcıya bırakıldı.
