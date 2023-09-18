import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/storage_repository.dart';

class ThemeModeNotifier extends ValueNotifier<ThemeMode> {
  ThemeModeNotifier({
    required this.storageRepo,
  }) : super(ThemeMode.system) {
    final bool? isDark = storageRepo.getBool('isDarkTheme');

    value = isDark == null
        ? ThemeMode.system
        : (isDark ? ThemeMode.dark : ThemeMode.light);
  }

  final StorageRepository storageRepo;

  void setTheme(ThemeMode themeMode) {
    value = themeMode;

    final isDark = themeMode == ThemeMode.dark;
    storageRepo.setBool('isDarkTheme', isDark);
  }
}
