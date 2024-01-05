// To parse this JSON data, do
//
//     final salaryEntity = salaryEntityFromJson(jsonString);

import 'dart:convert';

SalaryEntity salaryEntityFromJson(String str) =>
    SalaryEntity.fromJson(json.decode(str));

String salaryEntityToJson(SalaryEntity data) => json.encode(data.toJson());

class SalaryEntity {
  int id;
  String number;
  String state;
  EmployeeId employeeId;
  DateTime? dateFrom;
  DateTime? dateTo;
  List<LineId>? lineIds;

  SalaryEntity({
    required this.id,
    required this.number,
    required this.state,
    required this.employeeId,
    this.dateFrom,
    this.dateTo,
    this.lineIds,
  });

  factory SalaryEntity.fromJson(Map<String, dynamic> json) => SalaryEntity(
        id: json["id"],
        number: json["number"],
        state: json["state"],
        employeeId: EmployeeId.fromJson(json["employee_id"]),
        dateFrom: DateTime.parse(json["date_from"]),
        dateTo: DateTime.parse(json["date_to"]),
        lineIds:
            List<LineId>.from(json["line_ids"].map((x) => LineId.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "number": number,
        "state": state,
        "employee_id": employeeId.toJson(),
        "date_from":
            "${dateFrom!.year.toString().padLeft(4, '0')}-${dateFrom!.month.toString().padLeft(2, '0')}-${dateFrom!.day.toString().padLeft(2, '0')}",
        "date_to":
            "${dateTo!.year.toString().padLeft(4, '0')}-${dateTo!.month.toString().padLeft(2, '0')}-${dateTo!.day.toString().padLeft(2, '0')}",
        "line_ids": List<dynamic>.from(lineIds!.map((x) => x.toJson())),
      };
}

class EmployeeId {
  int id;
  String name;

  EmployeeId({
    required this.id,
    required this.name,
  });

  factory EmployeeId.fromJson(Map<String, dynamic> json) => EmployeeId(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class LineId {
  int id;
  String name;
  double amount;

  LineId({
    required this.id,
    required this.name,
    required this.amount,
  });

  factory LineId.fromJson(Map<String, dynamic> json) => LineId(
        id: json["id"],
        name: json["name"],
        amount: json["amount"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "amount": amount,
      };
}
