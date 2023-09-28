// ignore_for_file: prefer_final_locals, file_names, cast_nullable_to_non_nullable, unused_field

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
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

/// Класс-уведомитель отвечает за получение и хранение данных в [List] типа [T]
/// с диска.
///
/// По умолчанию используется путь "документы".
abstract base class RecordsNotifier<T extends Object>
    extends ValueNotifier<RecordsNotifierState<List<T>>> {
  RecordsNotifier() : super(const RecordsNotifierLoading()) {
    load();
  }

  String get fileName;

  Future<String> get _getPath async =>
      p.join((await getApplicationDocumentsDirectory()).path, fileName);

  List<T> _state = <T>[];

  @protected
  Future<void> load() async {
    final path = await _getPath;
    final file = File(path);
    if (await file.exists()) {
      String rawRecordsList = await file.readAsString();
      if (rawRecordsList.isNotEmpty) {
        _state = _serialize(rawRecordsList);
        value = RecordsNotifierData(_state);
      } else {
        value = const RecordsNotifierEmpty();
      }
    } else {
      value = const RecordsNotifierEmpty();
    }
  }

  @protected
  Future<void> addRecord(T element) async {
    value = const RecordsNotifierLoading();

    _state.add(element);

    String encoded = json.encode(_deserialize(_state));
    _writeData(encoded);

    value = RecordsNotifierData(_state);
  }

  @protected
  Future<void> updateRecord(T oldElement, T newElement) async {
    value = const RecordsNotifierLoading();

    // мы считаем, что в списке нет похожих элементов и они иммутабельны
    final index = _state.indexOf(oldElement);
    _state[index] = newElement;

    String encoded = json.encode(_deserialize(_state));
    _writeData(encoded);

    value = RecordsNotifierData(_state);
  }

  @protected
  Future<void> removeRecord(T element) async {
    value = const RecordsNotifierLoading();

    // мы считаем, что в списке нет похожих элементов и они иммутабельны
    _state.removeAt(_state.indexOf(element));

    String encoded = json.encode(_deserialize(_state));
    _writeData(encoded);

    value =
        _state.isEmpty ? RecordsNotifierEmpty() : RecordsNotifierData(_state);
  }

  Future<void> _writeData(String data) async {
    final path = await _getPath;
    final file = File(path);
    if (!await file.exists()) {
      await file.create();
    }

    await file.writeAsString(data);
  }

  /// Хранимые файлы должны преобразовываться в модельки.
  /// Реализуйте данный метод, чтобы указать способ сериализации элемента.
  T serializeElement(Map<String, dynamic> dataElement);

  List<T> _serialize(String data) => [
        for (final element in data as List)
          serializeElement(element as Map<String, dynamic>),
      ];

  /// Реализуйте данный метод, чтобы указать способ десериализации элемента.
  Map<String, dynamic> deserializeElement(T element);

  String _deserialize(List<T> elements) =>
      json.encode(elements.map((e) => deserializeElement(e)).toList());
}
