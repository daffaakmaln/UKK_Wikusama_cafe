import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<List<dynamic>> showTableAvailable() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('access_token');

  var headers = {
    'Authorization': 'Bearer $token',
    'makerID': '58' // Adjust makerID as needed
  };

  var request = http.Request('GET', Uri.parse('https://ukkcafe.smktelkom-mlg.sch.id/api/table/available'));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var responseData = await response.stream.bytesToString();
    return json.decode(responseData); // Return the parsed data
  } else {
    throw Exception("Error: ${response.reasonPhrase}");
  }
}
