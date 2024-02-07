// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shunhlai_attendance/constant/app_url.dart';
import 'package:shunhlai_attendance/globals.dart';
import 'package:shunhlai_attendance/models/attendance_entity.dart';
import 'package:shunhlai_attendance/models/attendince_list_entity.dart';

class AttendanceListApiClient {
  Future<List<AttendanceListEntity>> fetchData() async {
    final Map<String, String> headers = {
      'Access-token': Globals.getRegister().toString(),
    };

    var dateNow = DateTime.now();
    var date24HoursAgo = dateNow.subtract(const Duration(hours: 24));

    final response = await http.get(
      Uri.parse(
          '${AppUrl.baseUrl}/api/hr.attendance?filters=[["employee_id", "=", ${Globals.getEmployeeId()}]]'),
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

          List<AttendanceListEntity> attendanceList = resultsData
              .map((json) => AttendanceListEntity.fromJson(json))
              .toList();

          // Check if the last item's check_out is null
          if (attendanceList.isNotEmpty) {
            AttendanceListEntity lastAttendance = attendanceList.first;
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

// class AttendanceListApiClients {
//   Future<double> getTotalWorkedHours() async {
//     var headers = {'Access-token': Globals.getRegister()};

//     var request = http.Request(
//       'GET',
//       Uri.parse(
//           '${AppUrl.baseUrl}/api/hr.attendance?filters=[["employee_id", "=", ${Globals.getEmployeeId()}]]'),
//     );

//     request.headers.addAll(headers);

//     http.StreamedResponse response = await request.send();

//     if (response.statusCode == 200) {
//       String responseBody = await response.stream.bytesToString();
//       List<dynamic>? attendanceList =
//           jsonDecode(responseBody)['result']; // Updated key

//       if (attendanceList == null) {
//         // Handle the case where attendanceList is null
//         print('Attendance list is null');
//         return -1; // Or another appropriate value to indicate an error
//       }

//       List<AttendanceEnity> attendanceEntities = attendanceList
//           .map((attendance) => AttendanceEnity.fromJson(attendance))
//           .toList();

//       // Calculate the starting date (25th day of the previous month)
//       DateTime today = DateTime.now();
//       DateTime startingDate = DateTime(today.year, today.month, 25);
//       if (today.day < 25) {
//         startingDate = DateTime(today.year, today.month - 1, 25);
//       }

//       // Filter the attendance entries since the starting date
//       List<AttendanceEnity> filteredAttendanceList = attendanceEntities
//           .where((attendance) =>
//               attendance.checkIn != null &&
//               attendance.checkIn!.isAfter(startingDate))
//           .toList();

//       // Calculate total worked hours
//       double totalWorkedHours = filteredAttendanceList.fold(
//         0,
//         (previous, current) => previous + (current.workedHours ?? 0),
//       );

//       // Return the calculated total worked hours
//       return totalWorkedHours;
//     } else {
//       print(response.reasonPhrase);
//       // Return an appropriate value (e.g., -1) to indicate an error
//       return -1;
//     }
//   }
// }
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
        final List<dynamic>? results =
            responseData['result']; // Updated key to "result"
        if (results != null) {
          double totalWorkedHours = 0.0;
          for (var result in results) {
            DateTime checkInTime = DateTime.parse(result['check_in']);
            DateTime? checkOutTime;
            if (result['check_out'] != null) {
              checkOutTime = DateTime.parse(result['check_out']);
              if (checkInTime.isAfter(startDate) &&
                  checkOutTime.isBefore(endDate)) {
                totalWorkedHours +=
                    checkOutTime.difference(checkInTime).inHours.toDouble();
              }
            }
          }
          return totalWorkedHours;
        } else {
          throw Exception('Results are null');
        }
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

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);

      if (data != null &&
          data.containsKey('result') &&
          data['result'] is List<dynamic> &&
          data['result'].isNotEmpty) {
        return data['result'][0];
      }
    }
    throw Exception('Failed to load today data');
  }
}
