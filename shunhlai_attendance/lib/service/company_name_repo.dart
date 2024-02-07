import 'package:http/http.dart' as http;
import 'package:shunhlai_attendance/constant/app_url.dart';
import 'dart:convert';

import 'package:shunhlai_attendance/globals.dart';

class CompanyNameRepository {
  Future<void> getCompanyName() async {
    var headers = {'Access-token': Globals.getRegister().toString()};
    var request =
        http.Request('GET', Uri.parse('${AppUrl.baseUrl}/api/res.company'));
    request.bodyFields = {};
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // Decode the JSON response
      final responseString = await response.stream.bytesToString();
      final Map<String, dynamic> jsonResponse = json.decode(responseString);

      // Check if 'result' key exists and is not null
      if (jsonResponse.containsKey('result') &&
          jsonResponse['result'] != null) {
        // Check if the result array is not empty
        final resultArray = jsonResponse['result'];
        if (resultArray.isNotEmpty) {
          // Extract the "name" value from the first result
          final name = resultArray[0]['name'];

          // Assuming Globals.changeCompany is a function to update the company name
          Globals.changeCompany(name);

          // Uncomment the line below if you want to print the company name
          // print('Name: $name');
        } else {
          // Handle the case where the result array is empty
          // You may want to log a message or throw an error based on your requirements
        }
      } else {
        // Handle the case where 'result' key is missing or null
        // You may want to log a message or throw an error based on your requirements
      }
    } else {
      // Handle error when the response status code is not 200
      // print('company ${response.reasonPhrase}');
    }
  }
}
