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
class TranslationsId with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsId({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.id,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <id>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsId _root = this; // ignore: unused_field

	@override 
	TranslationsId $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsId(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsAppId app = _TranslationsAppId._(_root);
	@override late final _TranslationsHomeId home = _TranslationsHomeId._(_root);
	@override late final _TranslationsCollectionsId collections = _TranslationsCollectionsId._(_root);
	@override late final _TranslationsDrawingId drawing = _TranslationsDrawingId._(_root);
	@override late final _TranslationsImagesId images = _TranslationsImagesId._(_root);
	@override late final _TranslationsSettingsId settings = _TranslationsSettingsId._(_root);
	@override late final _TranslationsCommonId common = _TranslationsCommonId._(_root);
	@override late final _TranslationsMessagesId messages = _TranslationsMessagesId._(_root);
}

// Path: app
class _TranslationsAppId implements TranslationsAppEn {
	_TranslationsAppId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get name => 'Kidcol';
	@override String get collections => 'Koleksi';
	@override String get home => 'Beranda';
	@override String get drawing_room => 'Ruang Gambar';
	@override String get settings => 'Pengaturan';
}

// Path: home
class _TranslationsHomeId implements TranslationsHomeEn {
	_TranslationsHomeId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Selamat Datang di Kidcol';
	@override String get subtitle => 'Buat dan kelola koleksi Anda';
	@override String get create_collection => 'Buat Koleksi';
	@override String get view_collections => 'Lihat Koleksi';
	@override String get start_drawing => 'Mulai Menggambar';
}

// Path: collections
class _TranslationsCollectionsId implements TranslationsCollectionsEn {
	_TranslationsCollectionsId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Koleksi Saya';
	@override String get empty => 'Belum ada koleksi';
	@override String get create_new => 'Buat Koleksi Baru';
	@override String get name => 'Nama Koleksi';
	@override String get name_hint => 'Masukkan nama koleksi';
	@override String get save => 'Simpan';
	@override String get cancel => 'Batal';
	@override String get delete => 'Hapus';
	@override String get edit => 'Edit';
	@override String get view_images => 'Lihat Gambar';
}

// Path: drawing
class _TranslationsDrawingId implements TranslationsDrawingEn {
	_TranslationsDrawingId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ruang Gambar';
	@override String get tools => 'Alat';
	@override String get brush => 'Kuas';
	@override String get eraser => 'Penghapus';
	@override String get color => 'Warna';
	@override String get size => 'Ukuran';
	@override String get clear => 'Bersihkan';
	@override String get save => 'Simpan';
	@override String get back => 'Kembali';
}

// Path: images
class _TranslationsImagesId implements TranslationsImagesEn {
	_TranslationsImagesId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Gambar';
	@override String get empty => 'Tidak ada gambar dalam koleksi ini';
	@override String get add_image => 'Tambah Gambar';
	@override String get delete => 'Hapus';
	@override String get view => 'Lihat';
	@override String get download => 'Unduh';
}

// Path: settings
class _TranslationsSettingsId implements TranslationsSettingsEn {
	_TranslationsSettingsId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Pengaturan';
	@override String get language => 'Bahasa';
	@override String get english => 'English';
	@override String get indonesian => 'Indonesia';
	@override String get faq => 'FAQ';
	@override String get terms_of_service => 'Syarat & Ketentuan';
	@override String get privacy_policy => 'Kebijakan Privasi';
	@override String get about => 'Tentang';
	@override String get version => 'Versi';
}

// Path: common
class _TranslationsCommonId implements TranslationsCommonEn {
	_TranslationsCommonId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get ok => 'OK';
	@override String get cancel => 'Batal';
	@override String get yes => 'Ya';
	@override String get no => 'Tidak';
	@override String get delete => 'Hapus';
	@override String get save => 'Simpan';
	@override String get edit => 'Edit';
	@override String get add => 'Tambah';
	@override String get remove => 'Hapus';
	@override String get loading => 'Memuat...';
	@override String get error => 'Error';
	@override String get success => 'Berhasil';
	@override String get confirm => 'Konfirmasi';
	@override String get warning => 'Peringatan';
}

// Path: messages
class _TranslationsMessagesId implements TranslationsMessagesEn {
	_TranslationsMessagesId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get collection_created => 'Koleksi berhasil dibuat';
	@override String get collection_deleted => 'Koleksi berhasil dihapus';
	@override String get collection_updated => 'Koleksi berhasil diperbarui';
	@override String get image_saved => 'Gambar berhasil disimpan';
	@override String get image_deleted => 'Gambar berhasil dihapus';
	@override String get confirm_delete => 'Apakah Anda yakin ingin menghapus item ini?';
	@override String get error_occurred => 'Terjadi kesalahan. Silakan coba lagi.';
	@override String get no_internet => 'Tidak ada koneksi internet. Silakan periksa jaringan Anda.';
}

/// The flat map containing all translations for locale <id>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsId {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.name' => 'Kidcol',
			'app.collections' => 'Koleksi',
			'app.home' => 'Beranda',
			'app.drawing_room' => 'Ruang Gambar',
			'app.settings' => 'Pengaturan',
			'home.title' => 'Selamat Datang di Kidcol',
			'home.subtitle' => 'Buat dan kelola koleksi Anda',
			'home.create_collection' => 'Buat Koleksi',
			'home.view_collections' => 'Lihat Koleksi',
			'home.start_drawing' => 'Mulai Menggambar',
			'collections.title' => 'Koleksi Saya',
			'collections.empty' => 'Belum ada koleksi',
			'collections.create_new' => 'Buat Koleksi Baru',
			'collections.name' => 'Nama Koleksi',
			'collections.name_hint' => 'Masukkan nama koleksi',
			'collections.save' => 'Simpan',
			'collections.cancel' => 'Batal',
			'collections.delete' => 'Hapus',
			'collections.edit' => 'Edit',
			'collections.view_images' => 'Lihat Gambar',
			'drawing.title' => 'Ruang Gambar',
			'drawing.tools' => 'Alat',
			'drawing.brush' => 'Kuas',
			'drawing.eraser' => 'Penghapus',
			'drawing.color' => 'Warna',
			'drawing.size' => 'Ukuran',
			'drawing.clear' => 'Bersihkan',
			'drawing.save' => 'Simpan',
			'drawing.back' => 'Kembali',
			'images.title' => 'Gambar',
			'images.empty' => 'Tidak ada gambar dalam koleksi ini',
			'images.add_image' => 'Tambah Gambar',
			'images.delete' => 'Hapus',
			'images.view' => 'Lihat',
			'images.download' => 'Unduh',
			'settings.title' => 'Pengaturan',
			'settings.language' => 'Bahasa',
			'settings.english' => 'English',
			'settings.indonesian' => 'Indonesia',
			'settings.faq' => 'FAQ',
			'settings.terms_of_service' => 'Syarat & Ketentuan',
			'settings.privacy_policy' => 'Kebijakan Privasi',
			'settings.about' => 'Tentang',
			'settings.version' => 'Versi',
			'common.ok' => 'OK',
			'common.cancel' => 'Batal',
			'common.yes' => 'Ya',
			'common.no' => 'Tidak',
			'common.delete' => 'Hapus',
			'common.save' => 'Simpan',
			'common.edit' => 'Edit',
			'common.add' => 'Tambah',
			'common.remove' => 'Hapus',
			'common.loading' => 'Memuat...',
			'common.error' => 'Error',
			'common.success' => 'Berhasil',
			'common.confirm' => 'Konfirmasi',
			'common.warning' => 'Peringatan',
			'messages.collection_created' => 'Koleksi berhasil dibuat',
			'messages.collection_deleted' => 'Koleksi berhasil dihapus',
			'messages.collection_updated' => 'Koleksi berhasil diperbarui',
			'messages.image_saved' => 'Gambar berhasil disimpan',
			'messages.image_deleted' => 'Gambar berhasil dihapus',
			'messages.confirm_delete' => 'Apakah Anda yakin ingin menghapus item ini?',
			'messages.error_occurred' => 'Terjadi kesalahan. Silakan coba lagi.',
			'messages.no_internet' => 'Tidak ada koneksi internet. Silakan periksa jaringan Anda.',
			_ => null,
		};
	}
}
