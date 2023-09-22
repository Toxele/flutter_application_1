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
  final textController = TextEditingController();

  @override
  void dispose() {
    focusNode.dispose();
    textController.dispose();
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
              onPressed: () {},
              icon: const Icon(Icons.notification_add),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'notification_action',
          child: const Icon(Icons.save),
          onPressed: () {
            final presenter = context.read<NotificationsScreenPresenter>();
            presenter.addRecord(
              text: textController.text,
              time: DateTime.now(),
              isActive: true,
            );
          },
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            controller: isCreateMode
                ? textController
                : (textController..text = widget.event!.text),
            focusNode: isCreateMode ? (focusNode..requestFocus()) : null,
          ),
        ),
      ),
    );
  }
}
