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

final List<MenuItem> culinaryItems = [
  MenuItem(
      idmenu: 1,
      name: 'Pancake Jawa',
      imageUrl: 'assets/images/cake.png',
      description: 'Pancake Jawa dengan topping coklat dan kacang',
      price: 3000),
  MenuItem(
      idmenu: 2,
      name: 'Kwetiao Cina',
      imageUrl: 'assets/images/cake.png',
      description: 'Kwetiao lanciao',
      price: 800000),
  MenuItem(
      idmenu: 3,
      name: 'Bakmi Jawa',
      imageUrl: 'assets/images/cake.png',
      description: 'Mantapjiwa',
      price: 15000),
];

final List<MenuItem> drinkItems = [
  MenuItem(
      idmenu: 4,
      name: 'Es Koopi',
      imageUrl: 'assets/images/cake.png',
      description: 'es kopi eskopi',
      price: 3000),
  MenuItem(
      idmenu: 5,
      name: 'Tuwak Ireng',
      imageUrl: 'assets/images/cake.png',
      description: 'mawurah cik',
      price: 3000),
  MenuItem(
      idmenu: 6,
      name: 'Ais Tea',
      imageUrl: 'assets/images/cake.png',
      description: 'teabreak',
      price: 3000),
];

//customer cart
  List<MenuItem> _cart = [];

  //getter method
  List<MenuItem> get dishMenu => culinaryItems;
  List<MenuItem> get drinkMenu => drinkItems;
  List<MenuItem> get cart => _cart;

  //add to cart
  void AddtoCart(MenuItem fnb, int quantity) {
    for (int i = 0; i < quantity; i++) {
      _cart.add(fnb);
    }
  }

  //remove from cart
  void removefromCart(MenuItem fnb) {
    _cart.remove(fnb);
  }


