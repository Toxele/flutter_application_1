// ignore_for_file: prefer_final_locals, file_names, cast_nullable_to_non_nullable, unused_field

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_application_1/data/storage_repository.dart';
import 'package:path_provider/path_provider.dart';
import '../data/json_loader.dart';
import 'model/user_notification_record.dart';
import 'records_notifier.dart';

base class UserNotifyDataService
    extends RecordsNotifier<List<UserNotificationRecord>> {
  UserNotifyDataService({
    required super.serviceLoader,
    required StorageRepository storageRepo,
  });
  List<UserNotificationRecord> _records = [];
  UnmodifiableListView<UserNotificationRecord> get records =>
      UnmodifiableListView(_records);

  @override
  String get fileName => '\\notification_records.json';

  @override
  Future<List<UserNotificationRecord>> serializeData(String data) async {
    final recordList = <UserNotificationRecord>[];
    for (final record in jsonDecode(data) as List) {
      recordList
          .add(UserNotificationRecord.fromJson(record as Map<String, dynamic>));
    }
    return recordList.reversed.toList();
  }

  Future<void> saveRecord({
    String text = "",
    required DateTime timeToNotificate,
  }) async {
    if (value case RecordsNotifierData(data: final data)) {
      // TODO : пофиксить if - value принимает состояние RecordsNotifierEmpty, в user_records_notifier.dart скорее всего та же проблема
      value = const RecordsNotifierLoading();

      final user = UserNotificationRecord(
          timeToNotificate: timeToNotificate, text: text);

      data.add(user);
      final recordsRaw = data.map((e) => e.toJson()).toList();
      addRecord(recordsRaw);
      load();
    }
  }
}
