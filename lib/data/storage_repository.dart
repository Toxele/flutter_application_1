import 'package:shared_preferences/shared_preferences.dart';

/// todo исправить на экземпляр SharedPreferences, который будет лежать в провайдере
class StorageRepository {
  StorageRepository();

  late final SharedPreferences storage;

  Future<void> init() async => storage = await SharedPreferences.getInstance();
}

class StorageStore {
  const StorageStore._();

  static const String minPulseKey = 'minPulseKey';
  static const int minPulseDefaultValue = 80;

  static const String isTimeToStepperKey = 'isTimeToStepperKey';
  static const bool isTimeToStepperDefaultValue = true;

  // todo делать обязательную приписку "DefaultValue"
  static const String weightKey = 'weigthKey';
  static const double weight = 75.0;

  static const String heightKey = 'heightKey';
  static const double height = 175.0;

  static const String isManKey = 'isManKey';
  static const bool isMan = true;

  static const String minPulseKey1 = 'minPulseKey';
  static const int minPulseDefaultValue1 = 80;
}
