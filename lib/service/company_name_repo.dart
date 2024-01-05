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

      // Extract the "name" value
      final name = jsonResponse['results'][0]['name'];
      Globals.changeCompany(name);

      // print('Name: $name');
    } else {
      print(response.reasonPhrase);
    }
  }
}
