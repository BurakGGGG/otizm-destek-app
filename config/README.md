# Ortam profilleri

`flutter run|build ... --dart-define-from-file=config/<profil>.json`

| Profil | API | Paylaşılan bağlantılar | Durum |
| --- | --- | --- | --- |
| `render.json` (varsayılan) | `otizm-backend.onrender.com` | `otizm-destek-platformu.vercel.app` | Canlı; web PWA da bu backend'i kullanıyor (bundle'da `VITE_API_URL` varsayılanı aynı). |
| `otizmdestek.json` | `otizmdestek.com` | `otizmdestek.com` | Özel alan adı; **DNS'te henüz çözülmüyor**, yayına girince tek bayrakla geçilir. |

Profil verilmezse `lib/core/config/env.dart` içindeki varsayılanlar (render
profiliyle aynı) geçerlidir. Tek bir değeri değiştirmek için klasik
`--dart-define=WEB_BASE_URL=...` da çalışır ve profildeki değeri ezer.

Notlar:
- `API_BASE_URL` hem REST (`/api`) hem STOMP (`/ws`) için kök adrestir.
- `WEB_BASE_URL` acil durum kartı paylaşım bağlantısı (`/acil-profil/:token`)
  ve kullanıcı rehberi videoları (`/kullanici-rehberi?video=NN`) için kullanılır;
  bu iki adres API ile **aynı backend'i** gösteren bir dağıtım olmalıdır.
