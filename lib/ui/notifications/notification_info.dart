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
  DateTime? timeSelected;
  bool isActivate = true;

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
              time: timeSelected ?? DateTime.now(), // todo: пока что костыль
              isActive: true,
            );
          },
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: isCreateMode
                    ? textController
                    : (textController..text = widget.event!.text),
                focusNode: isCreateMode ? (focusNode..requestFocus()) : null,
              ),
            ),
            const Divider(),
            SwitchListTile(
              value: isActivate,
              title: Text(
                isCreateMode
                    ? DateTime.now().toString()
                    : widget.event!.time.toString(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: const Text('Нажмите, чтобы изменить время'),
              onChanged: (value) {
                setState(() {
                  isActivate = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
