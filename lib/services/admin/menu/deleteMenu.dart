import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> deleteMenu(int menuId) async {
  const String baseUrl = 'https://ukkcafe.smktelkom-mlg.sch.id/api/menu';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('access_token');

  var headers = {
    'Authorization': 'Bearer $token',
    'makerID': '58' // Sesuaikan dengan ID maker jika diperlukan
  };

  var response = await http.delete(
    Uri.parse('$baseUrl/$menuId'),
    headers: headers,
  );

  if (response.statusCode == 200) {
    var responseData = jsonDecode(response.body);
    return responseData['status'] == 'success';
  } else {
    throw Exception('Failed to delete menu: ${response.reasonPhrase}');
  }
}
