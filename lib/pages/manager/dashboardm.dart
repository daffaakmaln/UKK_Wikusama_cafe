import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ukk_kasir/pages/login/loginpage.dart';
import 'package:ukk_kasir/pages/manager/searchOrder.dart';
import 'package:ukk_kasir/pages/manager/searchOrderbyDate.dart';
import 'package:ukk_kasir/services/auth/user_service.dart';
import 'package:ukk_kasir/services/manager/showOrder.dart';
import 'package:ukk_kasir/style/styles.dart';

class HomeManager extends StatefulWidget {
  @override
  State<HomeManager> createState() => _HomeManagerState();
}

class _HomeManagerState extends State<HomeManager> {
  final DashboardManager dashboardManager = DashboardManager();
  final UserService _userService = UserService();
  String? username; // Variable untuk menyimpan nama pengguna
  String? userRole; // Variable untuk menyimpan peran pengguna

  @override
  void initState() {
    super.initState();
    getUserInfo(); // Ambil informasi pengguna saat halaman dimuat
  }

  Future<void> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      userRole = prefs.getString('user_role');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Manager',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Styles.themeColor,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(color: Styles.themeColor),
            child: Center(
              child: username != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Selamat Datang, $username!',
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        if (userRole != null)
                          Text(
                            'Role: $userRole',
                            style: TextStyle(
                                fontSize: 20, color: Colors.lightBlueAccent),
                          ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SearchPage(),
                                  ),
                                );
                              },
                              child: Text('Search Order'),
                            ),
                            SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderByDatePage(),
                                  ),
                                );
                              },
                              child: Text('Search Order by Date'),
                            ),
                          ],
                        ),
                      ],
                    )
                  : CircularProgressIndicator(),
            ),
          ),

          Expanded(
            child: FutureBuilder<List<Order>>(
              future: dashboardManager.fetchOrders(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("No orders available"));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Order order = snapshot.data![index];
                      return Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        elevation: 4,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          title: Text(
                            "Order #${order.orderId} - ${order.customerName}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
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
                        ),
                      );
                    },
                  );
                }
              },
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
