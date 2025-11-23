///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'translations.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
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
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  );

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final TranslationsAppEn app = TranslationsAppEn.internal(_root);
	late final TranslationsHomeEn home = TranslationsHomeEn.internal(_root);
	late final TranslationsCollectionsEn collections = TranslationsCollectionsEn.internal(_root);
	late final TranslationsDrawingEn drawing = TranslationsDrawingEn.internal(_root);
	late final TranslationsImagesEn images = TranslationsImagesEn.internal(_root);
	late final TranslationsSettingsEn settings = TranslationsSettingsEn.internal(_root);
	late final TranslationsCommonEn common = TranslationsCommonEn.internal(_root);
	late final TranslationsMessagesEn messages = TranslationsMessagesEn.internal(_root);
	late final TranslationsDialogEn dialog = TranslationsDialogEn.internal(_root);
	late final TranslationsPrintingEn printing = TranslationsPrintingEn.internal(_root);
	late final TranslationsErrorEn error = TranslationsErrorEn.internal(_root);
	late final TranslationsCollectionEn collection = TranslationsCollectionEn.internal(_root);
}

// Path: app
class TranslationsAppEn {
	TranslationsAppEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Kidcol'
	String get name => 'Kidcol';

	/// en: 'Collections'
	String get collections => 'Collections';

	/// en: 'Home'
	String get home => 'Home';

	/// en: 'Drawing Room'
	String get drawing_room => 'Drawing Room';

	/// en: 'Settings'
	String get settings => 'Settings';
}

// Path: home
class TranslationsHomeEn {
	TranslationsHomeEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Welcome to Kidcol'
	String get title => 'Welcome to Kidcol';

	/// en: 'Create and manage your collections'
	String get subtitle => 'Create and manage your collections';

	/// en: 'Create Collection'
	String get create_collection => 'Create Collection';

	/// en: 'View Collections'
	String get view_collections => 'View Collections';

	/// en: 'Start Drawing'
	String get start_drawing => 'Start Drawing';
}

// Path: collections
class TranslationsCollectionsEn {
	TranslationsCollectionsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'My Collections'
	String get title => 'My Collections';

	/// en: 'No collections yet'
	String get empty => 'No collections yet';

	/// en: 'Create New Collection'
	String get create_new => 'Create New Collection';

	/// en: 'Collection Name'
	String get name => 'Collection Name';

	/// en: 'Enter collection name'
	String get name_hint => 'Enter collection name';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Edit'
	String get edit => 'Edit';

	/// en: 'View Images'
	String get view_images => 'View Images';
}

// Path: drawing
class TranslationsDrawingEn {
	TranslationsDrawingEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Drawing Room'
	String get title => 'Drawing Room';

	/// en: 'Tools'
	String get tools => 'Tools';

	/// en: 'Brush'
	String get brush => 'Brush';

	/// en: 'Eraser'
	String get eraser => 'Eraser';

	/// en: 'Color'
	String get color => 'Color';

	/// en: 'Size'
	String get size => 'Size';

	/// en: 'Clear'
	String get clear => 'Clear';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Back'
	String get back => 'Back';
}

// Path: images
class TranslationsImagesEn {
	TranslationsImagesEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Images'
	String get title => 'Images';

	/// en: 'No images in this collection'
	String get empty => 'No images in this collection';

	/// en: 'Add Image'
	String get add_image => 'Add Image';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'View'
	String get view => 'View';

	/// en: 'Download'
	String get download => 'Download';
}

// Path: settings
class TranslationsSettingsEn {
	TranslationsSettingsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get title => 'Settings';

	/// en: 'Language'
	String get language => 'Language';

	/// en: 'English'
	String get english => 'English';

	/// en: 'Indonesian'
	String get indonesian => 'Indonesian';

	/// en: 'FAQ'
	String get faq => 'FAQ';

	/// en: 'Terms of Service'
	String get terms_of_service => 'Terms of Service';

	/// en: 'Privacy Policy'
	String get privacy_policy => 'Privacy Policy';

	/// en: 'About'
	String get about => 'About';

	/// en: 'Version'
	String get version => 'Version';
}

// Path: common
class TranslationsCommonEn {
	TranslationsCommonEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'OK'
	String get ok => 'OK';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Yes'
	String get yes => 'Yes';

	/// en: 'No'
	String get no => 'No';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Edit'
	String get edit => 'Edit';

	/// en: 'Add'
	String get add => 'Add';

	/// en: 'Remove'
	String get remove => 'Remove';

	/// en: 'Loading...'
	String get loading => 'Loading...';

	/// en: 'Error'
	String get error => 'Error';

	/// en: 'Success'
	String get success => 'Success';

	/// en: 'Confirm'
	String get confirm => 'Confirm';

	/// en: 'Warning'
	String get warning => 'Warning';
}

// Path: messages
class TranslationsMessagesEn {
	TranslationsMessagesEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Collection created successfully'
	String get collection_created => 'Collection created successfully';

	/// en: 'Collection deleted successfully'
	String get collection_deleted => 'Collection deleted successfully';

	/// en: 'Collection updated successfully'
	String get collection_updated => 'Collection updated successfully';

	/// en: 'Image saved successfully'
	String get image_saved => 'Image saved successfully';

	/// en: 'Image deleted successfully'
	String get image_deleted => 'Image deleted successfully';

	/// en: 'Are you sure you want to delete this item?'
	String get confirm_delete => 'Are you sure you want to delete this item?';

	/// en: 'An error occurred. Please try again.'
	String get error_occurred => 'An error occurred. Please try again.';

	/// en: 'No internet connection. Please check your network.'
	String get no_internet => 'No internet connection. Please check your network.';

	/// en: 'An update is available. Please update the app.'
	String get update_available => 'An update is available. Please update the app.';
}

// Path: dialog
class TranslationsDialogEn {
	TranslationsDialogEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No Collections'
	String get no_collections => 'No Collections';

	/// en: 'Please add a collection first.'
	String get please_add_collection_first => 'Please add a collection first.';

	/// en: 'Attention'
	String get attention => 'Attention';

	/// en: 'All images have been loaded.'
	String get images_finished => 'All images have been loaded.';

	/// en: 'Confirm Delete Image'
	String get confirm_delete_image => 'Confirm Delete Image';

	/// en: 'Are you sure you want to delete this image?'
	String get confirm_delete_image_message => 'Are you sure you want to delete this image?';

	/// en: 'No images'
	String get no_images => 'No images';

	/// en: 'Device Verification Required'
	String get device_verification_required => 'Device Verification Required';

	/// en: 'As a paid user, you need to verify your device to continue using the app.'
	String get device_verification_message => 'As a paid user, you need to verify your device to continue using the app.';

	/// en: 'Device Information:'
	String get device_info => 'Device Information:';

	/// en: 'Device ID:'
	String get device_id => 'Device ID:';

	/// en: 'Device ID Copied'
	String get device_id_copied => 'Device ID Copied';

	/// en: 'Device ID has been copied to clipboard'
	String get device_id_copied_message => 'Device ID has been copied to clipboard';

	/// en: 'Copy Device ID'
	String get copy_device_id => 'Copy Device ID';

	/// en: 'Verify Device'
	String get verify_device => 'Verify Device';

	/// en: 'Device verified successfully'
	String get device_verified_successfully => 'Device verified successfully';

	/// en: 'Failed to verify device'
	String get failed_to_verify_device => 'Failed to verify device';

	late final TranslationsDialogWhatsappVerificationEn whatsapp_verification = TranslationsDialogWhatsappVerificationEn.internal(_root);

	/// en: 'Please enter a collection name'
	String get please_enter_collection_name => 'Please enter a collection name';

	/// en: 'Collection name must be at least 2 characters'
	String get collection_name_too_short => 'Collection name must be at least 2 characters';

	/// en: 'Collection name must be less than 50 characters'
	String get collection_name_too_long => 'Collection name must be less than 50 characters';
}

// Path: printing
class TranslationsPrintingEn {
	TranslationsPrintingEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Print PDF'
	String get title => 'Print PDF';

	/// en: 'Processing images:'
	String get processing_images => 'Processing images:';

	/// en: 'Preparing images for PDF...'
	String get preparing_images => 'Preparing images for PDF...';

	/// en: 'Data not found.'
	String get data_not_found => 'Data not found.';

	/// en: 'Download KidCol App from Playstore and create your own coloring book'
	String get download_app_message => 'Download KidCol App from Playstore and create your own coloring book';
}

// Path: error
class TranslationsErrorEn {
	TranslationsErrorEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Failed to load images'
	String get failed_to_load_images => 'Failed to load images';

	/// en: 'Connection timeout. Please check your internet connection.'
	String get connection_timeout => 'Connection timeout. Please check your internet connection.';

	/// en: 'Server response timeout. Please try again.'
	String get server_response_timeout => 'Server response timeout. Please try again.';

	/// en: 'No internet connection. Please check your network.'
	String get no_internet_connection => 'No internet connection. Please check your network.';

	/// en: 'Authentication failed. Please check your API key.'
	String get authentication_failed => 'Authentication failed. Please check your API key.';

	/// en: 'Access forbidden. You may need to verify your account.'
	String get access_forbidden => 'Access forbidden. You may need to verify your account.';

	/// en: 'API endpoint not found. Please check the server configuration.'
	String get api_endpoint_not_found => 'API endpoint not found. Please check the server configuration.';

	/// en: 'Server error. Please try again later.'
	String get server_error => 'Server error. Please try again later.';

	/// en: 'Error Loading Data'
	String get error_loading_data => 'Error Loading Data';

	/// en: 'An unexpected error occurred while loading data'
	String get unexpected_error => 'An unexpected error occurred while loading data';
}

// Path: collection
class TranslationsCollectionEn {
	TranslationsCollectionEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Collection'
	String get title_prefix => 'Collection';
}

// Path: dialog.whatsapp_verification
class TranslationsDialogWhatsappVerificationEn {
	TranslationsDialogWhatsappVerificationEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Enter WhatsApp Number'
	String get enter_whatsapp_number => 'Enter WhatsApp Number';

	/// en: 'Verify WhatsApp Number'
	String get verify_whatsapp_number => 'Verify WhatsApp Number';

	/// en: 'Please enter your WhatsApp number to verify your account'
	String get enter_whatsapp_message => 'Please enter your WhatsApp number to verify your account';

	/// en: 'A verification code has been sent to'
	String get verification_code_sent => 'A verification code has been sent to';

	/// en: 'Verification Code'
	String get verification_code => 'Verification Code';

	/// en: 'Enter 6-digit code'
	String get enter_6_digit_code => 'Enter 6-digit code';

	/// en: 'Please enter your phone number'
	String get please_enter_phone => 'Please enter your phone number';

	/// en: 'Please enter the verification code'
	String get please_enter_code => 'Please enter the verification code';

	/// en: 'Code must be 6 digits'
	String get code_must_be_6_digits => 'Code must be 6 digits';

	/// en: 'Resend Code'
	String get resend_code => 'Resend Code';

	/// en: 'Verify'
	String get verify => 'Verify';

	/// en: 'Send Code'
	String get send_code => 'Send Code';

	/// en: 'Code Sent'
	String get code_sent => 'Code Sent';

	/// en: 'A verification code has been sent to your WhatsApp number'
	String get code_sent_message => 'A verification code has been sent to your WhatsApp number';

	/// en: 'Invalid Code'
	String get invalid_code => 'Invalid Code';

	/// en: 'The verification code you entered is invalid'
	String get invalid_code_message => 'The verification code you entered is invalid';

	/// en: 'Verified'
	String get whatsapp_verified => 'Verified';

	/// en: 'Your WhatsApp number has been verified successfully'
	String get whatsapp_verified_message => 'Your WhatsApp number has been verified successfully';
}
