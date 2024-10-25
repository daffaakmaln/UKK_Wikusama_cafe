import 'package:flutter/material.dart';
import 'package:ukk_kasir/data/model_data.dart';

class ItemPopup extends StatefulWidget {
  final MenuItem item;
  final Function(MenuItem, int) onItemAdded;
  final Function(MenuItem, String) onItemDesc;

  const ItemPopup({
    Key? key,
    required this.item,
    required this.onItemAdded,
    required this.onItemDesc,
  }) : super(key: key);

  @override
  _ItemPopupState createState() => _ItemPopupState();
}

class _ItemPopupState extends State<ItemPopup> {
  int _quantity = 1; // Quantity pesanan
  

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              widget.item.imageUrl,
              height: 100.0,
              width: 100.0,
            ),
            const SizedBox(height: 16.0),
            Text(
              widget.item.name,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'IDR ${widget.item.price}', 
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Deskripsi ${widget.item.description}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (_quantity > 1) {
                        _quantity--;
                      }
                    });
                  },
                  icon: const Icon(Icons.remove),
                ),
                const SizedBox(width: 8.0),
                Text(
                  '$_quantity',
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(width: 8.0),
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
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                widget.onItemAdded(widget.item, _quantity);
                widget.onItemDesc(widget.item, widget.item.description);
                Navigator.of(context).pop();
              },
              child: const Text('Tambahkan ke Pesanan'),
            ),
          ],
        ),
      ),
    );
  }
}
