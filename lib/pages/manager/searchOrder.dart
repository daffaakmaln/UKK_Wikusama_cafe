import 'package:flutter/material.dart';
import 'package:ukk_kasir/services/manager/showOrder.dart';
import 'package:ukk_kasir/services/manager/showOrderBySearch.dart';
import 'package:ukk_kasir/style/styles.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchOrder searchOrder = SearchOrder();
  final TextEditingController _searchController = TextEditingController();
  List<Order>? searchResults;

  void _searchOrders() async {
    String searchKey = _searchController.text;
    try {
      List<Order> results = await searchOrder.searchOrder(searchKey);
      setState(() {
        searchResults = results;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Orders',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Styles.themeColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Search Order",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchOrders,
                ),
              ),
            ),
            Expanded(
              child: searchResults == null
                  ? Center(child: Text("No search results"))
                  : ListView.builder(
                      itemCount: searchResults!.length,
                      itemBuilder: (context, index) {
                        var order = searchResults![index];
                        return Card(
                          elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10, horizontal: 15),
                  leading: CircleAvatar(
                    child: Text(order.customerName[0]),
                  ),
                          title: Text(
                            "Order #${order.orderId} - ${order.customerName}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Text("Table No. ${order.tableNumber}"),
                            Text("Status: ${order.status}"),
                              if (order.status == 'pending')
                                Text("Belum Lunas",
                                    style: TextStyle(color: Colors.red)),
                              if (order.status == 'paid')
                                Text("Lunas",
                                    style: TextStyle(color: Colors.green)),
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
