import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> makingOrder({
  required int userId,
  required int tableId,
  required String customerName,
  required List<Map<String, dynamic>> details,
}) async {
  const String baseUrl = 'https://ukkcafe.smktelkom-mlg.sch.id/api/order';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String makerId = '58';

  var headers = {
    'Content-Type': 'application/json',
    'makerID': makerId,
    'Authorization': 'Bearer ${prefs.getString('access_token')}',
  };

  var body = jsonEncode({
    "user_id": userId,
    "table_id": tableId,
    "customer_name": customerName,
    "detail": details,
  });

  try {
    var response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      if (responseData['status'] == 'success') {
        print('Order success: ${responseData['data']}');
        return true;
      } else {
        print('Order failed: ${responseData['message']}');
        return false;
      }
    } else {
      print('Failed to make order: ${response.reasonPhrase}');
      print('Response body: ${response.body}');
      return false;
    }
  } catch (error) {
    print('Error making order: $error');
    return false;
  }
}

