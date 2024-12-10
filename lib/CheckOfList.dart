// history_page.dart
import 'package:flutter/material.dart';

class CheckOfListPage extends StatelessWidget {
  const CheckOfListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History Page'),
      ),
      body: Center(
        child: const Text('This is the History page'),
      ),
    );
  }
}
