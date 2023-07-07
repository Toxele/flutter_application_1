// ignore_for_file: prefer_final_locals, file_names, cast_nullable_to_non_nullable

import 'dart:async';
import 'dart:convert';
//import 'dart:ffi';
import 'dart:io';
import 'package:json_annotation/json_annotation.dart';
import 'package:path_provider/path_provider.dart';

@JsonSerializable(explicitToJson: true)
class UserRecord {
  // поля значений, которые вводят пользователь, возможно сюда добавится дата и время
  int? sys;
  int? dia;
  int? pulse;
// DateTime timeOfRecord;
  UserRecord(this.sys, this.dia, this.pulse);
  factory UserRecord.fromJson(Map<String, dynamic> jsonMap) {
    return UserRecord(
      jsonMap["sys"] as int,
      jsonMap["dia"] as int,
      jsonMap["pulse"] as int,
      //  jsonMap["time"] as DateTime,
    );
  }

  Map toJson() => {"sys": sys, "pulse": pulse, "dia": dia};
}

class DataService {
  DataService(this._serviceLoader);
  final DataServiceLoader _serviceLoader;
  List<UserRecord> _records = [];
  List<UserRecord> get records => _records;
  static const String _fileName = '\\records.json';

  Future<String> get _getPath async =>
      '${(await getApplicationDocumentsDirectory()).path}$_fileName';

  Future<List<UserRecord>> loadRecords() async {
   String rawRecordsList = await _serviceLoader.loadRecords(path: await _getPath);
   final recordList = <UserRecord>[];
   for(final record in jsonDecode(rawRecordsList) as List)
   {
    recordList.add(UserRecord.fromJson(record as Map<String, dynamic>));
   }
   _records = recordList;
   return recordList;
  }

  Future addRecord(int sys, int dia, int pulse) async {
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

class DataServiceLoader {
  DataServiceLoader();
  Future<String> loadRecords({required String path}) async {
    final file = File(path);
    if (await file.exists()) {
      String rawRecordsList = await file.readAsString();
      return rawRecordsList;
    }
    return '';
  }
}
