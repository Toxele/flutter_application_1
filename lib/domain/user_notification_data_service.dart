// ignore_for_file: prefer_final_locals, file_names, cast_nullable_to_non_nullable, unused_field

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../data/json_loader.dart';
import 'model/user_notification_record.dart';

class UserNotifyDataService {
  UserNotifyDataService(this._serviceLoader);

  final JsonLoader _serviceLoader;

  List<UserNotificationRecord> _records = [];
  UnmodifiableListView<UserNotificationRecord> get records =>
      UnmodifiableListView(_records);

  static const String _fileName = '\\notification_records.json';

  Future<String> get _getPath async =>
      '${(await getApplicationDocumentsDirectory()).path}$_fileName';

  Future<List<UserNotificationRecord>> loadRecords() async {
    final path = await _getPath;
    final file = File(path);
    if (await file.exists()) {
      String rawRecordsList = await file.readAsString();

      final recordList = <UserNotificationRecord>[];
      for (final record in jsonDecode(rawRecordsList) as List) {
        recordList.add(UserNotificationRecord.fromJson(record as Map<String, dynamic>));
      }
      recordList.reversed;
      _records = recordList;

      return recordList;
    }
    return [];
  }

  Future addRecord({
    String text = "",
    required DateTime timeToNotificate,
  }) async {
    final user = UserNotificationRecord(
      text: text,
      timeToNotificate: timeToNotificate,
    );

    _records.add(user);
    final recordsRaw = _records.map((e) => e.toJson()).toList();
    final path = await _getPath;
    final file = File(path);
    if (!await file.exists()) {
      await file.create();
    }
    String encoded = json.encode(recordsRaw); // преобразуем в json
    await file.writeAsString(encoded); // запись в файл
    return true;
  }
}