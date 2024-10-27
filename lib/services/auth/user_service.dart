import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final String _baseUrl = 'https://ukkcafe.smktelkom-mlg.sch.id/api';

  Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<List<dynamic>?> fetchUsers() async {
    String? accessToken = await getAccessToken();
    if (accessToken == null) return null;

    final response = await http.get(
      Uri.parse('$_baseUrl/user'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'makerID': '58',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Failed to load users: ${response.statusCode}');
      return null;
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('user_role');
    await prefs.remove('user_id');
  }
}
