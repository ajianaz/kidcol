import 'package:isar/isar.dart';
import 'package:kidcol/app/data/entities/koleksi.dart';


part 'gambar.g.dart';

@collection
class Gambar{
  Id id = Isar.autoIncrement;
  late String endpoint;

  final koleksis = IsarLinks<Koleksi>();
}