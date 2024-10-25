import 'package:flutter/material.dart';
import 'package:ukk_kasir/pages/admin/dashboard.dart';
import 'package:ukk_kasir/pages/admin/edit.table.dart';
import 'package:ukk_kasir/pages/admin/edit_menu.dart';
import 'package:ukk_kasir/pages/admin/edit_user.dart';
import 'package:ukk_kasir/style/styles.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    AdminDashboard(),
    MenuUI(),
    TableUI(),
    UserUI()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: 'Edit Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.table_bar_outlined),
            label: 'Edit Table',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Edit User',
          ),
        ],
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.cyan[100],
        unselectedItemColor: Colors.white,
        selectedIconTheme: IconThemeData(color: Colors.cyan[100]),
        unselectedIconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Styles.themeColor,
        onTap: _onItemTapped,
      ),
    );
  }
}