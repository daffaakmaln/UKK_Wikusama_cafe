// services/auth_service.dart
import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthService {
  final String _loginUrl = 'https://ukkcafe.smktelkom-mlg.sch.id/api/login';

  Future<Map<String, dynamic>?> login(String username, String password, String makerID) async {
    var headers = {
      'makerID': makerID,
    };
    
    var request = http.MultipartRequest('POST', Uri.parse(_loginUrl));
    request.fields.addAll({
      'username': username,
      'password': password,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200) {
      // String responseBody = await response.stream.bytesToString();
      // return responseBody as dynamic; // Return the success response
      final responseData = await http.Response.fromStream(response);
      return json.decode(responseData.body) as Map<String, dynamic>;

    } else {
      return null; // Handle error case
    }
  }
}
