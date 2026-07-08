///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsTr = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.tr,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <tr>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final Translations$app$tr app = Translations$app$tr.internal(_root);
	late final Translations$common$tr common = Translations$common$tr.internal(_root);
	late final Translations$language$tr language = Translations$language$tr.internal(_root);
	late final Translations$theme$tr theme = Translations$theme$tr.internal(_root);
	late final Translations$roles$tr roles = Translations$roles$tr.internal(_root);
	late final Translations$auth$tr auth = Translations$auth$tr.internal(_root);
	late final Translations$forgotPassword$tr forgotPassword = Translations$forgotPassword$tr.internal(_root);
	late final Translations$resetPassword$tr resetPassword = Translations$resetPassword$tr.internal(_root);
	late final Translations$register$tr register = Translations$register$tr.internal(_root);
	late final Translations$nav$tr nav = Translations$nav$tr.internal(_root);
	late final Translations$chat$tr chat = Translations$chat$tr.internal(_root);
	late final Translations$messages$tr messages = Translations$messages$tr.internal(_root);
	late final Translations$home$tr home = Translations$home$tr.internal(_root);
	late final Translations$specialists$tr specialists = Translations$specialists$tr.internal(_root);
	late final Translations$progress$tr progress = Translations$progress$tr.internal(_root);
	late final Translations$goalForm$tr goalForm = Translations$goalForm$tr.internal(_root);
	late final Translations$noteForm$tr noteForm = Translations$noteForm$tr.internal(_root);
	late final Translations$notifications$tr notifications = Translations$notifications$tr.internal(_root);
	late final Translations$knowledge$tr knowledge = Translations$knowledge$tr.internal(_root);
	late final Translations$appointments$tr appointments = Translations$appointments$tr.internal(_root);
	late final Translations$expertDetail$tr expertDetail = Translations$expertDetail$tr.internal(_root);
	late final Translations$booking$tr booking = Translations$booking$tr.internal(_root);
	late final Translations$routines$tr routines = Translations$routines$tr.internal(_root);
	late final Translations$routineForm$tr routineForm = Translations$routineForm$tr.internal(_root);
	late final Translations$dailyTracker$tr dailyTracker = Translations$dailyTracker$tr.internal(_root);
	late final Translations$analytics$tr analytics = Translations$analytics$tr.internal(_root);
	late final Translations$children$tr children = Translations$children$tr.internal(_root);
	late final Translations$account$tr account = Translations$account$tr.internal(_root);
	late final Translations$help$tr help = Translations$help$tr.internal(_root);
	late final Translations$profile$tr profile = Translations$profile$tr.internal(_root);
	late final Translations$errors$tr errors = Translations$errors$tr.internal(_root);
}

// Path: app
class Translations$app$tr {
	Translations$app$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Otizm Destek'
	String get name => 'Otizm Destek';
}

// Path: common
class Translations$common$tr {
	Translations$common$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Yükleniyor'
	String get loading => 'Yükleniyor';

	/// tr: 'Bu bölüm yakında eklenecek.'
	String get comingSoon => 'Bu bölüm yakında eklenecek.';

	/// tr: 'Tümünü Gör'
	String get seeAll => 'Tümünü Gör';

	/// tr: 'Daha Fazla'
	String get more => 'Daha Fazla';

	/// tr: 'Tekrar Dene'
	String get retry => 'Tekrar Dene';

	/// tr: 'Veriler yüklenemedi.'
	String get loadError => 'Veriler yüklenemedi.';

	List<String> get monthsShort => [
		'Oca',
		'Şub',
		'Mar',
		'Nis',
		'May',
		'Haz',
		'Tem',
		'Ağu',
		'Eyl',
		'Eki',
		'Kas',
		'Ara',
	];
}

// Path: language
class Translations$language$tr {
	Translations$language$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Dil'
	String get title => 'Dil';

	/// tr: 'Türkçe'
	String get turkish => 'Türkçe';

	/// tr: 'English'
	String get english => 'English';
}

// Path: theme
class Translations$theme$tr {
	Translations$theme$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Tema'
	String get title => 'Tema';

	/// tr: 'Sistem'
	String get system => 'Sistem';

	/// tr: 'Açık'
	String get light => 'Açık';

	/// tr: 'Koyu'
	String get dark => 'Koyu';
}

// Path: roles
class Translations$roles$tr {
	Translations$roles$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Veli'
	String get parent => 'Veli';

	/// tr: 'Uzman'
	String get expert => 'Uzman';

	/// tr: 'Yönetici'
	String get admin => 'Yönetici';
}

// Path: auth
class Translations$auth$tr {
	Translations$auth$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Hesabınıza giriş yapın veya yeni bir hesap oluşturun.'
	String get subtitle => 'Hesabınıza giriş yapın veya yeni bir hesap oluşturun.';

	/// tr: 'E-posta Adresi'
	String get emailLabel => 'E-posta Adresi';

	/// tr: 'ornek@eposta.com'
	String get emailHint => 'ornek@eposta.com';

	/// tr: 'Şifre'
	String get passwordLabel => 'Şifre';

	/// tr: '••••••••'
	String get passwordHint => '••••••••';

	/// tr: 'Beni hatırla'
	String get rememberMe => 'Beni hatırla';

	/// tr: 'Şifremi unuttum'
	String get forgotPassword => 'Şifremi unuttum';

	/// tr: 'Giriş Yap'
	String get loginButton => 'Giriş Yap';

	/// tr: 'Hesabınız yok mu?'
	String get noAccount => 'Hesabınız yok mu?';

	/// tr: 'Veli hesabı ile kaydol'
	String get registerParent => 'Veli hesabı ile kaydol';

	/// tr: 'Uzman hesabı ile kaydol'
	String get registerExpert => 'Uzman hesabı ile kaydol';

	/// tr: 'Lütfen e-posta ve şifrenizi girin.'
	String get errorEmptyFields => 'Lütfen e-posta ve şifrenizi girin.';

	/// tr: '$role kayıt ekranı yakında eklenecek.'
	String registerComingSoon({required Object role}) => '${role} kayıt ekranı yakında eklenecek.';
}

// Path: forgotPassword
class Translations$forgotPassword$tr {
	Translations$forgotPassword$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Şifremi Unuttum'
	String get title => 'Şifremi Unuttum';

	/// tr: 'E-posta adresinizi girin; size bir şifre sıfırlama bağlantısı gönderelim.'
	String get subtitle => 'E-posta adresinizi girin; size bir şifre sıfırlama bağlantısı gönderelim.';

	/// tr: 'Sıfırlama Bağlantısı Gönder'
	String get submit => 'Sıfırlama Bağlantısı Gönder';

	/// tr: 'Bağlantı gönderildi'
	String get sentTitle => 'Bağlantı gönderildi';

	/// tr: 'Bu e-postaya kayıtlı bir hesap varsa, şifre sıfırlama bağlantısı gelen kutunuza ulaşacaktır.'
	String get sentBody => 'Bu e-postaya kayıtlı bir hesap varsa, şifre sıfırlama bağlantısı gelen kutunuza ulaşacaktır.';

	/// tr: 'Sıfırlama kodum var'
	String get haveCode => 'Sıfırlama kodum var';

	/// tr: 'Girişe dön'
	String get backToLogin => 'Girişe dön';

	/// tr: 'Lütfen e-posta girin.'
	String get errorEmailRequired => 'Lütfen e-posta girin.';

	/// tr: 'Geçerli bir e-posta girin.'
	String get errorEmailInvalid => 'Geçerli bir e-posta girin.';
}

// Path: resetPassword
class Translations$resetPassword$tr {
	Translations$resetPassword$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Şifre Sıfırla'
	String get title => 'Şifre Sıfırla';

	/// tr: 'E-postadaki sıfırlama kodunu ve yeni şifrenizi girin.'
	String get subtitle => 'E-postadaki sıfırlama kodunu ve yeni şifrenizi girin.';

	/// tr: 'Sıfırlama Kodu'
	String get tokenLabel => 'Sıfırlama Kodu';

	/// tr: 'E-postadaki bağlantıdaki kod'
	String get tokenHint => 'E-postadaki bağlantıdaki kod';

	/// tr: 'Yeni Şifre'
	String get newPasswordLabel => 'Yeni Şifre';

	/// tr: 'Yeni Şifre (Tekrar)'
	String get confirmLabel => 'Yeni Şifre (Tekrar)';

	/// tr: 'Şifreyi Güncelle'
	String get submit => 'Şifreyi Güncelle';

	/// tr: 'Şifreniz güncellendi. Giriş yapabilirsiniz.'
	String get success => 'Şifreniz güncellendi. Giriş yapabilirsiniz.';

	/// tr: 'Lütfen sıfırlama kodunu girin.'
	String get errorTokenRequired => 'Lütfen sıfırlama kodunu girin.';

	/// tr: 'Şifre en az 8 karakter olmalıdır.'
	String get errorPasswordShort => 'Şifre en az 8 karakter olmalıdır.';

	/// tr: 'Şifreler eşleşmiyor.'
	String get errorMismatch => 'Şifreler eşleşmiyor.';
}

// Path: register
class Translations$register$tr {
	Translations$register$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Veli Hesabı Oluştur'
	String get titleParent => 'Veli Hesabı Oluştur';

	/// tr: 'Uzman Hesabı Oluştur'
	String get titleExpert => 'Uzman Hesabı Oluştur';

	/// tr: 'Nasıl kaydolmak istersiniz?'
	String get roleQuestion => 'Nasıl kaydolmak istersiniz?';

	/// tr: 'Ad Soyad'
	String get fullNameLabel => 'Ad Soyad';

	/// tr: 'Adınız ve soyadınız'
	String get fullNameHint => 'Adınız ve soyadınız';

	/// tr: 'Telefon (isteğe bağlı)'
	String get phoneLabel => 'Telefon (isteğe bağlı)';

	/// tr: '05XX XXX XX XX'
	String get phoneHint => '05XX XXX XX XX';

	/// tr: 'Şehir (isteğe bağlı)'
	String get cityLabel => 'Şehir (isteğe bağlı)';

	/// tr: 'Yaşadığınız şehir'
	String get cityHint => 'Yaşadığınız şehir';

	/// tr: 'Uzmanlık Ünvanı'
	String get expertTitleLabel => 'Uzmanlık Ünvanı';

	/// tr: 'Örn. Çocuk Psikoloğu'
	String get expertTitleHint => 'Örn. Çocuk Psikoloğu';

	/// tr: 'Kurum (isteğe bağlı)'
	String get institutionLabel => 'Kurum (isteğe bağlı)';

	/// tr: 'Çalıştığınız kurum'
	String get institutionHint => 'Çalıştığınız kurum';

	/// tr: 'Lisans / Diploma No'
	String get licenseNumberLabel => 'Lisans / Diploma No';

	/// tr: 'Mesleki lisans numaranız'
	String get licenseNumberHint => 'Mesleki lisans numaranız';

	/// tr: 'Hakkında (isteğe bağlı)'
	String get bioLabel => 'Hakkında (isteğe bağlı)';

	/// tr: 'Deneyiminizi kısaca anlatın'
	String get bioHint => 'Deneyiminizi kısaca anlatın';

	/// tr: 'Uzmanlık Alanları (isteğe bağlı)'
	String get specializationsLabel => 'Uzmanlık Alanları (isteğe bağlı)';

	/// tr: 'Virgülle ayırın (Otizm, DEHB)'
	String get specializationsHint => 'Virgülle ayırın (Otizm, DEHB)';

	/// tr: 'KVKK aydınlatma metnini okudum ve onaylıyorum.'
	String get kvkkConsent => 'KVKK aydınlatma metnini okudum ve onaylıyorum.';

	/// tr: 'Kaydol'
	String get submit => 'Kaydol';

	/// tr: 'Zaten hesabınız var mı? Giriş yapın'
	String get haveAccount => 'Zaten hesabınız var mı? Giriş yapın';

	/// tr: 'Lütfen ad soyad girin.'
	String get errorFullNameRequired => 'Lütfen ad soyad girin.';

	/// tr: 'Lütfen e-posta girin.'
	String get errorEmailRequired => 'Lütfen e-posta girin.';

	/// tr: 'Geçerli bir e-posta girin.'
	String get errorEmailInvalid => 'Geçerli bir e-posta girin.';

	/// tr: 'Şifre en az 8 karakter olmalıdır.'
	String get errorPasswordShort => 'Şifre en az 8 karakter olmalıdır.';

	/// tr: 'Lütfen uzmanlık ünvanını girin.'
	String get errorExpertTitleRequired => 'Lütfen uzmanlık ünvanını girin.';

	/// tr: 'Devam etmek için KVKK onayı gereklidir.'
	String get errorKvkkRequired => 'Devam etmek için KVKK onayı gereklidir.';
}

// Path: nav
class Translations$nav$tr {
	Translations$nav$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Ana Sayfa'
	String get home => 'Ana Sayfa';

	/// tr: 'Uzmanlar'
	String get specialists => 'Uzmanlar';

	/// tr: 'Gelişim'
	String get progress => 'Gelişim';

	/// tr: 'Profil'
	String get profile => 'Profil';
}

// Path: chat
class Translations$chat$tr {
	Translations$chat$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'AI Asistan'
	String get title => 'AI Asistan';

	/// tr: 'Merhaba! Otizm ve çocuk gelişimi hakkındaki sorularınızı yanıtlamaya çalışayım.'
	String get greeting => 'Merhaba! Otizm ve çocuk gelişimi hakkındaki sorularınızı yanıtlamaya çalışayım.';

	/// tr: 'Bir soru sorun...'
	String get inputHint => 'Bir soru sorun...';

	/// tr: 'Yanıt alınamadı, lütfen tekrar deneyin.'
	String get errorGeneric => 'Yanıt alınamadı, lütfen tekrar deneyin.';
}

// Path: messages
class Translations$messages$tr {
	Translations$messages$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Mesajlar'
	String get title => 'Mesajlar';

	/// tr: 'Henüz bir konuşmanız yok.'
	String get noConversations => 'Henüz bir konuşmanız yok.';

	/// tr: 'Henüz mesaj yok. İlk mesajı gönderin.'
	String get noMessages => 'Henüz mesaj yok. İlk mesajı gönderin.';

	/// tr: 'Mesaj yazın...'
	String get inputHint => 'Mesaj yazın...';

	/// tr: 'Bağlanıyor...'
	String get connecting => 'Bağlanıyor...';
}

// Path: home
class Translations$home$tr {
	Translations$home$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Bildirimler'
	String get notifications => 'Bildirimler';

	/// tr: 'AI Asistan'
	String get assistant => 'AI Asistan';

	/// tr: 'Mesajlar'
	String get messages => 'Mesajlar';

	/// tr: 'Merhaba, $name'
	String greeting({required Object name}) => 'Merhaba, ${name}';

	/// tr: 'Veli'
	String get greetingFallback => 'Veli';

	/// tr: 'Bugün gelişim için neler yapabiliriz?'
	String get subtitle => 'Bugün gelişim için neler yapabiliriz?';

	/// tr: 'Çocuk Gelişimi'
	String get childProgressTitle => 'Çocuk Gelişimi';

	/// tr: 'Haftalık İlerleme Özeti'
	String get weeklySummary => 'Haftalık İlerleme Özeti';

	/// tr: '%$value Artış'
	String increaseBadge({required Object value}) => '%${value} Artış';

	/// tr: 'Hedefe Kalan: %$value'
	String remainingToGoal({required Object value}) => 'Hedefe Kalan: %${value}';

	/// tr: 'Bilişsel: İyi'
	String get statusCognitiveGood => 'Bilişsel: İyi';

	/// tr: 'İletişim: Gelişiyor'
	String get statusCommunicationImproving => 'İletişim: Gelişiyor';

	/// tr: 'Yaklaşan Randevular'
	String get upcomingAppointments => 'Yaklaşan Randevular';

	/// tr: 'Önerilen Makaleler'
	String get recommendedArticles => 'Önerilen Makaleler';

	/// tr: 'Çocuklarım'
	String get childrenTitle => 'Çocuklarım';

	/// tr: 'Henüz çocuk eklemediniz.'
	String get noChildren => 'Henüz çocuk eklemediniz.';

	/// tr: 'Çocuk Ekle'
	String get addChild => 'Çocuk Ekle';

	/// tr: '$years yaş'
	String ageYears({required Object years}) => '${years} yaş';

	/// tr: 'Yaklaşan randevunuz yok.'
	String get noAppointments => 'Yaklaşan randevunuz yok.';

	/// tr: 'Gösterilecek makale yok.'
	String get noArticles => 'Gösterilecek makale yok.';
}

// Path: specialists
class Translations$specialists$tr {
	Translations$specialists$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Uzman Bulun'
	String get title => 'Uzman Bulun';

	/// tr: 'İsim veya uzmanlık arayın...'
	String get searchHint => 'İsim veya uzmanlık arayın...';

	/// tr: 'Tümü'
	String get filterAll => 'Tümü';

	/// tr: 'Psikolog'
	String get filterPsychologist => 'Psikolog';

	/// tr: 'Özel Eğitim'
	String get filterSpecialEducation => 'Özel Eğitim';

	/// tr: 'Dil ve Konuşma'
	String get filterSpeech => 'Dil ve Konuşma';

	/// tr: 'Aramanıza uygun uzman bulunamadı.'
	String get noResults => 'Aramanıza uygun uzman bulunamadı.';

	/// tr: 'Yeni'
	String get ratingNew => 'Yeni';

	/// tr: '$count değerlendirme'
	String reviews({required Object count}) => '${count} değerlendirme';
}

// Path: progress
class Translations$progress$tr {
	Translations$progress$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Gelişim Takibi'
	String get title => 'Gelişim Takibi';

	/// tr: 'Hedefler ve gelişim notları.'
	String get subtitle => 'Hedefler ve gelişim notları.';

	/// tr: 'Yeni Kayıt Ekle'
	String get addRecord => 'Yeni Kayıt Ekle';

	/// tr: 'Hedefler'
	String get goalsTitle => 'Hedefler';

	/// tr: 'Son Gelişim Notları'
	String get recentNotes => 'Son Gelişim Notları';

	/// tr: 'Henüz hedef eklenmemiş.'
	String get noGoals => 'Henüz hedef eklenmemiş.';

	/// tr: 'Henüz gelişim notu eklenmemiş.'
	String get noNotes => 'Henüz gelişim notu eklenmemiş.';

	/// tr: 'Gelişim takibi için önce bir çocuk ekleyin.'
	String get noChild => 'Gelişim takibi için önce bir çocuk ekleyin.';

	/// tr: '$done / $total'
	String goalProgress({required Object done, required Object total}) => '${done} / ${total}';

	/// tr: 'Hedef Ekle'
	String get addGoal => 'Hedef Ekle';

	/// tr: 'Not Ekle'
	String get addNote => 'Not Ekle';
}

// Path: goalForm
class Translations$goalForm$tr {
	Translations$goalForm$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Hedef Ekle'
	String get title => 'Hedef Ekle';

	/// tr: 'Başlık'
	String get nameLabel => 'Başlık';

	/// tr: 'Örn. Göz teması kurma'
	String get nameHint => 'Örn. Göz teması kurma';

	/// tr: 'Kategori'
	String get categoryLabel => 'Kategori';

	/// tr: 'Hedef Sayısı'
	String get targetLabel => 'Hedef Sayısı';

	/// tr: 'Açıklama (isteğe bağlı)'
	String get descriptionLabel => 'Açıklama (isteğe bağlı)';

	/// tr: 'Hedefle ilgili detay'
	String get descriptionHint => 'Hedefle ilgili detay';

	/// tr: 'Kaydet'
	String get save => 'Kaydet';

	/// tr: 'Lütfen bir başlık girin.'
	String get errorTitle => 'Lütfen bir başlık girin.';

	/// tr: 'Hedef eklendi.'
	String get created => 'Hedef eklendi.';
}

// Path: noteForm
class Translations$noteForm$tr {
	Translations$noteForm$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Not Ekle'
	String get title => 'Not Ekle';

	/// tr: 'Başlık'
	String get nameLabel => 'Başlık';

	/// tr: 'Örn. Bugünkü gelişme'
	String get nameHint => 'Örn. Bugünkü gelişme';

	/// tr: 'İçerik (isteğe bağlı)'
	String get contentLabel => 'İçerik (isteğe bağlı)';

	/// tr: 'Gözlemlerinizi yazın'
	String get contentHint => 'Gözlemlerinizi yazın';

	/// tr: 'Kategori (isteğe bağlı)'
	String get categoryLabel => 'Kategori (isteğe bağlı)';

	/// tr: 'Ruh Hali (isteğe bağlı)'
	String get moodLabel => 'Ruh Hali (isteğe bağlı)';

	/// tr: 'Mutlu'
	String get moodHappy => 'Mutlu';

	/// tr: 'Sakin'
	String get moodCalm => 'Sakin';

	/// tr: 'Üzgün'
	String get moodSad => 'Üzgün';

	/// tr: 'Tarih'
	String get dateLabel => 'Tarih';

	/// tr: 'Kaydet'
	String get save => 'Kaydet';

	/// tr: 'Lütfen bir başlık girin.'
	String get errorTitle => 'Lütfen bir başlık girin.';

	/// tr: 'Not eklendi.'
	String get created => 'Not eklendi.';
}

// Path: notifications
class Translations$notifications$tr {
	Translations$notifications$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Göster'
	String get show => 'Göster';

	/// tr: 'Bildirimler'
	String get title => 'Bildirimler';

	/// tr: 'Henüz bildiriminiz yok.'
	String get empty => 'Henüz bildiriminiz yok.';

	/// tr: 'Tümünü okundu işaretle'
	String get markAllRead => 'Tümünü okundu işaretle';

	/// tr: '$day $month · $time'
	String dateLine({required Object day, required Object month, required Object time}) => '${day} ${month} · ${time}';
}

// Path: knowledge
class Translations$knowledge$tr {
	Translations$knowledge$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Bilgi Bankası'
	String get title => 'Bilgi Bankası';

	/// tr: 'Henüz makale eklenmemiş.'
	String get empty => 'Henüz makale eklenmemiş.';

	/// tr: 'Bu filtreye uygun içerik yok.'
	String get noResults => 'Bu filtreye uygun içerik yok.';

	/// tr: 'Tümü'
	String get filterAll => 'Tümü';

	/// tr: 'Makale'
	String get formatArticle => 'Makale';

	/// tr: 'Video'
	String get formatVideo => 'Video';

	/// tr: 'Podcast'
	String get formatPodcast => 'Podcast';

	/// tr: '$count görüntülenme'
	String views({required Object count}) => '${count} görüntülenme';

	/// tr: '$day $month $year'
	String dateLine({required Object day, required Object month, required Object year}) => '${day} ${month} ${year}';

	/// tr: 'Video bağlantısı'
	String get videoLink => 'Video bağlantısı';

	/// tr: 'Podcast bağlantısı'
	String get podcastLink => 'Podcast bağlantısı';
}

// Path: appointments
class Translations$appointments$tr {
	Translations$appointments$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Randevular'
	String get title => 'Randevular';

	/// tr: 'Henüz randevunuz yok.'
	String get empty => 'Henüz randevunuz yok.';

	/// tr: 'Yaklaşan'
	String get upcoming => 'Yaklaşan';

	/// tr: 'Geçmiş'
	String get past => 'Geçmiş';

	/// tr: 'Onay Bekliyor'
	String get statusPending => 'Onay Bekliyor';

	/// tr: 'Onaylandı'
	String get statusConfirmed => 'Onaylandı';

	/// tr: 'Tamamlandı'
	String get statusCompleted => 'Tamamlandı';

	/// tr: 'İptal Edildi'
	String get statusCancelled => 'İptal Edildi';

	/// tr: 'Online Görüşme'
	String get typeOnline => 'Online Görüşme';

	/// tr: 'Yüz Yüze'
	String get typeFaceToFace => 'Yüz Yüze';

	/// tr: 'Çocuk: $name'
	String withChild({required Object name}) => 'Çocuk: ${name}';

	/// tr: '$day $month $year · $time'
	String dateLine({required Object day, required Object month, required Object year, required Object time}) => '${day} ${month} ${year} · ${time}';

	/// tr: 'İptal Et'
	String get cancel => 'İptal Et';

	/// tr: 'Onayla'
	String get confirm => 'Onayla';

	/// tr: 'Tamamla'
	String get complete => 'Tamamla';

	/// tr: 'Görüşmeye Katıl'
	String get joinMeeting => 'Görüşmeye Katıl';

	/// tr: 'Randevuyu İptal Et'
	String get cancelTitle => 'Randevuyu İptal Et';

	/// tr: 'Bu randevuyu iptal etmek istediğinize emin misiniz?'
	String get cancelConfirm => 'Bu randevuyu iptal etmek istediğinize emin misiniz?';

	/// tr: 'İptal nedeni (isteğe bağlı)'
	String get cancelReasonLabel => 'İptal nedeni (isteğe bağlı)';

	/// tr: 'İptal nedeni: $reason'
	String cancelReasonShown({required Object reason}) => 'İptal nedeni: ${reason}';

	/// tr: 'Vazgeç'
	String get keepIt => 'Vazgeç';

	/// tr: 'Randevu iptal edildi.'
	String get cancelled => 'Randevu iptal edildi.';

	/// tr: 'Randevu onaylandı.'
	String get confirmed => 'Randevu onaylandı.';

	/// tr: 'Randevu tamamlandı olarak işaretlendi.'
	String get completed => 'Randevu tamamlandı olarak işaretlendi.';
}

// Path: expertDetail
class Translations$expertDetail$tr {
	Translations$expertDetail$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Randevu Al'
	String get bookAppointment => 'Randevu Al';

	/// tr: 'Mesaj Gönder'
	String get sendMessage => 'Mesaj Gönder';

	/// tr: 'Uzmanlık Alanları'
	String get specializationsTitle => 'Uzmanlık Alanları';

	/// tr: '$count makale'
	String articleCount({required Object count}) => '${count} makale';

	/// tr: 'Bu uzman şu an randevu kabul etmiyor.'
	String get notAcceptingPatients => 'Bu uzman şu an randevu kabul etmiyor.';
}

// Path: booking
class Translations$booking$tr {
	Translations$booking$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Randevu Al'
	String get title => 'Randevu Al';

	/// tr: 'Çocuk'
	String get childLabel => 'Çocuk';

	/// tr: 'Randevu almak için önce bir çocuk ekleyin.'
	String get noChild => 'Randevu almak için önce bir çocuk ekleyin.';

	/// tr: 'Randevu Tipi'
	String get typeLabel => 'Randevu Tipi';

	/// tr: 'Tarih'
	String get dateLabel => 'Tarih';

	/// tr: 'Tarih seçin'
	String get selectDate => 'Tarih seçin';

	/// tr: '$day $month $year'
	String dateValue({required Object day, required Object month, required Object year}) => '${day} ${month} ${year}';

	/// tr: 'Saat'
	String get timeLabel => 'Saat';

	/// tr: 'Uygun saatleri görmek için önce tarih seçin.'
	String get selectDateFirst => 'Uygun saatleri görmek için önce tarih seçin.';

	/// tr: 'Bu gün için uygun saat yok.'
	String get noSlots => 'Bu gün için uygun saat yok.';

	/// tr: 'Not (isteğe bağlı)'
	String get notesLabel => 'Not (isteğe bağlı)';

	/// tr: 'Uzmana iletmek istediğiniz not'
	String get notesHint => 'Uzmana iletmek istediğiniz not';

	/// tr: 'Randevuyu Onayla'
	String get confirm => 'Randevuyu Onayla';

	/// tr: 'Randevu oluşturuldu.'
	String get created => 'Randevu oluşturuldu.';

	/// tr: 'Lütfen bir çocuk seçin.'
	String get errorSelectChild => 'Lütfen bir çocuk seçin.';

	/// tr: 'Lütfen bir saat seçin.'
	String get errorSelectTime => 'Lütfen bir saat seçin.';
}

// Path: routines
class Translations$routines$tr {
	Translations$routines$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Rutinler'
	String get title => 'Rutinler';

	/// tr: 'Bu çocuk için henüz rutin yok.'
	String get empty => 'Bu çocuk için henüz rutin yok.';

	/// tr: 'Rutin oluşturmak için önce bir çocuk ekleyin.'
	String get noChild => 'Rutin oluşturmak için önce bir çocuk ekleyin.';

	/// tr: 'Rutin Ekle'
	String get add => 'Rutin Ekle';

	/// tr: 'Adım Ekle'
	String get addItem => 'Adım Ekle';

	/// tr: 'Henüz adım eklenmemiş.'
	String get noItems => 'Henüz adım eklenmemiş.';

	/// tr: 'Rutini Sil'
	String get deleteRoutineTitle => 'Rutini Sil';

	/// tr: '$name rutinini silmek istediğinize emin misiniz?'
	String deleteRoutineConfirm({required Object name}) => '${name} rutinini silmek istediğinize emin misiniz?';

	/// tr: 'Sil'
	String get delete => 'Sil';

	/// tr: 'İptal'
	String get cancel => 'İptal';

	/// tr: 'Rutin eklendi.'
	String get created => 'Rutin eklendi.';

	/// tr: 'Adım eklendi.'
	String get itemAdded => 'Adım eklendi.';

	/// tr: 'Rutin silindi.'
	String get deleted => 'Rutin silindi.';

	/// tr: 'Adım Başlığı'
	String get itemTitleLabel => 'Adım Başlığı';

	/// tr: 'Örn. Dişleri fırçala'
	String get itemTitleHint => 'Örn. Dişleri fırçala';

	/// tr: 'Saat (isteğe bağlı)'
	String get itemTimeLabel => 'Saat (isteğe bağlı)';

	/// tr: 'Saat seç'
	String get selectTime => 'Saat seç';

	/// tr: 'İkon'
	String get itemIconLabel => 'İkon';

	/// tr: 'Ekle'
	String get itemSave => 'Ekle';

	/// tr: 'Lütfen adım başlığı girin.'
	String get errorItemTitle => 'Lütfen adım başlığı girin.';
}

// Path: routineForm
class Translations$routineForm$tr {
	Translations$routineForm$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Rutin Ekle'
	String get title => 'Rutin Ekle';

	/// tr: 'Rutin Adı'
	String get nameLabel => 'Rutin Adı';

	/// tr: 'Örn. Sabah Rutini'
	String get nameHint => 'Örn. Sabah Rutini';

	/// tr: 'Açıklama (isteğe bağlı)'
	String get descriptionLabel => 'Açıklama (isteğe bağlı)';

	/// tr: 'Bu rutin ne için?'
	String get descriptionHint => 'Bu rutin ne için?';

	/// tr: 'Kaydet'
	String get save => 'Kaydet';

	/// tr: 'Lütfen bir rutin adı girin.'
	String get errorName => 'Lütfen bir rutin adı girin.';
}

// Path: dailyTracker
class Translations$dailyTracker$tr {
	Translations$dailyTracker$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Günlük Takip'
	String get title => 'Günlük Takip';

	/// tr: 'Bugün nasıldı?'
	String get todayTitle => 'Bugün nasıldı?';

	/// tr: 'Bugün'
	String get today => 'Bugün';

	/// tr: 'Çok Kötü'
	String get mood1 => 'Çok Kötü';

	/// tr: 'Kötü'
	String get mood2 => 'Kötü';

	/// tr: 'Orta'
	String get mood3 => 'Orta';

	/// tr: 'İyi'
	String get mood4 => 'İyi';

	/// tr: 'Harika'
	String get mood5 => 'Harika';

	/// tr: 'Olası tetikleyiciler (isteğe bağlı)'
	String get triggersLabel => 'Olası tetikleyiciler (isteğe bağlı)';

	/// tr: 'Not (isteğe bağlı)'
	String get notesLabel => 'Not (isteğe bağlı)';

	/// tr: 'Bugüne dair gözlemleriniz'
	String get notesHint => 'Bugüne dair gözlemleriniz';

	/// tr: 'Kaydet'
	String get save => 'Kaydet';

	/// tr: 'Güncelle'
	String get update => 'Güncelle';

	/// tr: 'Ruh hali kaydedildi.'
	String get saved => 'Ruh hali kaydedildi.';

	/// tr: 'Geçmiş Kayıtlar'
	String get historyTitle => 'Geçmiş Kayıtlar';

	/// tr: 'Henüz kayıt yok. İlk kaydı bugün ekleyin.'
	String get empty => 'Henüz kayıt yok. İlk kaydı bugün ekleyin.';

	/// tr: 'Günlük takip için önce bir çocuk ekleyin.'
	String get noChild => 'Günlük takip için önce bir çocuk ekleyin.';

	/// tr: 'Kaydı Sil'
	String get deleteTitle => 'Kaydı Sil';

	/// tr: '$date tarihli kaydı silmek istediğinize emin misiniz?'
	String deleteConfirm({required Object date}) => '${date} tarihli kaydı silmek istediğinize emin misiniz?';

	/// tr: 'Sil'
	String get delete => 'Sil';

	/// tr: 'İptal'
	String get cancel => 'İptal';

	/// tr: 'Kayıt silindi.'
	String get deleted => 'Kayıt silindi.';

	/// tr: 'Lütfen bir ruh hali seçin.'
	String get errorSelectMood => 'Lütfen bir ruh hali seçin.';

	/// tr: '$day $month $year'
	String dateLine({required Object day, required Object month, required Object year}) => '${day} ${month} ${year}';
}

// Path: analytics
class Translations$analytics$tr {
	Translations$analytics$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Gelişim Paneli'
	String get title => 'Gelişim Paneli';

	/// tr: 'Son 6 ayın gelişim eğilimleri.'
	String get subtitle => 'Son 6 ayın gelişim eğilimleri.';

	/// tr: 'Kilometre Taşları'
	String get milestones => 'Kilometre Taşları';

	/// tr: 'aylık kazanım sayısı'
	String get milestonesUnit => 'aylık kazanım sayısı';

	/// tr: 'Ruh Hali Ortalaması'
	String get mood => 'Ruh Hali Ortalaması';

	/// tr: '1-5 arası aylık ortalama'
	String get moodUnit => '1-5 arası aylık ortalama';

	/// tr: 'Ortalama Uyku'
	String get sleep => 'Ortalama Uyku';

	/// tr: 'gecelik saat (aylık ortalama)'
	String get sleepUnit => 'gecelik saat (aylık ortalama)';

	/// tr: 'Davranış Kayıtları'
	String get behavior => 'Davranış Kayıtları';

	/// tr: 'aylık kayıt sayısı'
	String get behaviorUnit => 'aylık kayıt sayısı';

	/// tr: 'Bu aralıkta henüz veri yok.'
	String get noData => 'Bu aralıkta henüz veri yok.';

	/// tr: 'Gelişim paneli için önce bir çocuk ekleyin.'
	String get noChild => 'Gelişim paneli için önce bir çocuk ekleyin.';
}

// Path: children
class Translations$children$tr {
	Translations$children$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Çocuklarım'
	String get title => 'Çocuklarım';

	/// tr: 'Çocuk Ekle'
	String get addTitle => 'Çocuk Ekle';

	/// tr: 'Çocuğu Düzenle'
	String get editTitle => 'Çocuğu Düzenle';

	/// tr: 'Henüz çocuk eklemediniz.'
	String get empty => 'Henüz çocuk eklemediniz.';

	/// tr: 'Çocuk Ekle'
	String get add => 'Çocuk Ekle';

	/// tr: 'Ad Soyad'
	String get nameLabel => 'Ad Soyad';

	/// tr: 'Çocuğun adı'
	String get nameHint => 'Çocuğun adı';

	/// tr: 'Doğum Tarihi (isteğe bağlı)'
	String get birthDateLabel => 'Doğum Tarihi (isteğe bağlı)';

	/// tr: 'Tarih seçin'
	String get birthDateSelect => 'Tarih seçin';

	/// tr: 'Cinsiyet (isteğe bağlı)'
	String get genderLabel => 'Cinsiyet (isteğe bağlı)';

	/// tr: 'Erkek'
	String get genderMale => 'Erkek';

	/// tr: 'Kız'
	String get genderFemale => 'Kız';

	/// tr: 'Tanı Bilgisi (isteğe bağlı)'
	String get diagnosisLabel => 'Tanı Bilgisi (isteğe bağlı)';

	/// tr: 'Varsa tanı bilgisi'
	String get diagnosisHint => 'Varsa tanı bilgisi';

	/// tr: 'Eğitim Programı (isteğe bağlı)'
	String get educationLabel => 'Eğitim Programı (isteğe bağlı)';

	/// tr: 'Devam ettiği eğitim programı'
	String get educationHint => 'Devam ettiği eğitim programı';

	/// tr: 'Terapiler (isteğe bağlı)'
	String get therapiesLabel => 'Terapiler (isteğe bağlı)';

	/// tr: 'Aldığı terapiler'
	String get therapiesHint => 'Aldığı terapiler';

	/// tr: '$years yaş'
	String ageYears({required Object years}) => '${years} yaş';

	/// tr: 'Kaydet'
	String get save => 'Kaydet';

	/// tr: 'İptal'
	String get cancel => 'İptal';

	/// tr: 'Sil'
	String get delete => 'Sil';

	/// tr: 'Çocuğu Sil'
	String get deleteTitle => 'Çocuğu Sil';

	/// tr: '$name profilini silmek istediğinize emin misiniz?'
	String deleteConfirm({required Object name}) => '${name} profilini silmek istediğinize emin misiniz?';

	/// tr: 'Lütfen çocuğun adını girin.'
	String get errorNameRequired => 'Lütfen çocuğun adını girin.';

	/// tr: 'Çocuk profili oluşturuldu.'
	String get created => 'Çocuk profili oluşturuldu.';

	/// tr: 'Çocuk profili güncellendi.'
	String get updated => 'Çocuk profili güncellendi.';

	/// tr: 'Çocuk profili silindi.'
	String get deleted => 'Çocuk profili silindi.';
}

// Path: account
class Translations$account$tr {
	Translations$account$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Hesap Bilgileri'
	String get title => 'Hesap Bilgileri';

	/// tr: 'E-posta'
	String get emailLabel => 'E-posta';

	/// tr: 'Ad Soyad'
	String get fullNameLabel => 'Ad Soyad';

	/// tr: 'Telefon'
	String get phoneLabel => 'Telefon';

	/// tr: '05XX XXX XX XX'
	String get phoneHint => '05XX XXX XX XX';

	/// tr: 'Şehir'
	String get cityLabel => 'Şehir';

	/// tr: 'Uzmanlık Ünvanı'
	String get expertTitleLabel => 'Uzmanlık Ünvanı';

	/// tr: 'Kurum'
	String get institutionLabel => 'Kurum';

	/// tr: 'Lisans / Diploma No'
	String get licenseNumberLabel => 'Lisans / Diploma No';

	/// tr: 'Hakkında'
	String get bioLabel => 'Hakkında';

	/// tr: 'Deneyiminizi kısaca anlatın'
	String get bioHint => 'Deneyiminizi kısaca anlatın';

	/// tr: 'Kaydet'
	String get save => 'Kaydet';

	/// tr: 'Profil güncellendi.'
	String get saved => 'Profil güncellendi.';

	/// tr: 'Ad soyad en az 2 karakter olmalıdır.'
	String get errorFullName => 'Ad soyad en az 2 karakter olmalıdır.';
}

// Path: help
class Translations$help$tr {
	Translations$help$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Yardım & Hakkında'
	String get title => 'Yardım & Hakkında';

	/// tr: 'Otizm Destek Hakkında'
	String get aboutTitle => 'Otizm Destek Hakkında';

	/// tr: 'Otizm Destek; çocuğunuzun gelişimini takip etmenize, uzmanlarla iletişim kurmanıza ve randevu almanıza yardımcı olan bir mobil uygulamadır.'
	String get aboutBody => 'Otizm Destek; çocuğunuzun gelişimini takip etmenize, uzmanlarla iletişim kurmanıza ve randevu almanıza yardımcı olan bir mobil uygulamadır.';

	/// tr: 'İpuçları'
	String get tipsTitle => 'İpuçları';

	/// tr: 'Çocuklarınızı "Çocuklarım"dan ekleyin; hedef ve gelişim notlarını "Gelişim" sekmesinden takip edin.'
	String get tip1 => 'Çocuklarınızı "Çocuklarım"dan ekleyin; hedef ve gelişim notlarını "Gelişim" sekmesinden takip edin.';

	/// tr: '"Uzmanlar"dan bir uzman seçip randevu alabilir veya mesaj gönderebilirsiniz.'
	String get tip2 => '"Uzmanlar"dan bir uzman seçip randevu alabilir veya mesaj gönderebilirsiniz.';

	/// tr: 'AI Asistan'a otizm ve çocuk gelişimi hakkında sorular sorabilirsiniz.'
	String get tip3 => 'AI Asistan\'a otizm ve çocuk gelişimi hakkında sorular sorabilirsiniz.';

	/// tr: 'İletişim'
	String get contactTitle => 'İletişim';

	/// tr: 'Soru ve önerileriniz için uygulama içinden bize ulaşabilirsiniz.'
	String get contactBody => 'Soru ve önerileriniz için uygulama içinden bize ulaşabilirsiniz.';

	/// tr: 'Sürüm $version'
	String version({required Object version}) => 'Sürüm ${version}';
}

// Path: profile
class Translations$profile$tr {
	Translations$profile$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Kullanıcı'
	String get defaultUser => 'Kullanıcı';

	/// tr: 'Hesap Bilgileri'
	String get accountInfo => 'Hesap Bilgileri';

	/// tr: 'Çocuklarım'
	String get myChildren => 'Çocuklarım';

	/// tr: 'Bildirim Ayarları'
	String get notificationSettings => 'Bildirim Ayarları';

	/// tr: 'Yardım'
	String get help => 'Yardım';

	/// tr: 'Çıkış Yap'
	String get signOut => 'Çıkış Yap';
}

// Path: errors
class Translations$errors$tr {
	Translations$errors$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Sunucuya ulaşılamadı, lütfen tekrar deneyin.'
	String get timeout => 'Sunucuya ulaşılamadı, lütfen tekrar deneyin.';

	/// tr: 'İnternet bağlantısı yok gibi görünüyor.'
	String get noConnection => 'İnternet bağlantısı yok gibi görünüyor.';

	/// tr: 'Bir hata oluştu ($code).'
	String generic({required Object code}) => 'Bir hata oluştu (${code}).';

	/// tr: 'İstek iptal edildi.'
	String get cancelled => 'İstek iptal edildi.';

	/// tr: 'Beklenmeyen bir hata oluştu.'
	String get unexpected => 'Beklenmeyen bir hata oluştu.';

	/// tr: 'Beklenmeyen sunucu yanıtı.'
	String get unexpectedResponse => 'Beklenmeyen sunucu yanıtı.';

	/// tr: 'İşlem başarısız.'
	String get operationFailed => 'İşlem başarısız.';

	/// tr: 'Sunucu yanıtında kullanıcı bilgisi yok.'
	String get noUserInResponse => 'Sunucu yanıtında kullanıcı bilgisi yok.';
}

/// The flat map containing all translations for locale <tr>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.name' => 'Otizm Destek',
			'common.loading' => 'Yükleniyor',
			'common.comingSoon' => 'Bu bölüm yakında eklenecek.',
			'common.seeAll' => 'Tümünü Gör',
			'common.more' => 'Daha Fazla',
			'common.retry' => 'Tekrar Dene',
			'common.loadError' => 'Veriler yüklenemedi.',
			'common.monthsShort.0' => 'Oca',
			'common.monthsShort.1' => 'Şub',
			'common.monthsShort.2' => 'Mar',
			'common.monthsShort.3' => 'Nis',
			'common.monthsShort.4' => 'May',
			'common.monthsShort.5' => 'Haz',
			'common.monthsShort.6' => 'Tem',
			'common.monthsShort.7' => 'Ağu',
			'common.monthsShort.8' => 'Eyl',
			'common.monthsShort.9' => 'Eki',
			'common.monthsShort.10' => 'Kas',
			'common.monthsShort.11' => 'Ara',
			'language.title' => 'Dil',
			'language.turkish' => 'Türkçe',
			'language.english' => 'English',
			'theme.title' => 'Tema',
			'theme.system' => 'Sistem',
			'theme.light' => 'Açık',
			'theme.dark' => 'Koyu',
			'roles.parent' => 'Veli',
			'roles.expert' => 'Uzman',
			'roles.admin' => 'Yönetici',
			'auth.subtitle' => 'Hesabınıza giriş yapın veya yeni bir hesap oluşturun.',
			'auth.emailLabel' => 'E-posta Adresi',
			'auth.emailHint' => 'ornek@eposta.com',
			'auth.passwordLabel' => 'Şifre',
			'auth.passwordHint' => '••••••••',
			'auth.rememberMe' => 'Beni hatırla',
			'auth.forgotPassword' => 'Şifremi unuttum',
			'auth.loginButton' => 'Giriş Yap',
			'auth.noAccount' => 'Hesabınız yok mu?',
			'auth.registerParent' => 'Veli hesabı ile kaydol',
			'auth.registerExpert' => 'Uzman hesabı ile kaydol',
			'auth.errorEmptyFields' => 'Lütfen e-posta ve şifrenizi girin.',
			'auth.registerComingSoon' => ({required Object role}) => '${role} kayıt ekranı yakında eklenecek.',
			'forgotPassword.title' => 'Şifremi Unuttum',
			'forgotPassword.subtitle' => 'E-posta adresinizi girin; size bir şifre sıfırlama bağlantısı gönderelim.',
			'forgotPassword.submit' => 'Sıfırlama Bağlantısı Gönder',
			'forgotPassword.sentTitle' => 'Bağlantı gönderildi',
			'forgotPassword.sentBody' => 'Bu e-postaya kayıtlı bir hesap varsa, şifre sıfırlama bağlantısı gelen kutunuza ulaşacaktır.',
			'forgotPassword.haveCode' => 'Sıfırlama kodum var',
			'forgotPassword.backToLogin' => 'Girişe dön',
			'forgotPassword.errorEmailRequired' => 'Lütfen e-posta girin.',
			'forgotPassword.errorEmailInvalid' => 'Geçerli bir e-posta girin.',
			'resetPassword.title' => 'Şifre Sıfırla',
			'resetPassword.subtitle' => 'E-postadaki sıfırlama kodunu ve yeni şifrenizi girin.',
			'resetPassword.tokenLabel' => 'Sıfırlama Kodu',
			'resetPassword.tokenHint' => 'E-postadaki bağlantıdaki kod',
			'resetPassword.newPasswordLabel' => 'Yeni Şifre',
			'resetPassword.confirmLabel' => 'Yeni Şifre (Tekrar)',
			'resetPassword.submit' => 'Şifreyi Güncelle',
			'resetPassword.success' => 'Şifreniz güncellendi. Giriş yapabilirsiniz.',
			'resetPassword.errorTokenRequired' => 'Lütfen sıfırlama kodunu girin.',
			'resetPassword.errorPasswordShort' => 'Şifre en az 8 karakter olmalıdır.',
			'resetPassword.errorMismatch' => 'Şifreler eşleşmiyor.',
			'register.titleParent' => 'Veli Hesabı Oluştur',
			'register.titleExpert' => 'Uzman Hesabı Oluştur',
			'register.roleQuestion' => 'Nasıl kaydolmak istersiniz?',
			'register.fullNameLabel' => 'Ad Soyad',
			'register.fullNameHint' => 'Adınız ve soyadınız',
			'register.phoneLabel' => 'Telefon (isteğe bağlı)',
			'register.phoneHint' => '05XX XXX XX XX',
			'register.cityLabel' => 'Şehir (isteğe bağlı)',
			'register.cityHint' => 'Yaşadığınız şehir',
			'register.expertTitleLabel' => 'Uzmanlık Ünvanı',
			'register.expertTitleHint' => 'Örn. Çocuk Psikoloğu',
			'register.institutionLabel' => 'Kurum (isteğe bağlı)',
			'register.institutionHint' => 'Çalıştığınız kurum',
			'register.licenseNumberLabel' => 'Lisans / Diploma No',
			'register.licenseNumberHint' => 'Mesleki lisans numaranız',
			'register.bioLabel' => 'Hakkında (isteğe bağlı)',
			'register.bioHint' => 'Deneyiminizi kısaca anlatın',
			'register.specializationsLabel' => 'Uzmanlık Alanları (isteğe bağlı)',
			'register.specializationsHint' => 'Virgülle ayırın (Otizm, DEHB)',
			'register.kvkkConsent' => 'KVKK aydınlatma metnini okudum ve onaylıyorum.',
			'register.submit' => 'Kaydol',
			'register.haveAccount' => 'Zaten hesabınız var mı? Giriş yapın',
			'register.errorFullNameRequired' => 'Lütfen ad soyad girin.',
			'register.errorEmailRequired' => 'Lütfen e-posta girin.',
			'register.errorEmailInvalid' => 'Geçerli bir e-posta girin.',
			'register.errorPasswordShort' => 'Şifre en az 8 karakter olmalıdır.',
			'register.errorExpertTitleRequired' => 'Lütfen uzmanlık ünvanını girin.',
			'register.errorKvkkRequired' => 'Devam etmek için KVKK onayı gereklidir.',
			'nav.home' => 'Ana Sayfa',
			'nav.specialists' => 'Uzmanlar',
			'nav.progress' => 'Gelişim',
			'nav.profile' => 'Profil',
			'chat.title' => 'AI Asistan',
			'chat.greeting' => 'Merhaba! Otizm ve çocuk gelişimi hakkındaki sorularınızı yanıtlamaya çalışayım.',
			'chat.inputHint' => 'Bir soru sorun...',
			'chat.errorGeneric' => 'Yanıt alınamadı, lütfen tekrar deneyin.',
			'messages.title' => 'Mesajlar',
			'messages.noConversations' => 'Henüz bir konuşmanız yok.',
			'messages.noMessages' => 'Henüz mesaj yok. İlk mesajı gönderin.',
			'messages.inputHint' => 'Mesaj yazın...',
			'messages.connecting' => 'Bağlanıyor...',
			'home.notifications' => 'Bildirimler',
			'home.assistant' => 'AI Asistan',
			'home.messages' => 'Mesajlar',
			'home.greeting' => ({required Object name}) => 'Merhaba, ${name}',
			'home.greetingFallback' => 'Veli',
			'home.subtitle' => 'Bugün gelişim için neler yapabiliriz?',
			'home.childProgressTitle' => 'Çocuk Gelişimi',
			'home.weeklySummary' => 'Haftalık İlerleme Özeti',
			'home.increaseBadge' => ({required Object value}) => '%${value} Artış',
			'home.remainingToGoal' => ({required Object value}) => 'Hedefe Kalan: %${value}',
			'home.statusCognitiveGood' => 'Bilişsel: İyi',
			'home.statusCommunicationImproving' => 'İletişim: Gelişiyor',
			'home.upcomingAppointments' => 'Yaklaşan Randevular',
			'home.recommendedArticles' => 'Önerilen Makaleler',
			'home.childrenTitle' => 'Çocuklarım',
			'home.noChildren' => 'Henüz çocuk eklemediniz.',
			'home.addChild' => 'Çocuk Ekle',
			'home.ageYears' => ({required Object years}) => '${years} yaş',
			'home.noAppointments' => 'Yaklaşan randevunuz yok.',
			'home.noArticles' => 'Gösterilecek makale yok.',
			'specialists.title' => 'Uzman Bulun',
			'specialists.searchHint' => 'İsim veya uzmanlık arayın...',
			'specialists.filterAll' => 'Tümü',
			'specialists.filterPsychologist' => 'Psikolog',
			'specialists.filterSpecialEducation' => 'Özel Eğitim',
			'specialists.filterSpeech' => 'Dil ve Konuşma',
			'specialists.noResults' => 'Aramanıza uygun uzman bulunamadı.',
			'specialists.ratingNew' => 'Yeni',
			'specialists.reviews' => ({required Object count}) => '${count} değerlendirme',
			'progress.title' => 'Gelişim Takibi',
			'progress.subtitle' => 'Hedefler ve gelişim notları.',
			'progress.addRecord' => 'Yeni Kayıt Ekle',
			'progress.goalsTitle' => 'Hedefler',
			'progress.recentNotes' => 'Son Gelişim Notları',
			'progress.noGoals' => 'Henüz hedef eklenmemiş.',
			'progress.noNotes' => 'Henüz gelişim notu eklenmemiş.',
			'progress.noChild' => 'Gelişim takibi için önce bir çocuk ekleyin.',
			'progress.goalProgress' => ({required Object done, required Object total}) => '${done} / ${total}',
			'progress.addGoal' => 'Hedef Ekle',
			'progress.addNote' => 'Not Ekle',
			'goalForm.title' => 'Hedef Ekle',
			'goalForm.nameLabel' => 'Başlık',
			'goalForm.nameHint' => 'Örn. Göz teması kurma',
			'goalForm.categoryLabel' => 'Kategori',
			'goalForm.targetLabel' => 'Hedef Sayısı',
			'goalForm.descriptionLabel' => 'Açıklama (isteğe bağlı)',
			'goalForm.descriptionHint' => 'Hedefle ilgili detay',
			'goalForm.save' => 'Kaydet',
			'goalForm.errorTitle' => 'Lütfen bir başlık girin.',
			'goalForm.created' => 'Hedef eklendi.',
			'noteForm.title' => 'Not Ekle',
			'noteForm.nameLabel' => 'Başlık',
			'noteForm.nameHint' => 'Örn. Bugünkü gelişme',
			'noteForm.contentLabel' => 'İçerik (isteğe bağlı)',
			'noteForm.contentHint' => 'Gözlemlerinizi yazın',
			'noteForm.categoryLabel' => 'Kategori (isteğe bağlı)',
			'noteForm.moodLabel' => 'Ruh Hali (isteğe bağlı)',
			'noteForm.moodHappy' => 'Mutlu',
			'noteForm.moodCalm' => 'Sakin',
			'noteForm.moodSad' => 'Üzgün',
			'noteForm.dateLabel' => 'Tarih',
			'noteForm.save' => 'Kaydet',
			'noteForm.errorTitle' => 'Lütfen bir başlık girin.',
			'noteForm.created' => 'Not eklendi.',
			'notifications.show' => 'Göster',
			'notifications.title' => 'Bildirimler',
			'notifications.empty' => 'Henüz bildiriminiz yok.',
			'notifications.markAllRead' => 'Tümünü okundu işaretle',
			'notifications.dateLine' => ({required Object day, required Object month, required Object time}) => '${day} ${month} · ${time}',
			'knowledge.title' => 'Bilgi Bankası',
			'knowledge.empty' => 'Henüz makale eklenmemiş.',
			'knowledge.noResults' => 'Bu filtreye uygun içerik yok.',
			'knowledge.filterAll' => 'Tümü',
			'knowledge.formatArticle' => 'Makale',
			'knowledge.formatVideo' => 'Video',
			'knowledge.formatPodcast' => 'Podcast',
			'knowledge.views' => ({required Object count}) => '${count} görüntülenme',
			'knowledge.dateLine' => ({required Object day, required Object month, required Object year}) => '${day} ${month} ${year}',
			'knowledge.videoLink' => 'Video bağlantısı',
			'knowledge.podcastLink' => 'Podcast bağlantısı',
			'appointments.title' => 'Randevular',
			'appointments.empty' => 'Henüz randevunuz yok.',
			'appointments.upcoming' => 'Yaklaşan',
			'appointments.past' => 'Geçmiş',
			'appointments.statusPending' => 'Onay Bekliyor',
			'appointments.statusConfirmed' => 'Onaylandı',
			'appointments.statusCompleted' => 'Tamamlandı',
			'appointments.statusCancelled' => 'İptal Edildi',
			'appointments.typeOnline' => 'Online Görüşme',
			'appointments.typeFaceToFace' => 'Yüz Yüze',
			'appointments.withChild' => ({required Object name}) => 'Çocuk: ${name}',
			'appointments.dateLine' => ({required Object day, required Object month, required Object year, required Object time}) => '${day} ${month} ${year} · ${time}',
			'appointments.cancel' => 'İptal Et',
			'appointments.confirm' => 'Onayla',
			'appointments.complete' => 'Tamamla',
			'appointments.joinMeeting' => 'Görüşmeye Katıl',
			'appointments.cancelTitle' => 'Randevuyu İptal Et',
			'appointments.cancelConfirm' => 'Bu randevuyu iptal etmek istediğinize emin misiniz?',
			'appointments.cancelReasonLabel' => 'İptal nedeni (isteğe bağlı)',
			'appointments.cancelReasonShown' => ({required Object reason}) => 'İptal nedeni: ${reason}',
			'appointments.keepIt' => 'Vazgeç',
			'appointments.cancelled' => 'Randevu iptal edildi.',
			'appointments.confirmed' => 'Randevu onaylandı.',
			'appointments.completed' => 'Randevu tamamlandı olarak işaretlendi.',
			'expertDetail.bookAppointment' => 'Randevu Al',
			'expertDetail.sendMessage' => 'Mesaj Gönder',
			'expertDetail.specializationsTitle' => 'Uzmanlık Alanları',
			'expertDetail.articleCount' => ({required Object count}) => '${count} makale',
			'expertDetail.notAcceptingPatients' => 'Bu uzman şu an randevu kabul etmiyor.',
			'booking.title' => 'Randevu Al',
			'booking.childLabel' => 'Çocuk',
			'booking.noChild' => 'Randevu almak için önce bir çocuk ekleyin.',
			'booking.typeLabel' => 'Randevu Tipi',
			'booking.dateLabel' => 'Tarih',
			'booking.selectDate' => 'Tarih seçin',
			'booking.dateValue' => ({required Object day, required Object month, required Object year}) => '${day} ${month} ${year}',
			'booking.timeLabel' => 'Saat',
			'booking.selectDateFirst' => 'Uygun saatleri görmek için önce tarih seçin.',
			'booking.noSlots' => 'Bu gün için uygun saat yok.',
			'booking.notesLabel' => 'Not (isteğe bağlı)',
			'booking.notesHint' => 'Uzmana iletmek istediğiniz not',
			'booking.confirm' => 'Randevuyu Onayla',
			'booking.created' => 'Randevu oluşturuldu.',
			'booking.errorSelectChild' => 'Lütfen bir çocuk seçin.',
			'booking.errorSelectTime' => 'Lütfen bir saat seçin.',
			'routines.title' => 'Rutinler',
			'routines.empty' => 'Bu çocuk için henüz rutin yok.',
			'routines.noChild' => 'Rutin oluşturmak için önce bir çocuk ekleyin.',
			'routines.add' => 'Rutin Ekle',
			'routines.addItem' => 'Adım Ekle',
			'routines.noItems' => 'Henüz adım eklenmemiş.',
			'routines.deleteRoutineTitle' => 'Rutini Sil',
			'routines.deleteRoutineConfirm' => ({required Object name}) => '${name} rutinini silmek istediğinize emin misiniz?',
			'routines.delete' => 'Sil',
			'routines.cancel' => 'İptal',
			'routines.created' => 'Rutin eklendi.',
			'routines.itemAdded' => 'Adım eklendi.',
			'routines.deleted' => 'Rutin silindi.',
			'routines.itemTitleLabel' => 'Adım Başlığı',
			'routines.itemTitleHint' => 'Örn. Dişleri fırçala',
			'routines.itemTimeLabel' => 'Saat (isteğe bağlı)',
			'routines.selectTime' => 'Saat seç',
			'routines.itemIconLabel' => 'İkon',
			'routines.itemSave' => 'Ekle',
			'routines.errorItemTitle' => 'Lütfen adım başlığı girin.',
			'routineForm.title' => 'Rutin Ekle',
			'routineForm.nameLabel' => 'Rutin Adı',
			'routineForm.nameHint' => 'Örn. Sabah Rutini',
			'routineForm.descriptionLabel' => 'Açıklama (isteğe bağlı)',
			'routineForm.descriptionHint' => 'Bu rutin ne için?',
			'routineForm.save' => 'Kaydet',
			'routineForm.errorName' => 'Lütfen bir rutin adı girin.',
			'dailyTracker.title' => 'Günlük Takip',
			'dailyTracker.todayTitle' => 'Bugün nasıldı?',
			'dailyTracker.today' => 'Bugün',
			'dailyTracker.mood1' => 'Çok Kötü',
			'dailyTracker.mood2' => 'Kötü',
			'dailyTracker.mood3' => 'Orta',
			'dailyTracker.mood4' => 'İyi',
			'dailyTracker.mood5' => 'Harika',
			'dailyTracker.triggersLabel' => 'Olası tetikleyiciler (isteğe bağlı)',
			'dailyTracker.notesLabel' => 'Not (isteğe bağlı)',
			'dailyTracker.notesHint' => 'Bugüne dair gözlemleriniz',
			'dailyTracker.save' => 'Kaydet',
			'dailyTracker.update' => 'Güncelle',
			'dailyTracker.saved' => 'Ruh hali kaydedildi.',
			'dailyTracker.historyTitle' => 'Geçmiş Kayıtlar',
			'dailyTracker.empty' => 'Henüz kayıt yok. İlk kaydı bugün ekleyin.',
			'dailyTracker.noChild' => 'Günlük takip için önce bir çocuk ekleyin.',
			'dailyTracker.deleteTitle' => 'Kaydı Sil',
			'dailyTracker.deleteConfirm' => ({required Object date}) => '${date} tarihli kaydı silmek istediğinize emin misiniz?',
			'dailyTracker.delete' => 'Sil',
			'dailyTracker.cancel' => 'İptal',
			'dailyTracker.deleted' => 'Kayıt silindi.',
			'dailyTracker.errorSelectMood' => 'Lütfen bir ruh hali seçin.',
			'dailyTracker.dateLine' => ({required Object day, required Object month, required Object year}) => '${day} ${month} ${year}',
			'analytics.title' => 'Gelişim Paneli',
			'analytics.subtitle' => 'Son 6 ayın gelişim eğilimleri.',
			'analytics.milestones' => 'Kilometre Taşları',
			'analytics.milestonesUnit' => 'aylık kazanım sayısı',
			'analytics.mood' => 'Ruh Hali Ortalaması',
			'analytics.moodUnit' => '1-5 arası aylık ortalama',
			'analytics.sleep' => 'Ortalama Uyku',
			'analytics.sleepUnit' => 'gecelik saat (aylık ortalama)',
			'analytics.behavior' => 'Davranış Kayıtları',
			'analytics.behaviorUnit' => 'aylık kayıt sayısı',
			'analytics.noData' => 'Bu aralıkta henüz veri yok.',
			'analytics.noChild' => 'Gelişim paneli için önce bir çocuk ekleyin.',
			'children.title' => 'Çocuklarım',
			'children.addTitle' => 'Çocuk Ekle',
			'children.editTitle' => 'Çocuğu Düzenle',
			'children.empty' => 'Henüz çocuk eklemediniz.',
			'children.add' => 'Çocuk Ekle',
			'children.nameLabel' => 'Ad Soyad',
			'children.nameHint' => 'Çocuğun adı',
			'children.birthDateLabel' => 'Doğum Tarihi (isteğe bağlı)',
			'children.birthDateSelect' => 'Tarih seçin',
			'children.genderLabel' => 'Cinsiyet (isteğe bağlı)',
			'children.genderMale' => 'Erkek',
			'children.genderFemale' => 'Kız',
			'children.diagnosisLabel' => 'Tanı Bilgisi (isteğe bağlı)',
			'children.diagnosisHint' => 'Varsa tanı bilgisi',
			'children.educationLabel' => 'Eğitim Programı (isteğe bağlı)',
			'children.educationHint' => 'Devam ettiği eğitim programı',
			'children.therapiesLabel' => 'Terapiler (isteğe bağlı)',
			'children.therapiesHint' => 'Aldığı terapiler',
			'children.ageYears' => ({required Object years}) => '${years} yaş',
			'children.save' => 'Kaydet',
			'children.cancel' => 'İptal',
			'children.delete' => 'Sil',
			'children.deleteTitle' => 'Çocuğu Sil',
			'children.deleteConfirm' => ({required Object name}) => '${name} profilini silmek istediğinize emin misiniz?',
			'children.errorNameRequired' => 'Lütfen çocuğun adını girin.',
			'children.created' => 'Çocuk profili oluşturuldu.',
			'children.updated' => 'Çocuk profili güncellendi.',
			'children.deleted' => 'Çocuk profili silindi.',
			'account.title' => 'Hesap Bilgileri',
			'account.emailLabel' => 'E-posta',
			'account.fullNameLabel' => 'Ad Soyad',
			'account.phoneLabel' => 'Telefon',
			'account.phoneHint' => '05XX XXX XX XX',
			'account.cityLabel' => 'Şehir',
			'account.expertTitleLabel' => 'Uzmanlık Ünvanı',
			'account.institutionLabel' => 'Kurum',
			'account.licenseNumberLabel' => 'Lisans / Diploma No',
			'account.bioLabel' => 'Hakkında',
			'account.bioHint' => 'Deneyiminizi kısaca anlatın',
			'account.save' => 'Kaydet',
			'account.saved' => 'Profil güncellendi.',
			'account.errorFullName' => 'Ad soyad en az 2 karakter olmalıdır.',
			'help.title' => 'Yardım & Hakkında',
			'help.aboutTitle' => 'Otizm Destek Hakkında',
			'help.aboutBody' => 'Otizm Destek; çocuğunuzun gelişimini takip etmenize, uzmanlarla iletişim kurmanıza ve randevu almanıza yardımcı olan bir mobil uygulamadır.',
			'help.tipsTitle' => 'İpuçları',
			'help.tip1' => 'Çocuklarınızı "Çocuklarım"dan ekleyin; hedef ve gelişim notlarını "Gelişim" sekmesinden takip edin.',
			'help.tip2' => '"Uzmanlar"dan bir uzman seçip randevu alabilir veya mesaj gönderebilirsiniz.',
			'help.tip3' => 'AI Asistan\'a otizm ve çocuk gelişimi hakkında sorular sorabilirsiniz.',
			'help.contactTitle' => 'İletişim',
			'help.contactBody' => 'Soru ve önerileriniz için uygulama içinden bize ulaşabilirsiniz.',
			'help.version' => ({required Object version}) => 'Sürüm ${version}',
			'profile.defaultUser' => 'Kullanıcı',
			'profile.accountInfo' => 'Hesap Bilgileri',
			'profile.myChildren' => 'Çocuklarım',
			'profile.notificationSettings' => 'Bildirim Ayarları',
			'profile.help' => 'Yardım',
			'profile.signOut' => 'Çıkış Yap',
			'errors.timeout' => 'Sunucuya ulaşılamadı, lütfen tekrar deneyin.',
			'errors.noConnection' => 'İnternet bağlantısı yok gibi görünüyor.',
			'errors.generic' => ({required Object code}) => 'Bir hata oluştu (${code}).',
			'errors.cancelled' => 'İstek iptal edildi.',
			'errors.unexpected' => 'Beklenmeyen bir hata oluştu.',
			'errors.unexpectedResponse' => 'Beklenmeyen sunucu yanıtı.',
			'errors.operationFailed' => 'İşlem başarısız.',
			'errors.noUserInResponse' => 'Sunucu yanıtında kullanıcı bilgisi yok.',
			_ => null,
		};
	}
}
