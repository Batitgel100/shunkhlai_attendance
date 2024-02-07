// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shunhlai_attendance/constant/app_url.dart';
import 'package:shunhlai_attendance/globals.dart';
import 'package:shunhlai_attendance/models/hr_leave_entity.dart';

class HrLeaveListApiClient {
  Future<List<HrLeaveEntity>> fetchData() async {
    final Map<String, String> headers = {
      'Access-token': Globals.getRegister().toString(),
    };
    final response = await http.get(
      Uri.parse(
          '${AppUrl.baseUrl}/api/hr.leave?filters=[("employee_id","=",${Globals.getEmployeeId()})]'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List<dynamic>? resultsData = jsonData['result']; // Updated key

      if (resultsData == null) {
        // Handle the case where 'result' key is null
        print('Result list is null');
        return []; // Or another appropriate value to indicate an error
      }

      return resultsData.map((json) => HrLeaveEntity.fromJson(json)).toList();
    } else {
      print('Failed to load data. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load data');
    }
  }
}
