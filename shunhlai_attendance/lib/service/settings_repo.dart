import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shunhlai_attendance/constant/app_url.dart';
import 'package:shunhlai_attendance/globals.dart';
import 'package:shunhlai_attendance/models/employe_data_entity.dart';

class EmployeDataApiClient {
  Future<EmployeeDataEntity?> getEmployeeData() async {
    var headers = {'Access-token': Globals.getRegister().toString()};
    var response = await http.get(
      Uri.parse(
          '${AppUrl.baseUrl}/api/hr.employee.public?filters=[["user_id", "=", ${Globals.getUserId()}]]'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic>? data = json.decode(response.body);

      if (data != null && data.containsKey('result')) {
        final List<dynamic> results = data['result'];

        if (results.isNotEmpty) {
          final String? employeeName = results[0]['name'];

          if (employeeName != null) {
            print('%%%%%$employeeName');
            final int id = results[0]['id'];
            final int companyId = results[0]['company_id'];
            Globals.changeEmployeeId(id);
            Globals.changeCompanyId(companyId);

            return EmployeeDataEntity.fromJson(results[0]);
          } else {
            // Handle the case when 'name' is null
            return null;
          }
        } else {
          return null;
        }
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to load employee data');
    }
  }
}
