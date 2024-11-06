import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ukk_kasir/pages/cashier/checklist_order.dart';
import 'package:ukk_kasir/pages/cashier/editprofile.dart';
import 'package:ukk_kasir/pages/cashier/showOrder.dart';
import 'package:ukk_kasir/pages/login/loginpage.dart';
import 'package:ukk_kasir/services/allrole/getMenu.dart';
import 'package:ukk_kasir/services/auth/user_service.dart';
import 'package:ukk_kasir/style/styles.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final String baseUrl = 'https://ukkcafe.smktelkom-mlg.sch.id/';
  final UserService _userService = UserService();
  List<dynamic> menuList = [];
  List<OrderItem> _orderList = [];
  bool isLoading = true;
  String? username; //username pengguna
  String? userRole; // role pengguna
  int? userId; // role pengguna

  @override
  void initState() {
    super.initState();
    _fetchMenuData();
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

  Future<void> _fetchMenuData() async {
    try {
      Map<String, dynamic> response = await getMenu();

      if (response["status"] == "success") {
        setState(() {
          menuList = response["data"];
          isLoading = false;
        });
      } else {
        _showError("Failed to fetch menu: ${response['message']}");
      }
    } catch (error) {
      _showError("An error occurred: $error");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
    setState(() {
      isLoading = false;
    });
  }

  // Menampilkan dialog untuk memilih kuantitas sebelum menambah item
  void _showQuantityDialog(MenuItem item) {
    int quantity = 1; // Default quantity

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Quantity"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Enter the quantity you want to buy:"),
              SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Quantity (Default: 1)",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  quantity = int.tryParse(value) ?? 1;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                _addItemToOrder(item, quantity);
                Navigator.of(context).pop();
              },
              child: Text("Add to Cart"),
            ),
          ],
        );
      },
    );
  }

  // Menambahkan item ke dalam pesanan dengan kuantitas yang dipilih
  void _addItemToOrder(MenuItem item, int quantity) {
    setState(() {
      _orderList.add(OrderItem(item: item, quantity: quantity));
    });
  }

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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : menuList.isEmpty
              ? const Center(child: Text("No menu available"))
              : Stack(
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
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 40,
                          ),
                          // Top bar with clock and logout icons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => OrdersByUserPage(userId: userId!,)),
                                  );
                                },
                                child: Icon(Icons.timelapse,
                                    size: 40, color: Colors.white),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => EditProfile(userID: userId!,)),
                                  );
                                },
                                child: Icon(Icons.person,
                                    size: 40, color: Colors.white),
                              ),
                              // Exit Icon (triggers a logout confirmation dialog)
                              GestureDetector(
                                onTap: () {
                                  _logout();
                                },
                                child: Icon(Icons.logout,
                                    size: 40, color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),

                          const Text(
                            'Welcome!',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          // Welcome Text
                          const SizedBox(height: 2),
                          if (username != null && userRole != null)
                            Text(
                              '$userRole - $username \nYour ID : $userId',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic),
                            ),
                          SizedBox(
                            height: 70,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 3 / 4,
                                ),
                                itemCount: menuList.length,
                                itemBuilder: (context, index) {
                                  var menuItem = menuList[index];
                                  final imageUrl =
                                      '$baseUrl${menuItem['menu_image_name']}';
                                  return GestureDetector(
                                    onTap: () {
                                      // Menampilkan dialog untuk memilih kuantitas
                                      _showQuantityDialog(
                                        MenuItem(
                                          name: menuItem['menu_name'],
                                          price: menuItem['price'],
                                          imageUrl: imageUrl,
                                          id: menuItem['menu_id'],
                                        ),
                                      );
                                    },
                                    child: _buildMenuItem(menuItem, imageUrl),
                                  );
                                },
                              ),
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
        onUpdateOrderList: (updatedOrderList) {
          // Add this line
          setState(() {
            _orderList = updatedOrderList;
          });
        },
      ),
    );
  }

  Widget _buildMenuItem(dynamic menuItem, String imageUrl) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: imageUrl != null
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )
                : Container(
                    color: Colors.grey.shade300,
                    child: const Center(child: Text("No Image")),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  menuItem['menu_name'],
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  menuItem['type'] ?? '',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                Text(
                  'Price: ${menuItem['price']}',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  menuItem['menu_description'] ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _logout() async {
    bool? confirmLogout = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmLogout == true) {
      await _userService.logout();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }
}

class OrderItem {
  final MenuItem item;
  final int quantity;

  OrderItem({required this.item, required this.quantity});
}

class MenuItem {
  final String name;
  final int price;
  final String imageUrl;
  final int id;

  MenuItem({required this.name, required this.price, required this.imageUrl, required this.id});
}

class BottomPaymentSheet extends StatelessWidget {
  final double totalPrice;
  final List<OrderItem> orderList;
  final Function(int) onDelete;
  final Function(List<OrderItem>) onUpdateOrderList;

  BottomPaymentSheet({
    required this.totalPrice,
    required this.orderList,
    required this.onDelete,
    required this.onUpdateOrderList,
  });

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
                  'IDR. ${totalPrice.toStringAsFixed(0)}',
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
                  backgroundColor: Styles.themeColor,
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  final updatedOrderList = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckListOrderPage(
                        orderList: List<OrderItem>.from(orderList),
                      ),
                    ),
                  );
                  if (updatedOrderList != null) {
                    onUpdateOrderList(updatedOrderList);
                  }
                },
                child: const Text(
                  'Check List',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
