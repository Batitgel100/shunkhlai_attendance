// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shunhlai_attendance/constant/app_url.dart';
import 'package:shunhlai_attendance/globals.dart';
import 'package:shunhlai_attendance/models/attendince_list_entity.dart';

class AttendanceListApiClient {
  Future<List<AttendanceListEntity>> getAttendanceList(int employeeId) async {
    var headers = {'Access-token': Globals.getRegister().toString()};
    var response = await http.get(
      Uri.parse(
          '${AppUrl.baseUrl}/api/hr.attendance?filters=[["employee_id", "=", ${Globals.getEmployeeId()}]]'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];

      List<AttendanceListEntity> attendanceList = results
          .map((result) => AttendanceListEntity.fromJson(result))
          .toList();

      // Filter attendance records for the last 7 days
      DateTime today = DateTime.now();
      DateTime sevenDaysAgo = today.subtract(const Duration(days: 30));
      List<AttendanceListEntity> last7DaysAttendance =
          attendanceList.where((attendance) {
        DateTime checkInDate = DateTime.parse(attendance.checkIn!);
        return checkInDate.isAfter(sevenDaysAgo) && checkInDate.isBefore(today);
      }).toList();

      // Calculate the sum of worked hours for the last 7 days
      double totalWorkedHours = last7DaysAttendance
          .map((attendance) => attendance.workedHours ?? 0.0)
          .reduce((a, b) => a + b);
      print(totalWorkedHours);
      // Return the total worked hours
      return last7DaysAttendance;
    } else {
      throw Exception('Failed to load attendance data');
    }
  }
}

class AttendanceListApiClients {
  Future<double> getTotalWorkedHours(
      int employeeId, DateTime startDate, DateTime endDate) async {
    var headers = {'Access-token': Globals.getRegister().toString()};
    var response = await http.get(
      Uri.parse(
          '${AppUrl.baseUrl}/api/hr.attendance?filters=[["employee_id", "=", ${Globals.getEmployeeId()}]]'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final dynamic responseData = json.decode(response.body);

      if (responseData is Map<String, dynamic>) {
        final List<dynamic> results = responseData['results'];
        List<AttendanceListEntity> attendanceList = results
            .map((result) => AttendanceListEntity.fromJson(result))
            .toList();
        double totalWorkedHours = 0.0;
        for (var attendance in attendanceList) {
          DateTime checkInTime = DateTime.parse(attendance.checkIn!);
          if (checkInTime.isAfter(startDate) && checkInTime.isBefore(endDate)) {
            totalWorkedHours += attendance.workedHours!;
          }
        }
        return totalWorkedHours;
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to load total hour data');
    }
  }
}

class TodayWorkedHoursApiClient {
  Future<Map<String, dynamic>> fetchAttendanceData() async {
    var headers = {'Access-token': Globals.getRegister()};
    final response = await http.get(
      Uri.parse(
          '${AppUrl.baseUrl}/api/hr.attendance?filters=[["employee_id", "=", ${Globals.getEmployeeId()}]]'),
      headers: headers,
    );

    // print('Response status code: ${response.statusCode}');
    // print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);
      if (data.containsKey('results') &&
          data['results'] is List<dynamic> &&
          data['results'].isNotEmpty) {
        return data['results'][0]; // Return the first element of the list
      }
    }
    throw Exception('Failed to load today data');
  }
}
