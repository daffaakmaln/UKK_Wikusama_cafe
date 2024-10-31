import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> addMenu({
  required String menuName,
  required String type,
  required String menuDescription,
  required int price,
  required String imagePath,
}) async {
  const String baseUrl = 'https://ukkcafe.smktelkom-mlg.sch.id/api/menu';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('access_token');

  var headers = {
    'Authorization': 'Bearer $token',
    'makerID': '58', // Adjust makerID as needed
  };

  var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
  request.fields.addAll({
    'menu_name': menuName,
    'type': type,
    'menu_description': menuDescription,
    'price': price.toString(),
  });
  request.files.add(await http.MultipartFile.fromPath('menu_image_name', imagePath));
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var responseData = await response.stream.bytesToString();
    var jsonResponse = jsonDecode(responseData);
    print(response.reasonPhrase);
    print(response.statusCode);
    return jsonResponse['status'] == 'success';
  } else {
    print('Failed to add menu: ${response.reasonPhrase}');
    return false;
  }
}
