import 'package:flutter/material.dart';
import 'package:ukk_kasir/pages/admin/navbar.dart';
import 'package:ukk_kasir/services/admin/user/addUser.dart';
import 'package:ukk_kasir/style/styles.dart';

class AddUserPage extends StatefulWidget {
  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final RegisterService _registService = RegisterService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _selectedRole = 'admin';

  Future<void> _register() async {
    String userName = _userNameController.text;
    String role = _selectedRole;
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (userName.isEmpty ||
        role.isEmpty ||
        username.isEmpty ||
        password.isEmpty) {
      _showPopup('All fields are required.');
      return;
    }

    var result =
        await _registService.registerUser(userName, role, username, password);
    if (result != null) {
      _showPopup('Registration successful!');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Navbar()),
        (Route<dynamic> route) => false, // Menghapus semua rute sebelumnya
      );
      // Navigate to the next page or login page
    } else {
      _showPopup('Registration failed. Please try again.');
    }
  }

  void _showPopup(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add User', style: TextStyle(color: Colors.white)),
        backgroundColor: Styles.themeColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _userNameController,
              decoration: InputDecoration(labelText: 'User Name'),
            ),
            Row(
              children: [
                Text('Select Role: ', style: TextStyle(fontSize: 18)),
                DropdownButton<String>(
                  style: TextStyle(fontSize: 20, color: Styles.themeColor),
                  value: _selectedRole,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRole = newValue!;
                    });
                  },
                  items: <String>['admin', 'cashier', 'manager']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Styles.themeColor),
                onPressed: () {
                  _register();
                },
                child: Text('Add User',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
