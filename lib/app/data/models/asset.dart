// To parse this JSON data, do
//
//     final asset = assetFromJson(jsonString);

import 'dart:convert';
import 'package:get/get.dart';
import 'package:kidcol/app/data/services/image_server_service.dart';

List<Asset> assetFromJson(String str) =>
    List<Asset>.from(json.decode(str).map((x) => Asset.fromJson(x)));

String assetToJson(List<Asset> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Asset {
  final String? id;
  final String? imageUrl;
  final int? level;
  final String? object;
  final String? category;
  final String? type;
  final DateTime? createdAt;
  final DateTime? deletedAt;

  Asset({
    this.id,
    this.imageUrl,
    this.level,
    this.object,
    this.category,
    this.type,
    this.createdAt,
    this.deletedAt,
  });

  factory Asset.fromJson(Map<String, dynamic> json) => Asset(
        id: json["id"],
        imageUrl: json["image_url"],
        level: json["level"],
        object: json["object"],
        category: json["category"],
        type: json["type"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        deletedAt: json["deleted_at"] == null
            ? null
            : DateTime.parse(json["deleted_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image_url": imageUrl,
        "level": level,
        "object": object,
        "category": category,
        "type": type,
        "created_at": createdAt?.toIso8601String(),
        "deleted_at": deletedAt?.toIso8601String(),
      };

  /// Get image URL with automatic server failover
  /// If primary server is down, it will automatically use backup server
  String getImageUrl() {
    if (imageUrl == null || imageUrl!.isEmpty) return '';

    try {
      // Try to get ImageServerService
      final imageServerService = Get.find<ImageServerService>();
      return imageServerService.getImageUrl(imageUrl!);
    } catch (e) {
      // If service not found, return original URL
      return imageUrl!;
    }
  }
}
