import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

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
            icon: const Icon(TablerIcons.plus),
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
