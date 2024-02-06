import "package:isar/isar.dart";
import "package:kidcol/app/data/entities/gambar.dart";

part 'koleksi.g.dart';

//TODO : create a collection of collection

@collection
class Koleksi {
  Id id = Isar.autoIncrement;
  late String title;

  //TODO : Add the backlink to collection <> image

  @Backlink(to: 'koleksis')
  final gambars = IsarLinks<Gambar>();
}