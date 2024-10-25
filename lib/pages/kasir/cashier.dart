import 'package:flutter/material.dart';
import 'package:ukk_kasir/data/model_data.dart';
import 'package:ukk_kasir/pages/kasir/checklist.dart';
import 'package:ukk_kasir/pages/login/login.dart';
import 'package:ukk_kasir/style/styles.dart';
import 'package:ukk_kasir/utils/popup.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<OrderItem> _orderList = []; // List untuk menyimpan pesanan

  // Fungsi untuk menambahkan item ke daftar pesanan
  void _addItemToOrder(MenuItem item, int quantity, String desc) {
    setState(() {
      _orderList
          .add(OrderItem(item: item, quantity: quantity, description: desc));
    });
  }

  // Fungsi untuk menambahkan deskripsi ke item
  void _addItemDescription(MenuItem item, String desc) {
    setState(() {
      int index = _orderList.indexWhere((order) => order.item == item);
      if (index != -1) {
        _orderList[index] = OrderItem(
            item: item,
            quantity: _orderList[index].quantity,
            description: desc);
      }
    });
  }

  // Hitung total harga pesanan
  double _calculateTotalPrice() {
    double total = 0;
    for (var order in _orderList) {
      total += order.item.price * order.quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/welcome.png'), // Add your background image here
                  fit: BoxFit.cover, // Makes the image cover the whole screen
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  // Top bar with clock and logout icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Calendar Icon (navigates to another page)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Placeholder()),
                          );
                        },
                        child:
                            Icon(Icons.history_toggle_off_rounded, size: 40, color: Colors.white),
                      ),

                      // Exit Icon (triggers a logout confirmation dialog)
                      GestureDetector(
                        onTap: () {
                          _showLogoutDialog(context); // Calls the logout dialog function
                        },
                        child:
                            Icon(Icons.logout, size: 40, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Welcome Text
                  const Text(
                    'Welcome!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Subtext with name
                  const Text(
                    'Cashier - Daffa.',
                    style: TextStyle(
                      fontSize: 24,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        // Takes remaining space before the image
                        CategorySection(
                          title: 'Culinary',
                          items: culinaryItems,
                          onItemAdded: (item, quantity, desc) {
                            _addItemToOrder(item, quantity, desc);
                          },
                          onItemDesc: (item, desc) {
                            _addItemDescription(item, desc);
                          },
                        ),
                        CategorySection(
                          title: 'Drink',
                          items: drinkItems,
                          onItemAdded: (item, quantity, desc) {
                            _addItemToOrder(item, quantity, desc);
                          },
                          onItemDesc: (item, desc) {
                            _addItemDescription(item, desc);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomSheet: BottomPaymentSheet(
          totalPrice: _calculateTotalPrice(),
          orderList: _orderList,
          onDelete: (index) {
            setState(() {
              _orderList.removeAt(index);
            });
          },
        ));
  }
}

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "Confirm Logout",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Are you sure you want to log out?",
          style: TextStyle(fontSize: 22),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text(
              "Cancel",
              style: TextStyle(fontSize: 20),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (Route<dynamic> route) =>
                    false, // Ini akan menghapus semua halaman sebelumnya
              );
            },
            child: Text("Logout", style: TextStyle(fontSize: 20)),
          ),
        ],
      );
    },
  );
}

class CategorySection extends StatelessWidget {
  final String title;
  final List<MenuItem> items;
  final Function(MenuItem, int, String) onItemAdded;
  final Function(MenuItem, String) onItemDesc;

  CategorySection({
    required this.title,
    required this.items,
    required this.onItemAdded,
    required this.onItemDesc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              const Icon(Icons.expand_more),
              const SizedBox(width: 8),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          child: Container(
            height: 165, // Tinggi container
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                MenuItem selectedItem = items[index];
                return GestureDetector(
                  onTap: () {
                    // Menampilkan ItemPopup saat item di-klik
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ItemPopup(
                          item: selectedItem,
                          onItemAdded: (item, quantity) {
                            onItemAdded(item, quantity, '');
                          },
                          onItemDesc: (item, desc) {
                            onItemDesc(item, desc);
                          },
                        );
                      },
                    );
                  },
                  child: Container(
                    width: 140,
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12)),
                          child: Image.asset(
                            selectedItem.imageUrl,
                            fit: BoxFit.cover,
                            height: 80, // Tinggi gambar
                            width: double.infinity,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            selectedItem.name,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'IDR ${selectedItem.price}',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600]),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class BottomPaymentSheet extends StatefulWidget {
  final double totalPrice;
  final List<OrderItem> orderList;
  final Function(int) onDelete;

  BottomPaymentSheet(
      {required this.totalPrice,
      required this.orderList,
      required this.onDelete});

  @override
  _BottomPaymentSheetState createState() => _BottomPaymentSheetState();
}

class _BottomPaymentSheetState extends State<BottomPaymentSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      decoration: BoxDecoration(
        color: Styles.themeColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Center(
            child: Text(
              "Cart",
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'IDR. ${widget.totalPrice.toStringAsFixed(0)}', // Menggunakan widget.totalPrice
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Styles.themeColor, // Warna background tombol
                    foregroundColor: Colors.white, // Warna teks tombol
                    side: const BorderSide(
                        color:
                            Colors.white), // Membuat border putih pada tombol
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          8), // Membuat sudut border lebih melengkung
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderPage(
                          orderList: widget.orderList,
                          onDelete: widget.onDelete,
                          onRefresh: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderPage(
                                  orderList: widget.orderList,
                                  onDelete: widget.onDelete,
                                  onRefresh: () {},
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Check List',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
