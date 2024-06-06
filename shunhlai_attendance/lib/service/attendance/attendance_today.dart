import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shunhlai_attendance/constant/app_url.dart';
import 'package:shunhlai_attendance/globals.dart';
import 'package:shunhlai_attendance/models/attendance_entity.dart';

class AttendanceToday {
  Future<List<AttendanceEnity>> fetchData() async {
    final Map<String, String> headers = {
      'Access-token': Globals.getRegister().toString(),
    };

    var dateNow = DateTime.now();
    var date24HoursAgo = dateNow.subtract(const Duration(hours: 24));

    final response = await http.get(
      Uri.parse(
          '${AppUrl.baseUrl}/api/hr.attendance?filters=[["employee_id", "=", ${Globals.getEmployeeId()}],["check_in", ">=", "$date24HoursAgo"],["check_in", "<=", "$dateNow"]]'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        // Print the received JSON for debugging
        // print('Received JSON: $jsonData');

        // Check if the response contains 'result' key and is a List
        if (jsonData.containsKey('result') && jsonData['result'] is List) {
          // Extract the list directly
          final List<dynamic> resultsData = jsonData['result'];

          List<AttendanceEnity> attendanceList = resultsData
              .map((json) => AttendanceEnity.fromJson(json))
              .toList();

          // Check if the last item's check_out is null
          if (attendanceList.isNotEmpty) {
            AttendanceEnity lastAttendance = attendanceList.first;
            if (lastAttendance.checkOut == null) {
              Globals.changeLeft(false);
            } else {
              Globals.changeLeft(true);
            }
          } else {
            Globals.changeLeft(true);
          }

          return attendanceList;
        } else {
          print('Invalid response format. Expected a List under "result".');
          throw Exception('Invalid response format');
        }
      } catch (e) {
        print('Error parsing response: $e');
        throw Exception('Failed to load data');
      }
    } else {
      print(
          'Failed to load today\'s attendance data. Response: ${response.body}');
      throw Exception('Failed to load data');
    }
  }
}
