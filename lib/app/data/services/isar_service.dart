import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:isar_community/isar.dart';
import 'package:kidcol/app/data/entities/gambar.dart';
import 'package:kidcol/app/data/entities/koleksi.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  late Future<Isar> db;
  static const String _instanceName = 'kidcol_instance';
  static const int _maxSizeMiB = 256;
  bool _isInitialized = false;
  Isar? _cachedInstance;

  IsarService() {
    db = openDB();
  }

  //TODO : Save koleksi
  Future<void> saveKoleksi(Koleksi newKoleksi) async {
    try {
      final isar = await db;
      await isar.writeTxn(() async {
        await isar.koleksis.put(newKoleksi);
      });
    } catch (e) {
      throw Exception('Failed to save koleksi: $e');
    }
  }

  //TODO : Save Gambar
  Future<void> saveGambar(Gambar newGambar, {List<Koleksi>? koleksis}) async {
    try {
      final isar = await db;

      // Validate input
      if (newGambar.endpoint.isEmpty) {
        throw ArgumentError('Gambar endpoint cannot be empty');
      }

      debugPrint('📸 Saving gambar: ${newGambar.endpoint}');
      debugPrint('📚 Koleksis to link: ${koleksis?.length ?? 0}');

      // Save the gambar first
      await isar.writeTxn(() async {
        await isar.gambars.put(newGambar);
      });
      debugPrint('✅ Gambar saved with ID: ${newGambar.id}');

      // Now save the relationships from the Koleksi side
      // Since Gambar.koleksis is a @Backlink, we must save from Koleksi.gambars
      if (koleksis != null && koleksis.isNotEmpty) {
        for (final koleksi in koleksis) {
          debugPrint(
              '🔗 Linking to koleksi: ${koleksi.title} (ID: ${koleksi.id})');

          // Reload koleksi from DB to get managed instance
          final managedKoleksi = await isar.koleksis.get(koleksi.id);
          if (managedKoleksi != null) {
            // Add and save in a transaction
            await isar.writeTxn(() async {
              managedKoleksi.gambars.add(newGambar);
              await managedKoleksi.gambars.save();
            });
            debugPrint('✅ Link saved for koleksi: ${koleksi.title}');
          }
        }
      }
      debugPrint('🎉 All done! Gambar and relationships saved.');
    } catch (e) {
      debugPrint('❌ Error in saveGambar: $e');
      throw Exception('Failed to save gambar: $e');
    }
  }

  //TODO : Get All Koleksi
  Future<List<Koleksi>> getAllKoleksis() async {
    try {
      final isar = await db;
      return await isar.koleksis.where().sortByTitle().findAll();
    } catch (e) {
      throw Exception('Failed to get koleksis: $e');
    }
  }

  //TODO : Change Listener for Data Koleksi
  Stream<List<Koleksi>> listenToKoleksis() async* {
    try {
      final isar = await db;
      yield* isar.koleksis.where().sortByTitle().watch(fireImmediately: true);
    } catch (e) {
      throw Exception('Failed to listen to koleksis: $e');
    }
  }

  //TODO : get All Gambar by koleksi id
  Future<List<Gambar>> getGambarKoleksi(Koleksi koleksi) async {
    try {
      final isar = await db;
      // Use the reference approach with proper filtering
      final koleksiWithGambars =
          await isar.koleksis.filter().idEqualTo(koleksi.id).findFirst();

      if (koleksiWithGambars != null) {
        await koleksiWithGambars.gambars.load();
        return koleksiWithGambars.gambars.toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to get gambar koleksi: $e');
    }
  }

  //TODO : Change Listener for get All Gambar by koleksi id
  Stream<List<Gambar>> listenToGambars(Koleksi koleksi) async* {
    try {
      final isar = await db;
      // Watch gambars collection directly with filter for better reactivity
      yield* isar.gambars
          .filter()
          .koleksis((q) => q.idEqualTo(koleksi.id))
          .watch(fireImmediately: true);
    } catch (e) {
      debugPrint('Error in listenToGambars: $e');
      throw Exception('Failed to listen to gambars: $e');
    }
  }

  //TODO : Delete Koleksi
  Future<void> deleteKoleksi(Koleksi koleksi) async {
    try {
      final isar = await db;
      await isar.writeTxn(() async {
        await isar.koleksis.delete(koleksi.id);
      });
    } catch (e) {
      throw Exception('Failed to delete koleksi: $e');
    }
  }

  //TODO : Delete Gambar
  Future<void> deleteGambar(Gambar gambar) async {
    try {
      final isar = await db;
      await isar.writeTxn(() async {
        await isar.gambars.delete(gambar.id);
      });
    } catch (e) {
      throw Exception('Failed to delete gambar: $e');
    }
  }

  //open DB connection
  Future<Isar> openDB() async {
    if (_isInitialized && _cachedInstance != null) {
      return _cachedInstance!;
    }

    try {
      var dirPath = "/assets/db";
      if (!kIsWeb) {
        var appDocDir = await getApplicationDocumentsDirectory();
        dirPath = appDocDir.path;
      }

      // Ensure directory exists
      final dbDir = Directory(dirPath);
      if (!await dbDir.exists()) {
        await dbDir.create(recursive: true);
      }

      if (Isar.instanceNames.isEmpty) {
        _cachedInstance = await Isar.open(
          [KoleksiSchema, GambarSchema],
          inspector: kDebugMode, // Only enable inspector in debug mode
          directory: dirPath,
          maxSizeMiB: _maxSizeMiB, // Set database size limit
          name:
              _instanceName, // Use named instance for better connection management
        );
        _isInitialized = true;
        return _cachedInstance!;
      }

      _cachedInstance = Isar.getInstance(_instanceName);
      _isInitialized = true;
      return _cachedInstance!;
    } catch (e) {
      throw Exception('Failed to open database: $e');
    }
  }

  // Cleanup method to properly close database connections
  Future<void> close() async {
    try {
      // Check if database is already closed or not initialized
      if (!_isInitialized || _cachedInstance == null) {
        return; // Already closed or never initialized
      }

      // Check if the instance is still open
      if (_cachedInstance!.isOpen) {
        await _cachedInstance!.close();
      }

      _cachedInstance = null;
      _isInitialized = false;
    } catch (e) {
      // Log the error but don't throw to prevent crashes
      debugPrint('Error closing database: $e');
      // Ensure state is reset even if close fails
      _cachedInstance = null;
      _isInitialized = false;
    }
  }

  // Method to check if database is initialized
  bool get isInitialized => _isInitialized;

  // Method to get database size information
  Future<int> getDatabaseSize() async {
    try {
      await db; // Just to ensure database is initialized
      // This is a simplified approach - actual size calculation may vary
      // depending on the platform and Isar implementation
      return 0; // Placeholder - Isar doesn't expose direct size info
    } catch (e) {
      throw Exception('Failed to get database size: $e');
    }
  }

  // Method to compact database (reclaim space)
  Future<void> compactDatabase() async {
    try {
      final isar = await db;
      await isar.writeTxn(() async {
        // Isar automatically compacts during transactions
        // This is a placeholder for explicit compaction if needed
      });
    } catch (e) {
      throw Exception('Failed to compact database: $e');
    }
  }
}
