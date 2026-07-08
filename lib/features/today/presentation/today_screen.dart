import 'package:flutter/material.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hoje'),
      ),
      body: const Center(
        child: Text('Seletor de dia, lista de blocos e anel de aderência'),
      ),
    );
  }
}
