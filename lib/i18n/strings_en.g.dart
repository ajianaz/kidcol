///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

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
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final TranslationsAppEn app = TranslationsAppEn._(_root);
	late final TranslationsHomeEn home = TranslationsHomeEn._(_root);
	late final TranslationsCollectionsEn collections = TranslationsCollectionsEn._(_root);
	late final TranslationsDrawingEn drawing = TranslationsDrawingEn._(_root);
	late final TranslationsImagesEn images = TranslationsImagesEn._(_root);
	late final TranslationsSettingsEn settings = TranslationsSettingsEn._(_root);
	late final TranslationsCommonEn common = TranslationsCommonEn._(_root);
	late final TranslationsMessagesEn messages = TranslationsMessagesEn._(_root);
}

// Path: app
class TranslationsAppEn {
	TranslationsAppEn._(this._root);

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
	TranslationsHomeEn._(this._root);

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
	TranslationsCollectionsEn._(this._root);

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
	TranslationsDrawingEn._(this._root);

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
	TranslationsImagesEn._(this._root);

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
	TranslationsSettingsEn._(this._root);

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
	TranslationsCommonEn._(this._root);

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
	TranslationsMessagesEn._(this._root);

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
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.name' => 'Kidcol',
			'app.collections' => 'Collections',
			'app.home' => 'Home',
			'app.drawing_room' => 'Drawing Room',
			'app.settings' => 'Settings',
			'home.title' => 'Welcome to Kidcol',
			'home.subtitle' => 'Create and manage your collections',
			'home.create_collection' => 'Create Collection',
			'home.view_collections' => 'View Collections',
			'home.start_drawing' => 'Start Drawing',
			'collections.title' => 'My Collections',
			'collections.empty' => 'No collections yet',
			'collections.create_new' => 'Create New Collection',
			'collections.name' => 'Collection Name',
			'collections.name_hint' => 'Enter collection name',
			'collections.save' => 'Save',
			'collections.cancel' => 'Cancel',
			'collections.delete' => 'Delete',
			'collections.edit' => 'Edit',
			'collections.view_images' => 'View Images',
			'drawing.title' => 'Drawing Room',
			'drawing.tools' => 'Tools',
			'drawing.brush' => 'Brush',
			'drawing.eraser' => 'Eraser',
			'drawing.color' => 'Color',
			'drawing.size' => 'Size',
			'drawing.clear' => 'Clear',
			'drawing.save' => 'Save',
			'drawing.back' => 'Back',
			'images.title' => 'Images',
			'images.empty' => 'No images in this collection',
			'images.add_image' => 'Add Image',
			'images.delete' => 'Delete',
			'images.view' => 'View',
			'images.download' => 'Download',
			'settings.title' => 'Settings',
			'settings.language' => 'Language',
			'settings.english' => 'English',
			'settings.indonesian' => 'Indonesian',
			'settings.faq' => 'FAQ',
			'settings.terms_of_service' => 'Terms of Service',
			'settings.privacy_policy' => 'Privacy Policy',
			'settings.about' => 'About',
			'settings.version' => 'Version',
			'common.ok' => 'OK',
			'common.cancel' => 'Cancel',
			'common.yes' => 'Yes',
			'common.no' => 'No',
			'common.delete' => 'Delete',
			'common.save' => 'Save',
			'common.edit' => 'Edit',
			'common.add' => 'Add',
			'common.remove' => 'Remove',
			'common.loading' => 'Loading...',
			'common.error' => 'Error',
			'common.success' => 'Success',
			'common.confirm' => 'Confirm',
			'common.warning' => 'Warning',
			'messages.collection_created' => 'Collection created successfully',
			'messages.collection_deleted' => 'Collection deleted successfully',
			'messages.collection_updated' => 'Collection updated successfully',
			'messages.image_saved' => 'Image saved successfully',
			'messages.image_deleted' => 'Image deleted successfully',
			'messages.confirm_delete' => 'Are you sure you want to delete this item?',
			'messages.error_occurred' => 'An error occurred. Please try again.',
			'messages.no_internet' => 'No internet connection. Please check your network.',
			_ => null,
		};
	}
}
