import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/class_instances.dart';
import 'package:flutter_application_1/data/json_loader.dart';
import 'package:flutter_application_1/domain/model/user_notification_record.dart';
import 'package:flutter_application_1/domain/model/user_record.dart';
import 'package:flutter_application_1/domain/user_notification_data_service.dart';
import 'package:flutter_application_1/ui/sceens_to_show_once/set_up_prefs_screen.dart';
import 'package:flutter_application_1/ui/shared/input_record_dialog.dart';
import 'package:flutter_application_1/ui/shared/record_info_dialog.dart';
import 'package:flutter_application_1/ui/shared/user_notify_input_record.dart';
import 'package:provider/provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  UserNotifyDataService? dataService;
  List<UserNotificationRecord>? records;
  void getRecords() async {
    records = await dataService?.loadRecords();
  }

  @override
  void initState() {
    super.initState();
    dataService = UserNotifyDataService(const JsonLoader());
    records = [];
    getRecords();
  }

  void onDone({required String text, required DateTime time}) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: records?.length,
        itemBuilder: (BuildContext context, int position) {
          return _RowUserRecords(record: records![position]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            //    final recordsNotifier = context.read<RecordsNotifier>();
            //     final userStatusNotifier = context.read<UserStatusNotifier>();

            showDialog(
              context: context,
              builder: (context) {
                return UserNotifyRecord(onDone: onDone); // help
              },
            );
          },
        ),
        onPressed: () {},
      ),
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
            create: (_) => UserRecordToDisplay(UserRecord(
                timeOfRecord:
                    record.timeToNotificate)), // TODO: replace UserRecord
            child: const RecordInfoDialog(),
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
