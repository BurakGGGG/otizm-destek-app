///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsEn extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsEn({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	late final TranslationsEn _root = this; // ignore: unused_field

	@override 
	TranslationsEn $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsEn(meta: meta ?? this.$meta);

	// Translations
	@override late final _Translations$app$en app = _Translations$app$en._(_root);
	@override late final _Translations$common$en common = _Translations$common$en._(_root);
	@override late final _Translations$language$en language = _Translations$language$en._(_root);
	@override late final _Translations$theme$en theme = _Translations$theme$en._(_root);
	@override late final _Translations$roles$en roles = _Translations$roles$en._(_root);
	@override late final _Translations$auth$en auth = _Translations$auth$en._(_root);
	@override late final _Translations$verifyEmail$en verifyEmail = _Translations$verifyEmail$en._(_root);
	@override late final _Translations$forgotPassword$en forgotPassword = _Translations$forgotPassword$en._(_root);
	@override late final _Translations$resetPassword$en resetPassword = _Translations$resetPassword$en._(_root);
	@override late final _Translations$password$en password = _Translations$password$en._(_root);
	@override late final _Translations$register$en register = _Translations$register$en._(_root);
	@override late final _Translations$settings$en settings = _Translations$settings$en._(_root);
	@override late final _Translations$legal$en legal = _Translations$legal$en._(_root);
	@override late final _Translations$kvkk$en kvkk = _Translations$kvkk$en._(_root);
	@override late final _Translations$onboarding$en onboarding = _Translations$onboarding$en._(_root);
	@override late final _Translations$nav$en nav = _Translations$nav$en._(_root);
	@override late final _Translations$chat$en chat = _Translations$chat$en._(_root);
	@override late final _Translations$messages$en messages = _Translations$messages$en._(_root);
	@override late final _Translations$home$en home = _Translations$home$en._(_root);
	@override late final _Translations$dailyPlan$en dailyPlan = _Translations$dailyPlan$en._(_root);
	@override late final _Translations$specialists$en specialists = _Translations$specialists$en._(_root);
	@override late final _Translations$progress$en progress = _Translations$progress$en._(_root);
	@override late final _Translations$goalForm$en goalForm = _Translations$goalForm$en._(_root);
	@override late final _Translations$noteForm$en noteForm = _Translations$noteForm$en._(_root);
	@override late final _Translations$notesPage$en notesPage = _Translations$notesPage$en._(_root);
	@override late final _Translations$notifications$en notifications = _Translations$notifications$en._(_root);
	@override late final _Translations$search$en search = _Translations$search$en._(_root);
	@override late final _Translations$knowledge$en knowledge = _Translations$knowledge$en._(_root);
	@override late final _Translations$appointments$en appointments = _Translations$appointments$en._(_root);
	@override late final _Translations$expertDetail$en expertDetail = _Translations$expertDetail$en._(_root);
	@override late final _Translations$booking$en booking = _Translations$booking$en._(_root);
	@override late final _Translations$routines$en routines = _Translations$routines$en._(_root);
	@override late final _Translations$routineForm$en routineForm = _Translations$routineForm$en._(_root);
	@override late final _Translations$dailyTracker$en dailyTracker = _Translations$dailyTracker$en._(_root);
	@override late final _Translations$sleep$en sleep = _Translations$sleep$en._(_root);
	@override late final _Translations$meds$en meds = _Translations$meds$en._(_root);
	@override late final _Translations$wall$en wall = _Translations$wall$en._(_root);
	@override late final _Translations$weekly$en weekly = _Translations$weekly$en._(_root);
	@override late final _Translations$meetup$en meetup = _Translations$meetup$en._(_root);
	@override late final _Translations$similar$en similar = _Translations$similar$en._(_root);
	@override late final _Translations$groups$en groups = _Translations$groups$en._(_root);
	@override late final _Translations$treatment$en treatment = _Translations$treatment$en._(_root);
	@override late final _Translations$tasks$en tasks = _Translations$tasks$en._(_root);
	@override late final _Translations$forum$en forum = _Translations$forum$en._(_root);
	@override late final _Translations$childDetail$en childDetail = _Translations$childDetail$en._(_root);
	@override late final _Translations$crisis$en crisis = _Translations$crisis$en._(_root);
	@override late final _Translations$calendar$en calendar = _Translations$calendar$en._(_root);
	@override late final _Translations$emergency$en emergency = _Translations$emergency$en._(_root);
	@override late final _Translations$behavior$en behavior = _Translations$behavior$en._(_root);
	@override late final _Translations$analytics$en analytics = _Translations$analytics$en._(_root);
	@override late final _Translations$children$en children = _Translations$children$en._(_root);
	@override late final _Translations$account$en account = _Translations$account$en._(_root);
	@override late final _Translations$help$en help = _Translations$help$en._(_root);
	@override late final _Translations$profile$en profile = _Translations$profile$en._(_root);
	@override late final _Translations$errors$en errors = _Translations$errors$en._(_root);
	@override late final _Translations$guide$en guide = _Translations$guide$en._(_root);
	@override late final _Translations$community$en community = _Translations$community$en._(_root);
	@override late final _Translations$reviews$en reviews = _Translations$reviews$en._(_root);
	@override late final _Translations$expertAccess$en expertAccess = _Translations$expertAccess$en._(_root);
}

// Path: app
class _Translations$app$en extends Translations$app$tr {
	_Translations$app$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get name => 'Autism Support';
}

// Path: common
class _Translations$common$en extends Translations$common$tr {
	_Translations$common$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Cancel';
	@override String get loading => 'Loading';
	@override String get comingSoon => 'This section is coming soon.';
	@override String get seeAll => 'See All';
	@override String get more => 'More';
	@override String get retry => 'Retry';
	@override String get loadError => 'Could not load data.';
	@override late final _Translations$common$unsaved$en unsaved = _Translations$common$unsaved$en._(_root);
	@override late final _Translations$common$a11y$en a11y = _Translations$common$a11y$en._(_root);
	@override List<String> get monthsShort => [
		'Jan',
		'Feb',
		'Mar',
		'Apr',
		'May',
		'Jun',
		'Jul',
		'Aug',
		'Sep',
		'Oct',
		'Nov',
		'Dec',
	];
}

// Path: language
class _Translations$language$en extends Translations$language$tr {
	_Translations$language$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Language';
	@override String get turkish => 'Türkçe';
	@override String get english => 'English';
}

// Path: theme
class _Translations$theme$en extends Translations$theme$tr {
	_Translations$theme$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Theme';
	@override String get system => 'System';
	@override String get light => 'Light';
	@override String get dark => 'Dark';
}

// Path: roles
class _Translations$roles$en extends Translations$roles$tr {
	_Translations$roles$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get parent => 'Parent';
	@override String get expert => 'Specialist';
	@override String get admin => 'Admin';
}

// Path: auth
class _Translations$auth$en extends Translations$auth$tr {
	_Translations$auth$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get subtitle => 'Sign in to your account or create a new one.';
	@override String get emailLabel => 'Email Address';
	@override String get emailHint => 'example@email.com';
	@override String get passwordLabel => 'Password';
	@override String get passwordHint => '••••••••';
	@override String get rememberMe => 'Remember me';
	@override String get forgotPassword => 'Forgot password';
	@override String get loginButton => 'Sign In';
	@override String get noAccount => 'Don\'t have an account?';
	@override String get registerParent => 'Sign up as a parent';
	@override String get registerExpert => 'Sign up as a specialist';
	@override String get errorEmptyFields => 'Please enter your email and password.';
	@override String registerComingSoon({required Object role}) => '${role} sign-up screen is coming soon.';
	@override String get errorMfaRequired => 'This account uses two-step verification; please sign in on the web for now.';
	@override String get resendVerification => 'Resend verification email';
}

// Path: verifyEmail
class _Translations$verifyEmail$en extends Translations$verifyEmail$tr {
	_Translations$verifyEmail$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Email Verification';
	@override String get waitingTitle => 'Check your inbox';
	@override String get waitingBody => 'We sent you a verification link. Once you open it, come back here and sign in.';
	@override String waitingBodyWithEmail({required Object email}) => 'We sent a verification link to ${email}. Once you open it, come back here and sign in.';
	@override String get spamHint => 'If the email does not arrive within a few minutes, check your spam folder.';
	@override String get approvalTitle => 'Your professional account is awaiting approval';
	@override String get approvalBody => 'We received your application. You can sign in once an administrator verifies your license details.';
	@override String get tokenLabel => 'Verification Code';
	@override String get tokenHint => 'The code inside the email link';
	@override String get tokenHelp => 'If you cannot open the link, paste the code from it here.';
	@override String get verifyButton => 'Verify';
	@override String get verifying => 'Verifying your email address…';
	@override String get resendButton => 'Resend email';
	@override String get resent => 'A new verification link was sent. Check your inbox and spam folder.';
	@override String get success => 'Your email address is verified. You can sign in now.';
	@override String get errorTokenRequired => 'Please enter the verification code.';
	@override String get errorEmailRequired => 'An email address is required to resend.';
	@override String get backToLogin => 'Back to sign in';
}

// Path: forgotPassword
class _Translations$forgotPassword$en extends Translations$forgotPassword$tr {
	_Translations$forgotPassword$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Forgot Password';
	@override String get subtitle => 'Enter your email and we\'ll send you a password reset link.';
	@override String get submit => 'Send Reset Link';
	@override String get sentTitle => 'Link sent';
	@override String get sentBody => 'If an account exists for this email, a password reset link will arrive in your inbox.';
	@override String get haveCode => 'I have a reset code';
	@override String get backToLogin => 'Back to login';
	@override String get errorEmailRequired => 'Please enter your email.';
	@override String get errorEmailInvalid => 'Please enter a valid email.';
}

// Path: resetPassword
class _Translations$resetPassword$en extends Translations$resetPassword$tr {
	_Translations$resetPassword$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Reset Password';
	@override String get subtitle => 'Enter the reset code from your email and your new password.';
	@override String get tokenLabel => 'Reset Code';
	@override String get tokenHint => 'The code from the email link';
	@override String get newPasswordLabel => 'New Password';
	@override String get confirmLabel => 'Confirm New Password';
	@override String get submit => 'Update Password';
	@override String get success => 'Your password has been updated. You can sign in now.';
	@override String get errorTokenRequired => 'Please enter the reset code.';
	@override String get errorPasswordShort => 'Password must be at least 8 characters.';
	@override String get errorMismatch => 'Passwords do not match.';
}

// Path: password
class _Translations$password$en extends Translations$password$tr {
	_Translations$password$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get strengthTitle => 'Password strength';
	@override String get strengthVeryWeak => 'Very weak';
	@override String get strengthWeak => 'Weak';
	@override String get strengthMedium => 'Medium';
	@override String get strengthStrong => 'Strong';
	@override String get strengthVeryStrong => 'Very strong';
	@override String get ruleMinLength => 'At least 8 characters';
	@override String get ruleUppercase => 'One uppercase letter';
	@override String get ruleDigit => 'One digit';
	@override String get ruleSpecial => 'One special character';
	@override String get errorTooShort => 'Password must be at least 8 characters.';
	@override String get errorTooLong => 'Password can be at most 64 characters.';
	@override String get errorNoUppercase => 'Password must contain at least one uppercase letter.';
	@override String get errorNoDigit => 'Password must contain at least one digit.';
	@override String get errorNoSpecial => 'Password must contain at least one special character (e.g. ! ? * . -).';
	@override String get errorCommon => 'This password is too common and easy to guess; please choose a different one.';
}

// Path: register
class _Translations$register$en extends Translations$register$tr {
	_Translations$register$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get titleParent => 'Create Parent Account';
	@override String get titleExpert => 'Create Specialist Account';
	@override String get roleQuestion => 'How would you like to sign up?';
	@override String get fullNameLabel => 'Full Name';
	@override String get fullNameHint => 'Your first and last name';
	@override String get phoneLabel => 'Phone (optional)';
	@override String get phoneHint => '05XX XXX XX XX';
	@override String get cityLabel => 'City (optional)';
	@override String get cityHint => 'Your city';
	@override String get expertTitleLabel => 'Professional Title';
	@override String get expertTitleHint => 'e.g. Child Psychologist';
	@override String get institutionLabel => 'Institution (optional)';
	@override String get institutionHint => 'Where you work';
	@override String get licenseNumberLabel => 'License / Diploma No';
	@override String get licenseNumberHint => 'Your professional license number';
	@override String get bioLabel => 'About (optional)';
	@override String get bioHint => 'Briefly describe your experience';
	@override String get specializationsLabel => 'Areas of Expertise (optional)';
	@override String get specializationsHint => 'Separate with commas (Autism, ADHD)';
	@override String get kvkkConsent => 'I have read and accept the data protection (KVKK) notice.';
	@override String get submit => 'Sign Up';
	@override String get haveAccount => 'Already have an account? Sign in';
	@override String get errorFullNameRequired => 'Please enter your full name.';
	@override String get errorEmailRequired => 'Please enter your email.';
	@override String get errorEmailInvalid => 'Please enter a valid email.';
	@override String get errorPasswordShort => 'Password must be at least 8 characters.';
	@override String get errorExpertTitleRequired => 'Please enter your professional title.';
	@override String get errorLicenseRequired => 'A license / diploma number is required for professional sign-up.';
	@override String get emailTaken => 'This email address is already registered. Try signing in.';
	@override String get emailAvailable => 'This email address is available.';
	@override String get errorKvkkRequired => 'KVKK consent is required to continue.';
}

// Path: settings
class _Translations$settings$en extends Translations$settings$tr {
	_Translations$settings$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get blockedTitle => 'Blocked users';
	@override String get blockedEmpty => 'You have not blocked anyone.';
	@override String get blockedRemove => 'Unblock';
	@override String get blockedRemoved => 'User unblocked.';
	@override String get privacyFamilyMessages => 'Let other families message me';
	@override String get matchingTitle => 'What are you looking for in the community?';
	@override String get matchingHint => 'Shown in match suggestions and on your profile.';
	@override String get communicationTitle => 'Your communication preference';
	@override String get intentExperience => 'Sharing experience';
	@override String get intentRegular => 'Regular conversation';
	@override String get intentLocalMeet => 'Meeting nearby';
	@override String get intentSeekMentor => 'Looking for a mentor';
	@override String get intentBeMentor => 'Can be a mentor';
	@override String get commWriting => 'Messaging first';
	@override String get commVideo => 'Video calls';
	@override String get commEvening => 'I reply in the evening';
	@override String get title => 'Settings';
	@override String get notificationsTitle => 'Notifications';
	@override String get notificationsSubtitle => 'Choose what you want to be notified about.';
	@override String get notifMessages => 'New messages';
	@override String get notifAppointment => 'Appointment confirmations and changes';
	@override String get notifApptReminder => 'Remind me 24 hours before an appointment';
	@override String get notifExpertNote => 'Specialist notes and feedback';
	@override String get notifTaskAssigned => 'When a new assignment arrives';
	@override String get notifForum => 'Forum and support wall replies';
	@override String get notifMatching => 'Similar family matches';
	@override String get notifCalendar => 'Calendar reminders';
	@override String get privacyTitle => 'Privacy';
	@override String get privacySubtitle => 'Decide how other people see you.';
	@override String get privacyShowProfile => 'Show my profile to other families';
	@override String get privacyAllowMessages => 'Allow people to message me';
	@override String get privacyShareProgress => 'Share the progress summary with my specialist';
	@override String get privacyApproximateLocation => 'Share my approximate location (city)';
	@override String get privacyHidePresence => 'Hide my online status';
	@override String get appearanceTitle => 'Appearance and language';
	@override String get accessibilityTitle => 'Accessibility';
	@override String get accessibilitySubtitle => 'Adapt the look and interaction to your needs.';
	@override String get a11yLargeText => 'Large text mode';
	@override String get a11yLargeTextBody => 'Shows text at a larger size.';
	@override String get a11yCalmMode => 'Calm appearance';
	@override String get a11yCalmModeBody => 'Uses softer tones that are easier on the eyes.';
	@override String get a11yHighContrast => 'High contrast';
	@override String get a11yHighContrastBody => 'Keeps text in the most legible colours.';
	@override String get a11yReduceMotion => 'Reduce motion';
	@override String get a11yReduceMotionBody => 'Turns off page transitions and animations.';
	@override String get a11ySimpleMode => 'Simple mode';
	@override String get a11ySimpleModeBody => 'Reduces the profile menu to the essential sections.';
	@override String get securityTitle => 'Security';
	@override String get securitySubtitle => 'Protect access to your account.';
	@override String get changePassword => 'Change password';
	@override String get changePasswordSubmit => 'Update password';
	@override String get currentPasswordLabel => 'Current password';
	@override String get newPasswordLabel => 'New password';
	@override String get passwordChanged => 'Your password has been updated.';
	@override String get errorCurrentPasswordRequired => 'Please enter your current password.';
	@override String get dataTitle => 'Your data and KVKK';
	@override String get dataSubtitle => 'Exercise your rights over your personal data here.';
	@override String get kvkkPanel => 'KVKK rights and consents';
	@override String get kvkkPanelBody => 'Consent preferences, requests and the privacy notice.';
	@override String get downloadData => 'Download my data';
	@override String get downloadDataBody => 'Get everything in your account as a JSON file.';
	@override String get downloadDataSubject => 'Otizm Destek — my account data';
	@override String get deleteAccount => 'Delete my account';
	@override String get deleteAccountBody => 'Your account and all records are permanently deleted.';
	@override String get deleteAccountWarning => 'This cannot be undone. All your data — child profiles, notes, appointments and messages — is permanently deleted.';
	@override String get deleteAccountSubmit => 'Permanently delete my account';
	@override String get deleteKeyword => 'DELETE';
	@override String deleteConfirmLabel({required Object keyword}) => 'Type "${keyword}" to confirm';
	@override String get errorDeleteConfirm => 'The confirmation text does not match.';
}

// Path: legal
class _Translations$legal$en extends Translations$legal$tr {
	_Translations$legal$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Legal documents';
	@override String get subtitle => 'Privacy notice, privacy policy, terms of use and medical safety warnings. The binding version is Turkish, so the texts are shown in Turkish.';
	@override String versionLine({required Object version, required Object date}) => 'Text version ${version} · Last updated ${date}';
	@override String get readNotice => 'Read the KVKK privacy notice';
}

// Path: kvkk
class _Translations$kvkk$en extends Translations$kvkk$tr {
	_Translations$kvkk$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Data rights and consents';
	@override String get rightsTitle => 'Your rights under KVKK art. 11';
	@override String get rightsBody => 'You may learn whether your data is processed, request correction or deletion, learn which third parties it was shared with, and object to automated analysis results. Requests are answered within 30 days at the latest.';
	@override String get consentsTitle => 'Your consent preferences';
	@override String get consentsSubtitle => 'Explicit consent must be purpose-specific; each item can be turned on or off separately.';
	@override String get consentNotice => 'Privacy notice acceptance';
	@override String get consentAi => 'AI analysis';
	@override String get consentAiBody => 'Allows development data to be transferred to the AI provider (abroad).';
	@override String get consentEmergency => 'Emergency card sharing';
	@override String get consentEmergencyBody => 'Allows your emergency card to be shown to third parties via link/QR.';
	@override String get consentMatching => 'Similar family matching';
	@override String get consentMatchingBody => 'Allows your profile to be shown to other families in the matching engine.';
	@override String get consentMarketing => 'Informational emails';
	@override String get consentMarketingBody => 'Lets us send you optional announcements and informational emails.';
	@override String get reconsentTitle => 'The privacy notice has been updated';
	@override String reconsentTitleVersion({required Object version}) => 'The privacy notice has been updated (version ${version})';
	@override String get reconsentBody => 'Review how your data is processed and accept the current notice.';
	@override String get reconsentAccept => 'I have read and accept';
	@override String get reconsentSaved => 'Your acceptance of the current notice has been recorded.';
	@override String get historyTitle => 'My consent history';
	@override String get requestsTitle => 'My requests';
	@override String get requestsSubtitle => 'Submit requests about your personal data here.';
	@override String get newRequest => 'Submit a KVKK request';
	@override String get requestsEmpty => 'You have no requests yet.';
	@override String get requestsError => 'Requests could not be loaded.';
	@override String get requestCreated => 'Your request was received. It will be answered within 30 days at the latest.';
	@override String get requestInfo => 'I want to learn whether my data is being processed';
	@override String get requestCorrection => 'I want incomplete or incorrect data to be corrected';
	@override String get requestDeletion => 'I want my data to be deleted / destroyed';
	@override String get requestTransfer => 'I want to learn the third parties my data was shared with';
	@override String get requestObjection => 'I object to a result produced against me by automated analysis';
	@override String get requestDamages => 'I request compensation for the damage I suffered';
	@override String get descriptionLabel => 'Your request';
	@override String get descriptionHint => 'Briefly describe your request.';
	@override String get responseTime => 'Requests are answered within 30 days at the latest.';
	@override String get submitRequest => 'Send request';
	@override String get errorDescriptionRequired => 'Please describe your request.';
	@override String get statusOpen => 'Received';
	@override String get statusReviewing => 'Under review';
	@override String get statusDone => 'Completed';
	@override String get statusRejected => 'Rejected';
	@override String receivedOn({required Object date}) => 'received on ${date}';
	@override String dueOn({required Object date}) => 'response due ${date}';
}

// Path: onboarding
class _Translations$onboarding$en extends Translations$onboarding$tr {
	_Translations$onboarding$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Getting started';
	@override String get skip => 'Skip';
	@override String get start => 'Let\'s begin';
	@override String get back => 'Back';
	@override String get continueButton => 'Continue';
	@override String get skipForNow => 'Skip for now';
	@override String get finish => 'Go to home';
	@override String get stepChild => 'Child Profile';
	@override String get stepTags => 'Support Areas';
	@override String get stepPlan => 'Starter Plan';
	@override String get welcomeTitle => 'Welcome';
	@override String get welcomeBody => 'Let\'s set the app up for your child in a few short steps. You can change everything later.';
	@override String get introChildTitle => 'Basic details';
	@override String get introChildBody => 'Name and a few optional notes';
	@override String get introTagsTitle => 'Support areas';
	@override String get introTagsBody => 'Pick the areas you observe';
	@override String get introPlanTitle => 'Starter suggestions';
	@override String get introPlanBody => 'See what you can do first';
	@override String get childTitle => 'Tell us about your child';
	@override String get childSubtitle => 'Only the name is required; you can fill in the rest later.';
	@override String get childNameLabel => 'Child\'s name';
	@override String get childNameHint => 'e.g. Elif';
	@override String get childBirthDateLabel => 'Date of birth (optional)';
	@override String get childBirthDateHint => 'Tap to choose';
	@override String get childDiagnosisLabel => 'Diagnosis details (optional)';
	@override String get childDiagnosisHint => 'Diagnosis and short notes, if any';
	@override String get focusTitle => 'Starting focus';
	@override String get communicationTitle => 'Communication style';
	@override String get supportTitle => 'Support that may help';
	@override String get tagsTitle => 'Which areas do you need support with?';
	@override String get tagsSubtitle => 'Pick what you observe; similar families and content suggestions follow these.';
	@override String get planTitle => 'Your starter plan is ready';
	@override String planTitleNamed({required Object name}) => 'Your starter plan for ${name} is ready';
	@override String get planSubtitle => 'You can try one of these as a first step.';
	@override String get planNote => 'These are only starting suggestions; every section stays reachable from the menu.';
	@override String get planTrackerTitle => 'Add a daily entry';
	@override String get planTrackerBody => 'Log sleep, mood or a short observation.';
	@override String get planExpertsTitle => 'Browse specialists';
	@override String get planExpertsBody => 'Look through specialists or request an appointment.';
	@override String get planKnowledgeTitle => 'Explore the knowledge base';
	@override String get planKnowledgeBody => 'Browse trusted content in the knowledge base.';
	@override String expertTitle({required Object name}) => 'Welcome ${name}';
	@override String get expertBody => 'Client tracking, appointments and messages are waiting on the home screen.';
	@override String get errorNameRequired => 'The child\'s name is required.';
	@override String get errorBirthDateFuture => 'The date of birth cannot be in the future.';
}

// Path: nav
class _Translations$nav$en extends Translations$nav$tr {
	_Translations$nav$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get home => 'Home';
	@override String get specialists => 'Specialists';
	@override String get progress => 'Progress';
	@override String get profile => 'Profile';
}

// Path: chat
class _Translations$chat$en extends Translations$chat$tr {
	_Translations$chat$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'AI Assistant';
	@override String get greeting => 'Hi! I\'ll try to answer your questions about autism and child development.';
	@override String get inputHint => 'Ask a question...';
	@override String get errorGeneric => 'Couldn\'t get a response, please try again.';
}

// Path: messages
class _Translations$messages$en extends Translations$messages$tr {
	_Translations$messages$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get blockUser => 'Block user';
	@override String blockConfirm({required Object name}) => '${name} will no longer be able to message you. Block?';
	@override String get blocked => 'User blocked.';
	@override String get title => 'Messages';
	@override String get noConversations => 'You have no conversations yet.';
	@override String get noMessages => 'No messages yet. Send the first one.';
	@override String get inputHint => 'Type a message...';
	@override String get connecting => 'Connecting...';
	@override String get pecsTitle => 'PECS picture cards';
	@override String get filterAll => 'All';
	@override String get filterUnread => 'Unread';
	@override String get filterExperts => 'Experts';
	@override String get filterGroups => 'Groups';
	@override String get filterArchived => 'Archive';
	@override String get emptyUnread => 'No unread messages.';
	@override String get emptyExperts => 'No messages with experts yet.';
	@override String get emptyGroups => 'You are not in a group yet.';
	@override String get emptyArchived => 'The archive is empty. Archived chats appear here.';
	@override String get archive => 'Archive';
	@override String get unarchive => 'Unarchive';
	@override String get mute => 'Mute';
	@override String get unmute => 'Unmute';
	@override String get reply => 'Reply';
	@override String replyingTo({required Object name}) => 'Replying to ${name}';
	@override String get someone => 'Message';
	@override String get attachPhoto => 'Attach a photo';
	@override String get photoSent => 'Photo sent.';
	@override String get newChat => 'New chat';
	@override String get searchUserHint => 'Search by name…';
	@override String get searchUserHelp => 'Type at least two letters to start a chat.';
	@override String get searchUserEmpty => 'No matching users found.';
	@override String get searchInChat => 'Search in chat';
	@override String get searchNoResults => 'No messages match this search.';
	@override String get deleteMessage => 'Delete message';
}

// Path: home
class _Translations$home$en extends Translations$home$tr {
	_Translations$home$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get notifications => 'Notifications';
	@override String get assistant => 'AI Assistant';
	@override String get messages => 'Messages';
	@override String greeting({required Object name}) => 'Hello, ${name}';
	@override String get greetingFallback => 'Parent';
	@override String get subtitle => 'What can we do for development today?';
	@override String get childProgressTitle => 'Child Development';
	@override String get weeklySummary => 'Weekly Progress Summary';
	@override String increaseBadge({required Object value}) => '${value}% Increase';
	@override String remainingToGoal({required Object value}) => 'Remaining to goal: ${value}%';
	@override String get statusCognitiveGood => 'Cognitive: Good';
	@override String get statusCommunicationImproving => 'Communication: Improving';
	@override String get upcomingAppointments => 'Upcoming Appointments';
	@override String get recommendedArticles => 'Recommended Articles';
	@override String get childrenTitle => 'My Children';
	@override String get noChildren => 'You haven\'t added a child yet.';
	@override String get addChild => 'Add Child';
	@override String ageYears({required Object years}) => '${years} yrs';
	@override String get noAppointments => 'You have no upcoming appointments.';
	@override String get noArticles => 'No articles to show.';
	@override String get quickTracker => 'Today\'s log';
	@override String get quickTrackerDetail => 'Mood, sleep, medication';
	@override String get quickBehavior => 'Behaviour note';
	@override String get quickBehaviorDetail => 'Antecedent-behaviour-consequence';
	@override String get quickNote => 'Observation note';
	@override String get quickNoteDetail => 'Add a short note';
	@override String get quickPlan => 'Add a plan';
	@override String get quickPlanDetail => 'Appointment, school, event';
}

// Path: dailyPlan
class _Translations$dailyPlan$en extends Translations$dailyPlan$tr {
	_Translations$dailyPlan$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'What to do today?';
	@override String subtitle({required Object count, required Object minutes}) => '${count} left · about ${minutes} min';
	@override String get subtitleDone => 'Today\'s tasks are done';
	@override String get coachLabel => 'Daily coach tip';
	@override String durationMinutes({required Object count}) => '${count} min';
	@override String get badgeNow => 'Do this now';
	@override String get badgeNext => 'Next';
	@override String get badgeSafety => 'Safety';
	@override String get badgeOptional => 'Optional';
	@override String get badgeDone => 'Done';
	@override String get allDoneTitle => 'Today\'s tasks are complete';
	@override String get allDoneDetail => 'The core records are in. With the time left you can look at the plan, the community or the knowledge base.';
	@override String get partMorning => 'this morning';
	@override String get partAfternoon => 'this afternoon';
	@override String get partEvening => 'this evening';
	@override String get coachNoChild => 'Today it is enough to create the child profile. The other sections make sense once the profile exists.';
	@override String coachAllDone({required Object name}) => 'Everything for ${name} is done today! You can move on to the plan or the knowledge base.';
	@override String coachMedication({required Object name, required Object part, required Object count}) => 'For ${name} it is best to finish the medication check ${part}; the remaining ${count} tasks are quicker.';
	@override String coachNoMood({required Object name, required Object part}) => 'Start with a short daily log for ${name} — it makes ${part} feel complete.';
	@override String coachEvent({required Object name, required Object count}) => 'There is a planned event for ${name} today; the remaining ${count} tasks can stay short.';
	@override String coachProgress({required Object done, required Object name, required Object count}) => '${done} done for ${name}, ${count} left. You are doing well!';
	@override String coachPlan({required Object name, required Object part, required Object minutes}) => 'Plan for ${name} ${part} - a short log, a calendar check and one note. About ${minutes} min in total.';
	@override String get taskDailyLog => 'Add today\'s short log';
	@override String get taskDailyLogDone => 'Update today\'s log';
	@override String get taskDailyLogDetail => 'Mark mood, sleep and medication in about a minute.';
	@override String get taskDailyLogDoneDetail => 'Mood is in; you can still add sleep, medication or a short note.';
	@override String get taskMedication => 'Finish the medication check';
	@override String taskMedicationDetail({required Object count}) => '${count} doses are not marked yet.';
	@override String get taskMessages => 'Reply to messages';
	@override String taskMessagesDetail({required Object count}) => 'You have ${count} unread messages.';
	@override String get taskExpertRequest => 'Answer the expert access request';
	@override String taskExpertRequestDetail({required Object count}) => '${count} experts are waiting for access to your child\'s data.';
	@override String taskEventDetail({required Object time}) => 'Today at ${time}';
	@override String taskEventTomorrowDetail({required Object time}) => 'Tomorrow at ${time}';
	@override String get taskCalendar => 'Plan the calendar';
	@override String get taskCalendarDetail => 'Add appointments, school or activities if you have any.';
	@override String get taskCalendarUpcoming => 'See the upcoming event';
	@override String get taskNotes => 'Add a short observation note';
	@override String get taskNotesDetail => 'Note something you noticed today.';
	@override String get taskNotesDone => 'Review your observation notes';
	@override String taskNotesDoneDetail({required Object count}) => '${count} notes so far — you can add a new one.';
	@override String get taskCommunity => 'Discover the community';
	@override String get taskCommunityDetail => 'See what families going through similar things are sharing.';
	@override String get taskCommunityDone => 'Follow the community areas';
	@override String get taskCommunityDoneDetail => 'There may be new posts in the weekly question, forum and meetups.';
	@override String get taskEmergency => 'Create the emergency card';
	@override String get taskEmergencyDetail => 'Keep critical medical details and emergency contacts on one card.';
	@override String get taskFirstChild => 'Create the first child profile';
	@override String get taskFirstChildDetail => 'Once the profile exists, the plan and tips adapt to your child.';
	@override String get taskGuide => 'See how the app is laid out';
	@override String get taskGuideDetail => 'Learn quickly what each section is for.';
	@override String get taskExperts => 'Discover expert support';
	@override String get taskExpertsDetail => 'You can browse expert profiles before booking anything.';
	@override String get startTitle => 'Quick start';
	@override String get startIntro => 'You do not have to finish everything on day one. The profile, a short log and the crisis guide are enough.';
	@override String startProgress({required Object done, required Object total}) => '${done}/${total} steps';
	@override String startReady({required Object percent}) => '${percent}% ready';
	@override String get startDismiss => 'Dismiss the guide';
	@override String get checkTodo => 'To do';
	@override String get checkDone => 'Completed';
	@override String get checkChildProfile => '1. Child profile';
	@override String get checkChildProfileDetail => 'The plan, tracking and expert sharing adapt to the profile.';
	@override String get checkDailyLog => '2. First short log';
	@override String get checkDailyLogDetail => 'Data comes first; the daily plan makes sense after that log.';
	@override String get checkCrisis => '3. Crisis guide';
	@override String get checkCrisisDetail => 'Read the calming and intervention steps before a hard moment.';
}

// Path: specialists
class _Translations$specialists$en extends Translations$specialists$tr {
	_Translations$specialists$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Find a Specialist';
	@override String get searchHint => 'Search by name or expertise...';
	@override String get filterAll => 'All';
	@override String get filterPsychologist => 'Psychologist';
	@override String get filterSpecialEducation => 'Special Education';
	@override String get filterSpeech => 'Speech & Language';
	@override String get noResults => 'No specialists match your search.';
	@override String get ratingNew => 'New';
	@override String reviews({required Object count}) => '${count} reviews';
	@override String get filters => 'Filters';
	@override String get cityLabel => 'City';
	@override String get sortLabel => 'Sort';
	@override String get sortDefault => 'Default';
	@override String get sortRating => 'By rating';
	@override String get sortName => 'By name';
	@override String get onlyAccepting => 'Only experts accepting new clients';
	@override String get onlyVerified => 'Only verified experts';
	@override String get onlyOnline => 'Online sessions only';
	@override String get onlyFavorites => 'My favourites only';
	@override String get addFavorite => 'Add to favourites';
	@override String get removeFavorite => 'Remove from favourites';
	@override String get clearFilters => 'Clear';
	@override String get applyFilters => 'Apply';
}

// Path: progress
class _Translations$progress$en extends Translations$progress$tr {
	_Translations$progress$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Progress Tracking';
	@override String get subtitle => 'Goals and development notes.';
	@override String get addRecord => 'Add New Record';
	@override String get goalsTitle => 'Goals';
	@override String get recentNotes => 'Recent Development Notes';
	@override String get noGoals => 'No goals added yet.';
	@override String get noNotes => 'No development notes yet.';
	@override String get noChild => 'Add a child first to track development.';
	@override String goalProgress({required Object done, required Object total}) => '${done} / ${total}';
	@override String get addGoal => 'Add Goal';
	@override String get addNote => 'Add Note';
	@override String get addToken => 'Add Token';
	@override String get tokenAdded => 'Token added 🎉';
	@override String get tokenRemoved => 'Token removed.';
	@override String get goalCompleted => 'Goal completed! 🎉';
	@override String rewardLine({required Object title}) => 'Reward: ${title}';
}

// Path: goalForm
class _Translations$goalForm$en extends Translations$goalForm$tr {
	_Translations$goalForm$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Add Goal';
	@override String get nameLabel => 'Title';
	@override String get nameHint => 'e.g. Making eye contact';
	@override String get categoryLabel => 'Category';
	@override String get targetLabel => 'Target Count';
	@override String get descriptionLabel => 'Description (optional)';
	@override String get descriptionHint => 'Details about the goal';
	@override String get save => 'Save';
	@override String get errorTitle => 'Please enter a title.';
	@override String get created => 'Goal added.';
}

// Path: noteForm
class _Translations$noteForm$en extends Translations$noteForm$tr {
	_Translations$noteForm$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Add Note';
	@override String get editTitle => 'Edit Note';
	@override String get nameLabel => 'Title';
	@override String get nameHint => 'e.g. Today\'s progress';
	@override String get contentLabel => 'Content (optional)';
	@override String get contentHint => 'Write your observations';
	@override String get categoryLabel => 'Category (optional)';
	@override String get moodLabel => 'Mood (optional)';
	@override String get moodHappy => 'Happy';
	@override String get moodNeutral => 'Normal';
	@override String get moodSad => 'Hard Day';
	@override String get dateLabel => 'Date';
	@override String get save => 'Save';
	@override String get errorTitle => 'Please enter a title.';
	@override String get created => 'Note added.';
	@override String get updated => 'Note updated.';
}

// Path: notesPage
class _Translations$notesPage$en extends Translations$notesPage$tr {
	_Translations$notesPage$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'My Notes';
	@override String get add => 'Add Note';
	@override String get searchHint => 'Search notes…';
	@override String get empty => 'No development notes yet. Start by adding the first note.';
	@override String get noResults => 'No results. Try changing the filter or search.';
	@override String get noChildren => 'Add a child profile first.';
	@override String get loadMore => 'Load More';
	@override String get edit => 'Edit';
	@override String get delete => 'Delete';
	@override String get cancel => 'Cancel';
	@override String get deleteTitle => 'Delete Note';
	@override String get deleteConfirm => 'Are you sure you want to delete this note?';
	@override String get deleted => 'Note deleted.';
}

// Path: notifications
class _Translations$notifications$en extends Translations$notifications$tr {
	_Translations$notifications$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get show => 'Show';
	@override String get title => 'Notifications';
	@override String get empty => 'You have no notifications yet.';
	@override String get markAllRead => 'Mark all as read';
	@override String dateLine({required Object day, required Object month, required Object time}) => '${day} ${month} · ${time}';
	@override String get noneInFilter => 'No notifications match this filter.';
	@override String get unreadOnly => 'Unread only';
	@override String selectedCount({required Object count}) => '${count} selected';
	@override String get deleteSelected => 'Delete selected';
	@override String get groupToday => 'Today';
	@override String get groupYesterday => 'Yesterday';
	@override String get groupThisWeek => 'This Week';
	@override String get groupOlder => 'Older';
	@override String get catAll => 'All';
	@override String get catAppointments => 'Appointments';
	@override String get catMessages => 'Messages';
	@override String get catForum => 'Forum';
	@override String get catTasks => 'Tasks';
	@override String get catSocial => 'Social';
	@override String get catSystem => 'System';
}

// Path: search
class _Translations$search$en extends Translations$search$tr {
	_Translations$search$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Search';
	@override String get hint => 'Search articles, posts, groups or experts…';
	@override String get help => 'Type what you are looking for.';
	@override String get noResults => 'No results match this search.';
	@override String get typeAll => 'All';
	@override String get typeArticle => 'Article';
	@override String get typePost => 'Post';
	@override String get typeGroup => 'Group';
	@override String get typeExpert => 'Expert';
}

// Path: knowledge
class _Translations$knowledge$en extends Translations$knowledge$tr {
	_Translations$knowledge$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Knowledge Base';
	@override String get empty => 'No articles yet.';
	@override String get noResults => 'No content matches this filter.';
	@override String get filterAll => 'All';
	@override String get formatArticle => 'Article';
	@override String get formatVideo => 'Video';
	@override String get formatPodcast => 'Podcast';
	@override String views({required Object count}) => '${count} views';
	@override String dateLine({required Object day, required Object month, required Object year}) => '${day} ${month} ${year}';
	@override String get videoLink => 'Video link';
	@override String get podcastLink => 'Podcast link';
	@override String get searchHint => 'Search articles, topics or keywords…';
	@override String get bookmarks => 'My bookmarks';
	@override String get bookmark => 'Bookmark';
	@override String get noBookmarks => 'You have not bookmarked anything yet.';
	@override String get relatedTitle => 'Related content';
	@override String commentsTitle({required Object count}) => 'Comments (${count})';
	@override String get noComments => 'Be the first to comment.';
	@override String get commentHint => 'Share your experience or ask a question…';
	@override String get commentSend => 'Post comment';
	@override String get someone => 'A family';
	@override String get expertBadge => 'Expert';
	@override String triedFor({required Object duration}) => 'Tried for: ${duration}';
	@override String effectiveness({required Object rating}) => 'Effectiveness: ${rating}/5';
	@override String get tagFilterTitle => 'Narrow down by tag';
	@override String get tagFilterClear => 'Clear tags';
	@override String tagFilterCount({required Object count}) => '${count} tags selected';
}

// Path: appointments
class _Translations$appointments$en extends Translations$appointments$tr {
	_Translations$appointments$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get rate => 'Rate';
	@override String get rateTitle => 'Rate this appointment';
	@override String get rateComment => 'Your comment (optional)';
	@override String get rateSave => 'Send';
	@override String get rated => 'Your rating has been saved.';
	@override String rateStars({required Object count}) => '${count} stars';
	@override String get ratingShown => 'Your rating';
	@override String get cancelSeries => 'Cancel series';
	@override String get cancelSeriesTitle => 'Cancel the whole series?';
	@override String get cancelSeriesConfirm => 'All upcoming appointments in this recurring series will be cancelled.';
	@override String get seriesCancelled => 'Series cancelled.';
	@override String seriesIndex({required Object index}) => 'Session ${index}';
	@override String get seriesBadge => 'Series';
	@override String get recurrenceTitle => 'Recurring sessions';
	@override String get recurrenceHint => 'Created automatically every week at the same day and time.';
	@override String get recurrenceSingle => 'Single';
	@override String recurrenceWeeks({required Object count}) => '${count} weeks';
	@override String recurrenceCreated({required Object count}) => 'A ${count}-week series has been created.';
	@override String get title => 'Appointments';
	@override String get empty => 'You don\'t have any appointments yet.';
	@override String get upcoming => 'Upcoming';
	@override String get past => 'Past';
	@override String get statusPending => 'Pending';
	@override String get statusConfirmed => 'Confirmed';
	@override String get statusCompleted => 'Completed';
	@override String get statusCancelled => 'Cancelled';
	@override String get typeOnline => 'Online session';
	@override String get typeFaceToFace => 'In person';
	@override String withChild({required Object name}) => 'Child: ${name}';
	@override String dateLine({required Object day, required Object month, required Object year, required Object time}) => '${day} ${month} ${year} · ${time}';
	@override String get cancel => 'Cancel';
	@override String get confirm => 'Confirm';
	@override String get complete => 'Complete';
	@override String get joinMeeting => 'Join meeting';
	@override String get cancelTitle => 'Cancel appointment';
	@override String get cancelConfirm => 'Are you sure you want to cancel this appointment?';
	@override String get cancelReasonLabel => 'Cancellation reason (optional)';
	@override String cancelReasonShown({required Object reason}) => 'Cancellation reason: ${reason}';
	@override String get keepIt => 'Keep';
	@override String get cancelled => 'Appointment cancelled.';
	@override String get confirmed => 'Appointment confirmed.';
	@override String get completed => 'Appointment marked as completed.';
	@override String get reschedule => 'Reschedule';
	@override String get rescheduleTitle => 'Reschedule Appointment';
	@override String get rescheduleConfirm => 'Confirm New Time';
	@override String get rescheduled => 'Appointment rescheduled.';
	@override String get nextTitle => 'Next appointment';
	@override String countdownDays({required Object days, required Object hours, required Object minutes}) => '${days} d ${hours} h ${minutes} m left';
	@override String countdownToday({required Object hours, required Object minutes, required Object seconds}) => '${hours} h ${minutes} m ${seconds} s left';
	@override String get countdownNow => 'Session time';
	@override String get statToday => 'Today';
	@override String get statWeek => 'This week';
	@override String get statMonth => 'This month';
	@override String get statPending => 'Pending';
	@override String get statCompleted => 'Completed';
	@override String get statCancelled => 'Cancelled';
	@override String get findExpert => 'Find an expert';
	@override String get today => 'Today';
	@override String get tomorrow => 'Tomorrow';
	@override String get detailTitle => 'Appointment details';
	@override String get detailDuration => 'Duration';
	@override String detailDurationValue({required Object count}) => '${count} min';
	@override String get detailExpert => 'Expert';
	@override String get detailParent => 'Parent';
	@override String get detailChild => 'Child';
	@override String get detailStatus => 'Status';
	@override String get detailType => 'Format';
	@override String get detailNote => 'Appointment note';
	@override String get detailTopic => 'Session topic';
	@override String get detailPreSession => 'Note shared before the session';
	@override String get detailSessionNote => 'Session note';
	@override String get detailSessionSummary => 'Session summary';
	@override String get detailFollowUp => 'Expert recommendations';
	@override String get detailFollowUpTask => 'Follow-up task';
	@override String get detailRating => 'Rating';
	@override String detailRatingValue({required Object rating}) => '${rating} / 5';
	@override String detailCancelledBy({required Object who}) => 'Cancelled by: ${who}';
	@override String get detailLateCancellation => 'Late cancellation';
	@override String get historyTitle => 'Status history';
	@override String get historyEmpty => 'No status changes recorded yet.';
	@override String historyChange({required Object from, required Object to}) => '${from} → ${to}';
	@override String historyMeta({required Object name, required Object date}) => '${name} · ${date}';
	@override String get detailOpen => 'Details';
}

// Path: expertDetail
class _Translations$expertDetail$en extends Translations$expertDetail$tr {
	_Translations$expertDetail$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get bookAppointment => 'Book Appointment';
	@override String get sendMessage => 'Send Message';
	@override String get specializationsTitle => 'Specializations';
	@override String articleCount({required Object count}) => '${count} articles';
	@override String get notAcceptingPatients => 'This expert is not accepting appointments right now.';
	@override String get aboutTitle => 'About';
	@override String get professionalTitle => 'Profile details';
	@override String get factNextSlot => 'First available slot';
	@override String get factNextSlotEmpty => 'Check the calendar';
	@override String get factSession => 'Session length';
	@override String factSessionValue({required Object count}) => '${count} minutes';
	@override String get factAgeGroups => 'Age groups';
	@override String get factAgeGroupsEmpty => 'Ask the expert';
	@override String get factLanguages => 'Languages';
	@override String get factSupportTopics => 'Support topics';
	@override String get factSupportTopicsEmpty => 'Not stated on the profile';
	@override String get factCancellation => 'Cancellation policy';
	@override String get factCancellationEmpty => 'Confirm with the expert before the appointment';
	@override String get factReschedule => 'Reschedule policy';
	@override String get factService => 'Session format';
	@override String get factServiceEmpty => 'Not stated';
	@override String get serviceOnline => 'Online';
	@override String get serviceFaceToFace => 'In person';
	@override String get factFee => 'Session fee';
	@override String get factFeeEmpty => 'Ask the expert';
	@override String get badgeVerified => 'Verified expert';
	@override String get badgePending => 'Awaiting approval';
	@override String get badgeLicenseVerified => 'License verified';
	@override String get report => 'Report this profile';
	@override String get reportReasonLabel => 'Reason';
	@override String get reportNoteLabel => 'Extra details (optional)';
	@override String get reportNoteHint => 'Describe the situation in a few sentences';
	@override String get reportSend => 'Send report';
	@override String get reportSent => 'Your report has been sent. The moderation team will review it.';
}

// Path: booking
class _Translations$booking$en extends Translations$booking$tr {
	_Translations$booking$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Book Appointment';
	@override String get childLabel => 'Child';
	@override String get noChild => 'Add a child first to book an appointment.';
	@override String get typeLabel => 'Appointment Type';
	@override String get dateLabel => 'Date';
	@override String get selectDate => 'Select date';
	@override String dateValue({required Object day, required Object month, required Object year}) => '${day} ${month} ${year}';
	@override String get timeLabel => 'Time';
	@override String get selectDateFirst => 'Select a date to see available times.';
	@override String get noSlots => 'No available times for this day.';
	@override String get notesLabel => 'Note (optional)';
	@override String get notesHint => 'A note for the expert';
	@override String get confirm => 'Confirm Appointment';
	@override String get created => 'Appointment created.';
	@override String get errorSelectChild => 'Please select a child.';
	@override String get errorSelectTime => 'Please select a time.';
}

// Path: routines
class _Translations$routines$en extends Translations$routines$tr {
	_Translations$routines$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String starWallet({required Object count}) => '${count} stars';
	@override String get stepDone => 'Step completed, +1 star!';
	@override String progressDone({required Object percent}) => '${percent}% completed';
	@override String stepCount({required Object count}) => '${count} steps';
	@override String get title => 'Routines';
	@override String get empty => 'No routines for this child yet.';
	@override String get noChild => 'Add a child first to create routines.';
	@override String get add => 'Add Routine';
	@override String get addItem => 'Add Step';
	@override String get noItems => 'No steps added yet.';
	@override String get deleteRoutineTitle => 'Delete Routine';
	@override String deleteRoutineConfirm({required Object name}) => 'Are you sure you want to delete the routine "${name}"?';
	@override String get delete => 'Delete';
	@override String get cancel => 'Cancel';
	@override String get created => 'Routine added.';
	@override String get itemAdded => 'Step added.';
	@override String get deleted => 'Routine deleted.';
	@override String get itemTitleLabel => 'Step Title';
	@override String get itemTitleHint => 'e.g. Brush teeth';
	@override String get itemTimeLabel => 'Time (optional)';
	@override String get selectTime => 'Select time';
	@override String get itemIconLabel => 'Icon';
	@override String get itemSave => 'Add';
	@override String get errorItemTitle => 'Please enter a step title.';
}

// Path: routineForm
class _Translations$routineForm$en extends Translations$routineForm$tr {
	_Translations$routineForm$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Add Routine';
	@override String get nameLabel => 'Routine Name';
	@override String get nameHint => 'e.g. Morning Routine';
	@override String get descriptionLabel => 'Description (optional)';
	@override String get descriptionHint => 'What is this routine for?';
	@override String get save => 'Save';
	@override String get errorName => 'Please enter a routine name.';
}

// Path: dailyTracker
class _Translations$dailyTracker$en extends Translations$dailyTracker$tr {
	_Translations$dailyTracker$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Daily Tracker';
	@override String get tabMood => 'Mood';
	@override String get tabSleep => 'Sleep';
	@override String get tabMeds => 'Medication';
	@override String get todayTitle => 'How was today?';
	@override String get today => 'Today';
	@override String get mood1 => 'Very Bad';
	@override String get mood2 => 'Bad';
	@override String get mood3 => 'Okay';
	@override String get mood4 => 'Good';
	@override String get mood5 => 'Great';
	@override String get triggersLabel => 'Possible triggers (optional)';
	@override String get notesLabel => 'Note (optional)';
	@override String get notesHint => 'Your observations about today';
	@override String get save => 'Save';
	@override String get update => 'Update';
	@override String get saved => 'Mood saved.';
	@override String get historyTitle => 'Past Entries';
	@override String get empty => 'No entries yet. Add the first one today.';
	@override String get noChild => 'Add a child first to use the daily tracker.';
	@override String get deleteTitle => 'Delete Entry';
	@override String deleteConfirm({required Object date}) => 'Are you sure you want to delete the entry dated ${date}?';
	@override String get delete => 'Delete';
	@override String get cancel => 'Cancel';
	@override String get deleted => 'Entry deleted.';
	@override String get errorSelectMood => 'Please select a mood.';
	@override String dateLine({required Object day, required Object month, required Object year}) => '${day} ${month} ${year}';
}

// Path: sleep
class _Translations$sleep$en extends Translations$sleep$tr {
	_Translations$sleep$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get todayTitle => 'Last Night / This Morning';
	@override String get bedtime => 'Bedtime';
	@override String get wakeTime => 'Wake Time';
	@override String get quality => 'Sleep Quality';
	@override String get nightWakings => 'Night wakings';
	@override String get factorsLabel => 'Sensory and environmental factors';
	@override String get factorWeighted => '🛏️ Weighted Blanket';
	@override String get factorSensory => '👕 Sensory Sensitivity';
	@override String get factorMelatonin => '💊 Melatonin Support';
	@override String get factorNoise => '🔊 Noise / Light';
	@override String get saved => 'Sleep saved.';
	@override String get empty => 'No sleep entries yet. Add the first one today.';
	@override String deleteConfirm({required Object date}) => 'Are you sure you want to delete the sleep entry dated ${date}?';
	@override String get deleted => 'Sleep entry deleted.';
	@override String duration({required Object h, required Object m}) => '${h} h ${m} min';
	@override String wakings({required Object count}) => 'woke ${count} times';
}

// Path: meds
class _Translations$meds$en extends Translations$meds$tr {
	_Translations$meds$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get safetyTitle => 'Medication safety';
	@override String get safetyBody => 'Medication reminders are for support only. Decisions about starting, stopping, changing doses or side effects should be made only with your doctor.';
	@override String get add => 'Add Medication';
	@override String get addTitle => 'Add New Medication';
	@override String get editTitle => 'Edit Medication';
	@override String get empty => 'No medications yet. Add your child\'s medications and supplements here.';
	@override String get name => 'Medication / Supplement Name';
	@override String get nameHint => 'E.g. Omega-3';
	@override String get dosage => 'Dose';
	@override String get unit => 'Unit';
	@override String get frequency => 'Frequency';
	@override String get freqDaily => 'Once a day';
	@override String get freqTwiceDaily => 'Twice a day';
	@override String get freqThreeDaily => '3 times a day';
	@override String get freqAsNeeded => 'As needed';
	@override String get freqWeekly => 'Weekly';
	@override String get timesLabel => 'Dose times';
	@override String get addTime => 'Add Time';
	@override String get noTime => 'No time';
	@override String get added => 'Medication added.';
	@override String get updated => 'Medication updated.';
	@override String get deleteTitle => 'Delete Medication';
	@override String deleteConfirm({required Object name}) => '${name} and its dose logs will be permanently deleted. Are you sure?';
	@override String get deleted => 'Medication deleted.';
	@override String get errorName => 'Please enter the medication name.';
	@override String get logTitle => 'Dose Log';
	@override String get taken => 'Medication taken';
	@override String get sideEffectsLabel => 'Observed side effects';
	@override String get logNotesLabel => 'Observation notes (optional)';
	@override String get logNotesHint => 'Anything you want to share with your doctor?';
	@override String get logSaved => 'Dose log saved.';
}

// Path: wall
class _Translations$wall$en extends Translations$wall$tr {
	_Translations$wall$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Support Wall';
	@override String get subtitle => 'Share your feelings and support each other. Posts can be anonymous.';
	@override String get empty => 'No posts yet. Be the first to share.';
	@override String get add => 'Share';
	@override String get addTitle => 'Support Post';
	@override String get editTitle => 'Edit Post';
	@override String get titleLabel => 'Title (optional)';
	@override String get titleHint => 'A short title';
	@override String get contentLabel => 'How are you feeling?';
	@override String get contentHint => 'You can let it out; you\'re not alone here.';
	@override String get anonymous => 'Post anonymously';
	@override String get anonymousUser => 'Anonymous User';
	@override String get post => 'Share';
	@override String get posted => 'Your post was added to the wall.';
	@override String get updated => 'Post updated.';
	@override String get deleteTitle => 'Delete Post';
	@override String get deleteConfirm => 'Are you sure you want to delete this post?';
	@override String get deleted => 'Post deleted.';
	@override String get errorContent => 'Please write something.';
	@override String supportCount({required Object count}) => '${count} support';
	@override String commentCount({required Object count}) => '${count} comments';
	@override String get detailTitle => 'Post';
	@override String get commentsTitle => 'Support Messages';
	@override String get commentHint => 'Write a message of support…';
	@override String get commentSend => 'Send';
	@override String get commentSent => 'Support message sent.';
	@override String get commentEmpty => 'No support messages yet. Be the first.';
	@override String get commentDeleteTitle => 'Delete Comment';
	@override String get commentDeleteConfirm => 'Are you sure you want to delete this support message?';
	@override String get commentDeleted => 'Comment deleted.';
	@override String get edit => 'Edit';
	@override String get delete => 'Delete';
	@override String get cancel => 'Cancel';
	@override String get save => 'Save';
	@override String get justNow => 'just now';
	@override String minsAgo({required Object count}) => '${count} min ago';
	@override String hoursAgo({required Object count}) => '${count} h ago';
	@override String daysAgo({required Object count}) => '${count} d ago';
}

// Path: weekly
class _Translations$weekly$en extends Translations$weekly$tr {
	_Translations$weekly$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get filterAll => 'All';
	@override String get filterExpert => 'Experts';
	@override String get filterPopular => 'Popular';
	@override String get filterLocal => 'My city';
	@override String get searchHint => 'Search answers';
	@override String localHint({required Object city}) => 'Showing answers from families in ${city} only.';
	@override String get localHintNoCity => 'No city on your profile; showing all answers.';
	@override String get noMatch => 'No answers match this filter.';
	@override String get title => 'Question of the Week';
	@override String get subtitle => 'This week\'s question for families. Share your experience and support each other.';
	@override String get empty => 'No weekly question yet. It will appear here when a new one is published.';
	@override String get answersTitle => 'Family Answers';
	@override String answerCount({required Object count}) => '${count} answers';
	@override String expertCount({required Object count}) => '${count} expert';
	@override String get expertBadge => 'Expert';
	@override String get anonymousUser => 'Anonymous Family';
	@override String get yourAnswerTitle => 'Write Your Answer';
	@override String get answerHint => 'Even a short note helps. Share your experience…';
	@override String get anonymous => 'Post anonymously';
	@override String get tagsLabel => 'Tags (optional)';
	@override String get send => 'Share';
	@override String get sent => 'Your answer was shared, thank you!';
	@override String get errorEmpty => 'Please write an answer.';
	@override String get noAnswers => 'No answers yet. Be the first to share.';
	@override String get likeError => 'Could not save the like.';
	@override String get justNow => 'just now';
	@override String minsAgo({required Object count}) => '${count} m ago';
	@override String hoursAgo({required Object count}) => '${count} h ago';
	@override String daysAgo({required Object count}) => '${count} d ago';
}

// Path: meetup
class _Translations$meetup$en extends Translations$meetup$tr {
	_Translations$meetup$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Local Meetups';
	@override String get subtitle => 'Meet families in your city and spend time together.';
	@override String get empty => 'No meetups in this city yet. Be the first to create one.';
	@override String get add => 'Create Meetup';
	@override String get addTitle => 'New Meetup';
	@override String get titleLabel => 'Meetup Name';
	@override String get titleHint => 'e.g. Morning Meetup at the Park';
	@override String get cityLabel => 'City';
	@override String get cityHint => 'Select a city';
	@override String get districtLabel => 'District';
	@override String get districtHint => 'e.g. Kadıköy';
	@override String get venueLabel => 'Venue';
	@override String get venueHint => 'e.g. Moda Park or a cafe name';
	@override String get dateLabel => 'Date';
	@override String get timeLabel => 'Time';
	@override String get descriptionLabel => 'Description';
	@override String get descriptionHint => 'Who can join, what will it be like?';
	@override String get create => 'Create';
	@override String get created => 'Your meetup was created. Other families can see it now.';
	@override String get errorRequired => 'Please fill in the title, city and date fields.';
	@override String attendCount({required Object count}) => '${count} attending';
	@override String get join => 'Join';
	@override String get joined => 'Attending';
	@override String get joinedMsg => 'You\'re attending the meetup!';
	@override String get leftMsg => 'Your attendance was cancelled.';
	@override String get today => 'Today';
	@override String get tomorrow => 'Tomorrow';
	@override String inDays({required Object count}) => 'in ${count} days';
	@override String get past => 'Past';
	@override String organizerBy({required Object name}) => 'Organized by ${name}';
}

// Path: similar
class _Translations$similar$en extends Translations$similar$tr {
	_Translations$similar$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Similar Families';
	@override String get subtitle => 'Meet families at a similar stage to your child and share experiences.';
	@override String get noChild => 'Add a child first, then discover similar families.';
	@override String get discoverable => 'You\'re discoverable in matching';
	@override String get hidden => 'You\'re hidden from matching';
	@override String get discoverableHint => 'If you turn this off, other families won\'t see you in suggestions.';
	@override String get empty => 'No matching families right now. Updating your profile and tags can improve your chances.';
	@override String get matchLabel => 'match';
	@override String get commonTagsTitle => 'Common areas';
	@override String moreTags({required Object count}) => '+${count}';
	@override String get reasonsTitle => 'Why you matched';
	@override String ageRange({required Object range}) => 'Age ${range}';
	@override String get message => 'Message';
	@override String get buddy => 'Buddy';
	@override String get mentor => 'Mentor';
	@override String get pendingLabel => 'Request pending';
	@override String get buddyLabel => 'Buddy connection';
	@override String get mentorLabel => 'Mentor connection';
	@override String get requestTitle => 'Connection request';
	@override String get mentorRequestTitle => 'Mentor request';
	@override String get requestHint => 'Write a short intro message (optional)';
	@override String get requestDefault => 'Hi, I noticed we\'ve been through similar journeys. If you\'re open to it, I\'d like to start with a brief introduction here.';
	@override String get send => 'Send Request';
	@override String get sent => 'Connection request sent.';
	@override String get cancel => 'Cancel';
	@override String get meetup => 'Meet up';
	@override String get meetupTitle => 'Send a meet-up request';
	@override String get meetupOnline => 'Online';
	@override String get meetupInPerson => 'In person';
	@override String get meetupPickDate => 'Pick a date';
	@override String get meetupPickTime => 'Pick a time';
	@override String get meetupLocation => 'Meeting place';
	@override String get meetupMessage => 'Message (optional)';
	@override String get meetupMessageHint => 'Briefly say why you would like to meet';
	@override String get meetupSent => 'Meet-up request sent.';
	@override String get meetupRequestsTitle => 'Meet-up requests';
	@override String get meetupAccept => 'Accept';
	@override String get meetupDecline => 'Decline';
	@override String get meetupCancel => 'Withdraw request';
	@override String get unknownFamily => 'Family';
	@override String get tabMatches => 'Matches';
	@override String get tabCircle => 'My circle';
	@override String get circlePendingTitle => 'Incoming connection requests';
	@override String get circleAcceptedTitle => 'My friends and mentors';
	@override String get circleEmpty => 'Your circle is empty. Start by sending a request from the Matches tab.';
	@override String get circleNoPending => 'No pending requests.';
	@override String get circleBuddyRequest => 'Friend request';
	@override String get circleMentorRequest => 'Mentor request';
	@override String get accept => 'Accept';
	@override String get reject => 'Decline';
	@override String get accepted => 'You are now connected.';
	@override String get rejected => 'Request declined.';
	@override String get removeBuddy => 'Remove connection';
	@override String removeBuddyConfirm({required Object name}) => 'Remove your connection with ${name}?';
	@override String get removed => 'Connection removed.';
	@override String get requestNote => 'Request note';
	@override String get withdraw => 'Withdraw request';
	@override String get withdrawn => 'Request withdrawn.';
	@override String distance({required Object km}) => '${km} km away';
	@override String get noCity => 'City not specified';
	@override String get commPrefWriting => 'Prefers messaging first';
	@override String get commPrefVideo => 'Open to video calls';
	@override String get commPrefEvening => 'Usually replies in the evening';
	@override String get scoresTitle => 'Match details';
	@override String get scoreTag => 'Tags';
	@override String get scoreAge => 'Age';
	@override String get scoreSensory => 'Sensory';
	@override String get scoreTherapy => 'Therapy';
	@override String get scoreEducation => 'Education';
}

// Path: groups
class _Translations$groups$en extends Translations$groups$tr {
	_Translations$groups$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String chatUnread({required Object count}) => 'Chat (${count})';
	@override String get detailTitle => 'Group details';
	@override String get detailHint => 'Members and meetings are visible to group members only.';
	@override String get membersTitle => 'Members';
	@override String get membersEmpty => 'Member list is not available.';
	@override String get membersOnly => 'Join the group to see members and meetings.';
	@override String get meetingsTitle => 'Meetings';
	@override String get meetingsEmpty => 'No meetings scheduled.';
	@override String get meetingAdd => 'Schedule meeting';
	@override String get meetingTitleLabel => 'Meeting title';
	@override String get meetingPickDate => 'Pick date';
	@override String get meetingPickTime => 'Pick time';
	@override String get meetingUrlLabel => 'Meeting link (optional)';
	@override String get meetingNoteLabel => 'Description (optional)';
	@override String get meetingSave => 'Save';
	@override String get meetingCreated => 'Meeting scheduled.';
	@override String get meetingJoin => 'Join meeting';
	@override String get meetingDelete => 'Cancel meeting';
	@override String meetingDeleteConfirm({required Object title}) => 'Cancel the meeting "${title}"?';
	@override String get meetingErrorTitle => 'Meeting title is required.';
	@override String get meetingErrorDate => 'Pick a date and time.';
	@override String get meetingErrorUrl => 'The link must start with http:// or https://.';
	@override String get title => 'Support Groups';
	@override String get subtitle => 'Meet families on similar topics and join the group chat.';
	@override String get tabMy => 'My Groups';
	@override String get tabDiscover => 'Discover';
	@override String get searchHint => 'Search groups…';
	@override String get allCategories => 'All';
	@override String get emptyMy => 'You haven\'t joined any group yet. Browse groups in the Discover tab.';
	@override String get emptyDiscover => 'No groups match these criteria. You can create a new one.';
	@override String memberCount({required Object count}) => '${count} members';
	@override String expertCount({required Object count}) => '${count} experts';
	@override String get verified => 'Verified';
	@override String get join => 'Join';
	@override String get joined => 'Joined';
	@override String get leave => 'Leave';
	@override String get chat => 'Group Chat';
	@override String get joinedMsg => 'You joined the group.';
	@override String get leftMsg => 'You left the group.';
	@override String get leaveTitle => 'Leave Group';
	@override String get leaveConfirm => 'Are you sure you want to leave this group?';
	@override String get add => 'Create Group';
	@override String get addTitle => 'New Group';
	@override String get nameLabel => 'Group Name';
	@override String get nameHint => 'e.g. Istanbul Early Intervention';
	@override String get descriptionLabel => 'Description';
	@override String get descriptionHint => 'What is the group about, who can join?';
	@override String get categoryLabel => 'Category';
	@override String get create => 'Create';
	@override String get created => 'Group created.';
	@override String get errorName => 'Please enter a group name.';
}

// Path: treatment
class _Translations$treatment$en extends Translations$treatment$tr {
	_Translations$treatment$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Treatment Panel';
	@override String get subtitle => 'Daily Support Plan';
	@override String get programActiveDefault => 'The daily support plan is active';
	@override String programActive({required Object name}) => '${name} plan is active';
	@override String get selectChild => 'Select profile';
	@override String get noChildrenTitle => 'No child profile yet';
	@override String get noChildrenBody => 'Add a child profile first to build a treatment plan.';
	@override String get addChild => 'Add Child';
	@override String get saveError => 'Treatment data could not be saved; the change was rolled back.';
	@override String get tabToday => 'Today';
	@override String get tabGoals => 'Goals';
	@override String get tabGames => 'Games';
	@override String get tabTools => 'Tools';
	@override List<String> get daysShort => [
		'Sun',
		'Mon',
		'Tue',
		'Wed',
		'Thu',
		'Fri',
		'Sat',
	];
	@override String get onboardTitle => 'Hello! Start in 3 steps 👋';
	@override String get onboardBody => 'This page helps you track the small supports you can do with your child every day.';
	@override String get onboardStep1 => '1. In the Goals tab, write one small thing to track today.';
	@override String get onboardStep2 => '2. Try the 5-10 minute activities in the Games tab.';
	@override String get onboardStep3 => '3. After playing, pick "Easy / Struggled" — the system handles the rest.';
	@override String get todayTitle => 'Today\'s short plan';
	@override String get todaySubtitle => 'Pick an item, apply it, then mark it as done.';
	@override String streakDays({required Object count}) => '${count} day streak';
	@override String doneOf({required Object done, required Object total}) => '${done}/${total} done';
	@override String stepCount({required Object count}) => '${count} steps';
	@override String get emptyPlanTitle => 'No plan found for today.';
	@override String get emptyPlanBody => 'Short daily steps will appear here once you add goals.';
	@override String get planDone => 'Today\'s plan is complete.';
	@override String get planDoneSub => 'That\'s enough for today.';
	@override String get moodSaveTitle => 'Log today\'s mood';
	@override String get moodSaveSub => 'The plan adapts automatically to your child\'s state';
	@override String moodTodayLabel({required Object label}) => 'Today\'s mood: ${label}';
	@override String get moodPlanned => 'The plan was prepared for this state';
	@override String get moodLevel1 => 'Struggling';
	@override String get moodLevel2 => 'Sensitive';
	@override String get moodLevel3 => 'Balanced';
	@override String get moodLevel4 => 'Good';
	@override String get moodLevel5 => 'Great';
	@override String get suggestionsTitle => 'Things to watch today';
	@override String get latestNoteTitle => 'Latest note';
	@override String get defaultExpert => 'Expert Therapist';
	@override String get noNoteAuthor => 'Platform Therapy Module';
	@override String get noNoteRole => 'Automatic daily plan';
	@override String get noNoteBody => 'No expert note yet. Today\'s plan was prepared from your child\'s records.';
	@override String get noteEmptyContent => 'This note has no additional details.';
	@override String get weeklyTitle => 'Weekly summary';
	@override String get weeklySubtitle => 'This section only shows the overall picture.';
	@override String get legendGame => 'Games';
	@override String get legendGoal => 'Goals';
	@override String chartGames({required Object count}) => '${count} games';
	@override String chartGoal({required Object percent}) => '${percent}% goals';
	@override String get weekGamesTitle => 'Games this week';
	@override String get weekGamesDetail => 'Mini exercises repeated this week';
	@override String get weekGamesEmpty => 'You can plan the first game today';
	@override String get weekGoalsTitle => 'Goals completed';
	@override String get weekGoalsDetail => 'Total progress across all active skill areas';
	@override String get weekGoalsEmpty => 'You can add goals from the Goals tab';
	@override String get weekSessionsTitle => 'Upcoming sessions';
	@override String get weekSessionsDetail => 'Planned appointments or events';
	@override String get weekSessionsEmpty => 'No appointments planned yet';
	@override String get microTitle => 'Development areas';
	@override String get microSubtitle => 'Check here when you need the details.';
	@override String get microLinkedGame => 'Supporting game:';
	@override String get addGoalTitle => 'Add a Daily Goal';
	@override String get addGoalSubtitle => 'Write one small thing you want to track for your child today.';
	@override String get goalHint => 'e.g. Made eye contact twice';
	@override String get focusLabel => 'Goal area';
	@override String get dueDateLabel => 'Due date (optional)';
	@override String get addGoal => 'Add Goal';
	@override String get saving => 'Saving…';
	@override String get yourGoals => 'Goals you added';
	@override String get edit => 'Edit';
	@override String get delete => 'Delete';
	@override String get save => 'Save';
	@override String get cancel => 'Cancel';
	@override String get goalAdded => 'New goal added.';
	@override String get goalUpdated => 'Goal updated.';
	@override String get goalEdited => 'Goal edited.';
	@override String get goalDeleted => 'Goal deleted.';
	@override String get groupsHeader => 'Therapy Goals — Progress by Area';
	@override String groupDone({required Object done, required Object total}) => '${done}/${total} completed';
	@override String get statusDone => 'Done';
	@override String get statusActive => 'Active';
	@override String get statusUpcoming => 'Queued';
	@override String get emptyGroupsTitle => 'No therapy goals yet';
	@override String get emptyGroupsBody => 'Goals are listed here automatically once a therapy type is added to your child\'s profile.';
	@override String get milestoneTitle => 'Record a Big Win 🏅';
	@override String get milestoneSubtitle => 'An important moment you want to remember';
	@override String get milestoneHint => 'e.g. Said their name for the first time';
	@override String get milestoneSaved => 'Milestone saved 🎉';
	@override String get notesTitle => 'Recent Observation Notes';
	@override String get notesEmpty => 'No expert or parent notes for this child yet.';
	@override String get upcomingTitle => 'Upcoming Events';
	@override String get upcomingEmpty => 'No active sessions or events planned soon.';
	@override String get goAppointments => 'Appointments';
	@override String get goCalendar => 'Open Calendar';
	@override String get gamesTitle => 'Daily Activities';
	@override String get gamesSubtitle => 'Short activities suggested from your child\'s therapy goals. Pick how it went after playing.';
	@override String todayDone({required Object done, required Object total}) => '${done}/${total} done today';
	@override String get filterAll => 'All';
	@override String get gameReady => 'Ready';
	@override String get gameDoneBadge => '✅ Done';
	@override String methodLabel({required Object name}) => 'Method: ${name}';
	@override String get whyGood => 'Why it helps';
	@override String goalBadge({required Object name}) => 'Goal: ${name}';
	@override String toolBadge({required Object name}) => 'Tool: ${name}';
	@override String get playToday => 'Play today';
	@override String get playedToday => 'Marked as done';
	@override String get feedbackQuestion => 'How did it go? (optional)';
	@override String get fbNone => 'No result selected yet';
	@override String get fbEasy => 'Very easy';
	@override String get fbAssisted => 'With help';
	@override String get fbIndependent => 'On their own';
	@override String get fbChallenging => 'Struggled';
	@override String get fbEasyLong => 'Found it easy';
	@override String get fbAssistedLong => 'Did it with help';
	@override String get fbIndependentLong => 'Did it independently';
	@override String get fbChallengingLong => 'Struggled';
	@override String get feedbackSaved => 'Game feedback saved.';
	@override String get allDoneTitle => '🎉 All of today\'s games are done. You\'re doing great!';
	@override String get allDoneBody => 'You completed today\'s support flow; you can add a short observation to the notes if you like.';
	@override String get hintMastered => 'Mastered it! Try a harder variant.';
	@override String get hintEasy => 'Finding it very easy. Increase the difficulty.';
	@override String get hintChallenging => 'Struggling. Break the activity into smaller parts.';
	@override String get notifyExpert => 'Notify Expert';
	@override String notifyBody({required Object game}) => 'Send your expert a short note about the difficulty in ${game}.';
	@override String notifyDefaultMsg({required Object game}) => '"${game}" aktivitesinde son zamanlarda zorlanıyor. Önerisi olan var mı?';
	@override String get notifyNoExpert => 'You haven\'t messaged an expert yet. Connect with an expert first.';
	@override String get notifySeeExperts => 'View Experts';
	@override String get notifySend => 'Send';
	@override String get notifySent => 'Expert notified.';
	@override String get emptyGames => 'No activities suggested for this area yet. They appear once therapy info is added to your child\'s profile.';
	@override String get historyTitle => 'Game History';
	@override String get historySubtitle => 'The history of played activities appears here.';
	@override String historyCount({required Object count}) => '${count} records';
	@override String get historyEmpty => 'No game records yet. History appears after the first record.';
	@override String challengingSummary({required Object count}) => '💪 "Struggled" was marked in ${count} activities. Consider breaking them into smaller steps or notifying your expert when retrying.';
	@override String get storiesTitle => 'Social Stories & Visual Flow';
	@override String get storiesSubtitle => 'Short picture stories that answer "What will happen?" before an activity — they ease transitions.';
	@override String get customBadge => 'Custom story';
	@override String linkedGoalBadge({required Object name}) => 'Linked goal: ${name}';
	@override String get addStoryTitle => 'Add a Custom Social Story';
	@override String get storyTitleHint => 'Story title (e.g. Going Shopping)';
	@override String get storyGoalHint => 'Linked goal (optional)';
	@override String get storyAdd => 'Add';
	@override String get storyAdded => 'Social story added.';
	@override String get storyDeleted => 'Story deleted.';
	@override String get deleteStoryTitle => 'Delete Story';
	@override String get deleteStoryConfirm => 'Are you sure you want to delete this story?';
	@override String get sensoryTitle => 'Comfort Settings';
	@override String get sensorySubtitle => 'Measurement Cards';
	@override String get sensorySaved => 'Sensory profile updated.';
	@override String get sliderHeader => 'Sensory Sensitivity Levels';
	@override String get sliderSound => '🔊 Sound Sensitivity';
	@override String get sliderTouch => '🖐️ Tactile Sensitivity';
	@override String get sliderVisual => '👁️ Visual Sensitivity';
	@override String get metricSound => 'Sound sensitivity';
	@override String get metricTouch => 'Tactile sensitivity';
	@override String get metricVisual => 'Visual stimulus tolerance';
	@override String get metricSoundNote => 'Monitored together with the sensory break game during transitions.';
	@override String get metricTouchNote => 'Tactile stimuli are supported with turn-taking and pressure activities.';
	@override String get metricVisualNote => 'Kept in balance with visual stories and the timeline.';
	@override String get triggerTitle => 'Trigger Log';
	@override String get tokenTitle => 'Digital Token Board';
	@override String get tokenSubtitle => 'Pick a goal with your child. Add a star for each success. At 5 stars they earn the reward!';
	@override String get tokenRewardLabel => 'Target Reward';
	@override String get tokenRewardHint => 'e.g. Riding the swing 🛝';
	@override String get tokenSetReward => 'Set Reward';
	@override String get tokenActive => 'Active Reward';
	@override String tokenCollect({required Object count}) => 'Collect success stars (${count}/5)';
	@override String get tokenAdd => '⭐ Add Star';
	@override String get tokenFullTitle => 'Congrats! The token card is full';
	@override String tokenFullBody({required Object reward}) => 'Your child completed all the steps and earned ${reward}!';
	@override String get tokenReset => 'Reset Board';
	@override String get tokenDefaultReward => 'Going to the park 🛝';
	@override String get breathTitle => 'Breathing Exercise';
	@override String get breathBody => 'When your child feels overstimulated, use the breathing regulator in the Crisis Guide together.';
	@override String get breathOpen => 'Open Breathing Exercise';
	@override String get aiStoryTitle => 'Social Story with AI';
	@override String get aiStoryBody => 'Ask the AI Assistant for a short custom social story draft for a new situation.';
	@override String get aiStoryOpen => 'Open AI Assistant';
}

// Path: tasks
class _Translations$tasks$en extends Translations$tasks$tr {
	_Translations$tasks$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'My Assignments';
	@override String get subtitle => 'Tasks assigned by your expert appear here; submit them as you complete each one.';
	@override String get pendingLabel => 'Pending';
	@override String get completedLabel => 'Completed';
	@override String get progressLabel => 'How much is done';
	@override String overdueSummary({required Object count}) => '${count} task(s) are past their due date';
	@override String filterAll({required Object count}) => 'All (${count})';
	@override String filterPending({required Object count}) => 'To Do (${count})';
	@override String filterCompleted({required Object count}) => 'Submitted (${count})';
	@override String get emptyAll => 'No tasks have been assigned by an expert yet. When your expert sets new assignments you will see them here.';
	@override String get emptyPending => 'No pending tasks.';
	@override String get emptyCompleted => 'No completed tasks.';
	@override String get overdueBanner => 'Due date passed! Your expert is waiting for the submission.';
	@override String get difficultyEasy => 'Easy';
	@override String get difficultyMedium => 'Medium';
	@override String get difficultyHard => 'Hard';
	@override String dueLabel({required Object date}) => 'Due: ${date}';
	@override String get detailLabel => 'Task Details';
	@override String get openMaterial => 'Open Required Material';
	@override String get submitTask => 'Submit Task';
	@override String get submitted => 'Task submitted to your expert!';
	@override String get submissionsError => 'Could not load the submission record.';
	@override String get noSubmission => 'No submission record found for this task (it may be an old task).';
	@override String get yourNote => 'Your Note';
	@override String get evidenceLink => 'Attached Evidence / Video';
	@override String get expertFeedback => 'Expert Review';
	@override String get expertApprovedNoNote => 'The expert approved but left no note.';
	@override String get awaitingReview => 'Awaiting expert review…';
	@override String get submitTitle => 'Submit Task';
	@override String get selectedTask => 'Selected Task';
	@override String get noteLabel => 'Note for Your Expert';
	@override String get noteHint => 'How did your child feel doing this task? (e.g. Completed it very comfortably)';
	@override String get evidenceLabel => 'Evidence / Attachment Link (Optional)';
	@override String get evidenceHint => 'You can add a cloud link to a video or photo of the practice moment so your expert can see it.';
	@override String get submitConfirm => 'Submit and Close';
	@override String get viewWizard => 'Wizard';
	@override String get viewList => 'List';
	@override String get wizardBadge => 'Daily Progress Flow';
	@override String get wizardTitle => 'Today\'s Exercise Guide';
	@override String get wizardIntro => 'Practise with your child by following the steps. When you are done, just tap one of the options below.';
	@override String wizardStageLevel({required Object label}) => '${label} level';
	@override String wizardStageCount({required Object done, required Object total}) => '${done} / ${total} exercises completed';
	@override String get wizardAllDoneTitle => 'Great work! Today\'s exercises are all done';
	@override String get wizardAllDoneBody => 'Every quality minute you spend with your child makes a big difference. New tasks will appear here when they are assigned.';
	@override String wizardStepCounter({required Object index, required Object total}) => '${index} / ${total}';
	@override String get wizardDefaultCategory => 'Development Exercise';
	@override String get wizardHowTo => 'How to do it (step by step)';
	@override String get wizardDefaultDescription => 'Try this activity with your child for 5-10 minutes in a calm setting.';
	@override String wizardFrequency({required Object value}) => 'Frequency: ${value}';
	@override String get wizardOutcomeQuestion => 'How did this exercise go today?';
	@override String get outcomeEasyTitle => 'We did it easily';
	@override String get outcomeEasyDesc => 'My child managed it comfortably';
	@override String get outcomeSupportedTitle => 'We did it with support';
	@override String get outcomeSupportedDesc => 'We finished it with a few prompts';
	@override String get outcomeHardTitle => 'Today was hard';
	@override String get outcomeHardDesc => 'We were not quite ready yet';
	@override String get wizardTipTitle => 'AutiBot tip';
	@override String get wizardTipBody => 'No problem at all. Motivation can change day to day for children on the autism spectrum. Try breaking the exercise into smaller parts and repeating it tomorrow in a shorter, 2-minute session. You can also leave a note for your expert.';
	@override String get wizardNoteLabel => 'A note for your expert (optional)';
	@override String get wizardNoteHint => 'e.g. Really enjoyed it, or got distracted quickly…';
	@override String get wizardAddPhoto => 'Add a photo of the moment';
	@override String get wizardChangePhoto => 'Change photo';
	@override String get wizardPhotoAdded => 'Photo added';
	@override String get wizardRemovePhoto => 'Remove';
	@override String get wizardSourceGallery => 'Choose from gallery';
	@override String get wizardSourceCamera => 'Take a photo';
	@override String get wizardSubmit => 'Save and complete exercise';
	@override String get wizardSubmitted => 'Congratulations! Today\'s exercise is complete 🎉';
	@override String get wizardDone => 'This exercise has been submitted';
	@override String get wizardDoneHint => 'It reached your expert; you can move on to the next exercise.';
	@override String get wizardPrev => 'Previous exercise';
	@override String get wizardNext => 'Next exercise';
	@override String get wizardTreeTitle => 'Your child\'s progress tree';
	@override String get stageSeed => 'Seed';
	@override String get stageSeedDesc => 'A new journey is beginning';
	@override String get stageSprout => 'Sprout';
	@override String get stageSproutDesc => 'Awareness and settling-in phase';
	@override String get stageFlower => 'Flower';
	@override String get stageFlowerDesc => 'Regular practice together';
	@override String get stageTree => 'Tree';
	@override String get stageTreeDesc => 'Wonderful! The skill is fully independent';
}

// Path: forum
class _Translations$forum$en extends Translations$forum$tr {
	_Translations$forum$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Community Forum';
	@override String get typeExperience => 'Experiences';
	@override String get typeQuestion => 'Q&A';
	@override String get typeAdvice => 'Advice';
	@override String get typeSuccess => 'Success Stories';
	@override String get catCommunication => 'Communication';
	@override String get catSocial => 'Social';
	@override String get catSensory => 'Sensory';
	@override String get catBehavior => 'Behavior';
	@override String get catMotor => 'Motor';
	@override String get catEducation => 'Education';
	@override String get justNow => 'just now';
	@override String minsAgo({required Object count}) => '${count} min ago';
	@override String hoursAgo({required Object count}) => '${count} h ago';
	@override String daysAgo({required Object count}) => '${count} d ago';
	@override String get searchHint => 'Search the forum…';
	@override String get tagFilter => 'Tag filter';
	@override String get sortNew => 'New';
	@override String get sortHot => 'Hot';
	@override String get sortUnanswered => 'Unanswered';
	@override String get sortExpert => 'Expert';
	@override String get empty => 'No posts yet. Start by sharing an experience with the community.';
	@override String get emptyQuestion => 'No questions yet. Ask the first question to start the discussion.';
	@override String get add => 'Share';
	@override String get loadMore => 'Load More';
	@override String get posted => 'Post shared.';
	@override String get anonymousUser => 'Anonymous User';
	@override String get expertBadge => 'Expert';
	@override String get pinnedBadge => 'Pinned';
	@override String get answeredBadge => 'Answered';
	@override String get postTitle => 'Post';
	@override String commentsHeader({required Object count}) => 'Comments (${count})';
	@override String get commentsError => 'Could not load comments.';
	@override String get noComments => 'No comments yet. Be the first to write one.';
	@override String get commentHint => 'Write a comment…';
	@override String get replyHint => 'Write your reply…';
	@override String replyingTo({required Object name}) => 'Replying to ${name}';
	@override String get reply => 'Reply';
	@override String get acceptAnswer => 'Best Answer';
	@override String get answerAccepted => 'Marked as best answer.';
	@override String get acceptedBadge => 'Best Answer';
	@override String get expertApproved => 'Expert Approved';
	@override String get editComment => 'Edit Comment';
	@override String get deleteCommentTitle => 'Delete Comment';
	@override String get deleteCommentConfirm => 'Are you sure you want to delete this comment?';
	@override String get deleteTitle => 'Delete Post';
	@override String get deleteConfirm => 'Are you sure you want to delete this post?';
	@override String get cancel => 'Cancel';
	@override String get delete => 'Delete';
	@override String get save => 'Save';
	@override String get reportTitle => 'Report';
	@override String get reportHint => 'Briefly describe the reason for your report';
	@override String get reportSend => 'Send';
	@override String get reportSent => 'Your report has been received.';
	@override String get newPost => 'New Post';
	@override String get editPost => 'Edit Post';
	@override String get titleLabel => 'Title';
	@override String get titleHintQuestion => 'Briefly summarize your question';
	@override String get titleHint => 'Title of your post';
	@override String get contentLabel => 'Content';
	@override String get tagsLabel => 'Symptom Tags';
	@override String get anonymousTitle => 'Share Anonymously';
	@override String get anonymousBody => 'Your profile details are hidden; you appear as "Anonymous User".';
	@override String get privacyTitle => 'Privacy Settings';
	@override String get privacyRealName => 'Show my real name';
	@override String get privacyChildAge => 'Show my child\'s age range';
	@override String get privacySymptoms => 'Show symptom tags';
	@override String get privacyDiagnosis => 'Show diagnosis details';
	@override String get privacyMatching => 'Allow use in the matching algorithm';
	@override String get share => 'Share';
}

// Path: childDetail
class _Translations$childDetail$en extends Translations$childDetail$tr {
	_Translations$childDetail$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Child Profile';
	@override String get editProfile => 'Edit Profile';
	@override String ageYears({required Object age}) => '${age} yrs';
	@override String get genderBoy => 'Boy';
	@override String get genderGirl => 'Girl';
	@override String get photoUpdated => 'Profile photo updated.';
	@override String get infoTitle => 'Details';
	@override String get infoEmpty => 'No diagnosis/education info yet. You can edit the profile from the top right.';
	@override String get diagnosis => 'Diagnosis Info';
	@override String get educationProgram => 'Education Program';
	@override String get therapies => 'Therapies';
	@override String get tagsTitle => 'Symptom Tags';
	@override String get tagsEmpty => 'No tags selected yet. Tags are used in similar-family matching and the forum.';
	@override String get tagsEdit => 'Edit Tags';
	@override String get tagsError => 'Could not load tags.';
	@override String get edit => 'Edit';
	@override String get save => 'Save';
	@override String get cancel => 'Cancel';
	@override String get delete => 'Delete';
	@override String get milestonesTitle => 'Milestones';
	@override String get milestonesEmpty => 'No milestones yet. Record the first big achievement!';
	@override String get milestonesError => 'Could not load milestones.';
	@override String get milestoneAdd => 'Add';
	@override String get milestoneEdit => 'Edit Milestone';
	@override String get milestoneTitleLabel => 'Title';
	@override String get milestoneTitleHint => 'e.g. Made eye contact for the first time';
	@override String get milestoneDescLabel => 'Description (optional)';
	@override String get milestoneSave => 'Add Milestone';
	@override String get milestoneDeleteTitle => 'Delete Milestone';
	@override String get milestoneDeleteConfirm => 'Are you sure you want to delete this record?';
	@override String get screeningTitle => 'Screening Results';
	@override String get screeningEmpty => 'No screening results yet.';
	@override String scoreOf({required Object score}) => '${score}/20';
	@override String get riskLow => 'Low risk';
	@override String get riskMedium => 'Medium risk';
	@override String get riskHigh => 'High risk';
	@override String get shortcutsTitle => 'Quick Access';
	@override String get shortcutTracker => 'Daily Tracker';
	@override String get shortcutBehavior => 'Behavior Journal';
	@override String get shortcutTreatment => 'Treatment Panel';
	@override String get shortcutAnalytics => 'Progress Panel';
}

// Path: crisis
class _Translations$crisis$en extends Translations$crisis$tr {
	_Translations$crisis$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Crisis Guide';
	@override String get heroTitle => 'What To Do in Hard Moments?';
	@override String get heroSubtitle => 'A quick guide to help you stay calm and take the right steps when your child is overwhelmed.';
	@override String get breathingTitle => 'Breathing Regulator';
	@override String get breathingSubtitle => 'Calm yourself first. Start and match your breathing to the ring\'s expand-and-shrink pace.';
	@override String get breathingStart => 'Start Exercise';
	@override String get breathingStop => 'Stop';
	@override String get breathingReady => 'Ready';
	@override String get breathingReadyHint => 'Tap to start';
	@override String get breathingInhale => 'Breathe In';
	@override String get breathingExhale => 'Breathe Out';
	@override String get breathingSeconds => 'seconds';
	@override String get stepsLabel => 'What To Do?';
	@override String get avoidLabel => 'What To Avoid';
	@override String get emergencyLabel => 'Suggested Emergency Line';
	@override String get contactsTitle => 'Emergency Numbers';
	@override String get disclaimer => 'This guide is for general information; in emergencies or medical situations always call your local emergency number.';
	@override String get contact112Label => 'Emergency Health and Safety';
	@override String get contact112Desc => 'Ambulance, Police, Fire';
	@override String get contact183Label => 'Social Support Line';
	@override String get contact183Desc => 'Family, Children and Social Services';
	@override String get listen => 'Listen';
	@override String get listenStop => 'Stop';
	@override String get listenIntro => 'What to do';
	@override String get listenUnavailable => 'Speech playback is not available on this device.';
	@override String get medicalTitle => 'Important medical warning';
	@override String get medicalBody => 'This guide does not replace professional medical or psychiatric care. In case of loss of consciousness, a severe seizure, breathing difficulty or serious harm, call your local emergency number immediately.';
	@override String get medicalMore => 'More details';
	@override String get quickTipTitle => 'First rule';
	@override String get quickTipBody => 'Stay calm yourself. Your child mirrors your emotional state. Take a deep breath and move slowly.';
	@override String get afterTitle => 'After the crisis — recovery time';
	@override List<String> get afterItems => [
		'Stay quietly with your child in a calm setting; do not push them to talk.',
		'Let them feel loved and safe.',
		'Note the triggers (date, time, setting, what happened before).',
		'Tell your expert team about the crisis.',
		'Make time for yourself too — caregivers get tired as well.',
	];
	@override late final _Translations$crisis$cards$en cards = _Translations$crisis$cards$en._(_root);
}

// Path: calendar
class _Translations$calendar$en extends Translations$calendar$tr {
	_Translations$calendar$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Calendar';
	@override String get subtitle => 'Child-specific therapy, doctor and activity schedule.';
	@override String get noChild => 'Add a child first to use the calendar.';
	@override String get empty => 'No events yet. Add the first one.';
	@override String get add => 'Add Event';
	@override String get addTitle => 'New Event';
	@override String get editTitle => 'Edit Event';
	@override String get eventType => 'Event Type';
	@override String get typeTerapi => 'Therapy';
	@override String get typeDoktor => 'Doctor';
	@override String get typeEgitim => 'Education';
	@override String get typeAktivite => 'Activity';
	@override String get typeAppointment => 'Appointment';
	@override String get typeDiger => 'Other';
	@override String get eventTitle => 'Title';
	@override String get titleHint => 'Event name';
	@override String get location => 'Location';
	@override String get locationHint => 'Clinic name, address';
	@override String get description => 'Description';
	@override String get start => 'Start';
	@override String get end => 'End (optional)';
	@override String get reminder => 'Reminder';
	@override String get reminderOff => 'Off';
	@override String reminderMin({required Object count}) => '${count} min before';
	@override String reminderHour({required Object count}) => '${count} h before';
	@override String get reminderDay => '1 day before';
	@override String get statusPlanned => 'Planned';
	@override String get statusCompleted => 'Completed';
	@override String get statusCancelled => 'Cancelled';
	@override String get markCompleted => 'Mark completed';
	@override String get markPlanned => 'Mark planned';
	@override String get markCancelled => 'Cancel event';
	@override String get today => 'Today';
	@override String get tomorrow => 'Tomorrow';
	@override String get save => 'Save';
	@override String get saved => 'Event saved.';
	@override String get deleteTitle => 'Delete Event';
	@override String deleteConfirm({required Object title}) => 'Are you sure you want to delete "${title}"?';
	@override String get deleted => 'Event deleted.';
	@override String get errorTitle => 'Please enter a title.';
	@override String get cancel => 'Cancel';
	@override String get delete => 'Delete';
}

// Path: emergency
class _Translations$emergency$en extends Translations$emergency$tr {
	_Translations$emergency$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Emergency Card';
	@override String get subtitle => 'Information to show to anyone who meets your child in an emergency.';
	@override String get noChild => 'Add a child first to create an emergency card.';
	@override String lastUpdated({required Object date}) => 'Last updated ${date}';
	@override String get notSaved => 'This card has not been saved yet.';
	@override String get save => 'Save';
	@override String get saved => 'Emergency card saved.';
	@override String get shareTitle => 'Share with a QR code';
	@override String get shareBody => 'Create a time-limited link; a teacher or paramedic can open the card from it. You can revoke the link at any time.';
	@override String get shareConsentRequired => 'Sharing requires the "Emergency card sharing" consent.';
	@override String get shareOpenConsents => 'Open consent settings';
	@override String get shareDuration => 'Validity period';
	@override String get share24h => 'Valid for 24 hours';
	@override String get share3d => 'Valid for 3 days';
	@override String get share1w => 'Valid for 1 week';
	@override String get share30d => 'Valid for 30 days';
	@override String get shareEnable => 'Create share link';
	@override String get shareDisable => 'Turn sharing off';
	@override String shareValidUntil({required Object date}) => 'The link is valid until ${date}.';
	@override String get shareCopy => 'Copy link';
	@override String get shareCopied => 'Link copied.';
	@override String get shareSend => 'Share';
	@override String get shareMessage => 'You can view my child\'s emergency card here:';
	@override String get call => 'Call';
	@override String get sectionChild => 'Child Information';
	@override String get sectionContacts => 'Emergency Contacts';
	@override String get sectionMedical => 'Medical Information';
	@override String get sectionBehavior => 'Behavioral Information';
	@override String get childName => 'Full Name';
	@override String get birthDate => 'Date of Birth';
	@override String get diagnosis => 'Diagnosis';
	@override String get bloodType => 'Blood Type';
	@override String get communicationLevel => 'Communication Level';
	@override String get languages => 'Language(s) Spoken';
	@override String get warningsLabel => 'Special condition warnings';
	@override String get selfInjury => 'May exhibit self-injury';
	@override String get wandering => 'Risk of wandering / getting lost';
	@override String get nonVerbal => 'Non-verbal';
	@override String get contact1 => 'First Contact';
	@override String get contact2 => 'Second Contact';
	@override String get doctor => 'Doctor / Hospital';
	@override String get name => 'Full Name';
	@override String get phone => 'Phone';
	@override String get relation => 'Relationship';
	@override String get doctorName => 'Doctor Name';
	@override String get doctorPhone => 'Doctor Phone';
	@override String get hospital => 'Hospital';
	@override String get medications => 'Current Medications';
	@override String get medicationsHint => 'Name - dose - time (one medication per line)';
	@override String get allergies => 'Allergies';
	@override String get allergiesHint => 'Food, drug, substance allergies';
	@override String get conditions => 'Other Medical Conditions';
	@override String get conditionsHint => 'Epilepsy, heart condition, etc.';
	@override String get triggers => 'Triggers (to avoid)';
	@override String get triggersHint => 'What causes a crisis? E.g. sudden noise, crowds';
	@override String get calming => 'Calming Strategies';
	@override String get calmingHint => 'What helps? E.g. favorite music, quiet room';
	@override String get avoid => 'Things to Never Do';
	@override String get avoidHint => 'E.g. don\'t shout, don\'t restrain, don\'t force eye contact';
	@override String get special => 'Special Instructions';
	@override String get specialHint => 'Extra notes for emergency services or caregivers';
	@override String get select => 'Select...';
}

// Path: behavior
class _Translations$behavior$en extends Translations$behavior$tr {
	_Translations$behavior$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Behavior Journal';
	@override String get subtitle => 'ABC (Antecedent-Behavior-Consequence) observation log';
	@override String get add => 'Add Entry';
	@override String get addTitle => 'New ABC Entry';
	@override String get empty => 'No behavior entries yet. Add the first observation.';
	@override String get noChild => 'Add a child first to use the behavior journal.';
	@override String get date => 'Date';
	@override String get time => 'Time';
	@override String get category => 'Category';
	@override String get location => 'Location';
	@override String get antecedentLabel => 'A — Antecedent (Trigger)';
	@override String get antecedentHint => 'Describe the trigger';
	@override String get behaviorLabel => 'B — Behavior (What happened?)';
	@override String get behaviorHint => 'Describe the behavior in detail';
	@override String get consequenceLabel => 'C — Consequence (What did you do?)';
	@override String get consequenceHint => 'Describe your intervention';
	@override String get other => 'Other...';
	@override String get intensityLabel => 'Intensity';
	@override String get intensity1 => 'Very Mild';
	@override String get intensity2 => 'Mild';
	@override String get intensity3 => 'Moderate';
	@override String get intensity4 => 'Severe';
	@override String get intensity5 => 'Very Severe';
	@override String get notesLabel => 'Additional notes (optional)';
	@override String get save => 'Save';
	@override String get saved => 'ABC entry created.';
	@override String get deleteTitle => 'Delete Entry';
	@override String deleteConfirm({required Object date}) => 'Are you sure you want to delete the ABC entry dated ${date}?';
	@override String get deleted => 'Entry deleted.';
	@override String get errorRequired => 'Please fill the required fields (category, location, A, B, C).';
}

// Path: analytics
class _Translations$analytics$en extends Translations$analytics$tr {
	_Translations$analytics$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Development Panel';
	@override String get subtitle => 'Development trends over the last 6 months.';
	@override String get milestones => 'Milestones';
	@override String get milestonesUnit => 'achievements per month';
	@override String get mood => 'Average Mood';
	@override String get moodUnit => 'monthly average (1-5)';
	@override String get sleep => 'Average Sleep';
	@override String get sleepUnit => 'hours per night (monthly average)';
	@override String get behavior => 'Behavior Logs';
	@override String get behaviorUnit => 'entries per month';
	@override String get noData => 'No data in this range yet.';
	@override String get noChild => 'Add a child first to see the development panel.';
	@override String get aiTitle => 'AI analysis';
	@override String get aiSubtitle => 'Summarises patterns in your child\'s records; it does not diagnose.';
	@override String get aiTypeGeneral => 'General';
	@override String get aiTypeBehavioral => 'Behaviour';
	@override String get aiTypeProgress => 'Progress';
	@override String get aiTypeWeekly => 'Weekly';
	@override String aiStart({required Object type}) => 'Start the ${type} analysis';
	@override String get aiRunning => 'Preparing the analysis…';
	@override String get aiError => 'The analysis could not be fetched. Please try again.';
	@override String get aiDisclaimer => 'This summary is informational; it is not a medical diagnosis or treatment advice.';
	@override String get aiConsentTitle => 'AI analysis needs your consent';
	@override String get aiConsentBody => 'Analysing your child\'s records requires explicit consent. You can grant it on the privacy and consents page.';
	@override String get aiConsentAction => 'Manage consents';
	@override String rangeDays({required Object count}) => 'Last ${count} days';
	@override String get scoreTitle => 'Tracking score';
	@override String scoreCoverage({required Object count, required Object total}) => 'Records in ${count} of ${total} data types';
	@override String get scoreStrong => 'Strong tracking';
	@override String get scoreGrowing => 'Tracking is growing';
	@override String get scoreWaiting => 'Waiting for data';
	@override String get actionsTitle => 'Missing data';
	@override String get actionMood => 'Add a mood entry';
	@override String get actionSleep => 'Add a sleep entry';
	@override String get actionNote => 'Write a development note';
	@override String get actionMilestone => 'Add a milestone';
	@override String insightMoodHigh({required Object days, required Object value}) => 'Average mood over the last ${days} days is ${value}/5 — quite high.';
	@override String insightMoodLow({required Object days, required Object value}) => 'Average mood over the last ${days} days is ${value}/5 — there may be some difficulties.';
	@override String insightSleepShort({required Object value}) => 'Average sleep is ${value} — 8-10 hours is recommended for enough rest.';
	@override String insightSleepGood({required Object value}) => 'Sleep looks good: ${value} on average.';
	@override String insightMilestones({required Object category, required Object count}) => 'Most milestones are in "${category}" (${count} of them).';
	@override String insightAppointments({required Object count}) => '${count} appointments completed.';
	@override String insightAppointmentsWithPending({required Object count, required Object pending}) => '${count} appointments completed, ${pending} still active.';
	@override String get dailyMood => 'Mood trend';
	@override String get dailyMoodUnit => 'daily entry (1-5)';
	@override String get dailySleep => 'Sleep pattern';
	@override String get dailySleepUnit => 'nightly duration (hours)';
	@override String get dailySleepQuality => 'quality (1-5)';
	@override String get behaviorCategories => 'Behaviour categories';
	@override String get behaviorCategoriesUnit => 'entry count and average intensity';
	@override String get milestoneCategories => 'Milestones';
	@override String get milestoneCategoriesUnit => 'achievements by category';
	@override String get notesActivity => 'Note activity';
	@override String get notesActivityUnit => 'notes per month';
	@override String countWithIntensity({required Object count, required Object intensity}) => '${count} · avg ${intensity}';
	@override String get exportCsv => 'Share as CSV';
	@override String get exportEmpty => 'Nothing to share yet.';
}

// Path: children
class _Translations$children$en extends Translations$children$tr {
	_Translations$children$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'My Children';
	@override String get addTitle => 'Add Child';
	@override String get editTitle => 'Edit Child';
	@override String get empty => 'You haven\'t added any children yet.';
	@override String get add => 'Add Child';
	@override String get nameLabel => 'Full Name';
	@override String get nameHint => 'Child\'s name';
	@override String get birthDateLabel => 'Birth Date (optional)';
	@override String get birthDateSelect => 'Select date';
	@override String get genderLabel => 'Gender (optional)';
	@override String get genderMale => 'Boy';
	@override String get genderFemale => 'Girl';
	@override String get diagnosisLabel => 'Diagnosis Info (optional)';
	@override String get diagnosisHint => 'Diagnosis info, if any';
	@override String get educationLabel => 'Education Program (optional)';
	@override String get educationHint => 'Current education program';
	@override String get therapiesLabel => 'Therapies (optional)';
	@override String get therapiesHint => 'Therapies received';
	@override String ageYears({required Object years}) => '${years} yrs';
	@override String get save => 'Save';
	@override String get cancel => 'Cancel';
	@override String get delete => 'Delete';
	@override String get deleteTitle => 'Delete Child';
	@override String deleteConfirm({required Object name}) => 'Are you sure you want to delete ${name}\'s profile?';
	@override String get errorNameRequired => 'Please enter the child\'s name.';
	@override String get created => 'Child profile created.';
	@override String get updated => 'Child profile updated.';
	@override String get deleted => 'Child profile deleted.';
}

// Path: account
class _Translations$account$en extends Translations$account$tr {
	_Translations$account$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Account Information';
	@override String get emailLabel => 'Email';
	@override String get fullNameLabel => 'Full Name';
	@override String get phoneLabel => 'Phone';
	@override String get phoneHint => '05XX XXX XX XX';
	@override String get cityLabel => 'City';
	@override String get expertTitleLabel => 'Expert Title';
	@override String get institutionLabel => 'Institution';
	@override String get licenseNumberLabel => 'License Number';
	@override String get bioLabel => 'About';
	@override String get bioHint => 'Briefly describe your experience';
	@override String get save => 'Save';
	@override String get saved => 'Profile updated.';
	@override String get errorFullName => 'Full name must be at least 2 characters.';
}

// Path: help
class _Translations$help$en extends Translations$help$tr {
	_Translations$help$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Help & About';
	@override String get aboutTitle => 'About Otizm Destek';
	@override String get aboutBody => 'Otizm Destek is a mobile app that helps you track your child\'s development, connect with experts, and book appointments.';
	@override String get tipsTitle => 'Tips';
	@override String get tip1 => 'Add your children under "My Children"; track goals and notes in the "Progress" tab.';
	@override String get tip2 => 'Pick an expert under "Experts" to book an appointment or send a message.';
	@override String get tip3 => 'Ask the AI Assistant questions about autism and child development.';
	@override String get contactTitle => 'Contact';
	@override String get contactBody => 'Reach us from within the app for any questions or suggestions.';
	@override String version({required Object version}) => 'Version ${version}';
}

// Path: profile
class _Translations$profile$en extends Translations$profile$tr {
	_Translations$profile$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get defaultUser => 'User';
	@override String get accountInfo => 'Account Information';
	@override String get myChildren => 'My Children';
	@override String get showAllSections => 'Show all sections';
	@override String get help => 'Help';
	@override String get signOut => 'Sign Out';
}

// Path: errors
class _Translations$errors$en extends Translations$errors$tr {
	_Translations$errors$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get timeout => 'Could not reach the server, please try again.';
	@override String get noConnection => 'You appear to be offline.';
	@override String generic({required Object code}) => 'An error occurred (${code}).';
	@override String get cancelled => 'Request cancelled.';
	@override String get unexpected => 'An unexpected error occurred.';
	@override String get unexpectedResponse => 'Unexpected server response.';
	@override String get operationFailed => 'Operation failed.';
	@override String get noUserInResponse => 'No user information in the server response.';
}

// Path: guide
class _Translations$guide$en extends Translations$guide$tr {
	_Translations$guide$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'User Guide';
	@override String get subtitle => 'See your first steps, what each section does and the support channels — all in one place.';
	@override String get searchHint => 'Search for a section, topic or action…';
	@override String countLabel({required Object visible, required Object total}) => '${visible} / ${total} sections';
	@override String get searchEmpty => 'No section matches your search.';
	@override String get startTitle => 'Where to start?';
	@override String get startSubtitle => 'Work through them in order; each step opens the related section.';
	@override String get sectionsTitle => 'What is each section for?';
	@override String get sectionsSubtitle => 'Pick a category to see the sections it contains.';
	@override String get purposeLabel => 'What is it for?';
	@override String get whenLabel => 'When to use it';
	@override String get openPage => 'Open';
	@override String get videosTitle => 'Tutorial videos';
	@override String get videosSubtitle => 'Short walkthroughs. Videos play in the web version; tapping one opens it in your browser.';
	@override String get videoWatch => 'Watch';
	@override String get videoWatched => 'Watched';
	@override String get videoMarkWatched => 'Mark as watched';
	@override String videoProgress({required Object done, required Object total}) => '${done} / ${total} videos watched';
	@override String get videoOpenError => 'The video link could not be opened.';
	@override String get videoCategoryStart => 'Getting started';
	@override String get videoCategoryChild => 'Child and development';
	@override String get videoCategoryTracking => 'Daily tracking';
	@override String get videoCategoryPlan => 'Plans and appointments';
	@override String get videoCategoryCommunity => 'Communication and community';
	@override String get videoCategorySupport => 'Safety and support';
	@override String get badgeDaily => 'Every day';
	@override String get badgeQuickLog => 'Quick log';
	@override String get badgeQuickHelp => 'Quick help';
	@override String get badgeFirstStep => 'First step';
	@override String get badgeSetup => 'First setup';
	@override String get badgeRoutine => 'Daily routine';
	@override String get badgeClinical => 'Clinical support';
	@override String get badgePrivacy => 'Privacy';
	@override String get badgeCalendar => 'Calendar';
	@override String get badgeCommunication => 'Communication';
	@override String get badgeProfile => 'Profile';
	@override String get groupDaily => 'Daily';
	@override String get groupDailyDesc => 'The home, tracking and quick-support sections you will use every day.';
	@override String get groupChild => 'My child';
	@override String get groupChildDesc => 'Your child\'s development, profile details, exercises and special-situation records.';
	@override String get groupCommunity => 'Community';
	@override String get groupCommunityDesc => 'Sharing experiences, the forum, local meetups and contact with other families.';
	@override String get groupExpertWork => 'Workspace';
	@override String get groupExpertWorkDesc => 'Appointment, communication and professional resource sections.';
	@override String get startChild => 'Create your child\'s profile';
	@override String get startChildDesc => 'Enter the basics, diagnosis notes and needs so there is a child to track.';
	@override String get startTracker => 'Add your first daily record';
	@override String get startTrackerDesc => 'Keep sleep, mood, medication and observations organised with short entries.';
	@override String get startAppointment => 'Book an appointment with an expert';
	@override String get startAppointmentDesc => 'Pick a suitable expert, request an appointment and follow the session flow.';
	@override String get startPrivacy => 'Review your sharing consents';
	@override String get startPrivacyDesc => 'Manage which data is processed for which purpose from the consent screen.';
	@override String get startExpertCalendar => 'Manage appointments';
	@override String get startExpertCalendarDesc => 'Approve requests, complete sessions and keep families informed.';
	@override String get startExpertMessages => 'Reach out to families';
	@override String get startExpertMessagesDesc => 'Answer questions through secure messaging and keep the follow-up going.';
	@override String get startExpertProfile => 'Complete your expert profile';
	@override String get startExpertProfileDesc => 'Keep your title, specialisations and contact details up to date.';
	@override String get pageHome => 'Home';
	@override String get pageHomePurpose => 'Shows today\'s to-dos, reminders and the short daily plan in one place.';
	@override String get pageHomeWhen => 'Every time you open the app and want to know what today holds.';
	@override String get pageHomeKeywords => 'home, start, task, today, dashboard';
	@override String get pageTracker => 'Daily Tracking';
	@override String get pageTrackerPurpose => 'Used to record mood, sleep, medication and short daily observations.';
	@override String get pageTrackerWhen => 'At the end of the day or when something notable changes.';
	@override String get pageTrackerKeywords => 'daily, mood, sleep, medication, record';
	@override String get pageMessages => 'Messages';
	@override String get pageMessagesPurpose => 'A secure space to write to experts and other people on the platform.';
	@override String get pageMessagesWhen => 'When you want to message about an appointment, a question or a follow-up.';
	@override String get pageMessagesKeywords => 'message, chat, contact, expert';
	@override String get pageAppointments => 'Appointments';
	@override String get pageAppointmentsPurpose => 'Manages appointment requests, session times and the meeting flow.';
	@override String get pageAppointmentsWhen => 'When planning a session or checking upcoming appointments.';
	@override String get pageAppointmentsKeywords => 'appointment, calendar, session, doctor, therapy';
	@override String get pageCrisis => 'What to do in hard moments';
	@override String get pageCrisisPurpose => 'Quickly shows calming and intervention steps for difficult moments.';
	@override String get pageCrisisWhen => 'During a crisis, intense stress or when you need fast guidance.';
	@override String get pageCrisisKeywords => 'crisis, hard moment, calming, emergency, breathing';
	@override String get pageAssistant => 'AI Assistant';
	@override String get pageAssistantPurpose => 'A chat assistant that answers instantly; it does not give medical advice, it points you in the right direction.';
	@override String get pageAssistantWhen => 'When you want a quick answer to something on your mind.';
	@override String get pageAssistantKeywords => 'assistant, chat, ai, question, bot';
	@override String get pageSettings => 'Settings';
	@override String get pageSettingsPurpose => 'Manages notification, privacy and accessibility preferences, theme and language, your password and your account.';
	@override String get pageSettingsWhen => 'When you want to tailor the app or manage your data.';
	@override String get pageSettingsKeywords => 'settings, notification, privacy, password, theme, language, accessibility';
	@override String get pageHelp => 'Help';
	@override String get pageHelpPurpose => 'Short information about the app, usage tips and contact channels.';
	@override String get pageHelpWhen => 'When you cannot work out how a feature behaves.';
	@override String get pageHelpKeywords => 'help, support, faq, contact';
	@override String get pageChildren => 'My Children';
	@override String get pageChildrenPurpose => 'Keeps your child\'s basics, diagnosis notes, therapy and needs.';
	@override String get pageChildrenWhen => 'During first setup or when child details change.';
	@override String get pageChildrenKeywords => 'child, profile, diagnosis, therapy, milestone';
	@override String get pageAnalytics => 'Progress Dashboard';
	@override String get pageAnalyticsPurpose => 'Turns daily records into charts and monthly trends.';
	@override String get pageAnalyticsWhen => 'When you want the bigger picture rather than single entries.';
	@override String get pageAnalyticsKeywords => 'progress, chart, analysis, trend, development';
	@override String get pageTreatment => 'Support Plan';
	@override String get pageTreatmentPurpose => 'Collects small goals, home practice, games and the daily support flow.';
	@override String get pageTreatmentWhen => 'When looking for a short activity or goal to try at home today.';
	@override String get pageTreatmentKeywords => 'treatment, plan, goal, activity, game, home practice';
	@override String get pageTasks => 'My Tasks';
	@override String get pageTasksPurpose => 'Shows the tasks your expert assigned, the daily exercise wizard and submission status.';
	@override String get pageTasksWhen => 'When following up on work given after a session.';
	@override String get pageTasksKeywords => 'task, homework, exercise, expert, submission';
	@override String get pageNotes => 'My Notes';
	@override String get pageNotesPurpose => 'Stores behaviour, development, meeting or noteworthy events as free-form notes.';
	@override String get pageNotesWhen => 'For short observations you want to share with your expert or remember later.';
	@override String get pageNotesKeywords => 'note, observation, development, behaviour, reminder';
	@override String get pageBehavior => 'Behaviour Log';
	@override String get pageBehaviorPurpose => 'Records what happened before, during and after a behaviour (ABC) so patterns become visible.';
	@override String get pageBehaviorWhen => 'When you want to understand why a behaviour repeats.';
	@override String get pageBehaviorKeywords => 'behaviour, abc, antecedent, consequence, pattern, trigger';
	@override String get pageEmergency => 'Emergency Card';
	@override String get pageEmergencyPurpose => 'Keeps the essential child information ready to share, via a time-limited link and QR code.';
	@override String get pageEmergencyWhen => 'When you may need to share key information quickly outside, at school or in an emergency.';
	@override String get pageEmergencyKeywords => 'emergency, card, safety, qr, sharing';
	@override String get pageCalendar => 'Calendar';
	@override String get pageCalendarPurpose => 'Keeps appointments, school, events and reminders on a dated agenda.';
	@override String get pageCalendarWhen => 'When you do not want to forget upcoming plans.';
	@override String get pageCalendarKeywords => 'calendar, event, reminder, plan';
	@override String get pageRoutines => 'Routines';
	@override String get pageRoutinesPurpose => 'Helps you follow daily routines step by step, visually.';
	@override String get pageRoutinesWhen => 'When you want to picture the morning, school, sleep or transition routine.';
	@override String get pageRoutinesKeywords => 'routine, schedule, step, visual, transition';
	@override String get pageForum => 'Community Forum';
	@override String get pageForumPurpose => 'A shared discussion space where parents and experts ask questions and share experience.';
	@override String get pageForumWhen => 'When you want to ask the community about something.';
	@override String get pageForumKeywords => 'forum, question, answer, community, experience';
	@override String get pageWall => 'Support Wall';
	@override String get pageWallPurpose => 'A freer support space for feelings and experiences — you can stay anonymous.';
	@override String get pageWallWhen => 'When you would rather open up than ask a question.';
	@override String get pageWallKeywords => 'support wall, feeling, sharing, support, anonymous';
	@override String get pageMeetups => 'Local Meetups';
	@override String get pageMeetupsPurpose => 'Lets you meet families in your city in real life.';
	@override String get pageMeetupsWhen => 'When you want to plan a face-to-face event nearby.';
	@override String get pageMeetupsKeywords => 'meetup, event, city, meeting, local';
	@override String get pageWeekly => 'Question of the Week';
	@override String get pageWeeklyPurpose => 'Lists families\' answers to one shared topic each week.';
	@override String get pageWeeklyWhen => 'When you want to see what other families think or share your own experience.';
	@override String get pageWeeklyKeywords => 'weekly question, community, experience, sharing';
	@override String get pageSimilar => 'Similar Families';
	@override String get pageSimilarPurpose => 'Introduces you to families going through a similar process in terms of age and needs.';
	@override String get pageSimilarWhen => 'When you want to find the families you have most in common with.';
	@override String get pageSimilarKeywords => 'similar families, matching, peer, meeting';
	@override String get pageGroups => 'Support Groups';
	@override String get pageGroupsPurpose => 'Lets you join category-based family and expert communities and their group chats.';
	@override String get pageGroupsWhen => 'When you are looking for a community focused on similar needs or age groups.';
	@override String get pageGroupsKeywords => 'group, community, chat, join';
	@override String get pageKnowledge => 'Knowledge Base';
	@override String get pageKnowledgePurpose => 'Collects trustworthy articles and resources.';
	@override String get pageKnowledgeWhen => 'When you want to read or learn about a topic calmly.';
	@override String get pageKnowledgeKeywords => 'knowledge, article, guide, resource, learning';
	@override String get pageExpertAppointments => 'My Appointments';
	@override String get pageExpertAppointmentsPurpose => 'Approve incoming requests, complete sessions and handle reschedule requests.';
	@override String get pageExpertAppointmentsWhen => 'While planning your day and closing records after a session.';
	@override String get pageExpertMessagesPurpose => 'A secure space to write to families; task feedback also goes through here.';
	@override String get pageExpertMessagesWhen => 'When you want to get back to a family or ask a follow-up question.';
	@override String get pageExpertForumPurpose => 'As an expert you can answer questions and share verified information.';
	@override String get pageExpertForumWhen => 'When you want to contribute professionally to the community.';
	@override String get video01 => 'Platform Overview';
	@override String get video01Desc => 'A short tour of the main sections, the role-based menu and the safe-use tools.';
	@override String get video02 => 'Parent Quick Start';
	@override String get video02Desc => 'Follow the basic flow from signing in to creating a child profile and the first daily record.';
	@override String get video03 => 'Using the User Guide';
	@override String get video03Desc => 'Learn how to find the feature you need through search, categories and role-based guidance.';
	@override String get video04 => 'Home and Navigation';
	@override String get video04Desc => 'Read the daily summaries and reach any section through the menu and quick links.';
	@override String get video05 => 'Child Profile';
	@override String get video05Desc => 'Create a child profile and keep the basics, diagnosis notes, needs and access details up to date.';
	@override String get video06 => 'Daily Mood and Sleep Tracking';
	@override String get video06Desc => 'Add mood, sleep and behaviour records in a few steps and review the history.';
	@override String get video07 => 'Medication Tracking';
	@override String get video07Desc => 'Save the medication plan, follow doses and times, and check past records safely.';
	@override String get video08 => 'Progress Dashboard';
	@override String get video08Desc => 'See how daily records turn into charts and interpret trends and development summaries.';
	@override String get video09 => 'Goals and Exercises';
	@override String get video09Desc => 'View goals suited to your child, run the home exercises and track completion.';
	@override String get video10 => 'Tasks and Routines';
	@override String get video10Desc => 'Follow the tasks your expert assigned and plan morning, school or sleep routines step by step.';
	@override String get video11 => 'Notes, Calendar and Emergency Card';
	@override String get video11Desc => 'Write down observations, plan important dates and keep the emergency card ready to share.';
	@override String get video12 => 'Finding an Expert and Booking';
	@override String get video12Desc => 'Filter experts, compare profiles, choose the right person and manage the appointment flow.';
	@override String get video13 => 'Messages, Privacy and Settings';
	@override String get video13Desc => 'Use secure messaging and manage profile, notification, password and data-sharing preferences.';
	@override String get video14 => 'Community, Forum and Meetups';
	@override String get video14Desc => 'Ask questions on the forum, read family experiences and discover safe community meetups.';
	@override String get video15 => 'Knowledge Base, Crisis and Help';
	@override String get video15Desc => 'Find trustworthy content, reach the crisis steps for hard moments and use the help channels.';
}

// Path: community
class _Translations$community$en extends Translations$community$tr {
	_Translations$community$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Community';
	@override String get badge => 'Moderated, safe contact';
	@override String get intro => 'Find families going through the same process, message them first and join groups and meetups when you are ready.';
	@override String get areasTitle => 'What would you like to do?';
	@override String get areasSubtitle => 'Every community space lives in this hub.';
	@override String get safetyTitle => 'Meeting safely';
	@override String get safetyBody => 'Keep the first conversation inside the app. You do not have to share your phone number, home address or your child\'s private details. You can block or report anyone who makes you uncomfortable.';
	@override String get similarText => 'See shared experiences and match reasons, then start a safe introduction.';
	@override String get messagesText => 'Continue your conversations with families and experts in one place.';
	@override String get groupsText => 'Join communities focused on similar needs and age groups.';
	@override String get meetupsText => 'Discover safe meetups in your city.';
	@override String get forumText => 'Ask the community and read answers from families and experts.';
	@override String get wallText => 'Share how you feel without judgement; stay anonymous if you like.';
	@override String get weeklyText => 'Join short experience threads around a single topic.';
}

// Path: reviews
class _Translations$reviews$en extends Translations$reviews$tr {
	_Translations$reviews$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String title({required Object count}) => 'Reviews (${count})';
	@override String get empty => 'No reviews for this expert yet.';
	@override String get write => 'Write a review';
	@override String get edit => 'Edit my review';
	@override String get ratingLabel => 'Your rating';
	@override String get commentHint => 'Briefly describe your experience (optional)…';
	@override String get save => 'Save';
	@override String get delete => 'Delete';
	@override String get deleteTitle => 'Delete review';
	@override String get deleteConfirm => 'Are you sure you want to delete this review?';
	@override String get someone => 'A parent';
}

// Path: expertAccess
class _Translations$expertAccess$en extends Translations$expertAccess$tr {
	_Translations$expertAccess$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Expert Access';
	@override String get intro => 'Experts can only see your child\'s development data once you approve them. You can withdraw access at any time.';
	@override String get pendingTitle => 'Pending requests';
	@override String get noPending => 'There are no pending expert access requests.';
	@override String get activeTitle => 'Experts with access';
	@override String get noActive => 'You have not granted access to any expert yet.';
	@override String requestLine({required Object child}) => 'Requests access to your child ${child}\'s profile.';
	@override String activeLine({required Object child}) => 'Can access your child ${child}\'s profile.';
	@override String requestedAt({required Object date}) => 'Requested on: ${date}';
	@override String get unknownExpert => 'Expert';
	@override String get approve => 'Approve';
	@override String get reject => 'Reject';
	@override String get revoke => 'Remove access';
	@override String get approved => 'Expert access request approved.';
	@override String get rejected => 'Expert access request rejected.';
	@override String get revoked => 'The expert\'s access has been removed.';
	@override String get revokeTitle => 'Remove access';
	@override String get revokeConfirm => 'Are you sure you want to remove this expert\'s access to your child\'s data?';
	@override String pendingBanner({required Object count}) => '${count} expert access request(s) waiting for your approval';
}

// Path: common.unsaved
class _Translations$common$unsaved$en extends Translations$common$unsaved$tr {
	_Translations$common$unsaved$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Unsaved changes';
	@override String get body => 'Your entries have not been saved yet. They will be lost if you leave.';
	@override String get stay => 'Stay';
	@override String get leave => 'Leave';
}

// Path: common.a11y
class _Translations$common$a11y$en extends Translations$common$a11y$tr {
	_Translations$common$a11y$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get edit => 'Edit';
	@override String get delete => 'Delete';
	@override String get close => 'Close';
	@override String get send => 'Send';
	@override String get options => 'Options';
	@override String get report => 'Report';
	@override String get clearSearch => 'Clear search';
	@override String get clearDate => 'Clear date';
	@override String get clearSelection => 'Clear selection';
	@override String get cancelReply => 'Cancel reply';
	@override String get showPassword => 'Show password';
	@override String get hidePassword => 'Hide password';
	@override String get decrease => 'Decrease';
	@override String get increase => 'Increase';
	@override String rating({required Object count}) => '${count} stars';
}

// Path: crisis.cards
class _Translations$crisis$cards$en extends Translations$crisis$cards$tr {
	_Translations$crisis$cards$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override late final _Translations$crisis$cards$meltdown$en meltdown = _Translations$crisis$cards$meltdown$en._(_root);
	@override late final _Translations$crisis$cards$sensory$en sensory = _Translations$crisis$cards$sensory$en._(_root);
	@override late final _Translations$crisis$cards$aggression$en aggression = _Translations$crisis$cards$aggression$en._(_root);
	@override late final _Translations$crisis$cards$anxiety$en anxiety = _Translations$crisis$cards$anxiety$en._(_root);
}

// Path: crisis.cards.meltdown
class _Translations$crisis$cards$meltdown$en extends Translations$crisis$cards$meltdown$tr {
	_Translations$crisis$cards$meltdown$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Crisis / Meltdown';
	@override String get subtitle => 'Loss of control, crying, screaming, self-harm attempts';
	@override List<String> get steps => [
		'Stay calm — your voice and body language transfer to the child.',
		'Create a safe space: move away sharp or hard objects.',
		'Keep verbal input minimal; single words or short sentences.',
		'Reduce sensory input: dim the lights, lower the sound.',
		'Stay nearby — don\'t leave, but don\'t touch.',
		'Once the crisis passes, reassure with a calm tone.',
	];
	@override List<String> get avoid => [
		'Don\'t speak loudly.',
		'Don\'t try to reason or explain.',
		'Don\'t punish or threaten.',
		'Don\'t leave them in a crowd.',
	];
	@override String get emergency => '112 — Emergency Health Line';
}

// Path: crisis.cards.sensory
class _Translations$crisis$cards$sensory$en extends Translations$crisis$cards$sensory$tr {
	_Translations$crisis$cards$sensory$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Sensory Overload';
	@override String get subtitle => 'Covering ears, avoiding light/sound, freezing';
	@override List<String> get steps => [
		'Move to a calmer, less stimulating environment right away.',
		'Offer favorite sensory objects (weighted blanket, squishy).',
		'Speak briefly in a predictable, calm tone.',
		'Deep pressure (firm hug) may help if the child consents.',
		'Give time — stay quiet for a few minutes.',
		'Note the trigger and take precautions going forward.',
	];
	@override List<String> get avoid => [
		'Don\'t keep giving verbal directions without changing the environment.',
		'Don\'t force them to hold anything.',
		'Don\'t say "Why are you overreacting?"',
	];
}

// Path: crisis.cards.aggression
class _Translations$crisis$cards$aggression$en extends Translations$crisis$cards$aggression$tr {
	_Translations$crisis$cards$aggression$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Aggression / Self-Harm';
	@override String get subtitle => 'Hitting, biting, head-banging, throwing objects';
	@override List<String> get steps => [
		'Keep a safe distance; move others away if nearby.',
		'Give low, short, calm directives ("Stop", "Here").',
		'Remove provoking objects and people from the area.',
		'Offer an alternative outlet: hitting a pillow, running.',
		'Once it passes, note the event; analyze the trigger.',
	];
	@override List<String> get avoid => [
		'Avoid using physical force (unless necessary).',
		'Don\'t fuel it by drawing attention or creating an audience.',
		'Don\'t reward during the behavior.',
	];
	@override String get emergency => '112 — Emergency Call Center';
}

// Path: crisis.cards.anxiety
class _Translations$crisis$cards$anxiety$en extends Translations$crisis$cards$anxiety$tr {
	_Translations$crisis$cards$anxiety$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Intense Anxiety / Panic';
	@override String get subtitle => 'Trembling, shortness of breath, crying, withdrawing';
	@override List<String> get steps => [
		'Say in a calm tone, "I\'m here, you\'re safe."',
		'Do a deep breathing exercise: 4 seconds in, 6 seconds out.',
		'Use the "see 5 things, touch 4 things" grounding exercise.',
		'Offer a safe person or object (favorite toy, headphones).',
		'Give time for it to pass; don\'t rush them.',
	];
	@override List<String> get avoid => [
		'Don\'t belittle it by saying "Calm down, it\'s fine."',
		'Don\'t keep asking and applying pressure.',
		'Don\'t add new demands during anxiety.',
	];
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsEn {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.name' => 'Autism Support',
			'common.cancel' => 'Cancel',
			'common.loading' => 'Loading',
			'common.comingSoon' => 'This section is coming soon.',
			'common.seeAll' => 'See All',
			'common.more' => 'More',
			'common.retry' => 'Retry',
			'common.loadError' => 'Could not load data.',
			'common.unsaved.title' => 'Unsaved changes',
			'common.unsaved.body' => 'Your entries have not been saved yet. They will be lost if you leave.',
			'common.unsaved.stay' => 'Stay',
			'common.unsaved.leave' => 'Leave',
			'common.a11y.edit' => 'Edit',
			'common.a11y.delete' => 'Delete',
			'common.a11y.close' => 'Close',
			'common.a11y.send' => 'Send',
			'common.a11y.options' => 'Options',
			'common.a11y.report' => 'Report',
			'common.a11y.clearSearch' => 'Clear search',
			'common.a11y.clearDate' => 'Clear date',
			'common.a11y.clearSelection' => 'Clear selection',
			'common.a11y.cancelReply' => 'Cancel reply',
			'common.a11y.showPassword' => 'Show password',
			'common.a11y.hidePassword' => 'Hide password',
			'common.a11y.decrease' => 'Decrease',
			'common.a11y.increase' => 'Increase',
			'common.a11y.rating' => ({required Object count}) => '${count} stars',
			'common.monthsShort.0' => 'Jan',
			'common.monthsShort.1' => 'Feb',
			'common.monthsShort.2' => 'Mar',
			'common.monthsShort.3' => 'Apr',
			'common.monthsShort.4' => 'May',
			'common.monthsShort.5' => 'Jun',
			'common.monthsShort.6' => 'Jul',
			'common.monthsShort.7' => 'Aug',
			'common.monthsShort.8' => 'Sep',
			'common.monthsShort.9' => 'Oct',
			'common.monthsShort.10' => 'Nov',
			'common.monthsShort.11' => 'Dec',
			'language.title' => 'Language',
			'language.turkish' => 'Türkçe',
			'language.english' => 'English',
			'theme.title' => 'Theme',
			'theme.system' => 'System',
			'theme.light' => 'Light',
			'theme.dark' => 'Dark',
			'roles.parent' => 'Parent',
			'roles.expert' => 'Specialist',
			'roles.admin' => 'Admin',
			'auth.subtitle' => 'Sign in to your account or create a new one.',
			'auth.emailLabel' => 'Email Address',
			'auth.emailHint' => 'example@email.com',
			'auth.passwordLabel' => 'Password',
			'auth.passwordHint' => '••••••••',
			'auth.rememberMe' => 'Remember me',
			'auth.forgotPassword' => 'Forgot password',
			'auth.loginButton' => 'Sign In',
			'auth.noAccount' => 'Don\'t have an account?',
			'auth.registerParent' => 'Sign up as a parent',
			'auth.registerExpert' => 'Sign up as a specialist',
			'auth.errorEmptyFields' => 'Please enter your email and password.',
			'auth.registerComingSoon' => ({required Object role}) => '${role} sign-up screen is coming soon.',
			'auth.errorMfaRequired' => 'This account uses two-step verification; please sign in on the web for now.',
			'auth.resendVerification' => 'Resend verification email',
			'verifyEmail.title' => 'Email Verification',
			'verifyEmail.waitingTitle' => 'Check your inbox',
			'verifyEmail.waitingBody' => 'We sent you a verification link. Once you open it, come back here and sign in.',
			'verifyEmail.waitingBodyWithEmail' => ({required Object email}) => 'We sent a verification link to ${email}. Once you open it, come back here and sign in.',
			'verifyEmail.spamHint' => 'If the email does not arrive within a few minutes, check your spam folder.',
			'verifyEmail.approvalTitle' => 'Your professional account is awaiting approval',
			'verifyEmail.approvalBody' => 'We received your application. You can sign in once an administrator verifies your license details.',
			'verifyEmail.tokenLabel' => 'Verification Code',
			'verifyEmail.tokenHint' => 'The code inside the email link',
			'verifyEmail.tokenHelp' => 'If you cannot open the link, paste the code from it here.',
			'verifyEmail.verifyButton' => 'Verify',
			'verifyEmail.verifying' => 'Verifying your email address…',
			'verifyEmail.resendButton' => 'Resend email',
			'verifyEmail.resent' => 'A new verification link was sent. Check your inbox and spam folder.',
			'verifyEmail.success' => 'Your email address is verified. You can sign in now.',
			'verifyEmail.errorTokenRequired' => 'Please enter the verification code.',
			'verifyEmail.errorEmailRequired' => 'An email address is required to resend.',
			'verifyEmail.backToLogin' => 'Back to sign in',
			'forgotPassword.title' => 'Forgot Password',
			'forgotPassword.subtitle' => 'Enter your email and we\'ll send you a password reset link.',
			'forgotPassword.submit' => 'Send Reset Link',
			'forgotPassword.sentTitle' => 'Link sent',
			'forgotPassword.sentBody' => 'If an account exists for this email, a password reset link will arrive in your inbox.',
			'forgotPassword.haveCode' => 'I have a reset code',
			'forgotPassword.backToLogin' => 'Back to login',
			'forgotPassword.errorEmailRequired' => 'Please enter your email.',
			'forgotPassword.errorEmailInvalid' => 'Please enter a valid email.',
			'resetPassword.title' => 'Reset Password',
			'resetPassword.subtitle' => 'Enter the reset code from your email and your new password.',
			'resetPassword.tokenLabel' => 'Reset Code',
			'resetPassword.tokenHint' => 'The code from the email link',
			'resetPassword.newPasswordLabel' => 'New Password',
			'resetPassword.confirmLabel' => 'Confirm New Password',
			'resetPassword.submit' => 'Update Password',
			'resetPassword.success' => 'Your password has been updated. You can sign in now.',
			'resetPassword.errorTokenRequired' => 'Please enter the reset code.',
			'resetPassword.errorPasswordShort' => 'Password must be at least 8 characters.',
			'resetPassword.errorMismatch' => 'Passwords do not match.',
			'password.strengthTitle' => 'Password strength',
			'password.strengthVeryWeak' => 'Very weak',
			'password.strengthWeak' => 'Weak',
			'password.strengthMedium' => 'Medium',
			'password.strengthStrong' => 'Strong',
			'password.strengthVeryStrong' => 'Very strong',
			'password.ruleMinLength' => 'At least 8 characters',
			'password.ruleUppercase' => 'One uppercase letter',
			'password.ruleDigit' => 'One digit',
			'password.ruleSpecial' => 'One special character',
			'password.errorTooShort' => 'Password must be at least 8 characters.',
			'password.errorTooLong' => 'Password can be at most 64 characters.',
			'password.errorNoUppercase' => 'Password must contain at least one uppercase letter.',
			'password.errorNoDigit' => 'Password must contain at least one digit.',
			'password.errorNoSpecial' => 'Password must contain at least one special character (e.g. ! ? * . -).',
			'password.errorCommon' => 'This password is too common and easy to guess; please choose a different one.',
			'register.titleParent' => 'Create Parent Account',
			'register.titleExpert' => 'Create Specialist Account',
			'register.roleQuestion' => 'How would you like to sign up?',
			'register.fullNameLabel' => 'Full Name',
			'register.fullNameHint' => 'Your first and last name',
			'register.phoneLabel' => 'Phone (optional)',
			'register.phoneHint' => '05XX XXX XX XX',
			'register.cityLabel' => 'City (optional)',
			'register.cityHint' => 'Your city',
			'register.expertTitleLabel' => 'Professional Title',
			'register.expertTitleHint' => 'e.g. Child Psychologist',
			'register.institutionLabel' => 'Institution (optional)',
			'register.institutionHint' => 'Where you work',
			'register.licenseNumberLabel' => 'License / Diploma No',
			'register.licenseNumberHint' => 'Your professional license number',
			'register.bioLabel' => 'About (optional)',
			'register.bioHint' => 'Briefly describe your experience',
			'register.specializationsLabel' => 'Areas of Expertise (optional)',
			'register.specializationsHint' => 'Separate with commas (Autism, ADHD)',
			'register.kvkkConsent' => 'I have read and accept the data protection (KVKK) notice.',
			'register.submit' => 'Sign Up',
			'register.haveAccount' => 'Already have an account? Sign in',
			'register.errorFullNameRequired' => 'Please enter your full name.',
			'register.errorEmailRequired' => 'Please enter your email.',
			'register.errorEmailInvalid' => 'Please enter a valid email.',
			'register.errorPasswordShort' => 'Password must be at least 8 characters.',
			'register.errorExpertTitleRequired' => 'Please enter your professional title.',
			'register.errorLicenseRequired' => 'A license / diploma number is required for professional sign-up.',
			'register.emailTaken' => 'This email address is already registered. Try signing in.',
			'register.emailAvailable' => 'This email address is available.',
			'register.errorKvkkRequired' => 'KVKK consent is required to continue.',
			'settings.blockedTitle' => 'Blocked users',
			'settings.blockedEmpty' => 'You have not blocked anyone.',
			'settings.blockedRemove' => 'Unblock',
			'settings.blockedRemoved' => 'User unblocked.',
			'settings.privacyFamilyMessages' => 'Let other families message me',
			'settings.matchingTitle' => 'What are you looking for in the community?',
			'settings.matchingHint' => 'Shown in match suggestions and on your profile.',
			'settings.communicationTitle' => 'Your communication preference',
			'settings.intentExperience' => 'Sharing experience',
			'settings.intentRegular' => 'Regular conversation',
			'settings.intentLocalMeet' => 'Meeting nearby',
			'settings.intentSeekMentor' => 'Looking for a mentor',
			'settings.intentBeMentor' => 'Can be a mentor',
			'settings.commWriting' => 'Messaging first',
			'settings.commVideo' => 'Video calls',
			'settings.commEvening' => 'I reply in the evening',
			'settings.title' => 'Settings',
			'settings.notificationsTitle' => 'Notifications',
			'settings.notificationsSubtitle' => 'Choose what you want to be notified about.',
			'settings.notifMessages' => 'New messages',
			'settings.notifAppointment' => 'Appointment confirmations and changes',
			'settings.notifApptReminder' => 'Remind me 24 hours before an appointment',
			'settings.notifExpertNote' => 'Specialist notes and feedback',
			'settings.notifTaskAssigned' => 'When a new assignment arrives',
			'settings.notifForum' => 'Forum and support wall replies',
			'settings.notifMatching' => 'Similar family matches',
			'settings.notifCalendar' => 'Calendar reminders',
			'settings.privacyTitle' => 'Privacy',
			'settings.privacySubtitle' => 'Decide how other people see you.',
			'settings.privacyShowProfile' => 'Show my profile to other families',
			'settings.privacyAllowMessages' => 'Allow people to message me',
			'settings.privacyShareProgress' => 'Share the progress summary with my specialist',
			'settings.privacyApproximateLocation' => 'Share my approximate location (city)',
			'settings.privacyHidePresence' => 'Hide my online status',
			'settings.appearanceTitle' => 'Appearance and language',
			'settings.accessibilityTitle' => 'Accessibility',
			'settings.accessibilitySubtitle' => 'Adapt the look and interaction to your needs.',
			'settings.a11yLargeText' => 'Large text mode',
			'settings.a11yLargeTextBody' => 'Shows text at a larger size.',
			'settings.a11yCalmMode' => 'Calm appearance',
			'settings.a11yCalmModeBody' => 'Uses softer tones that are easier on the eyes.',
			'settings.a11yHighContrast' => 'High contrast',
			'settings.a11yHighContrastBody' => 'Keeps text in the most legible colours.',
			'settings.a11yReduceMotion' => 'Reduce motion',
			'settings.a11yReduceMotionBody' => 'Turns off page transitions and animations.',
			'settings.a11ySimpleMode' => 'Simple mode',
			'settings.a11ySimpleModeBody' => 'Reduces the profile menu to the essential sections.',
			'settings.securityTitle' => 'Security',
			'settings.securitySubtitle' => 'Protect access to your account.',
			'settings.changePassword' => 'Change password',
			'settings.changePasswordSubmit' => 'Update password',
			'settings.currentPasswordLabel' => 'Current password',
			'settings.newPasswordLabel' => 'New password',
			'settings.passwordChanged' => 'Your password has been updated.',
			'settings.errorCurrentPasswordRequired' => 'Please enter your current password.',
			'settings.dataTitle' => 'Your data and KVKK',
			'settings.dataSubtitle' => 'Exercise your rights over your personal data here.',
			'settings.kvkkPanel' => 'KVKK rights and consents',
			'settings.kvkkPanelBody' => 'Consent preferences, requests and the privacy notice.',
			'settings.downloadData' => 'Download my data',
			'settings.downloadDataBody' => 'Get everything in your account as a JSON file.',
			'settings.downloadDataSubject' => 'Otizm Destek — my account data',
			'settings.deleteAccount' => 'Delete my account',
			'settings.deleteAccountBody' => 'Your account and all records are permanently deleted.',
			'settings.deleteAccountWarning' => 'This cannot be undone. All your data — child profiles, notes, appointments and messages — is permanently deleted.',
			'settings.deleteAccountSubmit' => 'Permanently delete my account',
			'settings.deleteKeyword' => 'DELETE',
			'settings.deleteConfirmLabel' => ({required Object keyword}) => 'Type "${keyword}" to confirm',
			'settings.errorDeleteConfirm' => 'The confirmation text does not match.',
			'legal.title' => 'Legal documents',
			'legal.subtitle' => 'Privacy notice, privacy policy, terms of use and medical safety warnings. The binding version is Turkish, so the texts are shown in Turkish.',
			'legal.versionLine' => ({required Object version, required Object date}) => 'Text version ${version} · Last updated ${date}',
			'legal.readNotice' => 'Read the KVKK privacy notice',
			'kvkk.title' => 'Data rights and consents',
			'kvkk.rightsTitle' => 'Your rights under KVKK art. 11',
			'kvkk.rightsBody' => 'You may learn whether your data is processed, request correction or deletion, learn which third parties it was shared with, and object to automated analysis results. Requests are answered within 30 days at the latest.',
			'kvkk.consentsTitle' => 'Your consent preferences',
			'kvkk.consentsSubtitle' => 'Explicit consent must be purpose-specific; each item can be turned on or off separately.',
			'kvkk.consentNotice' => 'Privacy notice acceptance',
			'kvkk.consentAi' => 'AI analysis',
			'kvkk.consentAiBody' => 'Allows development data to be transferred to the AI provider (abroad).',
			'kvkk.consentEmergency' => 'Emergency card sharing',
			'kvkk.consentEmergencyBody' => 'Allows your emergency card to be shown to third parties via link/QR.',
			'kvkk.consentMatching' => 'Similar family matching',
			'kvkk.consentMatchingBody' => 'Allows your profile to be shown to other families in the matching engine.',
			'kvkk.consentMarketing' => 'Informational emails',
			'kvkk.consentMarketingBody' => 'Lets us send you optional announcements and informational emails.',
			'kvkk.reconsentTitle' => 'The privacy notice has been updated',
			'kvkk.reconsentTitleVersion' => ({required Object version}) => 'The privacy notice has been updated (version ${version})',
			'kvkk.reconsentBody' => 'Review how your data is processed and accept the current notice.',
			'kvkk.reconsentAccept' => 'I have read and accept',
			'kvkk.reconsentSaved' => 'Your acceptance of the current notice has been recorded.',
			'kvkk.historyTitle' => 'My consent history',
			'kvkk.requestsTitle' => 'My requests',
			'kvkk.requestsSubtitle' => 'Submit requests about your personal data here.',
			'kvkk.newRequest' => 'Submit a KVKK request',
			'kvkk.requestsEmpty' => 'You have no requests yet.',
			'kvkk.requestsError' => 'Requests could not be loaded.',
			'kvkk.requestCreated' => 'Your request was received. It will be answered within 30 days at the latest.',
			'kvkk.requestInfo' => 'I want to learn whether my data is being processed',
			'kvkk.requestCorrection' => 'I want incomplete or incorrect data to be corrected',
			'kvkk.requestDeletion' => 'I want my data to be deleted / destroyed',
			'kvkk.requestTransfer' => 'I want to learn the third parties my data was shared with',
			'kvkk.requestObjection' => 'I object to a result produced against me by automated analysis',
			'kvkk.requestDamages' => 'I request compensation for the damage I suffered',
			'kvkk.descriptionLabel' => 'Your request',
			'kvkk.descriptionHint' => 'Briefly describe your request.',
			'kvkk.responseTime' => 'Requests are answered within 30 days at the latest.',
			'kvkk.submitRequest' => 'Send request',
			'kvkk.errorDescriptionRequired' => 'Please describe your request.',
			'kvkk.statusOpen' => 'Received',
			'kvkk.statusReviewing' => 'Under review',
			'kvkk.statusDone' => 'Completed',
			'kvkk.statusRejected' => 'Rejected',
			'kvkk.receivedOn' => ({required Object date}) => 'received on ${date}',
			'kvkk.dueOn' => ({required Object date}) => 'response due ${date}',
			'onboarding.title' => 'Getting started',
			'onboarding.skip' => 'Skip',
			'onboarding.start' => 'Let\'s begin',
			'onboarding.back' => 'Back',
			'onboarding.continueButton' => 'Continue',
			'onboarding.skipForNow' => 'Skip for now',
			'onboarding.finish' => 'Go to home',
			'onboarding.stepChild' => 'Child Profile',
			'onboarding.stepTags' => 'Support Areas',
			'onboarding.stepPlan' => 'Starter Plan',
			'onboarding.welcomeTitle' => 'Welcome',
			'onboarding.welcomeBody' => 'Let\'s set the app up for your child in a few short steps. You can change everything later.',
			'onboarding.introChildTitle' => 'Basic details',
			'onboarding.introChildBody' => 'Name and a few optional notes',
			'onboarding.introTagsTitle' => 'Support areas',
			'onboarding.introTagsBody' => 'Pick the areas you observe',
			'onboarding.introPlanTitle' => 'Starter suggestions',
			'onboarding.introPlanBody' => 'See what you can do first',
			'onboarding.childTitle' => 'Tell us about your child',
			'onboarding.childSubtitle' => 'Only the name is required; you can fill in the rest later.',
			'onboarding.childNameLabel' => 'Child\'s name',
			'onboarding.childNameHint' => 'e.g. Elif',
			'onboarding.childBirthDateLabel' => 'Date of birth (optional)',
			'onboarding.childBirthDateHint' => 'Tap to choose',
			'onboarding.childDiagnosisLabel' => 'Diagnosis details (optional)',
			'onboarding.childDiagnosisHint' => 'Diagnosis and short notes, if any',
			'onboarding.focusTitle' => 'Starting focus',
			'onboarding.communicationTitle' => 'Communication style',
			'onboarding.supportTitle' => 'Support that may help',
			'onboarding.tagsTitle' => 'Which areas do you need support with?',
			'onboarding.tagsSubtitle' => 'Pick what you observe; similar families and content suggestions follow these.',
			'onboarding.planTitle' => 'Your starter plan is ready',
			'onboarding.planTitleNamed' => ({required Object name}) => 'Your starter plan for ${name} is ready',
			'onboarding.planSubtitle' => 'You can try one of these as a first step.',
			'onboarding.planNote' => 'These are only starting suggestions; every section stays reachable from the menu.',
			'onboarding.planTrackerTitle' => 'Add a daily entry',
			'onboarding.planTrackerBody' => 'Log sleep, mood or a short observation.',
			'onboarding.planExpertsTitle' => 'Browse specialists',
			'onboarding.planExpertsBody' => 'Look through specialists or request an appointment.',
			'onboarding.planKnowledgeTitle' => 'Explore the knowledge base',
			'onboarding.planKnowledgeBody' => 'Browse trusted content in the knowledge base.',
			'onboarding.expertTitle' => ({required Object name}) => 'Welcome ${name}',
			'onboarding.expertBody' => 'Client tracking, appointments and messages are waiting on the home screen.',
			'onboarding.errorNameRequired' => 'The child\'s name is required.',
			'onboarding.errorBirthDateFuture' => 'The date of birth cannot be in the future.',
			'nav.home' => 'Home',
			'nav.specialists' => 'Specialists',
			'nav.progress' => 'Progress',
			'nav.profile' => 'Profile',
			'chat.title' => 'AI Assistant',
			'chat.greeting' => 'Hi! I\'ll try to answer your questions about autism and child development.',
			'chat.inputHint' => 'Ask a question...',
			'chat.errorGeneric' => 'Couldn\'t get a response, please try again.',
			'messages.blockUser' => 'Block user',
			'messages.blockConfirm' => ({required Object name}) => '${name} will no longer be able to message you. Block?',
			'messages.blocked' => 'User blocked.',
			'messages.title' => 'Messages',
			'messages.noConversations' => 'You have no conversations yet.',
			'messages.noMessages' => 'No messages yet. Send the first one.',
			'messages.inputHint' => 'Type a message...',
			'messages.connecting' => 'Connecting...',
			'messages.pecsTitle' => 'PECS picture cards',
			'messages.filterAll' => 'All',
			'messages.filterUnread' => 'Unread',
			'messages.filterExperts' => 'Experts',
			'messages.filterGroups' => 'Groups',
			'messages.filterArchived' => 'Archive',
			'messages.emptyUnread' => 'No unread messages.',
			'messages.emptyExperts' => 'No messages with experts yet.',
			'messages.emptyGroups' => 'You are not in a group yet.',
			'messages.emptyArchived' => 'The archive is empty. Archived chats appear here.',
			'messages.archive' => 'Archive',
			'messages.unarchive' => 'Unarchive',
			'messages.mute' => 'Mute',
			'messages.unmute' => 'Unmute',
			'messages.reply' => 'Reply',
			'messages.replyingTo' => ({required Object name}) => 'Replying to ${name}',
			'messages.someone' => 'Message',
			'messages.attachPhoto' => 'Attach a photo',
			'messages.photoSent' => 'Photo sent.',
			'messages.newChat' => 'New chat',
			'messages.searchUserHint' => 'Search by name…',
			'messages.searchUserHelp' => 'Type at least two letters to start a chat.',
			'messages.searchUserEmpty' => 'No matching users found.',
			'messages.searchInChat' => 'Search in chat',
			'messages.searchNoResults' => 'No messages match this search.',
			'messages.deleteMessage' => 'Delete message',
			'home.notifications' => 'Notifications',
			'home.assistant' => 'AI Assistant',
			'home.messages' => 'Messages',
			'home.greeting' => ({required Object name}) => 'Hello, ${name}',
			'home.greetingFallback' => 'Parent',
			'home.subtitle' => 'What can we do for development today?',
			'home.childProgressTitle' => 'Child Development',
			'home.weeklySummary' => 'Weekly Progress Summary',
			'home.increaseBadge' => ({required Object value}) => '${value}% Increase',
			'home.remainingToGoal' => ({required Object value}) => 'Remaining to goal: ${value}%',
			'home.statusCognitiveGood' => 'Cognitive: Good',
			'home.statusCommunicationImproving' => 'Communication: Improving',
			'home.upcomingAppointments' => 'Upcoming Appointments',
			'home.recommendedArticles' => 'Recommended Articles',
			'home.childrenTitle' => 'My Children',
			'home.noChildren' => 'You haven\'t added a child yet.',
			'home.addChild' => 'Add Child',
			'home.ageYears' => ({required Object years}) => '${years} yrs',
			'home.noAppointments' => 'You have no upcoming appointments.',
			'home.noArticles' => 'No articles to show.',
			'home.quickTracker' => 'Today\'s log',
			'home.quickTrackerDetail' => 'Mood, sleep, medication',
			'home.quickBehavior' => 'Behaviour note',
			'home.quickBehaviorDetail' => 'Antecedent-behaviour-consequence',
			'home.quickNote' => 'Observation note',
			'home.quickNoteDetail' => 'Add a short note',
			'home.quickPlan' => 'Add a plan',
			'home.quickPlanDetail' => 'Appointment, school, event',
			'dailyPlan.title' => 'What to do today?',
			'dailyPlan.subtitle' => ({required Object count, required Object minutes}) => '${count} left · about ${minutes} min',
			'dailyPlan.subtitleDone' => 'Today\'s tasks are done',
			'dailyPlan.coachLabel' => 'Daily coach tip',
			'dailyPlan.durationMinutes' => ({required Object count}) => '${count} min',
			'dailyPlan.badgeNow' => 'Do this now',
			'dailyPlan.badgeNext' => 'Next',
			'dailyPlan.badgeSafety' => 'Safety',
			'dailyPlan.badgeOptional' => 'Optional',
			'dailyPlan.badgeDone' => 'Done',
			'dailyPlan.allDoneTitle' => 'Today\'s tasks are complete',
			'dailyPlan.allDoneDetail' => 'The core records are in. With the time left you can look at the plan, the community or the knowledge base.',
			'dailyPlan.partMorning' => 'this morning',
			'dailyPlan.partAfternoon' => 'this afternoon',
			'dailyPlan.partEvening' => 'this evening',
			'dailyPlan.coachNoChild' => 'Today it is enough to create the child profile. The other sections make sense once the profile exists.',
			'dailyPlan.coachAllDone' => ({required Object name}) => 'Everything for ${name} is done today! You can move on to the plan or the knowledge base.',
			'dailyPlan.coachMedication' => ({required Object name, required Object part, required Object count}) => 'For ${name} it is best to finish the medication check ${part}; the remaining ${count} tasks are quicker.',
			'dailyPlan.coachNoMood' => ({required Object name, required Object part}) => 'Start with a short daily log for ${name} — it makes ${part} feel complete.',
			'dailyPlan.coachEvent' => ({required Object name, required Object count}) => 'There is a planned event for ${name} today; the remaining ${count} tasks can stay short.',
			'dailyPlan.coachProgress' => ({required Object done, required Object name, required Object count}) => '${done} done for ${name}, ${count} left. You are doing well!',
			'dailyPlan.coachPlan' => ({required Object name, required Object part, required Object minutes}) => 'Plan for ${name} ${part} - a short log, a calendar check and one note. About ${minutes} min in total.',
			'dailyPlan.taskDailyLog' => 'Add today\'s short log',
			'dailyPlan.taskDailyLogDone' => 'Update today\'s log',
			'dailyPlan.taskDailyLogDetail' => 'Mark mood, sleep and medication in about a minute.',
			'dailyPlan.taskDailyLogDoneDetail' => 'Mood is in; you can still add sleep, medication or a short note.',
			'dailyPlan.taskMedication' => 'Finish the medication check',
			'dailyPlan.taskMedicationDetail' => ({required Object count}) => '${count} doses are not marked yet.',
			'dailyPlan.taskMessages' => 'Reply to messages',
			'dailyPlan.taskMessagesDetail' => ({required Object count}) => 'You have ${count} unread messages.',
			'dailyPlan.taskExpertRequest' => 'Answer the expert access request',
			'dailyPlan.taskExpertRequestDetail' => ({required Object count}) => '${count} experts are waiting for access to your child\'s data.',
			'dailyPlan.taskEventDetail' => ({required Object time}) => 'Today at ${time}',
			'dailyPlan.taskEventTomorrowDetail' => ({required Object time}) => 'Tomorrow at ${time}',
			'dailyPlan.taskCalendar' => 'Plan the calendar',
			'dailyPlan.taskCalendarDetail' => 'Add appointments, school or activities if you have any.',
			'dailyPlan.taskCalendarUpcoming' => 'See the upcoming event',
			'dailyPlan.taskNotes' => 'Add a short observation note',
			'dailyPlan.taskNotesDetail' => 'Note something you noticed today.',
			'dailyPlan.taskNotesDone' => 'Review your observation notes',
			'dailyPlan.taskNotesDoneDetail' => ({required Object count}) => '${count} notes so far — you can add a new one.',
			'dailyPlan.taskCommunity' => 'Discover the community',
			'dailyPlan.taskCommunityDetail' => 'See what families going through similar things are sharing.',
			'dailyPlan.taskCommunityDone' => 'Follow the community areas',
			'dailyPlan.taskCommunityDoneDetail' => 'There may be new posts in the weekly question, forum and meetups.',
			'dailyPlan.taskEmergency' => 'Create the emergency card',
			'dailyPlan.taskEmergencyDetail' => 'Keep critical medical details and emergency contacts on one card.',
			'dailyPlan.taskFirstChild' => 'Create the first child profile',
			'dailyPlan.taskFirstChildDetail' => 'Once the profile exists, the plan and tips adapt to your child.',
			'dailyPlan.taskGuide' => 'See how the app is laid out',
			'dailyPlan.taskGuideDetail' => 'Learn quickly what each section is for.',
			'dailyPlan.taskExperts' => 'Discover expert support',
			'dailyPlan.taskExpertsDetail' => 'You can browse expert profiles before booking anything.',
			'dailyPlan.startTitle' => 'Quick start',
			'dailyPlan.startIntro' => 'You do not have to finish everything on day one. The profile, a short log and the crisis guide are enough.',
			'dailyPlan.startProgress' => ({required Object done, required Object total}) => '${done}/${total} steps',
			'dailyPlan.startReady' => ({required Object percent}) => '${percent}% ready',
			'dailyPlan.startDismiss' => 'Dismiss the guide',
			'dailyPlan.checkTodo' => 'To do',
			'dailyPlan.checkDone' => 'Completed',
			'dailyPlan.checkChildProfile' => '1. Child profile',
			'dailyPlan.checkChildProfileDetail' => 'The plan, tracking and expert sharing adapt to the profile.',
			'dailyPlan.checkDailyLog' => '2. First short log',
			'dailyPlan.checkDailyLogDetail' => 'Data comes first; the daily plan makes sense after that log.',
			'dailyPlan.checkCrisis' => '3. Crisis guide',
			'dailyPlan.checkCrisisDetail' => 'Read the calming and intervention steps before a hard moment.',
			'specialists.title' => 'Find a Specialist',
			'specialists.searchHint' => 'Search by name or expertise...',
			'specialists.filterAll' => 'All',
			'specialists.filterPsychologist' => 'Psychologist',
			'specialists.filterSpecialEducation' => 'Special Education',
			'specialists.filterSpeech' => 'Speech & Language',
			'specialists.noResults' => 'No specialists match your search.',
			'specialists.ratingNew' => 'New',
			'specialists.reviews' => ({required Object count}) => '${count} reviews',
			'specialists.filters' => 'Filters',
			'specialists.cityLabel' => 'City',
			'specialists.sortLabel' => 'Sort',
			'specialists.sortDefault' => 'Default',
			'specialists.sortRating' => 'By rating',
			'specialists.sortName' => 'By name',
			'specialists.onlyAccepting' => 'Only experts accepting new clients',
			'specialists.onlyVerified' => 'Only verified experts',
			'specialists.onlyOnline' => 'Online sessions only',
			'specialists.onlyFavorites' => 'My favourites only',
			'specialists.addFavorite' => 'Add to favourites',
			'specialists.removeFavorite' => 'Remove from favourites',
			'specialists.clearFilters' => 'Clear',
			'specialists.applyFilters' => 'Apply',
			'progress.title' => 'Progress Tracking',
			'progress.subtitle' => 'Goals and development notes.',
			'progress.addRecord' => 'Add New Record',
			'progress.goalsTitle' => 'Goals',
			'progress.recentNotes' => 'Recent Development Notes',
			'progress.noGoals' => 'No goals added yet.',
			'progress.noNotes' => 'No development notes yet.',
			'progress.noChild' => 'Add a child first to track development.',
			'progress.goalProgress' => ({required Object done, required Object total}) => '${done} / ${total}',
			'progress.addGoal' => 'Add Goal',
			'progress.addNote' => 'Add Note',
			'progress.addToken' => 'Add Token',
			'progress.tokenAdded' => 'Token added 🎉',
			'progress.tokenRemoved' => 'Token removed.',
			'progress.goalCompleted' => 'Goal completed! 🎉',
			'progress.rewardLine' => ({required Object title}) => 'Reward: ${title}',
			'goalForm.title' => 'Add Goal',
			'goalForm.nameLabel' => 'Title',
			'goalForm.nameHint' => 'e.g. Making eye contact',
			'goalForm.categoryLabel' => 'Category',
			'goalForm.targetLabel' => 'Target Count',
			'goalForm.descriptionLabel' => 'Description (optional)',
			'goalForm.descriptionHint' => 'Details about the goal',
			'goalForm.save' => 'Save',
			'goalForm.errorTitle' => 'Please enter a title.',
			'goalForm.created' => 'Goal added.',
			'noteForm.title' => 'Add Note',
			'noteForm.editTitle' => 'Edit Note',
			'noteForm.nameLabel' => 'Title',
			'noteForm.nameHint' => 'e.g. Today\'s progress',
			'noteForm.contentLabel' => 'Content (optional)',
			'noteForm.contentHint' => 'Write your observations',
			'noteForm.categoryLabel' => 'Category (optional)',
			'noteForm.moodLabel' => 'Mood (optional)',
			'noteForm.moodHappy' => 'Happy',
			'noteForm.moodNeutral' => 'Normal',
			'noteForm.moodSad' => 'Hard Day',
			'noteForm.dateLabel' => 'Date',
			'noteForm.save' => 'Save',
			'noteForm.errorTitle' => 'Please enter a title.',
			'noteForm.created' => 'Note added.',
			'noteForm.updated' => 'Note updated.',
			'notesPage.title' => 'My Notes',
			_ => null,
		} ?? switch (path) {
			'notesPage.add' => 'Add Note',
			'notesPage.searchHint' => 'Search notes…',
			'notesPage.empty' => 'No development notes yet. Start by adding the first note.',
			'notesPage.noResults' => 'No results. Try changing the filter or search.',
			'notesPage.noChildren' => 'Add a child profile first.',
			'notesPage.loadMore' => 'Load More',
			'notesPage.edit' => 'Edit',
			'notesPage.delete' => 'Delete',
			'notesPage.cancel' => 'Cancel',
			'notesPage.deleteTitle' => 'Delete Note',
			'notesPage.deleteConfirm' => 'Are you sure you want to delete this note?',
			'notesPage.deleted' => 'Note deleted.',
			'notifications.show' => 'Show',
			'notifications.title' => 'Notifications',
			'notifications.empty' => 'You have no notifications yet.',
			'notifications.markAllRead' => 'Mark all as read',
			'notifications.dateLine' => ({required Object day, required Object month, required Object time}) => '${day} ${month} · ${time}',
			'notifications.noneInFilter' => 'No notifications match this filter.',
			'notifications.unreadOnly' => 'Unread only',
			'notifications.selectedCount' => ({required Object count}) => '${count} selected',
			'notifications.deleteSelected' => 'Delete selected',
			'notifications.groupToday' => 'Today',
			'notifications.groupYesterday' => 'Yesterday',
			'notifications.groupThisWeek' => 'This Week',
			'notifications.groupOlder' => 'Older',
			'notifications.catAll' => 'All',
			'notifications.catAppointments' => 'Appointments',
			'notifications.catMessages' => 'Messages',
			'notifications.catForum' => 'Forum',
			'notifications.catTasks' => 'Tasks',
			'notifications.catSocial' => 'Social',
			'notifications.catSystem' => 'System',
			'search.title' => 'Search',
			'search.hint' => 'Search articles, posts, groups or experts…',
			'search.help' => 'Type what you are looking for.',
			'search.noResults' => 'No results match this search.',
			'search.typeAll' => 'All',
			'search.typeArticle' => 'Article',
			'search.typePost' => 'Post',
			'search.typeGroup' => 'Group',
			'search.typeExpert' => 'Expert',
			'knowledge.title' => 'Knowledge Base',
			'knowledge.empty' => 'No articles yet.',
			'knowledge.noResults' => 'No content matches this filter.',
			'knowledge.filterAll' => 'All',
			'knowledge.formatArticle' => 'Article',
			'knowledge.formatVideo' => 'Video',
			'knowledge.formatPodcast' => 'Podcast',
			'knowledge.views' => ({required Object count}) => '${count} views',
			'knowledge.dateLine' => ({required Object day, required Object month, required Object year}) => '${day} ${month} ${year}',
			'knowledge.videoLink' => 'Video link',
			'knowledge.podcastLink' => 'Podcast link',
			'knowledge.searchHint' => 'Search articles, topics or keywords…',
			'knowledge.bookmarks' => 'My bookmarks',
			'knowledge.bookmark' => 'Bookmark',
			'knowledge.noBookmarks' => 'You have not bookmarked anything yet.',
			'knowledge.relatedTitle' => 'Related content',
			'knowledge.commentsTitle' => ({required Object count}) => 'Comments (${count})',
			'knowledge.noComments' => 'Be the first to comment.',
			'knowledge.commentHint' => 'Share your experience or ask a question…',
			'knowledge.commentSend' => 'Post comment',
			'knowledge.someone' => 'A family',
			'knowledge.expertBadge' => 'Expert',
			'knowledge.triedFor' => ({required Object duration}) => 'Tried for: ${duration}',
			'knowledge.effectiveness' => ({required Object rating}) => 'Effectiveness: ${rating}/5',
			'knowledge.tagFilterTitle' => 'Narrow down by tag',
			'knowledge.tagFilterClear' => 'Clear tags',
			'knowledge.tagFilterCount' => ({required Object count}) => '${count} tags selected',
			'appointments.rate' => 'Rate',
			'appointments.rateTitle' => 'Rate this appointment',
			'appointments.rateComment' => 'Your comment (optional)',
			'appointments.rateSave' => 'Send',
			'appointments.rated' => 'Your rating has been saved.',
			'appointments.rateStars' => ({required Object count}) => '${count} stars',
			'appointments.ratingShown' => 'Your rating',
			'appointments.cancelSeries' => 'Cancel series',
			'appointments.cancelSeriesTitle' => 'Cancel the whole series?',
			'appointments.cancelSeriesConfirm' => 'All upcoming appointments in this recurring series will be cancelled.',
			'appointments.seriesCancelled' => 'Series cancelled.',
			'appointments.seriesIndex' => ({required Object index}) => 'Session ${index}',
			'appointments.seriesBadge' => 'Series',
			'appointments.recurrenceTitle' => 'Recurring sessions',
			'appointments.recurrenceHint' => 'Created automatically every week at the same day and time.',
			'appointments.recurrenceSingle' => 'Single',
			'appointments.recurrenceWeeks' => ({required Object count}) => '${count} weeks',
			'appointments.recurrenceCreated' => ({required Object count}) => 'A ${count}-week series has been created.',
			'appointments.title' => 'Appointments',
			'appointments.empty' => 'You don\'t have any appointments yet.',
			'appointments.upcoming' => 'Upcoming',
			'appointments.past' => 'Past',
			'appointments.statusPending' => 'Pending',
			'appointments.statusConfirmed' => 'Confirmed',
			'appointments.statusCompleted' => 'Completed',
			'appointments.statusCancelled' => 'Cancelled',
			'appointments.typeOnline' => 'Online session',
			'appointments.typeFaceToFace' => 'In person',
			'appointments.withChild' => ({required Object name}) => 'Child: ${name}',
			'appointments.dateLine' => ({required Object day, required Object month, required Object year, required Object time}) => '${day} ${month} ${year} · ${time}',
			'appointments.cancel' => 'Cancel',
			'appointments.confirm' => 'Confirm',
			'appointments.complete' => 'Complete',
			'appointments.joinMeeting' => 'Join meeting',
			'appointments.cancelTitle' => 'Cancel appointment',
			'appointments.cancelConfirm' => 'Are you sure you want to cancel this appointment?',
			'appointments.cancelReasonLabel' => 'Cancellation reason (optional)',
			'appointments.cancelReasonShown' => ({required Object reason}) => 'Cancellation reason: ${reason}',
			'appointments.keepIt' => 'Keep',
			'appointments.cancelled' => 'Appointment cancelled.',
			'appointments.confirmed' => 'Appointment confirmed.',
			'appointments.completed' => 'Appointment marked as completed.',
			'appointments.reschedule' => 'Reschedule',
			'appointments.rescheduleTitle' => 'Reschedule Appointment',
			'appointments.rescheduleConfirm' => 'Confirm New Time',
			'appointments.rescheduled' => 'Appointment rescheduled.',
			'appointments.nextTitle' => 'Next appointment',
			'appointments.countdownDays' => ({required Object days, required Object hours, required Object minutes}) => '${days} d ${hours} h ${minutes} m left',
			'appointments.countdownToday' => ({required Object hours, required Object minutes, required Object seconds}) => '${hours} h ${minutes} m ${seconds} s left',
			'appointments.countdownNow' => 'Session time',
			'appointments.statToday' => 'Today',
			'appointments.statWeek' => 'This week',
			'appointments.statMonth' => 'This month',
			'appointments.statPending' => 'Pending',
			'appointments.statCompleted' => 'Completed',
			'appointments.statCancelled' => 'Cancelled',
			'appointments.findExpert' => 'Find an expert',
			'appointments.today' => 'Today',
			'appointments.tomorrow' => 'Tomorrow',
			'appointments.detailTitle' => 'Appointment details',
			'appointments.detailDuration' => 'Duration',
			'appointments.detailDurationValue' => ({required Object count}) => '${count} min',
			'appointments.detailExpert' => 'Expert',
			'appointments.detailParent' => 'Parent',
			'appointments.detailChild' => 'Child',
			'appointments.detailStatus' => 'Status',
			'appointments.detailType' => 'Format',
			'appointments.detailNote' => 'Appointment note',
			'appointments.detailTopic' => 'Session topic',
			'appointments.detailPreSession' => 'Note shared before the session',
			'appointments.detailSessionNote' => 'Session note',
			'appointments.detailSessionSummary' => 'Session summary',
			'appointments.detailFollowUp' => 'Expert recommendations',
			'appointments.detailFollowUpTask' => 'Follow-up task',
			'appointments.detailRating' => 'Rating',
			'appointments.detailRatingValue' => ({required Object rating}) => '${rating} / 5',
			'appointments.detailCancelledBy' => ({required Object who}) => 'Cancelled by: ${who}',
			'appointments.detailLateCancellation' => 'Late cancellation',
			'appointments.historyTitle' => 'Status history',
			'appointments.historyEmpty' => 'No status changes recorded yet.',
			'appointments.historyChange' => ({required Object from, required Object to}) => '${from} → ${to}',
			'appointments.historyMeta' => ({required Object name, required Object date}) => '${name} · ${date}',
			'appointments.detailOpen' => 'Details',
			'expertDetail.bookAppointment' => 'Book Appointment',
			'expertDetail.sendMessage' => 'Send Message',
			'expertDetail.specializationsTitle' => 'Specializations',
			'expertDetail.articleCount' => ({required Object count}) => '${count} articles',
			'expertDetail.notAcceptingPatients' => 'This expert is not accepting appointments right now.',
			'expertDetail.aboutTitle' => 'About',
			'expertDetail.professionalTitle' => 'Profile details',
			'expertDetail.factNextSlot' => 'First available slot',
			'expertDetail.factNextSlotEmpty' => 'Check the calendar',
			'expertDetail.factSession' => 'Session length',
			'expertDetail.factSessionValue' => ({required Object count}) => '${count} minutes',
			'expertDetail.factAgeGroups' => 'Age groups',
			'expertDetail.factAgeGroupsEmpty' => 'Ask the expert',
			'expertDetail.factLanguages' => 'Languages',
			'expertDetail.factSupportTopics' => 'Support topics',
			'expertDetail.factSupportTopicsEmpty' => 'Not stated on the profile',
			'expertDetail.factCancellation' => 'Cancellation policy',
			'expertDetail.factCancellationEmpty' => 'Confirm with the expert before the appointment',
			'expertDetail.factReschedule' => 'Reschedule policy',
			'expertDetail.factService' => 'Session format',
			'expertDetail.factServiceEmpty' => 'Not stated',
			'expertDetail.serviceOnline' => 'Online',
			'expertDetail.serviceFaceToFace' => 'In person',
			'expertDetail.factFee' => 'Session fee',
			'expertDetail.factFeeEmpty' => 'Ask the expert',
			'expertDetail.badgeVerified' => 'Verified expert',
			'expertDetail.badgePending' => 'Awaiting approval',
			'expertDetail.badgeLicenseVerified' => 'License verified',
			'expertDetail.report' => 'Report this profile',
			'expertDetail.reportReasonLabel' => 'Reason',
			'expertDetail.reportNoteLabel' => 'Extra details (optional)',
			'expertDetail.reportNoteHint' => 'Describe the situation in a few sentences',
			'expertDetail.reportSend' => 'Send report',
			'expertDetail.reportSent' => 'Your report has been sent. The moderation team will review it.',
			'booking.title' => 'Book Appointment',
			'booking.childLabel' => 'Child',
			'booking.noChild' => 'Add a child first to book an appointment.',
			'booking.typeLabel' => 'Appointment Type',
			'booking.dateLabel' => 'Date',
			'booking.selectDate' => 'Select date',
			'booking.dateValue' => ({required Object day, required Object month, required Object year}) => '${day} ${month} ${year}',
			'booking.timeLabel' => 'Time',
			'booking.selectDateFirst' => 'Select a date to see available times.',
			'booking.noSlots' => 'No available times for this day.',
			'booking.notesLabel' => 'Note (optional)',
			'booking.notesHint' => 'A note for the expert',
			'booking.confirm' => 'Confirm Appointment',
			'booking.created' => 'Appointment created.',
			'booking.errorSelectChild' => 'Please select a child.',
			'booking.errorSelectTime' => 'Please select a time.',
			'routines.starWallet' => ({required Object count}) => '${count} stars',
			'routines.stepDone' => 'Step completed, +1 star!',
			'routines.progressDone' => ({required Object percent}) => '${percent}% completed',
			'routines.stepCount' => ({required Object count}) => '${count} steps',
			'routines.title' => 'Routines',
			'routines.empty' => 'No routines for this child yet.',
			'routines.noChild' => 'Add a child first to create routines.',
			'routines.add' => 'Add Routine',
			'routines.addItem' => 'Add Step',
			'routines.noItems' => 'No steps added yet.',
			'routines.deleteRoutineTitle' => 'Delete Routine',
			'routines.deleteRoutineConfirm' => ({required Object name}) => 'Are you sure you want to delete the routine "${name}"?',
			'routines.delete' => 'Delete',
			'routines.cancel' => 'Cancel',
			'routines.created' => 'Routine added.',
			'routines.itemAdded' => 'Step added.',
			'routines.deleted' => 'Routine deleted.',
			'routines.itemTitleLabel' => 'Step Title',
			'routines.itemTitleHint' => 'e.g. Brush teeth',
			'routines.itemTimeLabel' => 'Time (optional)',
			'routines.selectTime' => 'Select time',
			'routines.itemIconLabel' => 'Icon',
			'routines.itemSave' => 'Add',
			'routines.errorItemTitle' => 'Please enter a step title.',
			'routineForm.title' => 'Add Routine',
			'routineForm.nameLabel' => 'Routine Name',
			'routineForm.nameHint' => 'e.g. Morning Routine',
			'routineForm.descriptionLabel' => 'Description (optional)',
			'routineForm.descriptionHint' => 'What is this routine for?',
			'routineForm.save' => 'Save',
			'routineForm.errorName' => 'Please enter a routine name.',
			'dailyTracker.title' => 'Daily Tracker',
			'dailyTracker.tabMood' => 'Mood',
			'dailyTracker.tabSleep' => 'Sleep',
			'dailyTracker.tabMeds' => 'Medication',
			'dailyTracker.todayTitle' => 'How was today?',
			'dailyTracker.today' => 'Today',
			'dailyTracker.mood1' => 'Very Bad',
			'dailyTracker.mood2' => 'Bad',
			'dailyTracker.mood3' => 'Okay',
			'dailyTracker.mood4' => 'Good',
			'dailyTracker.mood5' => 'Great',
			'dailyTracker.triggersLabel' => 'Possible triggers (optional)',
			'dailyTracker.notesLabel' => 'Note (optional)',
			'dailyTracker.notesHint' => 'Your observations about today',
			'dailyTracker.save' => 'Save',
			'dailyTracker.update' => 'Update',
			'dailyTracker.saved' => 'Mood saved.',
			'dailyTracker.historyTitle' => 'Past Entries',
			'dailyTracker.empty' => 'No entries yet. Add the first one today.',
			'dailyTracker.noChild' => 'Add a child first to use the daily tracker.',
			'dailyTracker.deleteTitle' => 'Delete Entry',
			'dailyTracker.deleteConfirm' => ({required Object date}) => 'Are you sure you want to delete the entry dated ${date}?',
			'dailyTracker.delete' => 'Delete',
			'dailyTracker.cancel' => 'Cancel',
			'dailyTracker.deleted' => 'Entry deleted.',
			'dailyTracker.errorSelectMood' => 'Please select a mood.',
			'dailyTracker.dateLine' => ({required Object day, required Object month, required Object year}) => '${day} ${month} ${year}',
			'sleep.todayTitle' => 'Last Night / This Morning',
			'sleep.bedtime' => 'Bedtime',
			'sleep.wakeTime' => 'Wake Time',
			'sleep.quality' => 'Sleep Quality',
			'sleep.nightWakings' => 'Night wakings',
			'sleep.factorsLabel' => 'Sensory and environmental factors',
			'sleep.factorWeighted' => '🛏️ Weighted Blanket',
			'sleep.factorSensory' => '👕 Sensory Sensitivity',
			'sleep.factorMelatonin' => '💊 Melatonin Support',
			'sleep.factorNoise' => '🔊 Noise / Light',
			'sleep.saved' => 'Sleep saved.',
			'sleep.empty' => 'No sleep entries yet. Add the first one today.',
			'sleep.deleteConfirm' => ({required Object date}) => 'Are you sure you want to delete the sleep entry dated ${date}?',
			'sleep.deleted' => 'Sleep entry deleted.',
			'sleep.duration' => ({required Object h, required Object m}) => '${h} h ${m} min',
			'sleep.wakings' => ({required Object count}) => 'woke ${count} times',
			'meds.safetyTitle' => 'Medication safety',
			'meds.safetyBody' => 'Medication reminders are for support only. Decisions about starting, stopping, changing doses or side effects should be made only with your doctor.',
			'meds.add' => 'Add Medication',
			'meds.addTitle' => 'Add New Medication',
			'meds.editTitle' => 'Edit Medication',
			'meds.empty' => 'No medications yet. Add your child\'s medications and supplements here.',
			'meds.name' => 'Medication / Supplement Name',
			'meds.nameHint' => 'E.g. Omega-3',
			'meds.dosage' => 'Dose',
			'meds.unit' => 'Unit',
			'meds.frequency' => 'Frequency',
			'meds.freqDaily' => 'Once a day',
			'meds.freqTwiceDaily' => 'Twice a day',
			'meds.freqThreeDaily' => '3 times a day',
			'meds.freqAsNeeded' => 'As needed',
			'meds.freqWeekly' => 'Weekly',
			'meds.timesLabel' => 'Dose times',
			'meds.addTime' => 'Add Time',
			'meds.noTime' => 'No time',
			'meds.added' => 'Medication added.',
			'meds.updated' => 'Medication updated.',
			'meds.deleteTitle' => 'Delete Medication',
			'meds.deleteConfirm' => ({required Object name}) => '${name} and its dose logs will be permanently deleted. Are you sure?',
			'meds.deleted' => 'Medication deleted.',
			'meds.errorName' => 'Please enter the medication name.',
			'meds.logTitle' => 'Dose Log',
			'meds.taken' => 'Medication taken',
			'meds.sideEffectsLabel' => 'Observed side effects',
			'meds.logNotesLabel' => 'Observation notes (optional)',
			'meds.logNotesHint' => 'Anything you want to share with your doctor?',
			'meds.logSaved' => 'Dose log saved.',
			'wall.title' => 'Support Wall',
			'wall.subtitle' => 'Share your feelings and support each other. Posts can be anonymous.',
			'wall.empty' => 'No posts yet. Be the first to share.',
			'wall.add' => 'Share',
			'wall.addTitle' => 'Support Post',
			'wall.editTitle' => 'Edit Post',
			'wall.titleLabel' => 'Title (optional)',
			'wall.titleHint' => 'A short title',
			'wall.contentLabel' => 'How are you feeling?',
			'wall.contentHint' => 'You can let it out; you\'re not alone here.',
			'wall.anonymous' => 'Post anonymously',
			'wall.anonymousUser' => 'Anonymous User',
			'wall.post' => 'Share',
			'wall.posted' => 'Your post was added to the wall.',
			'wall.updated' => 'Post updated.',
			'wall.deleteTitle' => 'Delete Post',
			'wall.deleteConfirm' => 'Are you sure you want to delete this post?',
			'wall.deleted' => 'Post deleted.',
			'wall.errorContent' => 'Please write something.',
			'wall.supportCount' => ({required Object count}) => '${count} support',
			'wall.commentCount' => ({required Object count}) => '${count} comments',
			'wall.detailTitle' => 'Post',
			'wall.commentsTitle' => 'Support Messages',
			'wall.commentHint' => 'Write a message of support…',
			'wall.commentSend' => 'Send',
			'wall.commentSent' => 'Support message sent.',
			'wall.commentEmpty' => 'No support messages yet. Be the first.',
			'wall.commentDeleteTitle' => 'Delete Comment',
			'wall.commentDeleteConfirm' => 'Are you sure you want to delete this support message?',
			'wall.commentDeleted' => 'Comment deleted.',
			'wall.edit' => 'Edit',
			'wall.delete' => 'Delete',
			'wall.cancel' => 'Cancel',
			'wall.save' => 'Save',
			'wall.justNow' => 'just now',
			'wall.minsAgo' => ({required Object count}) => '${count} min ago',
			'wall.hoursAgo' => ({required Object count}) => '${count} h ago',
			'wall.daysAgo' => ({required Object count}) => '${count} d ago',
			'weekly.filterAll' => 'All',
			'weekly.filterExpert' => 'Experts',
			'weekly.filterPopular' => 'Popular',
			'weekly.filterLocal' => 'My city',
			'weekly.searchHint' => 'Search answers',
			'weekly.localHint' => ({required Object city}) => 'Showing answers from families in ${city} only.',
			'weekly.localHintNoCity' => 'No city on your profile; showing all answers.',
			'weekly.noMatch' => 'No answers match this filter.',
			'weekly.title' => 'Question of the Week',
			'weekly.subtitle' => 'This week\'s question for families. Share your experience and support each other.',
			'weekly.empty' => 'No weekly question yet. It will appear here when a new one is published.',
			'weekly.answersTitle' => 'Family Answers',
			'weekly.answerCount' => ({required Object count}) => '${count} answers',
			'weekly.expertCount' => ({required Object count}) => '${count} expert',
			'weekly.expertBadge' => 'Expert',
			'weekly.anonymousUser' => 'Anonymous Family',
			'weekly.yourAnswerTitle' => 'Write Your Answer',
			'weekly.answerHint' => 'Even a short note helps. Share your experience…',
			'weekly.anonymous' => 'Post anonymously',
			'weekly.tagsLabel' => 'Tags (optional)',
			'weekly.send' => 'Share',
			'weekly.sent' => 'Your answer was shared, thank you!',
			'weekly.errorEmpty' => 'Please write an answer.',
			'weekly.noAnswers' => 'No answers yet. Be the first to share.',
			'weekly.likeError' => 'Could not save the like.',
			'weekly.justNow' => 'just now',
			'weekly.minsAgo' => ({required Object count}) => '${count} m ago',
			'weekly.hoursAgo' => ({required Object count}) => '${count} h ago',
			'weekly.daysAgo' => ({required Object count}) => '${count} d ago',
			'meetup.title' => 'Local Meetups',
			'meetup.subtitle' => 'Meet families in your city and spend time together.',
			'meetup.empty' => 'No meetups in this city yet. Be the first to create one.',
			'meetup.add' => 'Create Meetup',
			'meetup.addTitle' => 'New Meetup',
			'meetup.titleLabel' => 'Meetup Name',
			'meetup.titleHint' => 'e.g. Morning Meetup at the Park',
			'meetup.cityLabel' => 'City',
			'meetup.cityHint' => 'Select a city',
			'meetup.districtLabel' => 'District',
			'meetup.districtHint' => 'e.g. Kadıköy',
			'meetup.venueLabel' => 'Venue',
			'meetup.venueHint' => 'e.g. Moda Park or a cafe name',
			'meetup.dateLabel' => 'Date',
			'meetup.timeLabel' => 'Time',
			'meetup.descriptionLabel' => 'Description',
			'meetup.descriptionHint' => 'Who can join, what will it be like?',
			'meetup.create' => 'Create',
			'meetup.created' => 'Your meetup was created. Other families can see it now.',
			'meetup.errorRequired' => 'Please fill in the title, city and date fields.',
			'meetup.attendCount' => ({required Object count}) => '${count} attending',
			'meetup.join' => 'Join',
			'meetup.joined' => 'Attending',
			'meetup.joinedMsg' => 'You\'re attending the meetup!',
			'meetup.leftMsg' => 'Your attendance was cancelled.',
			'meetup.today' => 'Today',
			'meetup.tomorrow' => 'Tomorrow',
			'meetup.inDays' => ({required Object count}) => 'in ${count} days',
			'meetup.past' => 'Past',
			'meetup.organizerBy' => ({required Object name}) => 'Organized by ${name}',
			'similar.title' => 'Similar Families',
			'similar.subtitle' => 'Meet families at a similar stage to your child and share experiences.',
			'similar.noChild' => 'Add a child first, then discover similar families.',
			'similar.discoverable' => 'You\'re discoverable in matching',
			'similar.hidden' => 'You\'re hidden from matching',
			'similar.discoverableHint' => 'If you turn this off, other families won\'t see you in suggestions.',
			'similar.empty' => 'No matching families right now. Updating your profile and tags can improve your chances.',
			'similar.matchLabel' => 'match',
			'similar.commonTagsTitle' => 'Common areas',
			'similar.moreTags' => ({required Object count}) => '+${count}',
			'similar.reasonsTitle' => 'Why you matched',
			'similar.ageRange' => ({required Object range}) => 'Age ${range}',
			'similar.message' => 'Message',
			'similar.buddy' => 'Buddy',
			'similar.mentor' => 'Mentor',
			'similar.pendingLabel' => 'Request pending',
			'similar.buddyLabel' => 'Buddy connection',
			'similar.mentorLabel' => 'Mentor connection',
			'similar.requestTitle' => 'Connection request',
			'similar.mentorRequestTitle' => 'Mentor request',
			'similar.requestHint' => 'Write a short intro message (optional)',
			'similar.requestDefault' => 'Hi, I noticed we\'ve been through similar journeys. If you\'re open to it, I\'d like to start with a brief introduction here.',
			'similar.send' => 'Send Request',
			'similar.sent' => 'Connection request sent.',
			'similar.cancel' => 'Cancel',
			'similar.meetup' => 'Meet up',
			'similar.meetupTitle' => 'Send a meet-up request',
			'similar.meetupOnline' => 'Online',
			'similar.meetupInPerson' => 'In person',
			'similar.meetupPickDate' => 'Pick a date',
			'similar.meetupPickTime' => 'Pick a time',
			'similar.meetupLocation' => 'Meeting place',
			'similar.meetupMessage' => 'Message (optional)',
			'similar.meetupMessageHint' => 'Briefly say why you would like to meet',
			'similar.meetupSent' => 'Meet-up request sent.',
			'similar.meetupRequestsTitle' => 'Meet-up requests',
			'similar.meetupAccept' => 'Accept',
			'similar.meetupDecline' => 'Decline',
			'similar.meetupCancel' => 'Withdraw request',
			'similar.unknownFamily' => 'Family',
			'similar.tabMatches' => 'Matches',
			'similar.tabCircle' => 'My circle',
			'similar.circlePendingTitle' => 'Incoming connection requests',
			'similar.circleAcceptedTitle' => 'My friends and mentors',
			'similar.circleEmpty' => 'Your circle is empty. Start by sending a request from the Matches tab.',
			'similar.circleNoPending' => 'No pending requests.',
			'similar.circleBuddyRequest' => 'Friend request',
			'similar.circleMentorRequest' => 'Mentor request',
			'similar.accept' => 'Accept',
			'similar.reject' => 'Decline',
			'similar.accepted' => 'You are now connected.',
			'similar.rejected' => 'Request declined.',
			'similar.removeBuddy' => 'Remove connection',
			'similar.removeBuddyConfirm' => ({required Object name}) => 'Remove your connection with ${name}?',
			'similar.removed' => 'Connection removed.',
			'similar.requestNote' => 'Request note',
			'similar.withdraw' => 'Withdraw request',
			'similar.withdrawn' => 'Request withdrawn.',
			'similar.distance' => ({required Object km}) => '${km} km away',
			'similar.noCity' => 'City not specified',
			'similar.commPrefWriting' => 'Prefers messaging first',
			'similar.commPrefVideo' => 'Open to video calls',
			'similar.commPrefEvening' => 'Usually replies in the evening',
			'similar.scoresTitle' => 'Match details',
			'similar.scoreTag' => 'Tags',
			'similar.scoreAge' => 'Age',
			'similar.scoreSensory' => 'Sensory',
			'similar.scoreTherapy' => 'Therapy',
			'similar.scoreEducation' => 'Education',
			'groups.chatUnread' => ({required Object count}) => 'Chat (${count})',
			'groups.detailTitle' => 'Group details',
			'groups.detailHint' => 'Members and meetings are visible to group members only.',
			'groups.membersTitle' => 'Members',
			'groups.membersEmpty' => 'Member list is not available.',
			'groups.membersOnly' => 'Join the group to see members and meetings.',
			'groups.meetingsTitle' => 'Meetings',
			'groups.meetingsEmpty' => 'No meetings scheduled.',
			'groups.meetingAdd' => 'Schedule meeting',
			'groups.meetingTitleLabel' => 'Meeting title',
			'groups.meetingPickDate' => 'Pick date',
			'groups.meetingPickTime' => 'Pick time',
			'groups.meetingUrlLabel' => 'Meeting link (optional)',
			'groups.meetingNoteLabel' => 'Description (optional)',
			'groups.meetingSave' => 'Save',
			'groups.meetingCreated' => 'Meeting scheduled.',
			'groups.meetingJoin' => 'Join meeting',
			'groups.meetingDelete' => 'Cancel meeting',
			'groups.meetingDeleteConfirm' => ({required Object title}) => 'Cancel the meeting "${title}"?',
			'groups.meetingErrorTitle' => 'Meeting title is required.',
			'groups.meetingErrorDate' => 'Pick a date and time.',
			'groups.meetingErrorUrl' => 'The link must start with http:// or https://.',
			'groups.title' => 'Support Groups',
			'groups.subtitle' => 'Meet families on similar topics and join the group chat.',
			'groups.tabMy' => 'My Groups',
			'groups.tabDiscover' => 'Discover',
			'groups.searchHint' => 'Search groups…',
			'groups.allCategories' => 'All',
			'groups.emptyMy' => 'You haven\'t joined any group yet. Browse groups in the Discover tab.',
			'groups.emptyDiscover' => 'No groups match these criteria. You can create a new one.',
			'groups.memberCount' => ({required Object count}) => '${count} members',
			'groups.expertCount' => ({required Object count}) => '${count} experts',
			'groups.verified' => 'Verified',
			'groups.join' => 'Join',
			'groups.joined' => 'Joined',
			'groups.leave' => 'Leave',
			'groups.chat' => 'Group Chat',
			'groups.joinedMsg' => 'You joined the group.',
			'groups.leftMsg' => 'You left the group.',
			'groups.leaveTitle' => 'Leave Group',
			_ => null,
		} ?? switch (path) {
			'groups.leaveConfirm' => 'Are you sure you want to leave this group?',
			'groups.add' => 'Create Group',
			'groups.addTitle' => 'New Group',
			'groups.nameLabel' => 'Group Name',
			'groups.nameHint' => 'e.g. Istanbul Early Intervention',
			'groups.descriptionLabel' => 'Description',
			'groups.descriptionHint' => 'What is the group about, who can join?',
			'groups.categoryLabel' => 'Category',
			'groups.create' => 'Create',
			'groups.created' => 'Group created.',
			'groups.errorName' => 'Please enter a group name.',
			'treatment.title' => 'Treatment Panel',
			'treatment.subtitle' => 'Daily Support Plan',
			'treatment.programActiveDefault' => 'The daily support plan is active',
			'treatment.programActive' => ({required Object name}) => '${name} plan is active',
			'treatment.selectChild' => 'Select profile',
			'treatment.noChildrenTitle' => 'No child profile yet',
			'treatment.noChildrenBody' => 'Add a child profile first to build a treatment plan.',
			'treatment.addChild' => 'Add Child',
			'treatment.saveError' => 'Treatment data could not be saved; the change was rolled back.',
			'treatment.tabToday' => 'Today',
			'treatment.tabGoals' => 'Goals',
			'treatment.tabGames' => 'Games',
			'treatment.tabTools' => 'Tools',
			'treatment.daysShort.0' => 'Sun',
			'treatment.daysShort.1' => 'Mon',
			'treatment.daysShort.2' => 'Tue',
			'treatment.daysShort.3' => 'Wed',
			'treatment.daysShort.4' => 'Thu',
			'treatment.daysShort.5' => 'Fri',
			'treatment.daysShort.6' => 'Sat',
			'treatment.onboardTitle' => 'Hello! Start in 3 steps 👋',
			'treatment.onboardBody' => 'This page helps you track the small supports you can do with your child every day.',
			'treatment.onboardStep1' => '1. In the Goals tab, write one small thing to track today.',
			'treatment.onboardStep2' => '2. Try the 5-10 minute activities in the Games tab.',
			'treatment.onboardStep3' => '3. After playing, pick "Easy / Struggled" — the system handles the rest.',
			'treatment.todayTitle' => 'Today\'s short plan',
			'treatment.todaySubtitle' => 'Pick an item, apply it, then mark it as done.',
			'treatment.streakDays' => ({required Object count}) => '${count} day streak',
			'treatment.doneOf' => ({required Object done, required Object total}) => '${done}/${total} done',
			'treatment.stepCount' => ({required Object count}) => '${count} steps',
			'treatment.emptyPlanTitle' => 'No plan found for today.',
			'treatment.emptyPlanBody' => 'Short daily steps will appear here once you add goals.',
			'treatment.planDone' => 'Today\'s plan is complete.',
			'treatment.planDoneSub' => 'That\'s enough for today.',
			'treatment.moodSaveTitle' => 'Log today\'s mood',
			'treatment.moodSaveSub' => 'The plan adapts automatically to your child\'s state',
			'treatment.moodTodayLabel' => ({required Object label}) => 'Today\'s mood: ${label}',
			'treatment.moodPlanned' => 'The plan was prepared for this state',
			'treatment.moodLevel1' => 'Struggling',
			'treatment.moodLevel2' => 'Sensitive',
			'treatment.moodLevel3' => 'Balanced',
			'treatment.moodLevel4' => 'Good',
			'treatment.moodLevel5' => 'Great',
			'treatment.suggestionsTitle' => 'Things to watch today',
			'treatment.latestNoteTitle' => 'Latest note',
			'treatment.defaultExpert' => 'Expert Therapist',
			'treatment.noNoteAuthor' => 'Platform Therapy Module',
			'treatment.noNoteRole' => 'Automatic daily plan',
			'treatment.noNoteBody' => 'No expert note yet. Today\'s plan was prepared from your child\'s records.',
			'treatment.noteEmptyContent' => 'This note has no additional details.',
			'treatment.weeklyTitle' => 'Weekly summary',
			'treatment.weeklySubtitle' => 'This section only shows the overall picture.',
			'treatment.legendGame' => 'Games',
			'treatment.legendGoal' => 'Goals',
			'treatment.chartGames' => ({required Object count}) => '${count} games',
			'treatment.chartGoal' => ({required Object percent}) => '${percent}% goals',
			'treatment.weekGamesTitle' => 'Games this week',
			'treatment.weekGamesDetail' => 'Mini exercises repeated this week',
			'treatment.weekGamesEmpty' => 'You can plan the first game today',
			'treatment.weekGoalsTitle' => 'Goals completed',
			'treatment.weekGoalsDetail' => 'Total progress across all active skill areas',
			'treatment.weekGoalsEmpty' => 'You can add goals from the Goals tab',
			'treatment.weekSessionsTitle' => 'Upcoming sessions',
			'treatment.weekSessionsDetail' => 'Planned appointments or events',
			'treatment.weekSessionsEmpty' => 'No appointments planned yet',
			'treatment.microTitle' => 'Development areas',
			'treatment.microSubtitle' => 'Check here when you need the details.',
			'treatment.microLinkedGame' => 'Supporting game:',
			'treatment.addGoalTitle' => 'Add a Daily Goal',
			'treatment.addGoalSubtitle' => 'Write one small thing you want to track for your child today.',
			'treatment.goalHint' => 'e.g. Made eye contact twice',
			'treatment.focusLabel' => 'Goal area',
			'treatment.dueDateLabel' => 'Due date (optional)',
			'treatment.addGoal' => 'Add Goal',
			'treatment.saving' => 'Saving…',
			'treatment.yourGoals' => 'Goals you added',
			'treatment.edit' => 'Edit',
			'treatment.delete' => 'Delete',
			'treatment.save' => 'Save',
			'treatment.cancel' => 'Cancel',
			'treatment.goalAdded' => 'New goal added.',
			'treatment.goalUpdated' => 'Goal updated.',
			'treatment.goalEdited' => 'Goal edited.',
			'treatment.goalDeleted' => 'Goal deleted.',
			'treatment.groupsHeader' => 'Therapy Goals — Progress by Area',
			'treatment.groupDone' => ({required Object done, required Object total}) => '${done}/${total} completed',
			'treatment.statusDone' => 'Done',
			'treatment.statusActive' => 'Active',
			'treatment.statusUpcoming' => 'Queued',
			'treatment.emptyGroupsTitle' => 'No therapy goals yet',
			'treatment.emptyGroupsBody' => 'Goals are listed here automatically once a therapy type is added to your child\'s profile.',
			'treatment.milestoneTitle' => 'Record a Big Win 🏅',
			'treatment.milestoneSubtitle' => 'An important moment you want to remember',
			'treatment.milestoneHint' => 'e.g. Said their name for the first time',
			'treatment.milestoneSaved' => 'Milestone saved 🎉',
			'treatment.notesTitle' => 'Recent Observation Notes',
			'treatment.notesEmpty' => 'No expert or parent notes for this child yet.',
			'treatment.upcomingTitle' => 'Upcoming Events',
			'treatment.upcomingEmpty' => 'No active sessions or events planned soon.',
			'treatment.goAppointments' => 'Appointments',
			'treatment.goCalendar' => 'Open Calendar',
			'treatment.gamesTitle' => 'Daily Activities',
			'treatment.gamesSubtitle' => 'Short activities suggested from your child\'s therapy goals. Pick how it went after playing.',
			'treatment.todayDone' => ({required Object done, required Object total}) => '${done}/${total} done today',
			'treatment.filterAll' => 'All',
			'treatment.gameReady' => 'Ready',
			'treatment.gameDoneBadge' => '✅ Done',
			'treatment.methodLabel' => ({required Object name}) => 'Method: ${name}',
			'treatment.whyGood' => 'Why it helps',
			'treatment.goalBadge' => ({required Object name}) => 'Goal: ${name}',
			'treatment.toolBadge' => ({required Object name}) => 'Tool: ${name}',
			'treatment.playToday' => 'Play today',
			'treatment.playedToday' => 'Marked as done',
			'treatment.feedbackQuestion' => 'How did it go? (optional)',
			'treatment.fbNone' => 'No result selected yet',
			'treatment.fbEasy' => 'Very easy',
			'treatment.fbAssisted' => 'With help',
			'treatment.fbIndependent' => 'On their own',
			'treatment.fbChallenging' => 'Struggled',
			'treatment.fbEasyLong' => 'Found it easy',
			'treatment.fbAssistedLong' => 'Did it with help',
			'treatment.fbIndependentLong' => 'Did it independently',
			'treatment.fbChallengingLong' => 'Struggled',
			'treatment.feedbackSaved' => 'Game feedback saved.',
			'treatment.allDoneTitle' => '🎉 All of today\'s games are done. You\'re doing great!',
			'treatment.allDoneBody' => 'You completed today\'s support flow; you can add a short observation to the notes if you like.',
			'treatment.hintMastered' => 'Mastered it! Try a harder variant.',
			'treatment.hintEasy' => 'Finding it very easy. Increase the difficulty.',
			'treatment.hintChallenging' => 'Struggling. Break the activity into smaller parts.',
			'treatment.notifyExpert' => 'Notify Expert',
			'treatment.notifyBody' => ({required Object game}) => 'Send your expert a short note about the difficulty in ${game}.',
			'treatment.notifyDefaultMsg' => ({required Object game}) => '"${game}" aktivitesinde son zamanlarda zorlanıyor. Önerisi olan var mı?',
			'treatment.notifyNoExpert' => 'You haven\'t messaged an expert yet. Connect with an expert first.',
			'treatment.notifySeeExperts' => 'View Experts',
			'treatment.notifySend' => 'Send',
			'treatment.notifySent' => 'Expert notified.',
			'treatment.emptyGames' => 'No activities suggested for this area yet. They appear once therapy info is added to your child\'s profile.',
			'treatment.historyTitle' => 'Game History',
			'treatment.historySubtitle' => 'The history of played activities appears here.',
			'treatment.historyCount' => ({required Object count}) => '${count} records',
			'treatment.historyEmpty' => 'No game records yet. History appears after the first record.',
			'treatment.challengingSummary' => ({required Object count}) => '💪 "Struggled" was marked in ${count} activities. Consider breaking them into smaller steps or notifying your expert when retrying.',
			'treatment.storiesTitle' => 'Social Stories & Visual Flow',
			'treatment.storiesSubtitle' => 'Short picture stories that answer "What will happen?" before an activity — they ease transitions.',
			'treatment.customBadge' => 'Custom story',
			'treatment.linkedGoalBadge' => ({required Object name}) => 'Linked goal: ${name}',
			'treatment.addStoryTitle' => 'Add a Custom Social Story',
			'treatment.storyTitleHint' => 'Story title (e.g. Going Shopping)',
			'treatment.storyGoalHint' => 'Linked goal (optional)',
			'treatment.storyAdd' => 'Add',
			'treatment.storyAdded' => 'Social story added.',
			'treatment.storyDeleted' => 'Story deleted.',
			'treatment.deleteStoryTitle' => 'Delete Story',
			'treatment.deleteStoryConfirm' => 'Are you sure you want to delete this story?',
			'treatment.sensoryTitle' => 'Comfort Settings',
			'treatment.sensorySubtitle' => 'Measurement Cards',
			'treatment.sensorySaved' => 'Sensory profile updated.',
			'treatment.sliderHeader' => 'Sensory Sensitivity Levels',
			'treatment.sliderSound' => '🔊 Sound Sensitivity',
			'treatment.sliderTouch' => '🖐️ Tactile Sensitivity',
			'treatment.sliderVisual' => '👁️ Visual Sensitivity',
			'treatment.metricSound' => 'Sound sensitivity',
			'treatment.metricTouch' => 'Tactile sensitivity',
			'treatment.metricVisual' => 'Visual stimulus tolerance',
			'treatment.metricSoundNote' => 'Monitored together with the sensory break game during transitions.',
			'treatment.metricTouchNote' => 'Tactile stimuli are supported with turn-taking and pressure activities.',
			'treatment.metricVisualNote' => 'Kept in balance with visual stories and the timeline.',
			'treatment.triggerTitle' => 'Trigger Log',
			'treatment.tokenTitle' => 'Digital Token Board',
			'treatment.tokenSubtitle' => 'Pick a goal with your child. Add a star for each success. At 5 stars they earn the reward!',
			'treatment.tokenRewardLabel' => 'Target Reward',
			'treatment.tokenRewardHint' => 'e.g. Riding the swing 🛝',
			'treatment.tokenSetReward' => 'Set Reward',
			'treatment.tokenActive' => 'Active Reward',
			'treatment.tokenCollect' => ({required Object count}) => 'Collect success stars (${count}/5)',
			'treatment.tokenAdd' => '⭐ Add Star',
			'treatment.tokenFullTitle' => 'Congrats! The token card is full',
			'treatment.tokenFullBody' => ({required Object reward}) => 'Your child completed all the steps and earned ${reward}!',
			'treatment.tokenReset' => 'Reset Board',
			'treatment.tokenDefaultReward' => 'Going to the park 🛝',
			'treatment.breathTitle' => 'Breathing Exercise',
			'treatment.breathBody' => 'When your child feels overstimulated, use the breathing regulator in the Crisis Guide together.',
			'treatment.breathOpen' => 'Open Breathing Exercise',
			'treatment.aiStoryTitle' => 'Social Story with AI',
			'treatment.aiStoryBody' => 'Ask the AI Assistant for a short custom social story draft for a new situation.',
			'treatment.aiStoryOpen' => 'Open AI Assistant',
			'tasks.title' => 'My Assignments',
			'tasks.subtitle' => 'Tasks assigned by your expert appear here; submit them as you complete each one.',
			'tasks.pendingLabel' => 'Pending',
			'tasks.completedLabel' => 'Completed',
			'tasks.progressLabel' => 'How much is done',
			'tasks.overdueSummary' => ({required Object count}) => '${count} task(s) are past their due date',
			'tasks.filterAll' => ({required Object count}) => 'All (${count})',
			'tasks.filterPending' => ({required Object count}) => 'To Do (${count})',
			'tasks.filterCompleted' => ({required Object count}) => 'Submitted (${count})',
			'tasks.emptyAll' => 'No tasks have been assigned by an expert yet. When your expert sets new assignments you will see them here.',
			'tasks.emptyPending' => 'No pending tasks.',
			'tasks.emptyCompleted' => 'No completed tasks.',
			'tasks.overdueBanner' => 'Due date passed! Your expert is waiting for the submission.',
			'tasks.difficultyEasy' => 'Easy',
			'tasks.difficultyMedium' => 'Medium',
			'tasks.difficultyHard' => 'Hard',
			'tasks.dueLabel' => ({required Object date}) => 'Due: ${date}',
			'tasks.detailLabel' => 'Task Details',
			'tasks.openMaterial' => 'Open Required Material',
			'tasks.submitTask' => 'Submit Task',
			'tasks.submitted' => 'Task submitted to your expert!',
			'tasks.submissionsError' => 'Could not load the submission record.',
			'tasks.noSubmission' => 'No submission record found for this task (it may be an old task).',
			'tasks.yourNote' => 'Your Note',
			'tasks.evidenceLink' => 'Attached Evidence / Video',
			'tasks.expertFeedback' => 'Expert Review',
			'tasks.expertApprovedNoNote' => 'The expert approved but left no note.',
			'tasks.awaitingReview' => 'Awaiting expert review…',
			'tasks.submitTitle' => 'Submit Task',
			'tasks.selectedTask' => 'Selected Task',
			'tasks.noteLabel' => 'Note for Your Expert',
			'tasks.noteHint' => 'How did your child feel doing this task? (e.g. Completed it very comfortably)',
			'tasks.evidenceLabel' => 'Evidence / Attachment Link (Optional)',
			'tasks.evidenceHint' => 'You can add a cloud link to a video or photo of the practice moment so your expert can see it.',
			'tasks.submitConfirm' => 'Submit and Close',
			'tasks.viewWizard' => 'Wizard',
			'tasks.viewList' => 'List',
			'tasks.wizardBadge' => 'Daily Progress Flow',
			'tasks.wizardTitle' => 'Today\'s Exercise Guide',
			'tasks.wizardIntro' => 'Practise with your child by following the steps. When you are done, just tap one of the options below.',
			'tasks.wizardStageLevel' => ({required Object label}) => '${label} level',
			'tasks.wizardStageCount' => ({required Object done, required Object total}) => '${done} / ${total} exercises completed',
			'tasks.wizardAllDoneTitle' => 'Great work! Today\'s exercises are all done',
			'tasks.wizardAllDoneBody' => 'Every quality minute you spend with your child makes a big difference. New tasks will appear here when they are assigned.',
			'tasks.wizardStepCounter' => ({required Object index, required Object total}) => '${index} / ${total}',
			'tasks.wizardDefaultCategory' => 'Development Exercise',
			'tasks.wizardHowTo' => 'How to do it (step by step)',
			'tasks.wizardDefaultDescription' => 'Try this activity with your child for 5-10 minutes in a calm setting.',
			'tasks.wizardFrequency' => ({required Object value}) => 'Frequency: ${value}',
			'tasks.wizardOutcomeQuestion' => 'How did this exercise go today?',
			'tasks.outcomeEasyTitle' => 'We did it easily',
			'tasks.outcomeEasyDesc' => 'My child managed it comfortably',
			'tasks.outcomeSupportedTitle' => 'We did it with support',
			'tasks.outcomeSupportedDesc' => 'We finished it with a few prompts',
			'tasks.outcomeHardTitle' => 'Today was hard',
			'tasks.outcomeHardDesc' => 'We were not quite ready yet',
			'tasks.wizardTipTitle' => 'AutiBot tip',
			'tasks.wizardTipBody' => 'No problem at all. Motivation can change day to day for children on the autism spectrum. Try breaking the exercise into smaller parts and repeating it tomorrow in a shorter, 2-minute session. You can also leave a note for your expert.',
			'tasks.wizardNoteLabel' => 'A note for your expert (optional)',
			'tasks.wizardNoteHint' => 'e.g. Really enjoyed it, or got distracted quickly…',
			'tasks.wizardAddPhoto' => 'Add a photo of the moment',
			'tasks.wizardChangePhoto' => 'Change photo',
			'tasks.wizardPhotoAdded' => 'Photo added',
			'tasks.wizardRemovePhoto' => 'Remove',
			'tasks.wizardSourceGallery' => 'Choose from gallery',
			'tasks.wizardSourceCamera' => 'Take a photo',
			'tasks.wizardSubmit' => 'Save and complete exercise',
			'tasks.wizardSubmitted' => 'Congratulations! Today\'s exercise is complete 🎉',
			'tasks.wizardDone' => 'This exercise has been submitted',
			'tasks.wizardDoneHint' => 'It reached your expert; you can move on to the next exercise.',
			'tasks.wizardPrev' => 'Previous exercise',
			'tasks.wizardNext' => 'Next exercise',
			'tasks.wizardTreeTitle' => 'Your child\'s progress tree',
			'tasks.stageSeed' => 'Seed',
			'tasks.stageSeedDesc' => 'A new journey is beginning',
			'tasks.stageSprout' => 'Sprout',
			'tasks.stageSproutDesc' => 'Awareness and settling-in phase',
			'tasks.stageFlower' => 'Flower',
			'tasks.stageFlowerDesc' => 'Regular practice together',
			'tasks.stageTree' => 'Tree',
			'tasks.stageTreeDesc' => 'Wonderful! The skill is fully independent',
			'forum.title' => 'Community Forum',
			'forum.typeExperience' => 'Experiences',
			'forum.typeQuestion' => 'Q&A',
			'forum.typeAdvice' => 'Advice',
			'forum.typeSuccess' => 'Success Stories',
			'forum.catCommunication' => 'Communication',
			'forum.catSocial' => 'Social',
			'forum.catSensory' => 'Sensory',
			'forum.catBehavior' => 'Behavior',
			'forum.catMotor' => 'Motor',
			'forum.catEducation' => 'Education',
			'forum.justNow' => 'just now',
			'forum.minsAgo' => ({required Object count}) => '${count} min ago',
			'forum.hoursAgo' => ({required Object count}) => '${count} h ago',
			'forum.daysAgo' => ({required Object count}) => '${count} d ago',
			'forum.searchHint' => 'Search the forum…',
			'forum.tagFilter' => 'Tag filter',
			'forum.sortNew' => 'New',
			'forum.sortHot' => 'Hot',
			'forum.sortUnanswered' => 'Unanswered',
			'forum.sortExpert' => 'Expert',
			'forum.empty' => 'No posts yet. Start by sharing an experience with the community.',
			'forum.emptyQuestion' => 'No questions yet. Ask the first question to start the discussion.',
			'forum.add' => 'Share',
			'forum.loadMore' => 'Load More',
			'forum.posted' => 'Post shared.',
			'forum.anonymousUser' => 'Anonymous User',
			'forum.expertBadge' => 'Expert',
			'forum.pinnedBadge' => 'Pinned',
			'forum.answeredBadge' => 'Answered',
			'forum.postTitle' => 'Post',
			'forum.commentsHeader' => ({required Object count}) => 'Comments (${count})',
			'forum.commentsError' => 'Could not load comments.',
			'forum.noComments' => 'No comments yet. Be the first to write one.',
			'forum.commentHint' => 'Write a comment…',
			'forum.replyHint' => 'Write your reply…',
			'forum.replyingTo' => ({required Object name}) => 'Replying to ${name}',
			'forum.reply' => 'Reply',
			'forum.acceptAnswer' => 'Best Answer',
			'forum.answerAccepted' => 'Marked as best answer.',
			'forum.acceptedBadge' => 'Best Answer',
			'forum.expertApproved' => 'Expert Approved',
			'forum.editComment' => 'Edit Comment',
			'forum.deleteCommentTitle' => 'Delete Comment',
			'forum.deleteCommentConfirm' => 'Are you sure you want to delete this comment?',
			'forum.deleteTitle' => 'Delete Post',
			'forum.deleteConfirm' => 'Are you sure you want to delete this post?',
			'forum.cancel' => 'Cancel',
			'forum.delete' => 'Delete',
			'forum.save' => 'Save',
			'forum.reportTitle' => 'Report',
			'forum.reportHint' => 'Briefly describe the reason for your report',
			'forum.reportSend' => 'Send',
			'forum.reportSent' => 'Your report has been received.',
			'forum.newPost' => 'New Post',
			'forum.editPost' => 'Edit Post',
			'forum.titleLabel' => 'Title',
			'forum.titleHintQuestion' => 'Briefly summarize your question',
			'forum.titleHint' => 'Title of your post',
			'forum.contentLabel' => 'Content',
			'forum.tagsLabel' => 'Symptom Tags',
			'forum.anonymousTitle' => 'Share Anonymously',
			'forum.anonymousBody' => 'Your profile details are hidden; you appear as "Anonymous User".',
			'forum.privacyTitle' => 'Privacy Settings',
			'forum.privacyRealName' => 'Show my real name',
			'forum.privacyChildAge' => 'Show my child\'s age range',
			'forum.privacySymptoms' => 'Show symptom tags',
			'forum.privacyDiagnosis' => 'Show diagnosis details',
			'forum.privacyMatching' => 'Allow use in the matching algorithm',
			'forum.share' => 'Share',
			'childDetail.title' => 'Child Profile',
			'childDetail.editProfile' => 'Edit Profile',
			'childDetail.ageYears' => ({required Object age}) => '${age} yrs',
			'childDetail.genderBoy' => 'Boy',
			'childDetail.genderGirl' => 'Girl',
			'childDetail.photoUpdated' => 'Profile photo updated.',
			'childDetail.infoTitle' => 'Details',
			'childDetail.infoEmpty' => 'No diagnosis/education info yet. You can edit the profile from the top right.',
			'childDetail.diagnosis' => 'Diagnosis Info',
			'childDetail.educationProgram' => 'Education Program',
			'childDetail.therapies' => 'Therapies',
			'childDetail.tagsTitle' => 'Symptom Tags',
			'childDetail.tagsEmpty' => 'No tags selected yet. Tags are used in similar-family matching and the forum.',
			'childDetail.tagsEdit' => 'Edit Tags',
			'childDetail.tagsError' => 'Could not load tags.',
			'childDetail.edit' => 'Edit',
			'childDetail.save' => 'Save',
			'childDetail.cancel' => 'Cancel',
			'childDetail.delete' => 'Delete',
			'childDetail.milestonesTitle' => 'Milestones',
			'childDetail.milestonesEmpty' => 'No milestones yet. Record the first big achievement!',
			'childDetail.milestonesError' => 'Could not load milestones.',
			'childDetail.milestoneAdd' => 'Add',
			'childDetail.milestoneEdit' => 'Edit Milestone',
			'childDetail.milestoneTitleLabel' => 'Title',
			'childDetail.milestoneTitleHint' => 'e.g. Made eye contact for the first time',
			'childDetail.milestoneDescLabel' => 'Description (optional)',
			'childDetail.milestoneSave' => 'Add Milestone',
			'childDetail.milestoneDeleteTitle' => 'Delete Milestone',
			'childDetail.milestoneDeleteConfirm' => 'Are you sure you want to delete this record?',
			'childDetail.screeningTitle' => 'Screening Results',
			'childDetail.screeningEmpty' => 'No screening results yet.',
			'childDetail.scoreOf' => ({required Object score}) => '${score}/20',
			'childDetail.riskLow' => 'Low risk',
			'childDetail.riskMedium' => 'Medium risk',
			'childDetail.riskHigh' => 'High risk',
			'childDetail.shortcutsTitle' => 'Quick Access',
			'childDetail.shortcutTracker' => 'Daily Tracker',
			'childDetail.shortcutBehavior' => 'Behavior Journal',
			'childDetail.shortcutTreatment' => 'Treatment Panel',
			'childDetail.shortcutAnalytics' => 'Progress Panel',
			'crisis.title' => 'Crisis Guide',
			'crisis.heroTitle' => 'What To Do in Hard Moments?',
			'crisis.heroSubtitle' => 'A quick guide to help you stay calm and take the right steps when your child is overwhelmed.',
			'crisis.breathingTitle' => 'Breathing Regulator',
			'crisis.breathingSubtitle' => 'Calm yourself first. Start and match your breathing to the ring\'s expand-and-shrink pace.',
			'crisis.breathingStart' => 'Start Exercise',
			'crisis.breathingStop' => 'Stop',
			'crisis.breathingReady' => 'Ready',
			'crisis.breathingReadyHint' => 'Tap to start',
			'crisis.breathingInhale' => 'Breathe In',
			'crisis.breathingExhale' => 'Breathe Out',
			'crisis.breathingSeconds' => 'seconds',
			'crisis.stepsLabel' => 'What To Do?',
			'crisis.avoidLabel' => 'What To Avoid',
			'crisis.emergencyLabel' => 'Suggested Emergency Line',
			'crisis.contactsTitle' => 'Emergency Numbers',
			'crisis.disclaimer' => 'This guide is for general information; in emergencies or medical situations always call your local emergency number.',
			'crisis.contact112Label' => 'Emergency Health and Safety',
			'crisis.contact112Desc' => 'Ambulance, Police, Fire',
			'crisis.contact183Label' => 'Social Support Line',
			'crisis.contact183Desc' => 'Family, Children and Social Services',
			'crisis.listen' => 'Listen',
			'crisis.listenStop' => 'Stop',
			'crisis.listenIntro' => 'What to do',
			'crisis.listenUnavailable' => 'Speech playback is not available on this device.',
			'crisis.medicalTitle' => 'Important medical warning',
			'crisis.medicalBody' => 'This guide does not replace professional medical or psychiatric care. In case of loss of consciousness, a severe seizure, breathing difficulty or serious harm, call your local emergency number immediately.',
			'crisis.medicalMore' => 'More details',
			'crisis.quickTipTitle' => 'First rule',
			'crisis.quickTipBody' => 'Stay calm yourself. Your child mirrors your emotional state. Take a deep breath and move slowly.',
			'crisis.afterTitle' => 'After the crisis — recovery time',
			'crisis.afterItems.0' => 'Stay quietly with your child in a calm setting; do not push them to talk.',
			'crisis.afterItems.1' => 'Let them feel loved and safe.',
			'crisis.afterItems.2' => 'Note the triggers (date, time, setting, what happened before).',
			'crisis.afterItems.3' => 'Tell your expert team about the crisis.',
			'crisis.afterItems.4' => 'Make time for yourself too — caregivers get tired as well.',
			'crisis.cards.meltdown.title' => 'Crisis / Meltdown',
			'crisis.cards.meltdown.subtitle' => 'Loss of control, crying, screaming, self-harm attempts',
			'crisis.cards.meltdown.steps.0' => 'Stay calm — your voice and body language transfer to the child.',
			'crisis.cards.meltdown.steps.1' => 'Create a safe space: move away sharp or hard objects.',
			'crisis.cards.meltdown.steps.2' => 'Keep verbal input minimal; single words or short sentences.',
			'crisis.cards.meltdown.steps.3' => 'Reduce sensory input: dim the lights, lower the sound.',
			'crisis.cards.meltdown.steps.4' => 'Stay nearby — don\'t leave, but don\'t touch.',
			'crisis.cards.meltdown.steps.5' => 'Once the crisis passes, reassure with a calm tone.',
			'crisis.cards.meltdown.avoid.0' => 'Don\'t speak loudly.',
			'crisis.cards.meltdown.avoid.1' => 'Don\'t try to reason or explain.',
			'crisis.cards.meltdown.avoid.2' => 'Don\'t punish or threaten.',
			'crisis.cards.meltdown.avoid.3' => 'Don\'t leave them in a crowd.',
			'crisis.cards.meltdown.emergency' => '112 — Emergency Health Line',
			'crisis.cards.sensory.title' => 'Sensory Overload',
			'crisis.cards.sensory.subtitle' => 'Covering ears, avoiding light/sound, freezing',
			'crisis.cards.sensory.steps.0' => 'Move to a calmer, less stimulating environment right away.',
			'crisis.cards.sensory.steps.1' => 'Offer favorite sensory objects (weighted blanket, squishy).',
			'crisis.cards.sensory.steps.2' => 'Speak briefly in a predictable, calm tone.',
			'crisis.cards.sensory.steps.3' => 'Deep pressure (firm hug) may help if the child consents.',
			'crisis.cards.sensory.steps.4' => 'Give time — stay quiet for a few minutes.',
			'crisis.cards.sensory.steps.5' => 'Note the trigger and take precautions going forward.',
			'crisis.cards.sensory.avoid.0' => 'Don\'t keep giving verbal directions without changing the environment.',
			'crisis.cards.sensory.avoid.1' => 'Don\'t force them to hold anything.',
			'crisis.cards.sensory.avoid.2' => 'Don\'t say "Why are you overreacting?"',
			'crisis.cards.aggression.title' => 'Aggression / Self-Harm',
			'crisis.cards.aggression.subtitle' => 'Hitting, biting, head-banging, throwing objects',
			'crisis.cards.aggression.steps.0' => 'Keep a safe distance; move others away if nearby.',
			'crisis.cards.aggression.steps.1' => 'Give low, short, calm directives ("Stop", "Here").',
			'crisis.cards.aggression.steps.2' => 'Remove provoking objects and people from the area.',
			'crisis.cards.aggression.steps.3' => 'Offer an alternative outlet: hitting a pillow, running.',
			'crisis.cards.aggression.steps.4' => 'Once it passes, note the event; analyze the trigger.',
			'crisis.cards.aggression.avoid.0' => 'Avoid using physical force (unless necessary).',
			'crisis.cards.aggression.avoid.1' => 'Don\'t fuel it by drawing attention or creating an audience.',
			'crisis.cards.aggression.avoid.2' => 'Don\'t reward during the behavior.',
			'crisis.cards.aggression.emergency' => '112 — Emergency Call Center',
			'crisis.cards.anxiety.title' => 'Intense Anxiety / Panic',
			'crisis.cards.anxiety.subtitle' => 'Trembling, shortness of breath, crying, withdrawing',
			'crisis.cards.anxiety.steps.0' => 'Say in a calm tone, "I\'m here, you\'re safe."',
			'crisis.cards.anxiety.steps.1' => 'Do a deep breathing exercise: 4 seconds in, 6 seconds out.',
			'crisis.cards.anxiety.steps.2' => 'Use the "see 5 things, touch 4 things" grounding exercise.',
			'crisis.cards.anxiety.steps.3' => 'Offer a safe person or object (favorite toy, headphones).',
			'crisis.cards.anxiety.steps.4' => 'Give time for it to pass; don\'t rush them.',
			'crisis.cards.anxiety.avoid.0' => 'Don\'t belittle it by saying "Calm down, it\'s fine."',
			'crisis.cards.anxiety.avoid.1' => 'Don\'t keep asking and applying pressure.',
			'crisis.cards.anxiety.avoid.2' => 'Don\'t add new demands during anxiety.',
			'calendar.title' => 'Calendar',
			'calendar.subtitle' => 'Child-specific therapy, doctor and activity schedule.',
			'calendar.noChild' => 'Add a child first to use the calendar.',
			'calendar.empty' => 'No events yet. Add the first one.',
			'calendar.add' => 'Add Event',
			'calendar.addTitle' => 'New Event',
			'calendar.editTitle' => 'Edit Event',
			'calendar.eventType' => 'Event Type',
			'calendar.typeTerapi' => 'Therapy',
			'calendar.typeDoktor' => 'Doctor',
			'calendar.typeEgitim' => 'Education',
			'calendar.typeAktivite' => 'Activity',
			'calendar.typeAppointment' => 'Appointment',
			'calendar.typeDiger' => 'Other',
			'calendar.eventTitle' => 'Title',
			'calendar.titleHint' => 'Event name',
			'calendar.location' => 'Location',
			'calendar.locationHint' => 'Clinic name, address',
			'calendar.description' => 'Description',
			'calendar.start' => 'Start',
			'calendar.end' => 'End (optional)',
			'calendar.reminder' => 'Reminder',
			'calendar.reminderOff' => 'Off',
			'calendar.reminderMin' => ({required Object count}) => '${count} min before',
			'calendar.reminderHour' => ({required Object count}) => '${count} h before',
			'calendar.reminderDay' => '1 day before',
			'calendar.statusPlanned' => 'Planned',
			'calendar.statusCompleted' => 'Completed',
			'calendar.statusCancelled' => 'Cancelled',
			'calendar.markCompleted' => 'Mark completed',
			'calendar.markPlanned' => 'Mark planned',
			'calendar.markCancelled' => 'Cancel event',
			'calendar.today' => 'Today',
			'calendar.tomorrow' => 'Tomorrow',
			'calendar.save' => 'Save',
			'calendar.saved' => 'Event saved.',
			'calendar.deleteTitle' => 'Delete Event',
			'calendar.deleteConfirm' => ({required Object title}) => 'Are you sure you want to delete "${title}"?',
			'calendar.deleted' => 'Event deleted.',
			'calendar.errorTitle' => 'Please enter a title.',
			'calendar.cancel' => 'Cancel',
			'calendar.delete' => 'Delete',
			_ => null,
		} ?? switch (path) {
			'emergency.title' => 'Emergency Card',
			'emergency.subtitle' => 'Information to show to anyone who meets your child in an emergency.',
			'emergency.noChild' => 'Add a child first to create an emergency card.',
			'emergency.lastUpdated' => ({required Object date}) => 'Last updated ${date}',
			'emergency.notSaved' => 'This card has not been saved yet.',
			'emergency.save' => 'Save',
			'emergency.saved' => 'Emergency card saved.',
			'emergency.shareTitle' => 'Share with a QR code',
			'emergency.shareBody' => 'Create a time-limited link; a teacher or paramedic can open the card from it. You can revoke the link at any time.',
			'emergency.shareConsentRequired' => 'Sharing requires the "Emergency card sharing" consent.',
			'emergency.shareOpenConsents' => 'Open consent settings',
			'emergency.shareDuration' => 'Validity period',
			'emergency.share24h' => 'Valid for 24 hours',
			'emergency.share3d' => 'Valid for 3 days',
			'emergency.share1w' => 'Valid for 1 week',
			'emergency.share30d' => 'Valid for 30 days',
			'emergency.shareEnable' => 'Create share link',
			'emergency.shareDisable' => 'Turn sharing off',
			'emergency.shareValidUntil' => ({required Object date}) => 'The link is valid until ${date}.',
			'emergency.shareCopy' => 'Copy link',
			'emergency.shareCopied' => 'Link copied.',
			'emergency.shareSend' => 'Share',
			'emergency.shareMessage' => 'You can view my child\'s emergency card here:',
			'emergency.call' => 'Call',
			'emergency.sectionChild' => 'Child Information',
			'emergency.sectionContacts' => 'Emergency Contacts',
			'emergency.sectionMedical' => 'Medical Information',
			'emergency.sectionBehavior' => 'Behavioral Information',
			'emergency.childName' => 'Full Name',
			'emergency.birthDate' => 'Date of Birth',
			'emergency.diagnosis' => 'Diagnosis',
			'emergency.bloodType' => 'Blood Type',
			'emergency.communicationLevel' => 'Communication Level',
			'emergency.languages' => 'Language(s) Spoken',
			'emergency.warningsLabel' => 'Special condition warnings',
			'emergency.selfInjury' => 'May exhibit self-injury',
			'emergency.wandering' => 'Risk of wandering / getting lost',
			'emergency.nonVerbal' => 'Non-verbal',
			'emergency.contact1' => 'First Contact',
			'emergency.contact2' => 'Second Contact',
			'emergency.doctor' => 'Doctor / Hospital',
			'emergency.name' => 'Full Name',
			'emergency.phone' => 'Phone',
			'emergency.relation' => 'Relationship',
			'emergency.doctorName' => 'Doctor Name',
			'emergency.doctorPhone' => 'Doctor Phone',
			'emergency.hospital' => 'Hospital',
			'emergency.medications' => 'Current Medications',
			'emergency.medicationsHint' => 'Name - dose - time (one medication per line)',
			'emergency.allergies' => 'Allergies',
			'emergency.allergiesHint' => 'Food, drug, substance allergies',
			'emergency.conditions' => 'Other Medical Conditions',
			'emergency.conditionsHint' => 'Epilepsy, heart condition, etc.',
			'emergency.triggers' => 'Triggers (to avoid)',
			'emergency.triggersHint' => 'What causes a crisis? E.g. sudden noise, crowds',
			'emergency.calming' => 'Calming Strategies',
			'emergency.calmingHint' => 'What helps? E.g. favorite music, quiet room',
			'emergency.avoid' => 'Things to Never Do',
			'emergency.avoidHint' => 'E.g. don\'t shout, don\'t restrain, don\'t force eye contact',
			'emergency.special' => 'Special Instructions',
			'emergency.specialHint' => 'Extra notes for emergency services or caregivers',
			'emergency.select' => 'Select...',
			'behavior.title' => 'Behavior Journal',
			'behavior.subtitle' => 'ABC (Antecedent-Behavior-Consequence) observation log',
			'behavior.add' => 'Add Entry',
			'behavior.addTitle' => 'New ABC Entry',
			'behavior.empty' => 'No behavior entries yet. Add the first observation.',
			'behavior.noChild' => 'Add a child first to use the behavior journal.',
			'behavior.date' => 'Date',
			'behavior.time' => 'Time',
			'behavior.category' => 'Category',
			'behavior.location' => 'Location',
			'behavior.antecedentLabel' => 'A — Antecedent (Trigger)',
			'behavior.antecedentHint' => 'Describe the trigger',
			'behavior.behaviorLabel' => 'B — Behavior (What happened?)',
			'behavior.behaviorHint' => 'Describe the behavior in detail',
			'behavior.consequenceLabel' => 'C — Consequence (What did you do?)',
			'behavior.consequenceHint' => 'Describe your intervention',
			'behavior.other' => 'Other...',
			'behavior.intensityLabel' => 'Intensity',
			'behavior.intensity1' => 'Very Mild',
			'behavior.intensity2' => 'Mild',
			'behavior.intensity3' => 'Moderate',
			'behavior.intensity4' => 'Severe',
			'behavior.intensity5' => 'Very Severe',
			'behavior.notesLabel' => 'Additional notes (optional)',
			'behavior.save' => 'Save',
			'behavior.saved' => 'ABC entry created.',
			'behavior.deleteTitle' => 'Delete Entry',
			'behavior.deleteConfirm' => ({required Object date}) => 'Are you sure you want to delete the ABC entry dated ${date}?',
			'behavior.deleted' => 'Entry deleted.',
			'behavior.errorRequired' => 'Please fill the required fields (category, location, A, B, C).',
			'analytics.title' => 'Development Panel',
			'analytics.subtitle' => 'Development trends over the last 6 months.',
			'analytics.milestones' => 'Milestones',
			'analytics.milestonesUnit' => 'achievements per month',
			'analytics.mood' => 'Average Mood',
			'analytics.moodUnit' => 'monthly average (1-5)',
			'analytics.sleep' => 'Average Sleep',
			'analytics.sleepUnit' => 'hours per night (monthly average)',
			'analytics.behavior' => 'Behavior Logs',
			'analytics.behaviorUnit' => 'entries per month',
			'analytics.noData' => 'No data in this range yet.',
			'analytics.noChild' => 'Add a child first to see the development panel.',
			'analytics.aiTitle' => 'AI analysis',
			'analytics.aiSubtitle' => 'Summarises patterns in your child\'s records; it does not diagnose.',
			'analytics.aiTypeGeneral' => 'General',
			'analytics.aiTypeBehavioral' => 'Behaviour',
			'analytics.aiTypeProgress' => 'Progress',
			'analytics.aiTypeWeekly' => 'Weekly',
			'analytics.aiStart' => ({required Object type}) => 'Start the ${type} analysis',
			'analytics.aiRunning' => 'Preparing the analysis…',
			'analytics.aiError' => 'The analysis could not be fetched. Please try again.',
			'analytics.aiDisclaimer' => 'This summary is informational; it is not a medical diagnosis or treatment advice.',
			'analytics.aiConsentTitle' => 'AI analysis needs your consent',
			'analytics.aiConsentBody' => 'Analysing your child\'s records requires explicit consent. You can grant it on the privacy and consents page.',
			'analytics.aiConsentAction' => 'Manage consents',
			'analytics.rangeDays' => ({required Object count}) => 'Last ${count} days',
			'analytics.scoreTitle' => 'Tracking score',
			'analytics.scoreCoverage' => ({required Object count, required Object total}) => 'Records in ${count} of ${total} data types',
			'analytics.scoreStrong' => 'Strong tracking',
			'analytics.scoreGrowing' => 'Tracking is growing',
			'analytics.scoreWaiting' => 'Waiting for data',
			'analytics.actionsTitle' => 'Missing data',
			'analytics.actionMood' => 'Add a mood entry',
			'analytics.actionSleep' => 'Add a sleep entry',
			'analytics.actionNote' => 'Write a development note',
			'analytics.actionMilestone' => 'Add a milestone',
			'analytics.insightMoodHigh' => ({required Object days, required Object value}) => 'Average mood over the last ${days} days is ${value}/5 — quite high.',
			'analytics.insightMoodLow' => ({required Object days, required Object value}) => 'Average mood over the last ${days} days is ${value}/5 — there may be some difficulties.',
			'analytics.insightSleepShort' => ({required Object value}) => 'Average sleep is ${value} — 8-10 hours is recommended for enough rest.',
			'analytics.insightSleepGood' => ({required Object value}) => 'Sleep looks good: ${value} on average.',
			'analytics.insightMilestones' => ({required Object category, required Object count}) => 'Most milestones are in "${category}" (${count} of them).',
			'analytics.insightAppointments' => ({required Object count}) => '${count} appointments completed.',
			'analytics.insightAppointmentsWithPending' => ({required Object count, required Object pending}) => '${count} appointments completed, ${pending} still active.',
			'analytics.dailyMood' => 'Mood trend',
			'analytics.dailyMoodUnit' => 'daily entry (1-5)',
			'analytics.dailySleep' => 'Sleep pattern',
			'analytics.dailySleepUnit' => 'nightly duration (hours)',
			'analytics.dailySleepQuality' => 'quality (1-5)',
			'analytics.behaviorCategories' => 'Behaviour categories',
			'analytics.behaviorCategoriesUnit' => 'entry count and average intensity',
			'analytics.milestoneCategories' => 'Milestones',
			'analytics.milestoneCategoriesUnit' => 'achievements by category',
			'analytics.notesActivity' => 'Note activity',
			'analytics.notesActivityUnit' => 'notes per month',
			'analytics.countWithIntensity' => ({required Object count, required Object intensity}) => '${count} · avg ${intensity}',
			'analytics.exportCsv' => 'Share as CSV',
			'analytics.exportEmpty' => 'Nothing to share yet.',
			'children.title' => 'My Children',
			'children.addTitle' => 'Add Child',
			'children.editTitle' => 'Edit Child',
			'children.empty' => 'You haven\'t added any children yet.',
			'children.add' => 'Add Child',
			'children.nameLabel' => 'Full Name',
			'children.nameHint' => 'Child\'s name',
			'children.birthDateLabel' => 'Birth Date (optional)',
			'children.birthDateSelect' => 'Select date',
			'children.genderLabel' => 'Gender (optional)',
			'children.genderMale' => 'Boy',
			'children.genderFemale' => 'Girl',
			'children.diagnosisLabel' => 'Diagnosis Info (optional)',
			'children.diagnosisHint' => 'Diagnosis info, if any',
			'children.educationLabel' => 'Education Program (optional)',
			'children.educationHint' => 'Current education program',
			'children.therapiesLabel' => 'Therapies (optional)',
			'children.therapiesHint' => 'Therapies received',
			'children.ageYears' => ({required Object years}) => '${years} yrs',
			'children.save' => 'Save',
			'children.cancel' => 'Cancel',
			'children.delete' => 'Delete',
			'children.deleteTitle' => 'Delete Child',
			'children.deleteConfirm' => ({required Object name}) => 'Are you sure you want to delete ${name}\'s profile?',
			'children.errorNameRequired' => 'Please enter the child\'s name.',
			'children.created' => 'Child profile created.',
			'children.updated' => 'Child profile updated.',
			'children.deleted' => 'Child profile deleted.',
			'account.title' => 'Account Information',
			'account.emailLabel' => 'Email',
			'account.fullNameLabel' => 'Full Name',
			'account.phoneLabel' => 'Phone',
			'account.phoneHint' => '05XX XXX XX XX',
			'account.cityLabel' => 'City',
			'account.expertTitleLabel' => 'Expert Title',
			'account.institutionLabel' => 'Institution',
			'account.licenseNumberLabel' => 'License Number',
			'account.bioLabel' => 'About',
			'account.bioHint' => 'Briefly describe your experience',
			'account.save' => 'Save',
			'account.saved' => 'Profile updated.',
			'account.errorFullName' => 'Full name must be at least 2 characters.',
			'help.title' => 'Help & About',
			'help.aboutTitle' => 'About Otizm Destek',
			'help.aboutBody' => 'Otizm Destek is a mobile app that helps you track your child\'s development, connect with experts, and book appointments.',
			'help.tipsTitle' => 'Tips',
			'help.tip1' => 'Add your children under "My Children"; track goals and notes in the "Progress" tab.',
			'help.tip2' => 'Pick an expert under "Experts" to book an appointment or send a message.',
			'help.tip3' => 'Ask the AI Assistant questions about autism and child development.',
			'help.contactTitle' => 'Contact',
			'help.contactBody' => 'Reach us from within the app for any questions or suggestions.',
			'help.version' => ({required Object version}) => 'Version ${version}',
			'profile.defaultUser' => 'User',
			'profile.accountInfo' => 'Account Information',
			'profile.myChildren' => 'My Children',
			'profile.showAllSections' => 'Show all sections',
			'profile.help' => 'Help',
			'profile.signOut' => 'Sign Out',
			'errors.timeout' => 'Could not reach the server, please try again.',
			'errors.noConnection' => 'You appear to be offline.',
			'errors.generic' => ({required Object code}) => 'An error occurred (${code}).',
			'errors.cancelled' => 'Request cancelled.',
			'errors.unexpected' => 'An unexpected error occurred.',
			'errors.unexpectedResponse' => 'Unexpected server response.',
			'errors.operationFailed' => 'Operation failed.',
			'errors.noUserInResponse' => 'No user information in the server response.',
			'guide.title' => 'User Guide',
			'guide.subtitle' => 'See your first steps, what each section does and the support channels — all in one place.',
			'guide.searchHint' => 'Search for a section, topic or action…',
			'guide.countLabel' => ({required Object visible, required Object total}) => '${visible} / ${total} sections',
			'guide.searchEmpty' => 'No section matches your search.',
			'guide.startTitle' => 'Where to start?',
			'guide.startSubtitle' => 'Work through them in order; each step opens the related section.',
			'guide.sectionsTitle' => 'What is each section for?',
			'guide.sectionsSubtitle' => 'Pick a category to see the sections it contains.',
			'guide.purposeLabel' => 'What is it for?',
			'guide.whenLabel' => 'When to use it',
			'guide.openPage' => 'Open',
			'guide.videosTitle' => 'Tutorial videos',
			'guide.videosSubtitle' => 'Short walkthroughs. Videos play in the web version; tapping one opens it in your browser.',
			'guide.videoWatch' => 'Watch',
			'guide.videoWatched' => 'Watched',
			'guide.videoMarkWatched' => 'Mark as watched',
			'guide.videoProgress' => ({required Object done, required Object total}) => '${done} / ${total} videos watched',
			'guide.videoOpenError' => 'The video link could not be opened.',
			'guide.videoCategoryStart' => 'Getting started',
			'guide.videoCategoryChild' => 'Child and development',
			'guide.videoCategoryTracking' => 'Daily tracking',
			'guide.videoCategoryPlan' => 'Plans and appointments',
			'guide.videoCategoryCommunity' => 'Communication and community',
			'guide.videoCategorySupport' => 'Safety and support',
			'guide.badgeDaily' => 'Every day',
			'guide.badgeQuickLog' => 'Quick log',
			'guide.badgeQuickHelp' => 'Quick help',
			'guide.badgeFirstStep' => 'First step',
			'guide.badgeSetup' => 'First setup',
			'guide.badgeRoutine' => 'Daily routine',
			'guide.badgeClinical' => 'Clinical support',
			'guide.badgePrivacy' => 'Privacy',
			'guide.badgeCalendar' => 'Calendar',
			'guide.badgeCommunication' => 'Communication',
			'guide.badgeProfile' => 'Profile',
			'guide.groupDaily' => 'Daily',
			'guide.groupDailyDesc' => 'The home, tracking and quick-support sections you will use every day.',
			'guide.groupChild' => 'My child',
			'guide.groupChildDesc' => 'Your child\'s development, profile details, exercises and special-situation records.',
			'guide.groupCommunity' => 'Community',
			'guide.groupCommunityDesc' => 'Sharing experiences, the forum, local meetups and contact with other families.',
			'guide.groupExpertWork' => 'Workspace',
			'guide.groupExpertWorkDesc' => 'Appointment, communication and professional resource sections.',
			'guide.startChild' => 'Create your child\'s profile',
			'guide.startChildDesc' => 'Enter the basics, diagnosis notes and needs so there is a child to track.',
			'guide.startTracker' => 'Add your first daily record',
			'guide.startTrackerDesc' => 'Keep sleep, mood, medication and observations organised with short entries.',
			'guide.startAppointment' => 'Book an appointment with an expert',
			'guide.startAppointmentDesc' => 'Pick a suitable expert, request an appointment and follow the session flow.',
			'guide.startPrivacy' => 'Review your sharing consents',
			'guide.startPrivacyDesc' => 'Manage which data is processed for which purpose from the consent screen.',
			'guide.startExpertCalendar' => 'Manage appointments',
			'guide.startExpertCalendarDesc' => 'Approve requests, complete sessions and keep families informed.',
			'guide.startExpertMessages' => 'Reach out to families',
			'guide.startExpertMessagesDesc' => 'Answer questions through secure messaging and keep the follow-up going.',
			'guide.startExpertProfile' => 'Complete your expert profile',
			'guide.startExpertProfileDesc' => 'Keep your title, specialisations and contact details up to date.',
			'guide.pageHome' => 'Home',
			'guide.pageHomePurpose' => 'Shows today\'s to-dos, reminders and the short daily plan in one place.',
			'guide.pageHomeWhen' => 'Every time you open the app and want to know what today holds.',
			'guide.pageHomeKeywords' => 'home, start, task, today, dashboard',
			'guide.pageTracker' => 'Daily Tracking',
			'guide.pageTrackerPurpose' => 'Used to record mood, sleep, medication and short daily observations.',
			'guide.pageTrackerWhen' => 'At the end of the day or when something notable changes.',
			'guide.pageTrackerKeywords' => 'daily, mood, sleep, medication, record',
			'guide.pageMessages' => 'Messages',
			'guide.pageMessagesPurpose' => 'A secure space to write to experts and other people on the platform.',
			'guide.pageMessagesWhen' => 'When you want to message about an appointment, a question or a follow-up.',
			'guide.pageMessagesKeywords' => 'message, chat, contact, expert',
			'guide.pageAppointments' => 'Appointments',
			'guide.pageAppointmentsPurpose' => 'Manages appointment requests, session times and the meeting flow.',
			'guide.pageAppointmentsWhen' => 'When planning a session or checking upcoming appointments.',
			'guide.pageAppointmentsKeywords' => 'appointment, calendar, session, doctor, therapy',
			'guide.pageCrisis' => 'What to do in hard moments',
			'guide.pageCrisisPurpose' => 'Quickly shows calming and intervention steps for difficult moments.',
			'guide.pageCrisisWhen' => 'During a crisis, intense stress or when you need fast guidance.',
			'guide.pageCrisisKeywords' => 'crisis, hard moment, calming, emergency, breathing',
			'guide.pageAssistant' => 'AI Assistant',
			'guide.pageAssistantPurpose' => 'A chat assistant that answers instantly; it does not give medical advice, it points you in the right direction.',
			'guide.pageAssistantWhen' => 'When you want a quick answer to something on your mind.',
			'guide.pageAssistantKeywords' => 'assistant, chat, ai, question, bot',
			'guide.pageSettings' => 'Settings',
			'guide.pageSettingsPurpose' => 'Manages notification, privacy and accessibility preferences, theme and language, your password and your account.',
			'guide.pageSettingsWhen' => 'When you want to tailor the app or manage your data.',
			'guide.pageSettingsKeywords' => 'settings, notification, privacy, password, theme, language, accessibility',
			'guide.pageHelp' => 'Help',
			'guide.pageHelpPurpose' => 'Short information about the app, usage tips and contact channels.',
			'guide.pageHelpWhen' => 'When you cannot work out how a feature behaves.',
			'guide.pageHelpKeywords' => 'help, support, faq, contact',
			'guide.pageChildren' => 'My Children',
			'guide.pageChildrenPurpose' => 'Keeps your child\'s basics, diagnosis notes, therapy and needs.',
			'guide.pageChildrenWhen' => 'During first setup or when child details change.',
			'guide.pageChildrenKeywords' => 'child, profile, diagnosis, therapy, milestone',
			'guide.pageAnalytics' => 'Progress Dashboard',
			'guide.pageAnalyticsPurpose' => 'Turns daily records into charts and monthly trends.',
			'guide.pageAnalyticsWhen' => 'When you want the bigger picture rather than single entries.',
			'guide.pageAnalyticsKeywords' => 'progress, chart, analysis, trend, development',
			'guide.pageTreatment' => 'Support Plan',
			'guide.pageTreatmentPurpose' => 'Collects small goals, home practice, games and the daily support flow.',
			'guide.pageTreatmentWhen' => 'When looking for a short activity or goal to try at home today.',
			'guide.pageTreatmentKeywords' => 'treatment, plan, goal, activity, game, home practice',
			'guide.pageTasks' => 'My Tasks',
			'guide.pageTasksPurpose' => 'Shows the tasks your expert assigned, the daily exercise wizard and submission status.',
			'guide.pageTasksWhen' => 'When following up on work given after a session.',
			'guide.pageTasksKeywords' => 'task, homework, exercise, expert, submission',
			'guide.pageNotes' => 'My Notes',
			'guide.pageNotesPurpose' => 'Stores behaviour, development, meeting or noteworthy events as free-form notes.',
			'guide.pageNotesWhen' => 'For short observations you want to share with your expert or remember later.',
			'guide.pageNotesKeywords' => 'note, observation, development, behaviour, reminder',
			'guide.pageBehavior' => 'Behaviour Log',
			'guide.pageBehaviorPurpose' => 'Records what happened before, during and after a behaviour (ABC) so patterns become visible.',
			'guide.pageBehaviorWhen' => 'When you want to understand why a behaviour repeats.',
			'guide.pageBehaviorKeywords' => 'behaviour, abc, antecedent, consequence, pattern, trigger',
			'guide.pageEmergency' => 'Emergency Card',
			'guide.pageEmergencyPurpose' => 'Keeps the essential child information ready to share, via a time-limited link and QR code.',
			'guide.pageEmergencyWhen' => 'When you may need to share key information quickly outside, at school or in an emergency.',
			'guide.pageEmergencyKeywords' => 'emergency, card, safety, qr, sharing',
			'guide.pageCalendar' => 'Calendar',
			'guide.pageCalendarPurpose' => 'Keeps appointments, school, events and reminders on a dated agenda.',
			'guide.pageCalendarWhen' => 'When you do not want to forget upcoming plans.',
			'guide.pageCalendarKeywords' => 'calendar, event, reminder, plan',
			'guide.pageRoutines' => 'Routines',
			'guide.pageRoutinesPurpose' => 'Helps you follow daily routines step by step, visually.',
			'guide.pageRoutinesWhen' => 'When you want to picture the morning, school, sleep or transition routine.',
			'guide.pageRoutinesKeywords' => 'routine, schedule, step, visual, transition',
			'guide.pageForum' => 'Community Forum',
			'guide.pageForumPurpose' => 'A shared discussion space where parents and experts ask questions and share experience.',
			'guide.pageForumWhen' => 'When you want to ask the community about something.',
			'guide.pageForumKeywords' => 'forum, question, answer, community, experience',
			'guide.pageWall' => 'Support Wall',
			'guide.pageWallPurpose' => 'A freer support space for feelings and experiences — you can stay anonymous.',
			'guide.pageWallWhen' => 'When you would rather open up than ask a question.',
			'guide.pageWallKeywords' => 'support wall, feeling, sharing, support, anonymous',
			'guide.pageMeetups' => 'Local Meetups',
			'guide.pageMeetupsPurpose' => 'Lets you meet families in your city in real life.',
			'guide.pageMeetupsWhen' => 'When you want to plan a face-to-face event nearby.',
			'guide.pageMeetupsKeywords' => 'meetup, event, city, meeting, local',
			'guide.pageWeekly' => 'Question of the Week',
			'guide.pageWeeklyPurpose' => 'Lists families\' answers to one shared topic each week.',
			'guide.pageWeeklyWhen' => 'When you want to see what other families think or share your own experience.',
			'guide.pageWeeklyKeywords' => 'weekly question, community, experience, sharing',
			'guide.pageSimilar' => 'Similar Families',
			'guide.pageSimilarPurpose' => 'Introduces you to families going through a similar process in terms of age and needs.',
			'guide.pageSimilarWhen' => 'When you want to find the families you have most in common with.',
			'guide.pageSimilarKeywords' => 'similar families, matching, peer, meeting',
			'guide.pageGroups' => 'Support Groups',
			'guide.pageGroupsPurpose' => 'Lets you join category-based family and expert communities and their group chats.',
			'guide.pageGroupsWhen' => 'When you are looking for a community focused on similar needs or age groups.',
			'guide.pageGroupsKeywords' => 'group, community, chat, join',
			'guide.pageKnowledge' => 'Knowledge Base',
			'guide.pageKnowledgePurpose' => 'Collects trustworthy articles and resources.',
			'guide.pageKnowledgeWhen' => 'When you want to read or learn about a topic calmly.',
			'guide.pageKnowledgeKeywords' => 'knowledge, article, guide, resource, learning',
			'guide.pageExpertAppointments' => 'My Appointments',
			'guide.pageExpertAppointmentsPurpose' => 'Approve incoming requests, complete sessions and handle reschedule requests.',
			'guide.pageExpertAppointmentsWhen' => 'While planning your day and closing records after a session.',
			'guide.pageExpertMessagesPurpose' => 'A secure space to write to families; task feedback also goes through here.',
			'guide.pageExpertMessagesWhen' => 'When you want to get back to a family or ask a follow-up question.',
			'guide.pageExpertForumPurpose' => 'As an expert you can answer questions and share verified information.',
			'guide.pageExpertForumWhen' => 'When you want to contribute professionally to the community.',
			'guide.video01' => 'Platform Overview',
			'guide.video01Desc' => 'A short tour of the main sections, the role-based menu and the safe-use tools.',
			'guide.video02' => 'Parent Quick Start',
			'guide.video02Desc' => 'Follow the basic flow from signing in to creating a child profile and the first daily record.',
			'guide.video03' => 'Using the User Guide',
			'guide.video03Desc' => 'Learn how to find the feature you need through search, categories and role-based guidance.',
			'guide.video04' => 'Home and Navigation',
			'guide.video04Desc' => 'Read the daily summaries and reach any section through the menu and quick links.',
			'guide.video05' => 'Child Profile',
			'guide.video05Desc' => 'Create a child profile and keep the basics, diagnosis notes, needs and access details up to date.',
			'guide.video06' => 'Daily Mood and Sleep Tracking',
			'guide.video06Desc' => 'Add mood, sleep and behaviour records in a few steps and review the history.',
			'guide.video07' => 'Medication Tracking',
			'guide.video07Desc' => 'Save the medication plan, follow doses and times, and check past records safely.',
			'guide.video08' => 'Progress Dashboard',
			'guide.video08Desc' => 'See how daily records turn into charts and interpret trends and development summaries.',
			'guide.video09' => 'Goals and Exercises',
			'guide.video09Desc' => 'View goals suited to your child, run the home exercises and track completion.',
			'guide.video10' => 'Tasks and Routines',
			'guide.video10Desc' => 'Follow the tasks your expert assigned and plan morning, school or sleep routines step by step.',
			'guide.video11' => 'Notes, Calendar and Emergency Card',
			'guide.video11Desc' => 'Write down observations, plan important dates and keep the emergency card ready to share.',
			'guide.video12' => 'Finding an Expert and Booking',
			'guide.video12Desc' => 'Filter experts, compare profiles, choose the right person and manage the appointment flow.',
			'guide.video13' => 'Messages, Privacy and Settings',
			'guide.video13Desc' => 'Use secure messaging and manage profile, notification, password and data-sharing preferences.',
			'guide.video14' => 'Community, Forum and Meetups',
			'guide.video14Desc' => 'Ask questions on the forum, read family experiences and discover safe community meetups.',
			'guide.video15' => 'Knowledge Base, Crisis and Help',
			'guide.video15Desc' => 'Find trustworthy content, reach the crisis steps for hard moments and use the help channels.',
			'community.title' => 'Community',
			'community.badge' => 'Moderated, safe contact',
			'community.intro' => 'Find families going through the same process, message them first and join groups and meetups when you are ready.',
			'community.areasTitle' => 'What would you like to do?',
			'community.areasSubtitle' => 'Every community space lives in this hub.',
			'community.safetyTitle' => 'Meeting safely',
			'community.safetyBody' => 'Keep the first conversation inside the app. You do not have to share your phone number, home address or your child\'s private details. You can block or report anyone who makes you uncomfortable.',
			'community.similarText' => 'See shared experiences and match reasons, then start a safe introduction.',
			'community.messagesText' => 'Continue your conversations with families and experts in one place.',
			'community.groupsText' => 'Join communities focused on similar needs and age groups.',
			'community.meetupsText' => 'Discover safe meetups in your city.',
			'community.forumText' => 'Ask the community and read answers from families and experts.',
			'community.wallText' => 'Share how you feel without judgement; stay anonymous if you like.',
			'community.weeklyText' => 'Join short experience threads around a single topic.',
			'reviews.title' => ({required Object count}) => 'Reviews (${count})',
			'reviews.empty' => 'No reviews for this expert yet.',
			'reviews.write' => 'Write a review',
			'reviews.edit' => 'Edit my review',
			'reviews.ratingLabel' => 'Your rating',
			'reviews.commentHint' => 'Briefly describe your experience (optional)…',
			'reviews.save' => 'Save',
			'reviews.delete' => 'Delete',
			'reviews.deleteTitle' => 'Delete review',
			'reviews.deleteConfirm' => 'Are you sure you want to delete this review?',
			'reviews.someone' => 'A parent',
			'expertAccess.title' => 'Expert Access',
			'expertAccess.intro' => 'Experts can only see your child\'s development data once you approve them. You can withdraw access at any time.',
			'expertAccess.pendingTitle' => 'Pending requests',
			'expertAccess.noPending' => 'There are no pending expert access requests.',
			'expertAccess.activeTitle' => 'Experts with access',
			'expertAccess.noActive' => 'You have not granted access to any expert yet.',
			'expertAccess.requestLine' => ({required Object child}) => 'Requests access to your child ${child}\'s profile.',
			'expertAccess.activeLine' => ({required Object child}) => 'Can access your child ${child}\'s profile.',
			'expertAccess.requestedAt' => ({required Object date}) => 'Requested on: ${date}',
			'expertAccess.unknownExpert' => 'Expert',
			'expertAccess.approve' => 'Approve',
			'expertAccess.reject' => 'Reject',
			'expertAccess.revoke' => 'Remove access',
			'expertAccess.approved' => 'Expert access request approved.',
			'expertAccess.rejected' => 'Expert access request rejected.',
			'expertAccess.revoked' => 'The expert\'s access has been removed.',
			'expertAccess.revokeTitle' => 'Remove access',
			'expertAccess.revokeConfirm' => 'Are you sure you want to remove this expert\'s access to your child\'s data?',
			'expertAccess.pendingBanner' => ({required Object count}) => '${count} expert access request(s) waiting for your approval',
			_ => null,
		};
	}
}
