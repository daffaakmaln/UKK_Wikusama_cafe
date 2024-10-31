import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ukk_kasir/pages/cashier/cashier_order.dart';
import 'package:ukk_kasir/pages/cashier/order_success.dart';
import 'package:ukk_kasir/services/allrole/getTable_available.dart';
import 'package:ukk_kasir/services/cashier/makeOrder.dart';
import 'package:ukk_kasir/style/styles.dart';

class DetailOrderPage extends StatefulWidget {
  final List<OrderItem> orderList;
  DetailOrderPage({required this.orderList});

  @override
  _DetailOrderPageState createState() => _DetailOrderPageState();
}

class _DetailOrderPageState extends State<DetailOrderPage> {
  final TextEditingController _customerNameController = TextEditingController();
  List<dynamic> _availableTables = [];
  String? username;
  String? userRole;
  int? userId;
  int? _selectedTableId;

  @override
  void initState() {
    super.initState();
    _fetchAvailableTables();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      userRole = prefs.getString('user_role');
      userId = prefs.getInt('user_id');
    });
  }

  Future<void> _fetchAvailableTables() async {
    try {
      final tables = await showTableAvailable();
      setState(() {
        _availableTables = tables;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch tables: $error")),
      );
    }
  }

  Future<void> _submitOrder() async {
  if (_selectedTableId == null || _customerNameController.text.isEmpty || userId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please select a table, enter customer name, and ensure user ID is set")),
    );
    return;
  }

  final List<Map<String, dynamic>> orderDetails = widget.orderList
      .map((orderItem) => {
            "menu_id": orderItem.item.id,
            "quantity": orderItem.quantity,
          })
      .toList();

  bool success = await makingOrder(
    userId: userId!,
    tableId: _selectedTableId!,
    customerName: _customerNameController.text,
    details: orderDetails,
  );

  if (success) {
    // Navigate to Order Success Page
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
      builder: (context) => OrderSuccessPage(
        userId: userId!,
        tableId: _selectedTableId!,
        customerName: _customerNameController.text,
        orderList: widget.orderList,
      ),
      ),
      (Route<dynamic> route) => false,
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Failed to place order")),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.themeColor,
        title: Text('Order Detail', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context, widget.orderList); // Pass updated list back
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _customerNameController,
              decoration: const InputDecoration(
                labelText: "Customer Name",
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: "Select Table",
              ),
              value: _selectedTableId,
              items: _availableTables.map<DropdownMenuItem<int>>((table) {
                return DropdownMenuItem<int>(
                  value: table['table_id'],
                  child: Text("No. ${table['table_number']}"),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTableId = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: widget.orderList.length,
                itemBuilder: (context, index) {
                  var orderItem = widget.orderList[index];
                  return ListTile(
                    title: Text(orderItem.item.name),
                    subtitle: Text('Quantity: ${orderItem.quantity}'),
                    trailing: Text('Rp. ${orderItem.item.price * orderItem.quantity}'),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Styles.themeColor,
                ),
                onPressed: _submitOrder,
                child: const Text("Submit Order", style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
