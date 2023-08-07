import 'package:shared_preferences/shared_preferences.dart';

class StorageRepository {
  StorageRepository();

  late final SharedPreferences _prefs;

  SharedPreferences get storage => _prefs;

  Future<void> init() async => _prefs = await SharedPreferences.getInstance();
}

class StorageStore {
  StorageStore._();
  String minPulseKey = 'minPulseKey';
  int minPulseDefaultValue = 80;

  // todo тут лежат все твои ключи и значения. Далее для примера
  String minPulseKey1 = 'minPulseKey';
  int minPulseDefaultValue1 = 80;
}
