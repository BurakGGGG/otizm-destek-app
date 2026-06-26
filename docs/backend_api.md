# Backend API Referansı (otizm-backend)

Kaynak: Spring Boot monorepo `github.com/EnesKotay/otizm-destek-platformu` (backend/).
Canlı: `https://otizm-backend.onrender.com` — REST ön eki **`/api`**, WS **`/ws`** (STOMP).

## Genel zarf
Tüm yanıtlar `ApiResponse<T>`:
```json
{ "success": true, "message": "…", "data": { … } }
```
401 gövdesi: `{"success":false,"message":"Oturum süresi dolmuş…"}`.
Kimlik: `Authorization: Bearer <accessToken>` (backend JWT). Stateless.

## Roller
`UserRole`: **PARENT, EXPERT, ADMIN** (educator/child yok).

## Auth — `/api/auth`
- `POST /login` `{email, password(min8)}` → `{accessToken, refreshToken, user: UserDto}`
- `POST /register` `{email, password, fullName, phone?, city?, kvkkConsent, role?, expertTitle?, institution?, licenseNumber?, bio?, specializations?[]}` → AuthResponse
- `POST /refresh` `{refreshToken}` → AuthResponse
- `POST /logout` `{refreshToken}`
- `GET /me` → UserDto (auth gerekir)
- `GET /check-email?email=` → `{available}`
- `POST /forgot-password` `{email}` · `POST /reset-password` `{token, password}`

### UserDto
`id, email, fullName, phone, role, expertTitle, city, institution, licenseNumber, bio, verified, licenseVerified, kvkkConsent, isActive, specializations[], profileImageUrl, createdAt`

## Diğer kilit uç noktalar
- `/api/children` — GET liste, POST, `GET/PUT/DELETE /{id}`
- `/api/experts` — GET liste, `/stats`, `/{id}`, `PUT /profile`
- `/api/appointments` — liste/oluştur; `PATCH /{id}/{cancel|reschedule|confirm|complete|rate}`, `/availability`, `/experts/{expertId}/availability`, `/patients`
- `/api/routines` — `/child/{childId}`, `POST /{routineId}/items`
- `/api/goals` — `/child/{childId}`
- `/api/notes` (gelişim notları) — `/child/{childId}`, `/child/{childId}/recent`
- `/api/knowledge` (makaleler) — `/category/{c}`, `/format/{f}`, `/{id}`, `/my`
- `/api/notifications` — `/paged`, `/unread-count`, `PUT /{id}/read`, `/read-all`
- `/api/chatbot` — `POST /message`, `POST /stream` (SSE, `text/event-stream`)
- `/api/push` — **Web Push (VAPID)**: `/vapid-public-key`, `POST /subscribe`. Mobil FCM için backend'e ayrı cihaz-token uç noktası gerekir (Faz 5).
- WS `/ws` — STOMP; `JwtChannelInterceptor` + `WebSocketAuthInterceptor` ile token doğrulanır.

## Güvenlik notları (SecurityConfig)
- `permitAll`: `/api/auth/**`, `/api/public/**`, `GET /api/upload/**`, `GET /api/forum(/**)`, `/ws/**`, `/actuator/health|info`.
- Diğer her şey `authenticated`. Swagger yalnız ADMIN.
- Auth karar: mobil **backend JWT'yi doğrudan** kullanır (Firebase Auth köprüsü yok). Firebase = push/analytics/crash/config/storage.
