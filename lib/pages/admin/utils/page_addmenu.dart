import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ukk_kasir/pages/admin/navbar.dart';
import 'package:ukk_kasir/services/admin/menu/addMenu.dart'; // Import the addMenu service
import 'package:ukk_kasir/style/styles.dart';

class AddMenuPage extends StatefulWidget {
  @override
  _AddMenuPageState createState() => _AddMenuPageState();
}

class _AddMenuPageState extends State<AddMenuPage> {
  final TextEditingController menuNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  String? selectedType;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }

  Future<void> _addMenu() async {
    if (menuNameController.text.isEmpty ||
        selectedType == null ||
        descriptionController.text.isEmpty ||
        priceController.text.isEmpty ||
        _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields and select an image.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      bool success = await addMenu(
        menuName: menuNameController.text,
        type: selectedType!,
        menuDescription: descriptionController.text,
        price: int.parse(priceController.text),
        imagePath: _image!.path,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Menu added successfully.')),
        );
        Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Navbar()),
        (Route<dynamic> route) => false, // Menghapus semua rute sebelumnya
      ); // Return to the previous page
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add menu.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding menu: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Menu', style: TextStyle(color: Colors.white)),
        backgroundColor: Styles.themeColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: menuNameController,
                decoration: InputDecoration(labelText: 'Menu Name'),
              ),
              DropdownButtonFormField<String>(
                value: selectedType,
                items: ['food', 'drink'].map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedType = newValue;
                  });
                },
                decoration: InputDecoration(labelText: 'Type'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Menu Description'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text("Select Image:", style: TextStyle(fontSize: 18)),
                  SizedBox(width: 30),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: Icon(Icons.photo, color: Colors.white),
                    label: Text('Pick Image', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: Styles.themeColor),
                  ),
                ],
              ),
              SizedBox(height: 20),
              _image != null
                  ? Image.file(_image!, height: 200)
                  : Text('No image selected'),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Styles.themeColor),
                  onPressed: isLoading ? null : _addMenu,
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Add Menu', style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
