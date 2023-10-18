import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/graph_screen.dart';
import 'package:flutter_application_1/ui/notifications/notifications_screen.dart';
import 'package:loggy/loggy.dart';
import 'package:provider/provider.dart';

import 'application/app_const.dart';
import 'application/theme_mode_notifier.dart';
import 'data/geolocation_repository.dart';
import 'data/storage_repository.dart';
import 'data/weather_repository.dart';
import 'domain/notifiers/hypertension_notifier/hypertension_notifier.dart';
import 'domain/notifiers/weather_notifier/weather_notifier.dart';
import 'domain/services/notification_service/notification_service.dart';
import 'ui/home/home.dart';
import 'ui/settings/settings_screen.dart';

Future<void> main() async {
  Loggy.initLoggy(
    logPrinter: const PrettyPrinter(),
  );
  WidgetsFlutterBinding.ensureInitialized();
  final storageRepo = StorageRepository();
  await storageRepo.init();

  final notificationService = NotificationService();
  await notificationService.init();

  runApp(
    MultiProvider(
      providers: [
        Provider<StorageRepository>(
          create: (_) => storageRepo,
        ),
        Provider<NotificationService>(
          create: (_) => notificationService,
        ),
        Provider<GeolocationRepository>(
          create: (_) => const GeolocationRepository(),
        ),
        Provider<WeatherRepository>(
          create: (_) => WeatherRepository(),
        ),
        ChangeNotifierProvider<HypertensionNotifier>(
          create: (_) => HypertensionNotifier(
            storageRepo: storageRepo,
          ),
        ),
        ChangeNotifierProxyProvider2<GeolocationRepository, WeatherRepository,
            WeatherNotifier>(
          create: (context) => WeatherNotifier(
            geolocationRepository: context.read<GeolocationRepository>(),
            weatherRepository: context.read<WeatherRepository>(),
          ),
          update: (_, geolocationRepo, weatherRepository, previousNotifier) =>
              WeatherNotifier(
            geolocationRepository: geolocationRepo,
            weatherRepository: weatherRepository,
          ),
        ),
      ],
      child: const GHFlutterApp(),
    ),
  );
}

class GHFlutterApp extends StatelessWidget {
  const GHFlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeModeNotifier>(
          create: (context) {
            return ThemeModeNotifier(
              storage: context.read<StorageRepository>(),
            );
          },
        ),
      ],
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: context.watch<ThemeModeNotifier>().value,
        theme: ThemeData.light(), // todo: поиграть с этим
        darkTheme: ThemeData.dark(),
        title: AppConst.appTitle,
        builder: (context, child) {
          final scrollConfiguration = ScrollConfiguration.of(context);
          return ScrollConfiguration(
            behavior: scrollConfiguration.copyWith(
              dragDevices: {
                ...scrollConfiguration.dragDevices,
                PointerDeviceKind.mouse,
              },
            ),
            child: child!,
          );
        },
        initialRoute: '/',
        routes: {
          '/': (context) => const HomePage(),
          '/graph': (context) => GraphScreen(),
          '/settings': (context) => const SettingsScreen(),
          '/notifications': (context) => const NotificationsScreen(),
          //'/recordingAdd':(context) => MyDialog(onDone: )
        },
      ),
    );
  }
}
