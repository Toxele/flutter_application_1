import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/notifiers/events_notification_notifier/event_notification.dart';
import 'package:flutter_application_1/ui/notifications/notifications_presenter.dart';
import 'package:provider/provider.dart';

class EventNotificationInfo extends StatefulWidget {
  const EventNotificationInfo({super.key, required this.event});

  final EventNotification? event;

  @override
  State<EventNotificationInfo> createState() => _EventNotificationInfoState();
}

class _EventNotificationInfoState extends State<EventNotificationInfo> {
  final focusNode = FocusNode();

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCreateMode = widget.event == null;

    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Создание оповещения'),
          actions: [
            IconButton(
              onPressed: () {
                // TODO: реализовать передачу в модельку
                final presenter = context.read<NotificationsScreenPresenter>();
                // TODO  : поменять липовый текст и время на нужное
                presenter.addRecord(
                    text: 'text', time: DateTime.now() /*Time */);
              },
              icon: const Icon(Icons.notification_add),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            focusNode: isCreateMode ? (focusNode..requestFocus()) : null,
          ),
        ),
      ),
    );
  }
}

//Card(
//           child: Text(event?.text ?? ""),
//         )
