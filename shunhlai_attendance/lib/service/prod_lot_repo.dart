import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shunhlai_attendance/constant/app_url.dart';
import 'package:shunhlai_attendance/globals.dart';
import 'package:shunhlai_attendance/models/prod_lot_entity.dart';

class ProdLotApiClient {
  Future<List<ProdLotEntity>> fetchData() async {
    final Map<String, String> headers = {
      'Access-token': Globals.getRegister().toString(),
    };
    final response = await http.get(
      Uri.parse('${AppUrl.baseUrl}/api/stock.production.lot'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List<dynamic> resultsData = jsonData['results'];
      return resultsData.map((json) => ProdLotEntity.fromJson(json)).toList();
    } else {
      print('Failed to load data. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load data');
    }
  }
}

class ProdLotApiClient1 {
  Future<List<ProdLotEntity>> fetchData(int productId) async {
    final Map<String, String> headers = {
      'Access-token': Globals.getRegister().toString(),
    };
    final response = await http.get(
      Uri.parse('${AppUrl.baseUrl}/api/stock.production.lot'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List<dynamic> resultsData = jsonData['results'];

      // Filter the list to include only items with product_id 17900
      final filteredData =
          resultsData.where((json) => json['product_id'] == productId).toList();

      return filteredData.map((json) => ProdLotEntity.fromJson(json)).toList();
    } else {
      print('Failed to load data. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load data');
    }
  }
}
