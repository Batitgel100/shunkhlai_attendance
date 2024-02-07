// To parse this JSON data, do
//
//     final productEntity = productEntityFromJson(jsonString);

import 'dart:convert';

ProductEntity productEntityFromJson(String str) =>
    ProductEntity.fromJson(json.decode(str));

String productEntityToJson(ProductEntity data) => json.encode(data.toJson());

class ProductEntity {
  int? id;
  String? name;
  String? barcode;
  String? defaultCode;
  String? image256;
  Id? categId;
  double? weight;
  double? volume;

  Id? uomId;

  ProductEntity({
    required this.id,
    required this.name,
    this.barcode,
    this.defaultCode,
    this.image256,
    this.categId,
    this.uomId,
    this.weight,
    this.volume,
  });

  factory ProductEntity.fromJson(Map<String, dynamic> json) => ProductEntity(
        id: json["id"],
        name: json["name"],
        barcode: json["barcode"],
        defaultCode: json["default_code"],
        image256: json["image_256"],
        weight: json["weight"],
        volume: json["volume"],
        categId: Id.fromJson(json["categ_id"]),
        uomId: Id.fromJson(json["uom_id"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "barcode": barcode,
        "default_code": defaultCode,
        "image_256": image256,
        "categ_id": categId!.toJson(),
        "weight": weight,
        "volume": volume,
        "uom_id": uomId!.toJson(),
      };
}

class Id {
  int? id;
  String? name;

  Id({
    required this.id,
    required this.name,
  });

  factory Id.fromJson(Map<String, dynamic> json) => Id(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
