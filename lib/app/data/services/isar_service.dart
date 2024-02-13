import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:kidcol/app/data/entities/gambar.dart';
import 'package:kidcol/app/data/entities/koleksi.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  //TODO : Save koleksi
  Future<void> saveKoleksi(Koleksi newKoleksi) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.koleksis.putSync(newKoleksi));
  }

  //TODO : Save Gambar
  Future<void> saveGambar(Gambar newGambar) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.gambars.putSync(newGambar));
  }

  //TODO : Get All Koleksi
  Future<List<Koleksi>> getAllKoleksis() async {
    final isar = await db;
    return await isar.koleksis.where().findAll();
  }

  //TODO : Change Listener for Data Koleksi
  Stream<List<Koleksi>> listenToKoleksis() async* {
    final isar = await db;
    yield* isar.koleksis.where().watch(fireImmediately: true);
  }

  //TODO : get All Gambar by koleksi id
  Future<List<Gambar>> getGambarKoleksi(Koleksi koleksi) async {
    final isar = await db;
    return await isar.gambars
        .filter()
        .koleksis((q) => q.idEqualTo(koleksi.id))
        .findAll();
  }

  //TODO : Change Listener for get All Gambar by koleksi id
  Stream<List<Gambar>> listenToGambars(Koleksi koleksi) async* {
    final isar = await db;
    yield* isar.gambars.filter().koleksis((q) => q.idEqualTo(koleksi.id)).watch(fireImmediately: true); 
    ;
  }

  //TODO : Delete Koleksi 
  Future<void> deleteKoleksi(Koleksi koleksi) async {
    final isar = await db;
    isar.writeTxn(() => isar.koleksis.delete(koleksi.id));
  }

  //TODO : Delete Gambar
  Future<void> deleteGambar(Gambar gambar) async {
    final isar = await db;
    isar.writeTxn(() => isar.gambars.delete(gambar.id));
  }

  //open DB connection
  Future<Isar> openDB() async {
    var dirPath = "/assets/db";
    if (!kIsWeb) {
      var appDocDir = await getApplicationDocumentsDirectory();
      dirPath = appDocDir.path;
    }

    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [KoleksiSchema, GambarSchema],
        inspector: true,
        directory: dirPath,
      );
    }

    return Future.value(Isar.getInstance());
  }
}
