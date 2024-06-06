import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shunhlai_attendance/constant/app_url.dart';
import 'package:shunhlai_attendance/globals.dart';

class HrLeaveTypeApiClient {
  Future<List<Temperatures>> fetchData() async {
    final Map<String, String> headers = {
      'Access-token': Globals.getRegister().toString(),
    };
    final response = await http.get(
      Uri.parse('${AppUrl.baseUrl}/api/hr.leave.type'),
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

      return resultsData.map((json) => Temperatures.fromJson(json)).toList();
    } else {
      print('Failed to load data. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load data');
    }
  }
}

Temperatures temperaturesFromJson(String str) =>
    Temperatures.fromJson(json.decode(str));

String temperaturesToJson(Temperatures data) => json.encode(data.toJson());

class Temperatures {
  int id;
  String? name;
  String? requestUnit;

  Temperatures({
    required this.id,
    required this.name,
    required this.requestUnit,
  });

  factory Temperatures.fromJson(Map<String, dynamic> json) => Temperatures(
        id: json["id"],
        name: json["name"],
        requestUnit: json["request_unit"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "request_unit": requestUnit,
      };
}
