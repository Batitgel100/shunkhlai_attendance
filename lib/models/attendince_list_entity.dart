class AttendanceListEntity {
  int? id;
  int? employeeId;
  String? checkIn;
  String? checkOut;
  double? workedHours; // Update the field name to match the JSON

  AttendanceListEntity({
    this.id,
    this.employeeId,
    this.checkIn,
    this.checkOut,
    this.workedHours,
  });

  AttendanceListEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employee_id'];
    checkIn = json['check_in'];
    checkOut = json['check_out'];
    workedHours =
        json['worked_hours']; // Update the field name to match the JSON
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['employee_id'] = employeeId;
    data['check_in'] = checkIn;
    data['check_out'] = checkOut;
    data['worked_hours'] =
        workedHours; // Update the field name to match the JSON
    return data;
  }
}
