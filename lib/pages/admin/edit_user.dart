import 'package:flutter/material.dart';
import 'package:ukk_kasir/pages/admin/utils/register.dart';
import 'package:ukk_kasir/pages/admin/utils/update_user.dart';
import 'package:ukk_kasir/pages/login/loginpage.dart';
import 'package:ukk_kasir/services/admin/user/deleteUser.dart';
import 'package:ukk_kasir/services/auth/user_service.dart';
import 'package:ukk_kasir/style/styles.dart';

class EdituserUI extends StatefulWidget {
  @override
  _EdituserUIState createState() => _EdituserUIState();
}

class _EdituserUIState extends State<EdituserUI> {
  final UserService _userService = UserService();
  final DeleteUserService _deleteuserService = DeleteUserService();
  List<dynamic> users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final fetchedUsers = await _userService.fetchUsers();
    if (fetchedUsers != null) {
      setState(() {
        users = fetchedUsers;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load users. Please try again.')),
      );
    }
  }

  Future<void> _deleteUser(int userId) async {
    bool success = await _deleteuserService.deleteUser(userId);
    if (success) {
      setState(() {
        users.removeWhere((user) => user['user_id'] == userId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User successfully deleted.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete user. Please try again.')),
      );
    }
  }

  Future<void> _editUser(Map<String, dynamic> user) async {
    final result = await showDialog(
      context: context,
      builder: (context) => EditUserDialog(user: user),
    );

    if (result == true) {
      await _fetchUsers(); // Refresh the user list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User', style: TextStyle(color: Colors.white)),
        backgroundColor: Styles.themeColor,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Styles.themeColor),
                onPressed: _addUser,
                child: Text('Add User', style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ),
          ),
          Expanded(
            child: users.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return ListTile(
                        title: Text(user['username'], style: TextStyle(fontSize: 18),),
                        subtitle: Text('Role: ${user['role']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => _editUser(user),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red,),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Confirm Delete'),
                                    content: Text('Are you sure you want to delete this user?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          _deleteUser(user['user_id']);
                                        },
                                        child: Text('Delete', style: TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _addUser() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddUserPage()),
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