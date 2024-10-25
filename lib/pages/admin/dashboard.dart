//ERROR CODE shared preferences error occured

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String? accessToken;
  List<dynamic> users = []; // To store user data

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter binding is initialized
    _loadAccessToken();
  }

  // Load access token from SharedPreferences
  Future<void> _loadAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      accessToken = prefs.getString('access_token');
      _fetchUsers(); // Fetch users after loading the access token
    });
  }

  // Fetch users from the API
  Future<void> _fetchUsers() async {
    if (accessToken == null) return;

    final response = await http.get(
      Uri.parse('https://ukkcafe.smktelkom-mlg.sch.id/api/user'), // Replace with your API endpoint
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        users = jsonDecode(response.body); // Assuming the response is a list of users
      });
    } else {
      // Handle error
      print('Failed to load users: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Implement logout functionality
              _logout();
            },
          ),
        ],
      ),
      body: users.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text(user['username']),
                  subtitle: Text('Role: ${user['role']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Implement edit user functionality
                      _editUser(user['user_id']);
                    },
                  ),
                );
              },
            ),
    );
  }

  // Logout function
  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('user_role');
    await prefs.remove('user_id');
    Navigator.pushReplacementNamed(context, '/login'); // Navigate to login page
  }

  // Edit user function (placeholder)
  void _editUser(int userId) {
    // Navigate to edit user page or show a dialog
    print('Edit user with ID: $userId');
  }
}