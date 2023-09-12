import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/class_instances.dart';
import 'package:flutter_application_1/domain/model/user_notification_record.dart';
import 'package:flutter_application_1/domain/user_notification_data_service.dart';
import 'package:flutter_application_1/ui/shared/notification_record_info_dialog.dart';
import 'package:flutter_application_1/ui/shared/user_notify_input_record.dart';
import 'package:provider/provider.dart';

import '../data/storage_repository.dart';
import '../domain/records_notifier.dart';

sealed class HomeState {
  const HomeState();
}

class HomeStateData extends HomeState {
  const HomeStateData(this.data);

  final List<UserNotificationRecord> data;
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
  StorageRepository? storage;
  HomeStateNotifier({
    required this.userNotificationRecordsNotifier,
    this.storage, // todo: внедрить через провайдера
  }) : super(const HomeStateLoading()) {
    load();
  }

  final UserNotifyDataService userNotificationRecordsNotifier;

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
    // todo: я внедрил это здесь. Но если тебе нужна UserDataService в другом месте,
    //  то здесь ты её можешь получить через `context.watch<UserDataService>()`
    // и тогда ты автоматически избавишься от Proxy
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserNotifyDataService>(
          create: (_) => UserNotifyDataService(
              storageRepo: context.read<StorageRepository>()),
        ),
        ChangeNotifierProxyProvider<UserNotifyDataService, HomeStateNotifier>(
          create: (context) => HomeStateNotifier(
            userNotificationRecordsNotifier:
                context.read<UserNotifyDataService>(),
          ),
          update: (_, userRecordsNotifier, __) => HomeStateNotifier(
              userNotificationRecordsNotifier: userRecordsNotifier),
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
                    context.read<UserNotifyDataService>();

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
  final UserNotificationRecord record;

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
