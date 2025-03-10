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

  Asset({
    this.designId,
    this.designName,
    this.parentId,
    this.imageUrl,
    this.createdAt,
  });

  factory Asset.fromJson(Map<String, dynamic> json) => Asset(
        designId: json["design_id"],
        designName: json["design_name"],
        parentId: json["parent_id"],
        imageUrl: json["image_url"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "design_id": designId,
        "design_name": designName,
        "parent_id": parentId,
        "image_url": imageUrl,
        "created_at": createdAt?.toIso8601String(),
      };
}
