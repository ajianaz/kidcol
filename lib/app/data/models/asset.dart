// To parse this JSON data, do
//
//     final asset = assetFromJson(jsonString);

import 'dart:convert';

List<Asset> assetFromJson(String str) =>
    List<Asset>.from(json.decode(str).map((x) => Asset.fromJson(x)));

String assetToJson(List<Asset> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Asset {
  final String? designId;
  final String? designName;
  final String? parentId;
  final String? imageUrl;
  final DateTime? createdAt;
  final String? id;
  final int? level;
  final String? object;
  final String? category;
  final String? type;
  final DateTime? deletedAt;

  Asset({
    this.designId,
    this.designName,
    this.parentId,
    this.imageUrl,
    this.createdAt,
    this.id,
    this.level,
    this.object,
    this.category,
    this.type,
    this.deletedAt,
  });

  factory Asset.fromJson(Map<String, dynamic> json) => Asset(
        designId: json["design_id"],
        designName: json["design_name"],
        parentId: json["parent_id"],
        imageUrl: json["image_url"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        id: json["id"],
        level: json["level"],
        object: json["object"],
        category: json["category"],
        type: json["type"],
        deletedAt: json["deleted_at"] == null
            ? null
            : DateTime.parse(json["deleted_at"]),
      );

  Map<String, dynamic> toJson() => {
        "design_id": designId,
        "design_name": designName,
        "parent_id": parentId,
        "image_url": imageUrl,
        "created_at": createdAt?.toIso8601String(),
        "id": id,
        "level": level,
        "object": object,
        "category": category,
        "type": type,
        "deleted_at": deletedAt?.toIso8601String(),
      };
}
