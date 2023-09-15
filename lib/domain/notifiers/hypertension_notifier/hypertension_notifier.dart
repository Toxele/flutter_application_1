import 'dart:convert';

import 'package:flutter_application_1/data/storage_repository.dart';

import '../abstract/records_notifier.dart';
import '../weather_notifier/weather.dart';
import 'hypertension_model.dart';

base class HypertensionNotifier
    extends RecordsNotifier<List<HypertensionModel>> {
  HypertensionNotifier({
    required this.storageRepo,
  });

  @override
  String get fileName => '\\hypertension_data.json';

  final StorageRepository storageRepo;

  @override
  Future<List<HypertensionModel>> serializeData(String data) async {
    final recordList = <HypertensionModel>[];
    for (final record in jsonDecode(data) as List) {
      recordList
          .add(HypertensionModel.fromJson(record as Map<String, dynamic>));
    }
    
    return recordList.reversed.toList();
  }

  Future<void> saveRecord({
    int sys = 120,
    int dia = 80,
    int pulse = 75,
    required Weather weather,
  }) async {
    // todo еЩЁ подумать здесь над логикой

    var records = <HypertensionModel>[];

    if (value case RecordsNotifierData(data: final data)) {
      value = const RecordsNotifierLoading();
      records = [...data];
    }
      value = const RecordsNotifierLoading(); 

    final user = HypertensionModel(
      sys: sys,
      dia: dia,
      pulse: pulse,
      weather: weather,
      timeOfRecord: DateTime.now(),
    );

    records.add(user);
    final recordsRaw = records.map((e) => e.toJson()).toList();

    addRecord(recordsRaw);
    load();
  }

  /// todo: подумать над логикой этого всего
  Future<bool> acceptRecord(int sys, int dia, int pulse) async {
    /// todo: это всё исправить на нормальные ключи и значения по умолчанию.
    storageRepo.storage.setInt('Dia Min', 70); // это временно
    storageRepo.storage.setInt('Dia Max', 140);
    storageRepo.storage.setInt('Sys Min', 90);
    storageRepo.storage.setInt('Sys Max', 170);
    storageRepo.storage.setInt('Pulse Min', 60);
    storageRepo.storage.setInt('Pulse Max', 130);
    int normalSysMin = storageRepo.storage.getInt('Sys Min') ?? 0;
    int normalSysMax = storageRepo.storage.getInt('Sys Max') ?? 0;
    int normalDiaMin = storageRepo.storage.getInt('Dia Min') ?? 0;
    int normalDiaMax = storageRepo.storage.getInt('Dia Max') ?? 0;
    int normalPulseMin = storageRepo.storage.getInt('Pulse Min') ?? 0;
    int normalPulseMax = storageRepo.storage.getInt('Pulse Max') ?? 0;
    return normalSysMin < sys &&
        sys < normalSysMax &&
        normalDiaMin < dia &&
        dia < normalDiaMax &&
        normalPulseMin < pulse &&
        pulse < normalPulseMax;
  }
}
