import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DeleteTable {
  final String baseUrl = 'https://ukkcafe.smktelkom-mlg.sch.id/api/table';
  final String makerID = '58';
  
  Future<bool> deleteTable(int tableId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    // Periksa apakah token tersedia
    if (token == null) {
      print('Error: No access token found.');
      return false;
    }

    final url = Uri.parse('$baseUrl/$tableId');
    final response = await http.delete(
      url,
      headers: {
        "makerID": makerID,
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      print('Table successfully deleted.');
      return true;
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      return false;
    }
  }
}
