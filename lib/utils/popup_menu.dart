import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ukk_kasir/data/model_data.dart';
import 'package:http/http.dart' as http;

class MenuDetailPopup extends StatefulWidget {
  final String menuId;
  final Function(MenuItem, int) onItemAdded;

  const MenuDetailPopup({
    Key? key,
    required this.menuId,
    required this.onItemAdded,
  }) : super(key: key);

  @override
  _MenuDetailPopupState createState() => _MenuDetailPopupState();
}

class _MenuDetailPopupState extends State<MenuDetailPopup> {
  late Future<MenuItem> _menuItemFuture;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _menuItemFuture = _fetchMenuItem(widget.menuId);
  }

  Future<MenuItem> _fetchMenuItem(String menuId) async {
    try {
      var response = await http.get(
        Uri.parse('https://ukkcafe.smktelkom-mlg.sch.id/api/menu/$menuId'),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return MenuItem(
          idmenu: data['idmenu'],
          name: data['menu_name'],
          price: data['price'],
          imageUrl: 'https://ukkcafe.smktelkom-mlg.sch.id/${data['menu_image_name']}',
          description: data['menu_description'],
        );
      } else {
        throw Exception('Failed to load menu item');
      }
    } catch (e) {
      throw Exception('Error fetching menu data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: FutureBuilder<MenuItem>(
        future: _menuItemFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No menu data available.'),
            );
          }

          final menuItem = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  menuItem.imageUrl,
                  height: 100,
                  width: 100,
                ),
                const SizedBox(height: 8),
                Text(
                  menuItem.name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Price: IDR ${menuItem.price}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  menuItem.description,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (_quantity > 1) _quantity--;
                        });
                      },
                      icon: const Icon(Icons.remove),
                    ),
                    Text(
                      '$_quantity',
                      style: const TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _quantity++;
                        });
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    widget.onItemAdded(menuItem, _quantity);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Add to Order'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
