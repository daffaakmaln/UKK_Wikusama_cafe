import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Order Model to represent each order item
class Order {
  final int orderId;
  final String orderDate;
  final int userId;
  final int tableId;
  final String customerName;
  final String status;
  final int makerId;
  final String createdAt;
  final String updatedAt;
  final String tableNumber;
  final bool isAvailable;
  final String userName;
  final String role;
  final String username;

  Order({
    required this.orderId,
    required this.orderDate,
    required this.userId,
    required this.tableId,
    required this.customerName,
    required this.status,
    required this.makerId,
    required this.createdAt,
    required this.updatedAt,
    required this.tableNumber,
    required this.isAvailable,
    required this.userName,
    required this.role,
    required this.username,
  });

  // Factory constructor to create Order object from JSON
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['order_id'],
      orderDate: json['order_date'],
      userId: json['user_id'],
      tableId: json['table_id'],
      customerName: json['customer_name'],
      status: json['status'],
      makerId: json['maker_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      tableNumber: json['table_number'],
      isAvailable: json['is_available'] == "true",
      userName: json['user_name'],
      role: json['role'],
      username: json['username'],
    );
  }
}

// DashboardManager class to handle fetching and processing orders
class DashboardManager {
  final String baseUrl = 'https://ukkcafe.smktelkom-mlg.sch.id/api/order';

  // Fetch orders and return a list of Order objects
  Future<List<Order>> fetchOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    String makerId = '58';

    var headers = {
      'Content-Type': 'application/json',
      'makerID': makerId,
      'Authorization': 'Bearer $token',
    };

    try {
      var response = await http.get(Uri.parse(baseUrl), headers: headers);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        List<dynamic> orderData = responseData['data'];

        // Convert JSON data to List<Order>
        return orderData.map((json) => Order.fromJson(json)).toList();
      } else {
        throw Exception("Failed to fetch orders: ${response.reasonPhrase}");
      }
    } catch (error) {
      throw Exception("Error occurred: $error");
    }
  }
}
