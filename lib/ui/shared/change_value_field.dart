import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/storage_repository.dart';
import 'package:flutter_application_1/utils/text_field_pattern.dart';
import 'package:provider/provider.dart';

class ChangeValueFieldDouble extends StatelessWidget {
  final StorageRepository sr;
  final String valueKey;
  final String valueName;
  const ChangeValueFieldDouble(this.sr, this.valueKey, this.valueName);
  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar:
            AppBar(), // можно ли выполнить проверку на то, что пользователь вышел из окна через аппбар?
        body: TextFieldPattern(
          onEdit: (String value) {
            sr.setDouble(valueKey, double.parse(value));
          },
          value: sr.getDouble(valueKey).toString(),
          valueName: valueName,
        ),
      ),
    );
  }
}
