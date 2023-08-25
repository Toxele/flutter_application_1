// ignore_for_file: prefer_final_locals, file_names, cast_nullable_to_non_nullable, unused_field

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../data/json_loader.dart';
import 'model/user_notification_record.dart';
import 'user_data_service.dart';

base class UserNotifyDataService
    extends RecordsNotifier<List<UserNotificationRecord>> {
  UserNotifyDataService({required super.serviceLoader});
  List<UserNotificationRecord> _records = [];
  UnmodifiableListView<UserNotificationRecord> get records =>
      UnmodifiableListView(_records);
  @override
  String get _fileName => '\\notification_records.json';

  @override
  Future<List<UserNotificationRecord>> _serializeData(String data) async {
    final recordList = <UserNotificationRecord>[];
    for (final record in jsonDecode(data) as List) {
      recordList
          .add(UserNotificationRecord.fromJson(record as Map<String, dynamic>));
    } 
    recordList.reversed;
    return recordList;
  }

  Future<void> addRecord({
    String text = "",
    required DateTime timeToNotificate,
  }) async {
    final user = UserNotificationRecord(
      text: text,
      timeToNotificate: timeToNotificate,
    );

    if (value case RecordsNotifierData(data: final data)) {
      value = const RecordsNotifierLoading();

      final user = UserNotificationRecord(
          timeToNotificate: timeToNotificate, text: text);

      data.add(user);
      final recordsRaw = data.map((e) => e.toJson()).toList();

   //   _addRecord(recordsRaw); // It don't works
    }
  }
}
