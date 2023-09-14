import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/storage_repository.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<StorageRepository>(
      builder: (context, child) => Scaffold(
        appBar: AppBar(title: Text('Настройки')),
        body: ListView(
          children: [
            ListTile(
              title: Text('Важная настройка 1'),
              onTap: () {},
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
      ),
      create: (_) => StorageRepository(),
    );
  }
}
