import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shunhlai_attendance/constant/app_url.dart';
import 'package:shunhlai_attendance/globals.dart';
import 'package:shunhlai_attendance/utils/utils.dart';

class StockIncomeUpdateApiClient {
  Future create(
      int moveId,
      String productName,
      int locationDestId,
      int companyId,
      int prodId,
      double qty,
      int prodLotId,
      int pickingId,
      int uomId,
      int locationId,
      BuildContext context) async {
    var headers = {
      'Access-token': Globals.getRegister().toString(),
      'Content-Type': 'text/plain',
    };

    var request = http.Request(
        'POST', Uri.parse('${AppUrl.baseUrl}/api/stock.move.line'));

    var requestBody = {
      "move_id": moveId,
      "location_id": locationId.toInt(),
      "location_dest_id": locationDestId,
      "company_id": companyId,
      "product_id": prodId,
      "lot_id": prodLotId,
      "state": "draft",
      "qty_done": qty,
      "picking_id": pickingId,
      "product_uom_id": uomId,
    };

    request.body = json.encode(requestBody);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Utils.flushBarSuccessMessage('Амжилттай нэмэгдлээ', context);

      print(await response.stream.bytesToString());
    } else {
      print(locationDestId.toString());
      print('Error: ${response.reasonPhrase}');
      Utils.flushBarErrorMessage('Алдаа заалаа', context);

      print(await response.stream.bytesToString());
    }
  }
}
