import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddTable {
  final String _baseUrl = 'https://ukkcafe.smktelkom-mlg.sch.id/api';

  Future<Map<String, dynamic>?> addTable(String tableNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    try {
      var headers = {
        'Authorization': 'Bearer $token',
        'makerID': '58',
      };

      var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/table'));
      request.fields.addAll({
        'table_number': tableNumber,
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        return json.decode(responseData.body) as Map<String, dynamic>;
      } else {
        print('Registration failed: ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('Error occurred: $e');
      return null; // Return null if any exception occurs
    }
  }
}
