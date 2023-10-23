
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/storage_repository.dart';
import 'package:flutter_application_1/utils/text_field_pattern.dart';

class ChangeValueFieldDouble extends StatelessWidget {
  final StorageRepository sr;
  final String valueKey;
  final String valueName;
  const ChangeValueFieldDouble(this.sr, this.valueKey, this.valueName);
  // TODO: вынести в отдельный контроллер и доделать
  void setValue(Object? value) {
    if (value is int) {
      sr.setInt(valueKey, value);
    }
    if (value is double) {
      sr.setDouble(valueKey, value);
    }
    if (value is String) {
      sr.setString(valueKey, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        // можно ли выполнить проверку на то, что пользователь вышел из окна через аппбар?
        body: TextFieldPattern(
          onEdit: (String value) {
            sr.setDouble(valueKey, double.parse(value));
          },
          value: sr.getDouble(valueKey).toString(),
          valueName: valueName,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: IconButton(
            icon: const Icon(Icons.done),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}
