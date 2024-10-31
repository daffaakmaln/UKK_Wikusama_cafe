import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<List<dynamic>> showOrderByUserId(int userId) async {
  const String baseUrl = 'https://ukkcafe.smktelkom-mlg.sch.id/api/order';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('access_token');
  String? makerId = '58'; // Set makerID or retrieve from SharedPreferences if needed

  var headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
    'makerID': makerId,
  };

  var request = http.Request('GET', Uri.parse('$baseUrl/$userId'));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var responseData = await response.stream.bytesToString();
    return json.decode(responseData)['data']; // Returns the 'data' array with order details
  } else {
    throw Exception("Failed to load orders: ${response.reasonPhrase}");
  }
}
