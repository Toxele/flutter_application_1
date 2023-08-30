import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/default_values.dart'
    as defaultValues;
import 'package:flutter_application_1/data/storage_repository.dart';

import '../model/user_record.dart';

class UserStatusNotifier {
  UserStatusNotifier(this.storageRepo);

  final StorageRepository storageRepo;
  late List<UserRecord> records;
  Future<bool> acceptRecord(int sys, int dia, int pulse) async {
    /// todo: это всё исправить на нормальные ключи и значения по умолчанию.
    storageRepo.storage.setInt('Dia Min', 70); // это временно
    storageRepo.storage.setInt('Dia Max', 140);
    storageRepo.storage.setInt('Sys Min', 90);
    storageRepo.storage.setInt('Sys Max', 170);
    storageRepo.storage.setInt('Pulse Min', 60);
    storageRepo.storage.setInt('Pulse Max', 130);
    int normalSysMin =
        storageRepo.storage.getInt('Sys Min') ?? defaultValues.defaultZero;
    int normalSysMax =
        storageRepo.storage.getInt('Sys Max') ?? defaultValues.defaultZero;
    int normalDiaMin =
        storageRepo.storage.getInt('Dia Min') ?? defaultValues.defaultZero;
    int normalDiaMax =
        storageRepo.storage.getInt('Dia Max') ?? defaultValues.defaultZero;
    int normalPulseMin =
        storageRepo.storage.getInt('Pulse Min') ?? defaultValues.defaultZero;
    int normalPulseMax =
        storageRepo.storage.getInt('Pulse Max') ?? defaultValues.defaultZero;
    return normalSysMin < sys &&
        sys < normalSysMax &&
        normalDiaMin < dia &&
        dia < normalDiaMax &&
        normalPulseMin < pulse &&
        pulse < normalPulseMax;
  }
}
