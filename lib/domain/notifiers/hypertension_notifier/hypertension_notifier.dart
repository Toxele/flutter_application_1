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
    storageRepo.setInt('Dia Min', 70); // это временно
    storageRepo.setInt('Dia Max', 140);
    storageRepo.setInt('Sys Min', 90);
    storageRepo.setInt('Sys Max', 170);
    storageRepo.setInt('Pulse Min', 60);
    storageRepo.setInt('Pulse Max', 130);
    int normalSysMin = storageRepo.getInt('Sys Min') ?? 0;
    int normalSysMax = storageRepo.getInt('Sys Max') ?? 0;
    int normalDiaMin = storageRepo.getInt('Dia Min') ?? 0;
    int normalDiaMax = storageRepo.getInt('Dia Max') ?? 0;
    int normalPulseMin = storageRepo.getInt('Pulse Min') ?? 0;
    int normalPulseMax = storageRepo.getInt('Pulse Max') ?? 0;
    return normalSysMin < sys &&
        sys < normalSysMax &&
        normalDiaMin < dia &&
        dia < normalDiaMax &&
        normalPulseMin < pulse &&
        pulse < normalPulseMax;
  }
}
