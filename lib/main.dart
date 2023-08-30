import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/strings.dart' as strings;
import 'package:flutter_application_1/domain/user_status_control_service/user_status_controller.dart';
import 'package:flutter_application_1/ui/graph_screen.dart';
import 'package:flutter_application_1/ui/notifications_screen.dart';
import 'package:flutter_application_1/ui/sceens_to_show_once/set_up_prefs_screen.dart';
import 'package:provider/provider.dart';

import 'data/geolocation_repository.dart';
import 'data/storage_repository.dart';
import 'domain/notification_service/notification_service.dart';
import 'domain/weather/weather_model.dart';
import 'domain/weather/weather_notifier.dart';
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
        Provider<GeolocationService>(
          create: (_) => const GeolocationService(),
        ),
        Provider<WeatherRepository>(
          create: (_) => WeatherRepository(),
        ),
        ChangeNotifierProxyProvider2<GeolocationService, WeatherRepository,
            WeatherNotifier>(
          create: (context) => WeatherNotifier(
            geolocationRepository: context.read<GeolocationService>(),
            weatherRepository: context.read<WeatherRepository>(),
          ),
          update: (_, geolocationRepo, weatherRepository, previousNotifier) =>
              WeatherNotifier(
            geolocationRepository: geolocationRepo,
            weatherRepository: weatherRepository,
          ),
        ),
        Provider<UserStatusNotifier>(
          create: (_) => UserStatusNotifier(storageRepo),
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
