import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/class_instances.dart';
import '../../domain/notification_service/notification_service.dart';

class NotificationRecordInfoDialog extends StatefulWidget {
  const NotificationRecordInfoDialog({super.key});
  @override
  State<NotificationRecordInfoDialog> createState() =>
      _NotificationRecordInfoDialogState();
}

class _NotificationRecordInfoDialogState
    extends State<NotificationRecordInfoDialog> {
  @override
  Widget build(BuildContext context) {
    final record = context.watch<UserNotificationRecordToDisplay>().value;
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () { // TODO: реализовать передачу в модельку
                context
                    .read<NotificationService>()
                    .showNotificationWithActions();
              },
              icon: const Icon(Icons.notification_add),
            ),
          ],
        ),
        body: Card(
          child: Text(record.text ?? ""),
        ),
      ),
    );
  }
}
