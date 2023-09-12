import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/strings.dart' as strings;
import 'package:flutter_application_1/ui/graph_screen.dart';
import 'package:flutter_application_1/ui/notifications_screen.dart';
import 'package:provider/provider.dart';

import 'data/geolocation_repository.dart';
import 'data/storage_repository.dart';
import 'data/weather_repository.dart';
import 'domain/notification_service/notification_service.dart';
import 'domain/user_records_notifier/user_records_notifier.dart';
import 'domain/weather_notifier/weather_notifier.dart';
import 'ui/home.dart';
import 'ui/settings/settings_screen.dart';
import 'ui/theme_notifier.dart';

Future<void> main() async {
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
        ChangeNotifierProvider<UserRecordsNotifier>(
          create: (_) => UserRecordsNotifier(
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
              storageRepo: context.read<StorageRepository>(),
            );
          },
        ),
      ],
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: context.watch<ThemeModeNotifier>().value,
          theme: ThemeData.light(), // todo: поиграть с этим
          darkTheme: ThemeData.dark(),
          title: strings.appTitle,
          initialRoute: '/',
          routes: {
            '/': (context) => const HomePage(),
            '/graph': (context) => GraphScreen(),
            '/settings': (context) => const SettingsScreen(),
            '/notifications': (context) => const NotificationsScreen(),
            //'/recordingAdd':(context) => MyDialog(onDone: )
          },
        );
      },
    );
  }
}
