import 'package:flutter/material.dart';
import 'package:ukk_kasir/pages/admin/utils/page_addmenu.dart';
import 'package:ukk_kasir/pages/admin/utils/page_updatemenu.dart';
import 'package:ukk_kasir/pages/login/loginpage.dart';
import 'package:ukk_kasir/services/auth/user_service.dart';
import 'package:ukk_kasir/services/allrole/getMenu.dart';
import 'package:ukk_kasir/style/styles.dart';

class MenuUI extends StatefulWidget {
  const MenuUI({super.key});

  @override
  State<MenuUI> createState() => _MenuUIState();
}

class _MenuUIState extends State<MenuUI> {
  final UserService _userService = UserService();
  List<dynamic> menuItems = []; // List to store menu data from API
  bool isLoading = true;
  final String baseUrl =
      'https://ukkcafe.smktelkom-mlg.sch.id/'; // Base URL for images

  @override
  void initState() {
    super.initState();
    _fetchMenuData(); // Fetch menu data on initialization
  }

  Future<void> _fetchMenuData() async {
    try {
      final response = await getMenu();
      setState(() {
        menuItems = response['data'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load menu: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Menu', style: TextStyle(color: Colors.white)),
        backgroundColor: Styles.themeColor,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddMenuPage(),
                              ),
                            );
                      },
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Add Menu",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Styles.themeColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 10), // Add spacing between button and grid
                    Expanded(
                    child: GridView.builder(
                      gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.7, // Adjust the aspect ratio to make the grid items taller
                      ),
                      itemCount: menuItems.length,
                      itemBuilder: (context, index) {
                      final item = menuItems[index];
                      final imageUrl =
                        '$baseUrl${item['menu_image_name']}'; // Full URL for the image

                      return GestureDetector(
                        onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                          builder: (context) =>
                            UpdateMenuPage(menuItem: item),
                          ),
                        );
                        },
                        child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                            width: 200,
                            height: 150, // Set a specific height
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder:
                                (context, error, stackTrace) => Icon(
                                  Icons.broken_image,
                                  color: Colors.grey),
                            ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                            '${item['menu_name']}',
                            style:
                              TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('Type: ${item['type']}'),
                            Text(
                            'Price: Rp. ${item['price']}',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold),
                            ),
                          ],
                          ),
                        ),
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
