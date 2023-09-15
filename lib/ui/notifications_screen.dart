import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/notifiers/abstract/records_notifier.dart';
import 'package:flutter_application_1/domain/notifiers/events_notification_notifier/event_notification.dart';
import 'package:flutter_application_1/domain/notifiers/events_notification_notifier/events_notification_notifier.dart';
import 'package:flutter_application_1/ui/class_instances.dart';
import 'package:flutter_application_1/ui/shared/notification_record_info_dialog.dart';
import 'package:flutter_application_1/ui/shared/user_notify_input_record.dart';
import 'package:provider/provider.dart';

import '../data/storage_repository.dart';

sealed class HomeState {
  const HomeState();
}

class HomeStateData extends HomeState {
  const HomeStateData(this.data);

  final List<EventNotification> data;
}

class HomeStateLoading extends HomeState {
  const HomeStateLoading();
}

class HomeStateError extends HomeState {
  const HomeStateError(this.message);

  final String message;
}

class HomeStateDataEmpty extends HomeState {
  const HomeStateDataEmpty();
}

class HomeStateNotifier extends ValueNotifier<HomeState> {
  final StorageRepository storage;
  HomeStateNotifier({
    required this.userNotificationRecordsNotifier,
    required this.storage, 
  }) : super(const HomeStateLoading()) {
    load();
  }

  final EventsNotificationNotifier userNotificationRecordsNotifier;

  Future<void> addRecord({
    required String message,
    required DateTime timeToNotificate,
  }) async {
    value = const HomeStateLoading();
    userNotificationRecordsNotifier.saveRecord(
      text: message,
      timeToNotificate: timeToNotificate,
    );
  }

  Future<void> load() async {
    value = switch (userNotificationRecordsNotifier.value) {
      RecordsNotifierData(data: final records) =>
        HomeStateData(records), //  const HomeStateSetUpPrefs(),
      RecordsNotifierLoading() => const HomeStateLoading(),
      RecordsNotifierEmpty() => const HomeStateDataEmpty(),
    };
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<EventsNotificationNotifier>(
          create: (_) => EventsNotificationNotifier(),
        ),
        ChangeNotifierProxyProvider2<EventsNotificationNotifier, StorageRepository,
            HomeStateNotifier>(
          create: (context) => HomeStateNotifier(
            userNotificationRecordsNotifier:
                context.read<EventsNotificationNotifier>(), storage: context.read<StorageRepository>(),
          ),
          update:
              (context, userRecordsNotifier, storage, oldHomeStateNotifier) =>
                  HomeStateNotifier(
            userNotificationRecordsNotifier: userRecordsNotifier,
            storage: storage,
          ),
        ),
      ],
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(),
          floatingActionButton: FloatingActionButton(
            child: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                final recordsNotifier = context.read<HomeStateNotifier>();
                final userStatusNotifier =
                    context.read<EventsNotificationNotifier>();

                showDialog(
                  context: context,
                  builder: (context) {
                    return ChangeNotifierProvider.value(
                      value: userStatusNotifier,
                      child: UserNotifyRecord(
                        onDone: recordsNotifier.addRecord,
                      ),
                    );
                  },
                );
              },
            ),
            onPressed: () {},
          ),
          body: Consumer<HomeStateNotifier>(
            builder: (context, homeStateNotifier, child) {
              final recordsState = homeStateNotifier.value;
              Widget child;
              switch (recordsState) {
                case HomeStateData(data: final records):
                  child = ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: records.length,
                    itemBuilder: (BuildContext context, int position) {
                      return _RowUserRecords(record: records[position]);
                    },
                  );
                case HomeStateLoading():
                  child = const Center(child: CircularProgressIndicator());
                case HomeStateError(message: final message):
                  child = Center(child: Text(message));
                case HomeStateDataEmpty():
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

class _RowUserRecords extends StatelessWidget {
  final EventNotification record;

  const _RowUserRecords({
    required this.record,
  });

  @override
  Widget build(BuildContext context) {
    String currentTime =
        '${record.timeToNotificate.hour}:${record.timeToNotificate.minute}';
    // используем тут этот record
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (context) {
          return ChangeNotifierProvider(
            create: (_) => UserNotificationRecordToDisplay(record),
            child: const NotificationRecordInfoDialog(),
          );
        },
      ),
      child: Card(
        child: Row(
          children: [
            Text(record.text ?? ""),
          ],
        ),
      ),
    );
  }
}
