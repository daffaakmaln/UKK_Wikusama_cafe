import 'package:flutter/material.dart';
import 'package:ukk_kasir/pages/admin/edit_user.dart';
import 'package:ukk_kasir/pages/admin/navbar.dart';
import 'package:ukk_kasir/pages/cashier/cashier.dart';
import 'package:ukk_kasir/pages/login/login.dart';
import 'package:ukk_kasir/pages/login/loginpage.dart';

void main() {
  runApp(const MyApp());
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wikusama Coffee',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: LoginPage(),
    );
  }
}