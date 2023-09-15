// ignore_for_file: prefer_final_locals, file_names, cast_nullable_to_non_nullable, unused_field

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

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

class RecordsNotifierEmpty<T> extends RecordsNotifierState<T> {
  const RecordsNotifierEmpty();
}

abstract base class RecordsNotifier<T>
    extends ValueNotifier<RecordsNotifierState<T>> {
  RecordsNotifier() : super(const RecordsNotifierLoading()) {
    load();
  }

  String get fileName;

  // todo: воспользоваться пакетом https://pub.dev/packages/path
  Future<String> get _getPath async =>
      '${(await getApplicationDocumentsDirectory()).path}$fileName';

  @protected
  Future<void> load() async {
    final path = await _getPath;
    final file = File(path);

    if (await file.exists()) {
      
      String rawRecordsList = await file.readAsString();
      if (rawRecordsList.isNotEmpty) {
        value = RecordsNotifierData(await serializeData(rawRecordsList));
      } else {
        value = const RecordsNotifierEmpty();
      }
    } else {
      value = const RecordsNotifierEmpty();
    }
    // todo: value = пустой список
  }

  @protected
  Future<void> addRecord(Object? data) async {
    final path = await _getPath;
    final file = File(path);

    if (!await file.exists()) {
      await file.create();
    }
    String encoded = json.encode(data);

    await file.writeAsString(encoded);
  }

  Future<T> serializeData(String data);
}
