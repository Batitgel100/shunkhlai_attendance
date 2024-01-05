import 'dart:convert';

LocationEntity locationEntityFromJson(String str) =>
    LocationEntity.fromJson(json.decode(str));

String locationEntityToJson(LocationEntity data) => json.encode(data.toJson());

class LocationEntity {
  int id;
  String? name;
  String? usage;

  LocationEntity({
    required this.id,
    required this.name,
    required this.usage,
  });

  factory LocationEntity.fromJson(Map<String, dynamic> json) => LocationEntity(
        id: json["id"],
        name: json["display_name"],
        usage: json["usage"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "display_name": name,
        "usage": usage,
      };
}
