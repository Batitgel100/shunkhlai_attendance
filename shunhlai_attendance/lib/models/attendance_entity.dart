class AttendanceEnity {
  int id;
  int? employeeId;
  DateTime? checkIn;
  DateTime? checkOut;
  double? workedHours;

  AttendanceEnity({
    required this.id,
    required this.employeeId,
    required this.checkIn,
    required this.checkOut,
    required this.workedHours,
  });

  factory AttendanceEnity.fromJson(Map<String, dynamic> json) {
    return AttendanceEnity(
      id: json["id"],
      employeeId: json["employee_id"],
      checkIn:
          json["check_in"] != null ? DateTime.parse(json["check_in"]) : null,
      checkOut:
          json["check_out"] != null ? DateTime.parse(json["check_out"]) : null,
      workedHours: json["worked_hours"]?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "employee_id": employeeId,
        "check_in": checkIn?.toIso8601String(),
        "check_out": checkOut?.toIso8601String(),
        "worked_hours": workedHours,
      };
}
