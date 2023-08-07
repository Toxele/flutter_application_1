import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/strings.dart' as strings;
import 'package:flutter_application_1/domain/user_status_control_service/user_status_controller.dart';
import 'package:flutter_application_1/ui/graph_screen.dart';
import 'package:provider/provider.dart';

import 'data/geolocation_repository.dart';
import 'data/storage_repository.dart';
import 'domain/weather/weather_model.dart';
import 'domain/weather/weather_notifier.dart';
import 'ui/home.dart';

Future<void> main() async {
  final storageRepo = StorageRepository();
  await storageRepo.init();

  runApp(
    MultiProvider(
      providers: [
        Provider<StorageRepository>(
          create: (_) => storageRepo,
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
        Provider<UserStatusController>(
          create: (_) => UserStatusController(),
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
    return MaterialApp(
      themeMode: ThemeMode.light, // todo: поиграть с этим
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      title: strings.appTitle,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/graph': (context) => GraphScreen(),
        //'/recordingAdd':(context) => MyDialog(onDone: )
      },
    );
  }
}
