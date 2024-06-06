// To parse this JSON data, do
//
//     final hrLeaveEntity = hrLeaveEntityFromJson(jsonString);

import 'dart:convert';

HrLeaveEntity hrLeaveEntityFromJson(String str) =>
    HrLeaveEntity.fromJson(json.decode(str));

String hrLeaveEntityToJson(HrLeaveEntity data) => json.encode(data.toJson());

class HrLeaveEntity {
  int id;
  String? name;
  EmployeeId? employeeId;
  HolidayStatusId? holidayStatusId;
  DateTime? requestDateFrom;
  DateTime? requestDateTo;
  double? numberOfDays;
  double? numberOfHoursDisplay;
  dynamic requestUnitHalf;
  bool? requestUnitHours;
  String? requestHourFrom;
  String? requestHourTo;
  String? state;
  EmployeeId? departmentId;

  HrLeaveEntity({
    required this.id,
    this.name,
    this.employeeId,
    this.holidayStatusId,
    this.requestDateFrom,
    this.requestDateTo,
    this.numberOfDays,
    this.departmentId,
    this.numberOfHoursDisplay,
    this.requestUnitHalf,
    this.requestUnitHours,
    this.requestHourFrom,
    this.requestHourTo,
    this.state,
  });

  factory HrLeaveEntity.fromJson(Map<String, dynamic> json) => HrLeaveEntity(
        id: json["id"],
        name: json["name"],
        employeeId: EmployeeId.fromJson(json["employee_id"]),
        holidayStatusId: HolidayStatusId.fromJson(json["holiday_status_id"]),
        requestDateFrom: DateTime.parse(json["date_from"]),
        requestDateTo: DateTime.parse(json["date_to"]),
        numberOfDays: json["number_of_days"],
        departmentId: EmployeeId.fromJson(json["department_id"]),
        numberOfHoursDisplay: json["number_of_hours_display"],
        requestUnitHalf: json["request_unit_half"],
        requestUnitHours: json["request_unit_hours"],
        requestHourFrom: json["request_hour_from"],
        requestHourTo: json["request_hour_to"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "employee_id": employeeId!.toJson(),
        "holiday_status_id": holidayStatusId!.toJson(),
        "date_from":
            "${requestDateFrom!.year.toString().padLeft(4, '0')}-${requestDateFrom!.month.toString().padLeft(2, '0')}-${requestDateFrom!.day.toString().padLeft(2, '0')}",
        "date_to":
            "${requestDateTo!.year.toString().padLeft(4, '0')}-${requestDateTo!.month.toString().padLeft(2, '0')}-${requestDateTo!.day.toString().padLeft(2, '0')}",
        "number_of_days": numberOfDays,
        "number_of_hours_display": numberOfHoursDisplay,
        "request_unit_half": requestUnitHalf,
        "department_id": departmentId!.toJson(),
        "request_unit_hours": requestUnitHours,
        "request_hour_from": requestHourFrom,
        "request_hour_to": requestHourTo,
        "state": state,
      };
}

class EmployeeId {
  int id;
  String? name;

  EmployeeId({
    required this.id,
    this.name,
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

class HolidayStatusId {
  int id;
  String? name;
  String? requestUnit;
  String? newType;
  String? validationType;
  int? responsibleId;
  int? companyId;

  HolidayStatusId({
    required this.id,
    this.name,
    this.requestUnit,
    this.newType,
    this.validationType,
    this.responsibleId,
    this.companyId,
  });

  factory HolidayStatusId.fromJson(Map<String, dynamic> json) =>
      HolidayStatusId(
        id: json["id"],
        name: json["name"],
        requestUnit: json["request_unit"],
        newType: json["new_type"],
        validationType: json["validation_type"],
        responsibleId: json["responsible_id"],
        companyId: json["company_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "request_unit": requestUnit,
        "new_type": newType,
        "validation_type": validationType,
        "responsible_id": responsibleId,
        "company_id": companyId,
      };
}
