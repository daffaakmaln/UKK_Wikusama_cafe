import 'package:flutter/material.dart';
import 'package:ukk_kasir/services/admin/user/updateUser.dart';

class EditUserDialog extends StatefulWidget {
  final Map<String, dynamic> user;

  EditUserDialog({required this.user});

  @override
  _EditUserDialogState createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  late TextEditingController _userNameController;
  late TextEditingController _usernameController;
  String _selectedRole = 'admin';
  final UpdateUserService _updateUserService = UpdateUserService();

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController(text: widget.user['user_name']);
    _usernameController = TextEditingController(text: widget.user['username']);
    _selectedRole = widget.user['role'];
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit User'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _userNameController,
              decoration: InputDecoration(labelText: 'User Name'),
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: InputDecoration(labelText: 'Role'),
              items: ['admin', 'cashier', 'manager'].map((role) {
                return DropdownMenuItem(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRole = value!;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            final success = await _updateUserService.updateUser(
              widget.user['user_id'],
              _userNameController.text,
              _selectedRole,
              _usernameController.text,
            );

            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('User updated successfully')),
              );
              Navigator.pop(context, true);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to update user')),
              );
            }
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
