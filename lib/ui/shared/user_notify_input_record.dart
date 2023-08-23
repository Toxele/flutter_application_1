import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/default_values.dart'
    as default_values;
import 'package:flutter_application_1/domain/user_status_control_service/user_status_controller.dart';
import 'package:flutter_application_1/domain/weather/weather_notifier.dart';
import 'package:provider/provider.dart';

import '../../domain/weather/weather.dart';
import '../../service classes/text_field_pattern.dart';

class _InputNotificationRecord {
  String text = "";
  DateTime time = DateTime(2023);
}

class UserNotifyRecord extends StatelessWidget {
  const UserNotifyRecord({super.key, required this.onDone});

  final void Function({
    String text,
    DateTime time,
  }) onDone;
  @override
  Widget build(BuildContext context) {
    return Provider<_InputNotificationRecord>(
      create: (_) => _InputNotificationRecord(),
      builder: (context, child) => Dialog.fullscreen(
        child: Scaffold(
          appBar: AppBar(),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final record = context.read<_InputNotificationRecord>();
              onDone.call();
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: const Icon(Icons.done),
          ),
          body: Consumer<_InputNotificationRecord>(
            builder: (context, record, _) {
              return ListView(
                children: [
                  TextFieldPattern(
                    onEdit: (String value) => record.text = value,
                    value: "Введите текст",
                    valueName: 'Текст отложенного уведомления',
                  ),
                  TextFieldPattern(
                    onEdit: (String value) => record.time = value as DateTime,
                    value: "Время получения уведомления",
                    valueName: '12:00:00',
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
