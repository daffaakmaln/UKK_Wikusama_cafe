import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ukk_kasir/services/manager/showOrder.dart';

class SearchOrder {
  final String baseUrl = 'https://ukkcafe.smktelkom-mlg.sch.id/api';

  // Search for orders based on a search key
  Future<List<Order>> searchOrder(String searchKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    String makerId = '58';

    // Headers setup
    var headers = {
      'Content-Type': 'application/json',
      'makerID': makerId,
      'Authorization': 'Bearer $token',  // Check no extra spaces here
    };

    // URL setup, including encoding of search key
    var url = Uri.parse('$baseUrl/order/search/${Uri.encodeComponent(searchKey)}');

    try {
      // GET request
      var response = await http.get(url, headers: headers);

      // Check if the response status is successful
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        List<dynamic> orderData = responseData['data'];

        // Convert each item in the data list to an Order object
        return orderData.map((json) => Order.fromJson(json)).toList();
      } else {
        // Improved error message to include response body
        throw Exception("Failed to search orders: ${response.reasonPhrase}, ${response.body}");
      }
    } catch (error) {
      throw Exception("Error occurred: $error");
    }
  }
}
