import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UpdateTable {
  final String baseUrl = 'https://ukkcafe.smktelkom-mlg.sch.id/api/table';
  final String makerID = '58';

  Future<bool> updateTable(int tableId, String tableNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    final url = Uri.parse('$baseUrl/$tableId');
    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "makerID": makerID,
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        'table_id': tableId,
        'table_number': tableNumber,
        'is_available': 'true',
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