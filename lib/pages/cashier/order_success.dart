import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:ukk_kasir/pages/cashier/cashier_order.dart';
import 'package:ukk_kasir/style/styles.dart';

class OrderSuccessPage extends StatelessWidget {
  final int userId;
  final int tableId;
  final String customerName;
  final List<OrderItem> orderList;

  OrderSuccessPage({
    required this.userId,
    required this.tableId,
    required this.customerName,
    required this.orderList,
  });

  double _calculateTotalPrice() {
    double total = 0;
    for (var order in orderList) {
      total += order.item.price * order.quantity;
    }
    return total;
  }

  Future<void> _generateAndPrintPdf(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          children: [
            pw.Text('Cafe Wikusamaa Coffee',
                style:
                    pw.TextStyle(fontSize: 26, fontWeight: pw.FontWeight.bold)),
            pw.Text('Jl. Danau Ranau No. 1 Sawojajar, Malang Regency, East Java - Indonesia'),
            pw.Text('----------------------------------------------------------------------'),
            pw.SizedBox(height: 20),
            pw.Text('Pesanan:',
                style:
                    pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text('User ID: $userId'),
            pw.Text('Table ID: $tableId'),
            pw.Text('Customer: $customerName'),
            pw.SizedBox(height: 10),
            pw.TableHelper.fromTextArray(
              headers: ['Menu', 'Jumlah', 'Harga'],
              data: orderList.map((orderItem) {
                return [
                  orderItem.item.name,
                  orderItem.quantity.toString(),
                  'Rp. ${orderItem.item.price * orderItem.quantity}',
                ];
              }).toList(),
            ),
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Total',
                    style: pw.TextStyle(
                        fontSize: 16, fontWeight: pw.FontWeight.bold)),
                pw.Text('Rp. ${_calculateTotalPrice()}',
                    style: pw.TextStyle(
                        fontSize: 16, fontWeight: pw.FontWeight.bold)),
              ],
            ),
            pw.Text('Thank you for ordering!',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          ],
        ),
      ),
    );

    // Print the PDF
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Order Success', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      backgroundColor: Styles.themeColor,
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              'assets/images/success.png',
              width: 150, // Sesuaikan ukuran ikon jika diperlukan
              height: 150,
            ),
          ),
          const SizedBox(height: 16), // Spasi antara gambar dan teks
          Text("User ID: $userId", style: const TextStyle(fontSize: 18)),
          Text("Table ID: $tableId", style: const TextStyle(fontSize: 18)),
          Text("Customer Name: $customerName", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Text("Order Details:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Expanded(
            child: ListView.builder(
              itemCount: orderList.length,
              itemBuilder: (context, index) {
              var orderItem = orderList[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text(
                      orderItem.item.name,
                      style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Quantity: ${orderItem.quantity}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    ],
                  ),
                  Text(
                    'Rp. ${orderItem.item.price * orderItem.quantity}',
                    style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    ),
                  ),
                  ],
                ),
                ),
              );
              },
            ),
            ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Price:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('Rp. ${_calculateTotalPrice()}', style: const TextStyle(fontSize: 18)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _generateAndPrintPdf(context),
              child: const Text("Cetak Struk (.pdf)", style: TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MenuPage()),
                  (Route<dynamic> route) => false, // Menghapus semua rute sebelumnya
                );
              },
              child: const Text("Kembali ke Menu Utama", style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    ),
  );
}

}
