import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/notifiers/events_notification_notifier/event_notification.dart';
import 'package:flutter_application_1/domain/notifiers/events_notification_notifier/events_notification_notifier.dart';
import 'package:flutter_application_1/domain/services/notification_service/notification_service.dart';
import 'package:provider/provider.dart';

import 'notification_info.dart';
import 'notifications_presenter.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<EventsNotificationNotifier>(
          create: (_) => EventsNotificationNotifier(
            notificationService: context.read<NotificationService>(),
          ),
        ),
        ChangeNotifierProxyProvider<EventsNotificationNotifier,
            NotificationsScreenPresenter>(
          create: (context) => NotificationsScreenPresenter(
            eventsNotificationNotifier:
                context.read<EventsNotificationNotifier>(),
          ),
          update: (context, userRecordsNotifier, oldHomeStateNotifier) =>
              NotificationsScreenPresenter(
            eventsNotificationNotifier: userRecordsNotifier,
          ),
        ),
      ],
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Уведомления'),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.notification_add),
              ),
              IconButton(
                onPressed: () {
                  final notificationService =
                      context.read<NotificationService>();
                  notificationService.showAllPendingNotifications();
                },
                icon: const Icon(Icons.pending_actions),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: 'notification_action',
            child: const Icon(Icons.add),
            onPressed: () {
              final presenter = context.read<NotificationsScreenPresenter>();
              showDialog(
                context: context,
                builder: (context) {
                  return ChangeNotifierProvider.value(
                    value: presenter,
                    child: const EventNotificationInfo(event: null),
                  );
                },
              );
            },
          ),
          body: Consumer<NotificationsScreenPresenter>(
            builder: (context, notificationsScreenState, child) {
              final recordsState = notificationsScreenState.value;
              Widget child;
              switch (recordsState) {
                case NotificationsScreenData(data: final events):
                  child = ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (BuildContext context, int index) {
                      final event = events[index];
                      return NotificationTile(
                        isActive: event.isActive,
                        text: event.text,
                        time: event.time,
                        record: event,
                        onEdit: () {
                          final presenter =
                              context.read<NotificationsScreenPresenter>();
                          showDialog(
                            context: context,
                            builder: (context) {
                              return ChangeNotifierProvider.value(
                                value: presenter,
                                child:
                                    EventNotificationInfo(event: events[index]),
                              );
                            },
                          );
                        },
                        onChangedActive: (bool value) {
                          final presenter =
                              context.read<NotificationsScreenPresenter>();

                          presenter.updateRecord(
                            repeatInterval: event.repeatInterval,
                            text: event.text,
                            time: event.time,
                            isActive: value,
                            oldRecord: event,
                          );
                        },
                      );
                    },
                  );
                case NotificationsScreenLoading():
                  child = const Center(child: CircularProgressIndicator());
                case NotificationsScreenError(message: final message):
                  child = Center(child: Text(message));
                case NotificationsScreenEmpty():
                  child = const Center(
                    child: Text('У вас нет сохранений'),
                  );
              }
              return child;
            },
          ),
        );
      },
    );
  }
}

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.text,
    required this.time,
    required this.isActive,
    required this.onEdit,
    required this.onChangedActive,
    required this.record,
  });

  final String text;
  final EventNotification record;
  final DateTime time;
  final bool isActive;
  final VoidCallback onEdit;
  final void Function(bool) onChangedActive;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(record.uuid),
      confirmDismiss: (direction) => showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Удалить запись?'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Нет'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Да'),
            ),
          ],
        ),
      ),
      onDismissed: (direction) async {
        // todo: выделить в слой презентера или домэин
        await context
            .read<NotificationService>()
            .flutterLocalNotificationsPlugin
            .cancel(record.uuid);
        // ignore: use_build_context_synchronously
        await context.read<EventsNotificationNotifier>().removeRecord(record);
      },
      background: const Align(
        alignment: Alignment.centerLeft,
        child: Icon(Icons.delete),
      ),
      secondaryBackground: const Align(
        alignment: Alignment.centerRight,
        child: Icon(Icons.delete),
      ),
      child: ListTile(
        onTap: onEdit,
        title: Text(text),
        subtitle: Text(time.toString()),
        trailing: Switch(value: isActive, onChanged: onChangedActive),
      ),
    );
  }
}
