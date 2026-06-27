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
	@override late final _Translations$roles$en roles = _Translations$roles$en._(_root);
	@override late final _Translations$auth$en auth = _Translations$auth$en._(_root);
	@override late final _Translations$register$en register = _Translations$register$en._(_root);
	@override late final _Translations$nav$en nav = _Translations$nav$en._(_root);
	@override late final _Translations$chat$en chat = _Translations$chat$en._(_root);
	@override late final _Translations$messages$en messages = _Translations$messages$en._(_root);
	@override late final _Translations$home$en home = _Translations$home$en._(_root);
	@override late final _Translations$specialists$en specialists = _Translations$specialists$en._(_root);
	@override late final _Translations$progress$en progress = _Translations$progress$en._(_root);
	@override late final _Translations$appointments$en appointments = _Translations$appointments$en._(_root);
	@override late final _Translations$children$en children = _Translations$children$en._(_root);
	@override late final _Translations$profile$en profile = _Translations$profile$en._(_root);
	@override late final _Translations$errors$en errors = _Translations$errors$en._(_root);
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
	@override String get loading => 'Loading';
	@override String get comingSoon => 'This section is coming soon.';
	@override String get seeAll => 'See All';
	@override String get more => 'More';
	@override String get retry => 'Retry';
	@override String get loadError => 'Could not load data.';
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
	@override String get errorKvkkRequired => 'KVKK consent is required to continue.';
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
	@override String get title => 'Messages';
	@override String get noConversations => 'You have no conversations yet.';
	@override String get noMessages => 'No messages yet. Send the first one.';
	@override String get inputHint => 'Type a message...';
	@override String get connecting => 'Connecting...';
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
}

// Path: appointments
class _Translations$appointments$en extends Translations$appointments$tr {
	_Translations$appointments$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
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

// Path: profile
class _Translations$profile$en extends Translations$profile$tr {
	_Translations$profile$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get defaultUser => 'User';
	@override String get accountInfo => 'Account Information';
	@override String get myChildren => 'My Children';
	@override String get notificationSettings => 'Notification Settings';
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

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsEn {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.name' => 'Autism Support',
			'common.loading' => 'Loading',
			'common.comingSoon' => 'This section is coming soon.',
			'common.seeAll' => 'See All',
			'common.more' => 'More',
			'common.retry' => 'Retry',
			'common.loadError' => 'Could not load data.',
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
			'register.errorKvkkRequired' => 'KVKK consent is required to continue.',
			'nav.home' => 'Home',
			'nav.specialists' => 'Specialists',
			'nav.progress' => 'Progress',
			'nav.profile' => 'Profile',
			'chat.title' => 'AI Assistant',
			'chat.greeting' => 'Hi! I\'ll try to answer your questions about autism and child development.',
			'chat.inputHint' => 'Ask a question...',
			'chat.errorGeneric' => 'Couldn\'t get a response, please try again.',
			'messages.title' => 'Messages',
			'messages.noConversations' => 'You have no conversations yet.',
			'messages.noMessages' => 'No messages yet. Send the first one.',
			'messages.inputHint' => 'Type a message...',
			'messages.connecting' => 'Connecting...',
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
			'specialists.title' => 'Find a Specialist',
			'specialists.searchHint' => 'Search by name or expertise...',
			'specialists.filterAll' => 'All',
			'specialists.filterPsychologist' => 'Psychologist',
			'specialists.filterSpecialEducation' => 'Special Education',
			'specialists.filterSpeech' => 'Speech & Language',
			'specialists.noResults' => 'No specialists match your search.',
			'specialists.ratingNew' => 'New',
			'specialists.reviews' => ({required Object count}) => '${count} reviews',
			'progress.title' => 'Progress Tracking',
			'progress.subtitle' => 'Goals and development notes.',
			'progress.addRecord' => 'Add New Record',
			'progress.goalsTitle' => 'Goals',
			'progress.recentNotes' => 'Recent Development Notes',
			'progress.noGoals' => 'No goals added yet.',
			'progress.noNotes' => 'No development notes yet.',
			'progress.noChild' => 'Add a child first to track development.',
			'progress.goalProgress' => ({required Object done, required Object total}) => '${done} / ${total}',
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
			'profile.defaultUser' => 'User',
			'profile.accountInfo' => 'Account Information',
			'profile.myChildren' => 'My Children',
			'profile.notificationSettings' => 'Notification Settings',
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
			_ => null,
		};
	}
}
