// ignore_for_file: prefer_final_locals, file_names, cast_nullable_to_non_nullable, unused_field

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/domain/weather/weather.dart';
import 'package:path_provider/path_provider.dart';
import '../data/json_loader.dart';
import 'model/user_record.dart';

sealed class RecordsNotifierState<T> {
  const RecordsNotifierState();
}

class RecordsNotifierData<T> extends RecordsNotifierState<T> {
  const RecordsNotifierData(this.data);

  final T data;
}

class RecordsNotifierLoading<T> extends RecordsNotifierState<T> {
  const RecordsNotifierLoading();
}

abstract base class RecordsNotifier<T>
    extends ValueNotifier<RecordsNotifierState<T>> {
  RecordsNotifier({required JsonLoader serviceLoader})
      : _serviceLoader = serviceLoader,
        super(const RecordsNotifierLoading());

  // todo: реализовать
  final JsonLoader _serviceLoader;

  String get _fileName;

  // todo: воспользоваться пакетом https://pub.dev/packages/path
  Future<String> get _getPath async =>
      '${(await getApplicationDocumentsDirectory()).path}$_fileName';

  Future<void> load() async {
    final path = await _getPath;
    final file = File(path);
    if (await file.exists()) {
      String rawRecordsList = await file.readAsString();

      value = RecordsNotifierData(await _serializeData(rawRecordsList));
    }

    // todo: value = пустой список
  }

  Future<void> _addRecord(Object? data) async {
    final path = await _getPath;
    final file = File(path);

    if (!await file.exists()) {
      await file.create();
    }
    String encoded = json.encode(data);

    await file.writeAsString(encoded);
  }

  Future<T> _serializeData(String data);
}

base class UserDataService extends RecordsNotifier<List<UserRecord>> {
  UserDataService({required super.serviceLoader});
  List<UserRecord> _records = [];
  UnmodifiableListView<UserRecord> get records =>
      UnmodifiableListView(_records);
  @override
  String get _fileName => '\\records.json';

  @override
  Future<List<UserRecord>> _serializeData(String data) async {
    final recordList = <UserRecord>[];
    for (final record in jsonDecode(data) as List) {
      recordList.add(UserRecord.fromJson(record as Map<String, dynamic>));
    }
    recordList.reversed;
    return recordList;
  }

  Future<void> addRecord({
    int sys = 120,
    int dia = 80,
    int pulse = 75,
    required Weather weather,
  }) async {
    if (value case RecordsNotifierData(data: final data)) {
      value = const RecordsNotifierLoading();

      final user = UserRecord(
        sys: sys,
        dia: dia,
        pulse: pulse,
        weather: weather,
        timeOfRecord: DateTime.now(),
      );

      data.add(user);
      final recordsRaw = data.map((e) => e.toJson()).toList();

      _addRecord(recordsRaw);
    }
  }
}
