import 'package:flutter/material.dart';

class OrderDetail extends StatelessWidget {
  final String orderId;

  OrderDetail({required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ID: $orderId',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Order Items:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // Add your order items here
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Replace with the actual number of items
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Item ${index + 1}'),
                    subtitle: Text('Item description'),
                    trailing: Text('\$10.00'), // Replace with actual price
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Total: \$50.00', // Replace with actual total
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}