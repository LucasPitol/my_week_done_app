import 'package:flutter/material.dart';

class BlocksScreen extends StatelessWidget {
  const BlocksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blocos'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
            tooltip: 'Criar bloco',
          ),
        ],
      ),
      body: const Center(
        child: Text('Lista de rotinas e formulário de blocos'),
      ),
    );
  }
}
