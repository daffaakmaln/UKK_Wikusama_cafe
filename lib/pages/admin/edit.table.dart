import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ukk_kasir/style/styles.dart';

class TableUI extends StatefulWidget {
  const TableUI({super.key});

  @override
  State<TableUI> createState() => _TableUIState();
}

class _TableUIState extends State<TableUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Table', style: TextStyle(color: Colors.white),),
        backgroundColor: Styles.themeColor,
      ),
    );
  }
}