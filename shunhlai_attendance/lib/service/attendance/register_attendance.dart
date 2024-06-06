// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shunhlai_attendance/constant/app_url.dart';
import 'package:shunhlai_attendance/globals.dart';
import 'package:shunhlai_attendance/models/attendance_entity.dart';
import 'package:shunhlai_attendance/service/attendance/attendance_today.dart';
import 'package:shunhlai_attendance/utils/utils.dart';

class RegisterAttendance {
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
  List<AttendanceEnity> box = [];
  AttendanceToday today = AttendanceToday();

  Future<bool> register(String image, BuildContext context) async {
    final data = await today.fetchData();

    if (data.isEmpty) {
      Utils.flushBarErrorMessage('Ирсэн бүртгэл байхгүй байна', context);
      return false;
    }

    box = data;

    if (box.isNotEmpty) {
      final todayId = box[0].id;

      DateTime dateTime = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss')
          .format(dateTime.add(const Duration(hours: -8)));

      try {
        var headers = {
          'Access-token': Globals.getRegister().toString(),
          'Content-Type': 'text/plain'
        };
        var request = http.Request(
            'PUT', Uri.parse('${AppUrl.baseUrl}/api/hr.attendance/$todayId'));
        request.body = jsonEncode({
          "check_out": formattedDate,
          // "image": image,
        });

        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          Utils.flushBarSuccessMessage('Амжилттай бүртгэгдлээ.', context);
          print(response.statusCode);

          return true;
        } else {
          print(request.body);
          print(response.statusCode);

          Utils.flushBarErrorMessage('Амжилтгүй.1', context);
          return false;
        }
      } catch (e) {
        Utils.flushBarErrorMessage('Амжилтгүй.2', context);
        return false;
      }
    } else {
      Utils.flushBarErrorMessage('Ирсэн бүртгэл байхгүй байна', context);
      return false;
    }
  }
}
