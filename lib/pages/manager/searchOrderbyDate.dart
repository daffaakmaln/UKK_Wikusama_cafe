import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ukk_kasir/services/manager/showOrderbyDate.dart';
import 'package:ukk_kasir/style/styles.dart';

class OrderByDatePage extends StatefulWidget {
  @override
  _OrderByDatePageState createState() => _OrderByDatePageState();
}

class _OrderByDatePageState extends State<OrderByDatePage> {
  DateTime? _selectedDate;
  List<dynamic> _searchResults = [];
  bool _isLoading = false;

  // Function to select a date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Function to search orders by the selected date
  Future<void> _searchOrders() async {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a date")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _searchResults = [];
    });

    try {
      String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      List<dynamic> results = await searchOrderByDate(formattedDate);

      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch orders: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Orders by Date',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Styles.themeColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose Date',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDate == null
                          ? 'No date chosen!'
                          : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                      style: TextStyle(fontSize: 16),
                    ),
                    Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Styles.themeColor),
                onPressed: _searchOrders,
                child: _isLoading
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text("Search Orders", style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _searchResults.isEmpty
                  ? Center(
                      child: Text('No orders found for this date.'),
                    )
                  : ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                var order = _searchResults[index];
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10, horizontal: 15),
                  leading: CircleAvatar(
                    child: Text(order['customer_name'][0]),
                  ),
                  title: Text(
                    "Customer: ${order['customer_name']}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text("Table No: ${order['table_number']}"),
                    if (order['status'] == 'pending')
                      Text("Belum Lunas", style: TextStyle(color: Colors.red)),
                    if (order['status'] == 'paid')
                      Text("Lunas", style: TextStyle(color: Colors.green)),
                    ],
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                  ),
                );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
