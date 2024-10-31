import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ukk_kasir/pages/login/loginpage.dart';
import 'package:ukk_kasir/services/auth/user_service.dart';
import 'package:ukk_kasir/style/styles.dart';

class DashboardUI extends StatefulWidget {
  const DashboardUI({super.key});

  @override
  State<DashboardUI> createState() => _DashboardUIState();
}

class _DashboardUIState extends State<DashboardUI> {
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
        title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
        backgroundColor: Styles.themeColor,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      body: Center(
        child: username != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Selamat Datang, $username!',
                    style: TextStyle(fontSize: 20),
                  ),
                  if (userRole != null)
                    Text(
                      'Role: $userRole',
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  SizedBox(height: 20,),
                  Container(

                    width: 300,
                    height: 200,
                    child: Text('Rules Admin: \nJangan terlalu cepat beralih halaman menggunakan navbar, karena menggunakan setState tiap halamannya. \n\nGapapa pelan asalkan aplikasi jalan :D', style: TextStyle(fontSize: 16),))
                ],
              )
            : CircularProgressIndicator(),
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
