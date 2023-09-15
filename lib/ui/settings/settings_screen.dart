import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/storage_repository.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sr = context.watch<StorageRepository>();
    return Scaffold(
      appBar: AppBar(title: Text('Настройки')),
      body: ListView(
        children: [
          ListTile(
            title: Text('Важная настройка 1'),
            onTap: () {
              print('12345');
            },
          ),
          ListTile(
            title: Text('Важная настройка 1'),
            onTap: () {},
          ),
          SwitchListTile(
            value: true,
            title: Text('bool настройка 1'),
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }
}
