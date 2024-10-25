import 'package:flutter/material.dart';
import 'package:ukk_kasir/data/model_data.dart';
import 'package:ukk_kasir/style/styles.dart';

class OrderItem {
  final MenuItem item;
  final int quantity;
  final String description;

  OrderItem({
    required this.item,
    required this.quantity,
    required this.description,
  });
}

class OrderPage extends StatefulWidget {
  final List<OrderItem> orderList;
  final Function(int) onDelete;
  final Function() onRefresh;

  OrderPage(
      {required this.orderList,
      required this.onDelete,
      required this.onRefresh});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  //function calculate
  int _calculateTotalPrice(List<OrderItem> orderList) {
    int totalPrice = 0;
    for (var item in orderList) {
      totalPrice += item.item.price * item.quantity;
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, // Ganti warna arrow di sini
          ),
          title: Text(
            'Checklist Order',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Styles.themeColor // Warna AppBar
          ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Flexible(
              child: widget.orderList.isEmpty // Kondisi jika pesanan kosong
                  ? Center(
                      child: Text(
                        "Oops, Belum Ada Pesanan!\n       Pesankan dulu le :v",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: widget.orderList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 5, // Memberi bayangan pada card
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                // Bagian gambar produk
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      20), // Membuat gambar lebih rounded
                                  child: Image.asset(
                                    widget.orderList[index].item.imageUrl,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(
                                    width: 10), // Spasi antara gambar dan teks

                                // Bagian teks
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.orderList[index].item.name,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Quantity: ${widget.orderList[index].quantity}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Description: ${widget.orderList[index].description}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey[900],
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'IDR. ${widget.orderList[index].item.price * widget.orderList[index].quantity}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green[500],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Bagian tombol delete
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Konfirmasi Hapus"),
                                          content: Text(
                                              "Apakah anda ingin menghapus pesanan ini?"),
                                          actions: [
                                            TextButton(
                                              child: Text("Tidak"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text("Ya"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                widget.onDelete(index);
                                                widget.onRefresh();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            if (widget.orderList.isNotEmpty) // Hanya tampilkan jika ada pesanan
              Container(
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Styles.themeColor,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Pesanan:",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          "IDR. ${_calculateTotalPrice(widget.orderList)}",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.lime),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Styles.themeColor, // Warna background tombol
                          foregroundColor: Colors.white, // Warna teks tombol
                          side: const BorderSide(
                              color: Colors
                                  .white), // Membuat border putih pada tombol
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8), // Membuat sudut border lebih melengkung
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          "Order ->",
                          style: TextStyle(fontSize: 18),
                        ))
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
