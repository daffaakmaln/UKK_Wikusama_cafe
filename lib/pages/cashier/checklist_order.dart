import 'package:flutter/material.dart';
import 'package:ukk_kasir/pages/cashier/detail_order.dart';
import 'package:ukk_kasir/style/styles.dart';
import 'package:ukk_kasir/pages/cashier/cashier_order.dart'; // Assuming this is the file where OrderItem and MenuItem are defined

class CheckListOrderPage extends StatefulWidget {
  final List<OrderItem> orderList;
  CheckListOrderPage({required this.orderList});

  @override
  _CheckListOrderPageState createState() => _CheckListOrderPageState();
}

class _CheckListOrderPageState extends State<CheckListOrderPage> {
  double _calculateTotalPrice() {
    double total = 0;
    for (var order in widget.orderList) {
      total += order.item.price * order.quantity;
    }
    return total;
  }

  void _deleteOrderItem(int index) {
    setState(() {
      widget.orderList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.themeColor,
        title: Text('Order Checklist', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context, widget.orderList); // Pass updated list back
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: widget.orderList.isEmpty
                ? const Center(
                    child: Text(
                      "    Tidak ada Order\nPesankan dulu le . . .",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )
                : ListView.builder(
                    itemCount: widget.orderList.length,
                    itemBuilder: (context, index) {
                      var orderItem = widget.orderList[index];
                      return ListTile(
                        leading: Image.network(orderItem.item.imageUrl),
                        title: Text("${orderItem.item.name} (ID ${orderItem.item.id})"),
                        subtitle: Text('Quantity: ${orderItem.quantity}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Rp. ${orderItem.item.price * orderItem.quantity}',
                              style: TextStyle(fontSize: 16),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _deleteOrderItem(index);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          if (widget.orderList.isNotEmpty)
            Container(
              color: Styles.themeColor,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Price:',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          'IDR. ${_calculateTotalPrice().toStringAsFixed(0)}',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailOrderPage(
                              orderList: widget.orderList,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Make Order',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
