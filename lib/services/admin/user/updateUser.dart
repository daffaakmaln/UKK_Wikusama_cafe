import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UpdateUserService {
  final String baseUrl = 'https://ukkcafe.smktelkom-mlg.sch.id/api/user';
  final String makerID = '58';

  Future<bool> updateUser(int userId, String userName, String role, String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    final url = Uri.parse('$baseUrl/$userId');
    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "makerID": makerID,
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        'user_name': userName,
        'role': role,
        'username': username,
      }),
    );

    if (response.statusCode == 200) {
      return true; // Berhasil update
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      return false; // Gagal update
    }
  }
}