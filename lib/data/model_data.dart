// data.dart
class MenuItem {
  final int idmenu;
  final String name;
  final String imageUrl;
  final String description;
  final int price;
  int quantity;

  MenuItem({required this.idmenu,required this.name, required this.imageUrl,required this.description, required this.price, this.quantity = 1});

  int get _idmenu => idmenu;
  String get _name => name;
  String get _imageUrl => imageUrl;
  String get _desc => description;
  int get _price => price;
}




