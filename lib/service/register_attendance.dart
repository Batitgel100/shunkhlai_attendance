// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shunhlai_attendance/constant/app_url.dart';
import 'package:shunhlai_attendance/globals.dart';
import 'package:shunhlai_attendance/utils/utils.dart';

class RegisterAttendance {
  Future<void> _saveId(
    int id,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('stored_id', id); // Use setInt to save an integer value
  }

  Future<bool> register(String image, BuildContext context) async {
    try {
      var headers = {
        'Access-token': Globals.getRegister().toString(),
      };
      final response = await http.post(
          Uri.parse('${AppUrl.baseUrl}/api/hr.attendance'),
          body: {"image": image},
          headers: headers);

      if (response.statusCode == 200) {
        final responseBody = response.body;
        final jsonData = json.decode(responseBody);
        final regid = jsonData['id'];
        Globals.changeregid(regid);
        _saveId(regid);
        print(response.body);

        Utils.flushBarSuccessMessage('Амжилттай бүртгэгдлээ.', context);

        return true;
      } else {
        Utils.flushBarErrorMessage(
            'Ирсэн тэмдэглэгээ хийгдсэн байна.', context);
        return false;
      }
    } catch (e) {
      Utils.flushBarErrorMessage('Амжилтгүй.', context);
      print(e);
      return false;
    }
  }
}

class RegisterAttendanceLeft {
  Future<bool> register(String image, BuildContext context) async {
    DateTime dateTime = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss')
        .format(dateTime.add(const Duration(hours: -8)));

    try {
      var headers = {
        'Access-token': Globals.getRegister().toString(),
        'Content-Type': 'text/plain'
      };
      var request = http.Request(
          'PUT',
          Uri.parse(
              '${AppUrl.baseUrl}/api/hr.attendance/${Globals.getregid()}'));
      request.body = jsonEncode({
        "check_out": formattedDate,
        "image": image,
      });

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      // log(response.statusCode as String);
      if (response.statusCode == 200) {
        Utils.flushBarSuccessMessage('Амжилттай бүртгэгдлээ.', context);
        print(response.statusCode);
        print(request.body);

        return true;
      } else {
        print(response.statusCode);
        print(response.reasonPhrase);
        Utils.flushBarErrorMessage('Амжилтгүй.1', context);

        return false;
      }
    } catch (e) {
      Utils.flushBarErrorMessage('Амжилтгүй.2', context);
      return false;
    }
  }
}
