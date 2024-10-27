import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

    if (response.statusCode == 200) {
      final responseData = await http.Response.fromStream(response);
      Map<String, dynamic> data = json.decode(responseData.body);
      
      // Simpan access_token ke SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', data['access_token']);
      await prefs.setInt('user_id', data['user']['user_id']);
      await prefs.setString('user_role', data['user']['role']);
      
      return data;
    } else {
      return null; // Handle error case
    }
  }
}
