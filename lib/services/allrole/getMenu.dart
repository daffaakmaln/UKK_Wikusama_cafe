import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, dynamic>> getMenu() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('access_token');

  var headers = {
    'Authorization': 'Bearer $token',
    'makerID': '58' // Adjust makerID as needed
  };

  var request = http.Request('GET', Uri.parse('https://ukkcafe.smktelkom-mlg.sch.id/api/menu'));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var responseData = await response.stream.bytesToString();
    var jsonResponse = json.decode(responseData);

    // Return the entire JSON response as a map, keeping all fields
    return {
      "status": jsonResponse["status"],
      "message": jsonResponse["message"],
      "data": jsonResponse["data"]
    };
  } else {
    throw Exception("Error: ${response.reasonPhrase}");
  }
}
