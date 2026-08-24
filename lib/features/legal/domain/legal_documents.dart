/// Yasal metinler — web `PublicInfoPage` içeriğiyle **birebir aynı**.
///
/// Bu metinler bağlayıcı hukuki belgelerdir: iki platformda farklı sürüm
/// olmaması için veri olarak tutulur ve çevrilmez (arayüz etiketleri i18n'de).
/// Esaslı bir değişiklikte [kLegalPolicyVersion] artırılmalı ve backend
/// `app.legal.policy-version` ile aynı tutulmalıdır; aksi halde
/// kullanıcılardan yeniden rıza istenmez.
library;

/// Metin sürümü — backend rıza sürümüyle aynı olmalı.
const String kLegalPolicyVersion = '1.1';

/// Son güncelleme tarihi (metinlerin altında gösterilir).
const String kLegalLastUpdated = '27 Temmuz 2026';

/// Metinlerin taslak olduğunu belirten uyarı (web ile aynı).
const String kLegalDraftNotice =
    'Bu sayfa ürün içinde kullanılacak temel metin taslağıdır. Köşeli parantez içindeki alanlar (veri sorumlusunun unvanı ve iletişim bilgileri, standart sözleşme bildirimleri, yetkili mahkeme) doldurulmadan canlıya çıkılmamalıdır; metin hukuk danışmanı ve ilgili sağlık/etik uzmanları tarafından gözden geçirilmelidir.';

/// Belge türü — rota parametresi olarak da kullanılır.
enum LegalDocumentKind { trust, kvkk, privacy, terms, medical }

class LegalSection {
  const LegalSection(this.title, this.paragraphs);

  final String title;
  final List<String> paragraphs;
}

class LegalDocument {
  const LegalDocument({
    required this.kind,
    required this.eyebrow,
    required this.title,
    required this.summary,
    required this.sections,
  });

  final LegalDocumentKind kind;
  final String eyebrow;
  final String title;
  final String summary;
  final List<LegalSection> sections;
}

const Map<LegalDocumentKind, LegalDocument> kLegalDocuments = {
  LegalDocumentKind.trust: LegalDocument(
    kind: LegalDocumentKind.trust,
    eyebrow: 'Şeffaflık ve kullanıcı kontrolü',
    title: 'Güven Merkezi',
    summary:
        'Çocuk ve aile verilerinin kimlerle, hangi amaçla ve ne kadar süreyle paylaşılacağını anlamanız için temel kontrolleri tek yerde açıklıyoruz.',
    sections: [
      LegalSection('Erişim nasıl çalışır?', [
        'Aile, uzman ve yönetici rolleri ayrı yetkilere sahiptir. Bir uzman yalnızca bağlantı ve paylaşım izni verilen danışan bilgilerine erişebilir.',
        'Mevcut paylaşım izinleri hesap ayarlarından görüntülenebilir; ihtiyaç sona erdiğinde erişim geri alınabilir.',
      ]),
      LegalSection('Uzman doğrulaması', [
        'Uzman başvurularında mesleki bilgiler ve yüklenen belgeler yönetici incelemesine alınır. Onay durumu profil üzerinde görünür; doğrulanmamış hesaplar klinik yetki gerektiren araçlara erişemez.',
      ]),
      LegalSection('Veri güvenliği', [
        'Hesap erişimi kimlik doğrulama ve rol tabanlı yetkilendirmeyle korunur. Hassas alanlar uygulama seviyesinde şifreleme, aktarım sırasında ise güvenli bağlantı kullanacak şekilde tasarlanmıştır.',
        'Güvenlik mutlak bir garanti değildir; şüpheli hesap hareketleri ve güvenlik sorunları destek kanalı üzerinden bildirilmelidir.',
      ]),
      LegalSection('Veri dışa aktarma ve silme', [
        'Kullanıcılar Ayarlar alanından hesap verilerinin dışa aktarılmasını veya hesabın silinmesini talep edebilir. Yasal saklama zorunluluğu bulunmayan veriler silinir ya da anonimleştirilir.',
      ]),
      LegalSection('Yapay zekâ ve tıbbi sınır', [
        'Yapay zekâ destekli özetler yalnızca kayıtları düzenlemeye yardımcı olur; tanı koymaz, tedavi planlamaz ve sağlık profesyonelinin kararının yerine geçmez.',
      ]),
      LegalSection('Destek ve başvuru', [
        'Gizlilik, erişim veya hesapla ilgili talepler giriş yaptıktan sonra Yardım Merkezi ve Ayarlar alanından iletilebilir. Acil sağlık durumlarında platform destek kanalı yerine resmi acil yardım hattı kullanılmalıdır.',
      ]),
    ],
  ),
  LegalDocumentKind.kvkk: LegalDocument(
    kind: LegalDocumentKind.kvkk,
    eyebrow: 'KVKK ve açık rıza',
    title: 'KVKK Aydınlatma Metni',
    summary:
        'Bu metin, 6698 sayılı Kişisel Verilerin Korunması Kanunu (KVKK) uyarınca platformda işlenen kişisel veriler hakkında kullanıcıları bilgilendirmek için hazırlanmıştır.',
    sections: [
      LegalSection('Veri sorumlusu', [
        '[Şirket/kurum unvanı ve iletişim bilgileri buraya eklenecektir.] Veri sorumlusu, işbu platform üzerinden sunulan hizmetin işleteni olan tüzel kişidir.',
      ]),
      LegalSection('Hangi veriler işlenir?', [
        'Kimlik ve iletişim bilgileri (ad soyad, e-posta, telefon), hesap ve giriş bilgileri, çocuk profili (doğum tarihi, cinsiyet, tanı/gelişim bilgileri), gelişim ve davranış notları, ilaç ve uyku takip kayıtları, randevu ve uzman iletişim kayıtları, mesajlaşma içerikleri, bildirim tercihleri, cihaz/push token bilgileri ve platform kullanım (log) kayıtları işlenebilir.',
        'Çocuğa ait sağlık, gelişim ve davranış verileri KVKK md. 6 kapsamında özel nitelikli kişisel veri sayılır; bu veriler yalnızca açık rıza alınarak ve hizmetin gerektirdiği ölçüde işlenir.',
      ]),
      LegalSection('İşleme amacı ve hukuki sebep', [
        'Veriler; hesap oluşturma ve kimlik doğrulama, çocuğun gelişim takibi, uzman-aile iletişim akışının kurulması, randevu ve tedavi planı yönetimi, platform güvenliğinin sağlanması, bildirim gönderimi, destek taleplerinin yanıtlanması ve yasal yükümlülüklerin yerine getirilmesi amacıyla işlenir.',
        'İşleme faaliyeti; KVKK md. 5/2 kapsamında sözleşmenin kurulması/ifası, hukuki yükümlülük ve meşru menfaat hukuki sebeplerine, özel nitelikli veriler için ise md. 6 kapsamında açık rızaya dayanır.',
      ]),
      LegalSection('Açık rızaya bağlı işlemeler', [
        'Aşağıdaki işlemler yalnızca ayrıca açık rıza verdiğinizde gerçekleşir; rıza vermemeniz hâlinde platformun geri kalanını kullanmaya devam edebilirsiniz:',
        '1) Yapay zekâ analizi: Çocuğunuzun gelişim, davranış ve sağlık kayıtları özet ve analiz üretilmesi için yapay zekâ sağlayıcısına aktarılır. Rıza verilmediğinde asistan ve analiz özellikleri çocuğa ait hiçbir veri almadan çalışır.',
        '2) Acil durum kartı paylaşımı: Kart, yalnızca sizin oluşturduğunuz süreli bağlantıyla üçüncü kişilere gösterilir. Bağlantıyı dilediğiniz an kapatabilirsiniz; kapattığınızda mevcut bağlantı da geçersiz olur.',
        '3) Benzer aile eşleştirmesi ve bilgilendirme e-postaları.',
        'Verdiğiniz ve geri aldığınız her rıza, tarihi ve hangi metin sürümüne verildiği ile birlikte kayıt altına alınır; bu kayıtları Ayarlar > KVKK ve Gizlilik bölümünden görüntüleyebilirsiniz.',
      ]),
      LegalSection('Aktarım ve yurt dışına aktarım', [
        'Kişisel veriler; kullanıcının yetki verdiği uzmanlar, barındırma/altyapı sağlayıcıları ve aşağıda sayılan servis sağlayıcılar ile yalnızca hizmetin gerektirdiği ölçüde ve kanunen yetkili kamu kurum ve kuruluşlarıyla paylaşılabilir.',
        'Yurt dışında konumlanan sağlayıcılar: yapay zekâ analizi ve asistan özellikleri için Google (Gemini API, ABD — yalnızca açık rıza verdiyseniz); mobil bildirimler için Google Firebase Cloud Messaging (ABD); yüklenen dosyaların saklanması için S3 uyumlu nesne depolama sağlayıcısı; bot koruması için Cloudflare Turnstile. Bu aktarımlar KVKK md. 9 kapsamındadır ve açık rızaya ya da Kurul tarafından yayımlanan standart sözleşmeye dayanılarak yapılır.',
        '[Veri sorumlusunun hangi sağlayıcılarla standart sözleşme imzaladığı, sözleşmelerin Kurul’a bildirim tarihleri ve sunucuların bulunduğu ülkeler hukuk danışmanınca teyit edilip bu bölümde güncellenmelidir.]',
      ]),
      LegalSection('Saklama ve imha süresi', [
        'Hesap verileri, hesabınız aktif olduğu sürece saklanır. Hesabınızı sildiğinizde profil, çocuk kayıtları ve yüklediğiniz dosyalar silinir; yasal saklama zorunluluğu bulunanlar süresi dolana kadar tutulur.',
        'Periyodik imha uygulanan süreler: denetim/işlem kayıtları 1 yıl, bildirimler 6 ay, sonuçlanmış KVKK başvuruları 3 yıl (ispat yükümlülüğü nedeniyle), e-posta doğrulaması yapılmamış hesaplar 30 gün, süresi dolan acil durum kartı paylaşım bağlantıları anında geçersiz kılınır.',
        'İmha işlemleri günlük çalışan otomatik bir görevle yürütülür; süresi dolan kayıtlar elle müdahale gerekmeden silinir.',
      ]),
      LegalSection('Haklarınız ve başvuru', [
        'KVKK md. 11 uyarınca; verilerinizin işlenip işlenmediğini öğrenme, işlenmişse buna ilişkin bilgi talep etme, işlenme amacına uygun kullanılıp kullanılmadığını öğrenme, yurt içi/yurt dışı aktarıldığı üçüncü kişileri bilme, eksik/yanlış işlenmişse düzeltilmesini isteme, silinmesini/yok edilmesini isteme, düzeltme-silme işlemlerinin aktarılan üçüncü kişilere bildirilmesini isteme, otomatik sistemlerle analiz sonucu aleyhinize bir sonucun ortaya çıkmasına itiraz etme ve zarara uğramanız halinde zararın giderilmesini talep etme haklarına sahipsiniz.',
        'Başvurularınızı Ayarlar > KVKK ve Gizlilik bölümündeki başvuru formundan iletebilirsiniz. Başvurular KVKK md. 13/2 uyarınca en geç otuz gün içinde sonuçlandırılır; başvurunuzun durumunu aynı ekrandan izleyebilirsiniz.',
        'Verilerinizin tamamını makine tarafından okunabilir bir dosya olarak Ayarlar > Verilerimi İndir bağlantısından dışa aktarabilir, hesabınızı aynı ekrandan silebilirsiniz.',
      ]),
    ],
  ),
  LegalDocumentKind.privacy: LegalDocument(
    kind: LegalDocumentKind.privacy,
    eyebrow: 'Gizlilik',
    title: 'Gizlilik Politikası',
    summary:
        'Bu politika, platformun kullanıcı ve çocuk mahremiyetini korumak için benimsediği temel yaklaşımı açıklar.',
    sections: [
      LegalSection('Veri minimizasyonu', [
        'Platform yalnızca hizmeti sunmak, güvenliği sağlamak ve kullanıcı deneyimini iyileştirmek için gerekli verileri toplamayı hedefler; amacı aşan veri toplanmaz.',
      ]),
      LegalSection('Paylaşım ve erişim', [
        'Çocuk ve aile verileri, kullanıcının yetki verdiği uzmanlar veya kanunen yetkili kurumlar dışında üçüncü kişilerle paylaşılmaz.',
        'Uzman, admin ve aile rolleri birbirinden ayrı, en az yetki ilkesine dayanan erişim sınırlarına sahiptir; adminler yalnızca platformun işletilmesi için gerekli ölçüde veriye erişebilir.',
      ]),
      LegalSection('Üçüncü taraf servisler', [
        'Platform; barındırma, e-posta gönderimi, push bildirim, dosya saklama, bot koruması ve yapay zekâ destekli içerik/öneri özellikleri için üçüncü taraf servis sağlayıcılardan yararlanır. Bu servislere yalnızca ilgili özelliğin çalışması için gerekli veri aktarılır.',
        'Güncel liste: Google Gemini (yapay zekâ analizi — yalnızca açık rıza verildiğinde), Google Firebase Cloud Messaging (mobil bildirim), SMTP e-posta sağlayıcısı (doğrulama ve bildirim e-postaları), S3 uyumlu nesne depolama (yüklenen dosyalar), Cloudflare Turnstile (bot koruması). Servis sağlayıcı değişikliklerinde bu liste güncellenir.',
        'Yapay zekâ rızası verilmediğinde çocuğa ait hiçbir gelişim, sağlık veya davranış verisi yapay zekâ sağlayıcısına gönderilmez; bu kısıt uygulama seviyesinde zorunlu tutulur.',
      ]),
      LegalSection('Çerezler ve benzer teknolojiler', [
        'Platform yalnızca zorunlu çerez ve yerel depolama kullanır: oturumunuzun açık kalması (kimlik doğrulama jetonu ve yenileme çerezi), güvenlik kontrolleri (bot koruması) ve tercihleriniz (erişilebilirlik ayarları, gösterilen bilgilendirmeler).',
        'Reklam, profilleme veya üçüncü taraf izleme çerezi kullanılmaz; bu nedenle zorunlu çerezler için ayrıca açık rıza aranmaz, yalnızca bilgilendirme yapılır.',
        'Tarayıcınızdan çerezleri engelleyebilirsiniz; ancak oturum çerezleri engellendiğinde giriş yapılamaz.',
      ]),
      LegalSection('Güvenlik önlemleri', [
        'Hesap erişimi kimlik doğrulama ile korunur, veriler yetkilendirme kontrolleriyle sınırlandırılır ve iletişim şifreli bağlantılar üzerinden yapılır. Buna rağmen internet üzerinden hiçbir sistemin mutlak güvenliği garanti edilemez.',
      ]),
      LegalSection('Saklama ve silme', [
        'Veriler, hizmetin gerektirdiği süre boyunca saklanır. Kullanıcı talebi veya yasal gereklilik durumunda silme ya da anonimleştirme süreci işletilir.',
        'Süresi dolan kayıtlar günlük çalışan otomatik bir imha göreviyle silinir. Ayrıntılı süreler KVKK Aydınlatma Metni’nin "Saklama ve imha süresi" bölümünde listelenmiştir.',
      ]),
      LegalSection('Politika güncellemeleri', [
        'Bu politika, platformdaki değişikliklere veya mevzuat güncellemelerine bağlı olarak revize edilebilir; önemli değişiklikler kullanıcılara bildirilir.',
      ]),
    ],
  ),
  LegalDocumentKind.terms: LegalDocument(
    kind: LegalDocumentKind.terms,
    eyebrow: 'Kullanım koşulları',
    title: 'Kullanım Şartları',
    summary:
        'Platformu kullanırken ailelerin, uzmanların ve yöneticilerin uyması beklenen temel kuralları özetler.',
    sections: [
      LegalSection('Hizmetin kapsamı', [
        'Otizm Destek; takip, planlama, iletişim, bilgi bankası ve topluluk özellikleri sunan yardımcı bir dijital platformdur.',
        'Platform, tanı koymaz, tedavi sağlamaz ve tek başına tedavi kararı vermez; sağlık profesyonellerinin yerini almaz.',
      ]),
      LegalSection('Hesap ve kullanıcı sorumlulukları', [
        'Kullanıcılar paylaştıkları bilgilerin doğruluğundan, hesap güvenliğinden (şifre gizliliği dahil) ve topluluk kurallarına uygun davranmaktan sorumludur.',
        'Uzman hesapları mesleki bilgilerini doğru sunmalı ve gerekli durumlarda platformun doğrulama süreçlerine tabi olmalıdır. Yanlış/yanıltıcı bilgi verilmesi hesabın askıya alınmasına veya kapatılmasına yol açabilir.',
      ]),
      LegalSection('Topluluk ve içerik kuralları', [
        'Hakaret, ayrımcılık, kişileri hedef gösteren paylaşımlar, yanıltıcı tıbbi iddialar ve gizlilik ihlali oluşturan içerikler bildirim üzerine veya doğrudan kaldırılabilir; tekrarlanan ihlallerde hesap kısıtlanabilir.',
        'Kullanıcılar, paylaştıkları içerikler üzerindeki fikri mülkiyet haklarını korurken, platforma bu içerikleri hizmetin sunulması amacıyla barındırma ve gösterme hakkı tanır.',
      ]),
      LegalSection('Hesap askıya alma ve fesih', [
        'Platform; kullanım şartlarının ihlali, güvenlik riski veya yasal zorunluluk hâllerinde bir hesabı askıya alabilir veya kapatabilir. Kullanıcılar da hesaplarını dilediği zaman Ayarlar üzerinden kapatma talebinde bulunabilir.',
      ]),
      LegalSection('Sorumluluğun sınırlandırılması', [
        'Platform üzerinden sunulan bilgi, hatırlatıcı ve takip araçları destekleyici niteliktedir; bunlara dayanarak alınan tıbbi kararlardan platform sorumlu tutulamaz.',
        '[Uygulanacak hukuk, yetkili mahkeme/uyuşmazlık çözüm yöntemi ve sorumluluk sınırlarına ilişkin nihai madde metinleri hukuk danışmanınca belirlenip buraya eklenmelidir.]',
      ]),
      LegalSection('Değişiklik hakkı', [
        'Bu kullanım şartları, hizmet kapsamındaki değişikliklere bağlı olarak güncellenebilir; önemli değişiklikler kullanıcılara bildirilir.',
      ]),
    ],
  ),
  LegalDocumentKind.medical: LegalDocument(
    kind: LegalDocumentKind.medical,
    eyebrow: 'Tıbbi güvenlik',
    title: 'Tıbbi Güvenlik Uyarıları',
    summary:
        'Kriz rehberi, ilaç takibi ve tarama alanlarının güvenli kullanımı için bu uyarılar görünür olmalıdır.',
    sections: [
      LegalSection('Doktor veya uzman yerine geçmez', [
        'Platformdaki bilgiler, taramalar, aktiviteler, kriz adımları ve takip kayıtları bilgilendirme ve düzenleme amaçlıdır; tıbbi tavsiye, tanı veya tedavi niteliği taşımaz.',
        'Tanı, tedavi, ilaç başlama, ilaç bırakma veya doz değişikliği kararları yalnızca yetkili sağlık profesyonelleri tarafından verilmelidir.',
      ]),
      LegalSection('Tarama ve yapay zeka destekli içerikler', [
        'Platformdaki tarama araçları ve yapay zeka destekli öneriler/özetler klinik tanı aracı değildir; yalnızca farkındalık ve ön bilgilendirme amaçlıdır. Sonuçlar mutlaka bir uzmanla değerlendirilmelidir.',
      ]),
      LegalSection('Acil durumda', [
        'Kendine zarar verme, başkasına zarar verme, bilinç kaybı, ciddi alerji, solunum güçlüğü, nöbet, şiddetli kriz veya ani kötüleşme durumunda yerel acil yardım hattına başvurun.',
        'Türkiye için acil yardım hattını 112 olarak düşünün. Bulunduğunuz ülkedeki resmi acil numarayı kullanın.',
      ]),
      LegalSection('İlaç ve kriz kayıtları', [
        'İlaç hatırlatıcıları destek amaçlıdır; tek güvenlik mekanizması olarak kullanılmamalıdır. Doz ve program bilgileri kullanıcı tarafından girilir; platform bu bilgilerin tıbbi doğruluğunu denetlemez.',
        'Kriz rehberi genel sakinleştirme ve hazırlık adımları sunar; çocuğun bireysel risk planının veya hekim talimatlarının yerini alamaz.',
      ]),
      LegalSection('Veri doğruluğu', [
        'Takip, günlük ve tarama verilerinin doğruluğundan veriyi giren kullanıcı sorumludur; platform bu verileri klinik olarak doğrulamaz.',
      ]),
    ],
  ),
};
