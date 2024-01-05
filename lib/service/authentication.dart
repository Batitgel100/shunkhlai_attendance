import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shunhlai_attendance/constant/app_url.dart';
import 'package:shunhlai_attendance/globals.dart';
import 'package:shunhlai_attendance/models/employe_data_entity.dart';

class AuthService {
  Future<bool> login(
      String username, String password, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse(
            '${AppUrl.baseUrl}/api/auth/get_tokens?username=$username&password=$password'),
        body: {
          'username': username,
          'password': password,
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        final responseBody = response.body;
        final jsonData = json.decode(responseBody);
        final userId = jsonData['uid'];
        final accessToken = jsonData['access_token'];
        final lat = jsonData['longitude'];
        final long = jsonData['latitude'];
        final timer = jsonData['expires_in'];
        final emplId = jsonData['employee_id'];
        final deparId = jsonData['department_id'];
        Globals.changeEmployeeId(emplId);
        Globals.changeDepartmentId(deparId);

        Globals.changeUserId(userId);
        Globals.changebaseUrl('ivco.mn');
        Globals.changeRegister(accessToken);
        Globals.changelat(lat);
        Globals.changelong(long);
        Globals.changeTimer(timer);
        await getEmployeeData();
        if (jsonData['mobile_stock_user'] == true) {
          Globals.changeIsStockUser(true);
        }
        if (jsonData['mobile_stock_admin'] == true) {
          Globals.changeIsStockAdmin(true);
        }
        print('${Globals.getlat()},${Globals.getlong()}');

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<EmployeeDataEntity?> getEmployeeData() async {
    var headers = {'Access-token': Globals.getRegister().toString()};
    var response = await http.get(
      Uri.parse(
          '${AppUrl.baseUrl}/api/hr.employee.public?filters=[["user_id", "=", ${Globals.getUserId()}]]'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      final String name = results[0]['name'];

      Globals.changeUserName(name);
      // log('company id: ${Globals.companyId}');
    }
    return null;
  }
}
