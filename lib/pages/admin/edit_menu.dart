import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ukk_kasir/style/styles.dart';

class MenuUI extends StatefulWidget {
  const MenuUI({super.key});

  @override
  State<MenuUI> createState() => _MenuUIState();
}

class _MenuUIState extends State<MenuUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Menu', style: TextStyle(color: Colors.white),),
        backgroundColor: Styles.themeColor,
      ),
    );
  }
}