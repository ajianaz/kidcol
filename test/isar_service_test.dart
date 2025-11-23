import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:kidcol/app/data/entities/gambar.dart';
import 'package:kidcol/app/data/entities/koleksi.dart';
import 'package:kidcol/app/data/services/isar_service.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

// Mock implementation for testing
class MockPathProviderPlatform extends PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    return './test_db';
  }

  @override
  Future<String?> getTemporaryPath() async {
    return './temp_db';
  }

  @override
  Future<String?> getLibraryPath() async {
    return './lib_db';
  }

  @override
  Future<String?> getApplicationSupportPath() async {
    return './support_db';
  }

  @override
  Future<String?> getExternalStoragePath() async {
    return './external_db';
  }

  @override
  Future<List<String>?> getExternalCachePaths() async {
    return ['./external_cache_db'];
  }

  @override
  Future<List<String>?> getExternalStoragePaths({
    StorageDirectory? type,
  }) async {
    return ['./external_storage_db'];
  }

  @override
  Future<String?> getDownloadsPath() async {
    return './downloads_db';
  }
}

void main() {
  group('IsarService Tests', () {
    late IsarService isarService;
    late Isar isar;

    setUpAll(() async {
      // Set up mock path provider
      PathProviderPlatform.instance = MockPathProviderPlatform();
    });

    setUp(() async {
      isarService = IsarService();
      isar = await isarService.db;
    });

    tearDown(() async {
      await isarService.close();
    });

    test('saveGambar should not throw nested transaction error', () async {
      // Create a new koleksi
      final koleksi = Koleksi()..title = 'Test Collection';

      // Save the koleksi first
      await isar.writeTxn(() async {
        await isar.koleksis.put(koleksi);
      });

      // Create a new gambar
      final gambar = Gambar()..endpoint = 'test_endpoint.jpg';

      // Add the koleksi to the gambar
      gambar.koleksis.add(koleksi);

      // This should not throw a nested transaction error
      expect(
        () async => await isarService.saveGambar(gambar),
        returnsNormally,
      );
    });

    test('saveGambar should correctly establish many-to-many relationship',
        () async {
      // Create a new koleksi
      final koleksi = Koleksi()..title = 'Test Collection';

      // Save the koleksi first
      await isar.writeTxn(() async {
        await isar.koleksis.put(koleksi);
      });

      // Create a new gambar
      final gambar = Gambar()..endpoint = 'test_endpoint.jpg';

      // Add the koleksi to the gambar
      gambar.koleksis.add(koleksi);

      // Save the gambar
      await isarService.saveGambar(gambar);

      // Verify the relationship was established
      final savedGambar = await isar.gambars.get(gambar.id);
      expect(savedGambar, isNotNull);
      expect(savedGambar!.endpoint, equals('test_endpoint.jpg'));

      // Check if the koleksi has the gambar in its gambars link
      final savedKoleksi = await isar.koleksis.get(koleksi.id);
      expect(savedKoleksi, isNotNull);
      expect(savedKoleksi!.gambars.isNotEmpty, isTrue);
      expect(savedKoleksi.gambars.first.id, equals(gambar.id));
    });

    test('saveGambar should handle multiple koleksis', () async {
      // Create multiple koleksis
      final koleksi1 = Koleksi()..title = 'Collection 1';
      final koleksi2 = Koleksi()..title = 'Collection 2';

      // Save the koleksis first
      await isar.writeTxn(() async {
        await isar.koleksis.putAll([koleksi1, koleksi2]);
      });

      // Create a new gambar
      final gambar = Gambar()..endpoint = 'test_endpoint_multiple.jpg';

      // Add both koleksis to the gambar
      gambar.koleksis.addAll([koleksi1, koleksi2]);

      // Save the gambar
      await isarService.saveGambar(gambar);

      // Verify the relationships were established
      final savedKoleksi1 = await isar.koleksis.get(koleksi1.id);
      final savedKoleksi2 = await isar.koleksis.get(koleksi2.id);

      expect(savedKoleksi1!.gambars.isNotEmpty, isTrue);
      expect(savedKoleksi1.gambars.first.id, equals(gambar.id));

      expect(savedKoleksi2!.gambars.isNotEmpty, isTrue);
      expect(savedKoleksi2.gambars.first.id, equals(gambar.id));
    });
  });
}
