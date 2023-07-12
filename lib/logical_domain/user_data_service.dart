// ignore_for_file: prefer_final_locals, file_names, cast_nullable_to_non_nullable, unused_field

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../data/json_loader.dart';
import 'user_record.dart';

class DataService {
  DataService(this._serviceLoader);
  final JsonLoader _serviceLoader;
  List<UserRecord> _records = [];
  List<UserRecord> get records => _records;
  static const String _fileName = '\\records.json';

  Future<String> get _getPath async =>
      '${(await getApplicationDocumentsDirectory()).path}$_fileName';

  Future<List<UserRecord>> loadRecords() async {
    final path = await _getPath;
    final file = File(path);
    if (await file.exists()) {
      String rawRecordsList = await file.readAsString();

      final recordList = <UserRecord>[];
      for (final record in jsonDecode(rawRecordsList) as List) {
        recordList.add(UserRecord.fromJson(record as Map<String, dynamic>));
      }
      _records = recordList;
      return recordList;
    }
    return [];
  }

  Future addRecord({int sys = 120, int dia = 80, int pulse = 75}) async {
    final user = UserRecord(sys, dia, pulse);

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
