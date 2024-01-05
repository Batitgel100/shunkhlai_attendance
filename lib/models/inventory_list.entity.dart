// To parse this JSON data, do
//
//     final inventoryListEntity = inventoryListEntityFromJson(jsonString);

import 'dart:convert';

InventoryListEntity inventoryListEntityFromJson(String str) =>
    InventoryListEntity.fromJson(json.decode(str));

String inventoryListEntityToJson(InventoryListEntity data) =>
    json.encode(data.toJson());

class InventoryListEntity {
  int id;
  String? name;
  String? state;
  String? date;
  Id? companyId;
  dynamic accountingDate;
  List<LocId>? locationIds;

  InventoryListEntity({
    required this.id,
    required this.name,
    required this.date,
    required this.state,
    required this.companyId,
    required this.accountingDate,
    required this.locationIds,
  });

  factory InventoryListEntity.fromJson(Map<String, dynamic> json) =>
      InventoryListEntity(
        id: json["id"],
        name: json["name"],
        date: json["date"],
        companyId: Id.fromJson(json["company_id"]),
        accountingDate: json["accounting_date"],
        locationIds: List<LocId>.from(
            json["location_ids"].map((x) => LocId.fromJson(x))),
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "date": date,
        "state": state,
        "company_id": companyId!.toJson(),
        "accounting_date": accountingDate,
        "location_ids": List<dynamic>.from(locationIds!.map((x) => x.toJson())),
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
