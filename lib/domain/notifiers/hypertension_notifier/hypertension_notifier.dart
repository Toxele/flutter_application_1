import 'package:flutter_application_1/data/storage_repository.dart';

import '../abstract/records_notifier.dart';
import '../weather_notifier/weather.dart';
import 'hypertension_model.dart';

base class HypertensionNotifier extends RecordsNotifier<HypertensionModel> {
  HypertensionNotifier({
    required this.storageRepo,
  });

  @override
  String get fileName => 'hypertension_data.json';

  final StorageRepository storageRepo;

  Future<void> saveRecord({
    int sys = 120,
    int dia = 80,
    int pulse = 75,
    required Weather weather, 
  }) async {
    final user = HypertensionModel(
      sys: sys,
      dia: dia,
      pulse: pulse,
      weather: weather,
      timeOfRecord: DateTime.now(),
    );

    await addRecord(user);
  }

  @override
  Map<String, dynamic> deserializeElement(HypertensionModel element) =>
      element.toJson();

  @override
  HypertensionModel serializeElement(Map<String, dynamic> data) =>
      HypertensionModel.fromJson(data);

  /// todo: подумать над логикой этого всего
  Future<bool> acceptRecord(int sys, int dia, int pulse) async {
    /// todo: это всё исправить на нормальные ключи и значения по умолчанию.

    final normalSysMin = storageRepo.getInt(StorageStore.sysMinKey) ??
        StorageStore.defualtSysMinValue;
    final normalSysMax = storageRepo.getInt(StorageStore.sysMaxKey) ??
        StorageStore.defualtSysMaxValue;
    final normalDiaMin = storageRepo.getInt(StorageStore.diaMinKey) ??
        StorageStore.defualtDiaMinValue;
    final normalDiaMax = storageRepo.getInt(StorageStore.diaMaxKey) ??
        StorageStore.defualtDiaMaxValue;
    final int normalPulseMin = storageRepo.getInt(StorageStore.pulseMinKey) ??
        StorageStore.defaultPulseMinValue;
    final int normalPulseMax = storageRepo.getInt(StorageStore.pulseMaxKey) ??
        StorageStore.defaultPulseMaxValue;
    return normalSysMin < sys &&
        sys < normalSysMax &&
        normalDiaMin < dia &&
        dia < normalDiaMax &&
        normalPulseMin < pulse &&
        pulse < normalPulseMax;
  }
}
