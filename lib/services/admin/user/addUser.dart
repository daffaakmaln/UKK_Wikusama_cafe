import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterService {
  final String _baseUrl = 'https://ukkcafe.smktelkom-mlg.sch.id/api';

  Future<Map<String, dynamic>?> registerUser(String userName, String role, String username, String password) async {
    var headers = {
      'makerID': '58',
    };

    var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/register'));
    request.fields.addAll({
      'user_name': userName,
      'role': role,
      'username': username,
      'password': password,
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
  }
}
