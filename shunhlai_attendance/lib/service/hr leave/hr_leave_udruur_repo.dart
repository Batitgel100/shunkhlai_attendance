// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shunhlai_attendance/constant/app_url.dart';
import 'package:shunhlai_attendance/globals.dart';

class HrLeaveUdruur {
  Future create(
      int departmentId,
      int employeeId,
      int holidayStatusId,
      String holidayType,
      String name,
      String datefrom,
      String dateto,
      String state,
      double duration) async {
    var headers = {
      'Access-token': Globals.getRegister().toString(),
      'Content-Type': 'text/plain',
    };

    var request =
        http.Request('POST', Uri.parse('${AppUrl.baseUrl}/api/hr.leave'));

    var requestBody = {
      "department_id": departmentId,
      "employee_id": employeeId,
      "holiday_status_id": holidayStatusId,
      "holiday_type": holidayType,
      "name": name,
      "request_date_from": datefrom,
      "request_date_to": dateto, "date_from": '$datefrom 09:00:00',
      "date_to": '$dateto 09:00:00',
      "company_id": Globals.getCompanyId(),
      // "number_of_days ": duration,
      "state": state
    };
    print(
      '$datefrom 09:00:00',
    );
    request.body = json.encode(requestBody);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(' %&#%&#%&#%&#${Globals.getCompanyId()}');
      // Utils.flushBarSuccessMessage('Амжилттай нэмэгдлээ', context);

      print(await response.stream.bytesToString());
    } else {
      print('Error: ${response.reasonPhrase}');
      print(await response.stream.bytesToString());
    }
  }
}

class HrLeaveTsagaar {
  Future create(
      String name,
      int employeeId,
      int departmentId,
      String hourfrom,
      String hourto,
      bool unit,
      int holidayStatusId,
      String datefrom,
      String dateto,
      String holidayType,
      String state,
      double duration) async {
    var headers = {
      'Access-token': Globals.getRegister().toString(),
      'Content-Type': 'text/plain',
    };

    var request =
        http.Request('POST', Uri.parse('${AppUrl.baseUrl}/api/hr.leave'));

    var requestBody = {
      "name": name,
      "employee_id": employeeId,
      "company_id": Globals.getCompanyId(),
      "department_id": departmentId,
      "request_hour_from": hourfrom,
      "request_hour_to": hourto,
      "request_unit_hours": unit,
      "holiday_status_id": holidayStatusId,
      "date_from": '$datefrom 09:00:00',
      "date_to": '$dateto 09:00:00',
      "number_of_hours_display": duration,
      "holiday_type": holidayType,
      "state": "confirm"
    };
    print(Globals.getCompanyId());

    request.body = json.encode(requestBody);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print(Globals.companyId);
    print(Globals.register);
    if (response.statusCode == 200) {
      // Utils.flushBarSuccessMessage('Амжилттай нэмэгдлээ', context);

      print(await response.stream.bytesToString());
    } else {
      print('Error: ${response.reasonPhrase}');
      print(await response.stream.bytesToString());
    }
  }
}
