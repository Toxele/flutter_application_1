import 'package:shared_preferences/shared_preferences.dart';

class StorageRepository {
  StorageRepository();

  late final SharedPreferences storage;

  Future<void> init() async => storage = await SharedPreferences.getInstance();
}

class StorageStore {
  StorageStore._();
  static const String minPulseKey = 'minPulseKey';
  static const int minPulseDefaultValue = 80;

  static const String isTimeToStepperKey = 'isTimeToStepperKey';
  static const bool isTimeToStepperDefaultValue = true;

  static const String weigthKey = 'weigthKey';
  static const double weigth = 75.0;
  
  static const String heightKey = 'heightKey';
  static const double height = 175.0;

  static const String isManKey = 'isManKey';
  static const bool isMan = true;
  // todo тут лежат все твои ключи и значения. Далее для примера
  static const String minPulseKey1 = 'minPulseKey';
  static const int minPulseDefaultValue1 = 80;
}
