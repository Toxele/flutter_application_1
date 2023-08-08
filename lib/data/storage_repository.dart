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

  // todo тут лежат все твои ключи и значения. Далее для примера
  static const String minPulseKey1 = 'minPulseKey';
  static const int minPulseDefaultValue1 = 80;
}
