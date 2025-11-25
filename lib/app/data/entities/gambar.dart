import 'package:isar_community/isar.dart';
import 'package:kidcol/app/data/entities/koleksi.dart';

part 'gambar.g.dart';

@collection
class Gambar {
  Id id = Isar.autoIncrement;

  @Index()
  late String endpoint;

  String? object;

  @Backlink(to: "gambars")
  final koleksis = IsarLinks<Koleksi>();
}
