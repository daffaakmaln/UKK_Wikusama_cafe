import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ukk_kasir/style/styles.dart';

class UserUI extends StatefulWidget {
  const UserUI({super.key});

  @override
  State<UserUI> createState() => _UserUIState();
}

class _UserUIState extends State<UserUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User', style: TextStyle(color: Colors.white),),
        backgroundColor: Styles.themeColor,
      ),
    );
  }
}