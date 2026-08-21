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
flutter build appbundle --release   # mağaza paketi (key.properties gerekir)
```

`flutterfire` CLI: `~/.pub-cache/bin` PATH'te olmalı. Yeniden yapılandırma:
`flutterfire configure --project=otizm-destek-app --platforms=android,ios`.

**Ortam profilleri** (`config/`, bkz. `config/README.md`):
`flutter run --dart-define-from-file=config/render.json` (varsayılanla aynı:
API Render, paylaşılan bağlantılar Vercel — web PWA de aynı backend'i kullanıyor)
ya da `config/otizmdestek.json` (özel alan adı; DNS yayına girince).

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
  - **Gelişim:** `/api/goals`, `/api/notes` (okuma + **hedef/not ekleme**);
    Gelişim sekmesindeki not bölümünden **Notlarım** tam ekranına geçiş.
  - **Notlarım:** `/api/notes` tam CRUD (web NotesPage birebir) — çocuk
    seçici, sayfalı liste (`GET /notes/child/{id}?page=`), arama +
    kategori/ruh hâli filtresi (client-side, web gibi), oluştur/**düzenle**
    (`PUT /notes/{id}`)/**sil** (`DELETE /notes/{id}`). **Veri uyumu
    düzeltmesi:** not kategorileri artık web ile birebir `kNoteCategories`
    (`Dil Gelişimi/Sosyal Beceri/Motor Gelişim/Davranış/Eğitim/Genel` —
    goal kategorilerinden AYRI, çevrilmez veri); ruh hâli ortası kodu
    `calm`→**`neutral`** (web `moods` birebir: happy/neutral/sad, paylaşılan
    DB'de saklanan veri). Not formu (`note_form_screen`) artık edit modunu da
    destekler. `/notes`, Profil menüsü + Gelişim sekmesi kısayolu.
  - **Çocuklarım:** `/api/children` CRUD (ekle/düzenle/sil).
  - **Randevular:** `/api/appointments` liste + iptal (veli) / onayla·tamamla (uzman);
    **randevu alma akışı** (müsaitlik slotları + `POST /appointments`;
    randevu tipi uzmanın sunduğu biçimle sınırlı — web bu bayrakları formda
    kullanmıyor);
    **erteleme** (`PATCH /{id}/reschedule`, veli+uzman, müsaitlik slotlu);
    **detay sayfası** (web "Randevu Detayı" penceresi birebir: süre, taraflar,
    görüşme konusu/öncesi not/seans notu/özet/öneriler/takip görevi,
    değerlendirme, görüşmeye katıl) + **durum geçmişi** zaman çizelgesi
    (`GET /appointments/{id}/history`; kayıt yoksa ya da uç nokta hata verirse
    web gibi sessizce boş gösterilir).
  - **Bilgi Bankası:** `/api/knowledge` liste + makale detayı (HTML→düz metin).
  - **Mesajlaşma:** REST geçmiş + **STOMP /ws** canlı; konuşma başlatma
    (`/messages/conversations/direct/{userId}`); thread açılınca **okundu**
    işaretleme (`POST /conversations/{id}/read` — okunmamış rozeti yalnızca
    bununla sıfırlanıyordu, mobilde eksikti), **arşiv/sessize alma**
    (`/archive`, `/mute`) ve liste süzgeçleri (Tümü/Okunmamış/Uzmanlar/
    Gruplar/Arşiv — web `ConvFilter` birebir). **PECS görsel iletişim
    kartları**: 12 kart, 3 kategori; kart gönderilince web'deki gibi
    **etiket metni** mesaj olarak gider (paylaşılan veri, çevrilmez) ve
    içerik eşleşen mesajlar emojisiyle çizilir (`messageType: PECS`).
    **Yanıtlama** (`replyToId` + balonda alıntı), **emoji tepkileri**
    (`POST /messages/{id}/react`, hızlı emoji seti web `QUICK_EMOJIS`
    birebir; `/topic/conversation/{id}/reactions` STOMP aboneliğiyle canlı),
    **fotoğraf eki** (image_picker → `POST /upload` `CONVERSATION` kapsamı →
    `IMAGE` mesajı). Ek dosyalar `GET /api/upload/**` kimlik doğrulaması
    istediği için tarayıcıda açılamıyor: dosya Bearer'lı indirilip paylaşım
    sayfasına veriliyor (web same-origin çerezle doğrudan açıyor).
    **Yeni sohbet** (`GET /users/search?q=`, en az iki harf) ve **sohbet içi
    arama** (`GET /conversations/{id}/search`). Arama sonucuna dokunmak
    mesaja atlamıyor (geçmiş sayfalı geldiği için konum garanti edilemiyor).
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
    **Yapay zekâ analizi** (`/api/ai-insights/{childId}`): dört tür
    (GENERAL/BEHAVIORAL/PROGRESS/WEEKLY — web `ANALYSIS_TYPES` birebir),
    SSE akışı (`/stream`) sohbet botundaki ayrıştırıcıyla, akış kurulamazsa
    web gibi tek seferlik uç noktaya düşülür. Backend veli `AI_ANALIZ` açık
    rızası istediği için kart rıza yoksa KVKK sayfasına yönlendirir; çıktı
    hafif markdown (başlık/madde/kalın) olarak çizilir ve tıbbi uyarı
    şeridiyle birlikte gösterilir. **Ham veri paneli** (web'in üç grafik
    sekmesinin karşılığı, mobilde tek akış): gün aralığı seçici (7/14/30/90 —
    web `RANGE_OPTIONS`), **takip skoru** (ruh hali %30 + uyku %30 + aktivite
    %20 + veri kapsamı %20, web `wellbeingScore` birebir) ve kural tabanlı
    öngörüler, eksik veri önerileri (en fazla üç), günlük ruh hali ve uyku
    (süre + kalite) serileri, davranış/kilometre taşı kategori kırılımları,
    aylık not aktivitesi ve **CSV paylaşımı** (web'de indirme; sütunlar
    `exportCsv` ile aynı). Hesaplar saf (`domain/analytics_summary.dart`,
    `test/analytics_summary_test.dart`), kaynaklar tek sağlayıcıda paralel
    toplanır ve tek tek yakalanır. Web'den ayrım: tarama başlatma önerisi yok
    (tarama anketi web'de de bulunmuyor).
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
    gösterilir. **Buluşma isteği** (`/api/meetup-requests`, PARENT'a kısıtlı):
    tür (ONLINE/YUZEYUZE — veri), tarih (`yyyy-MM-dd`), saat (`HH:mm`), yer ve
    not; gelen isteklerde kabul/ret, giden isteklerde geri çekme şeridi.
    (Topluluk buluşmaları ayrı `/meetups` özelliğidir.)
    `/similar-families`, Topluluk merkezi kısayolu.
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
- ✅ **Backend kayması düzeltmeleri (2026-08-16, web'in temmuz sürümü sonrası):**
  - **Oturum:** `AuthResponse.refreshToken` artık `@JsonIgnore`; token yalnızca
    httpOnly `refresh_token` çerezinde (Path=/api/auth) dönüyor ve her
    yenilemede rotasyona giriyor. Mobil token'ı `Set-Cookie` başlığından okuyor
    (`core/network/auth_cookies.dart`); yeni token okunamazsa eskisi saklanmaz
    (kullanılmış token tüm oturumları iptal ettiriyor). `RefreshInterceptor`
    artık `/auth/me` 401'ini de yeniliyor (açılışta oturum düşüyordu).
  - **Medya:** `GET /api/upload/**` authenticated oldu ve göreli URL dönüyor;
    `core/network/media.dart` (mutlaklaştırma + Dio üzerinden Bearer'lı
    `AuthedNetworkImage`). Yükleme `visibility` + `scopeType/scopeId` gönderir.
  - **Şifre:** `StrongPasswordValidator` (8-64, büyük harf, rakam, özel
    karakter, yaygın şifre yasağı) `core/util/password_rules.dart` ile birebir.
- ✅ **E-posta doğrulama:** kayıt yanıtı `pendingEmailVerification` /
  `pendingApproval` dönebiliyor (token'sız). `/verify-email` ekranı: kod ile
  doğrulama, yeniden gönderme, uzman onay bekleme; girişte doğrulama hatasında
  kısayol. Kayıtta e-posta müsaitlik kontrolü + uzman kaydında lisans zorunlu.
- ✅ **Onboarding** (`/onboarding`, web `/baslangic`): çocuk profili → destek
  etiketleri → başlangıç planı; `POST /users/me/onboarding-complete`, router
  `onboardingCompleted` bayrağına göre yönlendiriyor.
- ✅ **Ayarlar** (`/settings`): bildirim/gizlilik/erişilebilirlik tercihleri
  (cihazda, web localStorage anahtarlarıyla aynı adlar), tema+dil (Profil'den
  taşındı), şifre değiştirme, verilerimi indir (JSON paylaşımı), hesap silme.
- ✅ **KVKK** (`/kvkk`): amaç bazlı rızalar, yeniden rıza kartı, rıza geçmişi,
  veri sahibi başvuruları (`/kvkk/requests`).
- ✅ **Yasal metinler** (`/legal`, `/legal/:kind`): KVKK aydınlatma, gizlilik,
  kullanım şartları, tıbbi uyarı, güven merkezi — web `PublicInfoPage` birebir
  (bağlayıcı metin, çevrilmez); oturumsuz da açılır (kayıt ekranından).
- ✅ **Erişilebilirlik:** büyük yazı (%112,5), sakin görünüm ve yüksek kontrast
  paletleri, hareket azaltma (geçişsiz sayfa animasyonu), basit mod (profil
  menüsü sadeleşir) — hepsi Ayarlar > Erişilebilirlik altında, kalıcı.
- ✅ **Acil kart paylaşımı:** süreli jeton + QR (`.../share` uç noktaları),
  kopyala/paylaş/kapat; `ACIL_DURUM_KARTI` rızası yoksa kapı kapalı.
  Bağlantı web köküne gider (`Env.webBaseUrl`).
- ✅ **Bildirimler ekranı:** kategori sekmeleri (web `notificationUtils`
  eşlemesi), tarih gruplama, kaydırarak/seçerek silme, sayfalama.
- ✅ **Günlük Egzersiz Sihirbazı** (Ödevlerim > Sihirbaz sekmesi, web
  `DailyExerciseWizard`): görevler tek tek gezilir, sonuç seçimi velinin
  notunun başına **paylaşılan işaret** olarak eklenir (`[🎉 Kolayca Yaptık]`,
  `[🙂 Destekle Yaptık]`, `[💬 Bugün Zorlandık]` — çevrilmez), zorlanmada
  AutiBot ipucu, kanıt fotoğrafı `AUTHENTICATED` görünürlükle yüklenir
  (`core/network/upload_repository.dart` ortak sarmalayıcı), ilerleme ağacı
  (Tohum/Filiz/Çiçek/Ağaç, %25/50/75 eşikleri). Web'den ayrım: tamamlanmış
  görev tekrar teslim edilemez (web ikinci kayıt + ikinci bildirim üretiyor).
- ✅ **Kullanıcı Rehberi** (`/guide`, web `/kullanici-rehberi`): role göre
  başlangıç adımları, kategori bazlı bölüm kataloğu ("ne işe yarar / ne zaman
  kullanılır" + bölüme git), Türkçe uyumlu arama (`core/util/search_text.dart`),
  eğitim videoları listesi. Videolar web sunucusunda (webm, iOS oynatmıyor)
  kaldığı için kart `Env.webBaseUrl/kullanici-rehberi?video=NN` adresini
  tarayıcıda açar; izlendi işareti cihazda saklanır.
- ✅ **Topluluk merkezi** (`/community`, web `/topluluk`): yedi topluluk alanı
  tek girişte; Profil menüsündeki altı ayrı satırın yerine geçti.
- ✅ **Randevu başlığı:** canlı geri sayımlı "sıradaki randevu" kartı + altı
  sayaç; boş durumda Uzmanlar sekmesine götüren CTA (`/home?tab=` ile sekme
  açılabiliyor). "Bu hafta" sayacı web'den farklı olarak yalnızca bu haftayı
  sayar.
- ✅ **Kriz rehberi:** kriz kartını sesli dinleme (`flutter_tts`,
  `core/tts/speech_service.dart` — web `speechSynthesis` karşılığı), tıbbi
  uyarı şeridi (+ `/legal/medical`), "ilk kural" hatırlatması, kriz sonrası
  kontrol listesi.
- ✅ **Bilgi bankası:** `/knowledge/search` ile arama + kategori
  (`kKnowledgeCategories`, veri) + içerik türü + **semptom etiketi** filtresi
  (çoklu seçim; `tagIds` web gibi virgülle birleşik tek parametre gider),
  sayfalama, yer imleri (`/bookmarks`, `POST /{id}/bookmark`), ilgili
  içerikler, yorumlar (okuma + yazma), makaleyi sesli dinleme. Makale
  kartlarında etiket rozetleri. Yorumun "deneyim" alanları gönderilmiyor:
  backend DTO'sunda `isExperience` Jackson'a `experience` adıyla açıldığı için
  web'in gönderdiği bayrak sunucuda karşılık bulmuyor (gelen kayıtta iki
  anahtar da okunur).
- ✅ **Uzmanlar:** değerlendirmeler (`/api/experts/{id}/reviews` — ortalama,
  liste, kendi değerlendirmeni yaz/güncelle/sil) ve filtre sayfası (şehir,
  yalnızca randevu kabul edenler, yalnızca doğrulanmış, **yalnızca online**,
  **yalnızca favorilerim**, sıralama). Favoriler cihazda saklanır (web
  `expert_favorites_v1`), kartta kalp düğmesi. **Uzman profili** web `ProfilePage`/`ExpertsPage` bilgileriyle
  dolduruldu: hakkında (bio), doğrulama rozetleri, profil bilgileri tablosu
  (ilk uygun randevu `GET /appointments/experts/{id}/next-available`, görüşme
  süresi, yaş grubu, diller, destek konuları, hizmet biçimi, seans ücreti,
  iptal/erteleme koşulu — değerler veri, yalnızca etiketler çevrilir) ve
  **profil şikayeti** (`POST /reports {targetType:'EXPERT'}`, nedenler web
  `REPORT_REASONS` birebir; açıklama yeni satırla eklenir). Şikayet uç noktası
  `features/reports/` altında ortaklaştı (forum da onu kullanıyor). Web'den
  ayrım: "ilk uygun randevu" yalnızca uzman detayında sorulur (web listedeki
  her uzman için ayrı istek atıyor); lisans numarası rozeti yok — `/experts`
  yanıtı bu alanı taşımıyor (web'de de hep boş).
- ✅ **Uzman erişimi** (`/expert-access`, `/api/patients/connections/**`):
  veli, uzmanın çocuk verisine erişimini onaylar/reddeder, verdiği erişimi
  geri alır. Ana sayfada bekleyen istek şeridi, Çocuklarım başlığında ve
  Ayarlar > Gizlilik altında kısayol. Uç noktalar PARENT'a kısıtlı.
- ✅ **Ana sayfa:** dört hızlı eylem kısayolu (günlük kayıt, davranış notu,
  gözlem notu, plan ekle).
- ✅ **Genel arama** (`/search`, `GET /api/search`): makale, forum gönderisi,
  grup ve uzman tek sorguda; tür süzgeci ve kabuk başlığındaki arama düğmesi
  (web bunu kenar çubuğu komut paletinde sunuyor). Web'den ayrım: sonuca
  dokunmak bölüm listesine değil doğrudan içeriğe gider (uzman profili için
  `GET /experts/{id}` ile profil çekilir).
- ✅ **Günlük plan + koç notu** (ana sayfa, web `todayTasks`/`dailyCoachNote`):
  kural tabanlı "bugün ne yapalım" listesi — bekleyen doz ve bugün/yarın
  etkinliği en acil, tamamlananlar sona; ilerleme yüzdesi, sıra rozetleri
  (Şimdi bunu yap/Sonra/Güvenlik) ve yedi varyantlı koç notu. Girdiler
  `data/daily_plan_provider.dart` içinde paralel toplanır (ruh hali,
  ilaç dozları, takvim, notlar, okunmamış mesaj, uzman isteği, acil kart);
  alt istekler tek tek yakalanır, biri düşerse plan yine çıkar. Kurallar saf
  (`domain/daily_plan.dart`) ve `test/daily_plan_test.dart` ile korunur.
  **Yeni kullanıcı kontrol listesi**: profil → ilk kısa kayıt → kriz rehberi;
  kapatma cihazda saklanır (web `dashboard-onboarding-dismissed`). "Görüldü"
  bilgisi için gerçek ziyaretler işaretlenir
  (`core/storage/visited_routes.dart`, router dinleyicisi) — web yalnızca
  rehberden tıklananları sayıyor. Web'den ayrım: bekleyen süre toplamı
  gerçek dakikaları toplar (web "30 sn"yi 30 dakika sayıyor), duyusal profil
  adımı yok (mobilde Tedavi Paneli > Araçlar altında).
- ⏳ Sonraki adaylar: backend FCM deploy sonrası uçtan uca push testi.
  Kapsam dışı: BEP oluşturucu + danışanlar EXPERT_ONLY; tarama anketi web'de
  YOK (`/tarama` → `/cocuklarim` redirect); admin paneli mobil hedefi değil;
  ilaç-davranış zaman çizelgesi (web'de yalnızca EXPERT_ONLY danışanlar
  sayfasında ve **sabit sahte veriyle** çiziliyor); uzman "harita" görünümü
  (web'de gerçek harita değil, CSS ızgarasına yerleştirilmiş sahte konum
  kartları); uzman içerik yazarlığı
  (makale oluştur/AI taslak/analitik) web'de kalıyor. Sosyal hikayeler ve
  wellbeing backend'de var ama web'de mirror edilecek UX yok.
- Modül kapsamı ve fazlar: bkz. plan `~/.claude/plans/bir-otizm-destek-mobil-compressed-fog.md`.

## Notlar

- **Renkler:** widget'lar `context.colors.X` (AppPalette) kullanır; sabit palet
  `lib/core/theme/app_colors.dart` (`AppPalette.light`/`dark`). Tema kurarken `AppColors`
  (sabit, açık) kullanılır. Yeni ekranlarda `AppColors.*` yerine `context.colors.*`.
- **Uygulama simgesi:** varsayılan Flutter simgesi yerine uygulama içindeki
  logo (birincil mavi zemin + beyaz `volunteer_activism` ikonu). Android
  mipmap'leri (eski + API 26 uyarlanabilir ön plan/tek renk katmanları,
  `mipmap-anydpi-v26/ic_launcher.xml`) ve iOS AppIcon seti
  `python3 tool/generate_icons.py` ile üretilir (kaynak: Flutter SDK'daki
  Material ikon fontu; ek varlık yok). Uyarlanabilir katman olmadan API 26+
  simgeyi beyaz dairenin içine küçültüyordu. Açılış penceresi rengi
  `values/colors.xml` + `values-night` ile uygulamanın sayfa zemininde
  (`splash_background`).
- **Android sürüm imzası:** `android/key.properties` varsa gerçek anahtarla,
  yoksa debug anahtarıyla imzalanır (`android/app/build.gradle.kts`). Şablon
  `android/key.properties.example`; anahtar/parola depoya girmez.
- **Android manifest:** uygulama adı "Otizm Destek" (paket adı değil),
  `allowBackup=false` (sağlık verisi otomatik yedeklemeye girmesin) ve
  `url_launcher` için `VIEW` + `http(s)` paket görünürlük sorguları — Android
  11+ bu sorgu olmadan tarayıcıyı açamıyor (rehber videoları, görüşme linki,
  ödev materyali bu yüzden sessizce açılmıyordu).
- **iOS Info.plist:** görünen ad "Otizm Destek", `image_picker` için galeri ve
  kamera kullanım açıklamaları, `url_launcher` için `LSApplicationQueriesSchemes`
  (`tel`, `http`, `https`) hazır — Mac'te derlenince izin uyarısı ya da sessiz
  başarısızlık olmasın (GoogleService-Info.plist hâlâ eklenecek).
- **Dış bağlantılar:** uzmanın/velinin girdiği adresler (görüşme linki, ödev
  materyali, kanıt dosyası, makale medyası) `core/util/external_link.dart`
  üzerinden açılır; yalnızca `http`/`https` kabul edilir (`intent://`,
  `file://`, `market://` gibi şemalar cihazda başka uygulama tetikleyebilir).
  Uygulamanın kendi ürettiği `tel:` bağlantıları doğrudan açılmaya devam eder.
- **Ağ günlüğü:** `Env.enableNetworkLogs` varsayılanı **debug**'dır ve
  günlükçü yalnızca yöntem + yol + durum kodu yazar. İstek gövdeleri (çocuk
  sağlık kaydı, acil durum kartı, şifre) ve `Authorization` başlığı hiçbir
  derlemede günlüğe düşmez (`test/network_logging_test.dart`).
- **Simge düğmeleri:** yalnızca ikon taşıyan her `IconButton` `tooltip` almak
  zorunda — ekran okuyucu adı buradan gelir. Ortak etiketler
  `t.common.a11y.*`; kural `test/icon_button_tooltip_test.dart` kaynak
  taramasıyla korunuyor.
- **Kaydedilmemiş form:** form ekranları `UnsavedChangesGuard`
  (`core/widgets/unsaved_changes_guard.dart`) ile sarılır; `hasChanges` pop
  anında değerlendirilir (formun her tuş vuruşunda çizilmesi gerekmez).
  Kaydettikten sonra `Navigator.pop` doğrudan çağrıldığı için onay çıkmaz.
- **Autofill:** giriş/kayıt/şifre alanları `AutofillGroup` içinde ve
  `autofillHints` taşır; başarılı giriş/kayıt sonrası
  `TextInput.finishAutofillContext()` şifre yöneticisinin kaydetme istemini
  tetikler.
- Backend mutasyonları (POST/PUT/DELETE) canlı paylaşılan DB'yi kirletmemek için sözleşme
  bazında kaynaktan doğrulandı; canlı deneme kullanıcıya bırakıldı.
- **Web/backend kaynağı:** parite çalışmasında `github.com/EnesKotay/otizm-destek-platformu`
  deposu (frontend/ + backend/) referans alınır; sözleşmeler tahmin edilmez,
  ilgili controller/servis okunur.
- **Semptom etiketleri** (`/api/tags`) forum, çocuk profili, ilk kurulum ve
  bilgi bankasında ortaktır: model `features/tags/domain/symptom_tag.dart`,
  sağlayıcılar `symptomTagsGroupedProvider` / `symptomTagsProvider` (düz liste
  gruplu yanıttan türetilir — web'in ayrıca yaptığı `GET /tags` çağrısı
  mobilde yok).
- **Paylaşılan veri vs. arayüz metni:** backend'e yazılan ya da web'in okuduğu
  metinler (etiket adları, kategori değerleri, onboarding seçenekleri, yasal
  metinler) çevrilmez — i18n yalnızca arayüz metinleri içindir.
- **Dolgulu butonlar tam genişlik tasarlandı:** temada `FilledButton` ve
  `OutlinedButton` için `minimumSize: Size.fromHeight(...)` verilir, yani
  asgari genişlik **sonsuzdur**. Bu butonları `Row` içine koyarken ya
  `Expanded`/`Flexible` ile sınırlayın ya da satır içi biçimi verin
  (`AppButtonStyles.inlineFilled` / `inlineOutlined`,
  `core/theme/app_theme.dart`); aksi halde "BoxConstraints forces an infinite
  width" hatasıyla ekran çöker. `FilledButton.tonal*` de aynı temayı kullanır.
  `TextButton`'da bu kısıt yok. Kural `test/button_layout_rule_test.dart` ile
  korunur: hem davranışı doğrular hem de `lib/` kaynağını tarayıp sarmalanmamış
  satır butonu kalmadığını denetler (bu tarama randevu kartı dahil 14 gerçek
  çökme noktası buldu). Kaynak taraması **dolaylı** durumları görmez (buton
  başka bir widget sınıfının içindeyse); onları ekran görüntüsü üreteci
  yakalar — Benzer Aileler ekranındaki `_ConnectButton` böyle bulundu.
- **Ekran duman testleri:** `test/screen_smoke_test.dart` belirli ekranların
  davranışını doğrular (rozet, düğme durumu vb.); uzun listeler için test
  yüzeyi büyütülür (`tester.view.physicalSize`).
- **Ekran çökme taraması:** `test/screens_build_test.dart` **62 ekranı**
  sahte backend'le (`test/support/fake_backend.dart` → `screenCatalog`) kurar
  ve hiçbir çizim/düzen hatası atmadığını doğrular; karanlık tema ve büyük
  yazı + yüksek kontrast varyantları da listede. Yeni ekran eklerken katalog
  listesine bir satır eklemek yeterli. **Fontlar `loadTestFonts()` ile
  yüklenmeli**: test motorunun varsayılan fontu her karakteri sabit genişlikte
  çizdiği için gerçekte olmayan taşma hataları üretiyor.
- **Ekran görüntüsü üreteci:** `flutter test tool/screenshots_test.dart
  --update-goldens` aynı katalogdan `build/screens/*.png` üretir
  (emülatör/oturum gerektirmez; `tool/` normal takıma girmez). Aile
  belirtmeyen `TextStyle`lar başsız render'da kutu çizer (cihazda sistem
  fontuna düşerler) — görüntülerdeki bu kusur beklenendir.
- `dart format` bu depoda **kullanılmıyor** (mevcut dosyaların çoğu farklı
  sarmalanmış); elle 80 sütun hedeflenir.
