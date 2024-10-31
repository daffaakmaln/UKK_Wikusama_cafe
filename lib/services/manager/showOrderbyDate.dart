import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<List<dynamic>> searchOrderByDate(String date) async {
  const String baseUrl = 'https://ukkcafe.smktelkom-mlg.sch.id/api';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('access_token');
  String makerId = '58';

  var headers = {
    'Content-Type': 'application/json',
    'makerID': makerId,
    'Authorization': 'Bearer $token',
  };

  // Complete the URL with the given date
  var requestUrl = Uri.parse('$baseUrl/order/searchbydate/$date');

  var response = await http.get(requestUrl, headers: headers);

  if (response.statusCode == 200) {
    // Parse the response body
    var responseData = json.decode(response.body);
    if (responseData['status'] == 'success') {
      return responseData['data'];
    } else {
      throw Exception("Error: ${responseData['message']}");
    }
  } else {
    throw Exception("Error: ${response.reasonPhrase}");
  }
}
