import 'package:flutter/material.dart';
import 'package:ukk_kasir/pages/login/loginpage.dart';
import 'package:ukk_kasir/services/admin/table/get_table.dart';
import 'package:ukk_kasir/services/admin/table/delete_table.dart';
import 'package:ukk_kasir/services/admin/table/update_table.dart';
import 'package:ukk_kasir/services/admin/table/add_table.dart';
import 'package:ukk_kasir/services/auth/user_service.dart';
import 'package:ukk_kasir/style/styles.dart';

class TableUI extends StatefulWidget {
  const TableUI({super.key});

  @override
  State<TableUI> createState() => _TableUIState();
}

class _TableUIState extends State<TableUI> {
  final UserService _userService = UserService();
  List<dynamic> tables = [];
  bool isLoading = true;
  final DeleteTable deleteTableService = DeleteTable();
  final UpdateTable updateTableService = UpdateTable();
  final AddTable addTableService = AddTable(); // Instance of AddTable

  @override
  void initState() {
    super.initState();
    _fetchTableData();
  }

  Future<void> _fetchTableData() async {
    try {
      final fetchedTables = await showTable();
      setState(() {
        tables = fetchedTables;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load tables: $e')),
      );
    }
  }

  Future<void> _deleteTable(int tableId) async {
    bool success = await deleteTableService.deleteTable(tableId);
    if (success) {
      setState(() {
        tables.removeWhere((table) => table['table_id'] == tableId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Table successfully deleted.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete table.')),
      );
    }
  }

  Future<void> _addTable() async {
    TextEditingController tableNumberController = TextEditingController();

    bool? confirmAdd = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Table'),
        content: TextField(
          controller: tableNumberController,
          decoration: InputDecoration(labelText: 'Table Number'),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Add', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );

    if (confirmAdd == true) {
      String tableNumber = tableNumberController.text;

      // Check if the table number already exists
      bool tableExists =
          tables.any((table) => table['table_number'] == tableNumber);

      if (tableExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Table number already exists.')),
        );
        return; // Exit the method to prevent further processing
      } else if (tableNumber.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Table number is required.')),
        );
        return;
      }

      var result = await addTableService.addTable(tableNumber);

      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Table added successfully.')),
        );
        _fetchTableData(); // Refresh table list after adding
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add table.')),
        );
      }
    }
  }

  Future<void> _updateTable(int tableId, String currentNumber) async {
    TextEditingController tableNumberController =
        TextEditingController(text: currentNumber);

    bool? confirmUpdate = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Table'),
        content: TextField(
          controller: tableNumberController,
          decoration: InputDecoration(labelText: 'New Table Number'),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Update', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );

    if (confirmUpdate == true) {
      String newTableNumber = tableNumberController.text;

      bool tableNumberExists = tables.any((table) =>
          table['table_number'] == newTableNumber &&
          table['table_id'] != tableId);

      if (tableNumberExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Table number already exists.')),
        );
        return;
      }

      bool success = await updateTableService.updateTable(
        tableId,
        newTableNumber,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Table updated successfully.')),
        );
        _fetchTableData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update table.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Table', style: TextStyle(color: Colors.white)),
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
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Styles.themeColor,
                      ),
                      onPressed: _addTable, // Add table logic
                      child: Text(
                        'Add Table',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: tables.isEmpty
                      ? Center(child: Text('No tables available'))
                      : ListView.builder(
                          itemCount: tables.length,
                          itemBuilder: (context, index) {
                            final table = tables[index];
                            return Card(
                              child: ListTile(
                                title: Text(
                                  'Table ${table['table_number']}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                subtitle: Text(
                                    'Status tersedia: ${table['is_available']}'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit,
                                          color: Styles.themeColor),
                                      onPressed: () => _updateTable(
                                          table['table_id'],
                                          table['table_number']),
                                    ),
                                    IconButton(
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: () async {
                                        bool? confirmDelete = await showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text('Confirm Delete'),
                                            content: Text(
                                                'Are you sure you want to delete this table?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(false),
                                                child: Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(true),
                                                child: Text('Delete',
                                                    style: TextStyle(
                                                        color: Colors.red)),
                                              ),
                                            ],
                                          ),
                                        );

                                        if (confirmDelete == true) {
                                          _deleteTable(table['table_id']);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
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
