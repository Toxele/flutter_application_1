import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/notifiers/events_notification_notifier/event_notification.dart';
import 'package:flutter_application_1/ui/notifications/notifications_presenter.dart';
import 'package:provider/provider.dart';

class EventNotificationInfo extends StatelessWidget {
  const EventNotificationInfo({super.key});
  @override
  Widget build(BuildContext context) {
    final event = context.watch<EventNotification>();

    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                // TODO: реализовать передачу в модельку
                final presenter = context.read<NotificationsScreenPresenter>();

                presenter.addRecord(text: text, time: time);
              },
              icon: const Icon(Icons.notification_add),
            ),
          ],
        ),
        body: Card(
          child: Text(event.text ?? ""),
        ),
      ),
    );
  }
}
