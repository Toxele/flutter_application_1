import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/text_field_pattern.dart';

class _InputNotificationRecord {
  String text = "";
  DateTime time = DateTime(2023);
}

class UserNotifyRecord extends StatelessWidget {
  const UserNotifyRecord({super.key, required this.onDone});

  final void Function({
    required String message,
    required DateTime timeToNotificate,
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
                onDone.call(message: record.text, timeToNotificate: record.time);
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
