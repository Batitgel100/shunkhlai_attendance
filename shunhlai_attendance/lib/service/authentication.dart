import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shunhlai_attendance/constant/app_url.dart';
import 'package:shunhlai_attendance/globals.dart';
import 'package:shunhlai_attendance/models/employe_data_entity.dart';

import '../utils/utils.dart';

class AuthService {
  Future<bool> login(
      String username, String password, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse(
            // '${AppUrl.baseUrl}/api/auth/get_tokens?username=ulzii-orshikh@medvic.mn&password=20231223'),
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
        final expiresInSeconds = jsonData['expires_in'];
        print('User ID: $userId');
        print('Access Token: $accessToken');
        Globals.changeUserId(userId);
        Globals.changeRegister(accessToken);
        Globals.changeTimer(expiresInSeconds);
        await getEmployeeData();
        // Perform other actions with the obtained data

        return true;
      } else {
        print(response.body);
        return false;
      }
    } catch (e) {
      Utils.flushBarErrorMessage(e.toString(), context);
      print(e);
      return false;
    }
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
    final Map<String, dynamic>? data = json.decode(response.body);

    if (data != null && data.containsKey('result')) {
      final List<dynamic> results = data['result'];

      if (results.isNotEmpty) {
        final String? employeeName = results[0]['name'];

        if (employeeName != null) {
          print('%%%%%$employeeName');

          Globals.changeUserName(employeeName);

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
