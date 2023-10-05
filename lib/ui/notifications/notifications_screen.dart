import 'package:flutter/material.dart';
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
          appBar: AppBar(title: const Text('Уведомления')),
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
                        onEdit: () {
                          final presenter =
                              context.read<NotificationsScreenPresenter>();
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
  });

  final String text;
  final DateTime time;
  final bool isActive;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: IconButton(
        onPressed: onEdit,
        icon: const Icon(Icons.edit),
      ),
      title: Text(text),
      subtitle: Text(time.toString()),
      value: isActive,
      onChanged: (value) {},
    );

    // String currentTime =
    //     '${record.timeToNotificate.hour}:${record.timeToNotificate.minute}';
    //
    // // используем тут этот record
    // return GestureDetector(
    //   onTap: () => showDialog(
    //     context: context,
    //     builder: (context) {
    //       return ChangeNotifierProvider(
    //         create: (_) => UserNotificationRecordToDisplay(record),
    //         child: const NotificationRecordInfoDialog(),
    //       );
    //     },
    //   ),
    //   child: Card(
    //     child: Row(
    //       children: [
    //         Text(record.text ?? ""),
    //       ],
    //     ),
    //   ),
    // );
  }
}
