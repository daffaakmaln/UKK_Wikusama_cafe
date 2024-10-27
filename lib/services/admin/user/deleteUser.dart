import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DeleteUserService {
  final String baseUrl = 'https://ukkcafe.smktelkom-mlg.sch.id/api/user';
  final String makerID = '58';
  
  Future<bool> deleteUser(int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    // Periksa apakah token tersedia
    if (token == null) {
      print('Error: No access token found.');
      return false;
    }

    final url = Uri.parse('$baseUrl/$userId');
    final response = await http.delete(
      url,
      headers: {
        "makerID": makerID,
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      print('User successfully deleted.');
      return true;
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      return false;
    }
  }
}
