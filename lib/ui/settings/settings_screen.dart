import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/shared/change_value_field.dart';
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
              showDialog(
                context: context,
                builder: (context) {
                  return ChangeValueFieldDouble(
                    sr,
                    StorageStore.weightKey,
                    'Вес',
                  );
                },
              );
            },
          ),
          ListTile(
            title: Text('Рост'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return ChangeValueFieldDouble(
                    sr,
                    StorageStore.heightKey,
                    'Рост',
                  );
                },
              );
            },
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
