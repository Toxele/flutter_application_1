import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/storage_repository.dart';

class ThemeModeNotifier extends ValueNotifier<ThemeMode> {
  ThemeModeNotifier({
    required StorageRepository storage,
  })  : _storage = storage,
        super(ThemeMode.system) {
    final bool? isDark = _storage.getBool(StorageStore.isDarkThemeKey);

    value = switch (isDark) {
      null => ThemeMode.system,
      true => ThemeMode.dark,
      false => ThemeMode.light,
    };
  }

  final StorageRepository _storage;

  Future<void> setTheme(ThemeMode themeMode) async {
    value = themeMode;

    final isDark = switch (themeMode) {
      ThemeMode.system => null,
      ThemeMode.dark => true,
      ThemeMode.light => false,
    };

    if (isDark == null) {
      await _storage.remove(StorageStore.isDarkThemeKey);
    } else {
      await _storage.setBool(StorageStore.isDarkThemeKey, isDark);
    }
  }
}
