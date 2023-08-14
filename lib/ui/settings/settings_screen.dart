import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
