import 'dart:convert';

ProdLotEntity prodLotEntityFromJson(String str) =>
    ProdLotEntity.fromJson(json.decode(str));

String prodLotEntityToJson(ProdLotEntity data) => json.encode(data.toJson());

class ProdLotEntity {
  int id;
  String name;
  int productId;

  ProdLotEntity({
    required this.productId,
    required this.id,
    required this.name,
  });

  factory ProdLotEntity.fromJson(Map<String, dynamic> json) => ProdLotEntity(
        id: json["id"],
        productId: json["product_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "product_id": productId,
      };
}
