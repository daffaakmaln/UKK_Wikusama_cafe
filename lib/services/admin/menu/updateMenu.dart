// updateMenu.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> updateMenu(int menuId, String menuName, String type, int price, String description) async {
  const String baseUrl = 'https://ukkcafe.smktelkom-mlg.sch.id/api/menu';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('access_token');

  var headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
    'makerID': '58' // Adjust makerID if needed
  };

  var body = jsonEncode({
    'menu_name': menuName,
    'type': type,
    'price': price,
    'menu_description': description,
  });

  var response = await http.put(
    Uri.parse('$baseUrl/$menuId'),
    headers: headers,
    body: body,
  );

  if (response.statusCode == 200) {
    var responseData = jsonDecode(response.body);
    return responseData['status'] == 'success';
  } else {
    throw Exception('Failed to update menu: ${response.reasonPhrase}');
  }
}
