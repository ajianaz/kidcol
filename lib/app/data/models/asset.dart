class Asset {
    final String? uuid;
    final String? name;
    final String? directory;
    final int? typeId;
    final int? categoryId;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final String? createdBy;
    final dynamic deletedAt;

    Asset({
        this.uuid,
        this.name,
        this.directory,
        this.typeId,
        this.categoryId,
        this.createdAt,
        this.updatedAt,
        this.createdBy,
        this.deletedAt,
    });

    factory Asset.fromJson(Map<String, dynamic> json) => Asset(
        uuid: json["uuid"],
        name: json["name"],
        directory: json["directory"],
        typeId: json["type_id"],
        categoryId: json["category_id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdBy: json["created_by"],
        deletedAt: json["deleted_at"],
    );

    Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "name": name,
        "directory": directory,
        "type_id": typeId,
        "category_id": categoryId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "created_by": createdBy,
        "deleted_at": deletedAt,
    };
}