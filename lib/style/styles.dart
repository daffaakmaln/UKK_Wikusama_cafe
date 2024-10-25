// styles.dart
import 'package:flutter/material.dart';

class Styles {
  static const TextStyle titleTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle listTitleTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle priceTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.grey,
  );

  static const TextStyle totalPriceTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static const Color themeColor = Color.fromARGB(255, 33, 33, 33);

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const BoxDecoration cardDecoration = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.grey,
        blurRadius: 5,
        spreadRadius: 2,
      ),
    ],
  );
}
