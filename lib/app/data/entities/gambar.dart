import 'package:isar_community/isar.dart';
import 'package:get/get.dart';
import 'package:kidcol/app/data/entities/koleksi.dart';
import 'package:kidcol/app/data/services/image_server_service.dart';

part 'gambar.g.dart';

@collection
class Gambar {
  Id id = Isar.autoIncrement;

  @Index()
  late String endpoint;

  String? object;

  @Backlink(to: "gambars")
  final koleksis = IsarLinks<Koleksi>();

  /// Get image URL with automatic server failover
  /// If primary server is down, it will automatically use backup server
  String getImageUrl() {
    if (endpoint.isEmpty) return '';

    try {
      // Try to get ImageServerService
      final imageServerService = Get.find<ImageServerService>();
      return imageServerService.getImageUrl(endpoint);
    } catch (e) {
      // If service not found, return original URL
      return endpoint;
    }
  }
}
