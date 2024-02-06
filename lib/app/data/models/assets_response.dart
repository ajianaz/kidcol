import 'dart:convert';

import 'package:kidcol/app/data/models/asset.dart';

AssetsResponse assetsResponseFromJson(String str) => AssetsResponse.fromJson(json.decode(str));

String assetsResponseToJson(AssetsResponse data) => json.encode(data.toJson());

class AssetsResponse {
    final int? total;
    final int? totalPages;
    final int? currentPage;
    final List<Asset>? assets;

    AssetsResponse({
        this.total,
        this.totalPages,
        this.currentPage,
        this.assets,
    });

    factory AssetsResponse.fromJson(Map<String, dynamic> json) => AssetsResponse(
        total: json["total"],
        totalPages: json["totalPages"],
        currentPage: json["currentPage"],
        assets: json["assets"] == null ? [] : List<Asset>.from(json["assets"]!.map((x) => Asset.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "totalPages": totalPages,
        "currentPage": currentPage,
        "assets": assets == null ? [] : List<dynamic>.from(assets!.map((x) => x.toJson())),
    };
}