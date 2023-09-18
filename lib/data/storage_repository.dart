import 'package:shared_preferences/shared_preferences.dart';

class StorageRepository {
  StorageRepository();

  late final SharedPreferences _storage;

  Future<void> init() async => _storage = await SharedPreferences.getInstance();

  bool? getBool(String key) => _storage.getBool(key);

  int? getInt(String key) => _storage.getInt(key);

  double? getDouble(String key) => _storage.getDouble(key);

  String? getString(String key) => _storage.getString(key);

  List<String>? getStringList(String key) => _storage.getStringList(key);

  Future<bool> setBool(String key, bool value) async =>
      _storage.setBool(key, value);

  Future<bool> setInt(String key, int value) async =>
      _storage.setInt(key, value);

  Future<bool> setDouble(String key, double value) async =>
      _storage.setDouble(key, value);

  Future<bool> setString(String key, String value) async =>
      _storage.setString(key, value);

  Future<bool> setStringList(String key, List<String> value) async =>
      _storage.setStringList(key, value);

  bool containsKey(String key) => _storage.containsKey(key);

  Future<bool> remove(String key) => _storage.remove(key);

  Future<bool> clear() async => _storage.clear();

  Set<String> getKeys() => _storage.getKeys();
}

class StorageStore {
  const StorageStore._();

  static const String minPulseKey = 'minPulseKey';
  static const int minPulseDefaultValue = 80;

  static const String isTimeToStepperKey = 'isTimeToStepperKey';
  static const bool isTimeToStepperDefaultValue = true;

  static const String isDarkThemeKey = 'isDarkTheme';
  static const bool? isDarkThemeDefaultValue = null;

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
