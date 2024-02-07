// To parse this JSON data, do
//
//     final inventoryLineEntity = inventoryLineEntityFromJson(jsonString);

import 'dart:convert';

InventoryLineEntity inventoryLineEntityFromJson(String str) =>
    InventoryLineEntity.fromJson(json.decode(str));

String inventoryLineEntityToJson(InventoryLineEntity data) =>
    json.encode(data.toJson());

class InventoryLineEntity {
  int? id;
  int? inventoryId;
  ProdId? productId;
  LocId? locationId;
  double? theoreticalQty;
  double? productQty;
  double? differenceQty;
  Id? prodLotId;
  Id? packageId;

  InventoryLineEntity({
    required this.id,
    this.inventoryId,
    required this.productId,
    this.locationId,
    this.theoreticalQty,
    this.productQty,
    this.differenceQty,
    this.prodLotId,
    this.packageId,
  });

  factory InventoryLineEntity.fromJson(Map<String, dynamic> json) =>
      InventoryLineEntity(
        id: json["id"],
        inventoryId: json["inventory_id"],
        productId: json["product_id"] = ProdId.fromJson(json["product_id"]),
        locationId: json["location_id"] == null
            ? null
            : LocId.fromJson(json["location_id"]),
        theoreticalQty: json["theoretical_qty"],
        productQty: json["product_qty"],
        differenceQty: json["difference_qty"],
        prodLotId: json["prod_lot_id"] == null
            ? null
            : Id.fromJson(json["prod_lot_id"]),
        packageId:
            json["package_id"] == null ? null : Id.fromJson(json["package_id"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "inventory_id": inventoryId,
        "product_id": productId?.toJson(),
        "location_id": locationId?.toJson(),
        "theoretical_qty": theoreticalQty,
        "product_qty": productQty,
        "difference_qty": differenceQty,
        "prod_lot_id": prodLotId?.toJson(),
        "package_id": packageId?.toJson(),
      };
}

class Id {
  int? id;
  String? name;

  Id({
    this.id,
    this.name,
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

class LocId {
  int? id;
  String? displayName;

  LocId({
    this.id,
    this.displayName,
  });

  factory LocId.fromJson(Map<String, dynamic> json) => LocId(
        id: json["id"],
        displayName: json["display_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "display_name": displayName,
      };
}

class ProdId {
  int? id;
  String? displayName;
  String? barcode;

  ProdId({
    this.id,
    this.displayName,
    this.barcode,
  });

  factory ProdId.fromJson(Map<String, dynamic> json) => ProdId(
        id: json["id"],
        barcode: json["barcode"],
        displayName: json["display_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "display_name": displayName,
        "barcode": barcode,
      };
}
