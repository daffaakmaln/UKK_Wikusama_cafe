import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> showUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('access_token');
  
  var headers = {
    'Authorization': 'Bearer $token', // Menyertakan token otorisasi
    'makerID': '58'   // Gantilah makerID sesuai kebutuhan
  };
  
  var request = http.Request('GET', Uri.parse('https://ukkcafe.smktelkom-mlg.sch.id/api/user')); // Pastikan URL lengkap
  
  request.headers.addAll(headers);
  
  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var responseData = await response.stream.bytesToString();
    print(json.decode(responseData)); // Proses respons sesuai kebutuhan
  } else {
    print("Error: ${response.reasonPhrase}");
  }
}
