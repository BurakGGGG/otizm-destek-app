# Backend FCM Push — Spec (mobil için)

Mobil uygulama (Android, Firebase projesi `otizm-destek-app`) push bildirimi alabilmek
için backend'de **iki uç nokta** + **FCM gönderim servisi** bekler. Mevcut Web Push (VAPID)
yolu korunur; bu, mobil FCM için **ayrı** bir yoldur.

Mobil taraf (bu repo) hazır: izin ister, FCM token alır, aşağıdaki uç noktaya yollar,
bildirime dokununca `data` payload'ına göre ilgili ekrana yönlendirir. Uç nokta canlıya
çıkana kadar mobil 404'ü sessiz geçer.

## 1) Cihaz token kaydı — `POST /api/push/device-token`
- **Auth:** gerekli (Bearer; `authenticated`).
- **Body:**
  ```json
  { "token": "<FCM registration token>", "platform": "ANDROID" }
  ```
- **Davranış:** `(user, token)` upsert. Aynı token başka kullanıcıdaysa sahipliği güncelle.
  `updatedAt` tazele.
- **Yanıt:** `ApiResponse<Void>` → `{ "success": true, "message": "Cihaz kaydedildi" }`.

## 2) Cihaz token silme — `DELETE /api/push/device-token?token=<token>`
- **Auth:** gerekli. Çıkışta / token yenilenince mobil çağırır. İdempotent (yoksa da 200).

## 3) Veri modeli (öneri)
`device_tokens` tablosu:
| alan | tip | not |
|---|---|---|
| id | UUID | PK |
| user_id | UUID | FK users |
| token | text | **unique** |
| platform | varchar | ANDROID / IOS |
| created_at | timestamptz | |
| updated_at | timestamptz | |

## 4) Firebase Admin SDK
- Bağımlılık: `com.google.firebase:firebase-admin`.
- **Service account JSON** (Firebase Console → Project Settings → Service accounts → Generate
  new private key) yalnız **backend'de** secret olarak tutulur (env: `FIREBASE_CREDENTIALS`
  ya da dosya yolu). **Mobile'a/öne asla konmaz.**
- Init (bir kez):
  ```java
  FirebaseApp.initializeApp(FirebaseOptions.builder()
      .setCredentials(GoogleCredentials.fromStream(credsInputStream))
      .build());
  ```

## 5) Gönderim servisi
Olay anında (yeni **mesaj**, **randevu** durum değişimi) alıcının tüm token'larına gönder.

```java
Message msg = Message.builder()
    .setToken(token)
    .setNotification(Notification.builder()
        .setTitle(title).setBody(body).build())
    .putAllData(data)               // aşağıdaki sözleşme
    .setAndroidConfig(AndroidConfig.builder()
        .setPriority(AndroidConfig.Priority.HIGH).build())
    .build();
// Çoklu: FirebaseMessaging.getInstance().sendEachForMulticast(multicast);
```

### `data` payload sözleşmesi (mobil bunu bekler)
Tüm değerler **string** (FCM data zorunluluğu):
| key | değer | mobil aksiyonu |
|---|---|---|
| `type` | `MESSAGE` | `conversationId` ile sohbet thread'ini açar |
| `type` | `APPOINTMENT` | Randevular ekranını açar |
| `conversationId` | UUID | `type=MESSAGE` ile birlikte |
| `conversationTitle` | string | başlık (opsiyonel) |
| `appointmentId` | UUID | `type=APPOINTMENT` ile (opsiyonel) |

Örnek (yeni mesaj):
```json
{
  "notification": { "title": "Ayşe Yılmaz", "body": "Merhaba, yarın uygun musunuz?" },
  "data": { "type": "MESSAGE", "conversationId": "…", "conversationTitle": "Ayşe Yılmaz" }
}
```

## 6) Geçersiz token temizliği
Gönderim yanıtında `UNREGISTERED` / `INVALID_ARGUMENT` dönen token'ları `device_tokens`'tan sil.

## 7) Güvenlik / Security config
- `/api/push/device-token` (POST, DELETE) → `authenticated`. (Mevcut `/api/push/**` zaten
  permitAll **değil**; sadece `vapid-public-key`/`subscribe` gibi gerekli olanları açık tut.)
- Service account anahtarı repo'ya **commit edilmez** (env/secret).

## 8) Test
- Mobilden giriş yap → token kaydının DB'ye düştüğünü gör.
- Bir test mesajı/randevu olayı tetikle → cihazda bildirim; dokununca doğru ekran açılsın.
- Uygulama ön planda → uygulama içi SnackBar; arka planda/kapalı → sistem bildirimi.
