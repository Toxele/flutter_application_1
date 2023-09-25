import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/text_field_pattern.dart';
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
            title: const Text('Вес'),
            onTap: () {
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
