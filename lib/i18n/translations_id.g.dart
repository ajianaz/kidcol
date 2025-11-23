///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'translations.g.dart';

// Path: <root>
class TranslationsId extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsId({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.id,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);

	/// Metadata for the translations of <id>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

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
	@override late final _TranslationsDialogId dialog = _TranslationsDialogId._(_root);
	@override late final _TranslationsPrintingId printing = _TranslationsPrintingId._(_root);
	@override late final _TranslationsErrorId error = _TranslationsErrorId._(_root);
	@override late final _TranslationsCollectionId collection = _TranslationsCollectionId._(_root);
	@override late final _TranslationsSearchId search = _TranslationsSearchId._(_root);
	@override late final _TranslationsUiId ui = _TranslationsUiId._(_root);
}

// Path: app
class _TranslationsAppId extends TranslationsAppEn {
	_TranslationsAppId._(TranslationsId root) : this._root = root, super.internal(root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get name => 'Kidcol';
	@override String get collections => 'Koleksi';
	@override String get home => 'Beranda';
	@override String get drawing_room => 'Ruang Gambar';
	@override String get settings => 'Pengaturan';
}

// Path: home
class _TranslationsHomeId extends TranslationsHomeEn {
	_TranslationsHomeId._(TranslationsId root) : this._root = root, super.internal(root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Selamat Datang di Kidcol';
	@override String get subtitle => 'Buat dan kelola koleksi Anda';
	@override String get create_collection => 'Buat Koleksi';
	@override String get view_collections => 'Lihat Koleksi';
	@override String get start_drawing => 'Mulai Menggambar';
}

// Path: collections
class _TranslationsCollectionsId extends TranslationsCollectionsEn {
	_TranslationsCollectionsId._(TranslationsId root) : this._root = root, super.internal(root);

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
	@override String get select_collection => 'Pilih koleksi untuk menambahkan gambar ini';
	@override String get untitled_collection => 'Koleksi Tanpa Judul';
	@override String get close => 'Tutup';
	@override String get image_preview => 'Pratinjau Gambar';
	@override String get failed_to_load_image => 'Gagal memuat gambar';
	@override String get no_image_available => 'Tidak ada gambar tersedia';
	@override String get add_to_collection => 'Tambah ke Koleksi';
	@override String get draw => 'Gambar';
}

// Path: drawing
class _TranslationsDrawingId extends TranslationsDrawingEn {
	_TranslationsDrawingId._(TranslationsId root) : this._root = root, super.internal(root);

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
class _TranslationsImagesId extends TranslationsImagesEn {
	_TranslationsImagesId._(TranslationsId root) : this._root = root, super.internal(root);

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
class _TranslationsSettingsId extends TranslationsSettingsEn {
	_TranslationsSettingsId._(TranslationsId root) : this._root = root, super.internal(root);

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
	@override String get device_id => 'ID Perangkat';
	@override String get copy_device_id => 'Salin ID Perangkat';
	@override String get device_id_copied => 'ID Perangkat disalin ke clipboard';
}

// Path: common
class _TranslationsCommonId extends TranslationsCommonEn {
	_TranslationsCommonId._(TranslationsId root) : this._root = root, super.internal(root);

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
class _TranslationsMessagesId extends TranslationsMessagesEn {
	_TranslationsMessagesId._(TranslationsId root) : this._root = root, super.internal(root);

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
	@override String get update_available => 'Pembaruan tersedia. Silakan perbarui aplikasi.';
}

// Path: dialog
class _TranslationsDialogId extends TranslationsDialogEn {
	_TranslationsDialogId._(TranslationsId root) : this._root = root, super.internal(root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get no_collections => 'Tidak Ada Koleksi';
	@override String get please_add_collection_first => 'Mohon tambahkan koleksi terlebih dahulu.';
	@override String get attention => 'Perhatian';
	@override String get images_finished => 'Gambar sudah habis.';
	@override String get confirm_delete_image => 'Konfirmasi Hapus Gambar';
	@override String get confirm_delete_image_message => 'Apakah anda yakin akan menghapus gambar tersebut?';
	@override String get no_images => 'Tidak ada gambar';
	@override String get device_verification_required => 'Verifikasi Perangkat Diperlukan';
	@override String get device_verification_message => 'Sebagai pengguna berbayar, Anda perlu memverifikasi perangkat Anda untuk terus menggunakan aplikasi.';
	@override String get device_info => 'Informasi Perangkat:';
	@override String get device_id => 'ID Perangkat:';
	@override String get device_id_copied => 'ID Perangkat Disalin';
	@override String get device_id_copied_message => 'ID Perangkat telah disalin ke clipboard';
	@override String get copy_device_id => 'Salin ID Perangkat';
	@override String get verify_device => 'Verifikasi Perangkat';
	@override String get device_verified_successfully => 'Perangkat berhasil diverifikasi';
	@override String get failed_to_verify_device => 'Gagal memverifikasi perangkat';
	@override late final _TranslationsDialogWhatsappVerificationId whatsapp_verification = _TranslationsDialogWhatsappVerificationId._(_root);
	@override String get please_enter_collection_name => 'Silakan masukkan nama koleksi';
	@override String get collection_name_too_short => 'Nama koleksi harus minimal 2 karakter';
	@override String get collection_name_too_long => 'Nama koleksi harus kurang dari 50 karakter';
}

// Path: printing
class _TranslationsPrintingId extends TranslationsPrintingEn {
	_TranslationsPrintingId._(TranslationsId root) : this._root = root, super.internal(root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Cetak PDF';
	@override String get processing_images => 'Memproses gambar:';
	@override String get preparing_images => 'Menyiapkan gambar untuk PDF...';
	@override String get data_not_found => 'Data tidak ditemukan.';
	@override String get download_app_message => 'Unduh Aplikasi KidCol di Playstore dan buat buku mewarnaimu sendiri';
}

// Path: error
class _TranslationsErrorId extends TranslationsErrorEn {
	_TranslationsErrorId._(TranslationsId root) : this._root = root, super.internal(root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get failed_to_load_images => 'Gagal memuat gambar';
	@override String get connection_timeout => 'Koneksi timeout. Silakan periksa koneksi internet Anda.';
	@override String get server_response_timeout => 'Timeout respons server. Silakan coba lagi.';
	@override String get no_internet_connection => 'Tidak ada koneksi internet. Silakan periksa jaringan Anda.';
	@override String get authentication_failed => 'Autentikasi gagal. Silakan periksa kunci API Anda.';
	@override String get access_forbidden => 'Akses ditolak. Anda mungkin perlu memverifikasi akun Anda.';
	@override String get api_endpoint_not_found => 'Endpoint API tidak ditemukan. Silakan periksa konfigurasi server.';
	@override String get server_error => 'Kesalahan server. Silakan coba lagi nanti.';
	@override String get error_loading_data => 'Kesalahan Memuat Data';
	@override String get unexpected_error => 'Terjadi kesalahan tak terduga saat memuat data';
}

// Path: collection
class _TranslationsCollectionId extends TranslationsCollectionEn {
	_TranslationsCollectionId._(TranslationsId root) : this._root = root, super.internal(root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title_prefix => 'Koleksi';
}

// Path: search
class _TranslationsSearchId extends TranslationsSearchEn {
	_TranslationsSearchId._(TranslationsId root) : this._root = root, super.internal(root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Cari Gambar';
	@override String get hint => 'Masukkan kata kunci pencarian...';
	@override String get button => 'Cari';
	@override String get not_implemented => 'Fungsionalitas pencarian akan segera diimplementasikan!';
}

// Path: ui
class _TranslationsUiId extends TranslationsUiEn {
	_TranslationsUiId._(TranslationsId root) : this._root = root, super.internal(root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get tap_to_view => 'Ketuk untuk melihat';
	@override String get swipe_for_more => 'Geser ke atas untuk gambar lainnya';
}

// Path: dialog.whatsapp_verification
class _TranslationsDialogWhatsappVerificationId extends TranslationsDialogWhatsappVerificationEn {
	_TranslationsDialogWhatsappVerificationId._(TranslationsId root) : this._root = root, super.internal(root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get enter_whatsapp_number => 'Masukkan Nomor WhatsApp';
	@override String get verify_whatsapp_number => 'Verifikasi Nomor WhatsApp';
	@override String get enter_whatsapp_message => 'Silakan masukkan nomor WhatsApp Anda untuk memverifikasi akun Anda';
	@override String get verification_code_sent => 'Kode verifikasi telah dikirim ke';
	@override String get verification_code => 'Kode Verifikasi';
	@override String get enter_6_digit_code => 'Masukkan kode 6 digit';
	@override String get please_enter_phone => 'Silakan masukkan nomor telepon Anda';
	@override String get please_enter_code => 'Silakan masukkan kode verifikasi';
	@override String get code_must_be_6_digits => 'Kode harus 6 digit';
	@override String get resend_code => 'Kirim Ulang Kode';
	@override String get verify => 'Verifikasi';
	@override String get send_code => 'Kirim Kode';
	@override String get code_sent => 'Kode Dikirim';
	@override String get code_sent_message => 'Kode verifikasi telah dikirim ke nomor WhatsApp Anda';
	@override String get invalid_code => 'Kode Tidak Valid';
	@override String get invalid_code_message => 'Kode verifikasi yang Anda masukkan tidak valid';
	@override String get whatsapp_verified => 'Terverifikasi';
	@override String get whatsapp_verified_message => 'Nomor WhatsApp Anda telah berhasil diverifikasi';
}
